import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:space_api/space_api.dart';

typedef AdminCall = Future<Map<String, dynamic>> Function(
  String path, {
  Map<String, dynamic>? body,
  String? method,
});

class ChannelsPanel extends StatefulWidget {
  const ChannelsPanel({super.key, required this.call});
  final AdminCall call;
  @override
  State<ChannelsPanel> createState() => _ChannelsPanelState();
}

class _ChannelsPanelState extends State<ChannelsPanel> {
  List<Map<String, dynamic>> channels = [], members = [], rules = [];
  Map<String, dynamic>? selected;
  String status = '', subject = 'member', memberCursor = '';
  String? principal, accessRevision;
  bool busy = false, archived = false, preview = false;
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
      newId,
      newTitle,
      newOrder,
      title,
      order,
      manualPrincipal,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      status = e is SpaceApiError && e.status == 409
          ? 'Канал или права уже изменены. Загрузите их заново; несохранённые поля остаются в форме.'
          : e.toString().replaceFirst('Bad state: ', '');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  List<Map<String, dynamic>> maps(dynamic value) => (value as List? ?? [])
      .map((r) => Map<String, dynamic>.from(r as Map))
      .toList();
  Future<void> load() async {
    final data = await widget.call('/api/v1/channels?includeArchived=true');
    if (!mounted) return;
    channels = maps(data['channels']);
    status = 'Каналы загружены.';
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
      throw SpaceApiError(409, 'Канал изменился между загрузкой списка и прав');
    selected = Map<String, dynamic>.from(channel);
    title.text = channel['title'] as String;
    order.text = '${channel['position'] ?? 0}';
    archived = channel['archived'] == true;
    preview = channel['publicPreview'] == true;
    rules = maps(jsonDecode(jsonEncode(access['rules'] ?? [])));
    accessRevision = access['revision'] as String;
    status = 'Канал и права загружены.';
    if (members.isEmpty) await loadMembers();
  }

  int position(TextEditingController c) {
    final value = int.tryParse(c.text);
    if (value == null || value < 0 || value > 100000)
      throw StateError('Порядок должен быть от 0 до 100000');
    return value;
  }

  String name(TextEditingController c) {
    final value = c.text.trim();
    if (value.isEmpty || utf8.encode(value).length > 320)
      throw StateError('Укажите название до 320 байт');
    return value;
  }

