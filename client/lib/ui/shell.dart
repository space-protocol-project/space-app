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
import 'home_panel.dart';
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
  settings(Icons.tune);

  const Section(this.icon);
  final IconData icon;
  String localized(BuildContext context) => switch (this) {
    Section.overview => context.strings.overview,
    Section.chat => context.strings.chat,
    Section.forum => context.strings.forum,
    Section.feed => context.strings.feed,
    Section.rooms => context.strings.rooms,
    Section.identity => context.strings.identity,
    Section.settings => context.strings.settings,
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

  ChatController get controller => activeController ?? initialController;
  late final workspaces =
      widget.workspaces ?? ServerWorkspaces(vault: initialController.vault);
  bool dashboard = true;
  void showDashboard() {
    setState(() {
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
  void watchSavedServers() {
    presence.watch(widget.preferences.origins);
    workspaces.synchronize(widget.preferences.origins);
  }

  void announcePresence(ServerPresenceChange change) {
    if (!mounted) return;
    if (change.online) unawaited(workspaces.reconnect(change.origin));
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
    if (owner != null) await owner.disconnect();
    await home.stop();
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
                });
              }
              final administration = controller.administration;
              if (administration == null) {
                home.reportError(
                  controller.error.isEmpty
                      ? 'Сначала нужно подключиться к серверу владельцем.'
                      : controller.error,
                );
                return;
              }
              Navigator.pop(context);
              select(Section.identity);
              unawaited(openServerAdministration(this.context, administration));
            },
          ),
        ),
      ),
    );
  }

  Section selected = Section.overview;
  Future<void> search() async {
    final route = await showSearch<String>(
      context: context,
      delegate: SpaceSearch(
        {
          for (final section in Section.values)
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

  int get bottomIndex => switch (selected) {
    Section.overview => 0,
    Section.chat => 1,
    Section.forum || Section.feed => 2,
    Section.rooms => 3,
    Section.identity || Section.settings => 4,
  };
  void select(Section section) {
    setState(() {
      selected = section;
      dashboard = false;
    });
    scaffold.currentState?.closeDrawer();
  }

  @override
  void dispose() {
    widget.preferences.removeListener(watchSavedServers);
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
          SpaceActionButton(
            onPressed: controller.busy ? null : () => connection(),
            icon: controller.connected ? Icons.link_outlined : Icons.add,
            label: controller.connected
                ? context.strings.connection
                : context.strings.addSpace,
          ),
          const SizedBox(height: 20),
          if (controller.channels.isNotEmpty) ...[
            const Divider(height: 24),
            Text(context.strings.channels, style: TextStyle(fontSize: 12)),
            for (final channel in controller.channels)
              ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                selected:
                    selected == Section.chat &&
                    controller.channelId == channel.id,
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
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary,
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
          for (final section in Section.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: ListTile(
                dense: true,
                minTileHeight: 48,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                selected: selected == section,
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
                onTap: () => select(section),
              ),
            ),
          if (controller.administration != null)
            ListTile(
              leading: const Icon(Icons.settings_suggest_outlined),
              title: Text(context.strings.manageSpace),
              onTap: controller.busy
                  ? null
                  : () async {
                      final target = controller;
                      scaffold.currentState?.closeDrawer();
                      await openServerAdministration(
                        context,
                        target.administration!,
                        onDeviceRevoked: () {
                          target.disconnect();
                        },
                      );
                      await target.refreshChannels();
                    },
            ),
          if (widget.preferences.origins.isNotEmpty) ...[
            const Divider(height: 30),
            Text(context.strings.recentSpaces, style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            for (final origin in widget.preferences.origins)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Tooltip(
                  message: presence.online(origin) == null
                      ? context.strings.serverAvailabilityUnknown
                      : presence.online(origin) == true
                      ? context.strings.serverNowOnline(
                          Uri.parse(origin).authority,
                        )
                      : context.strings.serverNowOffline(
                          Uri.parse(origin).authority,
                        ),
                  child: Icon(
                    presence.online(origin) == null
                        ? Icons.public
                        : presence.online(origin) == true
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                    size: 18,
                    color: presence.online(origin) == true
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                title: Text(origin, style: const TextStyle(fontSize: 11)),
                onTap: () => openSpace(origin),
              ),
          ],
          const SizedBox(height: 20),
          Text(context.strings.prototype, style: TextStyle(fontSize: 11)),
        ],
      ),
    ),
  );
  Widget navigationSidebar() => dashboard && widget.controller == null
      ? SizedBox(
          width: 280,
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  context.strings.dashboardSpaces,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SpaceActionButton(
                  onPressed: addSpace,
                  icon: Icons.add,
                  label: context.strings.addSpace,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: Text(context.strings.dashboard),
                  onTap: showDashboard,
                ),
                for (final origin in widget.preferences.origins)
                  ListTile(
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
                    onTap: () => openSpace(origin),
                  ),
                const Divider(height: 28),
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: Text(context.strings.settings),
                  onTap: () => select(Section.settings),
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
          selected: dashboard,
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
                      !dashboard && identical(controller, workspaces[origin]),
                  onPressed: () => openSpace(origin),
                  icon: Text(
                    (workspaces[origin]?.spaceTitle.isNotEmpty == true
                            ? workspaces[origin]!.spaceTitle
                            : Uri.parse(origin).host)
                        .characters
                        .take(1)
                        .toString()
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
          key: const ValueKey('home-server-toggle'),
          tooltip: home.running
              ? context.strings.stopHome
              : context.strings.goLive,
          selected: home.running,
          onPressed: home.busy || controller.busy ? null : showHome,
          icon: home.busy
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(home.running ? Icons.power_settings_new : Icons.sensors),
        ),
        railButton(
          tooltip: context.strings.myIdentity,
          onPressed: () => select(Section.identity),
          icon: const Icon(Icons.shield_outlined),
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
      OverviewPanel(
        controller: controller,
        home: home,
        homeAction: showHome,
        homeDetails: showHomeDetails,
        openConnection: () => connection(),
        openChat: () => select(Section.chat),
      ),
      ChatView(
        key: const ValueKey('live-chat'),
        controller: controller,
        active: !dashboard && selected == Section.chat,
        showHeader: false,
        openConnection: () => connection(),
      ),
      UnavailablePanel(
        title: context.strings.forumTitle,
        description: context.strings.forumDescription,
        icon: Icons.forum_outlined,
      ),
      UnavailablePanel(
        title: context.strings.feedTitle,
        description: context.strings.feedDescription,
        icon: Icons.view_agenda_outlined,
      ),
      const RoomsPanel(),
      IdentityPanel(
        key: ValueKey(controller),
        controller: controller,
        revoke: revoke,
      ),
      SettingsPanel(preferences: widget.preferences),
    ],
  );
  Widget header(bool compact) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Row(
      children: [
        if (compact)
          IconButton(
            tooltip: context.strings.openNavigation,
            onPressed: () => scaffold.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        if (!compact) ...[
          Icon(selected.icon, size: 26),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dashboard
                    ? context.strings.dashboard
                    : selected == Section.chat
                    ? chatLabel
                    : selected.localized(context),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (!dashboard && selected == Section.chat && !compact)
                Text(
                  context.strings.chatDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        if (!compact && !dashboard)
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
        IconButton(
          tooltip: context.strings.appearanceSettings,
          onPressed: () => select(Section.settings),
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
            if (!dashboard && controller.error.isNotEmpty)
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
                      index: dashboard ? 0 : 1,
                      children: [
                        Dashboard(
                          workspaces: workspaces,
                          presence: presence,
                          homeAction: showHome,
                          homeRunning: home.running,
                          homeBusy: home.busy,
                          addSpace: addSpace,
                          openSpace: (origin) => openSpace(origin),
                          openChannel: (origin, channel) =>
                              openSpace(origin, channel: channel),
                        ),
                        pages(),
                      ],
                    ),
                  ),
                  if (box.maxWidth >= 1320 && !dashboard) contextPanel(),
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
                                Section.forum,
                                Section.rooms,
                                Section.identity,
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
                          icon: Icon(Icons.forum_outlined),
                          label: context.strings.topicsTab,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.headset_mic_outlined),
                          label: context.strings.rooms,
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.shield_outlined),
                          label: context.strings.profileTab,
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
