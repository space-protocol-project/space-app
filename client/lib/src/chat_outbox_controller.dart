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

  bool _receiptCurrent(OutboxScope scope, int epoch, LiveSession session) =>
      _outboxCurrent(scope, epoch) &&
      identical(session, _session) &&
      _outboxGrantMatches(scope);

  void _stopOutbox() {
    _outboxEpoch++;
    _outboxTimer?.cancel();
    _outboxTimer = null;
  }

  Future<void> _finishOutbox() async {
    try {
      await _outboxDrain?.timeout(const Duration(seconds: 3));
    } catch (_) {
      // Остановка не ждёт недоступную сеть бесконечно; запрос уже сохранён.
    }
  }

  void _retryOutboxConnection(Discovery server, Object problem) {
    final scope = _outboxScope;
    if (scope == null ||
        scope.origin != server.origin.toString() ||
        scope.serverId != server.serverId ||
        !_retryableSend(problem) ||
        accessRemoved ||
        outboxError.isNotEmpty ||
        !_pendingMessages.any((entry) => !entry.blocked)) {
      return;
    }
    final epoch = _outboxEpoch;
    _outboxTimer?.cancel();
    _outboxTimer = Timer(retryDelay(_outboxAttempt), () {
      _outboxTimer = null;
      if (_outboxCurrent(scope, epoch) &&
          identical(preview, server) &&
          !connected) {
        unawaited(connect());
      }
    });
    if (_outboxAttempt < 5) _outboxAttempt++;
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
    _outboxSources = const [];
    outboxError = '';
    final epoch = _outboxEpoch;
    try {
      final entries = await outboxStore.read(scope);
      if (_outboxCurrent(scope, epoch)) _pendingMessages = entries;
      final sources = outboxStore is LocalChatOutbox
          ? await (outboxStore as LocalChatOutbox).previousScopes(scope)
          : <OutboxScope>[];
      if (_outboxCurrent(scope, epoch)) _outboxSources = sources;
    } catch (_) {
      if (_outboxCurrent(scope, epoch)) outboxError = 'storage';
    }
  }

  Future<bool> _enqueueMessage(
    String text,
    List<String> attachments,
    List<XFile> files,
    String replyTo,
  ) async {
    final scope = _outboxScope;
    if (!canQueue || scope == null) return false;
    if (text.trim().isEmpty && attachments.isEmpty && files.isEmpty) {
      return false;
    }
    if (files.isNotEmpty && !canQueueFiles) return false;
    if (replyTo.isNotEmpty && (!repliesSupported || !canRead)) return false;
    final request = jsonEncode([
      channelId,
      text,
      attachments,
      replyTo,
      files.map((f) => [f.path, f.name]).toList(),
    ]);
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
      replyTo: replyTo,
    );
    return _persistMessage(scope, entry, files: files);
  }

  Future<bool> _persistMessage(
    OutboxScope scope,
    PendingMessage entry, {
    List<XFile> files = const [],
  }) async {
    final epoch = _outboxEpoch;
    busy = true;
    _update();
    try {
      final entries = await _saveMessageFiles(scope, epoch, entry, files);
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
        outboxError = problem is FileQueueFull
            ? 'files-full'
            : problem is OutboxFull
            ? 'full'
            : 'save';
        _update();
      }
      return false;
    } finally {
      busy = false;
      _update();
    }
  }

  void _wakeOutbox() {
    if (_outboxRecovering ||
        _disposed ||
        !connected ||
        accessRemoved ||
        _session == null ||
        (outboxError.isNotEmpty &&
            !['full', 'files-full'].contains(outboxError)) ||
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
      if (entry.blocked || entry.mutation?.after.isNotEmpty == true) {
        blockedChannels.add(entry.channelId);
      }
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
    if (entry.replyTo.isNotEmpty) {
      _requireReplySupport(session, entry);
      return (session as ReplyMessageSession).sendReplyQueued(
        entry.channelId,
        entry.text,
        entry.key,
        entry.attachmentIds,
        entry.replyTo,
      );
    }
    if (session is QueuedMessageSession) {
      return (session as QueuedMessageSession).sendQueued(
        entry.channelId,
        entry.text,
        entry.key,
        entry.attachmentIds,
      );
    }
    if (entry.channelId != channelId) {
      throw const GrpcError.failedPrecondition(
        'Сессия не поддерживает очередь каналов',
      );
    }
    return entry.attachmentIds.isEmpty
        ? session.send(entry.text, entry.key)
        : (session as AttachmentSession).sendAttachments(
            entry.channelId,
            entry.text,
            entry.key,
            entry.attachmentIds,
          );
  }

  Future<bool> _deliverMessage(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    PendingMessage entry,
  ) async {
    if (entry.mutation != null) {
      return _deliverMutation(scope, epoch, session, entry);
    }
    sendStatus = MessageSendStatus.sending;
    _update();
    Content content;
    try {
      final sent = await _sendWithSessionRecovery(scope, epoch, session, entry);
      content = sent.$2;
      _checkMessageReceipt(scope, sent.$1, content);
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
    if (!_checkOutboxDevice(scope, epoch) || !identical(session, _session)) {
      return false;
    }
    final remaining = await outboxStore.change(
      scope,
      (saved) => _receiptCurrent(scope, epoch, session)
          ? saved.where((message) => message.key != entry.key).toList()
          : saved,
    );
    if (!_outboxCurrent(scope, epoch)) return false;
    _pendingMessages = remaining;
    _outboxAttempt = 0;
    if (['full', 'files-full'].contains(outboxError)) outboxError = '';
    sendStatus = _pendingMessages.isEmpty
        ? MessageSendStatus.accepted
        : MessageSendStatus.queued;
    _update();
    await _removeQueuedFiles(scope, entry.localFiles);
    return true;
  }

  Future<(PendingMessage, Content)> _sendWithSessionRecovery(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    PendingMessage entry,
  ) => _recoverOutboxSession(
    scope,
    epoch,
    session,
    () => _sendFilesAndMessage(scope, epoch, session, entry),
  );

  Future<T> _recoverOutboxSession<T>(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } on GrpcError catch (problem) {
      if (problem.code != StatusCode.unauthenticated) rethrow;
    }
    // Один повтор после входа; ключ запроса и выдача устройства прежние.
    await session.login();
    if (!_checkOutboxDevice(scope, epoch) || !identical(session, _session)) {
      throw const GrpcError.permissionDenied(
        'Устройство или пространство изменилось',
      );
    }
    return operation();
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
        content.revision < 1 ||
        content.replyToId != entry.replyTo) {
      throw const FormatException('Неверное подтверждение сообщения');
    }
    if (content.revision == 1 &&
        (content.text != entry.text ||
            !listEquals(
              content.attachments.map((asset) => asset.id).toList(),
              entry.attachmentIds,
            ))) {
      throw const FormatException('Подтверждение другого сообщения');
    }
  }

  bool _retryableSend(Object problem) =>
      problem is SocketException ||
      problem is HttpException ||
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
    if (!_pendingMessages.any((message) => message.key == entry.key)) {
      return true;
    }
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
      final removed = _pendingMessages
          .where((entry) => entry.key == event.key)
          .firstOrNull;
      final remaining = await outboxStore.change(
        scope,
        (saved) => _changedEntries(saved, event),
      );
      if (!_outboxCurrent(scope, epoch)) return;
      _pendingMessages = remaining;
      outboxError = '';
      if (event.discard && remaining.isEmpty) {
        sendStatus = MessageSendStatus.idle;
      }
      _outboxTimer?.cancel();
      _outboxTimer = null;
      _update();
      _wakeOutbox();
      if (event.discard && removed != null) {
        _activeFileUploads[event.key]?.cancel();
        await _removeQueuedFiles(scope, removed.localFiles);
      }
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
      return saved
          .where((entry) => entry.key != event.key)
          .map(
            (entry) => entry.mutation?.after == event.key
                ? entry.withBlocked(true)
                : entry,
          )
          .toList();
    }
    return saved
        .map(
          (entry) =>
              entry.key == event.key && (entry.mutation?.after.isEmpty ?? true)
              ? entry.withBlocked(false)
              : entry,
        )
        .toList();
  }
}
