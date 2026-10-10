export 'src/recovery_dialogs.dart';
export 'src/recovery_camera_view.dart';
export 'src/pairing_start_view.dart';
export 'src/recovery_tools_view.dart';

import 'package:flutter/material.dart';
import 'package:space_api/space_api.dart';

import 'src/channels_panel.dart';
import 'src/members_panel.dart';
import 'src/invites_panel.dart';
import 'src/devices_panel.dart';
export 'src/devices_panel.dart';
export 'src/members_panel.dart';
export 'src/invites_panel.dart';
export 'src/channels_panel.dart';

typedef IdentityLogin = Future<Map<String, dynamic>> Function({bool create});

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
    required this.login,
    required this.gateway,
    this.autoConnect = false,
    this.onClose,
    this.revokeDevice,
    this.authorizeDevice,
    this.onDeviceRevoked,
  });
  final IdentityLogin login;
  final DeviceRevoke? revokeDevice;
  final Future<void> Function(String password)? authorizeDevice;
  final VoidCallback? onDeviceRevoked;
  final VoidCallback? onClose;
  final bool autoConnect;
  final SpaceGateway Function(Uri) gateway;
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    if (widget.autoConnect)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) run(() => signIn(false));
      });
  }

  SpaceGateway? api;
  Map<String, dynamic>? identity, settings;
  bool confirming = false;
  bool busy = false, initialized = true, enabled = true;
  String status = '', policy = 'open';
  final title = TextEditingController(),
      chat = TextEditingController(),
      code = TextEditingController();
  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      status = e is SpaceApiError && e.status == 409
          ? 'Настройки уже изменены. Загрузите их заново и повторите изменения.'
          : e.toString().replaceFirst('Bad state: ', '');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<Map<String, dynamic>> call(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (identity == null || api == null) throw StateError('Сначала войдите');
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 >
        (identity!['expires'] as num) - 15) {
      final next = await widget.login(create: false);
      if (next['principalId'] != identity!['principalId'] ||
          next['serverId'] != identity!['serverId']) {
        throw StateError('Идентичность изменилась. Войдите заново');
      }
      identity = next;
    }
    return api!.call(
      path,
      token: identity!['token'] as String,
      body: body,
      method: method,
    );
  }

  Future<void> signIn(bool create) async {
    final next = await widget.login(create: create);
    if (!mounted) return;
    api?.close();
    api = widget.gateway(Uri.parse(next['origin'] as String));
    identity = next;
    if (next['blocked'] == true) {
      throw StateError('Доступ к пространству заблокирован');
    }
    final setup = await call('/api/v1/space/setup');
    initialized = setup['initialized'] == true;
    if (!initialized) {
      status = 'Устройство вошло. Укажите одноразовый код сервера для назначения владельца.';
      return;
    }
    if (!['owner', 'admin'].contains(next['role'])) {
      status = 'Вход выполнен, но ваша роль не разрешает настройку сервера.';
      return;
    }
    await load();
  }

  Future<void> load() async {
    final data = await call('/api/v1/space/settings');
    if (!mounted) return;
    settings = data['settings'] as Map<String, dynamic>;
    title.text = settings!['title'] as String;
    chat.text = settings!['chatTitle'] as String;
    enabled = settings!['chatEnabled'] == true;
    policy = settings!['registrationPolicy'] as String;
    status = 'Настройки загружены с сервера.';
  }

  Future<void> save() async {
    if (title.text.trim().isEmpty || chat.text.trim().isEmpty) {
      throw StateError('Укажите оба названия');
    }
    final data = await call(
      '/api/v1/space/settings',
      method: 'PATCH',
      body: {
        'title': title.text.trim(),
        'chatTitle': chat.text.trim(),
        'chatEnabled': enabled,
        'registrationPolicy': policy,
        'expectedRevision': settings!['revision'],
      },
    );
    settings = data['settings'] as Map<String, dynamic>;
    status = 'Настройки сохранены на сервере.';
  }

  @override
  void dispose() {
    api?.close();
    title.dispose();
    chat.dispose();
    code.dispose();
    super.dispose();
  }

  Widget card(List<Widget> children) => Card(
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    ),
  );
  Widget button(String label, Future<void> Function() action) => FilledButton(
    onPressed: busy ? null : () => run(action),
    child: Text(label),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: status.isEmpty && !busy
        ? null
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Semantics(
                container: true,
                liveRegion: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (busy && !confirming) const LinearProgressIndicator(),
                    Text(status, key: const ValueKey('admin-status')),
                  ],
                ),
              ),
            ),
          ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (widget.onClose != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: widget.onClose,
                    tooltip: 'Закрыть управление',
                    icon: const Icon(Icons.close),
                  ),
                ),
              const Text(
                'Управление пространством',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Ваш сервер. Ваши правила. На новом сервере первый успешный вход назначает владельца.',
                ),
              ),
              const Text(
                'Настройки, каналы, участники, приглашения и устройства выбранного сервера.',
              ),
              const SizedBox(height: 20),
              if (identity == null)
                card([
                  const Text(
                    'Текущая идентичность устройства',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.autoConnect
                        ? 'Используется идентичность текущего подключения. Дополнительный аккаунт не нужен.'
                        : 'Используется текущая сессия приложения Space. Для восстановления откройте раздел идентичности.',
                  ),
                  const SizedBox(height: 16),
                  button(
                    'Подключить управление текущим сервером',
                    () => signIn(false),
                  ),
                ]),
              if (identity != null && !initialized)
                card([
                  const Text(
                    'Назначить первого владельца',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Получите код в консоли сервера: space-server -setup-code. Он действует 15 минут.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: code,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Одноразовый код сервера',
                    ),
                  ),
                  const SizedBox(height: 16),
                  button('Подтвердить владение', () async {
                    if (widget.authorizeDevice != null &&
                        identity!['administrative'] != true) {
                      throw StateError(
                        'Сначала явно выдайте разрешение этому устройству в блоке ниже',
                      );
                    }
                    final value = code.text;
                    code.clear();
                    await call(
                      '/api/v1/space/setup/claim',
                      body: {'setupCode': value},
                    );
                    initialized = true;
                    identity!['role'] = 'owner';
                    await load();
                  }),
                ]),
              if (identity != null &&
                  widget.authorizeDevice != null &&
                  (['owner', 'admin'].contains(identity!['role']) ||
                      !initialized) &&
                  identity!['administrative'] != true)
                card([
                  const Text(
                    'Разрешить этому устройству управление сервером',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Разрешение space.manage подписывается вашим корневым ключом. Оно действует вместе с ролью владельца или администратора.',
                  ),
                  button('Выдать разрешение этому устройству', () async {
                    var password = '';
                    setState(() => confirming = true);
                    final accepted = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Разрешить управление сервером?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Вы явно разрешаете этому устройству менять настройки, каналы и доступ участников.',
                            ),
                            if (identity!['hasRootAuthority'] != true)
                              TextField(
                                obscureText: true,
                                onChanged: (v) => password = v,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Пароль корневой карточки JSON/PNG',
                                ),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Отмена'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Разрешить'),
                          ),
                        ],
                      ),
                    );
                    if (mounted) setState(() => confirming = false);
                    if (accepted != true) return;
                    await widget.authorizeDevice!(password);
                    password = '';
                    await signIn(false);
                  }),
                ]),
              if (settings != null)
                card([
                  Text(
                    'Настройки пространства · версия ${settings!['revision']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: title,
                    maxLength: 80,
                    decoration: const InputDecoration(
                      labelText: 'Название пространства',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: chat,
                    maxLength: 80,
                    decoration: const InputDecoration(
                      labelText: 'Название общего чата',
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: enabled,
                    onChanged: busy ? null : (v) => setState(() => enabled = v),
                    title: const Text('Чаты доступны участникам'),
                    subtitle: const Text(
                      'Выключение закрывает чтение и отправку. История сохраняется.',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    key: ValueKey(policy),
                    initialValue: policy,
                    decoration: const InputDecoration(labelText: 'Регистрация'),
                    items: const [
                      DropdownMenuItem(value: 'open', child: Text('Открыта')),
                      DropdownMenuItem(
                        value: 'closed',
                        child: Text('По приглашению'),
                      ),
                    ],
                    onChanged: busy ? null : (v) => setState(() => policy = v!),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      button('Сохранить настройки', save),
                      OutlinedButton(
                        onPressed: busy ? null : () => run(load),
                        child: const Text('Загрузить заново'),
                      ),
                    ],
                  ),
                ]),
              if (settings != null) ...[
                const SizedBox(height: 20),
                ChannelsPanel(
                  key: ValueKey(
                    "${identity?['serverId']}|${identity?['principalId']}",
                  ),
                  call: call,
                ),
              ],
              if (settings != null) ...[
                const SizedBox(height: 20),
                MembersPanel(
                  key: ValueKey(
                    'members-${identity?['serverId']}-${identity?['principalId']}',
                  ),
                  call: call,
                  owner: identity?['role'] == 'owner',
                ),
                const SizedBox(height: 20),
                InvitesPanel(
                  key: ValueKey(
                    'invites-${identity?['serverId']}-${identity?['principalId']}',
                  ),
                  call: call,
                  origin: identity!['origin'] as String,
                  tlsFingerprint: api?.tlsFingerprint ?? '',
                ),
              ],
              if (identity != null && widget.revokeDevice != null) ...[
                const SizedBox(height: 20),
                DevicesPanel(
                  key: ValueKey(
                    'devices-${identity?['serverId']}-${identity?['principalId']}',
                  ),
                  call: call,
                  currentGrantId: identity!['grantId'] as String? ?? '',
                  hasRootAuthority: identity!['hasRootAuthority'] == true,
                  revoke: widget.revokeDevice!,
                  onRevoked: () {
                    setState(() {
                      identity = null;
                      settings = null;
                      status = 'Это устройство отозвано. Восстановите доступ или используйте другое устройство.';
                    });
                    widget.onDeviceRevoked?.call();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
