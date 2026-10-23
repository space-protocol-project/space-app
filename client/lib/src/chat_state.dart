part of 'chat_controller.dart';

// fromController уже замораживает protobuf и коллекции; сохраняем их идентичность.
@Freezed(equal: false, makeCollectionsUnmodifiable: false)
abstract class ChatState with _$ChatState {
  const ChatState._();
  const factory ChatState({
    @Default(false) bool historyLoading,
    @Default(false) bool hasOlderHistory,
    @Default('') String historyError,
    @Default(false) bool busy,
    @Default(false) bool connected,
    @Default(false) bool reconnecting,
    @Default(false) bool accessRemoved,
    @Default(false) bool canRead,
    @Default(false) bool canWrite,
    @Default('') String error,
    @Default('') String cacheError,
    @Default('') String fingerprint,
    @Default('') String cursor,
    @Default('') String origin,
    @Default('') String principalId,
    @Default('general') String channelId,
    @Default('') String spaceTitle,
    @Default('') String chatTitle,
    @Default('') String readThrough,
    LocalFailureCode? failureCode,
    @Default(false) bool failureRetry,
    @Default('') String invitationRole,
    @Default(false) bool initialSetup,
    Discovery? preview,
    ServerIcon? serverIcon,
    @Default([]) List<Content> messages,
    @Default([]) List<Channel> channels,
    @Default({}) Set<String> favorites,
    @Default({}) Map<String, int> unreadCounts,
    @Default(MessageSendStatus.idle) MessageSendStatus sendStatus,
    @Default(false) bool canQueue,
    @Default([]) List<PendingMessage> pendingMessages,
    @Default('') String outboxError,
    @Default([]) List<OutboxScope> outboxSources,
    @Default('') String outboxRecoveryTarget,
  }) = _ChatState;

  factory ChatState.fromController(ChatController controller) {
    final messages = controller.messages;
    final channels = controller.channels;
    final previous = controller.state;
    return ChatState(
      historyLoading: controller.historyLoading,
      hasOlderHistory: controller.hasOlderHistory,
      historyError: controller.historyError,
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
      initialSetup: controller._setupCode.isNotEmpty,
      preview: controller.preview,
      serverIcon: controller.serverIcon?.deepCopy()?..freeze(),
      messages: listEquals(messages, previous.messages)
          ? previous.messages
          : List.unmodifiable(messages.map((m) => m.deepCopy()..freeze())),
      channels: listEquals(channels, previous.channels)
          ? previous.channels
          : List.unmodifiable(channels.map((ch) => ch.deepCopy()..freeze())),
      favorites: Set.unmodifiable(
        messages
            .where(controller.isFavorite)
            .map((m) => '${m.channelId}/${m.id}'),
      ),
      unreadCounts: Map.unmodifiable({
        for (final ch in controller.channels)
          ch.id: controller.unreadCount(ch.id),
      }),
      sendStatus: controller.sendStatus,
      canQueue: controller.canQueue,
      pendingMessages: controller.pendingMessages,
      outboxError: controller.outboxError,
      outboxSources: controller.outboxSources,
      outboxRecoveryTarget: controller.outboxRecoveryTarget,
    );
  }

  bool isFavorite(Content message) =>
      favorites.contains('${message.channelId}/${message.id}');
  int unreadCount(String channelId) => unreadCounts[channelId] ?? 0;
}
