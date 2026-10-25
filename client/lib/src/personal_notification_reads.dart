part of 'personal_notifications_controller.dart';

extension PersonalNotificationReads on PersonalNotificationsController {
  Future<bool> markRead(
    PersonalNotificationScope scope,
    List<String> ids,
  ) async {
    if (!current(scope)) return false;
    try {
      await scope.api
          .markRead(scope.channel.id, ids)
          .timeout(const Duration(seconds: 5));
      return current(scope);
    } on GrpcError catch (error) {
      if (_accessError(error)) invalidate(scope);
      rethrow;
    }
  }

  Future<void> markVisibleChat(
    ChatController chat,
    List<Content> messages,
  ) async {
    final scope = _sources.values
        .where((s) => identical(s.chat, chat) && s.channel.id == chat.channelId)
        .firstOrNull;
    if (scope == null || !current(scope)) return;
    final ids = messages
        .where((m) => _unreadMention(scope, m))
        .map((m) => m.id)
        .take(50)
        .toList();
    if (ids.isEmpty) return;
    if (_reading.contains(scope.key)) {
      _readLater[scope.key] = (scope, ids);
      return;
    }
    await _markChat(scope, ids);
  }

  Future<void> _markChat(
    PersonalNotificationScope scope,
    List<String> ids,
  ) async {
    if (!current(scope)) return;
    _reading.add(scope.key);
    try {
      await scope.api
          .markChatRead(scope.channel.id, ids)
          .timeout(const Duration(seconds: 5));
      if (current(scope)) _rememberRead(scope, ids);
    } on GrpcError catch (error) {
      if (_accessError(error)) invalidate(scope);
    } catch (_) {
      /* Следующая проверка видимости допускает повтор. */
    } finally {
      _reading.remove(scope.key);
      final later = _readLater.remove(scope.key);
      if (later != null) unawaited(_markChat(later.$1, later.$2));
    }
  }

  bool _unreadMention(PersonalNotificationScope scope, Content message) =>
      !message.deleted &&
      message.authorId != scope.principal &&
      message.channelId == scope.channel.id &&
      !_readDone.contains('${scope.key}:${message.id}') &&
      message.mentions.any((mention) => mention.principalId == scope.principal);

  void _rememberRead(PersonalNotificationScope scope, List<String> ids) {
    for (final id in ids) {
      _readDone.add('${scope.key}:$id');
    }
    while (_readDone.length > 512) {
      _readDone.remove(_readDone.first);
    }
  }
}
