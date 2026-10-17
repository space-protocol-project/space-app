import 'dart:convert';

import 'chat_controller.dart';
import 'generated/space/v1/space.pb.dart';

class ChatNotificationTarget {
  const ChatNotificationTarget(
    this.origin,
    this.principal,
    this.channel,
    this.sequence, {
    this.mlsKey = '',
    this.group = '',
  });
  final String origin, principal, channel;
  final String mlsKey, group;
  final int sequence;
  static ChatNotificationTarget? decode(String payload) {
    try {
      if (payload.length > 2048) return null;
      final parts = jsonDecode(payload) as List;
      if (![4, 6].contains(parts.length) ||
          !parts.take(3).every(_scopePart) ||
          parts[3] is! int ||
          (parts[3] as int) <= 0 ||
          (parts[3] as int) >= 9223372036854775807) {
        return null;
      }
      if (parts.length == 6 &&
          (parts[4] is! String ||
              (parts[4] as String).isEmpty ||
              parts[5] is! String ||
              (parts[5] as String).isEmpty)) {
        return null;
      }
      return ChatNotificationTarget(
        parts[0] as String,
        parts[1] as String,
        parts[2] as String,
        parts[3] as int,
        mlsKey: parts.length == 6 ? parts[4] as String : '',
        group: parts.length == 6 ? parts[5] as String : '',
      );
    } catch (_) {
      return null;
    }
  }

  static bool _scopePart(dynamic part) =>
      part is String && part.isNotEmpty && part.length <= 1024;

  bool accessible(ChatState state) =>
      state.connected &&
      !state.accessRemoved &&
      state.principalId == principal &&
      state.origin == origin &&
      state.channels.any(
        (c) =>
            c.id == channel &&
            c.permissions.visible &&
            c.permissions.read &&
            !c.archived &&
            _groupMatches(c),
      );

  bool _groupMatches(Channel channel) => mlsKey.isEmpty
      ? group.isEmpty && channel.mlsGroupId.isEmpty
      : mlsKey.length <= 512 &&
            group.isNotEmpty &&
            channel.mlsGroupId.isNotEmpty &&
            base64Encode(channel.mlsGroupId) == group;
}

class ChatNotice {
  const ChatNotice(
    this.origin,
    this.principal,
    this.channel,
    this.sequence,
    this.message,
  );
  final String origin, principal;
  final Channel channel;
  final int sequence;
  final Content? message;
  bool get isMls => channel.mlsGroupId.isNotEmpty;
}

// Первый снимок задаёт границу: история после запуска не вызывает лавину уведомлений.
class ChatNotificationTracker {
  final _latest = <(String, String), Map<String, int>>{};

  List<ChatNotice> observe(ChatState state) {
    if (!state.connected || state.accessRemoved || state.principalId.isEmpty) {
      return [];
    }
    final scope = (state.origin, state.principalId);
    final previous = _latest[scope];
    final current = <String, int>{};
    final notices = <ChatNotice>[];
    for (final channel in state.channels.where(_readable)) {
      final sequence = channel.latestMessageSequence.toInt();
      final before = previous?[channel.id];
      current[channel.id] = sequence > (before ?? 0) ? sequence : before ?? 0;
      if (before == null ||
          sequence <= before ||
          state.unreadCount(channel.id) == 0) {
        continue;
      }
      final message = state.messages
          .where(
            (m) => m.channelId == channel.id && m.sequence.toInt() == sequence,
          )
          .firstOrNull;
      if (message?.authorId == state.principalId || message?.deleted == true) {
        continue;
      }
      notices.add(
        ChatNotice(state.origin, state.principalId, channel, sequence, message),
      );
    }
    _latest[scope] = current;
    return notices;
  }

  bool _readable(Channel channel) =>
      !channel.archived &&
      channel.permissions.visible &&
      channel.permissions.read &&
      channel.mlsGroupId.isEmpty;

  void retainOrigins(Iterable<String> origins) =>
      _latest.removeWhere((key, _) => !origins.contains(key.$1));
}
