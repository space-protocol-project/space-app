part of 'core.dart';

class SessionCommunitySearchApi implements CommunitySearchApi {
  SessionCommunitySearchApi(this.session);
  final SpaceSession session;

  @override
  Future<community.SearchCommunityContentResponse> search(
    String channel,
    String query,
    String token,
  ) async {
    if (!session.communitySearchSupported) {
      throw const GrpcError.unimplemented();
    }
    await session._ensureSession();
    return session.channel.unary(
      community_specs.CommunitySearchService.searchCommunityContent,
      community.SearchCommunityContentRequest(
        channelId: channel,
        query: query,
        pageToken: token,
      ),
      options: session._options,
    );
  }
}
