import '../l10n/strings.dart';
import 'admin_panel.dart';

import 'package:flutter/material.dart';

import 'recovery_panel.dart';

import '../src/chat_controller.dart';
import '../src/preferences.dart';
import '../src/home_controller.dart';
import 'components.dart';

class OverviewPanel extends StatelessWidget {
  const OverviewPanel({
    super.key,
    required this.controller,
    required this.openConnection,
    required this.openChat,
    this.home,
    this.homeAction,
    this.homeDetails,
  });
  final ChatController controller;
  final VoidCallback openConnection, openChat;
  final HomeController? home;
  final VoidCallback? homeAction, homeDetails;
  @override
  Widget build(BuildContext context) => PageBody(
    title: context.strings.welcome,
    description: context.strings.welcomeDescription,
    children: [
      if (home != null) ...[
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Мой домашний сервер',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                home!.busy
                    ? home!.phase
                    : home!.running
                    ? 'Сервер работает. После отключения все данные сохранятся.'
                    : 'Запустите своё пространство на этом компьютере.',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: home!.busy || controller.busy
                        ? null
                        : homeAction,
                    icon: Icon(
                      home!.running ? Icons.power_settings_new : Icons.sensors,
                    ),
                    label: Text(home!.running ? 'Отключиться' : 'Выйти в эфир'),
                  ),
                  OutlinedButton.icon(
                    onPressed: home!.busy ? null : homeDetails,
                    icon: const Icon(Icons.tune),
                    label: const Text('Мой сервер'),
                  ),
                ],
              ),
              if (home!.error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  home!.error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
            const SizedBox(height: 20),
            Text(
              context.strings.ideas,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Text(
              context.strings.connectDescription,
              style: TextStyle(height: 1.8),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: controller.busy
                  ? null
                  : controller.connected
                  ? openChat
                  : openConnection,
              icon: Icon(
                controller.connected ? Icons.arrow_forward : Icons.add,
              ),
              label: Text(
                controller.connected
                    ? context.strings.returnChat
                    : context.strings.addSpace,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      AdaptiveCards(
        children: [
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.yourConversation,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                Text(
                  controller.connected
                      ? context.strings.messageCount(controller.messages.length)
                      : context.strings.noMessages,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: openChat,
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(context.strings.openChat),
                ),
              ],
            ),
          ),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.yourAttention,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                Text(
                  context.strings.attentionDescription,
                  style: TextStyle(height: 1.7),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key, required this.preferences});
  final AppPreferences preferences;
  @override
  Widget build(BuildContext context) => PageBody(
    title: context.strings.settingsTitle,
    description: context.strings.settingsDescription,
    children: [
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: preferences.language,
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
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(context.strings.darkTheme),
              subtitle: Text(context.strings.themeDescription),
              value: preferences.dark,
              onChanged: (value) => preferences.change(dark: value),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(context.strings.compact),
              subtitle: Text(context.strings.compactDescription),
              value: preferences.compact,
              onChanged: (value) => preferences.change(compact: value),
            ),
            const Divider(),
            const SizedBox(height: 12),
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
                    selected: preferences.palette == entry.key,
                    onSelected: (_) => preferences.change(palette: entry.key),
                  ),
              ],
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
              context.strings.spaceAppearance,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              context.strings.spaceAppearanceDescription,
              style: TextStyle(height: 1.7),
            ),
          ],
        ),
      ),
      if (preferences.error.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text(
          preferences.error,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
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
                      const SizedBox(height: 8),
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
            const SizedBox(height: 12),
            const Text(
              'Карточка относится к выбранному серверу. Она не содержит историю сообщений; права и сохранённая история загружаются с сервера после восстановления.',
              style: TextStyle(height: 1.7),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      if (controller.administration != null)
        FilledButton.icon(
          onPressed: () async {
            await openServerAdministration(
              context,
              controller.administration!,
              onDeviceRevoked: () {
                controller.disconnect();
              },
            );
            await controller.refreshChannels();
          },
          icon: const Icon(Icons.settings_outlined),
          label: const Text('Управление пространством'),
        ),
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
            const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        Text(description, style: const TextStyle(height: 1.7)),
        const SizedBox(height: 20),
        const Text('Пока недоступно', style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