  Future<void> create() async {
    final id = newId.text.trim();
    if (!RegExp(r'^[a-z][a-z0-9_-]{0,63}$').hasMatch(id))
      throw StateError(
        'Адрес: латинские буквы, цифры, _ или -, начиная с буквы',
      );
    late Map<String, dynamic> result;
    try {
      result = await widget.call(
        '/api/v1/channels',
        method: 'POST',
        body: {
          'channelId': id,
          'title': name(newTitle),
          'position': position(newOrder),
          'viewType': 'chat',
          'publicPreview': false,
        },
      );
    } on SpaceApiError catch (e) {
      if (e.status == 409)
        throw StateError(
          'Канал с таким адресом уже существует. Выберите другой адрес.',
        );
      rethrow;
    }
    if (!mounted) return;
    newId.clear();
    newTitle.clear();
    await load();
    await choose(Map<String, dynamic>.from(result['channel'] as Map));
    status = 'Канал создан.';
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
      },
    );
    if (!mounted) return;
    selected = Map<String, dynamic>.from(result['channel'] as Map);
    // Метаданные и ACL используют одну revision, но несохранённые ACL остаются в форме.
    accessRevision = selected!['revision'] as String;
    await load();
    status = 'Настройки канала сохранены.';
  }

  Future<void> reloadSelected() async {
    final id = selected!['id'];
    await load();
    final c = channels.where((v) => v['id'] == id).firstOrNull;
    if (c == null) throw StateError('Канал больше не доступен');
    await choose(c);
  }

  void addRule() {
    if (rules.length >= 100) throw StateError('Лимит: 100 правил');
    final typed = manualPrincipal.text.trim();
    final id = typed.isNotEmpty ? typed : principal ?? '';
    if (subject == 'principal' && !RegExp(r'^u_[0-9a-f]{64}$').hasMatch(id))
      throw StateError(
        'Выберите участника или укажите его полный идентификатор',
      );
    if (rules.any(
      (r) => subject == 'principal'
          ? r['principalId'] == id
          : r['role'] == subject,
    ))
      throw StateError('Правило для этого участника или роли уже есть');
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
    status = 'Правило добавлено в форму. Сохраните права для применения.';
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
      throw StateError(
        'Список прав слишком большой для одного запроса. Сократите число индивидуальных правил.',
      );
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
    status = 'Права канала сохранены.';
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
      key: key,
      controller: c,
      enabled: !busy,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    ),
  );
  Widget ruleEditor(Map<String, dynamic> rule, int index) {
    final label = rule['role'] == 'member'
        ? 'Участники'
        : rule['role'] == 'reader'
        ? 'Читатели'
        : rule['principalId'] as String;
    final p = rule['permissions'] as Map? ?? {};
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            for (final entry in {
              'visible': 'Видеть канал',
              'read': 'Читать сообщения',
              'write': 'Отправлять сообщения',
              'manage': 'Управлять каналом',
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
              child: const Text('Удалить правило'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              const Text('Каналы и права', style: TextStyle(fontSize: 20)),
              action('Обновить список каналов', load),
            ],
          ),
          const SizedBox(height: 12),
          for (final c in channels)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(c['title'] as String),
              subtitle: Text(
                '${c['id']}${c['archived'] == true ? ' · Архив' : ''}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: busy ? null : () => run(() => choose(c)),
            ),
          if (channels.isEmpty && !busy) const Text('Каналов пока нет.'),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('Создать чат-канал'),
            children: [
              field(
                newId,
                'Адрес нового канала',
                key: const ValueKey('new-channel-id'),
              ),
              field(
                newTitle,
                'Название нового канала',
                key: const ValueKey('new-channel-title'),
              ),
              field(newOrder, 'Порядок нового канала', number: true),
              const Text(
                'Участники смогут читать и писать, читатели — читать. Публичный предпросмотр выключен.',
              ),
              const SizedBox(height: 12),
              action('Создать канал', create, primary: true),
            ],
          ),
          if (selected != null) ...[
            const Divider(height: 32),
            Text(
              'Канал ${selected!['id']} · версия ${selected!['revision']}',
              style: const TextStyle(fontSize: 18),
            ),
            field(
              title,
              'Название канала',
              key: const ValueKey('channel-title'),
            ),
            field(order, 'Порядок канала', number: true),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Архивировать канал'),
              value: archived,
              onChanged: busy ? null : (v) => setState(() => archived = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Показывать название посетителям без входа'),
              value: preview,
              onChanged: busy ? null : (v) => setState(() => preview = v),
            ),
            const Text(
              'Предпросмотр раскрывает название и адрес, но не сообщения. Архив сохраняет историю и запрещает новую запись.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                action('Сохранить канал', saveChannel, primary: true),
                action('Загрузить канал заново', reloadSelected),
              ],
            ),
            const Divider(height: 32),
            Text(
              'Права канала · версия $accessRevision',
              style: const TextStyle(fontSize: 18),
            ),
            const Text(
              'Индивидуальное правило заменяет правило роли. Владелец и администраторы сохраняют доступ. Читатель не получает отправку. «Управлять» меняет метаданные, но не права.',
            ),
            if (rules.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Правил нет: доступ только у администрации.'),
              ),
            for (var i = 0; i < rules.length; i++) ruleEditor(rules[i], i),
            DropdownButtonFormField<String>(
              initialValue: subject,
              decoration: const InputDecoration(
                labelText: 'Кому добавить правило',
              ),
              items: const [
                DropdownMenuItem(value: 'member', child: Text('Участники')),
                DropdownMenuItem(value: 'reader', child: Text('Читатели')),
                DropdownMenuItem(
                  value: 'principal',
                  child: Text('Отдельный участник'),
                ),
              ],
              onChanged: busy ? null : (v) => setState(() => subject = v!),
            ),
            if (subject == 'principal') ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey('member-$principal-${members.length}'),
                initialValue: members.any((m) => m['principalId'] == principal)
                    ? principal
                    : null,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Выберите участника',
                ),
                items: [
                  for (final m in members.where(
                    (v) => ['member', 'reader'].contains(v['role']),
                  ))
                    DropdownMenuItem(
                      value: m['principalId'] as String,
                      child: Text(
                        '${m['principalId']}${m['blocked'] == true ? ' · Заблокирован' : ''}',
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
                action(
                  'Загрузить ещё участников',
                  () => loadMembers(append: true),
                ),
              field(manualPrincipal, 'Или полный идентификатор участника'),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                action('Добавить правило', () async => addRule()),
                action('Сохранить права', saveAccess, primary: true),
              ],
            ),
          ],
          if (busy)
            const Padding(
              padding: EdgeInsets.all(12),
              child: LinearProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(status, key: const ValueKey('channels-status')),
          ),
        ],
      ),
    ),
  );
}
