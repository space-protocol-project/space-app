import '../src/generated/space/v1/space.pb.dart' show Channel;

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/server_presence.dart';
import '../src/server_workspaces.dart';
import 'components.dart';
import 'dashboard_highlights.dart';
import '../src/community_overview.dart';
import 'space_availability.dart';
import '../src/chat_controller.dart';

import 'package:space_admin_ui/space_admin_ui.dart' show ServerIconView;

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
    required this.workspaces,
    required this.presence,
    required this.addSpace,
    required this.openSpace,
    required this.openChannel,
    this.removeSpace,
    this.openCommunity,
    this.active = true,
    this.homeAction,
    this.homeDetails,
    this.createOwnSpace,
    this.importSpace,
    this.homeRunning = false,
    this.homeBusy = false,
  });
  final ServerWorkspaces workspaces;
  final ServerPresence presence;
  final VoidCallback addSpace;
  final ValueChanged<String> openSpace;
  final ValueChanged<String>? removeSpace;
  final ValueChanged<DashboardCommunityTarget>? openCommunity;
  final bool active;
  final void Function(String, String) openChannel;
  final VoidCallback? homeAction;
  final VoidCallback? homeDetails;
  final VoidCallback? createOwnSpace;
  final VoidCallback? importSpace;
  final bool homeRunning, homeBusy;

  @override
  State<Dashboard> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard> {
  final highlights = GlobalKey<DashboardHighlightsState>();
  @override
  Widget build(BuildContext context) {
    final entries = widget.workspaces.controllers.entries.toList();
    final known = entries
        .where(
          (entry) =>
              entry.value.connected &&
              widget.presence.online(entry.key) != false,
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
        _actions(context),
        const SizedBox(height: 24),
        _DashboardMetrics(
          servers: entries.length,
          online: entries
              .where((entry) => widget.presence.online(entry.key) == true)
              .length,
          channels: channels,
          unread: unread,
        ),
        const SizedBox(height: 24),
        DashboardHighlights(
          key: highlights,
          workspaces: widget.workspaces,
          presence: widget.presence,
          active: widget.active,
          openSpace: widget.openSpace,
          openChannel: widget.openChannel,
          openCommunity:
              widget.openCommunity ??
              (target) => widget.openSpace(target.origin),
        ),
        const SizedBox(height: 28),
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
                const SizedBox(height: 16),
                Text(context.strings.dashboardEmptyHelp),
              ],
            ),
          ),
        LayoutBuilder(
          builder: (context, box) {
            final width = box.maxWidth < 700
                ? box.maxWidth
                : (box.maxWidth - 20) / 2;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                for (final entry in entries)
                  SizedBox(
                    width: width,
                    child: _SpaceOverviewCard(
                      origin: entry.key,
                      controller: entry.value,
                      online: widget.presence.online(entry.key),
                      open: () => widget.openSpace(entry.key),
                      remove: widget.removeSpace == null
                          ? null
                          : () => widget.removeSpace!(entry.key),
                      openChannel: (id) => widget.openChannel(entry.key, id),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (MediaQuery.sizeOf(context).width < 760)
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  onPressed: widget.addSpace,
                  icon: const Icon(Icons.add),
                  label: Text(context.strings.addSpace),
                ),
                if (widget.createOwnSpace != null) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: widget.homeBusy ? null : widget.createOwnSpace,
                    icon: const Icon(Icons.add_home_outlined),
                    label: Text(context.strings.createOwnSpace),
                  ),
                ],
              ],
            ),
          ),
        OutlinedButton.icon(
          onPressed: () {
            widget.workspaces.refresh();
            widget.presence.check();
            highlights.currentState?.refresh();
          },
          icon: const Icon(Icons.refresh),
          label: Text(context.strings.dashboardRefresh),
        ),
        if (widget.importSpace != null)
          OutlinedButton.icon(
            key: const ValueKey('import-space-entry'),
            onPressed: widget.homeBusy ? null : widget.importSpace,
            icon: const Icon(Icons.file_download_outlined),
            label: Text(context.strings.homeImport),
          ),
        if (MediaQuery.sizeOf(context).width < 760 &&
            widget.homeDetails != null)
          OutlinedButton.icon(
            key: const ValueKey('home-server-details'),
            onPressed: widget.homeDetails,
            icon: const Icon(Icons.sensors),
            label: Text(context.strings.goLive),
          ),
      ],
    );
  }
}

class _SpaceOverviewCard extends StatelessWidget {
  const _SpaceOverviewCard({
    required this.origin,
    required this.controller,
    required this.online,
    required this.open,
    required this.openChannel,
    this.remove,
  });
  final String origin;
  final ChatController controller;
  final bool? online;
  final VoidCallback open;
  final VoidCallback? remove;
  final ValueChanged<String> openChannel;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    hoverBorder: true,
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: open,
          leading: ServerIconView(
            value: controller.serverIcon?.toProto3Json(),
            size: 44,
          ),
          title: Text(
            controller.spaceTitle.isEmpty
                ? Uri.parse(origin).authority
                : controller.spaceTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SpaceAvailability(online: online),
          ),
          trailing: remove == null
              ? null
              : PopupMenuButton<String>(
                  onSelected: (_) => remove!(),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text(context.strings.removeServer),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 8),
        Text(
          origin,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 20),
        if (!controller.connected || online == false)
          Text(context.strings.dashboardCatalogUnknown)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final channel in controller.channels)
                _channelChip(context, channel),
            ],
          ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: open,
            icon: const Icon(Icons.arrow_forward),
            label: Text(context.strings.dashboardOpen),
          ),
        ),
      ],
    ),
  );
  Widget _channelChip(BuildContext context, Channel channel) => ActionChip(
    avatar: Icon(
      channel.permissions.read ? Icons.tag : Icons.lock_outline,
      size: 16,
    ),
    label: Text(
      '${channel.title}${controller.unreadCount(channel.id) > 0 ? ' · ${controller.unreadCount(channel.id)}' : ''}',
    ),
    onPressed: controller.busy ? null : () => openChannel(channel.id),
  );
}

class _DashboardMetrics extends StatelessWidget {
  const _DashboardMetrics({
    required this.servers,
    required this.online,
    required this.channels,
    required this.unread,
  });
  final int servers, online, channels, unread;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      if (box.maxWidth < 120) return const SizedBox.shrink();
      final columns = box.maxWidth < 700 ? 2 : 4;
      final width = (box.maxWidth - (columns - 1) * 12) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _Metric(
            width: width,
            label: context.strings.dashboardServers,
            value: servers,
            icon: Icons.dns_outlined,
          ),
          _Metric(
            width: width,
            label: context.strings.dashboardOnline,
            value: online,
            icon: Icons.cloud_done_outlined,
          ),
          _Metric(
            width: width,
            label: context.strings.dashboardChannels,
            value: channels,
            icon: Icons.tag,
          ),
          _Metric(
            width: width,
            label: context.strings.dashboardUnread,
            value: unread,
            icon: Icons.mark_chat_unread_outlined,
          ),
        ],
      );
    },
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.icon,
    required this.width,
  });
  final String label;
  final int value;
  final IconData icon;
  final double width;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: SurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Spacer(),
              Text('$value', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: 12),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}
