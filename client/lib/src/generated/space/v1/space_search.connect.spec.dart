//
//  Generated code. Do not modify.
//  source: space/v1/space_search.proto
//

import "package:connectrpc/connect.dart" as connect;
import "space_search.pb.dart" as spacev1space_search;

/// core.space.search.v1: общий поиск по доступным обычным чатам, форуму и ленте.
abstract final class SpaceSearchService {
  /// Fully-qualified name of the SpaceSearchService service.
  static const name = 'space.v1.SpaceSearchService';

  static const searchSpace = connect.Spec(
    '/$name/SearchSpace',
    connect.StreamType.unary,
    spacev1space_search.SearchSpaceRequest.new,
    spacev1space_search.SearchSpaceResponse.new,
  );
}
