part of 'core.dart';

class SessionCommunityOverviewApi implements CommunityOverviewApi {
  SessionCommunityOverviewApi(this.session);
  final SpaceSession session;
  @override
  bool get supported => session.communityOverviewSupported;
  @override
  List<Channel> get sections => session.availableChannels
      .where(readableCommunity)
      .toList(growable: false);
  @override
  Future<void> refresh() => session.refreshChannels();
  @override
  Future<overview_pb.GetCommunityOverviewResponse> overview(
    String channel,
  ) async {
    if (!supported) throw const GrpcError.unimplemented();
    await session._ensureSession();
    return session.channel.unary(
      overview_specs.CommunityOverviewService.getCommunityOverview,
      overview_pb.GetCommunityOverviewRequest(channelId: channel),
      options: session._options,
    );
  }
}
