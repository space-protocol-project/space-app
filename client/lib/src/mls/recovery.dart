part of 'client.dart';

extension MlsRecovery on MlsClient {
  Future<void> importHistory(Map<String, dynamic> archive) async {
    if (archive['v'] != 1 ||
        archive['server_id'] != local.scope['server_id'] ||
        archive['principal_id'] != local.scope['principal_id']) {
      throw StateError('Архив принадлежит другому пространству или участнику');
    }
    if (archive['previous_grant_id'] == local.scope['grant_id']) {
      throw StateError('Для восстановления подключите новое устройство');
    }
    final entries = (archive['channels'] as List).cast<Map>();
    if (entries.length > 256) {
      throw StateError('В архиве слишком много каналов');
    }
    for (final entry in entries) {
      entry['messages'] = _checkedHistory(entry['messages'] as List);
      final group = base64Decode(entry['group_id'] as String);
      _checkGroupContext(entry['id'] as String, group);
      await pinChannel?.call(entry['id'] as String, group);
    }
    await local.change((document) {
      final channels = document['channels'] as Map;
      for (final entry in entries) {
        final channel = channels.putIfAbsent(
          entry['id'],
          () => _newChannel(base64Decode(entry['group_id'] as String)),
        ) as Map;
        if (channel['group_id'] != entry['group_id']) {
          throw StateError('Идентификатор группы архива не совпадает');
        }
        // История отделена от активного состояния и не продвигает курсор.
        channel['archived_messages'] = mergeMlsHistory([
          ...?channel['archived_messages'] as List?,
          ...entry['messages'] as List,
        ]);
      }
    });
  }

  List<Map<String, dynamic>> _checkedHistory(List<dynamic> messages) {
    if (messages.length > 20000) {
      throw StateError('В архиве слишком много сообщений');
    }
    return messages.map(_checkedHistoryItem).toList();
  }

  Map<String, dynamic> _checkedHistoryItem(dynamic value) {
    final item = value as Map;
    final message = item['message'] as Map;
    final mentions = checkedMlsMentions(message);
    final text = message['text'] as String;
    if (utf8.encode(text).length > 65536 ||
        (message['files'] as List).length > 5 ||
        item['sequence'] is! int ||
        item['time'] is! int ||
        item['author_id'] is! String ||
        item['grant_id'] is! String) {
      throw StateError('Повреждено сообщение архива');
    }
    _historyBytes(message['id'], 16);
    final reaction = _checkedHistoryReaction(message);
    final files = (message['files'] as List).map(_checkedHistoryFile).toList();
    return <String, dynamic>{
      'archived': true,
      'author_id': item['author_id'],
      'grant_id': item['grant_id'],
      'sequence': item['sequence'],
      'time': item['time'],
      'message': {
        'version': mentions.isEmpty ? 1 : 2,
        'id': message['id'],
        'text': text,
        'files': files,
        if (mentions.isNotEmpty) 'mentions': mlsMentionJson(text, mentions),
        if (reaction != null) 'reaction': Map<String, dynamic>.from(reaction),
        'reply': ?checkedMlsReply(message),
      },
    };
  }

  Map? _checkedHistoryReaction(Map message) {
    final text = message['text'] as String;
    final reaction = message['reaction'] as Map?;
    if (reaction != null) {
      _historyBytes(reaction['message_id'], 16);
      if (reaction['grant_id'] is! String ||
          (reaction['grant_id'] as String).length > 128 ||
          reaction['emoji'] is! String ||
          (reaction['emoji'] as String).length > 64 ||
          reaction['active'] is! bool ||
          text.isNotEmpty ||
          (message['files'] as List).isNotEmpty) {
        throw StateError('Повреждена реакция архива');
      }
    }
    return reaction;
  }

  Map<String, dynamic> _checkedHistoryFile(dynamic value) {
    final file = value as Map;
    _historyBytes(file['key'], 32);
    _historyBytes(file['nonce'], 24);
    _historyBytes(file['id'], 16);
    _historyBytes(file['message_id'], 16);
    final name = file['name'] as String;
    final size = file['size'] as int;
    if (name.isEmpty ||
        name.length > 255 ||
        RegExp(r'[/\\\x00-\x1f]').hasMatch(name) ||
        size < 1 ||
        size > 20 * 1024 * 1024 ||
        file['asset_id'] is! String) {
      throw StateError('Повреждён дескриптор файла архива');
    }
    return {
      for (final key in [
        'id',
        'message_id',
        'name',
        'size',
        'asset_id',
        'key',
        'nonce',
      ])
        key: file[key],
    };
  }

  void _historyBytes(dynamic value, int size) {
    if (value is! List ||
        value.length != size ||
        value.any((byte) => byte is! int || byte < 0 || byte > 255)) {
      throw StateError('Повреждён архив истории');
    }
  }
}
