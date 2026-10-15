part of 'client.dart';

extension MlsDelivery on MlsClient {
  Future<void> send(
    String channelId,
    String text, {
    List<Map<String, dynamic>> files = const [],
    List<String> assetIds = const [],
    List<int>? messageId,
  }) async {
    final id = messageId ?? mlsId();
    final document = await local.read();
    final channel = _channel(document, channelId);
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

  Future<void> invite(String channelId, MlsDevice peer) async {
    final document = await local.read();
    if (_unknown(document, [peer]).isNotEmpty) {
      throw StateError('Сначала проверьте код устройства');
    }
    final channel = _channel(document, channelId);
    _requireManager(channel);
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

  Future<void> remove(String channelId, MlsDevice peer) async {
    final document = await local.read();
    final channel = _channel(document, channelId);
    _requireManager(channel);
    if ((channel['outbox'] as List).isNotEmpty) {
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

  Future<void> transfer(String channelId, MlsDevice peer) async {
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
    channel.remove('retry_message');
  }

  Future<void> _flush(String id) async {
    final document = await local.read();
    final channel = _channel(document, id);
    final pending = List<Map<String, dynamic>>.from(
      (channel['outbox'] as List).cast<Map<String, dynamic>>(),
    );
    for (final item in pending) {
      if (_filePaused(item)) continue;
      final request = PublishMlsRequest.fromBuffer(
        base64Decode(item['request'] as String),
      );
      final PublishMlsResponse response;
      try {
        response = await rpc.publishMls(request, options: await options());
      } on GrpcError catch (error) {
        await _handleRejection(id, request, item, error);
        rethrow;
      }
      requireMlsAcknowledgement(request, response.envelope, local.scope);
      void confirm(Map<String, dynamic> document) {
        final channel = _channel(document, id);
        final receipts =
            channel.putIfAbsent('receipts', () => <String, dynamic>{}) as Map;
        receipts[response.envelope.sequence.toString()] = mlsReceipt(
          response.envelope,
        );
        if (request.kind == 'transfer') {
          channel['managers'] = [request.newManagerGrantId];
        } else if (request.kind == 'commit') {
          channel['epoch'] = request.expectedEpoch.toInt() + 1;
          channel['roster'] = response.envelope.roster.map(mlsBinding).toList();
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

      if (request.kind == 'commit') {
        await local.update('confirm_commit', {
          'group_id': channel['group_id'],
          'roster': response.envelope.roster.map(mlsBinding).toList(),
        }, change: (document, _) => confirm(document));
      } else {
        await local.change(confirm);
      }
    }
  }

  bool _filePaused(Map item) {
    if (filesAllowed) return false;
    final request = PublishMlsRequest.fromBuffer(
      base64Decode(item['request'] as String),
    );
    return request.attachmentIds.isNotEmpty;
  }

  Future<void> _handleRejection(
    String id,
    PublishMlsRequest request,
    Map<String, dynamic> item,
    GrpcError error,
  ) async {
    if (error.code == StatusCode.aborted) {
      await _discardStale(id, request, item);
    } else if (_rejectedTransfer(request, error)) {
      await local.change((document) {
        (_channel(document, id)['outbox'] as List).removeWhere(
          (entry) => (entry as Map)['request'] == item['request'],
        );
      });
    }
  }

  bool _rejectedTransfer(PublishMlsRequest request, GrpcError error) =>
      request.kind == 'transfer' &&
      const {
        StatusCode.invalidArgument,
        StatusCode.permissionDenied,
        StatusCode.failedPrecondition,
        StatusCode.notFound,
      }.contains(error.code);

  Future<void> _discardStale(
    String id,
    PublishMlsRequest request,
    Map<String, dynamic> item,
  ) async {
    void discard(Map<String, dynamic> document) {
      final channel = _channel(document, id);
      (channel['outbox'] as List).clear();
      if (request.kind == 'application') channel['retry_message'] = item;
    }

    if (request.kind == 'commit') {
      final channel = _channel(await local.read(), id);
      await local.update('discard_commit', {
        'group_id': channel['group_id'],
      }, change: (document, _) => discard(document));
    } else {
      await local.change(discard);
    }
  }

  Future<void> _retryRebasedMessage(String id) async {
    final channel = _channel(await local.read(), id);
    final retry = channel['retry_message'] as Map?;
    if (retry == null || channel['joined'] != true) return;
    final message = retry['message'] as Map;
    await send(
      id,
      message['text'] as String,
      messageId: (message['id'] as List).cast<int>(),
      files: (message['files'] as List).cast<Map<String, dynamic>>(),
      assetIds: (retry['asset_ids'] as List).cast<String>(),
    );
  }
}
