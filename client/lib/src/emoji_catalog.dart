import 'dart:convert';

import 'package:flutter/services.dart';

class EmojiEntry {
  EmojiEntry.fromJson(Map<String, dynamic> value)
    : emoji = value['emoji'] as String,
      group = value['group'] as String,
      english = value['en'] as String,
      russian = value['ru'] as String,
      chinese = value['zh'] as String;

  final String emoji, group, english, russian, chinese;
  late final searchText = '$emoji $russian $english $chinese'.toLowerCase();

  String label(String language) {
    final translated = switch (language) {
      'ru' => russian,
      'zh' => chinese,
      _ => english,
    };
    return translated.isEmpty ? english : translated;
  }
}

class EmojiCatalog {
  EmojiCatalog(this.entries);
  final List<EmojiEntry> entries;
  late final groups = entries.map((entry) => entry.group).toSet().toList();

  static Future<EmojiCatalog> load() async {
    final encoded = await rootBundle.loadString('assets/emoji/catalog.json');
    final values = jsonDecode(encoded) as List;
    return EmojiCatalog([
      for (final value in values)
        EmojiEntry.fromJson(Map<String, dynamic>.from(value as Map)),
    ]);
  }

  List<EmojiEntry> search(String text, String group, List<String> recent) {
    final query = text.trim().toLowerCase();
    final found = entries
        .where(
          (entry) =>
              _matchesGroup(entry, group, recent) &&
              entry.searchText.contains(query),
        )
        .toList();
    if (group == 'recent') {
      found.sort(
        (a, b) => recent.indexOf(a.emoji).compareTo(recent.indexOf(b.emoji)),
      );
    }
    return found;
  }

  bool _matchesGroup(EmojiEntry entry, String group, List<String> recent) {
    if (group.isEmpty) return true;
    if (group == 'recent') return recent.contains(entry.emoji);
    return entry.group == group;
  }
}
