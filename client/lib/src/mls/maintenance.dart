part of 'client.dart';

extension MlsMaintenance on MlsClient {
  Future<void> maintainChannels({bool force = false}) =>
      _serial(() => _maintain(force: force));
  Future<void> _maintain({bool force = false}) async {
    if (_maintenance != null) return _maintenance;
    if (!force &&
        _maintainedAt != null &&
        DateTime.now().difference(_maintainedAt!) <
            const Duration(seconds: 30)) {
      return;
    }
    final operation = _maintainChannels();
    _maintenance = operation;
    try {
      await operation;
      _maintainedAt = DateTime.now();
    } finally {
      _maintenance = null;
    }
  }

  Future<void> _maintainChannels() async {
    final channels = (await local.read())['channels'] as Map;
    Object? failure;
    for (final entry in channels.entries) {
      final channel = entry.value as Map;
      if (channel['joined'] != true) continue;
      try {
        await _maintainChannel(entry.key as String, channel);
      } catch (error) {
        failure ??= error;
      }
    }
    if (failure != null) throw failure;
  }

  Future<void> _maintainChannel(String id, Map channel) async {
    final view = await _refresh(
      id,
      base64Decode(channel['group_id'] as String),
      maintain: false,
    );
    if (view.untrusted.isNotEmpty) {
      throw StateError('Сначала сверьте коды новых устройств канала');
    }
    if ((_channel(await local.read(), id)['managers'] as List).contains(
      local.scope['grant_id'],
    )) {
      await _removeInvalidDevices(id);
    }
    final updated = _channel(await local.read(), id);
    final previous = updated['last_self_update'] as int? ?? 0;
    if ((updated['outbox'] as List).isEmpty &&
        DateTime.now().millisecondsSinceEpoch - previous >=
            const Duration(days: 1).inMilliseconds) {
      await selfUpdate(id);
    }
    await _retryRebasedMessage(id);
  }

  Future<void> _removeInvalidDevices(String id) async {
    final active = (await devices(id)).map((device) => device.grantId).toSet();
    // Собственное отсутствие означает неполный/недостоверный список.
    if (!active.contains(local.scope['grant_id'])) {
      throw StateError('Сервер не подтвердил действующее устройство MLS');
    }
    final roster = (_channel(await local.read(), id)['roster'] as List)
        .cast<Map>();
    for (final binding in roster) {
      final scope = binding['device'] as Map;
      if (active.contains(scope['grant_id'])) continue;
      await remove(
        id,
        MlsDevice(
          grantId: scope['grant_id'] as String,
          principalId: scope['principal_id'] as String,
          binding: utf8.encode(jsonEncode(binding)),
        ),
      );
    }
  }

  Future<void> selfUpdate(String id) => _serial(() => _selfUpdate(id));
  Future<void> _selfUpdate(String id) async {
    final channel = _channel(await local.read(), id);
    if ((channel['outbox'] as List).isNotEmpty) {
      throw StateError('Сначала завершите отправку');
    }
    await local.update(
      'self_update',
      {'group_id': channel['group_id']},
      change: (document, result) {
        _enqueue(
          document,
          id,
          PublishMlsRequest(
            channelId: id,
            requestId: mlsId(),
            kind: 'update',
            expectedEpoch: Int64(result['epoch'] as int),
            ciphertext: base64Decode(result['commit'] as String),
          ),
        );
      },
    );
    await _flush(id);
  }

  Future<Map<String, dynamic>> groupCode(String id) async {
    final channel = _channel(await local.read(), id);
    return local.update('group_code', {'group_id': channel['group_id']});
  }
}
