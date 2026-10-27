import 'theme_mode_picker.dart';

import 'dart:io';

import 'mls_create.dart';
import '../src/voice_devices.dart';
import 'voice_shortcut_settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';

import 'package:flutter/material.dart';

import 'recovery_panel.dart';

import '../src/chat_controller.dart';
import '../src/generated/space/v1/space.pb.dart' show Channel;
import '../src/preferences.dart';
import '../src/app_updates.dart';
import 'components.dart';
import 'app_updates_view.dart';
import 'shortcut_settings.dart';
import 'notification_settings.dart';
import 'member_profile.dart';

class OverviewPanel extends StatelessWidget {
  const OverviewPanel({
    super.key,
    required this.controller,
    required this.openChat,
    required this.openChannel,
    this.actions = const [],
  });
  final ChatController controller;
  final VoidCallback openChat;
  final ValueChanged<String> openChannel;
  final List<Widget> actions;

  Widget navigationActions() => actions.isEmpty
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: SurfaceCard(child: Column(children: actions)),
        );

  String _connectionStatus(BuildContext context) {
    if (controller.reconnecting) return context.strings.reconnecting;
    if (controller.connected) return context.strings.connected;
    return context.strings.serverOffline;
  }

  Widget _metric(BuildContext context, String label, int count) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$count', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(label),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final channels = controller.channels
        .where((c) => !c.archived && c.permissions.visible)
        .toList();
    final unread = channels.fold(
      0,
      (total, c) => total + controller.unreadCount(c.id),
    );
    final status = _connectionStatus(context);
    return PageBody(
      title: controller.spaceTitle.isEmpty
          ? context.strings.welcome
          : controller.spaceTitle,
      description: context.strings.welcomeDescription,
      children: [
        navigationActions(),
        SurfaceCard(
          hoverBorder: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    controller.connected
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(status)),
                ],
              ),
              if (controller.knownOrigin.isNotEmpty) ...[
                const SizedBox(height: 16),
                SelectableText(controller.knownOrigin),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (controller.memberProfile != null) ...[
          MemberProfileCard(
            key: ValueKey(('profile', controller)),
            controller: controller,
          ),
          const SizedBox(height: 24),
        ],
        if (controller.mlsSession?.mlsSupported == true &&
            controller.administration != null) ...[
          CreateMlsChannelButton(
            session: controller.mlsSession!,
            created: openChannel,
          ),
          const SizedBox(height: 24),
        ],
        AdaptiveCards(
          children: [
            _metric(
              context,
              context.strings.dashboardChannels,
              channels.length,
            ),
            _metric(context, context.strings.dashboardUnread, unread),
          ],
        ),
        const SizedBox(height: 24),
        SurfaceCard(
          hoverBorder: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.strings.channels,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (channels.isEmpty) Text(context.strings.serverNoChannels),
              for (final channel in channels) _channelTile(context, channel),
            ],
          ),
        ),
        if (controller.canRead) ...[
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: openChat,
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text(context.strings.openChat),
          ),
        ],
      ],
    );
  }

  Widget _channelTile(BuildContext context, Channel channel) => ListTile(
    key: ValueKey('overview-channel-${channel.id}'),
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.tag),
    title: Text(channel.title),
    trailing: controller.unreadCount(channel.id) > 0
        ? Badge(label: Text('${controller.unreadCount(channel.id)}'))
        : const Icon(Icons.chevron_right),
    onTap: () => openChannel(channel.id),
  );
}

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    super.key,
    required this.preferences,
    this.updates,
    this.prepareInstall,
    this.requestNotificationPermission,
    this.deviceTransfer,
    this.directoryBackup,
    this.voiceDevices,
    this.voiceSettings,
  });
  final AppUpdates? updates;
  final Future<void> Function()? prepareInstall;
  final Future<bool> Function()? requestNotificationPermission;
  final AppPreferences preferences;
  final Widget? deviceTransfer;
  final Widget? directoryBackup;
  final VoiceDevices? voiceDevices;
  final Widget? voiceSettings;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AppPreferences, PreferencesState>(
        bloc: preferences,
        builder: (context, state) => _build(context, state),
      );

  Widget _build(BuildContext context, PreferencesState state) => PageBody(
    title: context.strings.settingsTitle,
    description: context.strings.settingsDescription,
    children: [
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              key: const ValueKey('app-language'),
              isExpanded: true,
              initialValue: state.language,
              decoration: InputDecoration(labelText: context.strings.language),
              items: const [
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'zh-Hans', child: Text('简体中文')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) => preferences.change(language: value),
            ),
            const SizedBox(height: 24),
            Text(
              context.strings.appearance,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ThemeModePicker(preferences: preferences, mode: state.themeMode),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(context.strings.glassEffects),
              subtitle: Text(context.strings.glassEffectsHelp),
              value: state.effects,
              onChanged: (value) => preferences.change(effects: value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              key: ValueKey('ui-scale-${state.uiScale}'),
              initialValue: state.uiScale,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.strings.interfaceScale,
              ),
              items: [
                for (final scale in AppPreferences.uiScales)
                  DropdownMenuItem(
                    value: scale,
                    child: Text('${(scale * 100).round()}%'),
                  ),
              ],
              onChanged: (value) => preferences.change(uiScale: value),
            ),
            const SizedBox(height: 16),
            Text(context.strings.myColors),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final entry in {
                  'gruvbox': 'Gruvbox',
                  'ocean': context.strings.ocean,
                  'iris': context.strings.iris,
                }.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: state.palette == entry.key,
                    onSelected: (_) => preferences.change(palette: entry.key),
                  ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      ShortcutSettings(
        preferences: preferences,
        value: state.sendShortcut,
        additionalShortcuts: voiceDevices == null || Platform.isAndroid
            ? null
            : VoiceShortcutSettings(devices: voiceDevices!),
      ),
      const SizedBox(height: 24),
      if (voiceSettings != null) ...[
        SurfaceCard(child: voiceSettings!),
        const SizedBox(height: 24),
      ],
      NotificationSettings(
        preferences: preferences,
        requestPermission: requestNotificationPermission,
      ),
      if (state.error.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text(
          state.error,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ],
      const SizedBox(height: 24),
      AppUpdatesView(updates: updates, prepareInstall: prepareInstall),
      if (directoryBackup != null) ...[const SizedBox(height: 24), directoryBackup!],
      if (deviceTransfer != null) ...[
        const SizedBox(height: 24),
        deviceTransfer!,
      ],
    ],
  );
}

