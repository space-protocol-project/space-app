import 'dart:convert';

import '../generated/space/v1/community_mentions.pb.dart';
import '../mention_data.dart';

class MlsMessageFeatures {
  const MlsMessageFeatures.legacy()
    : known = false,
      ownMentions = false,
      allMentions = false;
  const MlsMessageFeatures({
    required this.ownMentions,
    required this.allMentions,
  }) : known = true;

  final bool known, ownMentions, allMentions;

  static MlsMessageFeatures read(Map<String, dynamic> value) {
    if (value
        case {
          'format': int format,
          'own_mentions': bool own,
          'all_mentions': bool all,
        }
        when format == 2 && value.length == 3 && (!all || own)) {
      return MlsMessageFeatures(ownMentions: own, allMentions: all);
    }
    throw const FormatException('Повреждены возможности формата MLS');
  }
}

bool _scalarText(String text) {
  for (var i = 0; i < text.length; i++) {
    final code = text.codeUnitAt(i);
    if (code >= 0xdc00 && code <= 0xdfff) return false;
    if (code < 0xd800 || code > 0xdbff) continue;
    i++;
    if (i == text.length ||
        text.codeUnitAt(i) < 0xdc00 ||
        text.codeUnitAt(i) > 0xdfff) {
      return false;
    }
  }
  return true;
}

bool _mentionIdentity(CommunityMention mention) =>
    RegExp(r'^[\x20-\x7e]{1,128}$').hasMatch(mention.principalId) &&
    mention.displayName.isNotEmpty &&
    utf8.encode(mention.displayName).length <= 256 &&
    !RegExp(r'[\x00-\x1f\x7f-\x9f]').hasMatch(mention.displayName) &&
    _scalarText(mention.displayName);

void requireMlsMentions(String text, List<CommunityMention> mentions) {
  if (mentions.length > 10 ||
      !_scalarText(text) ||
      utf8.encode(text).length > 8192) {
    throw const FormatException('Повреждены упоминания MLS');
  }
  var after = 0;
  for (final mention in mentions) {
    if (!_mentionIdentity(mention) ||
        mention.start < after ||
        mention.start > text.length ||
        mention.length > text.length - mention.start ||
        !validMention(text, mention, after)) {
      throw const FormatException('Повреждены диапазоны упоминаний MLS');
    }
    after = mention.start + mention.length;
  }
}

List<Map<String, Object>> mlsMentionJson(
  String text,
  List<CommunityMention> mentions,
) {
  requireMlsMentions(text, mentions);
  return [
    for (final m in mentions)
      {
        'principal_id': m.principalId,
        'display_name': m.displayName,
        'start': m.start,
        'length': m.length,
      },
  ];
}

CommunityMention _readMention(Object? raw) {
  if (raw
      case {
        'principal_id': String id,
        'display_name': String name,
        'start': int start,
        'length': int length,
      }
      when raw.length == 4 &&
          start >= 0 &&
          start <= 0x7fffffff &&
          length > 0 &&
          length <= 0x7fffffff) {
    return CommunityMention(
      principalId: id,
      displayName: name,
      start: start,
      length: length,
    );
  }
  throw const FormatException('Повреждена запись упоминания MLS');
}

List<CommunityMention> checkedMlsMentions(Map message) {
  final version = message['version'];
  if (!message.containsKey('mentions')) {
    if (version != null && (version is! int || version != 1)) {
      throw const FormatException('Неизвестный формат сообщения MLS');
    }
    return const [];
  }
  final raw = message['mentions'], text = message['text'];
  if (version is! int ||
      version != 2 ||
      raw is! List ||
      raw.isEmpty ||
      raw.length > 10 ||
      text is! String ||
      message['manager'] != null ||
      message['reaction'] != null) {
    throw const FormatException('Повреждён формат упоминаний MLS');
  }
  final mentions = raw.map(_readMention).toList();
  requireMlsMentions(text, mentions);
  return mentions;
}

void checkMlsChannelMentions(Map channel) {
  for (final field in const [
    'messages',
    'archived_messages',
    'outbox',
    'retry_messages',
  ]) {
    for (final row in channel[field] as List? ?? const []) {
      final message = (row as Map)['message'];
      if (message != null) checkedMlsMentions(message as Map);
    }
  }
  final legacyRetry = channel['retry_message'];
  if (legacyRetry != null) {
    checkedMlsMentions((legacyRetry as Map)['message'] as Map);
  }
}
