import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/space_admin_ui.dart' show ServerIconView;

import 'home_operation_progress.dart';
import '../l10n/failure_strings.dart';
import '../l10n/strings.dart';
import '../l10n/app_localizations.dart';
import 'admin_panel.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../src/chat_controller.dart';
import '../src/preferences.dart';
import '../src/app_updates.dart';
import '../src/secure_vault.dart';
import '../src/home_controller.dart';
import '../src/server_presence.dart';
import '../src/server_workspaces.dart';
import 'dashboard.dart';
import 'device_panel.dart';
import 'server_inbox.dart';
import 'home_panel.dart';
import 'space_setup_wizard.dart';
import 'chat_view.dart';
import 'connection_panel.dart';
import 'panels.dart';
import 'search.dart';
import 'components.dart';
import 'space_appearance.dart';
import 'space_frame.dart';
import 'space_popup.dart';
import 'measure_size.dart';

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
    this.updates,
    this.hostingEnabled = true,
  });
  final bool hostingEnabled;
  final AppPreferences preferences;
  final AppUpdates? updates;
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
  bool serverList = false;
  bool drawerOpen = false;
  final menuButtonFocus = FocusNode();
  final menuFocus = FocusScopeNode();
  FocusNode? returnFocus;
  double headerHeight = SpaceAppearance.headerHeight;
  void closeNavigation() {
    if (!drawerOpen) return;
    setState(() => drawerOpen = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || drawerOpen || ModalRoute.of(context)?.isCurrent != true) {
        return;
      }
      final target = returnFocus?.context != null
          ? returnFocus!
          : menuButtonFocus;
      if (target.canRequestFocus) target.requestFocus();
    });
  }

  void openNavigation() {
    if (drawerOpen) return;
    returnFocus = FocusManager.instance.primaryFocus;
    setState(() => drawerOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && drawerOpen) menuFocus.requestFocus();
    });
  }

  void headerResized(Size size) {
    if (mounted && (size.height - headerHeight).abs() > 1) {
      setState(() => headerHeight = size.height);
    }
  }

  String? jumpRequest;
  int jumpGeneration = 0;
  void openMessage(String id) {
    setState(() {
      jumpRequest = id;
      jumpGeneration++;
    });
    select(Section.chat);
  }

  Future<void> showFavorites() async {
    closeNavigation();
    final target = controller;
    final id = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 600,
          height: 480,
          child: BlocBuilder<ChatController, ChatState>(
            bloc: target,
            builder: (context, state) {
              final messages = state.messages.where(state.isFavorite).toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.strings.favoriteMessages,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          tooltip: context.strings.close,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: messages.isEmpty
                        ? Center(child: Text(context.strings.nothingFound))
                        : ListView.builder(
                            primary: false,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return ListTile(
                                title: Text(
                                  message.text,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(message.authorId),
                                onTap: () => Navigator.pop(context, message.id),
                                trailing: IconButton(
                                  tooltip: context.strings.removeFavorite,
                                  onPressed: () =>
                                      target.toggleFavorite(message),
                                  icon: const Icon(Icons.bookmark),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    if (mounted && identical(target, controller) && id != null) openMessage(id);
  }

  final Set<String> removing = {}, deniedHandled = {};
  void showServers() {
    setState(() {
      applicationSettings = false;
      devicePage = false;
      dashboard = true;
      serverList = true;
    });
    closeNavigation();
  }

  void handleDeniedServers() {
    for (final target in workspaces.controllers.values) {
      final origin = target.knownOrigin;
      if (target.accessRemoved &&
          !target.busy &&
          widget.preferences.origins.contains(origin) &&
          !removing.contains(origin) &&
          deniedHandled.add(origin)) {
        unawaited(removeSpace(origin, denied: true));
      }
    }
  }

  Future<void> removeSpace(String origin, {bool denied = false}) async {
    if (!removing.add(origin)) return;
    try {
      final target = workspaces[origin];
      if (!denied) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.strings.removeServer),
            content: Text(context.strings.removeServerConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.strings.close),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.strings.removeServer),
              ),
            ],
          ),
        );
        if (confirmed != true || !mounted) return;
      }
      if (target != null) {
        await target.clearOfflineData();
        await target.disconnect();
      }
      if (!mounted) return;
      if (identical(controller, target)) {
        setState(() {
          activeController = null;
          dashboard = true;
          applicationSettings = false;
          devicePage = false;
          serverList = false;
          selected = Section.overview;
        });
      }
      await workspaces.remove(origin);
      await widget.preferences.forget(origin);
      if (denied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.serverAccessRemoved)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.serverRemoveFailed)),
        );
      }
    } finally {
      removing.remove(origin);
    }
  }

  void showDevice() {
    setState(() {
      devicePage = true;
      serverList = false;
      dashboard = true;
      applicationSettings = false;
    });
    closeNavigation();
  }

  void showDashboard() {
    setState(() {
      applicationSettings = false;
      devicePage = false;
      serverList = false;
      dashboard = true;
      selected = Section.overview;
    });
    closeNavigation();
  }

  Future<void> openSpace(String origin, {String? channel}) async {
    await workspaces.synchronize([origin]);
    final target = workspaces[origin];
    if (target == null || !mounted) return;
    setState(() {
      activeController = target;
      dashboard = false;
      applicationSettings = false;
      devicePage = false;
      serverList = false;
      selected = Section.chat;
    });
    closeNavigation();
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
  late final home = HomeController(hostingEnabled: widget.hostingEnabled);
  late final updates = widget.updates ?? AppUpdates();
  late final presence =
      widget.presence ??
      ServerPresence(
        probe: (origin) => probeSavedServer(origin, SecureIdentityVault()),
      );
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

  Future<void> watchSavedServers() async {
    deniedHandled.removeWhere(
      (origin) => workspaces[origin]?.accessRemoved != true,
    );
    await presence.watch(widget.preferences.origins);
    await workspaces.synchronize(widget.preferences.origins);
    cacheServerIcons();
  }

  void announcePresence(ServerPresenceChange change) {
    if (!mounted) return;
    if (change.online &&
        !(home.busy &&
            home.phase == HomePhase.stopping &&
            home.server?.publicOrigin == change.origin)) {
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
    if (home.supported) unawaited(home.load());
    unawaited(updates.check());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(offerHomeAfterUpdate()),
    );
    final initialOrigin = initialController.preview?.origin.toString();
    if (initialOrigin != null && initialController.connected) {
      workspaces.adopt(
        initialOrigin,
        initialController,
        owned: widget.controller == null,
      );
    }
    unawaited(watchSavedServers());
  }

  Future<void> startHome(String ip) async {
    final state = await home.start(ip);
    if (state == null || !mounted) return;
    final existing = homeClient(state.publicOrigin);
    final target = existing != null && !existing.busy
        ? existing
        : createTransient();
    setState(() {
      activeController = target;
      dashboard = false;
      applicationSettings = false;
      devicePage = false;
      serverList = false;
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
      final identityOrigin = target.preview!.origin.toString();
      await workspaces.adopt(
        identityOrigin,
        target,
        owned: target != widget.controller,
      );
      transientControllers.remove(target);
      await widget.preferences.remember(identityOrigin);
    }
  }

  ChatController? homeClient(String endpoint) =>
      workspaces[endpoint] ??
      workspaces.controllers.values
          .where(
            (controller) => controller.preview?.endpoint.toString() == endpoint,
          )
          .firstOrNull;

  Future<void> stopHome() async {
    final owner = homeClient(home.server?.publicOrigin ?? '');
    await home.stop(disconnectClient: owner?.disconnect);
  }

  Future<void> prepareAppInstall() async {
    final sessions = {
      ...workspaces.controllers.values,
      ...transientControllers,
      initialController,
    };
    final deadline = DateTime.now().add(const Duration(seconds: 30));
    while (sessions.any((session) => session.busy)) {
      if (!mounted || DateTime.now().isAfter(deadline)) {
        throw StateError('Операции приложения ещё не завершены');
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (sessions.any(
          (session) => session.sendStatus == MessageSendStatus.unconfirmed,
        ) ||
        home.busy) {
      throw StateError(
        'Есть неподтверждённые сообщения или операция домашнего сервера',
      );
    }
    final resumeHome = home.running;
    if (resumeHome) {
      await stopHome();
      if (home.running || home.failureCode != null || home.busy) {
        throw StateError('Домашний сервер не подтвердил остановку');
      }
      final preferences = await SharedPreferences.getInstance();
      if (!await preferences.setBool('space.update.resumeHome', true)) {
        throw StateError('Не удалось сохранить состояние домашнего сервера');
      }
    }
    for (final session in sessions) {
      await session.disconnect().timeout(const Duration(seconds: 5));
    }
  }

  Future<void> offerHomeAfterUpdate() async {
    if (!home.supported) return;
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('space.update.resumeHome') != true) return;
    await home.load();
    if (!mounted) return;
    final start = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.updatesHomeTitle),
        content: Text(context.strings.updatesHomeResume),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.updatesLater),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.updatesHomeStart),
          ),
        ],
      ),
    );
    if (start == null) return;
    await preferences.remove('space.update.resumeHome');
    if (start && mounted) await startHome(home.ip);
  }

  Future<void> showHome() async {
    if (!home.supported) return;
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
    if (!home.supported) return;
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
              final owner = workspaces[home.server?.publicOrigin ?? ''];
              if (owner != null) {
                setState(() {
                  activeController = owner;
                  dashboard = false;
                  applicationSettings = false;
                  devicePage = false;
                  serverList = false;
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
    if (!home.supported) return;
    await home.load();
    if (!mounted) return;
    final strings = context.strings;
    if (home.pendingUpdate || home.updateAvailable) {
      await showHomeDetails();
      return;
    }
    final existing = home.ip.isNotEmpty;
    final owner = workspaces[home.server?.publicOrigin ?? ''];
    final settings = await _ownSpaceSettings(owner);
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
        create: (title, icon, chatEnabled) =>
            _saveOwnSpace(title, icon, chatEnabled, strings),
        manage: () => _manageOwnSpace(context),
      ),
    );
  }

  Future<Map<String, dynamic>?> _ownSpaceSettings(ChatController? owner) async {
    final session = owner?.administration;
    if (session == null) return null;
    try {
      final response = await session.adminRequest('/api/v1/space/settings');
      return Map<String, dynamic>.from(response['settings'] as Map);
    } catch (_) {
      // Мастер повторит проверку перед сохранением.
      return null;
    }
  }

  Future<String> _saveOwnSpace(
    String title,
    Map<String, dynamic> icon,
    bool chatEnabled,
    AppLocalizations strings,
  ) async {
    if (!home.running) {
      final ip = home.ip.isEmpty ? await home.detectIP() : home.ip;
      await startHome(ip);
    }
    final owner = workspaces[home.server?.publicOrigin ?? ''];
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
    return Uri.parse(home.server!.publicOrigin)
        .replace(
          fragment: Uri(
            queryParameters: {
              'invite': invite['token'] as String,
              'tls': home.server!.tlsFingerprint,
            },
          ).query,
        )
        .toString();
  }

  void _manageOwnSpace(BuildContext dialogContext) {
    Navigator.pop(dialogContext);
    final owner = workspaces[home.server?.publicOrigin ?? ''];
    if (owner == null || !mounted) return;
    setState(() {
      activeController = owner;
      dashboard = false;
      applicationSettings = false;
      devicePage = false;
      serverList = false;
    });
    select(Section.settings);
  }

  Section selected = Section.overview;
  Future<void> search() async {
    closeNavigation();
    final route = await showSpacePopup<String>(
      context,
      top: headerHeight + 22,
      surfaceKey: const ValueKey('space-search-surface'),
      builder: (context) => SpaceSearchPanel(
        sections: {
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
        messages: controller.messages,
      ),
    );
    if (!mounted || route == null || route.isEmpty) return;
    if (route.startsWith('message:')) {
      openMessage(route.substring(8));
      return;
    }
    select(Section.values.firstWhere((section) => section.name == route));
  }

  String get chatLabel => controller.channels.isNotEmpty
      ? controller.chatTitle
      : context.strings.chat;

  int get bottomIndex => serverList
      ? 1
      : devicePage
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
      serverList = false;
      applicationSettings = true;
    });
    closeNavigation();
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
      serverList = false;
    });
    closeNavigation();
  }

  @override
  void dispose() {
    menuButtonFocus.dispose();
    menuFocus.dispose();
    if (widget.presence == null) presence.dispose();
    home.dispose();
    if (widget.updates == null) updates.dispose();
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
      await workspaces.synchronize([origin]);
      activeController = workspaces[origin];
    }
    if (!mounted) return;
    final target = controller;
    final panel = ConnectionPanel(
      controller: target,
      origin:
          origin ??
          controller.preview?.endpoint.toString() ??
          'http://127.0.0.1:8080',
      onConnected: (address) async {
        await workspaces.adopt(
          address,
          target,
          owned: target != widget.controller,
        );
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
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
    width: SpaceAppearance.sidebarWidth,
    child: Material(
      color: SpaceAppearance.of(context).sidebar,
      child: ListView(
        primary: false,
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
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: Text(context.strings.favoriteMessages),
            onTap: showFavorites,
          ),
        ],
      ),
    ),
  );
  Widget mobileNavigation() => FocusScope(
    node: menuFocus,
    child: Material(
      key: const ValueKey('mobile-navigation'),
      color: SpaceAppearance.of(context).sidebar,
      child: ListView(
        primary: false,
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  spaceLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: context.strings.close,
                onPressed: closeNavigation,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final origin in widget.preferences.origins)
            ListTile(
              key: ValueKey('server-tab-$origin'),
              leading: ServerIconView(
                value:
                    workspaces[origin]?.serverIcon?.toProto3Json() ??
                    widget.preferences.serverIcons[origin],
              ),
              title: Text(
                workspaces[origin]?.spaceTitle.isNotEmpty == true
                    ? workspaces[origin]!.spaceTitle
                    : Uri.parse(origin).authority,
              ),
              subtitle: Text(
                serverTooltip(origin),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => openSpace(origin),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(context.strings.addSpace),
            onTap: () {
              closeNavigation();
              unawaited(addSpace());
            },
          ),
          if (home.supported)
            ListTile(
              leading: const Icon(Icons.add_home_outlined),
              title: Text(context.strings.createOwnSpace),
              onTap: home.busy
                  ? null
                  : () {
                      closeNavigation();
                      unawaited(createOwnSpace());
                    },
            ),
          const Divider(),
          ListTile(
            key: const ValueKey('dashboard-tab'),
            leading: const Icon(Icons.home_outlined),
            title: Text(context.strings.overview),
            onTap: showDashboard,
          ),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: Text(context.strings.spacesTitle),
            onTap: showServers,
          ),
          if (controller.preview != null || controller.connected) chatGroup(),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: Text(context.strings.favoriteMessages),
            onTap: showFavorites,
          ),
          ListTile(
            leading: const Icon(Icons.settings_suggest_outlined),
            title: Text(context.strings.manageSpace),
            enabled: controller.administration != null && !controller.busy,
            onTap: () => select(Section.settings),
          ),
          const Divider(),
          ListTile(
            key: const ValueKey('my-device-tab'),
            leading: const Icon(Icons.computer_outlined),
            title: Text(context.strings.myDevice),
            onTap: showDevice,
          ),
          ListTile(
            key: const ValueKey('app-settings-tab'),
            leading: updateBadge(Icons.settings_outlined),
            title: Text(context.strings.appSettings),
            onTap: showApplicationSettings,
          ),
          SwitchListTile(
            title: Text(context.strings.darkTheme),
            value: widget.preferences.dark,
            onChanged: (value) => widget.preferences.change(dark: value),
          ),
        ],
      ),
    ),
  );

  Widget navigationSidebar() => dashboard
      ? SizedBox(
          width: SpaceAppearance.sidebarWidth,
          child: Material(
            color: SpaceAppearance.of(context).sidebar,
            child: ListView(
              primary: false,
              padding: const EdgeInsets.all(20),
              children: [
                SpaceActionButton(
                  onPressed: addSpace,
                  icon: Icons.add,
                  label: context.strings.addSpace,
                ),
                const SizedBox(height: 16),
                if (home.supported)
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
                const SizedBox(height: 16),
                for (final origin in widget.preferences.origins)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      horizontalTitleGap: 12,
                      minLeadingWidth: 24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      tileColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: .35),
                      enabled:
                          presence.online(origin) == true ||
                          workspaces[origin]?.hasOfflineHistory == true,
                      leading: Icon(
                        presence.online(origin) == true
                            ? Icons.cloud_done_outlined
                            : Icons.dns_outlined,
                      ),
                      title: Text(
                        workspaces[origin]?.spaceTitle.isNotEmpty == true
                            ? workspaces[origin]!.spaceTitle
                            : Uri.parse(origin).authority,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        origin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap:
                          (presence.online(origin) == true ||
                              workspaces[origin]?.hasOfflineHistory == true)
                          ? () => openSpace(origin)
                          : null,
                    ),
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
              backgroundColor: selected
                  ? colors.primaryContainer
                  : Colors.transparent,
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

  String serverTooltip(String origin) {
    final title = workspaces[origin]?.spaceTitle ?? '';
    final label = title.isEmpty ? origin : '$title · $origin';
    final online = presence.online(origin);
    if (online == null) return label;
    final host = Uri.parse(origin).host;
    final status = online
        ? context.strings.serverNowOnline(host)
        : context.strings.serverNowOffline(host);
    return '$label\n$status';
  }

  Widget rail() => SizedBox(
    width: SpaceAppearance.railWidth,
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
          selected:
              dashboard && !applicationSettings && !devicePage && !serverList,
          onPressed: showDashboard,
          icon: const Icon(Icons.home_outlined),
        ),
        Expanded(
          child: ListView(
            primary: false,
            padding: EdgeInsets.zero,
            children: [
              for (final origin in widget.preferences.origins)
                railButton(
                  key: ValueKey('server-tab-$origin'),
                  // Вложенный Tooltip у значка создаёт потерянные узлы AXTree
                  // во Flutter 3.47.7. Название и статус имеют одну подсказку.
                  tooltip: serverTooltip(origin),
                  selected:
                      !applicationSettings &&
                      !dashboard &&
                      identical(controller, workspaces[origin]),
                  onPressed: () => openSpace(origin),
                  icon: Badge(
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
              railButton(
                tooltip: context.strings.addSpace,
                onPressed: addSpace,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        if (home.supported)
          railButton(
            key: const ValueKey('home-server-details-tab'),
            tooltip: home.running
                ? context.strings.serverInAir
                : context.strings.goLive,
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
          icon: updateBadge(Icons.settings_outlined),
        ),
        railButton(
          key: const ValueKey('my-device-tab'),
          tooltip: context.strings.myDevice,
          selected: devicePage,
          onPressed: showDevice,
          icon: const Icon(Icons.computer_outlined),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
  Future<void> showContextDetails() async {
    closeNavigation();
    await showSpacePopup<void>(
      context,
      top: headerHeight + 22,
      surfaceKey: const ValueKey('space-details-surface'),
      builder: (dialogContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: context.strings.close,
              onPressed: () => Navigator.pop(dialogContext),
              icon: const Icon(Icons.close),
            ),
          ),
          Flexible(child: contextDetails()),
        ],
      ),
    );
  }

  Widget contextPanel() => SizedBox(
    width: SpaceAppearance.sidebarWidth,
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
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
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
            openChannel: (id) {
              unawaited(controller.selectChannel(id));
              select(Section.chat);
            },
            openChat: () => select(Section.chat),
          ),
          Section.chat => ChatView(
            key: const ValueKey('live-chat'),
            controller: controller,
            active:
                !applicationSettings &&
                !dashboard &&
                !devicePage &&
                !serverList &&
                !drawerOpen &&
                selected == Section.chat,
            jumpRequest: jumpRequest,
            jumpGeneration: jumpGeneration,
            showHeader: false,
            topInset: headerHeight,
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
      onDeviceRevoked: () => target.clearOfflineData(),
    );
  }

  IconData get _headerIcon {
    if (devicePage) return Icons.computer_outlined;
    if (serverList) return Icons.dns_outlined;
    if (applicationSettings) return Icons.settings_outlined;
    return selected.icon;
  }

  String get _headerTitle {
    if (serverList) return context.strings.spacesTitle;
    if (devicePage) return context.strings.myDevice;
    if (applicationSettings) return context.strings.appSettings;
    if (dashboard) return context.strings.dashboard;
    if (selected == Section.chat) return chatLabel;
    return selected.localized(context);
  }

  String get _connectionLabel {
    if (controller.reconnecting) return context.strings.reconnecting;
    if (controller.connected) return context.strings.keyLogin;
    return context.strings.disconnected;
  }

  Widget header(bool compact) => SpaceHeader(
    minHeight: compact ? 62 : SpaceAppearance.headerHeight,
    title: _headerTitle,
    subtitle: !applicationSettings && !dashboard && selected == Section.chat
        ? (compact ? spaceLabel : context.strings.chatDescription)
        : null,
    leading: [
      if (compact)
        IconButton(
          key: const ValueKey('navigation-menu-button'),
          tooltip: context.strings.openNavigation,
          focusNode: menuButtonFocus,
          onPressed: drawerOpen ? closeNavigation : openNavigation,
          icon: const Icon(Icons.menu),
        ),
      if (!compact) ...[
        IgnorePointer(child: Icon(_headerIcon, size: 22)),
        const SizedBox(width: 12),
      ],
    ],
    actions: [
      if (!compact && !dashboard && !applicationSettings)
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IgnorePointer(
            child: Text(
              _connectionLabel,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      if (!compact) _connectionButton(),
      IconButton(
        tooltip: context.strings.search,
        onPressed: search,
        icon: const Icon(Icons.search),
      ),
      IconButton(
        key: const ValueKey('space-details'),
        tooltip: context.strings.connectionInformation,
        onPressed: showContextDetails,
        icon: const Icon(Icons.view_sidebar_outlined),
      ),
    ],
  );

  Widget _connectionButton() => IconButton(
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
  );
  Widget updateBadge(IconData icon) =>
      BlocSelector<AppUpdates, AppUpdateState, bool>(
        bloc: updates,
        selector: (state) => state.status == AppUpdateStatus.available,
        builder: (context, available) => Badge(
          key: const ValueKey('app-update-badge'),
          isLabelVisible: available,
          child: Icon(icon),
        ),
      );

  void _refreshShell() {
    if (mounted) setState(() {});
  }

  void _preferencesChanged(BuildContext context, PreferencesState state) {
    unawaited(watchSavedServers());
    _refreshShell();
  }

  void _workspacesChanged(BuildContext context, WorkspaceState state) {
    cacheServerIcons();
    handleDeniedServers();
    _refreshShell();
  }

  void _presenceChanged(BuildContext context, PresenceState state) {
    final change = state.change;
    if (change != null) announcePresence(change);
    _refreshShell();
  }

  int get _workspacePageIndex {
    if (serverList) return 4;
    if (devicePage) return 3;
    if (applicationSettings) return 2;
    if (dashboard) return 0;
    return 1;
  }

  Future<void> _onDeviceRestored(String origin, ChatController target) async {
    await workspaces.adopt(origin, target, owned: target != widget.controller);
    transientControllers.remove(target);
    await widget.preferences.remember(origin);
  }

  Widget _workspaceContent(BuildContext context, BoxConstraints box) {
    final compact = box.maxWidth < 760;
    return Stack(
      children: [
        Positioned.fill(
          child: SpaceContentInsets(
            top: headerHeight,
            child: Column(
              children: [
                if (!dashboard &&
                    selected == Section.chat &&
                    (controller.reconnecting ||
                        controller.busy ||
                        controller.error.isNotEmpty))
                  SizedBox(height: headerHeight),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: _workspacePageIndex,
                          children: [
                            Dashboard(
                              workspaces: workspaces,
                              presence: presence,
                              homeAction: home.supported ? showHome : null,
                              homeDetails: home.supported
                                  ? showHomeDetails
                                  : null,
                              createOwnSpace: home.supported
                                  ? createOwnSpace
                                  : null,
                              importSpace: home.supported && home.ip.isEmpty
                                  ? showHomeDetails
                                  : null,
                              homeRunning: home.running,
                              homeBusy: home.busy,
                              addSpace: addSpace,
                              openSpace: (origin) => openSpace(origin),
                              removeSpace: (origin) => removeSpace(origin),
                              openChannel: (origin, channel) =>
                                  openSpace(origin, channel: channel),
                            ),
                            pages(),
                            SettingsPanel(
                              preferences: widget.preferences,
                              updates: updates,
                              prepareInstall: prepareAppInstall,
                            ),
                            DevicePanel(
                              workspaces: workspaces,
                              fallback: deviceController,
                              restoreController: (origin) =>
                                  workspaces[origin] ?? createTransient(),
                              onRestored: _onDeviceRestored,
                            ),
                            ServerInbox(
                              controllers: workspaces.controllers,
                              presence: presence,
                              icons: widget.preferences.serverIcons,
                              open: (origin) => openSpace(origin),
                              remove: (origin) => removeSpace(origin),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: MeasureSize(
            onChange: headerResized,
            child: GlassSurface(
              radius: 0,
              blur: 24,
              showBorder: false,
              child: header(compact),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigation(BuildContext context) => NavigationBar(
    selectedIndex: bottomIndex,
    onDestinationSelected: _selectBottomPage,
    destinations: [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        label: context.strings.overview,
      ),
      NavigationDestination(
        icon: Icon(Icons.dns_outlined),
        label: context.strings.spacesTitle,
      ),
      NavigationDestination(
        icon: Icon(Icons.computer_outlined),
        label: context.strings.myDevice,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_suggest_outlined),
        label: context.strings.managementTab,
        enabled: controller.administration != null && !controller.busy,
      ),
    ],
  );

  void _selectBottomPage(int index) {
    switch (index) {
      case 0:
        showDashboard();
      case 1:
        showServers();
      case 2:
        select(Section.identity);
      case 3:
        select(Section.settings);
    }
  }

  Widget _responsiveShell(BuildContext context, BoxConstraints box) {
    final compact = box.maxWidth < 760;
    if (!compact && drawerOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && drawerOpen) closeNavigation();
      });
    }
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): closeNavigation,
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            unawaited(search()),
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            unawaited(search()),
      },
      child: PopScope(
        canPop: !drawerOpen,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) closeNavigation();
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            key: scaffold,

            bottomNavigationBar: compact
                ? IgnorePointer(
                    ignoring: drawerOpen,
                    child: ExcludeFocus(
                      excluding: drawerOpen,
                      child: ExcludeSemantics(
                        excluding: drawerOpen,
                        child: _bottomNavigation(context),
                      ),
                    ),
                  )
                : null,
            body: SpaceFrame(
              compact: compact,
              navigationOpen: drawerOpen,
              closeNavigation: closeNavigation,
              openNavigation: openNavigation,
              rail: rail(),
              sidebar: compact ? mobileNavigation() : navigationSidebar(),
              content: _workspaceContent(context, box),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MultiBlocListener(
    listeners: [
      BlocListener<AppPreferences, PreferencesState>(
        bloc: widget.preferences,
        listener: _preferencesChanged,
      ),
      BlocListener<ServerWorkspaces, WorkspaceState>(
        bloc: workspaces,
        listener: _workspacesChanged,
      ),
      BlocListener<HomeController, HomeState>(
        bloc: home,
        listener: (_, state) => _refreshShell(),
      ),
      BlocListener<AppUpdates, AppUpdateState>(
        bloc: updates,
        listenWhen: (before, after) => before.installing != after.installing,
        listener: (_, state) => _refreshShell(),
      ),
      BlocListener<ServerPresence, PresenceState>(
        bloc: presence,
        listener: _presenceChanged,
      ),
    ],
    child: BlocBuilder<ChatController, ChatState>(
      bloc: controller,
      builder: (context, _) => AbsorbPointer(
        absorbing: updates.installing,
        child: ExcludeFocus(
          excluding: updates.installing,
          child: LayoutBuilder(builder: _responsiveShell),
        ),
      ),
    ),
  );
}
