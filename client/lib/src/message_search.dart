import 'dart:convert';

import 'package:fixnum/fixnum.dart';

import 'rpc_clients.dart';
import 'mls/client.dart';
import 'mls/replies.dart';

class MessageSearchPage {
  const MessageSearchPage(this.messages, {this.next = ''});
  final List<Content> messages;
  final String next;
}

abstract interface class MessageSearchSession {
  Future<MessageSearchPage> searchMessages(
    String channel,
    String query,
    String cursor,
  );
}

String checkedSearchQuery(String query) {
  final value = query.trim();
  if (value.runes.length < 2 ||
      value.runes.length > 128 ||
      utf8.encode(value).length > 512) {
    throw ArgumentError('Введите от 2 до 128 символов');
  }
  return value;
}

MessageSearchPage checkedSearchPage(
  SearchContentResponse response,
  String channel,
  String query,
  int before,
) {
  if (response.contents.length > 50 || response.nextBeforeSequence.isNegative) {
    throw StateError('Некорректная страница поиска');
  }
  var previous = before == 0 ? Int64.MAX_VALUE : Int64(before);
  final ids = <String>{};
  for (final item in response.contents) {
    if (item.channelId != channel ||
        item.deleted ||
        item.id.isEmpty ||
        !ids.add(item.id) ||
        item.sequence <= Int64.ZERO ||
        item.sequence >= previous ||
        !item.text.toLowerCase().contains(query.toLowerCase())) {
      throw StateError('Некорректный результат поиска');
    }
    previous = item.sequence;
  }
  if (response.nextBeforeSequence != Int64.ZERO &&
      (response.contents.length != 50 ||
          response.nextBeforeSequence != previous)) {
    throw StateError('Некорректный курсор поиска');
  }
  return MessageSearchPage(
    List.unmodifiable(response.contents),
    next: response.nextBeforeSequence == Int64.ZERO
        ? ''
        : response.nextBeforeSequence.toString(),
  );
}

Future<MessageSearchPage> searchMlsMessages(
  MlsClient client,
  String channel,
  List<int> group,
  String query,
  String cursor,
) async {
  final term = checkedSearchQuery(query).toLowerCase();
  final document = await client.local.read();
  final saved = (document['channels'] as Map)[channel] as Map<String, dynamic>?;
  if (saved == null ||
      saved['joined'] != true ||
      saved['revocation_pending'] == true ||
      saved['group_id'] != base64Encode(group)) {
    throw StateError('Нет доступа к истории MLS');
  }
  final messages =
      MlsChannelData(saved).messages
          .where(
            (item) =>
                item['deleted'] != true &&
                ((item['message'] as Map)['text'] as String)
                    .toLowerCase()
                    .contains(term),
          )
          .map(
            (item) => Content(
              id: mlsMessageKey(item),
              channelId: channel,
              text: (item['message'] as Map)['text'] as String,
              authorId: item['author_id'] as String,
              sequence: Int64(item['sequence'] as int),
            ),
          )
          .toList()
        ..sort((a, b) {
          final order = b.sequence.compareTo(a.sequence);
          return order == 0 ? b.id.compareTo(a.id) : order;
        });
  final start = cursor.isEmpty
      ? 0
      : messages.indexWhere((m) => m.id == cursor) + 1;
  if (cursor.isNotEmpty && start == 0) {
    throw StateError('История изменилась, повторите поиск');
  }
  final page = messages.skip(start).take(50).toList();
  return MessageSearchPage(
    page,
    next: start + page.length < messages.length ? page.last.id : '',
  );
}
