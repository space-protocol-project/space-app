import '../l10n/failure_strings.dart';
import '../l10n/strings.dart';

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
                    context.strings.findSpace,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: context.strings.closeConnection,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(context.strings.connectionIntro),
            const SizedBox(height: 20),
            TextField(
              controller: address,
              enabled: !c.busy && !c.connected,
              decoration: InputDecoration(
                labelText: context.strings.serverAddress,
                hintText: 'http://127.0.0.1:8080',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: invitation,
              enabled: !c.busy && !c.connected,
              decoration: InputDecoration(
                labelText: context.strings.optionalInvite,
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
              label: Text(context.strings.checkServer),
            ),
            if (c.busy) ...[
              const SizedBox(height: 18),
              const LinearProgressIndicator(),
            ],
            if (c.error.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                chatFailureText(context, c),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (c.preview != null) ...[
              const SizedBox(height: 24),
              Text(
                context.strings.verifyTrust,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              SelectableText(c.preview!.origin.toString()),
              const SizedBox(height: 10),
              Text(context.strings.serverKeyFingerprint),
              const SizedBox(height: 6),
              SelectableText(
                c.fingerprint,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              if (c.preview!.tlsFingerprint.isNotEmpty) ...[
                Text(context.strings.tlsCertificateFingerprint),
                const SizedBox(height: 6),
                SelectableText(
                  c.preview!.tlsFingerprint,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
              ],
              Text(context.strings.firstTrustHelp),
              const SizedBox(height: 20),
              if (c.invitationRole.isNotEmpty)
                Text(
                  c.invitationRole == 'reader'
                      ? context.strings.readerInvitation
                      : context.strings.memberInvitation,
                ),
              FilledButton(
                onPressed: c.busy || c.connected ? null : connect,
                child: Text(context.strings.trustAndConnect),
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
                child: Text(context.strings.disconnectServer),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              context.strings.supportedConnections,
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
