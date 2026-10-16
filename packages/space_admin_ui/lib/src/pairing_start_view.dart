import 'package:flutter/material.dart';

import '../l10n/admin_localizations.dart';

import 'package:flutter/services.dart';

class PairingStartView extends StatelessWidget {
  const PairingStartView({
    super.key,
    required this.busy,
    required this.connectionBusy,
    required this.connected,
    required this.code,
    required this.signatureVerified,
    required this.verification,
    required this.error,
    required this.onStart,
    required this.onAccept,
    required this.onCancel,
  });
  final bool busy, connectionBusy, connected, signatureVerified;
  final String code, verification, error;
  final VoidCallback onStart, onAccept, onCancel;
  @override
  Widget build(BuildContext context) {
    final strings =
        AdminLocalizations.of(context) ??
        lookupAdminLocalizations(const Locale('ru'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 18),
        const Divider(),
        const SizedBox(height: 12),
        Text(
          strings.pairingIdentity,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(strings.pairingIntro),
        const SizedBox(height: 12),
        if (code.isEmpty)
          OutlinedButton.icon(
            onPressed: busy || connectionBusy || connected ? null : onStart,
            icon: const Icon(Icons.devices),
            label: Text(strings.pairingStart),
          ),
        if (code.isNotEmpty) ..._pairingDetails(context, strings),
        if (busy) const LinearProgressIndicator(),
        if (error.isNotEmpty)
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }

  List<Widget> _pairingDetails(
    BuildContext context,
    AdminLocalizations strings,
  ) {
    return [
      Text(strings.pairingInstructions),
      const SizedBox(height: 10),
      SelectableText(
        code,
        style: const TextStyle(fontFamily: 'JetBrains Mono'),
      ),
      TextButton.icon(
        onPressed: () => Clipboard.setData(ClipboardData(text: code)),
        icon: const Icon(Icons.copy),
        label: Text(strings.pairingCopy),
      ),
      if (!signatureVerified && error.isEmpty) Text(strings.pairingWaiting),
      if (!signatureVerified && verification.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text(strings.pairingCheckBeforeSign),
        SelectableText(
          verification,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontFamily: 'JetBrains Mono'),
        ),
      ],
      if (signatureVerified) ...[
        const SizedBox(height: 12),
        Text(strings.pairingVerified),
        SelectableText(
          verification,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontFamily: 'JetBrains Mono'),
        ),
        FilledButton(
          onPressed: busy ? null : onAccept,
          child: Text(strings.pairingAccept),
        ),
      ],
      TextButton(
        onPressed: busy ? null : onCancel,
        child: Text(strings.pairingCancel),
      ),
    ];
  }
}
