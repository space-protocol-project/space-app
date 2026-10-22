import 'content_insets.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_operations.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:space_api/space_api.dart';

import '../l10n/admin_localizations.dart';
import 'control_spacing.dart';

typedef AdminCall = Future<Map<String, dynamic>> Function(
  String path, {
  Map<String, dynamic>? body,
  String? method,
});

class ChannelsPanel extends StatefulWidget {
  const ChannelsPanel({super.key, required this.call, this.voiceRooms = false});
  final AdminCall call;
  final bool voiceRooms;
  @override
  State<ChannelsPanel> createState() => _ChannelsPanelState();
}

class _ChannelsPanelState extends State<ChannelsPanel> {
  final operations = AdminOperations();
  bool get busy => operations.state.busy;
  AdminLocalizations get strings =>
      AdminLocalizations.of(context) ??
      lookupAdminLocalizations(const Locale('ru'));
  List<Map<String, dynamic>> channels = [], members = [], rules = [];
  Map<String, dynamic>? selected;
  String status = '', subject = 'member', memberCursor = '';
  String? principal, accessRevision, statusKey;
  String get localizedStatus => switch (statusKey) {
    'channelsLoaded' => strings.channelsLoaded,
    'channelLoaded' => strings.channelLoaded,
    'channelCreated' =>
      widget.voiceRooms ? strings.voiceRoomCreated : strings.channelCreated,
    'channelSaved' =>
      widget.voiceRooms ? strings.voiceRoomSaved : strings.channelSaved,
    'channelDeleted' =>
      widget.voiceRooms ? strings.voiceRoomDeleted : strings.channelDeleted,
    'channelAccessSaved' => strings.channelAccessSaved,
    'channelRuleAdded' => strings.channelRuleAdded,
    'channelConflict' => strings.channelConflict,
    _ => status,
  };
  bool archived = false, preview = false;
  final newCapacity = TextEditingController(text: '8'),
      capacity = TextEditingController(text: '8');
  final newId = TextEditingController(),
      newTitle = TextEditingController(),
      newOrder = TextEditingController(text: '10');
  final title = TextEditingController(),
      order = TextEditingController(),
      manualPrincipal = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) run(load);
    });
  }

  @override
  void dispose() {
    for (final c in [
      newCapacity,
      capacity,
      newId,
      newTitle,
      newOrder,
      title,
      order,
      manualPrincipal,
    ]) {
      c.dispose();
    }
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
          ? 'channelConflict'
          : null;
      status = e.toString().replaceFirst('Bad state: ', '');
    } finally {
      if (mounted) operations.finish(error: failure);
    }
  }

  List<Map<String, dynamic>> maps(dynamic value) => (value as List? ?? [])
      .map((r) => Map<String, dynamic>.from(r as Map))
      .toList();
  Future<void> load() async {
    final data = await widget.call('/api/v1/channels?includeArchived=true');
    if (!mounted) return;
    channels = maps(data['channels']).where(_matchesView).toList();
    statusKey = 'channelsLoaded';
  }

  bool _matchesView(Map<String, dynamic> channel) {
    final views = channel['views'] as List?;
    if (views == null || views.isEmpty) return !widget.voiceRooms;
    final type = widget.voiceRooms ? 'voice_room' : 'chat';
    return views.any((view) => view is Map && view['type'] == type);
  }

  Future<void> loadMembers({bool append = false}) async {
    final result = await widget.call(
      '/api/v1/space/members${append && memberCursor.isNotEmpty ? '?after=${Uri.encodeQueryComponent(memberCursor)}' : ''}',
    );
    if (!mounted) return;
    if (!append) members = [];
    members.addAll(maps(result['members']));
    memberCursor = result['nextCursor'] as String? ?? '';
  }

  String channelPath(String id) =>
      '/api/v1/channels/${Uri.encodeComponent(id)}';
  Future<void> choose(Map<String, dynamic> channel) async {
    final access = await widget.call(
      '${channelPath(channel['id'] as String)}/access',
    );
    if (!mounted) return;
    if (access['revision'] != channel['revision'])
      throw SpaceApiError(409, strings.channelChanged);
    selected = Map<String, dynamic>.from(channel);
    title.text = channel['title'] as String;
    order.text = '${channel['position'] ?? 0}';
    capacity.text = '${channel['voiceCapacity'] ?? 8}';
    archived = channel['archived'] == true;
    preview = channel['publicPreview'] == true;
    rules = maps(jsonDecode(jsonEncode(access['rules'] ?? [])));
    accessRevision = access['revision'] as String;
    statusKey = 'channelLoaded';
    if (members.isEmpty) await loadMembers();
  }

  Map<String, dynamic> _capacityBody(TextEditingController controller) {
    if (!widget.voiceRooms) return const {};
    final value = int.tryParse(controller.text);
    if (value == null || value < 2 || value > 32) {
      throw StateError(strings.voiceRoomCapacityInvalid);
    }
    return {'voiceCapacity': value};
  }

  List<Widget> _capacityControls(TextEditingController controller) {
    if (!widget.voiceRooms) return const [];
    return [
      field(controller, strings.voiceRoomCapacity, number: true),
      Text(strings.voiceRoomCapacityHelp),
      const SizedBox(height: 16),
    ];
  }

  int position(TextEditingController c) {
    final value = int.tryParse(c.text);
    if (value == null || value < 0 || value > 100000)
      throw StateError(strings.channelOrderInvalid);
    return value;
  }

  String name(TextEditingController c) {
    final value = c.text.trim();
    if (value.isEmpty || utf8.encode(value).length > 320)
      throw StateError(strings.channelNameInvalid);
    return value;
  }

  Future<void> create() async {
    final channelName = name(newTitle);
    final channelPosition = position(newOrder);
    if (newId.text.isEmpty) {
      newId.text =
          '${widget.voiceRooms ? 'voice' : 'chat'}_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';
    }
    final id = newId.text;
    late Map<String, dynamic> result;
    try {
      result = await widget.call(
        '/api/v1/channels',
        method: 'POST',
        body: {
          'channelId': id,
          'title': channelName,
          'position': channelPosition,
          'viewType': widget.voiceRooms ? 'voice_room' : 'chat',
          'publicPreview': false,
          ..._capacityBody(newCapacity),
        },
      );
    } on SpaceApiError catch (e) {
      if (e.status == 409) throw StateError(strings.channelIdTaken);
      rethrow;
    }
    if (!mounted) return;
    newId.clear();
    newTitle.clear();
    await load();
    await choose(Map<String, dynamic>.from(result['channel'] as Map));
    statusKey = 'channelCreated';
  }

  Future<void> deleteChannel() async {
    final channel = selected!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_deleteLabel),
        content: Text(
          widget.voiceRooms
              ? strings.voiceRoomDeleteConfirm(channel['title'] as String)
              : strings.channelDeleteConfirm(channel['title'] as String),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_deleteLabel),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await run(() async {
      await widget.call(
        '${channelPath(channel['id'] as String)}?expectedRevision=${channel['revision']}',
        method: 'DELETE',
      );
      if (!mounted) return;
      selected = null;
      rules = [];
      await load();
      statusKey = 'channelDeleted';
    });
  }

  Future<void> saveChannel() async {
    final c = selected!;
    final result = await widget.call(
      channelPath(c['id'] as String),
      method: 'PATCH',
      body: {
        'title': name(title),
        'position': position(order),
        'archived': archived,
        'publicPreview': preview,
        'expectedRevision': c['revision'],
        ..._capacityBody(capacity),
      },
    );
    if (!mounted) return;
    selected = Map<String, dynamic>.from(result['channel'] as Map);
    // Метаданные и ACL используют одну revision, но несохранённые ACL остаются в форме.
    accessRevision = selected!['revision'] as String;
    await load();
    statusKey = 'channelSaved';
  }

  Future<void> reloadSelected() async {
    final id = selected!['id'];
    await load();
    final c = channels.where((v) => v['id'] == id).firstOrNull;
    if (c == null) throw StateError(strings.channelUnavailable);
    await choose(c);
  }

  void addRule() {
    if (rules.length >= 100) throw StateError(strings.channelRulesLimit);
    final typed = manualPrincipal.text.trim();
    final id = typed.isNotEmpty ? typed : principal ?? '';
    if (subject == 'principal' && !RegExp(r'^u_[0-9a-f]{64}$').hasMatch(id))
      throw StateError(strings.channelMemberRequired);
    if (rules.any(
      (r) => subject == 'principal'
          ? r['principalId'] == id
          : r['role'] == subject,
    ))
      throw StateError(strings.channelRuleDuplicate);
    rules.add({
      if (subject == 'principal') 'principalId': id else 'role': subject,
      'permissions': {
        'visible': true,
        'read': true,
        'write': subject == 'member',
        'manage': false,
      },
    });
    principal = null;
    manualPrincipal.clear();
    statusKey = 'channelRuleAdded';
  }

  void permission(Map<String, dynamic> rule, String field, bool value) {
    final p = Map<String, dynamic>.from(rule['permissions'] as Map? ?? {});
    p[field] = value;
    if (!value && field == 'visible') {
      p['read'] = false;
      p['write'] = false;
      p['manage'] = false;
    }
    if (!value && field == 'read') p['write'] = false;
    if (p['write'] == true) p['read'] = true;
    if (p['read'] == true || p['manage'] == true) p['visible'] = true;
    setState(() => rule['permissions'] = p);
  }

  Future<void> saveAccess() async {
    if (utf8
            .encode(
              jsonEncode({'expectedRevision': accessRevision, 'rules': rules}),
            )
            .length >
        16000)
      throw StateError(strings.channelAccessTooLarge);
    final result = await widget.call(
      '${channelPath(selected!['id'] as String)}/access',
      method: 'PUT',
      body: {'expectedRevision': accessRevision, 'rules': rules},
    );
    if (!mounted) return;
    selected!['revision'] = result['revision'];
    accessRevision = result['revision'] as String;
    rules = maps(result['rules']);
    await load();
    statusKey = 'channelAccessSaved';
  }

  Widget action(
    String label,
    Future<void> Function() call, {
    bool primary = false,
  }) => primary
      ? FilledButton(
          onPressed: busy ? null : () => run(call),
          child: Text(label),
        )
      : OutlinedButton(
          onPressed: busy ? null : () => run(call),
          child: Text(label),
        );
  Widget field(
    TextEditingController c,
    String label, {
    bool number = false,
    Key? key,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      scrollPadding: SpaceContentInsets.scrollPaddingOf(context),
      key: key,
      controller: c,
      enabled: !busy,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    ),
  );
  Widget ruleEditor(Map<String, dynamic> rule, int index) {
    final label = rule['role'] == 'member'
        ? strings.channelMembers
        : rule['role'] == 'reader'
        ? strings.channelReaders
        : rule['principalId'] as String;
    final p = rule['permissions'] as Map? ?? {};
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            for (final entry in {
              'visible': strings.channelVisible,
              'read': widget.voiceRooms
                  ? strings.voiceRoomListen
                  : strings.channelRead,
              'write': widget.voiceRooms
                  ? strings.voiceRoomSpeak
                  : strings.channelWrite,
              'manage': strings.channelManage,
            }.entries)
              CheckboxListTile(
                key: ValueKey('rule-$index-${entry.key}'),
                contentPadding: EdgeInsets.zero,
                title: Text(entry.value),
                value: p[entry.key] == true,
                onChanged: busy
                    ? null
                    : (v) => permission(rule, entry.key, v ?? false),
              ),
            TextButton(
              onPressed: busy
                  ? null
                  : () => setState(() => rules.removeAt(index)),
              child: Text(strings.channelDeleteRule),
            ),
          ],
        ),
      ),
    );
  }

  Widget channelEditor() => _ChannelEditorSurface(
    child: spaceControls(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 32),
          Text(
            strings.channelRevision(
              '${selected!['id']}',
              '${selected!['revision']}',
            ),
            style: const TextStyle(fontSize: 18),
          ),
          field(
            title,
            strings.channelName,
            key: const ValueKey('channel-title'),
          ),
          field(order, strings.channelOrder, number: true),
          ..._capacityControls(capacity),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.voiceRooms
                  ? strings.voiceRoomArchive
                  : strings.channelArchive,
            ),
            value: archived,
            onChanged: busy ? null : (v) => setState(() => archived = v),
          ),
          ..._previewControls(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              action(_saveLabel, saveChannel, primary: true),
              action(strings.channelReload, reloadSelected),
              OutlinedButton(
                onPressed: busy ? null : deleteChannel,
                child: Text(_deleteLabel),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(
            strings.channelAccessRevision('$accessRevision'),
            style: const TextStyle(fontSize: 18),
          ),
          Text(_accessHelp),
          if (rules.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(strings.channelRulesEmpty),
            ),
          for (var i = 0; i < rules.length; i++) ruleEditor(rules[i], i),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: subject,
            decoration: InputDecoration(labelText: strings.channelRuleSubject),
            items: [
              DropdownMenuItem(
                value: 'member',
                child: Text(strings.channelMembers),
              ),
              DropdownMenuItem(
                value: 'reader',
                child: Text(strings.channelReaders),
              ),
              DropdownMenuItem(
                value: 'principal',
                child: Text(strings.channelIndividual),
              ),
            ],
            onChanged: busy ? null : (v) => setState(() => subject = v!),
          ),
          if (subject == 'principal') ..._individualRule(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              action(strings.channelAddRule, () async => addRule()),
              action(strings.channelSaveAccess, saveAccess, primary: true),
            ],
          ),
        ],
      ),
    ),
  );

  String get _panelTitle =>
      widget.voiceRooms ? strings.voiceRoomsTitle : strings.channelsTitle;
  String get _reloadLabel =>
      widget.voiceRooms ? strings.voiceRoomsReload : strings.channelsReload;
  String get _emptyLabel =>
      widget.voiceRooms ? strings.voiceRoomsEmpty : strings.channelsEmpty;
  String get _createSection => widget.voiceRooms
      ? strings.voiceRoomCreate
      : strings.channelCreateSection;
  String get _newTitleLabel =>
      widget.voiceRooms ? strings.voiceRoomNewTitle : strings.channelNewTitle;
  String get _defaultsLabel =>
      widget.voiceRooms ? strings.voiceRoomDefaults : strings.channelDefaults;
  String get _createLabel =>
      widget.voiceRooms ? strings.voiceRoomCreate : strings.channelCreate;
  String get _saveLabel =>
      widget.voiceRooms ? strings.voiceRoomSave : strings.channelSave;
  String get _deleteLabel =>
      widget.voiceRooms ? strings.voiceRoomDelete : strings.channelDelete;
  String get _accessHelp => widget.voiceRooms
      ? strings.voiceRoomAccessHelp
      : strings.channelAccessHelp;

  List<Widget> _previewControls() {
    if (widget.voiceRooms) return [Text(strings.voiceRoomArchiveHelp)];
    return [
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(strings.channelPublicPreview),
        value: preview,
        onChanged: busy ? null : (v) => setState(() => preview = v),
      ),
      Text(strings.channelPreviewHelp),
    ];
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminOperations, AdminOperationState>(
        bloc: operations,
        builder: (context, state) => Card(
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
                    Text(_panelTitle, style: TextStyle(fontSize: 20)),
                    action(_reloadLabel, load),
                  ],
                ),
                const SizedBox(height: 16),
                for (final c in channels) ..._channelEntry(c),
                if (channels.isEmpty && !busy) Text(_emptyLabel),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(_createSection),
                  children: [
                    field(
                      newTitle,
                      _newTitleLabel,
                      key: const ValueKey('new-channel-title'),
                    ),
                    field(newOrder, strings.channelNewOrder, number: true),
                    ..._capacityControls(newCapacity),
                    Text(_defaultsLabel),
                    const SizedBox(height: 16),
                    action(_createLabel, create, primary: true),
                    const SizedBox(height: 24),
                  ],
                ),
                if (busy)
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: LinearProgressIndicator(),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    localizedStatus,
                    key: const ValueKey('channels-status'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  List<Widget> _individualRule() {
    return [
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        key: ValueKey('member-$principal-${members.length}'),
        initialValue: members.any((m) => m['principalId'] == principal)
            ? principal
            : null,
        isExpanded: true,
        decoration: InputDecoration(labelText: strings.channelSelectMember),
        items: [
          for (final m in members.where(
            (v) => ['member', 'reader'].contains(v['role']),
          ))
            DropdownMenuItem(
              value: m['principalId'] as String,
              child: Text(
                '${m['principalId']}${m['blocked'] == true ? strings.channelBlockedSuffix : ''}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: busy
            ? null
            : (v) => setState(() {
                principal = v;
                manualPrincipal.clear();
              }),
      ),
      if (memberCursor.isNotEmpty)
        action(strings.channelMoreMembers, () => loadMembers(append: true)),
      field(manualPrincipal, strings.channelPrincipalId),
    ];
  }

  List<Widget> _channelEntry(Map<String, dynamic> c) {
    return [
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(c['title'] as String),
        subtitle: Text(
          '${c['id']}${c['archived'] == true ? strings.channelArchivedSuffix : ''}',
        ),
        trailing: Icon(
          selected?['id'] == c['id'] ? Icons.expand_less : Icons.expand_more,
        ),
        onTap: busy
            ? null
            : () {
                if (selected?['id'] == c['id']) {
                  setState(() => selected = null);
                } else {
                  run(() => choose(c));
                }
              },
      ),
      if (selected?['id'] == c['id']) channelEditor(),
    ];
  }
}

class _ChannelEditorSurface extends StatefulWidget {
  const _ChannelEditorSurface({required this.child});
  final Widget child;
  @override
  State<_ChannelEditorSurface> createState() => _ChannelEditorSurfaceState();
}

class _ChannelEditorSurfaceState extends State<_ChannelEditorSurface> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            scheme.primary.withValues(alpha: .12),
            scheme.surface,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hovered ? scheme.primary : Colors.transparent,
          ),
        ),
        child: Material(type: MaterialType.transparency, child: widget.child),
      ),
    );
  }
}
