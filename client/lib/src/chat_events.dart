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
  });
  final String address, invitationToken, tlsFingerprint;
  final String? homeOrigin;
}

final class ChatConnected extends ChatEvent<void> {
  ChatConnected({
    this.restoredRecord,
    this.pairingId = '',
    this.setupCode = '',
  });
  final DeviceRecord? restoredRecord;
  final String pairingId, setupCode;
}

final class ChatChannelSelected extends ChatEvent<void> {
  ChatChannelSelected(this.id);
  final String id;
}

final class ChatChannelsRefreshed extends ChatEvent<void> {}

final class ChatMessageSent extends ChatEvent<bool> {
  ChatMessageSent(this.text);
  final String text;
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
