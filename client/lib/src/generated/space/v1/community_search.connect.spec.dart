//
//  Generated code. Do not modify.
//  source: space/v1/community_search.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_search.pb.dart" as spacev1community_search;

/// core.community.search.v1: только выбранный открытый forum/feed раздел.
abstract final class CommunitySearchService {
  /// Fully-qualified name of the CommunitySearchService service.
  static const name = 'space.v1.CommunitySearchService';

  static const searchCommunityContent = connect.Spec(
    '/$name/SearchCommunityContent',
    connect.StreamType.unary,
    spacev1community_search.SearchCommunityContentRequest.new,
    spacev1community_search.SearchCommunityContentResponse.new,
  );
}
