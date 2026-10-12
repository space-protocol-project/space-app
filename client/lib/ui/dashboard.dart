import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/server_presence.dart';
import '../src/server_workspaces.dart';
import 'components.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.workspaces,
    required this.presence,
    required this.addSpace,
    required this.openSpace,
    required this.openChannel,
    this.homeAction,
    this.homeDetails,
    this.homeRunning = false,
    this.homeBusy = false,
  });
  final ServerWorkspaces workspaces;
  final ServerPresence presence;
  final VoidCallback addSpace;
  final ValueChanged<String> openSpace;
  final void Function(String, String) openChannel;
  final VoidCallback? homeAction;
  final VoidCallback? homeDetails;
  final bool homeRunning, homeBusy;

  @override
  Widget build(BuildContext context) {
    final entries = workspaces.controllers.entries.toList();
    final known = entries
        .where(
          (entry) =>
              entry.value.connected && presence.online(entry.key) != false,
        )
        .toList();
    final channels = known.fold(
      0,
      (count, entry) =>
          count +
          entry.value.channels
              .where((channel) => channel.permissions.read)
              .length,
    );
    final unread = known.fold(
      0,
      (count, entry) =>
          count +
          entry.value.channels.fold(
            0,
            (sum, channel) => sum + entry.value.unreadCount(channel.id),
          ),
    );
    return PageBody(
      title: context.strings.dashboardTitle,
      description: context.strings.dashboardDescription,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Metric(
              label: context.strings.dashboardServers,
              value: entries.length,
              icon: Icons.dns_outlined,
            ),
            _Metric(
              label: context.strings.dashboardOnline,
              value: entries
                  .where((entry) => presence.online(entry.key) == true)
                  .length,
              icon: Icons.cloud_done_outlined,
            ),
            _Metric(
              label: context.strings.dashboardChannels,
              value: channels,
              icon: Icons.tag,
            ),
            _Metric(
              label: context.strings.dashboardUnread,
              value: unread,
              icon: Icons.mark_chat_unread_outlined,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: addSpace,
              icon: const Icon(Icons.add),
              label: Text(context.strings.addSpace),
            ),
            OutlinedButton.icon(
              onPressed: () {
                workspaces.refresh();
                presence.check();
              },
              icon: const Icon(Icons.refresh),
              label: Text(context.strings.dashboardRefresh),
            ),
            if (homeDetails != null)
              OutlinedButton.icon(
                key: const ValueKey('home-server-details'),
                onPressed: homeDetails,
                icon: const Icon(Icons.dns_outlined),
                label: Text(context.strings.myServer),
              ),
            if (MediaQuery.sizeOf(context).width < 760 && homeAction != null)
              OutlinedButton.icon(
                onPressed: homeBusy ? null : homeAction,
                icon: Icon(
                  homeRunning ? Icons.power_settings_new : Icons.sensors,
                ),
                label: Text(
                  homeRunning
                      ? context.strings.stopHome
                      : context.strings.goLive,
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        if (entries.isEmpty)
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.hub_outlined,
                  size: 42,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  context.strings.dashboardEmpty,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(context.strings.dashboardEmptyHelp),
              ],
            ),
          ),
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      presence.online(entry.key) == true
                          ? Icons.cloud_done_outlined
                          : Icons.dns_outlined,
                    ),
                    title: Text(
                      entry.value.spaceTitle.isEmpty
                          ? Uri.parse(entry.key).authority
                          : entry.value.spaceTitle,
                    ),
                    subtitle: Text(
                      '${entry.key}\n${presence.online(entry.key) == null
                          ? context.strings.serverAvailabilityUnknown
                          : presence.online(entry.key) == true
                          ? context.strings.dashboardAvailable
                          : context.strings.dashboardUnavailable}',
                    ),
                    onTap: () => openSpace(entry.key),
                  ),
                  if (!entry.value.connected ||
                      presence.online(entry.key) == false)
                    Text(context.strings.dashboardCatalogUnknown)
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final channel in entry.value.channels)
                          ActionChip(
                            avatar: Icon(
                              channel.permissions.read
                                  ? Icons.tag
                                  : Icons.lock_outline,
                              size: 16,
                            ),
                            label: Text(
                              '${channel.title}${entry.value.unreadCount(channel.id) > 0 ? ' · ${entry.value.unreadCount(channel.id)}' : ''}',
                            ),
                            onPressed: entry.value.busy
                                ? null
                                : () => openChannel(entry.key, channel.id),
                          ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => openSpace(entry.key),
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(context.strings.dashboardOpen),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          context.strings.dashboardResourcesHelp,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label;
  final int value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 210,
    child: SurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text('$value', style: Theme.of(context).textTheme.headlineMedium),
          Text(label),
        ],
      ),
    ),
  );
}
