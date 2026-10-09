import '../l10n/strings.dart';

import 'package:flutter/material.dart';

import '../src/generated/space/v1/space.pb.dart';

class SpaceSearch extends SearchDelegate<String> {
  SpaceSearch(this.sections, this.messages, String hint)
    : super(searchFieldLabel: hint);
  final Map<String, String> sections;
  final List<Content> messages;
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      tooltip: context.strings.clearSearch,
      onPressed: () => query = '',
      icon: const Icon(Icons.close),
    ),
  ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
    tooltip: context.strings.back,
    onPressed: () => close(context, ''),
    icon: const Icon(Icons.arrow_back),
  );
  @override
  Widget buildResults(BuildContext context) => results(context);
  @override
  Widget buildSuggestions(BuildContext context) => results(context);
  Widget results(BuildContext context) {
    final term = query.toLowerCase().trim();
    final matching = sections.entries
        .where((entry) => entry.value.toLowerCase().contains(term))
        .toList();
    final contents = term.isEmpty
        ? <Content>[]
        : messages
              .where((message) => message.text.toLowerCase().contains(term))
              .take(20)
              .toList();
    return ListView(
      children: [
        if (matching.isEmpty && contents.isEmpty)
          Padding(
            padding: EdgeInsets.all(28),
            child: Text(context.strings.nothingFound),
          ),
        for (final entry in matching)
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: Text(entry.value),
            subtitle: Text(context.strings.appSection),
            onTap: () => close(context, entry.key),
          ),
        for (final message in contents)
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: Text(
              message.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(context.strings.loadedMessage),
            onTap: () => close(context, 'chat'),
          ),
      ],
    );
  }
}
