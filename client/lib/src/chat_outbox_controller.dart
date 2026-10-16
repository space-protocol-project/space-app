part of 'chat_controller.dart';

extension _ChatOutboxController on ChatController {
  bool get _canQueueMessage {
    if (_disposed ||
        accessRemoved ||
        encryptedChannel ||
        busy ||
        _outboxScope?.origin != knownOrigin ||
        outboxError.isNotEmpty) {
      return false;
    }
    if (!_outboxGrantMatches(_outboxScope!)) return false;
    final target = channels.where((entry) => entry.id == channelId).firstOrNull;
    return target == null
        ? connected
        : target.permissions.write && !target.archived;
  }

  bool _outboxCurrent(OutboxScope scope, int epoch) =>
      !_disposed &&
      !accessRemoved &&
      epoch == _outboxEpoch &&
      identical(scope, _outboxScope);

  bool _outboxGrantMatches(OutboxScope scope) {
    final session = _session;
    return session is! DeviceManagement ||
        (session as DeviceManagement).currentGrantId == scope.grantId;
  }

  bool _checkOutboxDevice(OutboxScope scope, int epoch) {
    if (!_outboxCurrent(scope, epoch)) return false;
    if (_outboxGrantMatches(scope)) return true;
    outboxError = 'identity';
    _update();
    return false;
  }

  void _stopOutbox() {
    _outboxEpoch++;
    _outboxTimer?.cancel();
    _outboxTimer = null;
  }

  Future<void> _loadSessionOutbox(Discovery server, LiveSession session) =>
      _loadOutbox(
        OutboxScope(
          server.origin.toString(),
          server.serverId,
          session.principalId,
          session is DeviceManagement
              ? (session as DeviceManagement).currentGrantId
              : '',
        ),
      );

  Future<void> _loadOutbox(OutboxScope scope) async {
    _stopOutbox();
    _outboxScope = scope;
    _pendingMessages = const [];
    outboxError = '';
    final epoch = _outboxEpoch;
    try {
      final entries = await outboxStore.read(scope);
      if (_outboxCurrent(scope, epoch)) _pendingMessages = entries;
    } catch (_) {
      if (_outboxCurrent(scope, epoch)) outboxError = 'storage';
    }
  }

  Future<bool> _enqueueMessage(String text, List<String> attachments) async {
    final scope = _outboxScope;
    if (!canQueue || scope == null) return false;
    if (text.trim().isEmpty && attachments.isEmpty) return false;
    final request = jsonEncode([channelId, text, attachments]);
    if (_pendingText != request || _pendingKey.isEmpty) {
      _pendingText = request;
      _pendingKey = newRequestKey();
    }
    final entry = PendingMessage(
      key: _pendingKey,
      channelId: channelId,
      text: text,
      attachments: attachments,
      createdAt: now().millisecondsSinceEpoch,
    );
    return _persistMessage(scope, entry);
  }

  Future<bool> _persistMessage(OutboxScope scope, PendingMessage entry) async {
    final epoch = _outboxEpoch;
    busy = true;
    _update();
    try {
      entry.validate();
      final entries = await outboxStore.change(scope, (saved) {
        if (!_outboxCurrent(scope, epoch)) return saved;
        if (saved.any((message) => message.key == entry.key)) return saved;
        return [...saved, entry];
      });
      if (!_outboxCurrent(scope, epoch)) return false;
      _pendingMessages = entries;
      outboxError = '';
      _pendingKey = '';
      _pendingText = '';
      sendStatus = MessageSendStatus.queued;
      _update();
      _wakeOutbox();
      return true;
    } catch (problem) {
      if (_outboxCurrent(scope, epoch)) {
        outboxError = problem is OutboxFull ? 'full' : 'save';
        _update();
      }
      return false;
    } finally {
      busy = false;
      _update();
    }
  }

  void _wakeOutbox() {
    if (_disposed ||
        !connected ||
        accessRemoved ||
        _session == null ||
        (outboxError.isNotEmpty && outboxError != 'full') ||
        _outboxScope == null ||
        _outboxTimer != null) {
      return;
    }
    if (_outboxDrain != null) {
      _outboxWakeRequested = true;
      return;
    }
    _outboxWakeRequested = false;
    final scope = _outboxScope!;
    final epoch = _outboxEpoch;
    _outboxDrain = _drainMessages(scope, epoch, _session!).whenComplete(() {
      _outboxDrain = null;
      if (epoch != _outboxEpoch || _outboxWakeRequested) _wakeOutbox();
    });
  }

  PendingMessage? _nextMessage() {
    final blockedChannels = <String>{};
    for (final entry in _pendingMessages) {
      if (entry.blocked) blockedChannels.add(entry.channelId);
      if (!blockedChannels.contains(entry.channelId)) return entry;
    }
    return null;
  }

  Future<void> _drainMessages(
    OutboxScope scope,
    int epoch,
    LiveSession session,
  ) async {
    try {
      while (_outboxCurrent(scope, epoch) &&
          identical(session, _session) &&
          connected) {
        if (!_checkOutboxDevice(scope, epoch)) return;
        final entry = _nextMessage();
        if (entry == null) return;
        if (!await _deliverMessage(scope, epoch, session, entry)) return;
      }
    } catch (_) {
      if (_outboxCurrent(scope, epoch)) {
        outboxError = 'storage';
        _update();
      }
    }
  }

