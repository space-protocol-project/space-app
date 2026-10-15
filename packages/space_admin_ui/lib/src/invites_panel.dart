import 'content_insets.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_operations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_api/space_api.dart';

import 'channels_panel.dart';
import 'members_panel.dart';
import '../l10n/admin_localizations.dart';

class InvitesPanel extends StatefulWidget {
  const InvitesPanel({
    super.key,
    required this.call,
    required this.origin,
    this.tlsFingerprint = '',
    this.linkBuilder,
  });
  final String tlsFingerprint;
  final String Function(String)? linkBuilder;
  final AdminCall call;
  final String origin;
  @override
  State<InvitesPanel> createState() => _InvitesPanelState();
}

class _InvitesPanelState extends State<InvitesPanel> {
  final operations = AdminOperations();
  bool get busy => operations.state.busy;
  AdminLocalizations get strings =>
      AdminLocalizations.of(context) ??
      lookupAdminLocalizations(const Locale('ru'));
  final invites = <Map<String, dynamic>>[];
  final uses = TextEditingController(text: '1');
  String role = 'member', cursor = '', status = '', token = '', issuedId = '';
  int ttl = 86400;
  String? statusKey;
  String get localizedStatus => switch (statusKey) {
    'invitesLoaded' => strings.invitesLoaded,
    'inviteCreated' => strings.inviteCreated,
    'inviteCopied' => strings.inviteCopied,
    'inviteCopyFailed' => strings.inviteCopyFailed,
    'inviteRevoked' => strings.inviteRevoked,
    _ => status,
  };
  String get link =>
      widget.linkBuilder?.call(token) ??
      Uri.parse(widget.origin)
          .replace(
            fragment: Uri(
              queryParameters: {
                'invite': token,
                if (widget.tlsFingerprint.isNotEmpty)
                  'tls': widget.tlsFingerprint,
              },
            ).query,
          )
          .toString();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) run(() => load());
    });
  }

  @override
  void dispose() {
    uses.dispose();
    token = '';
    unawaited(operations.close());
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (!await operations.begin()) return;
    Object? failure;
    try {
      await action();
    } catch (e) {
      failure = e;
      statusKey = null;
      status = e.toString().replaceFirst('Bad state: ', '');
      if (e is SpaceApiError && [401, 403].contains(e.status)) {
        token = '';
        issuedId = '';
        invites.clear();
        cursor = '';
      }
    } finally {
      if (mounted) operations.finish(error: failure);
    }
  }

  bool active(Map<String, dynamic> invite) =>
      invite['revoked'] != true &&
      int.parse('${invite['expiresAt']}') >
          DateTime.now().millisecondsSinceEpoch ~/ 1000 &&
      (invite['uses'] as num? ?? 0) < (invite['maxUses'] as num);
  Future<void> load({bool append = false}) async {
    final result = await widget.call(
      '/api/v1/space/invites${append && cursor.isNotEmpty ? '?after=${Uri.encodeQueryComponent(cursor)}' : ''}',
    );
    if (!mounted) return;
    if (!append) invites.clear();
    for (final raw in result['invites'] as List? ?? []) {
      final value = Map<String, dynamic>.from(raw as Map);
      final index = invites.indexWhere((v) => v['id'] == value['id']);
      if (index < 0)
        invites.add(value);
      else
        invites[index] = value;
      if (value['id'] == issuedId && !active(value)) {
        token = '';
        issuedId = '';
      }
    }
    cursor = result['nextCursor'] as String? ?? '';
    statusKey = 'invitesLoaded';
  }

  Future<void> create() async {
    final count = int.tryParse(uses.text);
    if (count == null || count < 1 || count > 100)
      throw StateError(strings.inviteUsesInvalid);
    final result = await widget.call(
      '/api/v1/space/invites',
      method: 'POST',
      body: {'role': role, 'ttlSeconds': ttl, 'maxUses': count},
    );
    if (!mounted) return;
    token = result['token'] as String;
    issuedId = (result['invite'] as Map)['id'] as String;
    await load();
    statusKey = 'inviteCreated';
  }

  Future<void> copy(String value) async {
    try {
      await Clipboard.setData(ClipboardData(text: value));
      statusKey = 'inviteCopied';
    } catch (_) {
      statusKey = 'inviteCopyFailed';
    }
  }

  Future<void> revoke(Map<String, dynamic> invite) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final strings =
            AdminLocalizations.of(context) ??
            lookupAdminLocalizations(const Locale('ru'));
        return AlertDialog(
          title: Text(strings.inviteRevokeConfirm),
          content: Text(strings.inviteRevokeHelp),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(strings.inviteRevoke),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    await run(() async {
      await widget.call(
        '/api/v1/space/invites/${Uri.encodeComponent(invite['id'] as String)}/revoke',
        method: 'POST',
        body: {},
      );
      if (!mounted) return;
      invite['revoked'] = true;
      if (invite['id'] == issuedId) {
        token = '';
        issuedId = '';
      }
      statusKey = 'inviteRevoked';
    });
  }

  String expiry(Map<String, dynamic> invite) {
    final d = DateTime.fromMillisecondsSinceEpoch(
      int.parse('${invite['expiresAt']}') * 1000,
    ).toLocal();
    final material = MaterialLocalizations.of(context);
    return '${material.formatShortDate(d)} ${material.formatTimeOfDay(TimeOfDay.fromDateTime(d), alwaysUse24HourFormat: true)}';
  }

  String state(Map<String, dynamic> invite) => invite['revoked'] == true
      ? strings.inviteRevokedState
      : int.parse('${invite['expiresAt']}') <=
            DateTime.now().millisecondsSinceEpoch ~/ 1000
      ? strings.inviteExpiredState
      : (invite['uses'] as num? ?? 0) >= (invite['maxUses'] as num)
      ? strings.inviteUsedState
      : strings.inviteActiveState;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminOperations, AdminOperationState>(
        bloc: operations,
        builder: (context, state) => _build(context),
      );

  Widget _build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(strings.invitesTitle, style: TextStyle(fontSize: 20)),
              OutlinedButton(
                onPressed: busy ? null : () => run(() => load()),
                child: Text(strings.invitesRefresh),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(strings.invitesHelp),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            isExpanded: true,
            key: const ValueKey('invite-role'),
            initialValue: role,
            decoration: InputDecoration(labelText: strings.inviteRole),
            items: [
              DropdownMenuItem(
                value: 'member',
                child: Text(
                  strings.inviteMember,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: 'reader',
                child: Text(
                  strings.inviteReader,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: busy ? null : (v) => setState(() => role = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: const ValueKey('invite-ttl'),
            initialValue: ttl,
            decoration: InputDecoration(labelText: strings.inviteTtl),
            items: [
              DropdownMenuItem(value: 60, child: Text(strings.inviteMinute)),
              DropdownMenuItem(value: 3600, child: Text(strings.inviteHour)),
              DropdownMenuItem(value: 86400, child: Text(strings.inviteDay)),
              DropdownMenuItem(value: 604800, child: Text(strings.inviteWeek)),
            ],
            onChanged: busy ? null : (v) => setState(() => ttl = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            scrollPadding: SpaceContentInsets.scrollPaddingOf(context),
            key: const ValueKey('invite-max-uses'),
            controller: uses,
            enabled: !busy,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: strings.inviteUses),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: busy ? null : () => run(create),
            child: Text(strings.inviteCreate),
          ),
          if (token.isNotEmpty) ...[
            const Divider(height: 28),
            Text(strings.inviteCode),
            SelectableText(token, key: const ValueKey('issued-invite-token')),
            const SizedBox(height: 12),
            Text(strings.inviteLink),
            SelectableText(link, key: const ValueKey('issued-invite-link')),
            Text(strings.inviteLinkHelp),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton(
                  onPressed: busy ? null : () => run(() => copy(token)),
                  child: Text(strings.inviteCopyCode),
                ),
                OutlinedButton(
                  onPressed: busy ? null : () => run(() => copy(link)),
                  child: Text(strings.inviteCopyLink),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () => setState(() {
                          token = '';
                          issuedId = '';
                        }),
                  child: Text(strings.inviteHide),
                ),
              ],
            ),
          ],
          const Divider(height: 28),
          for (final invite in invites)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${memberRoleLabel(invite['role'] as String, strings)} · ${state(invite)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    strings.inviteExpiry(
                      expiry(invite),
                      (invite['uses'] as num? ?? 0).toInt(),
                      (invite['maxUses'] as num).toInt(),
                    ),
                  ),
                  if (active(invite))
                    OutlinedButton(
                      key: ValueKey('revoke-${invite['id']}'),
                      onPressed: busy ? null : () => revoke(invite),
                      child: Text(strings.inviteRevoke),
                    ),
                  const Divider(),
                ],
              ),
            ),
          if (invites.isEmpty && !busy) Text(strings.invitesEmpty),
          if (cursor.isNotEmpty)
            OutlinedButton(
              onPressed: busy ? null : () => run(() => load(append: true)),
              child: Text(strings.invitesMore),
            ),
          if (busy) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Semantics(
              container: true,
              liveRegion: true,
              child: Text(
                localizedStatus,
                key: const ValueKey('invites-status'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
