export 'src/server_icon.dart';
export 'src/control_spacing.dart';
import 'src/control_spacing.dart';
export 'src/server_icon_picker.dart';
import 'src/server_icon_picker.dart';
export 'src/recovery_dialogs.dart';
export 'src/recovery_camera_view.dart';
export 'src/pairing_start_view.dart';
export 'src/recovery_tools_view.dart';

import 'package:flutter/material.dart';
import 'package:space_api/space_api.dart';

import 'src/channels_panel.dart';
import 'l10n/admin_localizations.dart';
export 'l10n/admin_localizations.dart';
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

  AdminLocalizations get strings =>
      AdminLocalizations.of(context) ??
      lookupAdminLocalizations(const Locale('ru'));
  SpaceGateway? api;
  Map<String, dynamic>? identity, settings, serverIcon;
  bool iconDirty = false, iconLoading = false;
  bool confirming = false;
  bool busy = false, initialized = true, enabled = true;
  String status = '', policy = 'open';
  String? statusKey;
  String get localizedStatus => switch (statusKey) {
    'settingsConflict' => strings.settingsConflict,
    'setupNeeded' => strings.setupNeeded,
    'roleDenied' => strings.roleDenied,
    'settingsLoaded' => strings.settingsLoaded,
    'settingsSaved' => strings.settingsSaved,
    'deviceRevoked' => strings.deviceRevoked,
    _ => status,
  };
  final title = TextEditingController(),
      chat = TextEditingController(),
      code = TextEditingController();
  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      statusKey = e is SpaceApiError && e.status == 409
          ? 'settingsConflict'
          : null;
      status = e.toString().replaceFirst('Bad state: ', '');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<Map<String, dynamic>> call(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (identity == null || api == null) throw StateError(strings.signInFirst);
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 >
        (identity!['expires'] as num) - 15) {
      final next = await widget.login(create: false);
      if (next['principalId'] != identity!['principalId'] ||
          next['serverId'] != identity!['serverId']) {
        throw StateError(strings.identityChanged);
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
      throw StateError(strings.accessBlocked);
    }
    final setup = await call('/api/v1/space/setup');
    initialized = setup['initialized'] == true;
    if (!initialized) {
      statusKey = 'setupNeeded';
      return;
    }
    if (!['owner', 'admin'].contains(next['role'])) {
      statusKey = 'roleDenied';
      return;
    }
    await load();
  }

  Future<void> load() async {
    final data = await call('/api/v1/space/settings');
    if (!mounted) return;
    settings = data['settings'] as Map<String, dynamic>;
    serverIcon = settings!['icon'] is Map
        ? Map<String, dynamic>.from(settings!['icon'] as Map)
        : null;
    iconDirty = false;
    title.text = settings!['title'] as String;
    chat.text = settings!['chatTitle'] as String;
    enabled = settings!['chatEnabled'] == true;
    policy = settings!['registrationPolicy'] as String;
    statusKey = 'settingsLoaded';
  }

  Future<void> save() async {
    if (title.text.trim().isEmpty) {
      throw StateError(strings.bothNames);
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
        if (iconDirty) 'icon': serverIcon,
      },
    );
    settings = data['settings'] as Map<String, dynamic>;
    serverIcon = settings!['icon'] is Map
        ? Map<String, dynamic>.from(settings!['icon'] as Map)
        : null;
    iconDirty = false;
    statusKey = 'settingsSaved';
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
      child: spaceControls(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
  Widget button(String label, Future<void> Function() action) => FilledButton(
    onPressed: busy || iconLoading ? null : () => run(action),
    child: Text(label),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: localizedStatus.isEmpty && !busy
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
                    Text(localizedStatus, key: const ValueKey('admin-status')),
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
                    tooltip: strings.closeManagement,
                    icon: const Icon(Icons.close),
                  ),
                ),
              Text(
                strings.managementTitle,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(strings.managementIntro),
              ),
              const SizedBox(height: 20),
              if (identity == null)
                card([
                  Text(strings.deviceIdentity, style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 12),
                  Text(
                    widget.autoConnect
                        ? strings.currentConnection
                        : strings.currentSession,
                  ),
                  const SizedBox(height: 16),
                  button(strings.connectManagement, () => signIn(false)),
                ]),
              if (identity != null && !initialized)
                card([
                  Text(strings.claimOwner, style: TextStyle(fontSize: 20)),
                  Text(strings.setupHelp),
                  const SizedBox(height: 16),
                  TextField(
                    controller: code,
                    obscureText: true,
                    decoration: InputDecoration(labelText: strings.setupCode),
                  ),
                  const SizedBox(height: 16),
                  button(strings.confirmOwner, () async {
                    if (widget.authorizeDevice != null &&
                        identity!['administrative'] != true) {
                      throw StateError(strings.authorizeFirst);
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
                  Text(strings.authorizeTitle, style: TextStyle(fontSize: 20)),
                  Text(strings.authorizeHelp),
                  button(strings.authorizeDevice, () async {
                    var password = '';
                    setState(() => confirming = true);
                    final accepted = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(strings.authorizeConfirm),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(strings.authorizeDetails),
                            if (identity!['hasRootAuthority'] != true)
                              TextField(
                                obscureText: true,
                                onChanged: (v) => password = v,
                                decoration: InputDecoration(
                                  labelText: strings.rootPassword,
                                ),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(strings.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(strings.allow),
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
                    strings.settingsRevision('${settings!['revision']}'),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  if (settings!.containsKey('icon')) ...[
                    ServerIconPicker(
                      value: serverIcon,
                      disabled: busy,
                      onChanged: (value) => setState(() {
                        serverIcon = value;
                        iconDirty = true;
                      }),
                      onPending: (value) => setState(() => iconLoading = value),
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                    Text(
                      strings.serverIconTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(strings.serverIconUpgrade),
                    const SizedBox(height: 20),
                  ],
                  TextField(
                    controller: title,
                    maxLength: 80,
                    decoration: InputDecoration(labelText: strings.spaceName),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: enabled,
                    onChanged: busy ? null : (v) => setState(() => enabled = v),
                    title: Text(strings.chatsEnabled),
                    subtitle: Text(strings.chatsHelp),
                  ),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    key: ValueKey(policy),
                    initialValue: policy,
                    decoration: InputDecoration(
                      labelText: strings.registration,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'open',
                        child: Text(strings.registrationOpen),
                      ),
                      DropdownMenuItem(
                        value: 'closed',
                        child: Text(strings.registrationClosed),
                      ),
                    ],
                    onChanged: busy ? null : (v) => setState(() => policy = v!),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      button(strings.saveSettings, save),
                      OutlinedButton(
                        onPressed: busy ? null : () => run(load),
                        child: Text(strings.reloadSettings),
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
                      statusKey = 'deviceRevoked';
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
