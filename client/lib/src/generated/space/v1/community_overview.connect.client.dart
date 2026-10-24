//
//  Generated code. Do not modify.
//  source: space/v1/community_overview.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_overview.pb.dart" as spacev1community_overview;
import "community_overview.connect.spec.dart" as specs;

/// core.community.overview.v1: персональная сводка одного доступного раздела.
extension type CommunityOverviewServiceClient (connect.Transport _transport) {
  Future<spacev1community_overview.GetCommunityOverviewResponse> getCommunityOverview(
    spacev1community_overview.GetCommunityOverviewRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityOverviewService.getCommunityOverview,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
