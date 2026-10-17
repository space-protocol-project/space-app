import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'message_search.dart';

/// Последовательно обходит каналы, ограничивая число запросов одной страницы.
Future<MessageSearchPage> searchChannelPages({
  required List<String> channels,
  required String query,
  required String cursor,
  required Future<MessageSearchPage> Function(String, String, String) fetch,
}) async {
  final term = checkedSearchQuery(query);
  final signature = sha256
      .convert(utf8.encode(jsonEncode(channels)))
      .toString();
  final position = _searchPosition(cursor, term, signature, channels.length);
  var index = position.$1, after = position.$2;
  for (var requests = 0; index < channels.length && requests < 4; requests++) {
    final page = await fetch(channels[index], term, after);
    _checkChannelPage(page, channels[index]);
    if (page.next.isNotEmpty && page.next == after) {
      throw StateError('Курсор поиска не продвинулся');
    }
    after = page.next;
    if (after.isEmpty) index++;
    final next = index < channels.length
        ? jsonEncode([term, signature, index, after])
        : '';
    if (page.messages.isNotEmpty) {
      return MessageSearchPage(page.messages, next: next);
    }
    if (page.next.isNotEmpty) {
      throw StateError('Пустая страница с продолжением');
    }
  }
  return MessageSearchPage(
    const [],
    next: index < channels.length
        ? jsonEncode([term, signature, index, after])
        : '',
  );
}

(int, String) _searchPosition(
  String cursor,
  String query,
  String signature,
  int count,
) {
  if (cursor.isEmpty) return (0, '');
  if (cursor.length > 4096) throw StateError('Некорректный курсор поиска');
  final value = jsonDecode(cursor);
  if (value is! List ||
      value.length != 4 ||
      value[0] != query ||
      value[1] != signature ||
      value[2] is! int ||
      value[2] < 0 ||
      value[2] >= count ||
      value[3] is! String ||
      (value[3] as String).length > 2048) {
    throw StateError('Область поиска изменилась');
  }
  return (value[2] as int, value[3] as String);
}

void _checkChannelPage(MessageSearchPage page, String channel) {
  if (page.messages.length > 50 ||
      page.next.length > 2048 ||
      page.messages.any((message) => message.channelId != channel)) {
    throw StateError('Некорректная страница поиска');
  }
}
