part of 'core.dart';

class SessionCommunityFavoriteApi implements CommunityFavoriteApi {
  SessionCommunityFavoriteApi(this.session);
  final SpaceSession session;
  @override
  String get scopeId => '${session.positionScope}|${session.currentGrantId}';
  @override
  Future<favorites_pb.GetCommunityFavoriteStatesResponse> states(
    String channel,
    List<mentions_pb.CommunityContentReference> contents,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      favorites_specs.CommunityFavoriteService.getCommunityFavoriteStates,
      favorites_pb.GetCommunityFavoriteStatesRequest(
        channelId: channel,
        contents: contents,
      ),
      options: session._options,
    );
  }

  @override
  Future<favorites_pb.ListCommunityFavoritesResponse> list(
    String channel,
    String pageToken,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      favorites_specs.CommunityFavoriteService.listCommunityFavorites,
      favorites_pb.ListCommunityFavoritesRequest(
        channelId: channel,
        pageToken: pageToken,
      ),
      options: session._options,
    );
  }

  @override
  Future<favorites_pb.SetCommunityFavoriteResponse> set(
    favorites_pb.SetCommunityFavoriteRequest request,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      favorites_specs.CommunityFavoriteService.setCommunityFavorite,
      request,
      options: session._options,
    );
  }
}
