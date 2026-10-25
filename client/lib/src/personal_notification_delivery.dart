part of 'personal_notifications_controller.dart';

extension PersonalNotificationDelivery on PersonalNotificationsController {
  Future<void> poll() =>
      _polling ??= _poll().whenComplete(() => _polling = null);

  Future<void> _poll() async {
    if (!state.enabled || isClosed) return;
    await refreshSources();
    final epoch = _epoch;
    final sources = _sources.values.toList();
    for (var start = 0; start < sources.length; start += 4) {
      if (!_deliveryCurrent(epoch)) return;
      await Future.wait(
        sources.skip(start).take(4).map((scope) => _baseline(scope, epoch)),
      );
    }
    await _deliverRound(sources, epoch);
  }

  bool _deliveryCurrent(int epoch) =>
      !isClosed && state.enabled && epoch == _epoch;

  Future<void> _baseline(PersonalNotificationScope scope, int epoch) async {
    if (_checkpoints.containsKey(scope.key) || !current(scope)) return;
    try {
      final page = await read(
        scope,
        ListPersonalNotificationsRequest(
          channelId: scope.channel.id,
          baselineOnly: true,
        ),
      );
      if (page != null && current(scope) && _deliveryCurrent(epoch)) {
        _checkpoints[scope.key] = _NotificationCheckpoint(
          scope,
          page.nextSequence.toInt(),
        );
      }
    } catch (_) {
      /* Следующий цикл повторит начальную границу. */
    }
  }

  Future<void> _deliverRound(
    List<PersonalNotificationScope> sources,
    int epoch,
  ) async {
    if (sources.isEmpty) return;
    var remaining = 32;
    for (var offset = 0; offset < sources.length; offset++) {
      final index = (_roundStart + offset) % sources.length;
      remaining -= await _deliverPage(sources[index], epoch, remaining);
      if (remaining == 0) {
        _roundStart = (index + 1) % sources.length;
        return;
      }
    }
    _roundStart = (_roundStart + 1) % sources.length;
  }

  Future<int> _deliverPage(
    PersonalNotificationScope scope,
    int epoch,
    int limit,
  ) async {
    final checkpoint = _checkpoints[scope.key];
    if (checkpoint == null || !current(scope) || !_deliveryCurrent(epoch)) {
      return 0;
    }
    try {
      final page = await read(
        scope,
        ListPersonalNotificationsRequest(
          channelId: scope.channel.id,
          afterSequence: Int64(checkpoint.after),
          throughSequence: Int64(checkpoint.through),
          unreadOnly: true,
          limit: limit,
        ),
      );
      if (page == null || !current(scope) || !_deliveryCurrent(epoch)) return 0;
      checkpoint.through = page.throughSequence.toInt();
      return await _consume(scope, checkpoint, page, epoch);
    } on GrpcError catch (error) {
      if (error.code == StatusCode.invalidArgument) {
        resetScope(scope);
      }
    } catch (_) {
      /* Сбой доставки сохраняет курсор для повтора. */
    }
    return 0;
  }

  Future<int> _consume(
    PersonalNotificationScope scope,
    _NotificationCheckpoint checkpoint,
    ListPersonalNotificationsResponse page,
    int epoch,
  ) async {
    if (!current(scope) || !_deliveryCurrent(epoch)) return 0;
    if (page.notifications.isNotEmpty) {
      final notices = page.notifications
          .map((n) => n.deepCopy()..freeze())
          .toList();
      final handled = await deliver(scope, notices);
      if (!current(scope) || !_deliveryCurrent(epoch) || !handled) return 0;
    }
    checkpoint.after = page.nextSequence.toInt();
    if (!page.hasMore) checkpoint.through = 0;
    return page.notifications.length;
  }
}
