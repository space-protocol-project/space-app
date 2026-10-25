//
//  Generated code. Do not modify.
//  source: space/v1/community_mentions.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_mentions.pb.dart" as spacev1community_mentions;
import "community_mentions.connect.spec.dart" as specs;

extension type CommunityMentionServiceClient (connect.Transport _transport) {
  Future<spacev1community_mentions.ListMentionCandidatesResponse> listMentionCandidates(
    spacev1community_mentions.ListMentionCandidatesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityMentionService.listMentionCandidates,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1community_mentions.MarkCommunityMentionsReadResponse> markCommunityMentionsRead(
    spacev1community_mentions.MarkCommunityMentionsReadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityMentionService.markCommunityMentionsRead,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
