import 'dart:convert';

import 'generated/space/v1/space.pb.dart';

// События остаются в защищённом журнале; интерфейс показывает только сообщения.
List<Map<String, dynamic>> projectMlsReactions(
  List<Map<String, dynamic>> events,
) {
  final projection = _MlsReactionProjection();
  for (final item in events) {
    projection.accept(item);
  }
  return projection.result();
}

class _MlsReactionProjection {
  final messages = <String, Map<String, dynamic>>{};
  final reactions = <String, Map<String, Set<String>>>{};
  String key(dynamic grant, dynamic id) => jsonEncode([grant, id]);
  void accept(Map<String, dynamic> item) {
    final message = item['message'] as Map;
    final reaction = message['reaction'] as Map?;
    if (reaction == null) {
      final id = key(item['grant_id'], message['id']);
      messages[id] = Map<String, dynamic>.from(item);
      reactions.putIfAbsent(id, () => {});
      return;
    }
    final id = key(reaction['grant_id'], reaction['message_id']);
    final target = messages[id];
    if (target == null || target['deleted'] == true) return;
    final emoji = reaction['emoji'] as String;
    final actor = item['author_id'] as String;
    final grouped = reactions[id]!;
    _set(grouped, emoji, actor, reaction['active'] == true);
  }

  void _set(
    Map<String, Set<String>> grouped,
    String emoji,
    String actor,
    bool active,
  ) {
    if (!active) {
      grouped[emoji]?.remove(actor);
      if (grouped[emoji]?.isEmpty == true) grouped.remove(emoji);
      return;
    }
    if (!grouped.containsKey(emoji) && grouped.length >= 32) return;
    final participants = grouped.putIfAbsent(emoji, () => <String>{});
    if (participants.length < 256) participants.add(actor);
  }

  List<Map<String, dynamic>> result() => [
    for (final entry in messages.entries)
      {
        ...entry.value,
        'reactions': [
          for (final group in reactions[entry.key]!.entries)
            Reaction(emoji: group.key, principalIds: group.value),
        ],
      },
  ];
}
