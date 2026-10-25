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
    Set<String>? active;
    for (final entry in channels.entries) {
      final channel = entry.value as Map;
      if (channel['joined'] != true) continue;
      try {
        active ??= (await devices(entry.key as String))
            .map((device) => device.grantId)
            .toSet();
        await _maintainChannel(entry.key as String, channel, active);
      } catch (error) {
        failure ??= error;
      }
    }
    if (failure != null) throw failure;
  }

  Future<void> _maintainChannel(
    String id,
    Map channel,
    Set<String> active,
  ) async {
    final view = await _refresh(
      id,
      base64Decode(channel['group_id'] as String),
      maintain: false,
    );
    if (view.untrusted.isNotEmpty) {
      throw StateError('Сначала сверьте коды новых устройств канала');
    }
    await _removeInvalidDevices(id, active);
    final updated = _channel(await local.read(), id);
    final previous = updated['last_self_update'] as int? ?? 0;
    final upgrade =
        view.messageFeatures.known && !view.messageFeatures.ownMentions;
    final expired =
        DateTime.now().millisecondsSinceEpoch - previous >=
        const Duration(days: 1).inMilliseconds;
    if ((updated['outbox'] as List).isEmpty && (upgrade || expired)) {
      await selfUpdate(id);
    }
    await _retryRebasedMessage(id);
  }

  Future<void> _removeInvalidDevices(String id, Set<String> active) async {
    // Собственное отсутствие означает неполный/недостоверный список.
    if (!active.contains(local.scope['grant_id'])) {
      throw StateError('Сервер не подтвердил действующее устройство MLS');
    }
    final previous = _channel(await local.read(), id);
    final remembered = (previous['revoked_devices'] as List? ?? []).toSet();
    final roster = (previous['roster'] as List).cast<Map>();
    final invalid = roster
        .where(
          (binding) =>
              remembered.contains((binding['device'] as Map)['grant_id']) ||
              !active.contains((binding['device'] as Map)['grant_id']),
        )
        .toList();
    await local.change((document) {
      final channel = _channel(document, id);
      channel['revocation_pending'] = invalid.isNotEmpty;
      channel['revoked_devices'] = {
        ...remembered,
        ...invalid.map((binding) => (binding['device'] as Map)['grant_id']),
      }.toList();
    });
    final channel = _channel(await local.read(), id);
    if (invalid.isNotEmpty &&
        !(channel['managers'] as List).contains(local.scope['grant_id'])) {
      throw StateError(
        'Отозванное устройство ещё не исключено. Ожидается управляющее устройство канала.',
      );
    }
    for (final binding in invalid) {
      final scope = binding['device'] as Map;
      await remove(
        id,
        MlsDevice(
          grantId: scope['grant_id'] as String,
          principalId: scope['principal_id'] as String,
          binding: utf8.encode(jsonEncode(binding)),
        ),
      );
    }
    await local.change((document) {
      _channel(document, id)['revocation_pending'] = false;
    });
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
