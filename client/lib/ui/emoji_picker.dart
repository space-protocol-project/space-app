import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/strings.dart';
import '../src/emoji_catalog.dart';

const quickEmoji = ['👍', '❤️', '😂', '😮', '😢', '🔥'];

void insertEmoji(TextEditingController controller, String emoji) {
  final value = controller.value;
  final selection = value.selection;
  final start = selection.isValid ? selection.start : value.text.length;
  final end = selection.isValid ? selection.end : value.text.length;
  controller.value = TextEditingValue(
    text: value.text.replaceRange(start, end, emoji),
    selection: TextSelection.collapsed(offset: start + emoji.length),
  );
}

Future<String?> pickEmoji(BuildContext context) =>
    showDialog<String>(context: context, builder: (_) => const _EmojiPicker());

class EmojiButton extends StatelessWidget {
  const EmojiButton({super.key, required this.controller, this.enabled = true});
  final TextEditingController controller;
  final bool enabled;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.strings.emojiPicker,
    icon: const Icon(Icons.sentiment_satisfied_alt),
    onPressed: !enabled
        ? null
        : () async {
            final emoji = await pickEmoji(context);
            if (emoji != null && context.mounted) {
              insertEmoji(controller, emoji);
            }
          },
  );
}

class _EmojiPicker extends StatefulWidget {
  const _EmojiPicker();
  @override
  State<_EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<_EmojiPicker> {
  static Future<EmojiCatalog>? catalogue;
  final search = TextEditingController();
  List<String> recent = [];
  String group = '';
  @override
  void initState() {
    super.initState();
    catalogue ??= EmojiCatalog.load();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => recent = prefs.getStringList('space.emoji.recent') ?? []);
    }
  }

  Future<void> select(String emoji) async {
    Navigator.of(context).pop(emoji);
    final prefs = await SharedPreferences.getInstance();
    final previous = prefs.getStringList('space.emoji.recent') ?? [];
    await prefs.setStringList(
      'space.emoji.recent',
      [emoji, ...previous.where((e) => e != emoji)].take(32).toList(),
    );
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(16),
    child: SizedBox(
      width: 420,
      height: 460,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.strings.emojiPicker,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextField(
              controller: search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: context.strings.emojiSearch,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<EmojiCatalog>(
                future: catalogue,
                builder: _catalogue,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget _catalogue(
    BuildContext context,
    AsyncSnapshot<EmojiCatalog> snapshot,
  ) {
    if (snapshot.hasError) {
      return Center(child: Text(context.strings.failureOperationFailed));
    }
    final data = snapshot.data;
    if (data == null) return const Center(child: CircularProgressIndicator());
    return _results(context, data);
  }

  Widget _results(BuildContext context, EmojiCatalog data) {
    final filtered = data.search(search.text, group, recent);
    final language = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        _categoryTabs(context, data.groups),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 48,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) =>
                _emojiTile(filtered[index], language),
          ),
        ),
      ],
    );
  }

  Widget _emojiTile(EmojiEntry entry, String language) => Tooltip(
    message: entry.label(language),
    child: TextButton(
      onPressed: () => select(entry.emoji),
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(entry.emoji, style: const TextStyle(fontSize: 25)),
    ),
  );

  Widget _categoryTabs(BuildContext context, List<String> categories) {
    final categoryLabels = [
      context.strings.emojiFaces,
      context.strings.emojiPeople,
      context.strings.emojiNature,
      context.strings.emojiFood,
      context.strings.emojiTravel,
      context.strings.emojiActivities,
      context.strings.emojiObjects,
      context.strings.emojiSymbols,
      context.strings.emojiFlags,
    ];
    const icons = [
      Icons.mood,
      Icons.waving_hand_outlined,
      Icons.pets_outlined,
      Icons.restaurant_outlined,
      Icons.directions_car_outlined,
      Icons.sports_soccer,
      Icons.lightbulb_outline,
      Icons.tag,
      Icons.flag_outlined,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: Text(context.strings.emojiAll),
            selected: group.isEmpty,
            onSelected: (_) => setState(() => group = ''),
          ),
          const SizedBox(width: 4),
          ChoiceChip(
            label: const Icon(Icons.history, size: 20),
            tooltip: context.strings.emojiRecent,
            selected: group == 'recent',
            onSelected: (_) => setState(() => group = 'recent'),
          ),
          for (var i = 0; i < categories.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ChoiceChip(
                tooltip: categoryLabels[i % categoryLabels.length],
                label: Icon(icons[i % icons.length], size: 20),
                selected: group == categories[i],
                onSelected: (_) => setState(() => group = categories[i]),
              ),
            ),
        ],
      ),
    );
  }
}
