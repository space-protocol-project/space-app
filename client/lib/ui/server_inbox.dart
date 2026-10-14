import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/server_presence.dart';
import 'space_availability.dart';
import 'components.dart';

class ServerInbox extends StatefulWidget {
  const ServerInbox({
    super.key,
    required this.controllers,
    required this.presence,
    required this.icons,
    required this.open,
    required this.remove,
  });
  final Map<String, ChatController> controllers;
  final ServerPresence presence;
  final Map<String, Map<String, dynamic>> icons;
  final ValueChanged<String> open, remove;
  @override
  State<ServerInbox> createState() => _ServerInboxState();
}

class _ServerInboxState extends State<ServerInbox> {
  String query = '';
  int filter = 0;
  int unread(ChatController controller) => controller.channels
      .where((c) => !c.archived)
      .fold(0, (sum, c) => sum + controller.unreadCount(c.id));
  String title(String origin, ChatController controller) =>
      controller.spaceTitle.isEmpty
      ? Uri.parse(origin).authority
      : controller.spaceTitle;
  String timeLabel(BuildContext context, int timestamp) {
    if (timestamp <= 0) return '';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
      final now = DateTime.now();
      final local = MaterialLocalizations.of(context);
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return local.formatTimeOfDay(
          TimeOfDay.fromDateTime(date),
          alwaysUse24HourFormat: true,
        );
      }
      return local.formatShortDate(date);
    } on RangeError {
      return '';
    }
  }

  bool _includeServer(MapEntry<String, ChatController> entry) {
    final matches = '${title(entry.key, entry.value)} ${entry.key}'
        .toLowerCase()
        .contains(query.toLowerCase());
    final included =
        filter == 0 ||
        filter == 1 && widget.presence.online(entry.key) == true ||
        filter == 2 && unread(entry.value) > 0;
    return matches && included;
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.controllers.entries.where(_includeServer).toList()
      ..sort(
        (a, b) => (b.value.latestKnownMessage?.createdAtUnixMs.toInt() ?? 0)
            .compareTo(
              a.value.latestKnownMessage?.createdAtUnixMs.toInt() ?? 0,
            ),
      );
    return Material(
      color: Colors.transparent,
      child: CustomScrollView(
        primary: false,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16 + SpaceContentInsets.topOf(context),
                16,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    scrollPadding: SpaceContentInsets.scrollPaddingOf(context),
                    onChanged: (value) => setState(() => query = value),
                    decoration: InputDecoration(
                      hintText: context.strings.serverSearch,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final entry in [
                        context.strings.serverFilterAll,
                        context.strings.dashboardOnline,
                        context.strings.dashboardUnread,
                      ].indexed)
                        ChoiceChip(
                          label: Text(entry.$2),
                          selected: filter == entry.$1,
                          onSelected: (_) => setState(() => filter = entry.$1),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text(context.strings.nothingFound)),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) =>
                    serverRow(context, entries[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget serverRow(
    BuildContext context,
    MapEntry<String, ChatController> entry,
  ) {
    final controller = entry.value;
    final latest = controller.latestKnownMessage;
    final channel = controller.channels
        .where((c) => c.id == latest?.channelId)
        .firstOrNull;
    final online = widget.presence.online(entry.key);
    final preview = latest == null
        ? context.strings.serverNoEvents
        : '${channel?.title ?? latest.channelId}: ${String.fromCharCodes(latest.text.runes.take(180)).replaceAll(RegExp(r'\s+'), ' ')}';
    final count = unread(controller);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: EdgeInsets.zero,
        hoverBorder: true,
        child: ListTile(
          key: ValueKey('server-inbox-${entry.key}'),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Badge(
            isLabelVisible: online == true,
            backgroundColor: Colors.green,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: ServerIconView(value: widget.icons[entry.key], size: 32),
            ),
          ),
          title: Text(
            title(entry.key, controller),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpaceAvailability(online: online),
                const SizedBox(height: 6),
                Text(preview, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeLabel(context, latest?.createdAtUnixMs.toInt() ?? 0),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (count > 0) Badge(label: Text('$count')),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (_) => widget.remove(entry.key),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(context.strings.removeServer),
                  ),
                ],
              ),
            ],
          ),
          onTap: () => widget.open(entry.key),
        ),
      ),
    );
  }
}
