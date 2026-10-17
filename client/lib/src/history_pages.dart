import 'package:fixnum/fixnum.dart';

import 'rpc_clients.dart' show Content, GetHistoryPageResponse;

class HistoryPage {
  const HistoryPage(
    this.messages, {
    this.nextBefore = 0,
    this.eventCursor = '',
  });
  final List<Content> messages;
  final int nextBefore;
  final String eventCursor;
}

abstract interface class HistoryPageSession {
  Future<HistoryPage> historyPage(String channel, {int before = 0});
}

HistoryPage checkedHistoryPage(
  GetHistoryPageResponse response,
  String channel,
  int before,
) {
  if (response.contents.length > 100 ||
      response.nextBeforeSequence.isNegative ||
      response.eventCursor.length > 512) {
    throw StateError('Некорректная страница истории');
  }
  var previous = Int64.ZERO;
  final ids = <String>{};
  for (final message in response.contents) {
    if (!validHistoryMessage(message, channel, previous, before) ||
        !ids.add(message.id)) {
      throw StateError('Некорректное сообщение истории');
    }
    previous = message.sequence;
  }
  final next = response.nextBeforeSequence.toInt();
  if (next != 0 &&
      (response.contents.length != 100 ||
          next != response.contents.first.sequence.toInt())) {
    throw StateError('Некорректная граница истории');
  }
  return HistoryPage(
    List.unmodifiable(response.contents),
    nextBefore: next,
    eventCursor: response.eventCursor,
  );
}

bool validHistoryMessage(
  Content message,
  String channel,
  Int64 previous,
  int before,
) =>
    message.channelId == channel &&
    message.id.isNotEmpty &&
    message.sequence > previous &&
    (before == 0 || message.sequence < Int64(before));
