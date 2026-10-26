//
//  Generated code. Do not modify.
//  source: space/v1/space_search.proto
//

import "package:connectrpc/connect.dart" as connect;
import "space_search.pb.dart" as spacev1space_search;
import "space_search.connect.spec.dart" as specs;

/// core.space.search.v1: общий поиск по доступным обычным чатам, форуму и ленте.
extension type SpaceSearchServiceClient (connect.Transport _transport) {
  Future<spacev1space_search.SearchSpaceResponse> searchSpace(
    spacev1space_search.SearchSpaceRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.SpaceSearchService.searchSpace,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
