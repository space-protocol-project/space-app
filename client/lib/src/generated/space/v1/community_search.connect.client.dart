//
//  Generated code. Do not modify.
//  source: space/v1/community_search.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_search.pb.dart" as spacev1community_search;
import "community_search.connect.spec.dart" as specs;

/// core.community.search.v1: только выбранный открытый forum/feed раздел.
extension type CommunitySearchServiceClient (connect.Transport _transport) {
  Future<spacev1community_search.SearchCommunityContentResponse> searchCommunityContent(
    spacev1community_search.SearchCommunityContentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunitySearchService.searchCommunityContent,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
