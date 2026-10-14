part of 'chat_controller.dart';

final class ChatState {
  const ChatState({
    this.busy = false,
    this.connected = false,
    this.reconnecting = false,
    this.accessRemoved = false,
    this.canRead = false,
    this.canWrite = false,
    this.error = '',
    this.cacheError = '',
    this.fingerprint = '',
    this.cursor = '',
    this.origin = '',
    this.principalId = '',
    this.channelId = 'general',
    this.spaceTitle = '',
    this.chatTitle = '',
    this.readThrough = '',
    this.failureCode,
    this.failureRetry = false,
    this.invitationRole = '',
    this.preview,
    this.serverIcon,
    this.messages = const [],
    this.channels = const [],
    this.favorites = const {},
    this.unreadCounts = const {},
    this.sendStatus = MessageSendStatus.idle,
  });

  factory ChatState.fromController(ChatController controller) => ChatState(
    busy: controller.busy,
    connected: controller.connected,
    reconnecting: controller.reconnecting,
    accessRemoved: controller.accessRemoved,
    canRead: controller.canRead,
    canWrite: controller.canWrite,
    error: controller.error,
    cacheError: controller.cacheError,
    fingerprint: controller.fingerprint,
    cursor: controller.cursor,
    origin: controller.knownOrigin,
    principalId: controller.principalId,
    channelId: controller.channelId,
    spaceTitle: controller.spaceTitle,
    chatTitle: controller.chatTitle,
    readThrough: controller.readThrough,
    failureCode: controller.failureCode,
    failureRetry: controller.failureRetry,
    invitationRole: controller.invitationRole,
    preview: controller.preview,
    serverIcon: controller.serverIcon?.deepCopy()?..freeze(),
    messages: List.unmodifiable(
      controller.messages.map((m) => m.deepCopy()..freeze()),
    ),
    channels: List.unmodifiable(
      controller.channels.map((ch) => ch.deepCopy()..freeze()),
    ),
    favorites: Set.unmodifiable(
      controller.messages
          .where(controller.isFavorite)
          .map((m) => '${m.channelId}/${m.id}'),
    ),
    unreadCounts: Map.unmodifiable({
      for (final ch in controller.channels)
        ch.id: controller.unreadCount(ch.id),
    }),
    sendStatus: controller.sendStatus,
  );

  final bool busy,
      connected,
      reconnecting,
      accessRemoved,
      canRead,
      canWrite,
      failureRetry;
  final String error,
      cacheError,
      fingerprint,
      cursor,
      origin,
      principalId,
      channelId,
      spaceTitle,
      chatTitle,
      readThrough,
      invitationRole;
  final LocalFailureCode? failureCode;
  final Discovery? preview;
  final ServerIcon? serverIcon;
  final List<Content> messages;
  final List<Channel> channels;
  final Set<String> favorites;
  final Map<String, int> unreadCounts;
  final MessageSendStatus sendStatus;
  bool isFavorite(Content message) =>
      favorites.contains('${message.channelId}/${message.id}');
  int unreadCount(String channelId) => unreadCounts[channelId] ?? 0;
}
