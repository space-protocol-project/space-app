import '../l10n/strings.dart';
import 'admin_panel.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/chat_controller.dart';
import '../src/preferences.dart';
import '../src/secure_vault.dart';
import '../src/home_controller.dart';
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
  const SpaceShell({super.key, required this.preferences, this.controller});
  final AppPreferences preferences;
  final ChatController? controller;
  @override
  State<SpaceShell> createState() => _SpaceShellState();
}

class _SpaceShellState extends State<SpaceShell> {
  late final ChatController controller =
      widget.controller ?? ChatController(SecureIdentityVault());
  final scaffold = GlobalKey<ScaffoldState>();
  final home = HomeController();
  @override
  void initState() {
    super.initState();
    unawaited(home.load());
  }

  Future<void> startHome(String ip) async {
    final state = await home.start(ip);
    if (state == null || !mounted) return;
    await controller.inspect(
      state.localOrigin,
      homeOrigin: state.publicOrigin,
      tlsFingerprint: state.tlsFingerprint,
    );
    if (!mounted) return;
    if (controller.preview == null) {
      home.reportError(controller.error);
      return;
    }
    await controller.connect(setupCode: state.setupCode);
    if (!controller.connected) home.reportError(controller.error);
    if (mounted && controller.connected) {
      await widget.preferences.remember(state.publicOrigin);
    }
  }

  Future<void> stopHome() async {
    if (controller.preview?.origin.toString() == home.state?.publicOrigin) {
      await controller.disconnect();
    }
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
                ? controller.chatTitle
                : section.localized(context),
        },
        controller.messages,
        context.strings.searchHint,
      ),
    );
    if (!mounted || route == null || route.isEmpty) return;
    select(Section.values.firstWhere((section) => section.name == route));
  }

  int get bottomIndex => switch (selected) {
    Section.overview => 0,
    Section.chat => 1,
    Section.forum || Section.feed => 2,
    Section.rooms => 3,
    Section.identity || Section.settings => 4,
  };
  void select(Section section) {
    setState(() => selected = section);
    scaffold.currentState?.closeDrawer();
  }

  @override
  void dispose() {
    home.dispose();
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  Future<void> connection([String? origin]) async {
    if (origin != null &&
        controller.connected &&
        controller.preview?.origin.toString() != origin) {
      await controller.disconnect();
    }
    if (!mounted) return;
    final panel = ConnectionPanel(
      controller: controller,
      origin:
          origin ??
          controller.preview?.origin.toString() ??
          'http://127.0.0.1:8080',
      onConnected: (address) async {
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
    if (accepted == true && mounted) await controller.revoke();
  }

  String get spaceLabel => controller.spaceTitle.isNotEmpty
      ? controller.spaceTitle
      : controller.preview?.origin.authority ?? context.strings.yourSpace;
  Widget sidebar() => SizedBox(
    width: 248,
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
          AnimatedBuilder(
            animation: home,
            builder: (context, _) => SpaceActionButton(
              onPressed: home.busy || controller.busy ? null : showHome,
              icon: home.running ? Icons.power_settings_new : Icons.sensors,
              label: home.running ? 'Отключиться' : 'Выйти в эфир',
            ),
          ),
          const SizedBox(height: 16),
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
                            ? controller.chatTitle
                            : context.strings.chats
                      : section.localized(context),
                ),
                onTap: () => select(section),
              ),
            ),
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
          if (controller.administration != null)
            ListTile(
              leading: const Icon(Icons.settings_suggest_outlined),
              title: Text(context.strings.manageSpace),
              onTap: controller.busy
                  ? null
                  : () async {
                      scaffold.currentState?.closeDrawer();
                      await openServerAdministration(
                        context,
                        controller.administration!,
                        onDeviceRevoked: () {
                          controller.disconnect();
                        },
                      );
                      await controller.refreshChannels();
                    },
            ),
          if (widget.preferences.origins.isNotEmpty) ...[
            const Divider(height: 30),
            Text(context.strings.recentSpaces, style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            for (final origin in widget.preferences.origins)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.public, size: 18),
                title: Text(origin, style: const TextStyle(fontSize: 11)),
                onTap: controller.busy ? null : () => connection(origin),
              ),
          ],
          const SizedBox(height: 20),
          Text(context.strings.prototype, style: TextStyle(fontSize: 11)),
        ],
      ),
    ),
  );
  Widget rail() => Container(
    width: 72,
    color: Theme.of(context).colorScheme.surfaceContainerLowest,
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
        IconButton.filledTonal(
          tooltip: context.strings.selectedSpace,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          onPressed: () => select(Section.overview),
          icon: const Icon(Icons.public),
        ),
        const SizedBox(height: 12),
        IconButton(
          tooltip: context.strings.addSpace,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          onPressed: controller.busy ? null : () => connection(),
          icon: const Icon(Icons.add),
        ),
        const Spacer(),
        IconButton(
          tooltip: context.strings.myIdentity,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          onPressed: () => select(Section.identity),
          icon: const Icon(Icons.shield_outlined),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
  Widget contextPanel() => Container(
    width: 240,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border(
        left: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
    child: SingleChildScrollView(
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
        active: selected == Section.chat,
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
      IdentityPanel(controller: controller, revoke: revoke),
      SettingsPanel(preferences: widget.preferences),
    ],
  );
  Widget header(bool compact) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border(
        bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
    child: Row(
      children: [
        if (compact)
          IconButton(
            tooltip: context.strings.openNavigation,
            onPressed: () => scaffold.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        Expanded(
          child: Text(
            selected == Section.chat
                ? controller.chatTitle
                : selected.localized(context),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (!compact)
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
          tooltip: context.strings.serverConnection,
          onPressed: controller.busy ? null : () => connection(),
          icon: Icon(
            controller.connected
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
    animation: Listenable.merge([controller, widget.preferences, home]),
    builder: (context, _) => LayoutBuilder(
      builder: (context, box) {
        final compact = box.maxWidth < 760;
        final workspace = Column(
          children: [
            header(compact),
            if (controller.reconnecting)
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
            if (controller.busy) const LinearProgressIndicator(minHeight: 2),
            if (controller.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  controller.error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Expanded(child: pages()),
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
                  ? Drawer(child: SafeArea(child: sidebar()))
                  : null,
              bottomNavigationBar: compact
                  ? NavigationBar(
                      selectedIndex: bottomIndex,
                      onDestinationSelected: (index) => select(
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(areaRadius),
                          child: rail(),
                        ),
                        const SizedBox(width: 8),
                        RegionFrame(child: sidebar()),
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: RegionFrame(child: workspace)),
                      if (box.maxWidth >= 1320) ...[
                        const SizedBox(width: 8),
                        RegionFrame(child: contextPanel()),
                      ],
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
