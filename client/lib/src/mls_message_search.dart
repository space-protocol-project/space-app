part of 'message_search.dart';

Future<MessageSearchPage> searchSavedMlsMessages(
  MlsLocalStore local,
  String channel,
  List<int> group,
  String query,
  String cursor,
) async => searchMlsDocument(await local.read(), channel, group, query, cursor);

Future<MessageSearchPage> searchMlsDocument(
  Map<String, dynamic> document,
  String channel,
  List<int> group,
  String query,
  String cursor,
) async {
  final term = checkedSearchQuery(query).toLowerCase();
  final groupKey = base64Encode(group);
  final saved = (document['channels'] as Map)[channel] as Map<String, dynamic>?;
  if (saved == null ||
      saved['joined'] != true ||
      saved['revocation_pending'] == true ||
      saved['group_id'] != groupKey) {
    throw StateError('Нет доступа к истории MLS');
  }
  final boundary = _MlsSearchBoundary.parse(cursor, channel, groupKey, term);
  final latest = await _latestSearchMessages(saved);
  final matches = SplayTreeSet<Content>(_compareMlsSearch);
  var processed = 0;
  for (final item in latest.values) {
    if (++processed % 512 == 0) await Future<void>.delayed(Duration.zero);
    final content = _matchingMlsContent(item, channel, term);
    if (content == null || !boundary.accepts(content)) continue;
    matches.add(content);
    if (matches.length > 51) matches.remove(matches.last);
  }
  final more = matches.length > 50;
  if (more) matches.remove(matches.last);
  final page = matches.toList();
  return MessageSearchPage(page, next: more ? boundary.encode(page.last) : '');
}

Future<Map<String, Map>> _latestSearchMessages(Map saved) async {
  final latest = <String, Map>{};
  var processed = 0;
  for (final items in [
    saved['archived_messages'] ?? const [],
    saved['messages'],
  ]) {
    for (final raw in items as List) {
      if (++processed % 512 == 0) await Future<void>.delayed(Duration.zero);
      final item = raw as Map, message = item['message'] as Map;
      if (message['reaction'] != null || message['manager'] != null) continue;
      latest[mlsMessageKey(item)] = item;
    }
  }
  return latest;
}

Content? _matchingMlsContent(Map item, String channel, String term) {
  final text = (item['message'] as Map)['text'] as String;
  if (item['deleted'] == true || !text.toLowerCase().contains(term)) {
    return null;
  }
  return Content(
    id: mlsMessageKey(item),
    channelId: channel,
    text: text,
    authorId: item['author_id'] as String,
    sequence: Int64(item['sequence'] as int),
  );
}

int _compareMlsSearch(Content a, Content b) {
  final order = b.sequence.compareTo(a.sequence);
  return order == 0 ? b.id.compareTo(a.id) : order;
}

class _MlsSearchBoundary {
  _MlsSearchBoundary(this.channel, this.group, this.query, this.anchor);
  final String channel, group, query;
  final Content? anchor;
  static _MlsSearchBoundary parse(
    String cursor,
    String channel,
    String group,
    String query,
  ) {
    if (cursor.isEmpty) return _MlsSearchBoundary(channel, group, query, null);
    if (cursor.length > 4096) throw StateError('Некорректный курсор MLS');
    final data = jsonDecode(cursor);
    if (data is! Map ||
        data['v'] != 1 ||
        data['channel'] != channel ||
        data['group'] != group ||
        data['query'] != query) {
      throw StateError('Область поиска MLS изменилась');
    }
    final sequence = data['sequence'], id = data['id'];
    if (sequence is! int ||
        sequence < 0 ||
        id is! String ||
        id.isEmpty ||
        id.length > 512) {
      throw StateError('Некорректная граница MLS');
    }
    return _MlsSearchBoundary(
      channel,
      group,
      query,
      Content(id: id, sequence: Int64(sequence)),
    );
  }

  bool accepts(Content content) =>
      anchor == null || _compareMlsSearch(content, anchor!) > 0;
  String encode(Content content) => jsonEncode({
    'v': 1,
    'channel': channel,
    'group': group,
    'query': query,
    'sequence': content.sequence.toInt(),
    'id': content.id,
  });
}
