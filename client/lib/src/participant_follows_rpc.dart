part of 'core.dart';

class SessionParticipantFollowApi implements ParticipantFollowApi {
  SessionParticipantFollowApi(this.session);
  final SpaceSession session;
  @override
  String get scopeId => '${session.positionScope}|${session.currentGrantId}';
  @override
  String get principalId => session.principalId;

  Future<O> _call<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request,
  ) async {
    if (!session.participantFollowsSupported) {
      throw const GrpcError.unimplemented();
    }
    await session._ensureSession();
    return session.channel.unary(spec, request, options: session._options);
  }

  @override
  Future<follows_pb.GetParticipantFollowStatesResponse> states(
    String channel,
    List<String> ids,
  ) => _call(
    follows_specs.ParticipantFollowService.getParticipantFollowStates,
    follows_pb.GetParticipantFollowStatesRequest(
      channelId: channel,
      principalIds: ids,
    ),
  );
  @override
  Future<follows_pb.SetParticipantFollowResponse> set(
    follows_pb.SetParticipantFollowRequest request,
  ) => _call(
    follows_specs.ParticipantFollowService.setParticipantFollow,
    request,
  );
  @override
  Future<follows_pb.ListFollowingParticipantsResponse> following(
    String token,
  ) => _call(
    follows_specs.ParticipantFollowService.listFollowingParticipants,
    follows_pb.ListFollowingParticipantsRequest(pageToken: token, limit: 20),
  );
  @override
  Future<follows_pb.ListPersonalFeedResponse> feed(String token) => _call(
    follows_specs.ParticipantFollowService.listPersonalFeed,
    follows_pb.ListPersonalFeedRequest(pageToken: token, limit: 20),
  );
}
