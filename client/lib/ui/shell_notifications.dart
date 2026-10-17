part of 'shell.dart';

extension _ShellNotifications on _SpaceShellState {
  void receiveNotifications(WorkspaceState state) {
    notificationTracker.retainOrigins(state.chats.keys);
    for (final chat in state.chats.values) {
      for (final notice in notificationTracker.observe(chat)) {
        queueNotification(notice);
      }
    }
  }

  void queueNotification(ChatNotice notice) {
    if (widget.preferences.notificationMode == 0) return;
    final key = jsonEncode([
      notice.origin,
      notice.principal,
      notice.channel.id,
    ]);
    if (!pendingNotices.containsKey(key) && pendingNotices.length >= 32) return;
    pendingNotices[key] = notice;
    if (notificationDraining) return;
    notificationDraining = true;
    notificationJobs = notificationJobs.then((_) => drainNotifications());
  }

  Future<void> drainNotifications() async {
    try {
      while (mounted && pendingNotices.isNotEmpty) {
        final key = pendingNotices.keys.first;
        final notice = pendingNotices.remove(key)!;
        try {
          await deliverNotification(notice);
        } catch (_) {
          /* Системный запрет не прерывает чат. */
        }
      }
    } finally {
      notificationDraining = false;
    }
  }

  bool notificationChatVisible(ChatNotice notice) =>
      notificationFocused &&
      !dashboard &&
      !applicationSettings &&
      !devicePage &&
      !serverList &&
      selected == Section.chat &&
      controller.knownOrigin == notice.origin &&
      controller.channelId == notice.channel.id;

  bool notificationStillAllowed(ChatNotice notice) {
    final chat = workspaces[notice.origin];
    return mounted &&
        widget.preferences.notificationMode != 0 &&
        chat != null &&
        notificationTarget(notice).accessible(chat.state);
  }

  ChatNotificationTarget notificationTarget(ChatNotice notice) =>
      ChatNotificationTarget(
        notice.origin,
        notice.principal,
        notice.channel.id,
        notice.sequence,
        mlsKey: notice.isMls ? notice.message!.id : '',
        group: notice.isMls ? base64Encode(notice.channel.mlsGroupId) : '',
      );

  Future<Content?> notificationContent(ChatNotice notice) async {
    if (notice.isMls) {
      return mlsNotificationMessage(
        notice.origin,
        notice.channel.id,
        base64Encode(notice.channel.mlsGroupId),
        notice.message!.id,
      );
    }
    return workspaces[notice.origin]?.messages
        .where(
          (m) =>
              m.channelId == notice.channel.id &&
              m.sequence.toInt() == notice.sequence,
        )
        .firstOrNull;
  }

  Future<void> deliverNotification(ChatNotice notice) async {
    if (!notificationStillAllowed(notice) || notificationChatVisible(notice)) {
      return;
    }
    await systemNotifications.initialize();
    if (!mounted ||
        !notificationStillAllowed(notice) ||
        notificationChatVisible(notice)) {
      return;
    }
    final latest = await notificationContent(notice);
    if (!mounted ||
        !notificationStillAllowed(notice) ||
        notificationChatVisible(notice)) {
      return;
    }
    if (notice.isMls && latest == null) return;
    if (latest?.deleted == true || latest?.authorId == notice.principal) return;
    await showNotification(notice, latest);
  }

  Future<void> showNotification(ChatNotice notice, Content? latest) async {
    final preview = widget.preferences.notificationMode == 2;
    final title = preview
        ? '${workspaces[notice.origin]!.spaceTitle} · ${notice.channel.title}'
        : 'Space';
    final text = preview ? latest?.text : null;
    final body = text == null || text.isEmpty
        ? context.strings.newMessageNotification
        : text.substring(0, text.length.clamp(0, 220));
    final digest = sha256
        .convert(
          utf8.encode(
            jsonEncode([notice.origin, notice.principal, notice.channel.id]),
          ),
        )
        .bytes;
    final id = ((digest[0] << 16) | (digest[1] << 8) | digest[2]);
    await systemNotifications.show(
      id: id,
      title: title,
      body: body,
      actionLabel: context.strings.openChat,
      target: [
        notice.origin,
        notice.principal,
        notice.channel.id,
        notice.sequence,
        if (notice.isMls) notice.message!.id,
        if (notice.isMls) base64Encode(notice.channel.mlsGroupId),
      ],
    );
  }

  void clearPrivateNotifications() {
    pendingNotices.clear();
    notificationJobs = notificationJobs
        .then((_) => systemNotifications.clear())
        .catchError((Object _) {});
  }

  Future<void> openNotification(String payload) async {
    try {
      final target = ChatNotificationTarget.decode(payload);
      if (target == null) return;
      final chat = workspaces[target.origin];
      if (chat == null || !widget.preferences.origins.contains(target.origin)) {
        return;
      }
      await workspaces.reconnect(target.origin);
      if (!mounted || !target.accessible(chat.state)) return;
      if (!await notificationMlsTargetAvailable(target)) return;
      if (!mounted || !target.accessible(chat.state)) return;
      await openSpace(target.origin, channel: target.channel);
      if (!notificationDestinationCurrent(chat, target)) return;
      await systemNotifications.focus();
      if (!notificationDestinationCurrent(chat, target)) return;
      final message = target.mlsKey.isEmpty
          ? chat.messages
                .where(
                  (m) =>
                      m.channelId == target.channel &&
                      m.sequence.toInt() == target.sequence,
                )
                .firstOrNull
          : await mlsNotificationMessage(
              target.origin,
              target.channel,
              target.group,
              target.mlsKey,
            );
      if (!notificationDestinationCurrent(chat, target)) return;
      if (message != null) openMessage(message.id);
    } catch (_) {
      // Устаревшее или подменённое уведомление не меняет подключение.
    }
  }

  bool notificationDestinationCurrent(
    ChatController chat,
    ChatNotificationTarget target,
  ) =>
      mounted &&
      identical(controller, chat) &&
      controller.channelId == target.channel &&
      target.accessible(chat.state);
}