  Future<Content> _sendPending(LiveSession session, PendingMessage entry) {
    if (session is QueuedMessageSession) {
      return (session as QueuedMessageSession).sendQueued(
        entry.channelId,
        entry.text,
        entry.key,
        entry.attachments,
      );
    }
    if (entry.channelId != channelId) {
      throw const GrpcError.failedPrecondition(
        'Сессия не поддерживает очередь каналов',
      );
    }
    return entry.attachments.isEmpty
        ? session.send(entry.text, entry.key)
        : (session as AttachmentSession).sendAttachments(
            entry.channelId,
            entry.text,
            entry.key,
            entry.attachments,
          );
  }

  Future<bool> _deliverMessage(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    PendingMessage entry,
  ) async {
    sendStatus = MessageSendStatus.sending;
    _update();
    Content content;
    try {
      content = await _sendPending(session, entry);
      _checkMessageReceipt(scope, entry, content);
    } catch (problem) {
      if (!_outboxCurrent(scope, epoch)) return false;
      return _pendingFailure(scope, epoch, entry, problem);
    }
    if (!_checkOutboxDevice(scope, epoch)) return false;
    // Сначала сохраняем историю, затем убираем подтверждённый запрос.
    // Сбой записи оставляет тот же ключ для идемпотентного повтора.
    if (entry.channelId == channelId) _mergeMessage(content);
    _captureHistory();
    _history?.merge([content], now());
    await _flushHistory();
    if (cacheError.isNotEmpty) throw StateError('История не сохранена');
    final remaining = await outboxStore.change(
      scope,
      (saved) => saved.where((message) => message.key != entry.key).toList(),
    );
    if (!_outboxCurrent(scope, epoch)) return false;
    _pendingMessages = remaining;
    _outboxAttempt = 0;
    if (outboxError == 'full') outboxError = '';
    sendStatus = _pendingMessages.isEmpty
        ? MessageSendStatus.accepted
        : MessageSendStatus.queued;
    _update();
    return true;
  }

  void _checkMessageReceipt(
    OutboxScope scope,
    PendingMessage entry,
    Content content,
  ) {
    if (content.id.isEmpty ||
        content.channelId != entry.channelId ||
        content.authorId != scope.principalId ||
        content.sequence <= 0 ||
        content.revision < 1) {
      throw const FormatException('Неверное подтверждение сообщения');
    }
    if (content.revision == 1 &&
        (content.text != entry.text ||
            !listEquals(
              content.attachments.map((asset) => asset.id).toList(),
              entry.attachments,
            ))) {
      throw const FormatException('Подтверждение другого сообщения');
    }
  }

  bool _retryableSend(Object problem) =>
      problem is SocketException ||
      problem is TimeoutException ||
      problem is GrpcError &&
          [
            StatusCode.unavailable,
            StatusCode.deadlineExceeded,
            StatusCode.cancelled,
          ].contains(problem.code);

  Future<bool> _pendingFailure(
    OutboxScope scope,
    int epoch,
    PendingMessage entry,
    Object problem,
  ) async {
    sendStatus = MessageSendStatus.unconfirmed;
    if (_retryableSend(problem)) {
      final delay = retryDelay(_outboxAttempt);
      if (_outboxAttempt < 5) _outboxAttempt++;
      _outboxTimer = Timer(delay, () {
        _outboxTimer = null;
        if (_outboxCurrent(scope, epoch)) _wakeOutbox();
      });
      _update();
      return false;
    }
    final remaining = await outboxStore.change(
      scope,
      (saved) => saved
          .map(
            (message) =>
                message.key == entry.key ? message.withBlocked(true) : message,
          )
          .toList(),
    );
    if (_outboxCurrent(scope, epoch)) {
      _pendingMessages = remaining;
      _update();
    }
    return true;
  }

  Future<void> _changePending(ChatOutboxChanged event) async {
    final scope = _outboxScope;
    if (scope == null || accessRemoved) return;
    final epoch = _outboxEpoch;
    try {
      final remaining = await outboxStore.change(
        scope,
        (saved) => _changedEntries(saved, event),
      );
      if (!_outboxCurrent(scope, epoch)) return;
      _pendingMessages = remaining;
      outboxError = '';
      _outboxTimer?.cancel();
      _outboxTimer = null;
      _update();
      _wakeOutbox();
    } catch (_) {
      if (_outboxCurrent(scope, epoch)) {
        outboxError = 'storage';
        _update();
      }
    }
  }

  List<PendingMessage> _changedEntries(
    List<PendingMessage> saved,
    ChatOutboxChanged event,
  ) {
    if (event.discard) {
      return saved.where((entry) => entry.key != event.key).toList();
    }
    return saved
        .map(
          (entry) => entry.key == event.key ? entry.withBlocked(false) : entry,
        )
        .toList();
  }
}
