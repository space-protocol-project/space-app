import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_api/space_api.dart';

import 'channels_panel.dart';
import 'members_panel.dart';

class InvitesPanel extends StatefulWidget {
  const InvitesPanel({
    super.key,
    required this.call,
    required this.origin,
    this.tlsFingerprint = '',
  });
  final String tlsFingerprint;
  final AdminCall call;
  final String origin;
  @override
  State<InvitesPanel> createState() => _InvitesPanelState();
}

class _InvitesPanelState extends State<InvitesPanel> {
  final invites = <Map<String, dynamic>>[];
  final uses = TextEditingController(text: '1');
  bool busy = false;
  String role = 'member', cursor = '', status = '', token = '', issuedId = '';
  int ttl = 86400;
  String get link => Uri.parse(widget.origin)
      .replace(
        fragment: Uri(
          queryParameters: {
            'invite': token,
            if (widget.tlsFingerprint.isNotEmpty) 'tls': widget.tlsFingerprint,
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
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      status = e.toString().replaceFirst('Bad state: ', '');
      if (e is SpaceApiError && [401, 403].contains(e.status)) {
        token = '';
        issuedId = '';
        invites.clear();
        cursor = '';
      }
    } finally {
      if (mounted) setState(() => busy = false);
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
    status = 'Приглашения загружены.';
  }

  Future<void> create() async {
    final count = int.tryParse(uses.text);
    if (count == null || count < 1 || count > 100)
      throw StateError('Укажите число использований от 1 до 100');
    final result = await widget.call(
      '/api/v1/space/invites',
      method: 'POST',
      body: {'role': role, 'ttlSeconds': ttl, 'maxUses': count},
    );
    if (!mounted) return;
    token = result['token'] as String;
    issuedId = (result['invite'] as Map)['id'] as String;
    await load();
    status = 'Приглашение создано. Скопируйте код или ссылку сейчас.';
  }

  Future<void> copy(String value) async {
    try {
      await Clipboard.setData(ClipboardData(text: value));
      status = 'Скопировано в буфер обмена.';
    } catch (_) {
      status = 'Копирование недоступно. Выделите код или ссылку и скопируйте вручную.';
    }
  }

  Future<void> revoke(Map<String, dynamic> invite) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отозвать приглашение?'),
        content: const Text(
          'Новые вступления по нему будут запрещены. Уже вступившие участники сохранят доступ.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Отозвать приглашение'),
          ),
        ],
      ),
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
      status =
          'Приглашение отозвано. Доступ уже вступивших участников не изменён.';
    });
  }

  String expiry(Map<String, dynamic> invite) {
    final d = DateTime.fromMillisecondsSinceEpoch(
      int.parse('${invite['expiresAt']}') * 1000,
    ).toLocal();
    String two(int n) => '$n'.padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  String state(Map<String, dynamic> invite) => invite['revoked'] == true
      ? 'Отозвано'
      : int.parse('${invite['expiresAt']}') <=
            DateTime.now().millisecondsSinceEpoch ~/ 1000
      ? 'Истекло'
      : (invite['uses'] as num? ?? 0) >= (invite['maxUses'] as num)
      ? 'Использовано'
      : 'Действует';
  @override
  Widget build(BuildContext context) => Card(
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
              const Text('Приглашения', style: TextStyle(fontSize: 20)),
              OutlinedButton(
                onPressed: busy ? null : () => run(() => load()),
                child: const Text('Обновить приглашения'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Владелец и администраторы выдают приглашения участникам и читателям. Роль существующего участника приглашение не меняет.',
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: role,
            decoration: const InputDecoration(labelText: 'Роль приглашённого'),
            items: const [
              DropdownMenuItem(
                value: 'member',
                child: Text(
                  'Участник — читает и пишет',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: 'reader',
                child: Text(
                  'Читатель — только чтение',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: busy ? null : (v) => setState(() => role = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: ttl,
            decoration: const InputDecoration(labelText: 'Срок приглашения'),
            items: const [
              DropdownMenuItem(value: 60, child: Text('1 минута')),
              DropdownMenuItem(value: 3600, child: Text('1 час')),
              DropdownMenuItem(value: 86400, child: Text('1 день')),
              DropdownMenuItem(value: 604800, child: Text('7 дней')),
            ],
            onChanged: busy ? null : (v) => setState(() => ttl = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('invite-max-uses'),
            controller: uses,
            enabled: !busy,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Число использований (1–100)',
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: busy ? null : () => run(create),
            child: const Text('Создать приглашение'),
          ),
          if (token.isNotEmpty) ...[
            const Divider(height: 28),
            const Text('Код нового приглашения'),
            SelectableText(token, key: const ValueKey('issued-invite-token')),
            const SizedBox(height: 12),
            const Text('Ссылка для браузера'),
            SelectableText(link, key: const ValueKey('issued-invite-link')),
            const Text(
              'Код показывается только сейчас и хранится в памяти формы. Локальная ссылка работает на этом компьютере или через настроенный SSH-туннель.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton(
                  onPressed: busy ? null : () => run(() => copy(token)),
                  child: const Text('Копировать код'),
                ),
                OutlinedButton(
                  onPressed: busy ? null : () => run(() => copy(link)),
                  child: const Text('Копировать ссылку'),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () => setState(() {
                          token = '';
                          issuedId = '';
                        }),
                  child: const Text('Скрыть код'),
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
                    '${memberRoleLabel(invite['role'] as String)} · ${state(invite)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'До ${expiry(invite)} по времени устройства · использований ${invite['uses'] ?? 0}/${invite['maxUses']}',
                  ),
                  if (active(invite))
                    OutlinedButton(
                      key: ValueKey('revoke-${invite['id']}'),
                      onPressed: busy ? null : () => revoke(invite),
                      child: const Text('Отозвать приглашение'),
                    ),
                  const Divider(),
                ],
              ),
            ),
          if (invites.isEmpty && !busy) const Text('Приглашений пока нет.'),
          if (cursor.isNotEmpty)
            OutlinedButton(
              onPressed: busy ? null : () => run(() => load(append: true)),
              child: const Text('Загрузить ещё приглашения'),
            ),
          if (busy) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Semantics(
              container: true,
              liveRegion: true,
              child: Text(status, key: const ValueKey('invites-status')),
            ),
          ),
        ],
      ),
    ),
  );
}
