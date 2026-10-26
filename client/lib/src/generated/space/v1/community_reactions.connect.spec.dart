//
//  Generated code. Do not modify.
//  source: space/v1/community_reactions.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_reactions.pb.dart" as spacev1community_reactions;

/// core.community.reactions.v1: только forum/feed, без списка чужих principal ID.
abstract final class CommunityReactionService {
  /// Fully-qualified name of the CommunityReactionService service.
  static const name = 'space.v1.CommunityReactionService';

  static const listCommunityReactions = connect.Spec(
    '/$name/ListCommunityReactions',
    connect.StreamType.unary,
    spacev1community_reactions.ListCommunityReactionsRequest.new,
    spacev1community_reactions.ListCommunityReactionsResponse.new,
  );

  static const setCommunityReaction = connect.Spec(
    '/$name/SetCommunityReaction',
    connect.StreamType.unary,
    spacev1community_reactions.SetCommunityReactionRequest.new,
    spacev1community_reactions.SetCommunityReactionResponse.new,
  );
}
