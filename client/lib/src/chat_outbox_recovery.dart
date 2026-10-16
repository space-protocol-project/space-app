part of 'chat_controller.dart';

extension _ChatOutboxRecovery on ChatController {
  Future<void> _rememberPreviousQueue(
    String origin,
    ChatHistory saved,
    DeviceRecord? record,
  ) async {
    if (record == null ||
        record.serverId != saved.serverId ||
        record.grantId == saved.grantId ||
        (await record.identity()).principalId != saved.principalId) {
      return;
    }
    // Старые версии ещё не записывали каталог grant. Чтение защищённой
    // очереди регистрирует её перед удалением устаревшего кеша истории.
    await outboxStore.read(
      OutboxScope(origin, saved.serverId, saved.principalId, saved.grantId),
    );
  }

  bool _recoveryAllowed(OutboxScope source, String target) =>
      connected &&
      !busy &&
      !accessRemoved &&
      _session is DeviceManagement &&
      _outboxScope?.id == target &&
      _outboxSources.any((scope) => scope.id == source.id) &&
      _outboxGrantMatches(_outboxScope!);

  Future<bool> _recoverOutbox(ChatOutboxRecovered event) async {
    if (!_recoveryAllowed(event.source, event.target)) return false;
    final scope = _outboxScope!;
    final session = _session;
    busy = true;
    _outboxRecovering = true;
    _stopOutbox();
    final epoch = _outboxEpoch;
    _update();
    bool active() =>
        _outboxCurrent(scope, epoch) &&
        identical(session, _session) &&
        connected &&
        _outboxGrantMatches(scope);
    try {
      await _finishOutbox();
      final entries = await fileStore.transfer(
        event.source,
        scope,
        outboxStore,
        active: active,
        expectedSource: event.snapshot,
      );
      if (!active()) return false;
      _pendingMessages = entries;
      await _loadOutbox(scope);
      return outboxError.isEmpty;
    } catch (_) {
      if (active()) outboxError = 'recovery';
      return false;
    } finally {
      _outboxRecovering = false;
      if (identical(scope, _outboxScope)) {
        busy = false;
        _update();
        _wakeOutbox();
      }
    }
  }
}
