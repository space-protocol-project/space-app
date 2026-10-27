import 'package:flutter/material.dart';

import 'control_spacing.dart';

import '../l10n/admin_localizations.dart';

class RecoveryDeviceView {
  const RecoveryDeviceView({
    required this.id,
    required this.expiresAt,
    this.revoked = false,
    this.recovery = false,
  });
  final String id;
  final int expiresAt;
  final bool revoked, recovery;
}

class RecoveryToolsView extends StatelessWidget {
  const RecoveryToolsView({
    super.key,
    required this.connected,
    required this.hasServer,
    required this.hasDeviceManagement,
    required this.hasRootAuthority,
    required this.canRotate,
    required this.pending,
    this.progress = '',
    this.canCreateQr = false,
    this.onCreateQr,
    this.qrPreview,
    this.recoveryOptions,
    this.onExportJson,
    required this.message,
    required this.pairingTools,
    required this.devices,
    required this.currentGrantId,
    required this.onRotate,
    required this.onRenewRotation,
    required this.onFinishRotation,
    required this.onExport,
    required this.onRestore,
    required this.onScan,
    required this.onRefreshDevices,
    required this.onRevoke,
  });
  final bool connected,
      hasServer,
      hasDeviceManagement,
      hasRootAuthority,
      canRotate,
      pending;
  final String message, currentGrantId;
  final String progress;
  final bool canCreateQr;
  final VoidCallback? onCreateQr;
  final Widget? qrPreview;
  final Widget? recoveryOptions;
  final VoidCallback? onExportJson;
  final Widget pairingTools;
  final List<RecoveryDeviceView> devices;
  final VoidCallback onRotate,
      onRenewRotation,
      onFinishRotation,
      onExport,
      onRestore,
      onScan,
      onRefreshDevices;
  final ValueChanged<String> onRevoke;
  @override
  Widget build(BuildContext context) {
    final strings =
        AdminLocalizations.of(context) ??
        lookupAdminLocalizations(const Locale('ru'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canRotate) _rotationTools(context, strings),
        const SizedBox(height: 20),
        pairingTools,
        const SizedBox(height: 20),
        _recoveryCardTools(context, strings),
        const SizedBox(height: 20),
        _deviceTools(context, strings),
        if (pending && progress.isEmpty) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
        ],
        if (message.isNotEmpty) ...[const SizedBox(height: 12), Text(message)],
      ],
    );
  }

  Widget _rotationTools(BuildContext context, AdminLocalizations strings) =>
      RecoverySurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.rotationTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(strings.rotationHelp),
            const SizedBox(height: 12),
            if (connected && hasRootAuthority && canRotate) ...[
              OutlinedButton(
                onPressed: pending ? null : onRotate,
                child: Text(strings.rotationStart),
              ),
              TextButton(
                onPressed: pending ? null : onRenewRotation,
                child: Text(strings.rotationRenew),
              ),
            ],
            OutlinedButton(
              onPressed: pending || !hasServer ? null : onFinishRotation,
              child: Text(strings.rotationFinish),
            ),
          ],
        ),
      );

  Widget _recoveryCardTools(BuildContext context, AdminLocalizations strings) =>
      RecoverySurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.recoveryTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(strings.recoveryHelp),
            if (recoveryOptions != null) recoveryOptions!,
            if (qrPreview != null) ...[const SizedBox(height: 16), qrPreview!],
            if (pending && progress.isNotEmpty) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text(progress),
            ],
            const SizedBox(height: 16),
            _cardActions(strings),
            if (onCreateQr != null && !canCreateQr && qrPreview == null) ...[
              const SizedBox(height: 12),
              Text(strings.recoveryOriginalCardNeeded),
            ],
          ],
        ),
      );

  Widget _deviceTools(BuildContext context, AdminLocalizations strings) =>
      RecoverySurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    strings.recoveryDevices,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: strings.devicesRefresh,
                  onPressed: pending || !connected || !hasDeviceManagement
                      ? null
                      : onRefreshDevices,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            Text(strings.recoveryDevicesHelp),
            for (final grant in devices)
              ..._recoveryDevice(context, strings, grant),
          ],
        ),
      );
  Widget _cardActions(AdminLocalizations strings) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      if (onCreateQr != null)
        OutlinedButton.icon(
          onPressed: pending || !canCreateQr ? null : onCreateQr,
          icon: const Icon(Icons.qr_code),
          label: Text(strings.recoveryCreateQr),
        ),
      FilledButton.icon(
        onPressed:
            pending ||
                (onCreateQr != null
                    ? qrPreview == null
                    : !connected || !hasRootAuthority)
            ? null
            : onExport,
        icon: const Icon(Icons.save_alt),
        label: Text(strings.recoveryExport),
      ),
      if (onExportJson != null)
        TextButton(
          onPressed: pending ? null : onExportJson,
          child: const Text('JSON'),
        ),
      OutlinedButton.icon(
        onPressed: pending ? null : onRestore,
        icon: const Icon(Icons.restore),
        label: Text(strings.recoveryRestore),
      ),
      OutlinedButton.icon(
        onPressed: pending ? null : onScan,
        icon: const Icon(Icons.qr_code_scanner),
        label: Text(strings.recoveryScan),
      ),
    ],
  );

  List<Widget> _recoveryDevice(
    BuildContext context,
    AdminLocalizations strings,
    RecoveryDeviceView grant,
  ) {
    return [
      const Divider(),
      Text(
        grant.recovery
            ? strings.deviceRecovery
            : grant.id == currentGrantId
            ? strings.deviceCurrent
            : strings.deviceOther,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      SelectableText(
        grant.id,
        style: const TextStyle(fontSize: 12, fontFamily: 'JetBrains Mono'),
      ),
      Text(
        grant.revoked
            ? strings.inviteRevokedState
            : strings.deviceAccessUntil(
                '${DateTime.fromMillisecondsSinceEpoch(grant.expiresAt * 1000).toLocal()}',
              ),
      ),
      if (!grant.revoked &&
          grant.expiresAt > DateTime.now().millisecondsSinceEpoch ~/ 1000)
        TextButton(
          onPressed: pending ? null : () => onRevoke(grant.id),
          child: Text(strings.deviceRevokeAccess),
        ),
    ];
  }
}

class RecoverySurface extends StatelessWidget {
  const RecoverySurface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: spaceControls(child),
    ),
  );
}
