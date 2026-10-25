part of 'shell.dart';

extension _ShellNotifications on _SpaceShellState {
  Future<void> syncAndroidNotifications() async {
    try {
      await androidPush.sync(
        enabled: widget.preferences.notificationMode != 0,
        origins: widget.preferences.origins,
      );
      if (widget.preferences.notificationMode != 0) {
        await registerAndroidNotifications();
      }
    } catch (_) {
      /* Системный запрет не прерывает чат. */
    }
  }

  void receiveNotifications(WorkspaceState state) {
    if (widget.preferences.notificationMode != 0) {
      unawaited(registerAndroidNotifications());
    }
    retryNotificationOpen();
    notificationTracker.retainOrigins(state.chats.keys);
    for (final chat in state.chats.values) {
      for (final notice in notificationTracker.observe(chat)) {
        queueNotification(notice);
      }
    }
  }

  Future<void> registerAndroidNotifications() async {
    if (!AndroidPush.supported) return;
    for (final chat in workspaces.controllers.values) {
      final session = chat.mlsSession;
      if (!chat.connected || chat.accessRemoved || session == null) continue;
      try {
        await androidPush.register(session);
      } catch (_) {
        /* Следующее подключение повторит регистрацию. */
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
    final chat = workspaces[notice.origin];
    if (chat?.personalNotifications != null) {
      return chat!.notificationContent(notice.channel.id, notice.sequence);
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
    if (latest == null &&
        (notice.isMls ||
            workspaces[notice.origin]?.personalNotifications != null)) {
      return;
    }
    if (latest?.deleted == true || latest?.authorId == notice.principal) return;
    if (!notice.isMls &&
        workspaces[notice.origin]?.personalNotifications != null &&
        latest?.mentions.any((m) => m.principalId == notice.principal) ==
            true) {
      return;
    }
    await showNotification(notice, latest);
  }

  Future<void> showNotification(ChatNotice notice, Content? latest) async {
    final mode = widget.preferences.notificationMode;
    final epoch = notificationOpenEpoch;
    final preview = mode == 2;
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
      permitted: () =>
          mounted &&
          epoch == notificationOpenEpoch &&
          widget.preferences.notificationMode == mode &&
          widget.preferences.origins.contains(notice.origin) &&
          notificationStillAllowed(notice) &&
          !notificationChatVisible(notice),
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
    notificationOpenEpoch++;
    deferredNotification = null;
    pendingNotices.clear();
    notificationJobs = notificationJobs
        .then((_) => systemNotifications.clear())
        .catchError((Object _) {});
  }

  Future<void> restoreNotificationActivation() async {
    try {
      await widget.startupReady;
      if (!mounted) return;
      await workspaces.synchronize(widget.preferences.origins);
      if (!mounted) return;
      await systemNotifications.listenForActivation(
        enabled: widget.preferences.notificationMode != 0,
      );
      await syncAndroidNotifications();
    } catch (_) {
      // Неудача запуска из уведомления не препятствует обычному запуску.
    } finally {
      notificationStartupComplete = true;
      if (mounted) {
        personalNotifications.setDeliveryEnabled(
          widget.preferences.notificationMode != 0,
        );
      }
    }
  }

  Future<void> queueNotificationOpen(String payload) async {
    if (exiting ||
        widget.preferences.notificationMode == 0 ||
        ChatNotificationTarget.decode(payload) == null &&
            PersonalNotificationTarget.decode(payload) == null) {
      return;
    }
    notificationOpenEpoch++;
    deferredNotification = payload;
    await drainNotificationOpen();
  }

  void retryNotificationOpen() {
    if (notificationOpening || deferredNotification == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(drainNotificationOpen());
    });
  }

  Future<void> drainNotificationOpen() async {
    final payload = deferredNotification;
    if (!mounted || exiting || notificationOpening || payload == null) return;
    notificationOpening = true;
    try {
      deferredNotification = null;
      await openNotification(payload);
    } finally {
      notificationOpening = false;
      if (deferredNotification != payload) retryNotificationOpen();
    }
  }

  Future<void> openNotification(String payload) async {
    final personal = PersonalNotificationTarget.decode(payload);
    if (personal != null) {
      await openPersonalNotification(personal, notificationOpenEpoch);
    } else {
      await openChatNotification(payload);
    }
  }

  Future<void> openChatNotification(String payload) async {
    final epoch = notificationOpenEpoch;
    try {
      final target = ChatNotificationTarget.decode(payload);
      if (target == null) return;
      final chat = workspaces[target.origin];
      if (chat == null || !widget.preferences.origins.contains(target.origin)) {
        return;
      }
      if (!await notificationConnectionReady(
        chat,
        target.origin,
        payload,
        epoch,
      )) {
        return;
      }
      if (!notificationAccessCurrent(chat, target, epoch)) return;
      if (!await notificationMlsTargetAvailable(target)) return;
      if (!notificationAccessCurrent(chat, target, epoch)) return;
      await openSpace(target.origin, channel: target.channel);
      if (!notificationDestinationCurrent(chat, target, epoch)) return;
      await systemNotifications.focus();
      if (!notificationDestinationCurrent(chat, target, epoch)) return;
      final message = target.mlsKey.isEmpty
          ? await chat.notificationMessage(target.sequence)
          : await mlsNotificationMessage(
              target.origin,
              target.channel,
              target.group,
              target.mlsKey,
            );
      if (!notificationDestinationCurrent(chat, target, epoch)) return;
      if (message != null) openMessage(message.id);
    } catch (_) {
      // Устаревшее или подменённое уведомление не меняет подключение.
    }
  }

  Future<bool> notificationConnectionReady(
    ChatController chat,
    String origin,
    String payload,
    int epoch,
  ) async {
    await workspaces.reconnect(origin);
    if (chat.busy) {
      try {
        await chat.stream
            .firstWhere((state) => !state.busy)
            .timeout(const Duration(seconds: 30));
      } on TimeoutException {
        // Цель остаётся до завершения текущего подключения.
      }
    }
    if (!mounted || epoch != notificationOpenEpoch) return false;
    if (chat.connected || chat.accessRemoved) return true;
    if (widget.preferences.origins.contains(origin)) {
      deferredNotification ??= payload;
    }
    return false;
  }

  bool notificationDestinationCurrent(
    ChatController chat,
    ChatNotificationTarget target,
    int epoch,
  ) =>
      notificationAccessCurrent(chat, target, epoch) &&
      identical(controller, chat) &&
      controller.channelId == target.channel;

  bool notificationAccessCurrent(
    ChatController chat,
    ChatNotificationTarget target,
    int epoch,
  ) =>
      mounted &&
      !exiting &&
      epoch == notificationOpenEpoch &&
      widget.preferences.notificationMode != 0 &&
      target.accessible(chat.state);
}
