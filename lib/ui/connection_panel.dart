import 'package:flutter/material.dart';

import '../src/chat_controller.dart';
import 'pairing_panel.dart';

class ConnectionPanel extends StatefulWidget {
  const ConnectionPanel({
    super.key,
    required this.controller,
    required this.onConnected,
    this.origin = 'http://127.0.0.1:8080',
  });
  final ChatController controller;
  final Future<void> Function(String) onConnected;
  final String origin;
  @override
  State<ConnectionPanel> createState() => _ConnectionPanelState();
}

class _ConnectionPanelState extends State<ConnectionPanel> {
  final invitation = TextEditingController();
  late final TextEditingController address = TextEditingController(
    text: widget.origin,
  );
  @override
  void dispose() {
    address.dispose();
    invitation.dispose();
    super.dispose();
  }

  Future<void> connect() async {
    await widget.controller.connect();
    if (widget.controller.connected && mounted) {
      await widget.onConnected(widget.controller.preview!.origin.toString());
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) {
      final c = widget.controller;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.travel_explore),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Найдите своё пространство',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Закрыть подключение',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Адрес независимого сервера. Сначала проверим его, затем вы решите, доверять ли ему.',
            ),
            const SizedBox(height: 20),
            TextField(
              controller: address,
              enabled: !c.busy && !c.connected,
              decoration: const InputDecoration(
                labelText: 'Адрес сервера или ссылка приглашения',
                hintText: 'http://127.0.0.1:8080',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: invitation,
              enabled: !c.busy && !c.connected,
              decoration: const InputDecoration(
                labelText: 'Код приглашения (необязательно)',
                hintText: 'iv_…',
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(
              onPressed: c.busy || c.connected
                  ? null
                  : () => c.inspect(
                      address.text,
                      invitationToken: invitation.text,
                    ),
              icon: const Icon(Icons.search),
              label: const Text('Проверить сервер'),
            ),
            if (c.busy) ...[
              const SizedBox(height: 18),
              const LinearProgressIndicator(),
            ],
            if (c.error.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                c.error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (c.preview != null) ...[
              const SizedBox(height: 24),
              Text(
                'Проверка доверия',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              SelectableText(c.preview!.origin.toString()),
              const SizedBox(height: 10),
              const Text('Отпечаток серверного ключа'),
              const SizedBox(height: 6),
              SelectableText(
                c.fingerprint,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              const Text(
                'При первом визите сравните адрес и отпечаток с известными данными владельца. Первый вход создаёт отдельные ключи для этого сервера.',
              ),
              const SizedBox(height: 20),
              if (c.invitationRole.isNotEmpty)
                Text(
                  c.invitationRole == 'reader'
                      ? 'Приглашение: читатель — только чтение чата.'
                      : 'Приглашение: участник — читать и писать в чате.',
                ),
              FilledButton(
                onPressed: c.busy || c.connected ? null : connect,
                child: const Text('Доверять и подключиться'),
              ),
              PairingStartPanel(controller: c, onConnected: widget.onConnected),
            ],
            if (c.connected) ...[
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: c.busy
                    ? null
                    : () async {
                        await c.disconnect();
                      },
                child: const Text('Отключиться от сервера'),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'Сейчас поддерживаются локальные серверы. Карточку восстановления можно открыть в разделе «Идентичность».',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    },
  );
}
