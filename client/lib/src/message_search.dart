import 'dart:convert';

import 'mls/mentions.dart';

import 'dart:collection';

import 'package:fixnum/fixnum.dart';

import 'rpc_clients.dart';
import 'mls/client.dart';
import 'mls/replies.dart';
import 'mls/local_store.dart';

part 'mls_message_search.dart';

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
  return searchSavedMlsMessages(client.local, channel, group, query, cursor);
}
