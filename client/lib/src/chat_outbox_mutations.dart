part of 'chat_controller.dart';

extension _ChatOutboxMutations on ChatController {
  bool get _canQueueMutation =>
      _outboxScope != null &&
      canQueue &&
      (_session == null || _session is QueuedMutationSession);

  Future<bool> _enqueueMutation(
    Content message,
    MutationKind kind, {
    String text = '',
    String emoji = '',
    bool active = false,
  }) async {
    final scope = _outboxScope;
    if (!_canQueueMutation ||
        scope == null ||
        message.deleted ||
        message.channelId != channelId ||
        message.revision < 1 ||
        message.sequence < 1) {
      return false;
    }
    if (kind != MutationKind.reaction &&
        message.authorId != scope.principalId) {
      return false;
    }
    final change = QueuedMutation.forMessage(
      message,
      kind,
      emoji: emoji,
      active: active,
    );
    final signature = jsonEncode([
      'mutation',
      channelId,
      text,
      change.toJson(),
    ]);
    if (_pendingText != signature || _pendingKey.isEmpty) {
      _pendingText = signature;
      _pendingKey = newRequestKey();
    }
    return _persistMessage(
      scope,
      PendingMessage(
        key: _pendingKey,
        channelId: channelId,
        text: text,
        createdAt: now().millisecondsSinceEpoch,
        mutation: change,
      ),
    );
  }

  List<PendingMessage> _appendMutation(
    List<PendingMessage> saved,
    PendingMessage entry,
  ) {
    final change = entry.mutation;
    if (change == null) return [...saved, entry];
    final previous = saved
        .where(
          (item) =>
              item.channelId == entry.channelId &&
              item.mutation?.id == change.id,
        )
        .lastOrNull;
    if (previous == null) return [...saved, entry];
    if (previous.mutation!.kind == MutationKind.delete) {
      throw const FormatException('Удаление уже ожидает отправки');
    }
    return [...saved, entry.withMutation(change.dependingOn(previous.key))];
  }

  Future<bool> _deliverMutation(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    PendingMessage entry,
  ) async {
    sendStatus = MessageSendStatus.sending;
    _update();
    MutationReceipt receipt;
    try {
      if (session is! QueuedMutationSession) {
        throw const GrpcError.failedPrecondition(
          'Сессия не поддерживает очередь изменений',
        );
      }
      receipt = await _recoverOutboxSession(
        scope,
        epoch,
        session,
        () => (session as QueuedMutationSession).mutateQueued(
          entry.channelId,
          entry.key,
          entry.text,
          entry.mutation!,
        ),
      );
      checkMutationReceipt(scope, entry, receipt);
    } catch (problem) {
      if (!_outboxCurrent(scope, epoch)) return false;
      return _pendingFailure(scope, epoch, entry, problem);
    }
    if (!_checkOutboxDevice(scope, epoch)) return false;
    final content = receipt.content;
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
          ? acknowledgeMutation(saved, entry, receipt.appliedRevision)
          : saved,
    );
    if (!_outboxCurrent(scope, epoch)) return false;
    _pendingMessages = remaining;
    _outboxAttempt = 0;
    if (outboxError == 'full') outboxError = '';
    sendStatus = remaining.isEmpty
        ? MessageSendStatus.accepted
        : MessageSendStatus.queued;
    _update();
    return true;
  }
}
