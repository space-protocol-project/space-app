part of 'chat_controller.dart';

sealed class ChatEvent<T> extends RequestEvent<T> {}

final class ChatHistoryRestored extends ChatEvent<void> {
  ChatHistoryRestored(this.origin);
  final String origin;
}

final class ChatHistoryFlushed extends ChatEvent<void> {}

final class ChatOfflineDataCleared extends ChatEvent<void> {}

final class ChatFavoriteToggled extends ChatEvent<void> {
  ChatFavoriteToggled(Content message) : message = message.deepCopy()..freeze();
  final Content message;
}

final class ChatReadMarked extends ChatEvent<void> {
  ChatReadMarked(this.id);
  final String id;
}

final class ChatInspected extends ChatEvent<void> {
  ChatInspected(
    this.address, {
    this.invitationToken = '',
    this.homeOrigin,
    this.tlsFingerprint = '',
    this.savedRecord,
  });
  final String address, invitationToken, tlsFingerprint;
  final String? homeOrigin;
  final DeviceRecord? savedRecord;
}

final class ChatConnected extends ChatEvent<void> {
  ChatConnected({
    this.restoredRecord,
    this.pairingId = '',
    this.setupCode = '',
    this.nickname,
  });
  final DeviceRecord? restoredRecord;
  final String pairingId, setupCode;
  final String? nickname;
}

final class ChatChannelSelected extends ChatEvent<void> {
  ChatChannelSelected(this.id);
  final String id;
}

final class ChatChannelsRefreshed extends ChatEvent<void> {}

final class ChatMessageSent extends ChatEvent<bool> {
  ChatMessageSent(this.text, [this.attachments = const []]);
  final String text;
  final List<String> attachments;
}

final class ChatDeviceRevoked extends ChatEvent<void> {}

final class ChatDisconnected extends ChatEvent<void> {}

final class ChatStatePublished extends ChatEvent<void> {
  ChatStatePublished(this.state);
  final ChatState state;
}

final class ChatFrameReceived extends ChatEvent<bool> {
  ChatFrameReceived(
    SubscribeResponse frame,
    this.session,
    this.generation,
    this.channelId,
  ) : frame = frame.deepCopy()..freeze();
  final SubscribeResponse frame;
  final LiveSession session;
  final int generation;
  final String channelId;
}

final class ChatCatalogChanged extends ChatEvent<bool> {
  ChatCatalogChanged(this.session, this.generation);
  final LiveSession session;
  final int generation;
}

final class ChatCatalogFailed extends ChatEvent<bool> {
  ChatCatalogFailed(this.session, this.generation, this.error);
  final LiveSession session;
  final int generation;
  final Object error;
}

final class ChatMessageChanged extends ChatEvent<bool> {
  ChatMessageChanged(Content message, this.text)
    : message = message.deepCopy()..freeze();
  final Content message;
  final String? text;
}

final class ChatReactionSet extends ChatEvent<bool> {
  ChatReactionSet(Content message, this.emoji, this.active)
    : message = message.deepCopy()..freeze();
  final Content message;
  final String emoji;
  final bool active;
}

final class ChatOutboxChanged extends ChatEvent<void> {
  ChatOutboxChanged(this.key, {this.discard = false});
  final String key;
  final bool discard;
}
