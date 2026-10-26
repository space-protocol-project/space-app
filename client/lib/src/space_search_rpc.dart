part of 'core.dart';

class SessionSpaceSearchApi implements SpaceSearchApi {
  SessionSpaceSearchApi(this.session);
  final SpaceSession session;
  @override
  String get scopeId => '${session.positionScope}|${session.currentGrantId}';
  @override
  Future<space_search_pb.SearchSpaceResponse> search(
    String query,
    String token,
  ) async {
    await session._ensureSession();
    return session.channel.unary(
      space_search_specs.SpaceSearchService.searchSpace,
      space_search_pb.SearchSpaceRequest(
        query: query,
        pageToken: token,
        limit: 20,
      ),
      options: session._options,
    );
  }
}
