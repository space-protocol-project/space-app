import 'package:space_admin_ui/space_admin_ui.dart' show ServerIconView;

import 'home_operation_progress.dart';
import '../l10n/failure_strings.dart';
import '../l10n/strings.dart';
import 'admin_panel.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/chat_controller.dart';
import '../src/preferences.dart';
import '../src/secure_vault.dart';
import '../src/home_controller.dart';
import '../src/server_presence.dart';
import '../src/server_workspaces.dart';
import 'dashboard.dart';
import 'device_panel.dart';
import 'home_panel.dart';
import 'space_setup_wizard.dart';
import 'chat_view.dart';
import 'connection_panel.dart';
import 'panels.dart';
import 'search.dart';
import 'components.dart';

enum Section {
  overview(Icons.home_outlined),
  chat(Icons.tag),
  forum(Icons.forum_outlined),
  feed(Icons.view_agenda_outlined),
  rooms(Icons.headset_mic_outlined),
  identity(Icons.shield_outlined),
  settings(Icons.settings_suggest_outlined);

  const Section(this.icon);
  final IconData icon;
  String localized(BuildContext context) => switch (this) {
    Section.overview => context.strings.overview,
    Section.chat => context.strings.chat,
    Section.forum => context.strings.forum,
    Section.feed => context.strings.feed,
    Section.rooms => context.strings.rooms,
    Section.identity => context.strings.identity,
    Section.settings => context.strings.manageSpace,
  };
}

class SpaceShell extends StatefulWidget {
  const SpaceShell({
    super.key,
    required this.preferences,
    this.controller,
    this.presence,
    this.workspaces,
  });
  final AppPreferences preferences;
  final ChatController? controller;
  final ServerPresence? presence;
  final ServerWorkspaces? workspaces;
  @override
  State<SpaceShell> createState() => _SpaceShellState();
}

class _SpaceShellState extends State<SpaceShell> {
  late final ChatController initialController =
      widget.controller ?? ChatController(SecureIdentityVault());
  ChatController? activeController;
  final transientControllers = <ChatController>{};
  ChatController createTransient() {
    final target = ChatController(initialController.vault);
    transientControllers.add(target);
    return target;
  }

  late final deviceController = createTransient();

  ChatController get controller => activeController ?? initialController;
  late final workspaces =
      widget.workspaces ?? ServerWorkspaces(vault: initialController.vault);
  bool dashboard = true;
  bool applicationSettings = false;
  bool devicePage = false;
  void showDevice() {
    setState(() {
      devicePage = true;
      dashboard = true;
      applicationSettings = false;
    });
    scaffold.currentState?.closeDrawer();
  }

  void showDashboard() {
    setState(() {
      applicationSettings = false;
      devicePage = false;
      dashboard = true;
      selected = Section.overview;
    });
    scaffold.currentState?.closeDrawer();
  }

  Future<void> openSpace(String origin, {String? channel}) async {
    workspaces.synchronize([origin]);
    final target = workspaces[origin];
    if (target == null || !mounted) return;
    setState(() {
      activeController = target;
      dashboard = false;
      applicationSettings = false;
      devicePage = false;
      selected = Section.chat;
    });
    scaffold.currentState?.closeDrawer();
    await workspaces.reconnect(origin);
    if (channel != null && mounted && identical(controller, target)) {
      await target.selectChannel(channel);
    }
  }

  Future<void> addSpace() async {
    final previous = activeController;
    final pending = createTransient();
    setState(() => activeController = pending);
    await connection();
    if (!mounted) return;
    if (!workspaces.controllers.values.contains(pending)) {
      setState(() => activeController = previous);
      transientControllers.remove(pending);
      pending.dispose();
    }
  }

  final scaffold = GlobalKey<ScaffoldState>();
  final home = HomeController();
  late final presence =
      widget.presence ??
      ServerPresence(
        probe: (origin) => probeSavedServer(origin, SecureIdentityVault()),
      );
  StreamSubscription<ServerPresenceChange>? presenceChanges;
  void cacheServerIcons() {
    for (final entry in workspaces.controllers.entries) {
      final icon = entry.value.serverIcon;
      if (icon != null) {
        unawaited(
          widget.preferences.cacheServerIcon(entry.key, icon.toProto3Json()),
        );
      }
    }
  }

