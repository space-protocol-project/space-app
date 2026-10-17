import 'dart:convert';

import '../rpc_clients.dart' show Asset, Content;

Map<String, dynamic>? checkedMlsReply(Map message) {
  final value = message['reply'];
  if (value == null) return null;
  if (value is! Map ||
      message['reaction'] != null ||
      message['manager'] != null) {
    throw StateError('Повреждена ссылка ответа MLS');
  }
  final grant = value['grant_id'];
  final id = value['message_id'];
  if (grant is! String ||
      !RegExp(r'^[\x20-\x7e]{1,128}$').hasMatch(grant) ||
      id is! List ||
      id.length != 16 ||
      id.any((byte) => byte is! int || byte < 0 || byte > 255)) {
    throw StateError('Повреждена ссылка ответа MLS');
  }
  return {'grant_id': grant, 'message_id': List<int>.from(id)};
}

String mlsMessageKey(Map item) =>
    jsonEncode([item['grant_id'], (item['message'] as Map)['id']]);

Map<String, dynamic> mlsReplyReference(Map item) => {
  'grant_id': item['grant_id'],
  'message_id': List<int>.from((item['message'] as Map)['id'] as List),
};

Map<String, dynamic>? findMlsReply(
  Iterable<Map<String, dynamic>> messages,
  Map? reference,
) {
  if (reference == null) return null;
  final key = jsonEncode([reference['grant_id'], reference['message_id']]);
  return messages.where((item) => mlsMessageKey(item) == key).firstOrNull;
}

Content? mlsReplyContent(Map? item) {
  if (item == null) return null;
  final message = item['message'] as Map;
  return Content(
    authorId: item['author_id'] as String,
    text: message['text'] as String,
    attachments: [
      for (final file in message['files'] as List)
        Asset(name: (file as Map)['name'] as String),
    ],
  );
}
