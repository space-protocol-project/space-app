part of 'shell.dart';

extension _ShellMlsNotifications on _SpaceShellState {
  Future<void> pollMlsNotifications() => exiting
      ? Future.value()
      : mlsNotificationWatcher.poll(
          notificationMlsSources(),
          queueNotification,
        );

  List<MlsNotificationSource> notificationMlsSources() => [
    for (final chat in workspaces.controllers.values)
      ...notificationMlsSourcesFor(chat),
  ];

  Iterable<MlsNotificationSource> notificationMlsSourcesFor(
    ChatController chat,
  ) {
    if (widget.preferences.notificationMode == 0 ||
        !chat.connected ||
        chat.accessRemoved ||
        chat.mlsSession == null) {
      return [];
    }
    return chat.channels
        .where(notificationReadableMls)
        .map((channel) => notificationMlsSource(chat, channel));
  }

  bool notificationReadableMls(Channel channel) =>
      channel.mlsGroupId.isNotEmpty &&
      channel.permissions.read &&
      channel.permissions.visible &&
      !channel.archived;

  MlsNotificationSource notificationMlsSource(
    ChatController chat,
    Channel channel,
  ) {
    final session = chat.mlsSession!;
    final generation = mlsNotificationGeneration;
    final group = base64Encode(channel.mlsGroupId);
    return MlsNotificationSource(
      origin: chat.knownOrigin,
      principal: chat.principalId,
      channel: Channel.fromBuffer(channel.writeToBuffer())..freeze(),
      open: session.mlsClient,
      valid: () =>
          mounted &&
          generation == mlsNotificationGeneration &&
          widget.preferences.notificationMode != 0 &&
          identical(workspaces[chat.knownOrigin], chat) &&
          identical(chat.mlsSession, session) &&
          notificationMlsCurrent(chat, channel.id, group),
    );
  }

  bool notificationMlsCurrent(ChatController chat, String id, String group) =>
      chat.connected &&
      !chat.accessRemoved &&
      chat.channels.any(
        (channel) =>
            channel.id == id &&
            notificationReadableMls(channel) &&
            base64Encode(channel.mlsGroupId) == group,
      );

  MlsNotificationSource? notificationMlsSourceAt(
    String origin,
    String id,
    String group,
  ) => notificationMlsSources()
      .where(
        (source) =>
            source.origin == origin &&
            source.channel.id == id &&
            base64Encode(source.channel.mlsGroupId) == group,
      )
      .firstOrNull;

  Future<Content?> mlsNotificationMessage(
    String origin,
    String channel,
    String group,
    String key,
  ) async {
    final source = notificationMlsSourceAt(origin, channel, group);
    return source == null ? null : mlsNotificationWatcher.message(source, key);
  }

  Future<bool> notificationMlsTargetAvailable(
    ChatNotificationTarget target,
  ) async {
    if (target.mlsKey.isEmpty) return true;
    return await mlsNotificationMessage(
          target.origin,
          target.channel,
          target.group,
          target.mlsKey,
        ) !=
        null;
  }

  void resetMlsNotifications() {
    final mode = widget.preferences.notificationMode;
    if (mode == previousMlsNotificationMode) return;
    previousMlsNotificationMode = mode;
    mlsNotificationGeneration++;
    mlsNotificationWatcher.reset();
  }
}
