import 'generated/space/v1/space_search.pb.dart';

export 'generated/space/v1/space_search.pb.dart';

abstract interface class SpaceSearchApi {
  String get scopeId;
  Future<SearchSpaceResponse> search(String query, String token);
}

abstract interface class SpaceSearchSource {
  SpaceSearchApi? get spaceSearch;
}
