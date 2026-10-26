part of 'core.dart';

class SessionCommunityReactionApi implements CommunityReactionApi {
  SessionCommunityReactionApi(this.session);
  final SpaceSession session;
  @override
  String get scopeId => '${session.positionScope}|${session.currentGrantId}';

  @override
  Future<reactions_pb.ListCommunityReactionsResponse> list(
    String channel,
    List<mentions_pb.CommunityContentReference> contents,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      reactions_specs.CommunityReactionService.listCommunityReactions,
      reactions_pb.ListCommunityReactionsRequest(
        channelId: channel,
        contents: contents,
      ),
      options: session._options,
    );
  }

  @override
  Future<reactions_pb.SetCommunityReactionResponse> set(
    reactions_pb.SetCommunityReactionRequest request,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      reactions_specs.CommunityReactionService.setCommunityReaction,
      request,
      options: session._options,
    );
  }
}