  void watchSavedServers() {
    presence.watch(widget.preferences.origins);
    workspaces.synchronize(widget.preferences.origins);
    cacheServerIcons();
  }

  void announcePresence(ServerPresenceChange change) {
    if (!mounted) return;
    if (change.online &&
        !(home.busy &&
            home.phase == HomePhase.stopping &&
            home.state?.publicOrigin == change.origin)) {
      unawaited(workspaces.reconnect(change.origin));
    }
    final name = Uri.parse(change.origin).authority;
    final label = change.online
        ? context.strings.serverNowOnline(name)
        : context.strings.serverNowOffline(name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              change.online
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_off_outlined,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
          ],
        ),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    dashboard = widget.controller == null;
    unawaited(home.load());
    final initialOrigin = initialController.preview?.origin.toString();
    if (initialOrigin != null && initialController.connected) {
      workspaces.adopt(
        initialOrigin,
        initialController,
        owned: widget.controller == null,
      );
    }
    widget.preferences.addListener(watchSavedServers);
    workspaces.addListener(cacheServerIcons);
    presenceChanges = presence.changes.listen(announcePresence);
    watchSavedServers();
  }

  Future<void> startHome(String ip) async {
    final state = await home.start(ip);
    if (state == null || !mounted) return;
    final existing = workspaces[state.publicOrigin];
    final target = existing != null && !existing.busy
        ? existing
        : createTransient();
    setState(() {
      activeController = target;
      dashboard = false;
      applicationSettings = false;
      devicePage = false;
      selected = Section.overview;
    });
    await target.inspect(
      state.localOrigin,
      homeOrigin: state.publicOrigin,
      tlsFingerprint: state.tlsFingerprint,
    );
    if (!mounted) return;
    if (target.preview == null) {
      home.reportError(target.error);
      return;
    }
    await target.connect(setupCode: state.setupCode);
    if (!target.connected) home.reportError(target.error);
    if (mounted && target.connected) {
      workspaces.adopt(
        state.publicOrigin,
        target,
        owned: target != widget.controller,
      );
      transientControllers.remove(target);
      await widget.preferences.remember(state.publicOrigin);
    }
  }

  Future<void> stopHome() async {
    final owner = workspaces[home.state?.publicOrigin ?? ''];
    await home.stop(disconnectClient: owner?.disconnect);
  }

  Future<void> showHome() async {
    if (home.running) {
      await stopHome();
      return;
    }
    await home.load();
    if (!mounted) return;
    await startHome(home.ip);
    if (!mounted) return;
    await showHomeDetails();
  }

  Future<void> showHomeDetails() async {
    await home.load();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 580,
            maxHeight: MediaQuery.sizeOf(context).height * .9,
          ),
          child: HomePanel(
            home: home,
            onStart: startHome,
            onStop: stopHome,
            openAdministration: () {
              final owner = workspaces[home.state?.publicOrigin ?? ''];
              if (owner != null) {
                setState(() {
                  activeController = owner;
                  dashboard = false;
                  applicationSettings = false;
                  devicePage = false;
                });
              }
              final administration = owner?.administration;
              if (administration == null) {
                home.reportError(
                  owner == null || owner.error.isEmpty
                      ? 'Сначала нужно подключиться к серверу владельцем.'
                      : owner.error,
                );
                return;
              }
              Navigator.pop(context);
              select(Section.settings);
            },
          ),
        ),
      ),
    );
  }

  Future<void> createOwnSpace() async {
    await home.load();
    if (!mounted) return;
    final strings = context.strings;
    if (home.pendingUpdate || home.updateAvailable) {
      await showHomeDetails();
      return;
    }
    final existing = home.ip.isNotEmpty;
    final owner = workspaces[home.state?.publicOrigin ?? ''];
    Map<String, dynamic>? settings;
    if (owner?.administration != null) {
      try {
        final response = await owner!.administration!.adminRequest(
          '/api/v1/space/settings',
        );
        settings = Map<String, dynamic>.from(response['settings'] as Map);
      } catch (_) {
        // Мастер повторит проверку перед сохранением.
      }
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SpaceSetupWizard(
        existing: existing,
        initialTitle: settings?['title'] as String? ?? owner?.spaceTitle ?? '',
        initialIcon: settings?['icon'] is Map
            ? Map<String, dynamic>.from(settings!['icon'] as Map)
            : null,
        initialChat: settings?['chatEnabled'] as bool? ?? true,
        create: (title, icon, chatEnabled) async {
          if (!home.running) {
            final ip = home.ip.isEmpty ? await home.detectIP() : home.ip;
            await startHome(ip);
          }
          final owner = workspaces[home.state?.publicOrigin ?? ''];
          final session = owner?.administration;
          if (session == null || !session.canManageSpace) {
            throw StateError(
              home.error.isNotEmpty ? home.error : strings.setupOwnerRequired,
            );
          }
          final response = await session.adminRequest('/api/v1/space/settings');
          final settings = response['settings'] as Map;
          if (!settings.containsKey('icon')) {
            throw StateError(strings.setupUpdateRequired);
          }
          await session.adminRequest(
            '/api/v1/space/settings',
            method: 'PATCH',
            body: {
              'title': title,
              'chatTitle': settings['chatTitle'],
              'chatEnabled': chatEnabled,
              'registrationPolicy': settings['registrationPolicy'],
              'expectedRevision': settings['revision'],
              'icon': icon,
            },
          );
          final invite = await session.adminRequest(
            '/api/v1/space/invites',
            method: 'POST',
            body: {'role': 'member', 'ttlSeconds': 86400, 'maxUses': 1},
          );
          return Uri.parse(home.state!.publicOrigin)
              .replace(
                fragment: Uri(
                  queryParameters: {
                    'invite': invite['token'] as String,
                    'tls': home.state!.tlsFingerprint,
                  },
                ).query,
              )
              .toString();
        },
        manage: () {
          Navigator.pop(context);
          final owner = workspaces[home.state?.publicOrigin ?? ''];
          if (owner == null || !mounted) return;
          setState(() {
            activeController = owner;
            dashboard = false;
            applicationSettings = false;
            devicePage = false;
          });
          select(Section.settings);
        },
      ),
    );
  }

  Section selected = Section.overview;
  Future<void> search() async {
    final route = await showSearch<String>(
      context: context,
      delegate: SpaceSearch(
        {
          for (final section in [
            Section.overview,
            Section.chat,
            Section.identity,
            Section.settings,
          ])
            section.name: section == Section.chat
                ? chatLabel
                : section.localized(context),
        },
        controller.messages,
        context.strings.searchHint,
      ),
    );
    if (!mounted || route == null || route.isEmpty) return;
    select(Section.values.firstWhere((section) => section.name == route));
  }

  String get chatLabel =>
      controller.connected ? controller.chatTitle : context.strings.chat;

  int get bottomIndex => devicePage
      ? 2
      : dashboard || applicationSettings
      ? 0
      : switch (selected) {
          Section.chat => 1,
          Section.settings => 3,
          _ => 0,
        };
  void showApplicationSettings() {
    setState(() {
      devicePage = false;
      applicationSettings = true;
    });
    scaffold.currentState?.closeDrawer();
  }

  void select(Section section) {
    if (section == Section.identity) {
      showDevice();
      return;
    }
    if (section == Section.settings &&
        (controller.busy || controller.administration == null)) {
      return;
    }
    if (selected == Section.settings && section != Section.settings) {
      unawaited(controller.refreshChannels());
    }
    setState(() {
      selected = section;
      dashboard = false;
      applicationSettings = false;
      devicePage = false;
    });
    scaffold.currentState?.closeDrawer();
  }

  @override
  void dispose() {
    widget.preferences.removeListener(watchSavedServers);
    workspaces.removeListener(cacheServerIcons);
    unawaited(presenceChanges?.cancel());
    if (widget.presence == null) presence.dispose();
    home.dispose();
    for (final pending in transientControllers) {
      pending.dispose();
    }
    transientControllers.clear();
    final ownsInitial = workspaces.controllers.values.contains(
      initialController,
    );
    if (widget.workspaces == null) workspaces.dispose();
    if (widget.controller == null && !ownsInitial) initialController.dispose();
    super.dispose();
  }

  Future<void> connection([String? origin]) async {
    if (origin != null) {
      workspaces.synchronize([origin]);
      activeController = workspaces[origin];
    }
    if (!mounted) return;
    final target = controller;
    final panel = ConnectionPanel(
      controller: target,
      origin:
          origin ??
          controller.preview?.origin.toString() ??
          'http://127.0.0.1:8080',
      onConnected: (address) async {
        workspaces.adopt(address, target, owned: target != widget.controller);
        transientControllers.remove(target);
        activeController = target;
        await widget.preferences.remember(address);
        if (!mounted) return;
        Navigator.pop(context);
        select(Section.chat);
      },
    );
    if (MediaQuery.sizeOf(context).width < 760) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .9,
            ),
            child: panel,
          ),
        ),
      );
    } else {
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog(child: SizedBox(width: 540, child: panel)),
      );
    }
  }

  Future<void> revoke() async {
    final target = controller;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.revokeTitle),
        content: Text(context.strings.revokeDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.keep),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.revoke),
          ),
        ],
      ),
    );
    if (accepted == true && mounted) await target.revoke();
  }

  String get spaceLabel => controller.spaceTitle.isNotEmpty
      ? controller.spaceTitle
      : controller.preview?.origin.authority ?? context.strings.yourSpace;
  Widget chatGroup() => SurfaceCard(
    key: const ValueKey('server-chats'),
    color: Theme.of(context).colorScheme.surfaceContainerHigh,
    hoverBorder: true,
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.forum_outlined, size: 20),
          title: Text(context.strings.chats),
          onTap: () => select(Section.chat),
        ),
        for (final channel in controller.channels.where(
          (channel) => !channel.archived,
        ))
          ListTile(
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            selected:
                selected == Section.chat && controller.channelId == channel.id,
            leading: Icon(
              channel.archived
                  ? Icons.archive_outlined
                  : !channel.permissions.read
                  ? Icons.lock_outline
                  : Icons.tag,
              size: 18,
            ),
            title: Text(channel.title, overflow: TextOverflow.ellipsis),
            trailing: controller.unreadCount(channel.id) > 0
                ? Tooltip(
                    message: context.strings.unreadCount(
                      controller.unreadCount(channel.id),
                    ),
                    child: Badge(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      label: Text(
                        controller.unreadCount(channel.id) > 99
                            ? '99+'
                            : '${controller.unreadCount(channel.id)}',
                      ),
                    ),
                  )
                : null,
            subtitle: channel.archived
                ? Text(context.strings.archived)
                : !channel.permissions.read
                ? Text(context.strings.noReadAccess)
                : null,
            onTap: controller.busy
                ? null
                : () {
                    controller.selectChannel(channel.id);
                    select(Section.chat);
                  },
          ),
      ],
    ),
  );
  Widget sidebar() => SizedBox(
    width: 280,
    child: Material(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
        children: [
          Text(
            spaceLabel,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            controller.connected
                ? context.strings.connected
                : context.strings.spaceDisconnected,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final section in [
            Section.overview,
            Section.chat,
            Section.settings,
          ])
            if (section == Section.chat)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: chatGroup(),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  dense: true,
                  minTileHeight: 48,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  selected: !applicationSettings && selected == section,
                  selectedTileColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  leading: Icon(section.icon, size: 20),
                  title: Text(
                    section == Section.chat
                        ? controller.channels.isEmpty
                              ? chatLabel
                              : context.strings.chats
                        : section.localized(context),
                  ),
                  onTap:
                      section == Section.settings &&
                          (controller.busy || controller.administration == null)
                      ? null
                      : () => select(section),
                ),
              ),
        ],
      ),
    ),
  );
  Widget navigationSidebar() => dashboard
      ? SizedBox(
          width: 280,
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                SpaceActionButton(
                  onPressed: addSpace,
                  icon: Icons.add,
                  label: context.strings.addSpace,
                ),
                const SizedBox(height: 12),
                SpaceActionButton(
                  onPressed: home.busy ? null : createOwnSpace,
                  icon: Icons.add_home_outlined,
                  label: context.strings.createOwnSpace,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: Text(context.strings.dashboard),
                  onTap: showDashboard,
                ),
                const SizedBox(height: 20),
                Text(
                  context.strings.recentSpaces,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                for (final origin in widget.preferences.origins)
                  ListTile(
                    enabled: presence.online(origin) == true,
                    leading: Icon(
                      presence.online(origin) == true
                          ? Icons.cloud_done_outlined
                          : Icons.dns_outlined,
                    ),
                    title: Text(
                      workspaces[origin]?.spaceTitle.isNotEmpty == true
                          ? workspaces[origin]!.spaceTitle
                          : Uri.parse(origin).authority,
                    ),
                    subtitle: Text(
                      origin,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: presence.online(origin) == true
                        ? () => openSpace(origin)
                        : null,
                  ),
              ],
            ),
          ),
        )
      : sidebar();
  Widget railButton({
    Key? key,
    required String tooltip,
    required Widget icon,
    required VoidCallback? onPressed,
    bool selected = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: SizedBox.square(
          dimension: 48,
          child: IconButton(
            key: key,
            tooltip: tooltip,
            onPressed: onPressed,
            icon: icon,
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              fixedSize: const Size.square(48),
              backgroundColor: colors.surfaceContainerHigh,
              foregroundColor: selected ? colors.primary : colors.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: selected
                      ? colors.primary.withValues(alpha: .5)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rail() => SizedBox(
    width: 64,
    child: Column(
      children: [
        const SizedBox(height: 24),
        Image.asset(
          'assets/branding/space-app-icon.png',
          width: 44,
          height: 44,
          semanticLabel: context.strings.logo,
        ),
        const SizedBox(height: 24),
        railButton(
          key: const ValueKey('dashboard-tab'),
          tooltip: context.strings.dashboard,
          selected: dashboard && !applicationSettings && !devicePage,
          onPressed: showDashboard,
          icon: const Icon(Icons.home_outlined),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (final origin in widget.preferences.origins)
                railButton(
                  key: ValueKey('server-tab-$origin'),
                  tooltip: workspaces[origin]?.spaceTitle.isNotEmpty == true
                      ? '${workspaces[origin]!.spaceTitle} · $origin'
                      : origin,
                  selected:
                      !applicationSettings &&
                      !dashboard &&
                      identical(controller, workspaces[origin]),
                  onPressed: () => openSpace(origin),
                  icon: Tooltip(
                    message: presence.online(origin) == null
                        ? origin
                        : presence.online(origin) == true
                        ? context.strings.serverNowOnline(
                            Uri.parse(origin).host,
                          )
                        : context.strings.serverNowOffline(
                            Uri.parse(origin).host,
                          ),
                    child: Badge(
                      isLabelVisible: presence.online(origin) != null,
                      backgroundColor: presence.online(origin) == true
                          ? Colors.green
                          : Theme.of(context).colorScheme.outlineVariant,
                      child: ServerIconView(
                        value:
                            workspaces[origin]?.serverIcon?.toProto3Json() ??
                            widget.preferences.serverIcons[origin],
                      ),
                    ),
                  ),
                ),
              railButton(
                tooltip: context.strings.addSpace,
                onPressed: addSpace,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        railButton(
          key: const ValueKey('home-server-details-tab'),
          tooltip: context.strings.goLive,
          onPressed: showHomeDetails,
          selected: home.running,
          icon: home.busy
              ? HomeOperationProgress(home: home, compact: true)
              : const Icon(Icons.sensors),
        ),
        railButton(
          key: const ValueKey('app-settings-tab'),
          tooltip: context.strings.appSettings,
          selected: applicationSettings,
          onPressed: showApplicationSettings,
          icon: const Icon(Icons.settings_outlined),
        ),
        railButton(
          key: const ValueKey('my-device-tab'),
          tooltip: context.strings.myDevice,
          selected: devicePage,
          onPressed: showDevice,
          icon: const Icon(Icons.computer_outlined),
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
  Widget contextPanel() => SizedBox(
    width: 280,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 8, 20),
      child: SurfaceCard(
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        hoverBorder: true,
        child: contextDetails(),
      ),
    ),
  );
  Widget contextDetails() => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.aboutSpace,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 14),
        Text(
          context.strings.independentServer,
          style: TextStyle(fontSize: 12, height: 1.8),
        ),
        const Divider(height: 36),
        Text(
          context.strings.connection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          controller.connected
              ? context.strings.deviceSignedIn
              : context.strings.noSession,
          style: const TextStyle(fontSize: 12),
        ),
        if (controller.preview != null) ...[
          const SizedBox(height: 10),
          SelectableText(
            controller.preview!.origin.toString(),
            style: const TextStyle(fontSize: 11),
          ),
        ],
        const SizedBox(height: 16),
        SpaceActionButton(
          onPressed: () => connection(),
          icon: Icons.link_outlined,
          label: context.strings.checkConnection,
        ),
        const Divider(height: 36),
        Text(
          context.strings.beYourself,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          context.strings.ownPace,
          style: TextStyle(fontSize: 12, height: 1.8),
        ),
      ],
    ),
  );
  Widget pages() => IndexedStack(
    index: selected.index,
    children: [
      for (final section in Section.values)
        switch (section) {
          Section.overview => OverviewPanel(
            controller: controller,
            home:
                controller.preview?.origin.toString() ==
                    'https://${home.ip}:8443'
                ? home
                : null,
            homeAction: showHome,
            homeDetails: showHomeDetails,
            openConnection: () => connection(),
            openChat: () => select(Section.chat),
          ),
          Section.chat => ChatView(
            key: const ValueKey('live-chat'),
            controller: controller,
            active:
                !applicationSettings && !dashboard && selected == Section.chat,
            showHeader: false,
            sendWithShift: widget.preferences.sendShortcut == 'shiftEnter',
            openConnection: () => connection(),
          ),
          Section.forum => UnavailablePanel(
            title: context.strings.forumTitle,
            description: context.strings.forumDescription,
            icon: Icons.forum_outlined,
          ),
          Section.feed => UnavailablePanel(
            title: context.strings.feedTitle,
            description: context.strings.feedDescription,
            icon: Icons.view_agenda_outlined,
          ),
          Section.rooms => const RoomsPanel(),
          Section.identity => const SizedBox.shrink(),
          Section.settings => administrationPage(),
        },
    ],
  );
  Widget administrationPage() {
    final target = controller;
    final session = target.administration;
    if (selected != Section.settings ||
        dashboard ||
        applicationSettings ||
        session == null) {
      return const SizedBox.shrink();
    }
    return serverAdministration(
      context,
      session,
      key: ObjectKey(session),
      onDeviceRevoked: () => target.disconnect(),
    );
  }

  Widget header(bool compact) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Row(
      children: [
        if (compact)
          IconButton(
            tooltip: context.strings.myDevice,
            onPressed: showDevice,
            icon: const Icon(Icons.computer_outlined),
          ),
        if (compact)
          IconButton(
            tooltip: context.strings.openNavigation,
            onPressed: () => scaffold.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        if (!compact) ...[
          Icon(
            devicePage
                ? Icons.computer_outlined
                : applicationSettings
                ? Icons.settings_outlined
                : selected.icon,
            size: 26,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                devicePage
                    ? context.strings.myDevice
                    : applicationSettings
                    ? context.strings.appSettings
                    : dashboard
                    ? context.strings.dashboard
                    : selected == Section.chat
                    ? chatLabel
                    : selected.localized(context),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (!applicationSettings &&
                  !dashboard &&
                  selected == Section.chat &&
                  !compact)
                Text(
                  context.strings.chatDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        if (!compact && !dashboard && !applicationSettings)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              controller.reconnecting
                  ? context.strings.reconnecting
                  : controller.connected
                  ? context.strings.keyLogin
                  : context.strings.disconnected,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        IconButton(
          tooltip: dashboard
              ? context.strings.addSpace
              : context.strings.serverConnection,
          onPressed: controller.busy
              ? null
              : dashboard
              ? addSpace
              : () => connection(),
          icon: Icon(
            dashboard
                ? Icons.add
                : controller.connected
                ? Icons.cloud_done_outlined
                : Icons.cloud_off_outlined,
          ),
        ),
        if (compact)
          IconButton(
            tooltip: context.strings.appSettings,
            onPressed: showApplicationSettings,
            icon: const Icon(Icons.tune),
          ),
        IconButton(
          tooltip: context.strings.search,
          onPressed: search,
          icon: const Icon(Icons.search),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([
      controller,
      workspaces,
      widget.preferences,
      home,
      presence,
    ]),
    builder: (context, _) => LayoutBuilder(
      builder: (context, box) {
        final compact = box.maxWidth < 760;
        final workspace = Column(
          children: [
            header(compact),
            if (!dashboard && controller.reconnecting)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.strings.recoveringEvents,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!dashboard && controller.busy)
              const LinearProgressIndicator(minHeight: 2),
            if (!applicationSettings &&
                !dashboard &&
                controller.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  chatFailureText(context, controller),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: devicePage
                          ? 3
                          : applicationSettings
                          ? 2
                          : dashboard
                          ? 0
                          : 1,
                      children: [
                        Dashboard(
                          workspaces: workspaces,
                          presence: presence,
                          homeAction: showHome,
                          homeDetails: showHomeDetails,
                          createOwnSpace: createOwnSpace,
                          homeRunning: home.running,
                          homeBusy: home.busy,
                          addSpace: addSpace,
                          openSpace: (origin) => openSpace(origin),
                          openChannel: (origin, channel) =>
                              openSpace(origin, channel: channel),
                        ),
                        pages(),
                        SettingsPanel(preferences: widget.preferences),
                        DevicePanel(
                          workspaces: workspaces,
                          fallback: deviceController,
                          restoreController: (origin) =>
                              workspaces[origin] ?? createTransient(),
                          onRestored: (origin, target) async {
                            workspaces.adopt(
                              origin,
                              target,
                              owned: target != widget.controller,
                            );
                            transientControllers.remove(target);
                            await widget.preferences.remember(origin);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (box.maxWidth >= 1320 &&
                      !dashboard &&
                      !applicationSettings)
                    contextPanel(),
                ],
              ),
            ),
          ],
        );
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
                unawaited(search()),
            const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
                unawaited(search()),
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
              key: scaffold,
              drawer: compact
                  ? Drawer(child: SafeArea(child: navigationSidebar()))
                  : null,
              bottomNavigationBar: compact
                  ? NavigationBar(
                      selectedIndex: bottomIndex,
                      onDestinationSelected: (index) => index == 0
                          ? showDashboard()
                          : select(
                              [
                                Section.overview,
                                Section.chat,
                                Section.identity,
                                Section.settings,
                              ][index],
                            ),
                      destinations: [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          label: context.strings.overview,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.tag),
                          label: context.strings.chatTab,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.computer_outlined),
                          label: context.strings.myDevice,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.settings_suggest_outlined),
                          label: context.strings.managementTab,
                          enabled:
                              controller.administration != null &&
                              !controller.busy,
                        ),
                      ],
                    )
                  : null,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(compact ? 6 : 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact) ...[
                        rail(),
                        const SizedBox(width: 8),
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                          child: navigationSidebar(),
                        ),
                      ],
                      Expanded(
                        child: ClipRRect(
                          borderRadius: compact
                              ? BorderRadius.circular(20)
                              : const BorderRadius.horizontal(
                                  right: Radius.circular(20),
                                ),
                          child: ColoredBox(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            child: workspace,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
