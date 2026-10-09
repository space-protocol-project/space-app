import 'admin_panel.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/chat_controller.dart';
import '../src/preferences.dart';
import '../src/secure_vault.dart';
import 'chat_view.dart';
import 'connection_panel.dart';
import 'panels.dart';
import 'search.dart';
import 'components.dart';

enum Section {
  overview('Обзор', Icons.home_outlined),
  chat('Общий чат', Icons.tag),
  forum('Обсуждения', Icons.forum_outlined),
  feed('Лента', Icons.view_agenda_outlined),
  rooms('Встречи', Icons.headset_mic_outlined),
  identity('Идентичность', Icons.shield_outlined),
  settings('Настройки', Icons.tune);

  const Section(this.label, this.icon);
  final String label;
  final IconData icon;
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
  Section selected = Section.overview;
  Future<void> search() async {
    final route = await showSearch<String>(
      context: context,
      delegate: SpaceSearch({
        for (final section in Section.values)
          section.name: section == Section.chat
              ? controller.chatTitle
              : section.label,
      }, controller.messages),
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
        title: const Text('Отозвать это устройство?'),
        content: const Text(
          'Доступ к выбранному серверу прекратится. Ключи останутся на компьютере; новое разрешение автоматически не создаётся.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Оставить'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Отозвать'),
          ),
        ],
      ),
    );
    if (accepted == true && mounted) await controller.revoke();
  }

  String get spaceLabel => controller.spaceTitle.isNotEmpty
      ? controller.spaceTitle
      : controller.preview?.origin.authority ?? 'Ваше пространство';
  Widget sidebar() => SizedBox(
    width: 248,
    child: Material(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
        children: [
          Container(
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.surfaceContainerHighest,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Space',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            spaceLabel,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            controller.connected ? 'Подключено' : 'Пространство не подключено',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: controller.busy ? null : () => connection(),
            icon: const Icon(Icons.add),
            label: Text(
              controller.connected ? 'Подключение' : 'Добавить пространство',
            ),
          ),
          const SizedBox(height: 20),
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
                            : 'Чаты'
                      : section.label,
                ),
                onTap: () => select(section),
              ),
            ),
          if (controller.channels.isNotEmpty) ...[
            const Divider(height: 24),
            const Text('Каналы', style: TextStyle(fontSize: 12)),
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
                subtitle: channel.archived
                    ? const Text('Архив')
                    : !channel.permissions.read
                    ? const Text('Без доступа к сообщениям')
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
              title: const Text('Управление пространством'),
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
            const Text('Недавние пространства', style: TextStyle(fontSize: 12)),
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
          const Text(
            'Локальный прототип · Windows',
            style: TextStyle(fontSize: 11),
          ),
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
        Text(
          's.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        IconButton.filledTonal(
          tooltip: 'Выбранное пространство',
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
          tooltip: 'Добавить пространство',
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
          tooltip: 'Моя идентичность',
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
            'О пространстве',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 14),
          const Text(
            'Независимый сервер. Ваши права и доступные разделы определяются отдельно в каждом пространстве.',
            style: TextStyle(fontSize: 12, height: 1.8),
          ),
          const Divider(height: 36),
          Text('Подключение', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(
            controller.connected
                ? 'Вход по ключу устройства выполнен'
                : 'Нет активной сессии',
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
          OutlinedButton(
            onPressed: () => connection(),
            child: const Text('Проверить подключение'),
          ),
          const Divider(height: 36),
          Text(
            'Можно быть собой.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'Не обязательно отвечать сразу. Камера и микрофон не используются; системные уведомления пока выключены.',
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
        openConnection: () => connection(),
        openChat: () => select(Section.chat),
      ),
      ChatView(
        key: const ValueKey('live-chat'),
        controller: controller,
        active: selected == Section.chat,
        openConnection: () => connection(),
      ),
      const UnavailablePanel(
        title: 'Хорошие разговоры остаются.',
        description: 'Место для обсуждений, которым нужно больше времени.',
        icon: Icons.forum_outlined,
      ),
      const UnavailablePanel(
        title: 'Немного вдохновения.',
        description: 'Публикации людей, которых вы выбрали.',
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
            tooltip: 'Открыть навигацию',
            onPressed: () => scaffold.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        Expanded(
          child: Text(
            selected == Section.chat ? controller.chatTitle : selected.label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              controller.reconnecting
                  ? 'Восстанавливаем соединение'
                  : controller.connected
                  ? 'Вход по ключу'
                  : 'Не подключено',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        IconButton(
          tooltip: 'Подключение к серверу',
          onPressed: controller.busy ? null : () => connection(),
          icon: Icon(
            controller.connected
                ? Icons.cloud_done_outlined
                : Icons.cloud_off_outlined,
          ),
        ),
        IconButton(
          tooltip: 'Настройки оформления',
          onPressed: () => select(Section.settings),
          icon: const Icon(Icons.tune),
        ),
        IconButton(
          tooltip: 'Поиск',
          onPressed: search,
          icon: const Icon(Icons.search),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([controller, widget.preferences]),
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
                        'Восстанавливаем события. Сообщения и черновик сохранены.',
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
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          label: 'Обзор',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.tag),
                          label: 'Чат',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.forum_outlined),
                          label: 'Темы',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.headset_mic_outlined),
                          label: 'Встречи',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.shield_outlined),
                          label: 'Профиль',
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
