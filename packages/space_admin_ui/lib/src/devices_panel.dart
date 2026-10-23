import 'content_insets.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_operations.dart';

import 'package:flutter/material.dart';

import 'channels_panel.dart';
import '../l10n/admin_localizations.dart';

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
  final operations = AdminOperations();
  bool get busy => operations.state.busy;
  AdminLocalizations get strings =>
      AdminLocalizations.of(context) ??
      lookupAdminLocalizations(const Locale('ru'));
  List<Map<String, dynamic>> devices = [];
  bool revoked = false, confirming = false;
  String status = '';
  String? statusKey;
  String get localizedStatus => switch (statusKey) {
    'devicesLoaded' => strings.devicesLoaded,
    'deviceRevokedStatus' => strings.deviceRevokedStatus,
    _ => status,
  };
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) run(load);
    });
  }

  @override
  void dispose() {
    unawaited(operations.close());
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (revoked || !await operations.begin()) return;
    Object? failure;
    try {
      await action();
    } catch (e) {
      failure = e;
      if (mounted) {
        statusKey = null;
        status = e.toString().replaceFirst('Bad state: ', '');
      }
    } finally {
      if (mounted) operations.finish(error: failure);
    }
  }

  Future<void> load() async {
    final result = await widget.call('/api/v1/auth/devices');
    if (!mounted) return;
    devices = [
      for (final value in result['devices'] as List? ?? [])
        Map<String, dynamic>.from(value as Map),
    ];
    statusKey = 'devicesLoaded';
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
        builder: (context) {
          final strings =
              AdminLocalizations.of(context) ??
              lookupAdminLocalizations(const Locale('ru'));
          return AlertDialog(
            title: Text(strings.deviceRevokeConfirm),
            content: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_revokeWarning(strings, grant, current)),
                  if (needsCard) ...[
                    const SizedBox(height: 16),
                    Text(strings.deviceCardHelp),
                    TextField(
                      scrollPadding: SpaceContentInsets.scrollPaddingOf(
                        context,
                      ),
                      onChanged: (value) => password = value,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: strings.deviceCardPassword,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(strings.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, password),
                child: Text(strings.deviceRevoke),
              ),
            ],
          );
        },
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
    statusKey = 'deviceRevokedStatus';
  }

  String _revokeWarning(
    AdminLocalizations strings,
    Map<String, dynamic> grant,
    bool current,
  ) {
    if (grant['recovery'] == true) return strings.deviceRecoveryWarning;
    if (current) return strings.deviceCurrentWarning;
    return strings.deviceOtherWarning;
  }

  String expiry(Map<String, dynamic> grant) {
    final seconds = int.tryParse('${grant['expiresAt']}');
    if (seconds == null) return strings.deviceExpiryUnknown;
    final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000).toLocal();
    final material = MaterialLocalizations.of(context);
    return '${material.formatShortDate(date)} ${material.formatTimeOfDay(TimeOfDay.fromDateTime(date), alwaysUse24HourFormat: true)}';
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminOperations, AdminOperationState>(
        bloc: operations,
        builder: (context, state) => _build(context),
      );

  Widget _build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(strings.devicesTitle, style: TextStyle(fontSize: 20)),
          Text(strings.devicesHelp),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: busy || revoked ? null : () => run(load),
            child: Text(strings.devicesRefresh),
          ),
          if (busy && !confirming) const LinearProgressIndicator(),
          if (!busy && devices.isEmpty) Text(strings.devicesEmpty),
          for (final grant in devices) _deviceEntry(grant),
          if (localizedStatus.isNotEmpty)
            Text(localizedStatus, key: const ValueKey('devices-status')),
        ],
      ),
    ),
  );
  Widget _deviceEntry(Map<String, dynamic> grant) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          grant['recovery'] == true
              ? strings.deviceRecovery
              : grant['id'] == widget.currentGrantId
              ? strings.deviceCurrent
              : strings.deviceOther,
        ),
        SelectableText(
          '${grant['id']}',
          style: const TextStyle(fontSize: 12, fontFamily: 'JetBrains Mono'),
        ),
        Text(
          grant['revoked'] == true
              ? strings.inviteRevokedState
              : active(grant)
              ? strings.deviceAccessUntil(expiry(grant))
              : strings.deviceExpired(expiry(grant)),
        ),
        Text(strings.deviceScopes((grant['scopes'] as List? ?? []).join(', '))),
        if ((grant['parentGrantId'] as String? ?? '').isNotEmpty)
          Text(strings.deviceParent('${grant['parentGrantId']}')),
        if (active(grant))
          TextButton(
            key: ValueKey('revoke-device-${grant['id']}'),
            onPressed: busy ? null : () => run(() => revoke(grant)),
            child: Text(strings.deviceRevokeAccess),
          ),
      ],
    ),
  );
}
