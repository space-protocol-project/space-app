import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

import '../src/chat_controller.dart';
import '../src/core.dart';
import '../src/generated/space/v1/space.pb.dart';
import '../src/recovery_card.dart';
import '../src/recovery_qr.dart';
import '../src/pairing.dart';
import '../src/root_rotation.dart' as rotation;
import '../src/generated/space/v1/space.pbgrpc.dart' show AuthServiceClient;

import 'package:space_admin_ui/space_admin_ui.dart';

import 'camera_scanner.dart';

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
  final pairingCode = TextEditingController();
  final pairingEntered = TextEditingController();
  Pairing? preparedPair;
  DeviceRecord? preparedAuthority;
  String pairingCheck = '';
  @override
  void dispose() {
    pairingCode.dispose();
    pairingEntered.dispose();
    super.dispose();
  }

  static const files = [
    XTypeGroup(label: 'Карточка Space', extensions: ['json', 'png']),
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

  Future<bool> confirm(String text) => confirmRecoveryAction(context, text);
  Future<String?> password(bool creating) =>
      askRecoveryPassword(context, creating: creating);

  Future<void> export() async {
    final manager = widget.controller.deviceManagement;
    if (manager == null) return;
    final pass = await password(true);
    if (pass == null) return;
    final packet = await compute(sealCardInWorker, [
      await manager.recoveryPayload(),
      pass,
    ]);
    if (!mounted) return;
    final png = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Формат карточки'),
        content: const Text(
          'PNG содержит зашифрованный QR и подходит для печати. JSON — компактный резервный файл. Пароль храните отдельно.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('JSON'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('QR в PNG'),
          ),
        ],
      ),
    );
    if (png == null) return;
    final extension = png ? 'png' : 'json';
    final content = png
        ? await compute(pngInWorker, packet)
        : Uint8List.fromList(utf8.encode(packet));
    final destination = await getSaveLocation(
      suggestedName: 'space-recovery.$extension',
      acceptedTypeGroups: [
        XTypeGroup(label: 'Карточка Space', extensions: [extension]),
      ],
    );
    if (destination == null) return;
    await XFile.fromData(
      content,
      mimeType: png ? 'image/png' : 'application/json',
      name: 'space-recovery.$extension',
    ).saveTo(destination.path);
    if (mounted) {
      setState(
        () => message = 'Карточка сохранена. Проверьте её восстановлением на отдельном устройстве; файл и пароль храните раздельно.',
      );
    }
  }

  Future<void> restore({String? cameraPacket}) async {
    String packet;
    if (cameraPacket != null) {
      packet = cameraPacket;
    } else {
      final file = await openFile(acceptedTypeGroups: files);
      if (file == null) return;
      if (await file.length() > maxRecoveryImageBytes) {
        throw const FormatException('Карточка слишком большая');
      }
      packet = await compute(artifactInWorker, await file.readAsBytes());
    }
    final pass = await password(false);
    if (pass == null) return;
    final payload = await compute(openCardInWorker, [packet, pass]);
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

  Future<void> rotate({bool renew = false}) async {
    final manager = widget.controller.deviceManagement;
    if (manager is! RootRotationControl) return;
    if (!await confirm(
      renew
          ? 'Обновить истёкший запрос с теми же сохранёнными новыми ключами? Если сервер уже завершил переход, используйте завершение сохранённой смены.'
          : 'Сменить корневой ключ? Ваш ID, права и история сохранятся. Прежние устройства и карточки потеряют доступ. Новый секрет сначала сохраняется в защищённый журнал. После перехода обязательно сохраните новую карточку.',
    )) {
      return;
    }
    await (manager as RootRotationControl).prepareRotation(renew: renew);
    await finishRotation();
  }

  Future<void> finishRotation() async {
    final server = widget.controller.preview, vault = widget.controller.vault;
    if (server == null || vault is! RotationJournalVault) {
      throw const FormatException('Сначала проверьте адрес прежнего сервера');
    }
    final channel = ClientChannel(
      server.origin.host,
      port: server.grpcPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    try {
      final record = await rotation.finishRootRotation(
        server,
        vault,
        AuthServiceClient(channel),
      );
      if (record == null) {
        if (mounted) {
          setState(
            () => message = 'Для этого сервера нет сохранённой смены ключа.',
          );
        }
        return;
      }
      await widget.controller.disconnect();
      await widget.controller.inspect(record.origin);
      await widget.controller.connect();
      if (!widget.controller.connected) {
        throw const FormatException(
          'Новый ключ сохранён. Проверьте доступность сервера и подключитесь повторно.',
        );
      }
      await refresh();
      if (mounted) {
        setState(
          () => message = 'Корневой ключ сменён, прежний ID сохранён. Сохраните новую карточку; старые карточки и устройства больше не работают.',
        );
      }
    } finally {
      await channel.shutdown();
    }
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
      if (await file.length() > maxRecoveryImageBytes) {
        throw const FormatException('Карточка слишком большая');
      }
      final pass = await password(false);
      if (pass == null) return;
      authority = await recordFromRecovery(
        await compute(openCardInWorker, [
          await compute(artifactInWorker, await file.readAsBytes()),
          pass,
        ]),
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

  Future<void> approve() async {
    final server = widget.controller.preview,
        manager = widget.controller.deviceManagement;
    if (server == null || manager == null) return;
    final pair = await inspectPairing(server, pairingCode.text);
    if (pair.state != 'pending') {
      throw const FormatException('Код уже использован или отменён');
    }
    if (!await confirm(
      'Подготовить подключение «${pair.deviceName}» к вашей идентичности? ${pair.administrative ? 'Запрошено также управление пространством, если роль это разрешает.' : 'Запрошен доступ к чату с вашими правами.'} Подпись ещё не выдаётся. Сначала сравните код на обоих экранах.',
    )) {
      return;
    }
    DeviceRecord? authority;
    if (!manager.hasRootAuthority) {
      final file = await openFile(acceptedTypeGroups: files);
      if (file == null) return;
      if (await file.length() > maxRecoveryImageBytes) {
        throw const FormatException('Карточка слишком большая');
      }
      final pass = await password(false);
      if (pass == null) return;
      authority = await recordFromRecovery(
        await compute(openCardInWorker, [
          await compute(artifactInWorker, await file.readAsBytes()),
          pass,
        ]),
      );
    }
    final code = await manager.preparePairing(pair, authority: authority);
    if (mounted) {
      setState(() {
        pairingCheck = code;
        preparedPair = pair;
        preparedAuthority = authority;
        pairingEntered.clear();
        message = 'Код появится также на новом устройстве. Введите показанный там код проверки перед выдачей подписи.';
      });
    }
  }

  Future<void> finishPairing() async {
    final manager = widget.controller.deviceManagement, pair = preparedPair;
    if (manager == null || pair == null) return;
    if (pairingEntered.text.replaceAll(RegExp(r'[\s-]'), '').toUpperCase() !=
        pairingCheck.replaceAll('-', '')) {
      throw const FormatException(
        'Коды проверки не совпадают. Не подтверждайте подключение.',
      );
    }
    if (!await confirm(
      'Коды на двух устройствах совпадают? Выдать root-подпись для нового устройства с указанными правами?',
    )) {
      return;
    }
    await manager.approvePairing(pair, authority: preparedAuthority);
    if (mounted) {
      setState(() {
        preparedPair = null;
        preparedAuthority = null;
        pairingEntered.clear();
        pairingCode.clear();
        message = 'Подпись выдана. Завершите вход на новом устройстве.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => RecoveryToolsView(
    connected: widget.controller.connected,
    hasServer: widget.controller.preview != null,
    hasDeviceManagement: widget.controller.deviceManagement != null,
    hasRootAuthority:
        widget.controller.deviceManagement?.hasRootAuthority == true,
    canRotate: widget.controller.deviceManagement is RootRotationControl,
    pending: pending,
    message: message,
    pairingCode: pairingCode,
    pairingEntered: pairingEntered,
    pairingCheck: pairingCheck,
    pairingPrepared: preparedPair != null,
    currentGrantId: widget.controller.deviceManagement?.currentGrantId ?? '',
    devices: [
      for (final g in devices)
        RecoveryDeviceView(
          id: g.id,
          expiresAt: g.expiresAt.toInt(),
          revoked: g.revoked,
          recovery: g.recovery,
        ),
    ],
    onRotate: () => run(rotate),
    onRenewRotation: () => run(() => rotate(renew: true)),
    onFinishRotation: () => run(finishRotation),
    onPreparePairing: () => run(approve),
    onApprovePairing: () => run(finishPairing),
    onPairingCodeChanged: (_) => setState(() {
      preparedPair = null;
      preparedAuthority = null;
      pairingCheck = '';
    }),
    onExport: () => run(export),
    onRestore: () => run(restore),
    onScan: () => run(() async {
      final packet = await scanRecoveryCamera(context);
      if (packet != null && mounted) await restore(cameraPacket: packet);
    }),
    onRefreshDevices: () => run(refresh),
    onRevoke: (id) => run(() => revoke(devices.firstWhere((g) => g.id == id))),
  );
}
