import 'generated/space/v1/community_mentions.pb.dart';
import 'generated/space/v1/community_favorites.pb.dart';

export 'generated/space/v1/community_mentions.pb.dart'
    show CommunityContentReference;
export 'generated/space/v1/community_search.pb.dart' show CommunitySearchResult;
export 'generated/space/v1/community_search.pbenum.dart'
    show CommunitySearchKind;
export 'generated/space/v1/community_favorites.pb.dart';

abstract interface class CommunityFavoriteApi {
  String get scopeId;
  Future<GetCommunityFavoriteStatesResponse> states(
    String channel,
    List<CommunityContentReference> contents,
  );
  Future<ListCommunityFavoritesResponse> list(String channel, String pageToken);
  Future<SetCommunityFavoriteResponse> set(SetCommunityFavoriteRequest request);
}

abstract interface class CommunityFavoriteSource {
  CommunityFavoriteApi? get communityFavorites;
}

CommunityFavoriteApi? communityFavoritesFor(Object api) =>
    api is CommunityFavoriteSource ? api.communityFavorites : null;
String communityFavoriteKey(CommunityContentReference content) =>
    '${content.kind.value}:${content.id}';
bool validFavoriteReference(CommunityContentReference content) =>
    content.kind.value >= 1 &&
    content.kind.value <= 4 &&
    RegExp(r'^[\x21-\x7e]{1,128}$').hasMatch(content.id);
