part of 'core.dart';

class SessionCommunityMentionApi implements CommunityMentionApi {
  SessionCommunityMentionApi(this.session);
  final SpaceSession session;
  @override
  String get principalId => session.principalId;

  Future<T> _call<I extends GeneratedMessage, T extends GeneratedMessage>(
    connect.Spec<I, T> spec,
    I request,
  ) async {
    if (!session.communityMentionsSupported && !session.chatMentionsSupported) {
      throw const GrpcError.unimplemented();
    }
    await session._ensureSession();
    return session.channel.unary(spec, request, options: session._options);
  }

  @override
  Future<List<mentions_pb.MentionCandidate>> candidates(
    String channel,
    String parent,
    String query,
  ) async => (await _call(
    mentions_specs.CommunityMentionService.listMentionCandidates,
    mentions_pb.ListMentionCandidatesRequest(
      channelId: channel,
      parentId: parent,
      query: query,
    ),
  )).candidates;

  @override
  Future<void> markRead(
    String channel,
    List<mentions_pb.CommunityContentReference> content,
  ) async {
    await _call(
      mentions_specs.CommunityMentionService.markCommunityMentionsRead,
      mentions_pb.MarkCommunityMentionsReadRequest(
        channelId: channel,
        contents: content,
      ),
    );
  }
}
