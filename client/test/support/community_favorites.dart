import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/community_favorites_api.dart';

CommunityContentReference favoriteRef(String id, {int kind = 1}) =>
    CommunityContentReference(kind: CommunitySearchKind.valueOf(kind), id: id);
CommunityFavorite favoriteItem(String id, {int kind = 1}) => CommunityFavorite(
  result: CommunitySearchResult(
    kind: CommunitySearchKind.valueOf(kind),
    id: id,
    parentId: kind == 1 || kind == 3 ? id : 'parent',
    title: 'Тема $id',
    snippet: 'Текст $id',
    sequence: Int64(kind == 1 || kind == 3 ? 0 : 3),
  ),
  savedAtUnixMicros: Int64.ONE,
);

class FakeCommunityFavorites implements CommunityFavoriteApi {
  @override
  String scopeId = 'fake';
  final values = <String, CommunityFavoriteState>{};
  final requests = <SetCommunityFavoriteRequest>[];
  final pages = <List<CommunityContentReference>>[];
  final applied = <String, SetCommunityFavoriteResponse>{};
  Future<GetCommunityFavoriteStatesResponse> Function(
    List<CommunityContentReference>,
  )?
  onStates;
  Future<SetCommunityFavoriteResponse> Function(SetCommunityFavoriteRequest)?
  onSet;
  Future<ListCommunityFavoritesResponse> Function(String)? onList;
  CommunityFavoriteState value(CommunityContentReference ref) =>
      values.putIfAbsent(
        communityFavoriteKey(ref),
        () => CommunityFavoriteState(content: ref),
      );
  @override
  Future<GetCommunityFavoriteStatesResponse> states(
    String channel,
    List<CommunityContentReference> contents,
  ) async {
    pages.add(contents);
    if (onStates != null) return onStates!(contents);
    return GetCommunityFavoriteStatesResponse(states: contents.map(value));
  }

  @override
  Future<ListCommunityFavoritesResponse> list(
    String channel,
    String pageToken,
  ) async {
    if (onList != null) return onList!(pageToken);
    return ListCommunityFavoritesResponse(
      favorites: values.values
          .where((s) => s.saved)
          .map((s) => favoriteItem(s.content.id, kind: s.content.kind.value)),
    );
  }

  @override
  Future<SetCommunityFavoriteResponse> set(
    SetCommunityFavoriteRequest request,
  ) async {
    requests.add(request.deepCopy());
    if (onSet != null) return onSet!(request);
    return apply(request);
  }

  SetCommunityFavoriteResponse apply(SetCommunityFavoriteRequest request) {
    final current = value(request.content).deepCopy();
    final previous = applied[request.idempotencyKey];
    if (previous != null) return previous.deepCopy()..state = current;
    if (current.revision != request.expectedRevision) {
      throw const GrpcError.aborted();
    }
    if (current.saved != request.saved) {
      current.saved = request.saved;
      current.revision += Int64.ONE;
    }
    values[communityFavoriteKey(request.content)] = current;
    final result = SetCommunityFavoriteResponse(
      state: current.deepCopy(),
      idempotencyKey: request.idempotencyKey,
      appliedRevision: current.revision,
    );
    applied[request.idempotencyKey] = result.deepCopy();
    return result;
  }
}
