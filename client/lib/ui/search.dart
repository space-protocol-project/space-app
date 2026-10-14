import '../l10n/strings.dart';

import 'package:flutter/material.dart';

import '../src/generated/space/v1/space.pb.dart';

class SpaceSearchPanel extends StatefulWidget {
  const SpaceSearchPanel({
    super.key,
    required this.sections,
    required this.messages,
  });
  final Map<String, String> sections;
  final List<Content> messages;
  @override
  State<SpaceSearchPanel> createState() => _SpaceSearchPanelState();
}

class _SpaceSearchPanelState extends State<SpaceSearchPanel> {
  final input = TextEditingController();
  String query = '';
  @override
  void dispose() {
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
                onChanged: (value) => setState(() => query = value),
                decoration: InputDecoration(
                  hintText: context.strings.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: context.strings.clearSearch,
                    onPressed: () {
                      input.clear();
                      setState(() => query = '');
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
        : widget.messages
              .where((message) => message.text.toLowerCase().contains(term))
              .take(20)
              .toList();
    return ListView(
      primary: false,
      shrinkWrap: true,
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
            onTap: () => Navigator.pop(context, entry.key),
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
            onTap: () => Navigator.pop(context, 'message:${message.id}'),
          ),
      ],
    );
  }
}
