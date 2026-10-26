//
//  Generated code. Do not modify.
//  source: space/v1/community_reactions.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_reactions.pb.dart" as spacev1community_reactions;
import "community_reactions.connect.spec.dart" as specs;

/// core.community.reactions.v1: только forum/feed, без списка чужих principal ID.
extension type CommunityReactionServiceClient (connect.Transport _transport) {
  Future<spacev1community_reactions.ListCommunityReactionsResponse> listCommunityReactions(
    spacev1community_reactions.ListCommunityReactionsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityReactionService.listCommunityReactions,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1community_reactions.SetCommunityReactionResponse> setCommunityReaction(
    spacev1community_reactions.SetCommunityReactionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityReactionService.setCommunityReaction,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
