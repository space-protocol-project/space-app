part of 'client.dart';

extension MlsReceive on MlsClient {
  Future<List<MlsDevice>> _receive(
    String channelId,
    MlsEnvelope envelope,
  ) async {
    final document = await local.read();
    final channel = _channel(document, channelId);
    requireMlsSequence(channel, envelope);
    if (envelope.authorGrantId == local.scope['grant_id']) {
      final receiptKey = envelope.sequence.toString();
      if ((channel['receipts'] as Map?)?[receiptKey] != mlsReceipt(envelope)) {
        throw StateError(
          'Сервер вернул неизвестный пакет от имени этого устройства',
        );
      }
      await local.change((document) {
        final channel = _channel(document, channelId);
        (channel['receipts'] as Map).remove(receiptKey);
        channel['cursor'] = envelope.sequence.toInt();
      });
      return [];
    }
    if (envelope.kind == 'commit' || envelope.kind == 'update') {
      return _receiveCommit(channelId, envelope, document, channel);
    }
    if (!channel['joined'] || envelope.epoch.toInt() != channel['epoch']) {
      throw StateError('Необходимо восстановить эпоху MLS');
    }
    await local.update(
      'decrypt',
      {
        'group_id': channel['group_id'],
        'ciphertext': base64Encode(envelope.ciphertext),
      },
      change: (document, result) {
        _checkSender(result['sender'] as String, envelope);
        final message = result['message'] as Map<String, dynamic>;
        if (base64Encode((message['id'] as List).cast<int>()) !=
            base64Encode(envelope.requestId)) {
          throw StateError('Идентификатор сообщения изменён сервером');
        }
        final channel = _channel(document, channelId);
        _acceptPayload(channel, message, envelope);
        channel['cursor'] = envelope.sequence.toInt();
      },
    );
    return [];
  }

  Future<List<MlsDevice>> _receiveCommit(
    String id,
    MlsEnvelope envelope,
    Map<String, dynamic> document,
    Map<String, dynamic> channel,
  ) async {
    final unknown = _unknown(document, envelope.roster);
    if (unknown.isNotEmpty) return unknown;
    final roster = envelope.roster.map(mlsBinding).toList();
    final joining = channel['joined'] != true;
    final args = _commitArgs(channel, envelope, roster, joining);
    await local.update(
      joining ? 'join' : 'apply_commit',
      args,
      change: (document, result) {
        final channel = _channel(document, id);
        _confirmWelcome(joining, channel, result, envelope);
        channel['joined'] = true;
        if (joining) {
          channel['last_self_update'] = DateTime.now().millisecondsSinceEpoch;
        }
        channel['epoch'] = result['epoch'];
        channel['roster'] = roster;
        channel['cursor'] = envelope.sequence.toInt();
        if (!joining) {
          _rebaseApplications(channel);
          (channel['outbox'] as List).clear();
        }
      },
    );
    if (joining) {
      _registered = false;
      await initialize();
    }
    return [];
  }

  Map<String, dynamic> _commitArgs(
    Map<String, dynamic> channel,
    MlsEnvelope envelope,
    List<Map<String, dynamic>> roster,
    bool joining,
  ) {
    final committer =
        (joining
                ? roster
                : (channel['roster'] as List).cast<Map<String, dynamic>>())
            .where(
              (binding) =>
                  (binding['device'] as Map)['grant_id'] ==
                  envelope.authorGrantId,
            )
            .firstOrNull;
    if (committer == null) {
      throw StateError('Нет подтверждённого автора Commit');
    }
    if (!joining &&
        envelope.kind != 'update' &&
        !(channel['managers'] as List).contains(envelope.authorGrantId)) {
      throw StateError('Устройство не уполномочено менять состав канала');
    }
    if (joining &&
        (envelope.addedGrantId != local.scope['grant_id'] ||
            envelope.welcome.isEmpty)) {
      throw StateError('Нет приглашения этого устройства');
    }
    final args = <String, dynamic>{
      'group_id': channel['group_id'],
      'roster': roster,
    };
    if (envelope.kind == 'update' &&
        (joining || jsonEncode(roster) != jsonEncode(channel['roster']))) {
      throw StateError('Self-update не может менять состав группы');
    }
    if (joining) {
      args['welcome'] = base64Encode(envelope.welcome);
    } else {
      args['committer'] = committer;
      args['commit'] = base64Encode(envelope.ciphertext);
    }
    return args;
  }

  void _checkSender(String sender, MlsEnvelope envelope) {
    final identity = jsonDecode(utf8.decode(base64Decode(sender))) as List;
    final scope = identity[1] as Map;
    if (identity[0] != 'space/mls/device/v1' ||
        scope['server_id'] != local.scope['server_id'] ||
        scope['grant_id'] != envelope.authorGrantId ||
        scope['principal_id'] != envelope.authorId) {
      throw StateError('Автор сообщения не соответствует MLS-подписи');
    }
  }

  void _acceptPayload(
    Map<String, dynamic> channel,
    Map<String, dynamic> message,
    MlsEnvelope envelope,
  ) {
    checkedMlsMentions(message);
    final manager = message['manager'];
    if (envelope.kind == 'transfer') {
      final authorized = (channel['managers'] as List).contains(
        envelope.authorGrantId,
      );
      final members = (channel['roster'] as List).map(
        (binding) => (binding['device'] as Map)['grant_id'],
      );
      if (!authorized ||
          message['reaction'] != null ||
          manager == null ||
          manager != envelope.newManagerGrantId ||
          !members.contains(manager)) {
        throw StateError('Недействительная передача управления MLS');
      }
      channel['managers'] = [manager];
      return;
    }
    if (envelope.kind != 'application' || manager != null) {
      throw StateError(
        'Тип операции не соответствует зашифрованному сообщению',
      );
    }
    (channel['messages'] as List).add({
      'message': message,
      'author_id': envelope.authorId,
      'grant_id': envelope.authorGrantId,
      'sequence': envelope.sequence.toInt(),
      'time': envelope.createdAtUnixMs.toInt(),
    });
  }

  void _confirmWelcome(
    bool joining,
    Map<String, dynamic> channel,
    Map<String, dynamic> result,
    MlsEnvelope envelope,
  ) {
    if (!joining) return;
    _checkSender(result['sender'] as String, envelope);
    channel['managers'] = [envelope.authorGrantId];
  }
}
