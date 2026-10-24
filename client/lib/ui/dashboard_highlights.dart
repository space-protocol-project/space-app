import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/community_overview.dart';
import '../src/chat_controller.dart';
import '../src/dashboard_controller.dart';
import '../src/generated/space/v1/community_overview.pb.dart';
import '../src/server_presence.dart';
import '../src/server_workspaces.dart';
import 'components.dart';

class DashboardHighlights extends StatefulWidget {
  const DashboardHighlights({
    super.key,
    required this.workspaces,
    required this.presence,
    required this.openSpace,
    required this.openChannel,
    required this.openCommunity,
    this.active = true,
  });
  final ServerWorkspaces workspaces;
  final ServerPresence presence;
  final ValueChanged<String> openSpace;
  final void Function(String, String) openChannel;
  final ValueChanged<DashboardCommunityTarget> openCommunity;
  final bool active;
  @override
  State<DashboardHighlights> createState() => DashboardHighlightsState();
}

class DashboardHighlightsState extends State<DashboardHighlights>
    with WidgetsBindingObserver {
  late DashboardController controller = DashboardController(
    widget.workspaces,
    widget.presence,
  );
  bool foreground = true;
  void refresh() => unawaited(controller.refresh());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    foreground =
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.paused;
    controller.setActive(widget.active && foreground);
  }

  @override
  void didUpdateWidget(covariant DashboardHighlights oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.workspaces, widget.workspaces) ||
        !identical(oldWidget.presence, widget.presence)) {
      unawaited(controller.close());
      controller = DashboardController(widget.workspaces, widget.presence);
    }
    controller.setActive(widget.active && foreground);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground = state == AppLifecycleState.resumed;
    controller.setActive(widget.active && foreground);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(controller.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DashboardController, DashboardState>(
        bloc: controller,
        builder: (context, state) => LayoutBuilder(
          builder: (context, box) {
            final attention = _attention(state);
            final recent = _recent(state);
            if (box.maxWidth < 950) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [attention, const SizedBox(height: 20), recent],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: attention),
                const SizedBox(width: 20),
                Expanded(child: recent),
              ],
            );
          },
        ),
      );

  Widget _card({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? action,
  }) => SurfaceCard(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            ?action,
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );

  Widget _attention(DashboardState state) {
    final rows = <Widget>[
      ..._connectionRows(),
      ..._reportRows(state),
      ..._replyRows(state),
      ..._chatRows(),
    ];
    return _card(
      title: context.strings.dashboardAttention,
      icon: Icons.notifications_active_outlined,
      children: [
        if (rows.isEmpty)
          Text(
            state.loading
                ? context.strings.dashboardChecking
                : _attentionEmpty(state),
          ),
        ...rows.take(8),
        if (rows.length > 8)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(context.strings.dashboardAttentionLimit),
          ),
      ],
    );
  }

  String _attentionEmpty(DashboardState state) =>
      state.failed || state.unsupported
      ? context.strings.dashboardAttentionUnknown
      : context.strings.dashboardAttentionEmpty;

  List<Widget> _connectionRows() => widget.workspaces.controllers.entries
      .where(
        (entry) =>
            !entry.value.connected ||
            widget.presence.online(entry.key) == false ||
            entry.value.accessRemoved ||
            entry.value.error.isNotEmpty ||
            entry.value.reconnecting,
      )
      .map(
        (entry) => _row(
          key: 'dashboard-connection-${entry.key}',
          icon: Icons.cloud_off_outlined,
          title: context.strings.dashboardConnectionIssue,
          subtitle: _spaceName(entry.key, entry.value.spaceTitle),
          tap: () => widget.openSpace(entry.key),
        ),
      )
      .toList();

  List<Widget> _chatRows() =>
      widget.workspaces.controllers.entries.expand(_chatRowsFor).toList();

  Iterable<Widget> _chatRowsFor(MapEntry<String, ChatController> entry) {
    final chat = entry.value;
    if (!chat.connected ||
        chat.reconnecting ||
        chat.accessRemoved ||
        widget.presence.online(entry.key) == false) {
      return [];
    }
    return chat.channels
        .where(
          (channel) =>
              !channel.archived &&
              channel.permissions.visible &&
              channel.permissions.read &&
              chat.unreadCount(channel.id) > 0,
        )
        .map(
          (channel) => _row(
            key: 'dashboard-unread-${entry.key}-${channel.id}',
            icon: Icons.mark_chat_unread_outlined,
            title: channel.title,
            subtitle: _spaceName(entry.key, chat.spaceTitle),
            count: chat.unreadCount(channel.id),
            tap: () => widget.openChannel(entry.key, channel.id),
          ),
        );
  }

  List<Widget> _reportRows(DashboardState state) => state.communities
      .where(
        (section) =>
            section.overview.canModerate && section.overview.pendingReports > 0,
      )
      .map(
        (section) => _row(
          key: 'dashboard-reports-${section.origin}-${section.channel.id}',
          icon: Icons.flag_outlined,
          title: context.strings.dashboardPendingReports,
          subtitle: _sectionName(section),
          count: section.overview.pendingReports.toInt(),
          tap: () => widget.openCommunity(section.target(reports: true)),
        ),
      )
      .toList();

  List<Widget> _replyRows(DashboardState state) => [
    for (final section in state.communities)
      for (final entry in section.overview.repliesToYou)
        _row(
          key: 'dashboard-reply-${section.origin}-${entry.content.id}',
          icon: Icons.reply_outlined,
          title: entry.content.title,
          subtitle:
              '${context.strings.dashboardRepliesToYou} · ${_sectionName(section)}',
          count: entry.unreadRepliesToYou.toInt(),
          tap: () => widget.openCommunity(
            section.target(
              id: entry.content.id,
              replySequence: entry.firstUnreadReplySequence.toInt(),
            ),
          ),
        ),
  ];

  Widget _recent(DashboardState state) {
    final entries = _recentEntries(state);
    return _card(
      title: context.strings.dashboardCommunityNews,
      icon: Icons.dynamic_feed_outlined,
      action: IconButton(
        tooltip: context.strings.forumRefresh,
        onPressed: state.loading ? null : controller.refresh,
        icon: const Icon(Icons.refresh),
      ),
      children: [
        Text(
          context.strings.dashboardCommunityDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        if (state.loading) const LinearProgressIndicator(),
        ..._recentStatus(state, entries.isEmpty),
        for (final item in entries.take(8))
          _communityRow(item.section, item.entry),
      ],
    );
  }

  List<({DashboardCommunitySection section, CommunityOverviewEntry entry})>
  _recentEntries(DashboardState state) {
    return <
        ({DashboardCommunitySection section, CommunityOverviewEntry entry})
      >[
        for (final section in state.communities)
          for (final entry in section.overview.recent)
            (section: section, entry: entry),
      ]
      ..sort(
        (a, b) => b.entry.content.createdAtUnix.compareTo(
          a.entry.content.createdAtUnix,
        ),
      );
  }

  bool get _hasUnavailableSpaces => widget.workspaces.controllers.entries.any(
    (entry) =>
        !entry.value.connected ||
        entry.value.reconnecting ||
        entry.value.accessRemoved ||
        widget.presence.online(entry.key) == false,
  );

  List<Widget> _recentStatus(DashboardState state, bool empty) {
    final unavailable = _hasUnavailableSpaces;
    return [
      if (state.failed) Text(context.strings.dashboardCommunityFailed),
      if (state.unsupported)
        Text(context.strings.dashboardCommunityUnsupported),
      if (unavailable) Text(context.strings.dashboardCommunityOffline),
      if (empty &&
          !state.loading &&
          !state.failed &&
          !state.unsupported &&
          !unavailable)
        Text(context.strings.dashboardCommunityEmpty),
    ];
  }

  Widget _communityRow(
    DashboardCommunitySection section,
    CommunityOverviewEntry entry,
  ) {
    final content = entry.content;
    return _row(
      key: 'dashboard-community-${section.origin}-${content.id}',
      icon: section.forum ? Icons.forum_outlined : Icons.article_outlined,
      title: _entryTitle(section, entry),
      subtitle:
          '${_sectionName(section)} · ${section.forum ? context.strings.communitySearchThread : context.strings.communitySearchPost}',
      count: entry.readStateSupported ? entry.unreadCount.toInt() : 0,
      tap: () => widget.openCommunity(section.target(id: content.id)),
    );
  }

  String _entryTitle(
    DashboardCommunitySection section,
    CommunityOverviewEntry entry,
  ) {
    if (section.forum) return entry.content.title;
    return entry.content.snippet.trim().isEmpty
        ? context.strings.dashboardAttachmentPost
        : entry.content.snippet;
  }

  String _spaceName(String origin, String title) =>
      title.trim().isEmpty ? origin : title;
  String _sectionName(DashboardCommunitySection section) =>
      '${_spaceName(section.origin, section.spaceTitle)} · ${section.channel.title}';

  Widget _row({
    required String key,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback tap,
    int count = 0,
  }) => ListTile(
    key: ValueKey(key),
    contentPadding: const EdgeInsets.symmetric(vertical: 8),
    leading: Icon(icon, size: 22),
    title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
    subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
    trailing: count > 0
        ? Badge(label: Text('$count'))
        : const Icon(Icons.chevron_right),
    onTap: tap,
  );
}
