import 'package:flutter/material.dart';

import 'channels_panel.dart';

typedef DeviceRevoke = Future<void> Function(
  Map<String, dynamic> grant,
  String password,
);

class DevicesPanel extends StatefulWidget {
  const DevicesPanel({
    super.key,
    required this.call,
    required this.currentGrantId,
    required this.revoke,
    required this.onRevoked,
    this.hasRootAuthority = false,
  });
  final AdminCall call;
  final String currentGrantId;
  final DeviceRevoke revoke;
  final VoidCallback onRevoked;
  final bool hasRootAuthority;
  @override
  State<DevicesPanel> createState() => _DevicesPanelState();
}

class _DevicesPanelState extends State<DevicesPanel> {
  List<Map<String, dynamic>> devices = [];
  bool busy = false, revoked = false, confirming = false;
  String status = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) run(load);
    });
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy || revoked) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) status = e.toString().replaceFirst('Bad state: ', '');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> load() async {
    final result = await widget.call('/api/v1/auth/devices');
    if (!mounted) return;
    devices = [
      for (final value in result['devices'] as List? ?? [])
        Map<String, dynamic>.from(value as Map),
    ];
    status = 'Устройства загружены.';
  }

  bool active(Map<String, dynamic> grant) =>
      grant['revoked'] != true &&
      (int.tryParse('${grant['expiresAt']}') ?? 0) >
          DateTime.now().millisecondsSinceEpoch ~/ 1000;
  Future<void> revoke(Map<String, dynamic> grant) async {
    final current = grant['id'] == widget.currentGrantId;
    final needsCard = !current && !widget.hasRootAuthority;
    var password = '';
    String? secret;
    setState(() => confirming = true);
    try {
      secret = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Отозвать доступ?'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  grant['recovery'] == true
                      ? 'Карточка и все подключённые через неё устройства потеряют доступ. Проверьте другой путь восстановления.'
                      : current
                      ? 'Это устройство потеряет доступ. Его сессия и подписки завершатся.'
                      : 'Сессии и подписки устройства завершатся.',
                ),
                if (needsCard) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'После подтверждения выберите исходную карточку JSON или PNG. Секрет используется только для подписи.',
                  ),
                  TextField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Пароль карточки',
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, password),
              child: const Text('Отозвать'),
            ),
          ],
        ),
      );
    } finally {
      password = '';
      if (mounted) setState(() => confirming = false);
    }
    if (secret == null || !mounted) return;
    await widget.revoke(grant, secret);
    if (!mounted) return;
    if (current) {
      revoked = true;
      devices = [];
      widget.onRevoked();
    } else {
      await load();
    }
    status = 'Доступ отозван на сервере.';
  }

  String expiry(Map<String, dynamic> grant) {
    final seconds = int.tryParse('${grant['expiresAt']}');
    if (seconds == null) return 'Срок неизвестен';
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000)
        .toLocal()
        .toString();
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Устройства и разрешения', style: TextStyle(fontSize: 20)),
          const Text(
            'Только устройства вашей идентичности. Роль на сервере и разрешения устройства проверяются отдельно.',
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: busy || revoked ? null : () => run(load),
            child: const Text('Обновить устройства'),
          ),
          if (busy && !confirming) const LinearProgressIndicator(),
          if (!busy && devices.isEmpty) const Text('Нет доступных устройств.'),
          for (final grant in devices)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grant['recovery'] == true
                        ? 'Ключ восстановления'
                        : grant['id'] == widget.currentGrantId
                        ? 'Это устройство'
                        : 'Другое устройство',
                  ),
                  SelectableText(
                    '${grant['id']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                  Text(
                    grant['revoked'] == true
                        ? 'Отозвано'
                        : active(grant)
                        ? 'Доступ до ${expiry(grant)}'
                        : 'Срок истёк: ${expiry(grant)}',
                  ),
                  Text(
                    'Разрешения: ${(grant['scopes'] as List? ?? []).join(', ')}',
                  ),
                  if ((grant['parentGrantId'] as String? ?? '').isNotEmpty)
                    Text('Выдано через: ${grant['parentGrantId']}'),
                  if (active(grant))
                    TextButton(
                      onPressed: busy ? null : () => run(() => revoke(grant)),
                      child: const Text('Отозвать доступ'),
                    ),
                ],
              ),
            ),
          if (status.isNotEmpty)
            Text(status, key: const ValueKey('devices-status')),
        ],
      ),
    ),
  );
}
