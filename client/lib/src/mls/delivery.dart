part of 'client.dart';

extension MlsDelivery on MlsClient {
  // Только явная отмена пользователем, а не неподписанный код ошибки сервера.
  Future<void> cancelTransfer(String id) => _serial(
    () => local.change((document) {
      (_channel(document, id)['outbox'] as List).removeWhere(
        (item) =>
            PublishMlsRequest.fromBuffer(
              base64Decode((item as Map)['request'] as String),
            ).kind ==
            'transfer',
      );
    }),
  );
  Future<void> send(
    String channelId,
    String text, {
    List<Map<String, dynamic>> files = const [],
    List<String> assetIds = const [],
    List<int>? messageId,
  }) => _serial(
    () => _send(
      channelId,
      text,
      files: files,
      assetIds: assetIds,
      messageId: messageId,
    ),
  );

  Future<void> _send(
    String channelId,
    String text, {
    List<Map<String, dynamic>> files = const [],
    List<String> assetIds = const [],
    List<int>? messageId,
  }) async {
    final id = messageId ?? mlsId();
    final document = await local.read();
    final channel = _channel(document, channelId);
    if (channel['revocation_pending'] == true) {
      throw StateError(
        'Сначала дождитесь исключения отозванных устройств из канала',
      );
    }
    final retries = _retries(channel);
    if (retries.isNotEmpty &&
        jsonEncode((retries.first as Map)['message']['id']) != jsonEncode(id)) {
      throw StateError('Сначала завершите отложенную отправку');
    }
    if ((channel['outbox'] as List).any((item) => !_filePaused(item as Map))) {
      throw StateError('Сначала завершите предыдущую отправку');
    }
    final message = {'version': 1, 'id': id, 'text': text, 'files': files};
    await local.update(
      'encrypt',
      {'group_id': channel['group_id'], 'message': message},
      change: (document, result) {
        final request = PublishMlsRequest(
          channelId: channelId,
          requestId: id,
          kind: 'application',
          expectedEpoch: Int64(result['epoch'] as int),
          ciphertext: base64Decode(result['ciphertext'] as String),
          attachmentIds: assetIds,
        );
        _enqueue(
          document,
          channelId,
          request,
          message: message,
          assetIds: assetIds,
        );
      },
    );
    await _flush(channelId);
  }

  Future<void> invite(String channelId, MlsDevice peer) =>
      _serial(() => _invite(channelId, peer));
  Future<void> _invite(String channelId, MlsDevice peer) async {
    final document = await local.read();
    if (_unknown(document, [peer]).isNotEmpty) {
      throw StateError('Сначала проверьте код устройства');
    }
    final channel = _channel(document, channelId);
    _requireManager(channel);
    if ((channel['revoked_devices'] as List? ?? []).contains(peer.grantId)) {
      throw StateError(
        'Для возвращения в канал зарегистрируйте новое устройство',
      );
    }
    if ((channel['roster'] as List).any(
      (binding) => (binding['device'] as Map)['grant_id'] == peer.grantId,
    )) {
      throw StateError('Устройство уже входит в канал');
    }
    if ((channel['outbox'] as List).isNotEmpty) {
      throw StateError('Сначала завершите предыдущую отправку');
    }
    await local.update(
      'invite',
      {
        'group_id': channel['group_id'],
        'peer': mlsBinding(peer),
        'key_package': base64Encode(peer.keyPackage),
      },
      change: (document, result) {
        final request = PublishMlsRequest(
          channelId: channelId,
          requestId: mlsId(),
          kind: 'commit',
          expectedEpoch: Int64(result['epoch'] as int),
          ciphertext: base64Decode(result['commit'] as String),
          welcome: base64Decode(result['welcome'] as String),
          addGrantId: peer.grantId,
        );
        _enqueue(document, channelId, request);
      },
    );
    await _flush(channelId);
  }

  Future<void> remove(String channelId, MlsDevice peer) =>
      _serial(() => _remove(channelId, peer));
  Future<void> _remove(String channelId, MlsDevice peer) async {
    final document = await local.read();
    final channel = _channel(document, channelId);
    _requireManager(channel);
    if ((channel['outbox'] as List).any(
      (item) =>
          PublishMlsRequest.fromBuffer(
            base64Decode((item as Map)['request'] as String),
          ).kind !=
          'application',
    )) {
      throw StateError('Сначала завершите предыдущую отправку');
    }
    await local.update(
      'remove',
      {'group_id': channel['group_id'], 'peer': mlsBinding(peer)},
      change: (document, result) {
        _enqueue(
          document,
          channelId,
          PublishMlsRequest(
            channelId: channelId,
            requestId: mlsId(),
            kind: 'commit',
            expectedEpoch: Int64(result['epoch'] as int),
            ciphertext: base64Decode(result['commit'] as String),
            removeGrantId: peer.grantId,
          ),
        );
      },
    );
    await _flush(channelId);
  }

  Future<void> transfer(String channelId, MlsDevice peer) =>
      _serial(() => _transfer(channelId, peer));
  Future<void> _transfer(String channelId, MlsDevice peer) async {
    final document = await local.read();
    final channel = _channel(document, channelId);
    _requireManager(channel);
    final members = (channel['roster'] as List).map(
      (binding) => (binding['device'] as Map)['grant_id'],
    );
    if (peer.grantId == local.scope['grant_id'] ||
        !members.contains(peer.grantId)) {
      throw StateError('Передать управление можно другому устройству канала');
    }
    if ((channel['outbox'] as List).isNotEmpty) {
      throw StateError('Сначала завершите предыдущую отправку');
    }
    final id = mlsId();
    await local.update(
      'encrypt',
      {
        'group_id': channel['group_id'],
        'message': {
          'version': 1,
          'id': id,
          'text': '',
          'files': [],
          'manager': peer.grantId,
        },
      },
      change: (document, result) {
        _enqueue(
          document,
          channelId,
          PublishMlsRequest(
            channelId: channelId,
            requestId: id,
            kind: 'transfer',
            expectedEpoch: Int64(result['epoch'] as int),
            ciphertext: base64Decode(result['ciphertext'] as String),
            newManagerGrantId: peer.grantId,
          ),
        );
      },
    );
    await _flush(channelId);
  }

