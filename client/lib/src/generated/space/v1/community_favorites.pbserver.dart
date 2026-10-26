// This is a generated file - do not edit.
//
// Generated from space/v1/community_favorites.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'community_favorites.pb.dart' as $2;
import 'community_favorites.pbjson.dart';

export 'community_favorites.pb.dart';

abstract class CommunityFavoriteServiceBase extends $pb.GeneratedService {
  $async.Future<$2.GetCommunityFavoriteStatesResponse>
      getCommunityFavoriteStates(
          $pb.ServerContext ctx, $2.GetCommunityFavoriteStatesRequest request);
  $async.Future<$2.ListCommunityFavoritesResponse> listCommunityFavorites(
      $pb.ServerContext ctx, $2.ListCommunityFavoritesRequest request);
  $async.Future<$2.SetCommunityFavoriteResponse> setCommunityFavorite(
      $pb.ServerContext ctx, $2.SetCommunityFavoriteRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetCommunityFavoriteStates':
        return $2.GetCommunityFavoriteStatesRequest();
      case 'ListCommunityFavorites':
        return $2.ListCommunityFavoritesRequest();
      case 'SetCommunityFavorite':
        return $2.SetCommunityFavoriteRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetCommunityFavoriteStates':
        return getCommunityFavoriteStates(
            ctx, request as $2.GetCommunityFavoriteStatesRequest);
      case 'ListCommunityFavorites':
        return listCommunityFavorites(
            ctx, request as $2.ListCommunityFavoritesRequest);
      case 'SetCommunityFavorite':
        return setCommunityFavorite(
            ctx, request as $2.SetCommunityFavoriteRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      CommunityFavoriteServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => CommunityFavoriteServiceBase$messageJson;
}
