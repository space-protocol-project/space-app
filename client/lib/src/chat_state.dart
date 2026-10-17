part of 'chat_controller.dart';

final class ChatState {
  const ChatState({
    this.historyLoading = false,
    this.hasOlderHistory = false,
    this.historyError = '',
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
    this.initialSetup = false,
    this.preview,
    this.serverIcon,
    this.messages = const [],
    this.channels = const [],
    this.favorites = const {},
    this.unreadCounts = const {},
    this.sendStatus = MessageSendStatus.idle,
    this.canQueue = false,
    this.pendingMessages = const [],
    this.outboxError = '',
    this.outboxSources = const [],
    this.outboxRecoveryTarget = '',
  });

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

  final bool historyLoading, hasOlderHistory;
  final String historyError;
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
  final bool initialSetup;
  final Discovery? preview;
  final ServerIcon? serverIcon;
  final List<Content> messages;
  final List<Channel> channels;
  final Set<String> favorites;
  final Map<String, int> unreadCounts;
  final MessageSendStatus sendStatus;
  final bool canQueue;
  final String outboxError;
  final List<OutboxScope> outboxSources;
  final String outboxRecoveryTarget;
  final List<PendingMessage> pendingMessages;
  bool isFavorite(Content message) =>
      favorites.contains('${message.channelId}/${message.id}');
  int unreadCount(String channelId) => unreadCounts[channelId] ?? 0;
}