  void _requireManager(Map<String, dynamic> channel) {
    if (!(channel['managers'] as List).contains(local.scope['grant_id'])) {
      throw StateError(
        'Изменять состав может подтверждённое управляющее устройство',
      );
    }
  }

  void _enqueue(
    Map<String, dynamic> document,
    String id,
    PublishMlsRequest request, {
    Map<String, dynamic>? message,
    List<String> assetIds = const [],
  }) {
    final channel = _channel(document, id);
    (channel['outbox'] as List).add({
      'request': base64Encode(request.writeToBuffer()),
      'message': message,
      'asset_ids': assetIds,
    });
    if (request.kind == 'application') {
      _retries(channel).removeWhere(
        (item) =>
            jsonEncode((item as Map)['message']['id']) ==
            jsonEncode(request.requestId),
      );
    }
  }

  Future<void> _flush(String id) async {
    final document = await local.read();
    final channel = _channel(document, id);
    final pending = List<Map<String, dynamic>>.from(
      (channel['outbox'] as List).cast<Map<String, dynamic>>(),
    );
    pending.sort((a, b) => _commitPriority(a).compareTo(_commitPriority(b)));
    for (final item in pending) {
      final current = _channel(await local.read(), id)['outbox'] as List;
      if (!current.any(
        (entry) => (entry as Map)['request'] == item['request'],
      )) {
        continue;
      }
      if (_filePaused(item)) continue;
      final request = PublishMlsRequest.fromBuffer(
        base64Decode(item['request'] as String),
      );
      final PublishMlsResponse response;
      response = await rpc.publishMls(request, options: await options());
      requireMlsAcknowledgement(request, response.envelope, local.scope);
      void confirm(Map<String, dynamic> document) =>
          _confirmDelivery(document, id, request, response, item);

      if (request.kind == 'commit' || request.kind == 'update') {
        await local.update('confirm_commit', {
          'group_id': channel['group_id'],
          'roster': response.envelope.roster.map(mlsBinding).toList(),
        }, change: (document, _) => confirm(document));
      } else {
        await local.change(confirm);
      }
    }
  }

  void _confirmDelivery(
    Map<String, dynamic> document,
    String id,
    PublishMlsRequest request,
    PublishMlsResponse response,
    Map<String, dynamic> item,
  ) {
    final channel = _channel(document, id);
    final receipts =
        channel.putIfAbsent('receipts', () => <String, dynamic>{}) as Map;
    receipts[response.envelope.sequence.toString()] = mlsReceipt(
      response.envelope,
    );
    if (request.kind == 'transfer') {
      channel['managers'] = [request.newManagerGrantId];
    } else if (request.kind == 'commit' || request.kind == 'update') {
      channel['epoch'] = request.expectedEpoch.toInt() + 1;
      channel['roster'] = response.envelope.roster.map(mlsBinding).toList();
      _rebaseApplications(channel);
      if (request.kind == 'update') {
        channel['last_self_update'] = DateTime.now().millisecondsSinceEpoch;
      }
    } else {
      (channel['messages'] as List).add({
        'message': item['message'],
        'asset_ids': item['asset_ids'],
        'author_id': local.scope['principal_id'],
        'grant_id': local.scope['grant_id'],
        'sequence': response.envelope.sequence.toInt(),
        'time': response.envelope.createdAtUnixMs.toInt(),
      });
    }
    (channel['outbox'] as List).removeWhere(
      (entry) => (entry as Map)['request'] == item['request'],
    );
  }

  bool _filePaused(Map item) {
    if (filesAllowed) return false;
    final request = PublishMlsRequest.fromBuffer(
      base64Decode(item['request'] as String),
    );
    return request.attachmentIds.isNotEmpty;
  }

  int _commitPriority(Map item) =>
      PublishMlsRequest.fromBuffer(base64Decode(item['request'] as String))
              .kind ==
          'application'
      ? 1
      : 0;

  void _rebaseApplications(Map<String, dynamic> channel) {
    final outbox = channel['outbox'] as List;
    final applications = outbox
        .where(
          (item) =>
              PublishMlsRequest.fromBuffer(
                base64Decode((item as Map)['request'] as String),
              ).kind ==
              'application',
        )
        .toList();
    _retries(channel).addAll(applications);
    outbox.removeWhere(applications.contains);
  }

  List<dynamic> _retries(Map<String, dynamic> channel) {
    final retries =
        channel.putIfAbsent('retry_messages', () => <dynamic>[]) as List;
    final legacy = channel.remove('retry_message');
    if (legacy != null) retries.add(legacy);
    return retries;
  }

  Future<void> _retryRebasedMessage(String id) async {
    final channel = _channel(await local.read(), id);
    if (channel['joined'] != true) return;
    for (final retry in List<Map>.from(_retries(channel))) {
      final message = retry['message'] as Map;
      await _send(
        id,
        message['text'] as String,
        messageId: (message['id'] as List).cast<int>(),
        files: (message['files'] as List).cast<Map<String, dynamic>>(),
        assetIds: (retry['asset_ids'] as List).cast<String>(),
      );
    }
  }
}
