import 'storage_limits.dart';
import 'content_insets.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_operations.dart';

import 'package:flutter/material.dart';
import 'package:space_api/space_api.dart';

import 'channels_panel.dart';
import '../l10n/admin_localizations.dart';

Map<String, dynamic> memberStorageChange(
  Map<String, dynamic> original,
  Map<String, dynamic> draft,
) {
  final value = '${draft['storageMiB'] ?? ''}'.trim();
  if (value.isNotEmpty) {
    return {'storageLimitBytes': storageLimitBytes(value).toString()};
  }
  return original.containsKey('storageLimitBytes')
      ? {'resetStorageLimit': true}
      : {};
}

String memberStorageMiB(Map<String, dynamic> member) {
  final value = int.tryParse('${member['storageLimitBytes']}');
  return value == null ? '' : (value ~/ 1048576).toString();
}

String memberRoleLabel(String role, [AdminLocalizations? translations]) {
  final strings = translations ?? lookupAdminLocalizations(const Locale('ru'));
  return switch (role) {
    'owner' => strings.roleOwner,
    'admin' => strings.roleAdmin,
    'member' => strings.roleMember,
    'reader' => strings.roleReader,
    _ => role,
  };
}

class MembersPanel extends StatefulWidget {
  const MembersPanel({super.key, required this.call, required this.owner});
  final AdminCall call;
  final bool owner;
  @override
  State<MembersPanel> createState() => _MembersPanelState();
}

