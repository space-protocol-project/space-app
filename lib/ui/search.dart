import 'package:flutter/material.dart';

import '../src/generated/space/v1/space.pb.dart';

class SpaceSearch extends SearchDelegate<String> {
  SpaceSearch(this.sections, this.messages)
    : super(searchFieldLabel: 'Разделы и загруженные сообщения');
  final Map<String, String> sections;
  final List<Content> messages;
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      tooltip: 'Очистить поиск',
      onPressed: () => query = '',
      icon: const Icon(Icons.close),
    ),
  ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
    tooltip: 'Вернуться',
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
          const Padding(
            padding: EdgeInsets.all(28),
            child: Text('Ничего не найдено. Попробуйте другое слово.'),
          ),
        for (final entry in matching)
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: Text(entry.value),
            subtitle: const Text('Раздел приложения'),
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
            subtitle: const Text('Общий чат · загруженное сообщение'),
            onTap: () => close(context, 'chat'),
          ),
      ],
    );
  }
}
