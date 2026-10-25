part of 'shell.dart';

extension _ShellPersonalNotifications on _SpaceShellState {
  Widget personalNotificationButton() => IconButton(
    key: const ValueKey('personal-notifications'),
    tooltip: context.strings.notifications,
    onPressed: openPersonalInbox,
    icon: const Icon(Icons.notifications_none),
  );

  Future<void> openPersonalInbox() async {
    final initial = personalNotifications.state.scopes
        .where(
          (s) =>
              identical(s.chat, controller) &&
              s.channel.id == controller.channelId,
        )
        .firstOrNull;
    final inbox = PersonalInboxController(
      personalNotifications,
      initialKey: initial?.key,
    );
    PersonalNotificationTarget? target;
    try {
      target = await showDialog<PersonalNotificationTarget>(
        context: context,
        builder: (_) => PersonalInbox(controller: inbox),
      );
    } finally {
      await inbox.close();
    }
    if (target != null && mounted) {
      await openPersonalNotification(
        target,
        notificationOpenEpoch,
        fromInbox: true,
      );
    }
  }

  bool personalNotificationCurrent(
    PersonalNotificationTarget target,
    int epoch, {
    bool fromInbox = false,
  }) =>
      mounted &&
      !exiting &&
      epoch == notificationOpenEpoch &&
      (fromInbox || widget.preferences.notificationMode != 0) &&
      widget.preferences.origins.contains(target.origin) &&
      personalNotifications.scopeFor(target)?.valid() == true;

  bool personalChatVisible(PersonalNotificationScope scope) =>
      notificationChatVisible(
        ChatNotice(scope.origin, scope.principal, scope.channel, 1, null),
      );

  Future<bool> deliverPersonalNotifications(
    PersonalNotificationScope scope,
    List<PersonalNotification> notices,
  ) async {
    if (notices.isEmpty) return true;
    final target = scope.target(notices.last);
    final epoch = notificationOpenEpoch,
        mode = widget.preferences.notificationMode;
    bool permitted() =>
        personalNotificationCurrent(target, epoch) &&
        widget.preferences.notificationMode == mode &&
        personalNotifications.current(scope);
    if (!permitted()) return false;
    if (notificationView(notices.last.targetKind) == 'chat' &&
        personalChatVisible(scope)) {
      return true;
    }
    try {
      await systemNotifications.initialize();
      if (!permitted()) return false;
      final page = await personalNotifications.read(
        scope,
        ListPersonalNotificationsRequest(
          channelId: scope.channel.id,
          afterSequence: Int64(notices.first.sequence.toInt() - 1),
          throughSequence: notices.last.sequence,
          unreadOnly: true,
          limit: 50,
        ),
      );
      if (!permitted() || page == null) return false;
      final latest = page.notifications.lastOrNull;
      if (latest == null) return true;
      await showPersonalNotification(scope, latest, permitted);
      return permitted();
    } catch (_) {
      return false;
    }
  }

  Future<void> showPersonalNotification(
    PersonalNotificationScope scope,
    PersonalNotification notice,
    bool Function() permitted,
  ) async {
    final preview = widget.preferences.notificationMode == 2;
    final reason = (notice.unreadReasons & 1) != 0
        ? context.strings.dashboardMention
        : context.strings.notificationReply;
    final body = preview
        ? '$reason\n${String.fromCharCodes(notice.snippet.runes.take(220))}'
        : context.strings.newMessageNotification;
    final bytes = sha256
        .convert(
          utf8.encode(
            jsonEncode([
              'personal',
              scope.origin,
              scope.principal,
              scope.channel.id,
            ]),
          ),
        )
        .bytes;
    await systemNotifications.show(
      id: (bytes[0] << 16) | (bytes[1] << 8) | bytes[2],
      title: preview ? scope.label : 'Space',
      body: body,
      target: scope.target(notice).payload,
      actionLabel: context.strings.notificationOpen,
      permitted: () =>
          permitted() &&
          !(notificationView(notice.targetKind) == 'chat' &&
              personalChatVisible(scope)),
    );
  }

  Future<void> openPersonalNotification(
    PersonalNotificationTarget target,
    int epoch, {
    bool fromInbox = false,
  }) async {
    try {
      final chat = workspaces[target.origin];
      if (chat == null || !widget.preferences.origins.contains(target.origin)) {
        return;
      }
      if (!await notificationConnectionReady(
        chat,
        target.origin,
        jsonEncode(target.payload),
        epoch,
      )) {
        return;
      }
      personalNotifications.synchronize();
      bool current() =>
          personalNotificationCurrent(target, epoch, fromInbox: fromInbox);
      if (!current() || await personalNotifications.resolve(target) == null) {
        return;
      }
      if (!current()) return;
      await systemNotifications.focus();
      if (!current()) return;
      final notice = await personalNotifications.resolve(target);
      if (!current() || notice == null) return;
      await navigatePersonalNotification(target, notice, current);
    } catch (_) {
      /* Недоступная цель не открывает произвольное пространство. */
    }
  }

  Future<void> navigatePersonalNotification(
    PersonalNotificationTarget target,
    PersonalNotification notice,
    bool Function() current,
  ) async {
    final chat = workspaces[target.origin]!;
    final view = notificationView(notice.targetKind);
    await openSpace(
      target.origin,
      channel: view == 'chat' ? target.channel : null,
    );
    if (!current() || !identical(controller, chat)) return;
    if (view == 'chat') {
      final message = await chat.notificationMessage(
        notice.targetSequence.toInt(),
      );
      if (!current() ||
          message?.id != notice.contentId ||
          chat.channelId != target.channel) {
        return;
      }
      openMessage(message!.id);
      return;
    }
    showCommunityTarget(
      DashboardCommunityTarget(
        origin: target.origin,
        channel: target.channel,
        destination: view == 'forum'
            ? DashboardDestination.forum
            : DashboardDestination.feed,
        id: notice.parentId,
        replySequence: notice.targetSequence.toInt(),
      ),
    );
  }
}
