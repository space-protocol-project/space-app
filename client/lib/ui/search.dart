import 'dart:async';

import '../src/message_search.dart';
import '../src/message_summary.dart';
import '../l10n/strings.dart';

import 'package:flutter/material.dart';

import '../src/generated/space/v1/space.pb.dart';

class SpaceSearchPanel extends StatefulWidget {
  const SpaceSearchPanel({
    super.key,
    required this.sections,
    required this.messages,
    this.searchMessages,
    this.onMessageSelected,
    this.localOnly = false,
  });
  final Map<String, String> sections;
  final List<Content> messages;
  final Future<MessageSearchPage> Function(String query, String cursor)?
  searchMessages;
  final void Function(Content)? onMessageSelected;
  final bool localOnly;
  @override
  State<SpaceSearchPanel> createState() => _SpaceSearchPanelState();
}

class _SpaceSearchPanelState extends State<SpaceSearchPanel> {
  final input = TextEditingController();
  String query = '';
  String next = '';
  String failure = '';
  List<Content> found = [];
  bool loading = false;
  int generation = 0;
  Timer? debounce;

  void changeQuery(String value) {
    debounce?.cancel();
    generation++;
    setState(() {
      query = value;
      found = [];
      next = '';
      failure = '';
      loading = false;
    });
    if (widget.searchMessages == null || value.trim().runes.length < 2) return;
    debounce = Timer(const Duration(milliseconds: 300), () => load());
  }

  Future<void> load({bool more = false}) async {
    if (loading || widget.searchMessages == null) return;
    final current = generation;
    final term = query.trim();
    setState(() {
      loading = true;
      failure = '';
    });
    try {
      final page = await widget.searchMessages!(term, more ? next : '');
      if (!mounted || generation != current) return;
      setState(() {
        found = {
          for (final item in [
            ...(more ? found : <Content>[]),
            ...page.messages,
          ])
            item.id: item,
        }.values.take(200).toList();
        next = page.next;
      });
    } catch (_) {
      if (mounted && generation == current) {
        setState(() => failure = context.strings.messageSearchFailed);
      }
    } finally {
      if (mounted && generation == current) setState(() => loading = false);
    }
  }

  Widget searchStatus(BuildContext context) => Column(
    children: [
      Text(
        widget.localOnly
            ? context.strings.messageSearchLocal
            : context.strings.messageSearchServer,
      ),
      if (loading) const LinearProgressIndicator(),
      if (failure.isNotEmpty)
        TextButton(onPressed: () => load(), child: Text(failure)),
      if (found.length >= 200) Text(context.strings.messageSearchLimit),
    ],
  );

  void selectMessage(BuildContext context, Content message) {
    widget.onMessageSelected?.call(message);
    Navigator.pop(context, 'message:${message.id}');
  }

  @override
  void dispose() {
    debounce?.cancel();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
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
                onChanged: changeQuery,
                maxLength: 128,
                decoration: InputDecoration(
                  hintText: widget.searchMessages == null
                      ? context.strings.searchHint
                      : context.strings.search,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: context.strings.clearSearch,
                    onPressed: () {
                      input.clear();
                      changeQuery('');
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
        if (widget.searchMessages != null) searchStatus(context),
        Flexible(child: results(context)),
      ],
    ),
  );
  Widget results(BuildContext context) {
    final term = query.toLowerCase().trim();
    final matching = widget.sections.entries
        .where((entry) => entry.value.toLowerCase().contains(term))
        .toList();
    final contents = term.isEmpty
        ? <Content>[]
        : widget.searchMessages != null
        ? found
        : widget.messages
              .where(
                (message) =>
                    messageSummary(message).toLowerCase().contains(term),
              )
              .take(20)
              .toList();
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        if (matching.isEmpty && contents.isEmpty && !loading && failure.isEmpty)
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
            subtitle: Text(
              widget.searchMessages == null
                  ? context.strings.loadedMessage
                  : message.authorId,
            ),
            onTap: () => selectMessage(context, message),
          ),
        if (next.isNotEmpty && found.length < 200)
          TextButton(
            onPressed: loading ? null : () => load(more: true),
            child: Text(context.strings.messageSearchMore),
          ),
      ],
    );
  }
}
