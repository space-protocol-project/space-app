//
//  Generated code. Do not modify.
//  source: space/v1/community_favorites.proto
//

import "package:connectrpc/connect.dart" as connect;
import "community_favorites.pb.dart" as spacev1community_favorites;
import "community_favorites.connect.spec.dart" as specs;

/// core.community.favorites.v1: личное избранное участника, общее для его устройств.
extension type CommunityFavoriteServiceClient (connect.Transport _transport) {
  Future<spacev1community_favorites.GetCommunityFavoriteStatesResponse> getCommunityFavoriteStates(
    spacev1community_favorites.GetCommunityFavoriteStatesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityFavoriteService.getCommunityFavoriteStates,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1community_favorites.ListCommunityFavoritesResponse> listCommunityFavorites(
    spacev1community_favorites.ListCommunityFavoritesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityFavoriteService.listCommunityFavorites,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1community_favorites.SetCommunityFavoriteResponse> setCommunityFavorite(
    spacev1community_favorites.SetCommunityFavoriteRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.CommunityFavoriteService.setCommunityFavorite,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
