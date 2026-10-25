import 'dart:convert';

import 'generated/space/v1/community_mentions.pb.dart';

bool validMention(String text, CommunityMention mention, int after) {
  final end = mention.start + mention.length;
  return mention.principalId.isNotEmpty &&
      mention.start >= after &&
      mention.length > 1 &&
      end <= text.length &&
      text.substring(mention.start, end) == '@${mention.displayName}';
}

List<CommunityMention> validMentions(
  String text,
  Iterable<CommunityMention> mentions,
) {
  final result = <CommunityMention>[];
  var after = 0;
  for (final mention in mentions.take(10)) {
    if (!validMention(text, mention, after)) continue;
    result.add(mention);
    after = mention.start + mention.length;
  }
  return result;
}

List<Object?> mentionJson(Iterable<CommunityMention> mentions) =>
    mentions.map((m) => m.toProto3Json()).toList();

bool sameMentions(Iterable<CommunityMention> a, Iterable<CommunityMention> b) =>
    jsonEncode(mentionJson(a)) == jsonEncode(mentionJson(b));

List<CommunityMention> readMentions(Object? raw, String text) {
  if (raw == null) return [];
  if (raw is! List || raw.length > 10) {
    throw const FormatException('Некорректные упоминания');
  }
  final mentions = raw
      .map((m) => CommunityMention()..mergeFromProto3Json(m))
      .toList();
  if (validMentions(text, mentions).length != mentions.length) {
    throw const FormatException('Некорректные диапазоны упоминаний');
  }
  return mentions;
}
