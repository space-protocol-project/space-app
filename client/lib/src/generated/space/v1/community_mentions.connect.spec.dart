//
//  Generated code. Do not modify.
//  source: space/v1/community_mentions.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_mentions.pb.dart" as spacev1community_mentions;

abstract final class CommunityMentionService {
  /// Fully-qualified name of the CommunityMentionService service.
  static const name = 'space.v1.CommunityMentionService';

  static const listMentionCandidates = connect.Spec(
    '/$name/ListMentionCandidates',
    connect.StreamType.unary,
    spacev1community_mentions.ListMentionCandidatesRequest.new,
    spacev1community_mentions.ListMentionCandidatesResponse.new,
  );

  static const markCommunityMentionsRead = connect.Spec(
    '/$name/MarkCommunityMentionsRead',
    connect.StreamType.unary,
    spacev1community_mentions.MarkCommunityMentionsReadRequest.new,
    spacev1community_mentions.MarkCommunityMentionsReadResponse.new,
  );
}
