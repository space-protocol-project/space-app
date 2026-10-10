import 'package:flutter/material.dart';
import 'package:space_api/space_api.dart';

import 'channels_panel.dart';

String memberRoleLabel(String role) =>
    {
      'owner': 'Владелец',
      'admin': 'Администратор',
      'member': 'Участник',
      'reader': 'Читатель',
    }[role] ??
    role;

class MembersPanel extends StatefulWidget {
  const MembersPanel({super.key, required this.call, required this.owner});
  final AdminCall call;
  final bool owner;
  @override
  State<MembersPanel> createState() => _MembersPanelState();
}

class _MembersPanelState extends State<MembersPanel> {
  final members = <Map<String, dynamic>>[];
  final drafts = <String, Map<String, dynamic>>{};
  final search = TextEditingController();
  bool busy = false;
  String cursor = '', status = '';
  String? editing;
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
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      status = e is SpaceApiError && e.status == 409
          ? 'Права уже изменились. Несохранённые значения остаются в форме. Обновите участников перед повтором.'
          : e.toString().replaceFirst('Bad state: ', '');
      if (e is SpaceApiError && [401, 403].contains(e.status)) {
        members.clear();
        drafts.clear();
        cursor = '';
      }
    } finally {
      if (mounted) setState(() => busy = false);
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
      drafts.putIfAbsent(id, () => Map<String, dynamic>.from(m));
    }
    cursor = data['nextCursor'] as String? ?? '';
    status = 'Участники загружены.';
  }

  Future<void> save(Map<String, dynamic> m) async {
    final id = m['principalId'] as String;
    final draft = drafts[id]!;
    final proposal = Map<String, dynamic>.from(draft);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить права участника?'),
        content: Text(
          '$id\nРоль: ${memberRoleLabel(proposal['role'] as String)}\nДоступ: ${proposal['blocked'] == true ? 'заблокирован' : 'разрешён'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Применить права'),
          ),
        ],
      ),
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
        },
      );
      if (!mounted) return;
      final saved = Map<String, dynamic>.from(result['member'] as Map);
      members[members.indexWhere((v) => v['principalId'] == id)] = saved;
      drafts[id] = Map<String, dynamic>.from(saved);
      status = 'Права участника сохранены. Сервер применяет их к действиям и подпискам.';
    });
  }

  Widget editor(Map<String, dynamic> m) {
    final id = m['principalId'] as String;
    final draft = drafts[id]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(
            id,
            style: const TextStyle(fontSize: 12, fontFamily: 'JetBrains Mono'),
          ),
          Text(
            '${memberRoleLabel(m['role'] as String)}${m['blocked'] == true ? ' · Доступ заблокирован' : ''}',
          ),
          if (widget.owner && m['role'] != 'owner')
            TextButton(
              key: ValueKey('edit-member-$id'),
              onPressed: busy
                  ? null
                  : () => setState(() => editing = editing == id ? null : id),
              child: Text(editing == id ? 'Свернуть права' : 'Изменить права'),
            ),
          if (widget.owner && m['role'] != 'owner' && editing == id) ...[
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: ValueKey('role-$id-${m['revision']}'),
              initialValue: draft['role'] as String,
              decoration: const InputDecoration(labelText: 'Роль участника'),
              items: [
                for (final role in ['reader', 'member', 'admin'])
                  DropdownMenuItem(
                    value: role,
                    child: Text(memberRoleLabel(role)),
                  ),
              ],
              onChanged: busy ? null : (v) => setState(() => draft['role'] = v),
            ),
            SwitchListTile(
              key: ValueKey('blocked-$id'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Заблокировать участника'),
              value: draft['blocked'] == true,
              onChanged: busy
                  ? null
                  : (v) => setState(() => draft['blocked'] = v),
            ),
            OutlinedButton(
              key: ValueKey('save-member-$id'),
              onPressed: busy ? null : () => save(m),
              child: const Text('Сохранить права участника'),
            ),
          ],
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = search.text.trim().toLowerCase();
    final filtered = members
        .where(
          (m) =>
              '${m['principalId']} ${m['role']} ${memberRoleLabel(m['role'] as String)} ${m['blocked'] == true ? 'заблокирован' : ''}'
                  .toLowerCase()
                  .contains(query),
        )
        .toList();
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                const Text('Участники', style: TextStyle(fontSize: 20)),
                OutlinedButton(
                  onPressed: busy ? null : () => run(() => load()),
                  child: const Text('Обновить участников'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Роли и блокировку меняет только владелец. Администраторы могут просматривать список.',
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('member-search'),
              controller: search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Поиск по идентификатору или роли',
              ),
            ),
            Text(
              'Загружено: ${members.length}. Поиск работает по загруженным участникам.',
            ),
            for (final m in filtered) editor(m),
            if (filtered.isEmpty && !busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Участники не найдены.'),
              ),
            if (cursor.isNotEmpty)
              OutlinedButton(
                onPressed: busy ? null : () => run(() => load(append: true)),
                child: const Text('Загрузить ещё участников'),
              ),
            if (busy) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Semantics(
                container: true,
                liveRegion: true,
                child: Text(status, key: const ValueKey('members-status')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
