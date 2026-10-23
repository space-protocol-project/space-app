import '../src/message_search.dart';
import '../src/message_search_controller.dart';
import '../src/message_summary.dart';
import '../l10n/strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/generated/space/v1/space.pb.dart';

class SpaceSearchPanel extends StatefulWidget {
  const SpaceSearchPanel({
    super.key,
    required this.sections,
    required this.messages,
    this.searchMessages,
    this.onMessageSelected,
    this.localOnly = false,
    this.searchAllChannels,
    this.channelNames = const {},
    this.allChannelsLabel,
    this.allChannelsLocalOnly = false,
  });
  final Map<String, String> sections;
  final List<Content> messages;
  final Future<MessageSearchPage> Function(String query, String cursor)?
  searchMessages;
  final void Function(Content)? onMessageSelected;
  final bool localOnly;
  final Future<MessageSearchPage> Function(String, String)? searchAllChannels;
  final Map<String, String> channelNames;
  final String? allChannelsLabel;
  final bool allChannelsLocalOnly;
  @override
  State<SpaceSearchPanel> createState() => _SpaceSearchPanelState();
}

class _SpaceSearchPanelState extends State<SpaceSearchPanel> {
  final input = TextEditingController();
  late final search = MessageSearchController(
    searchMessages: widget.searchMessages,
    searchAllChannels: widget.searchAllChannels,
  );

  @override
  void didUpdateWidget(covariant SpaceSearchPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    search.searchMessages = widget.searchMessages;
    search.searchAllChannels = widget.searchAllChannels;
  }

  String searchSource(BuildContext context, MessageSearchState state) {
    if (state.allChannels && !widget.allChannelsLocalOnly) {
      return context.strings.messageSearchMixed;
    }
    if (widget.localOnly || state.allChannels && widget.allChannelsLocalOnly) {
      return context.strings.messageSearchLocal;
    }
    return context.strings.messageSearchServer;
  }

  Widget searchStatus(BuildContext context, MessageSearchState state) => Column(
    children: [
      Text(searchSource(context, state)),
      if (state.loading) const LinearProgressIndicator(),
      if (state.failed)
        TextButton(
          onPressed: search.load,
          child: Text(context.strings.messageSearchFailed),
        ),
      if (state.messages.length >= MessageSearchController.resultLimit)
        Text(context.strings.messageSearchLimit),
    ],
  );

  void selectMessage(BuildContext context, Content message) {
    widget.onMessageSelected?.call(message);
    Navigator.pop(context, 'message:${message.id}');
  }

  @override
  void dispose() {
    search.close();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MessageSearchController, MessageSearchState>(
        bloc: search,
        builder: (context, state) => searchPanel(context, state),
      );

  Widget searchPanel(BuildContext context, MessageSearchState state) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('space-search-input'),
                    controller: input,
                    autofocus: true,
                    onChanged: search.changeQuery,
                    maxLength: 128,
                    decoration: InputDecoration(
                      hintText: search.activeSearch == null
                          ? context.strings.searchHint
                          : context.strings.search,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        tooltip: context.strings.clearSearch,
                        onPressed: () {
                          input.clear();
                          search.changeQuery('');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.strings.close,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.searchAllChannels != null)
              CheckboxListTile(
                key: const ValueKey('search-all-channels'),
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  widget.allChannelsLabel ??
                      context.strings.messageSearchAllChannels,
                ),
                value: state.allChannels,
                onChanged: (value) => search.selectAllChannels(value ?? false),
              ),
            if (search.activeSearch != null) searchStatus(context, state),
            Flexible(child: results(context, state)),
          ],
        ),
      );
  String resultSubtitle(BuildContext context, Content message) {
    if (search.activeSearch == null) return context.strings.loadedMessage;
    if (!search.state.allChannels) return message.authorId;
    return '${widget.channelNames[message.channelId] ?? message.channelId} · ${message.authorId}';
  }

  List<Content> matchingMessages(String term, MessageSearchState state) {
    if (term.isEmpty) return [];
    if (search.activeSearch != null) return state.messages;
    return widget.messages
        .where(
          (message) => messageSummary(message).toLowerCase().contains(term),
        )
        .take(20)
        .toList();
  }

  Widget results(BuildContext context, MessageSearchState state) {
    final term = state.query.toLowerCase().trim();
    final matching = widget.sections.entries
        .where((entry) => entry.value.toLowerCase().contains(term))
        .toList();
    final contents = matchingMessages(term, state);
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        if (matching.isEmpty &&
            contents.isEmpty &&
            !state.loading &&
            !state.failed &&
            state.next.isEmpty)
          Padding(
            padding: EdgeInsets.all(28),
            child: Text(context.strings.nothingFound),
          ),
        for (final entry in matching)
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: Text(entry.value),
            subtitle: Text(context.strings.appSection),
            onTap: () => Navigator.pop(context, entry.key),
          ),
        for (final message in contents)
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: Text(
              messageSummary(message),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(resultSubtitle(context, message)),
            onTap: () => selectMessage(context, message),
          ),
        if (state.next.isNotEmpty &&
            state.messages.length < MessageSearchController.resultLimit)
          TextButton(
            onPressed: state.loading ? null : () => search.load(more: true),
            child: Text(context.strings.messageSearchMore),
          ),
      ],
    );
  }
}
