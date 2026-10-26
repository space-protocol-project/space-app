import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/space_search.dart';

const searchChannels = {'chat': 'chat', 'forum': 'forum', 'feed': 'feed'};

SpaceSearchResult searchHit(String id, {int kind = 2, int time = 1000}) {
  final view = kind == 1 ? 'chat' : kind <= 3 ? 'forum' : 'feed';
  final root = kind == 1 || kind == 2 || kind == 4;
  return SpaceSearchResult(channelId: view,
    channelTitle: {'chat': 'Чаты', 'forum': 'Форум', 'feed': 'Лента'}[view],
    kind: SpaceSearchKind.valueOf(kind), id: id, parentId: root ? id : 'parent',
    title: kind == 2 || kind == 3 ? 'Совет форума' : '',
    snippet: 'Совет $id', authorId: 'p_author', authorName: 'Мария',
    createdAtUnixMs: Int64(time), sequence: Int64(root && kind != 1 ? 0 : 3));
}

class FakeSpaceSearch implements SpaceSearchApi {
  @override String scopeId = 'scope';
  final calls = <(String,String)>[];
  List<SpaceSearchResult> items = [for (var kind = 5; kind >= 1; kind--) searchHit('item-$kind', kind: kind)];
  Future<SearchSpaceResponse> Function(String,String)? onSearch;
  @override Future<SearchSpaceResponse> search(String query, String token) async {
    calls.add((query,token));
    if (onSearch != null) return onSearch!(query,token);
    return SearchSpaceResponse(results: items.map((i) => i.deepCopy()));
  }
}
