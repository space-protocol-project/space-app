//
//  Generated code. Do not modify.
//  source: space/v1/community_favorites.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_favorites.pb.dart" as spacev1community_favorites;

/// core.community.favorites.v1: личное избранное участника, общее для его устройств.
abstract final class CommunityFavoriteService {
  /// Fully-qualified name of the CommunityFavoriteService service.
  static const name = 'space.v1.CommunityFavoriteService';

  static const getCommunityFavoriteStates = connect.Spec(
    '/$name/GetCommunityFavoriteStates',
    connect.StreamType.unary,
    spacev1community_favorites.GetCommunityFavoriteStatesRequest.new,
    spacev1community_favorites.GetCommunityFavoriteStatesResponse.new,
  );

  static const listCommunityFavorites = connect.Spec(
    '/$name/ListCommunityFavorites',
    connect.StreamType.unary,
    spacev1community_favorites.ListCommunityFavoritesRequest.new,
    spacev1community_favorites.ListCommunityFavoritesResponse.new,
  );

  static const setCommunityFavorite = connect.Spec(
    '/$name/SetCommunityFavorite',
    connect.StreamType.unary,
    spacev1community_favorites.SetCommunityFavoriteRequest.new,
    spacev1community_favorites.SetCommunityFavoriteResponse.new,
  );
}
