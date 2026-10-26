import 'generated/space/v1/community_mentions.pb.dart';
import 'generated/space/v1/community_reactions.pb.dart';

export 'generated/space/v1/community_mentions.pb.dart'
    show CommunityContentReference;
export 'generated/space/v1/community_reactions.pb.dart';
export 'generated/space/v1/community_search.pbenum.dart'
    show CommunitySearchKind;

abstract interface class CommunityReactionApi {
  String get scopeId;
  Future<ListCommunityReactionsResponse> list(
    String channel,
    List<CommunityContentReference> contents,
  );
  Future<SetCommunityReactionResponse> set(SetCommunityReactionRequest request);
}

abstract interface class CommunityReactionSource {
  CommunityReactionApi? get communityReactions;
}

CommunityReactionApi? communityReactionsFor(Object api) =>
    api is CommunityReactionSource ? api.communityReactions : null;

String communityReactionKey(CommunityContentReference content) =>
    '${content.kind.value}:${content.id}';

bool validReactionReference(CommunityContentReference content) =>
    content.kind.value >= 1 &&
    content.kind.value <= 4 &&
    RegExp(r'^[\x21-\x7e]{1,128}$').hasMatch(content.id);
