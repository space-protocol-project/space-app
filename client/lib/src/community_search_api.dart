import 'generated/space/v1/community_search.pb.dart';

abstract interface class CommunitySearchApi {
  Future<SearchCommunityContentResponse> search(
    String channel,
    String query,
    String token,
  );
}

abstract interface class CommunitySearchSource {
  CommunitySearchApi? get communitySearch;
}

CommunitySearchApi? communitySearchFor(Object api) =>
    api is CommunitySearchSource ? api.communitySearch : null;
