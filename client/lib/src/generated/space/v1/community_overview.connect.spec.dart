//
//  Generated code. Do not modify.
//  source: space/v1/community_overview.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_overview.pb.dart" as spacev1community_overview;

/// core.community.overview.v1: персональная сводка одного доступного раздела.
abstract final class CommunityOverviewService {
  /// Fully-qualified name of the CommunityOverviewService service.
  static const name = 'space.v1.CommunityOverviewService';

  static const getCommunityOverview = connect.Spec(
    '/$name/GetCommunityOverview',
    connect.StreamType.unary,
    spacev1community_overview.GetCommunityOverviewRequest.new,
    spacev1community_overview.GetCommunityOverviewResponse.new,
  );
}