class _MembersPanelState extends State<MembersPanel> {
  final operations = AdminOperations();
  bool get busy => operations.state.busy;
  AdminLocalizations get strings =>
      AdminLocalizations.of(context) ??
      lookupAdminLocalizations(const Locale('ru'));
  final members = <Map<String, dynamic>>[];
  final drafts = <String, Map<String, dynamic>>{};
  final search = TextEditingController();
  String cursor = '', status = '';
  String? editing, statusKey;
  String get localizedStatus => switch (statusKey) {
    'membersLoaded' => strings.membersLoaded,
    'memberSaved' => strings.memberSaved,
    'membersConflict' => strings.membersConflict,
    _ => status,
  };
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) run(() => load());
    });
  }

  @override
  void dispose() {
    search.dispose();
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
      statusKey = e is SpaceApiError && e.status == 409
          ? 'membersConflict'
          : null;
      status = e.toString().replaceFirst('Bad state: ', '');
      if (e is SpaceApiError && [401, 403].contains(e.status)) {
        members.clear();
        drafts.clear();
        cursor = '';
      }
    } finally {
      if (mounted) operations.finish(error: failure);
    }
  }

  Future<void> load({bool append = false}) async {
    final data = await widget.call(
      '/api/v1/space/members${append && cursor.isNotEmpty ? '?after=${Uri.encodeQueryComponent(cursor)}' : ''}',
    );
    if (!mounted) return;
    if (!append) {
      members.clear();
      drafts.clear();
      editing = null;
    }
    for (final raw in data['members'] as List? ?? []) {
      final m = Map<String, dynamic>.from(raw as Map);
      final id = m['principalId'] as String;
      final index = members.indexWhere((v) => v['principalId'] == id);
      if (index < 0)
        members.add(m);
      else
        members[index] = m;
      drafts.putIfAbsent(id, () => {...m, 'storageMiB': memberStorageMiB(m)});
    }
    cursor = data['nextCursor'] as String? ?? '';
    statusKey = 'membersLoaded';
  }

  Future<void> save(Map<String, dynamic> m) async {
    final id = m['principalId'] as String;
    final draft = drafts[id]!;
    final proposal = Map<String, dynamic>.from(draft);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final strings =
            AdminLocalizations.of(context) ??
            lookupAdminLocalizations(const Locale('ru'));
        return AlertDialog(
          title: Text(strings.memberConfirm),
          content: Text(
            strings.memberProposal(
              id,
              memberRoleLabel(proposal['role'] as String, strings),
              proposal['blocked'] == true
                  ? strings.memberBlocked
                  : strings.memberAllowed,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(strings.memberApply),
            ),
          ],
        );
      },
    );
    if (confirm != true || !mounted) return;
    await run(() async {
      final result = await widget.call(
        '/api/v1/space/members/${Uri.encodeComponent(id)}',
        method: 'PATCH',
        body: {
          'role': proposal['role'],
          'blocked': proposal['blocked'] ?? false,
          'expectedRevision': proposal['revision'],
          ...memberStorageChange(m, proposal),
        },
      );
      if (!mounted) return;
      final saved = Map<String, dynamic>.from(result['member'] as Map);
      members[members.indexWhere((v) => v['principalId'] == id)] = saved;
      drafts[id] = {...saved, 'storageMiB': memberStorageMiB(saved)};
      statusKey = 'memberSaved';
    });
  }

  Widget editor(Map<String, dynamic> m) {
    final id = m['principalId'] as String;
    final draft = drafts[id]!;
    return Card.outlined(
      key: ValueKey('member-card-$id'),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 16,
                child: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            if ((m['nickname'] as String? ?? '').isNotEmpty)
              Text(
                m['nickname'] as String,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            SelectableText(
              id,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'JetBrains Mono',
              ),
            ),
            Text(
              '${memberRoleLabel(m['role'] as String, strings)}${m['blocked'] == true ? strings.memberBlockedSuffix : ''}',
            ),
            if (widget.owner && m['role'] != 'owner')
              TextButton(
                key: ValueKey('edit-member-$id'),
                onPressed: busy
                    ? null
                    : () => setState(() => editing = editing == id ? null : id),
                child: Text(
                  editing == id ? strings.memberCollapse : strings.memberEdit,
                ),
              ),
            if (widget.owner && m['role'] != 'owner' && editing == id) ...[
              TextFormField(
                key: ValueKey('storage-$id-${m["revision"]}'),
                initialValue: memberStorageMiB(m),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings.storagePersonal,
                  helperText: strings.storageInherited,
                ),
                onChanged: (value) => draft['storageMiB'] = value,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                key: ValueKey('role-$id-${m['revision']}'),
                initialValue: draft['role'] as String,
                decoration: InputDecoration(labelText: strings.memberRole),
                items: [
                  for (final role in ['reader', 'member', 'admin'])
                    DropdownMenuItem(
                      value: role,
                      child: Text(
                        memberRoleLabel(role, strings),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: busy
                    ? null
                    : (v) => setState(() => draft['role'] = v),
              ),
              SwitchListTile(
                key: ValueKey('blocked-$id'),
                contentPadding: EdgeInsets.zero,
                title: Text(strings.memberBlock),
                value: draft['blocked'] == true,
                onChanged: busy
                    ? null
                    : (v) => setState(() => draft['blocked'] = v),
              ),
              OutlinedButton(
                key: ValueKey('save-member-$id'),
                onPressed: busy ? null : () => save(m),
                child: Text(strings.memberSave),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminOperations, AdminOperationState>(
        bloc: operations,
        builder: (context, state) => _build(context),
      );

  Widget _build(BuildContext context) {
    final query = search.text.trim().toLowerCase();
    final filtered = members
        .where(
          (m) =>
              '${m['nickname'] ?? ''} ${m['principalId']} ${m['role']} ${memberRoleLabel(m['role'] as String, strings)} ${m['blocked'] == true ? strings.memberBlocked : ''}'
                  .toLowerCase()
                  .contains(query),
        )
        .toList();
    return Card(
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
                Text(strings.channelMembers, style: TextStyle(fontSize: 20)),
                OutlinedButton(
                  onPressed: busy ? null : () => run(() => load()),
                  child: Text(strings.membersRefresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(strings.membersHelp),
            const SizedBox(height: 12),
            TextField(
              scrollPadding: SpaceContentInsets.scrollPaddingOf(context),
              key: const ValueKey('member-search'),
              controller: search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: strings.membersSearch),
            ),
            Text(strings.membersCount(members.length)),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth.clamp(0.0, 240.0);
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final m in filtered)
                      SizedBox(
                        width: width,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: width),
                          child: editor(m),
                        ),
                      ),
                  ],
                );
              },
            ),
            if (filtered.isEmpty && !busy)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(strings.membersEmpty),
              ),
            if (cursor.isNotEmpty)
              OutlinedButton(
                onPressed: busy ? null : () => run(() => load(append: true)),
                child: Text(strings.channelMoreMembers),
              ),
            if (busy) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Semantics(
                container: true,
                liveRegion: true,
                child: Text(
                  localizedStatus,
                  key: const ValueKey('members-status'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