class IdentityPanel extends StatelessWidget {
  const IdentityPanel({
    super.key,
    required this.controller,
    required this.revoke,
  });
  final ChatController controller;
  final VoidCallback revoke;
  @override
  Widget build(BuildContext context) => PageBody(
    title: 'Вы — это вы.',
    description: 'Ключи устройства и доверие к выбранному пространству.',
    children: [
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: const Icon(Icons.person_outline, size: 30),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Этот компьютер',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.connected
                            ? 'Вход выполнен по ключу устройства'
                            : 'Активного подключения нет',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Пользовательские ключи хранятся в системном защищённом хранилище. Сервер получает публичные ключи и подписи. Аппаратная изоляция не заявляется.',
              style: TextStyle(height: 1.7),
            ),
            if (controller.principalId.isNotEmpty) ...[
              const SizedBox(height: 14),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('Сведения для проверки'),
                children: [
                  SelectableText(controller.principalId),
                  const SizedBox(height: 10),
                  SelectableText(controller.fingerprint),
                  const SizedBox(height: 16),
                ],
              ),
            ],
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: controller.connected && !controller.busy
                  ? revoke
                  : null,
              icon: const Icon(Icons.no_accounts_outlined),
              label: const Text('Отозвать это устройство здесь'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Восстановление ключей',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Карточка относится к выбранному серверу. Она не содержит историю сообщений; права и сохранённая история загружаются с сервера после восстановления.',
              style: TextStyle(height: 1.7),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      const SizedBox(height: 20),
      RecoveryPanel(controller: controller),
    ],
  );
}

class UnavailablePanel extends StatelessWidget {
  const UnavailablePanel({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });
  final String title, description;
  final IconData icon;
  @override
  Widget build(BuildContext context) => PageBody(
    title: title,
    description: description,
    children: [
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 44, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 18),
            Text(
              'Пока недоступно',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'В этой версии клиента работает текстовый чат. Раздел появится, когда его поддержат клиент и выбранное пространство.',
              style: TextStyle(height: 1.8),
            ),
          ],
        ),
      ),
    ],
  );
}

class RoomsPanel extends StatelessWidget {
  const RoomsPanel({super.key});
  @override
  Widget build(BuildContext context) => PageBody(
    title: 'Быть рядом — по-разному.',
    description: 'Вы выбираете формат. Перед входом камера и микрофон должны оставаться выключенными.',
    children: [
      AdaptiveCards(
        children: [
          room(
            context,
            Icons.mic_none,
            'Голосовая комната',
            'Разговор без камеры, возможность просто слушать.',
          ),
          room(
            context,
            Icons.videocam_outlined,
            'Видео-встреча',
            'Видео и совместная работа с экраном.',
          ),
        ],
      ),
      const SizedBox(height: 18),
      AdaptiveCards(
        children: [
          room(
            context,
            Icons.record_voice_over_outlined,
            'Сцена',
            'Спикеры и слушатели; выступление после согласия.',
          ),
          room(
            context,
            Icons.live_tv,
            'Прямой эфир',
            'Трансляция с понятными условиями доступа и записи.',
          ),
        ],
      ),
    ],
  );
  Widget room(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 18),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(description, style: const TextStyle(height: 1.7)),
        const SizedBox(height: 20),
        const Text('Пока недоступно', style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
