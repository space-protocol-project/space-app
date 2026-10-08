import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../src/chat_controller.dart';
import '../src/core.dart';
import '../src/generated/space/v1/space.pb.dart';
import '../src/recovery_card.dart';
import 'components.dart';

class RecoveryPanel extends StatefulWidget {
  const RecoveryPanel({super.key, required this.controller});
  final ChatController controller;
  @override
  State<RecoveryPanel> createState() => _RecoveryPanelState();
}

class _RecoveryPanelState extends State<RecoveryPanel> {
  bool pending = false;
  String message = '';
  List<DeviceGrant> devices = [];
  static const files = [
    XTypeGroup(label: 'Карточка Space', extensions: ['json']),
  ];
  Future<void> run(Future<void> Function() action) async {
    if (pending || widget.controller.busy) return;
    setState(() {
      pending = true;
      message = '';
    });
    try {
      await action();
    } catch (error) {
      if (mounted) {
        setState(
          () => message = error is FormatException ? error.message.toString() : 'Операция не завершена. Проверьте доступ, карточку и соединение.',
        );
      }
    } finally {
      if (mounted) setState(() => pending = false);
    }
  }

  Future<bool> confirm(String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Подтвердите действие'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Подтвердить'),
            ),
          ],
        ),
      ) ??
      false;
  Future<String?> password(bool creating) async {
    final first = TextEditingController(), second = TextEditingController();
    String? error;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(creating ? 'Защитите карточку' : 'Открыть карточку'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Пароль шифрует файл только на этом устройстве. Сервер его не получает. Используйте несколько случайных слов и храните пароль отдельно.',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: first,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль (от 12 символов)',
                  ),
                ),
                if (creating) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: second,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Повторите пароль',
                    ),
                  ),
                ],
                if (error != null) Text(error!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                if (first.text.length < 12 ||
                    (creating && first.text != second.text)) {
                  update(
                    () => error =
                        'Пароль слишком короткий или значения не совпадают.',
                  );
                  return;
                }
                Navigator.pop(context, first.text);
              },
              child: Text(creating ? 'Зашифровать' : 'Открыть'),
            ),
          ],
        ),
      ),
    );
    first.dispose();
    second.dispose();
    return result;
  }

  Future<void> export() async {
    final manager = widget.controller.deviceManagement;
    if (manager == null) return;
    final pass = await password(true);
    if (pass == null) return;
    final packet = await compute(sealCardInWorker, [
      await manager.recoveryPayload(),
      pass,
    ]);
    final destination = await getSaveLocation(
      suggestedName: 'space-recovery.json',
      acceptedTypeGroups: files,
    );
    if (destination == null) return;
    await XFile.fromData(
      Uint8List.fromList(utf8.encode(packet)),
      mimeType: 'application/json',
      name: 'space-recovery.json',
    ).saveTo(destination.path);
    if (mounted) {
      setState(
        () => message = 'Карточка сохранена. Проверьте её восстановлением на отдельном устройстве; файл и пароль храните раздельно.',
      );
    }
  }

  Future<void> restore() async {
    final file = await openFile(acceptedTypeGroups: files);
    if (file == null) return;
    if (await file.length() > 16384) {
      throw const FormatException('Карточка слишком большая');
    }
    final pass = await password(false);
    if (pass == null) return;
    final payload = await compute(openCardInWorker, [
      await file.readAsString(),
      pass,
    ]);
    final record = await recordFromRecovery(payload);
    final server = await discover(record.origin);
    checkTrust(server, record);
    final existing = await widget.controller.vault.load(record.origin);
    if (existing != null) checkTrust(server, existing);
    if (!mounted ||
        !await confirm(
          'Восстановить идентичность на ${record.origin}? Будет создан новый ключ этого устройства. ${existing == null ? '' : 'Сохранённые здесь ключи для этого адреса будут заменены. Сначала сохраните их карточку, если это другая идентичность.'}',
        )) {
      return;
    }
    await widget.controller.disconnect();
    await widget.controller.inspect(record.origin);
    await widget.controller.connect(restoredRecord: record);
    if (!widget.controller.connected) {
      throw const FormatException(
        'Ключи сохранены, но сервер не разрешил подключение. Проверьте отзыв карточки, блокировку и доступность чата.',
      );
    }
    await refresh();
    if (mounted) {
      setState(
        () => message = 'Идентичность восстановлена с новым устройством. Проверьте список и отзовите потерянные устройства.',
      );
    }
  }

  Future<void> refresh() async {
    final result = await widget.controller.deviceManagement?.listDevices();
    if (mounted) setState(() => devices = result ?? []);
  }

  Future<void> revoke(DeviceGrant grant) async {
    final manager = widget.controller.deviceManagement;
    if (manager == null) return;
    if (!await confirm(
      grant.recovery
          ? 'Отозвать ключ восстановления? Карточка и все устройства, подключённые через неё, перестанут работать. Перед этим сохраните другой путь доступа.'
          : 'Отозвать это устройство? Его сессии и подписки завершатся.',
    )) {
      return;
    }
    DeviceRecord? authority;
    if (!manager.hasRootAuthority && grant.id != manager.currentGrantId) {
      final file = await openFile(acceptedTypeGroups: files);
      if (file == null) return;
      if (await file.length() > 16384) {
        throw const FormatException('Карточка слишком большая');
      }
      final pass = await password(false);
      if (pass == null) return;
      authority = await recordFromRecovery(
        await compute(openCardInWorker, [await file.readAsString(), pass]),
      );
    }
    await manager.revokeDevice(grant, authority: authority);
    if (grant.id == manager.currentGrantId) {
      await widget.controller.disconnect();
      if (mounted) setState(() => devices = []);
    } else {
      await refresh();
    }
    if (mounted) setState(() => message = 'Разрешение отозвано на сервере.');
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Восстановление доступа',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Зашифрованная карточка сохраняет доступ к этой идентичности на выбранном сервере. Рабочий ключ устройства в неё не копируется. Владение карточкой и паролем позволяет подключать новые устройства. Устройство из карточки панели не сохраняет управляющий секрет; для отзыва других устройств её нужно открыть заново. Корневая карточка Flutter восстанавливает полный управляющий root. Сейчас используется файл JSON; QR-импорт появится отдельно.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed:
                      pending ||
                          !widget.controller.connected ||
                          widget
                                  .controller
                                  .deviceManagement
                                  ?.hasRootAuthority !=
                              true
                      ? null
                      : () => run(export),
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Сохранить карточку'),
                ),
                OutlinedButton.icon(
                  onPressed: pending ? null : () => run(restore),
                  icon: const Icon(Icons.restore),
                  label: const Text('Восстановить из файла'),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ваши устройства',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Обновить устройства',
                  onPressed:
                      pending ||
                          !widget.controller.connected ||
                          widget.controller.deviceManagement == null
                      ? null
                      : () => run(refresh),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const Text(
              'Показаны разрешения только вашей идентичности. Старые и отозванные записи сохраняются.',
            ),
            for (final grant in devices) ...[
              const Divider(),
              Text(
                grant.recovery
                    ? 'Ключ восстановления'
                    : grant.id ==
                          widget.controller.deviceManagement?.currentGrantId
                    ? 'Это устройство'
                    : 'Другое устройство',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SelectableText(grant.id, style: const TextStyle(fontSize: 12)),
              Text(
                grant.revoked
                    ? 'Отозвано'
                    : 'Действует до ${DateTime.fromMillisecondsSinceEpoch(grant.expiresAt.toInt() * 1000).toLocal()}',
              ),
              if (!grant.revoked &&
                  grant.expiresAt.toInt() >
                      DateTime.now().millisecondsSinceEpoch ~/ 1000)
                TextButton(
                  onPressed: pending ? null : () => run(() => revoke(grant)),
                  child: const Text('Отозвать доступ'),
                ),
            ],
          ],
        ),
      ),
      if (pending) ...[
        const SizedBox(height: 16),
        const LinearProgressIndicator(),
      ],
      if (message.isNotEmpty) ...[const SizedBox(height: 12), Text(message)],
    ],
  );
}
