part of 'space_search.dart';

String spaceSearchView(SpaceSearchKind kind) => switch (kind.value) {
  1 => 'chat',
  2 || 3 => 'forum',
  4 || 5 => 'feed',
  _ => '',
};

String spaceSearchKey(SpaceSearchResult result) =>
    '${result.kind.value}:${result.channelId}:${result.id}';

bool _spaceSearchText(String value, int max) =>
    !value.contains('\u0000') && utf8.encode(value).length <= max;

void _checkSpaceMetadata(SpaceSearchResult item) {
  if (!_spaceSearchText(item.channelTitle, 320) ||
      !_spaceSearchText(item.title, 480) ||
      item.snippet.runes.length > 240 ||
      !_spaceSearchText(item.snippet, 960) ||
      !_spaceSearchText(item.authorName, 512) ||
      item.authorId.isEmpty ||
      !_spaceSearchText(item.authorId, 256) ||
      item.createdAtUnixMs < Int64.ZERO) {
    throw StateError('Некорректные сведения результата поиска');
  }
}

void _checkSpaceTarget(SpaceSearchResult item, Map<String, String> channels) {
  final view = spaceSearchView(item.kind);
  if (view.isEmpty ||
      channels[item.channelId] != view ||
      item.id.isEmpty ||
      !_spaceSearchText(item.id, 256) ||
      item.parentId.isEmpty ||
      !_spaceSearchText(item.parentId, 256)) {
    throw StateError('Результат поиска вне доступной области');
  }
  _checkSpacePosition(item, view);
}

void _checkSpacePosition(SpaceSearchResult item, String view) {
  final root = item.kind.value == 2 || item.kind.value == 4;
  if (root ? item.sequence != Int64.ZERO : item.sequence <= Int64.ZERO) {
    throw StateError('Некорректная позиция результата поиска');
  }
  if ((root || view == 'chat') && item.parentId != item.id) {
    throw StateError('Некорректный родитель результата поиска');
  }
}

List<SpaceSearchResult> _checkedSpacePage(
  SearchSpaceResponse page,
  List<SpaceSearchResult> previous,
  Map<String, String> channels,
) {
  if (page.results.length > 50 ||
      (page.results.isEmpty && page.nextPageToken.isNotEmpty)) {
    throw StateError('Некорректный размер страницы поиска');
  }
  final result = [...previous];
  final keys = previous.map(spaceSearchKey).toSet();
  for (final source in page.results) {
    final item = source.deepCopy()..freeze();
    _checkSpaceMetadata(item);
    _checkSpaceTarget(item, channels);
    if (!keys.add(spaceSearchKey(item))) {
      throw StateError('Повтор результата поиска');
    }
    if (result.isNotEmpty && compareSpaceSearch(result.last, item) >= 0) {
      throw StateError('Нарушен порядок результатов поиска');
    }
    result.add(item);
  }
  return result;
}

int compareSpaceSearch(SpaceSearchResult a, SpaceSearchResult b) {
  final time = b.createdAtUnixMs.compareTo(a.createdAtUnixMs);
  if (time != 0) return time;
  final kind = b.kind.value.compareTo(a.kind.value);
  if (kind != 0) return kind;
  final channel = b.channelId.compareTo(a.channelId);
  return channel != 0 ? channel : _compareSpaceBytes(b.id, a.id);
}

int _compareSpaceBytes(String a, String b) {
  final left = utf8.encode(a), right = utf8.encode(b);
  for (var index = 0; index < left.length && index < right.length; index++) {
    final comparison = left[index].compareTo(right[index]);
    if (comparison != 0) return comparison;
  }
  return left.length.compareTo(right.length);
}
