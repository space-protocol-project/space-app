// This is a generated file - do not edit.
//
// Generated from space/v1/community_reactions.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'community_reactions.pb.dart' as $1;
import 'community_reactions.pbjson.dart';

export 'community_reactions.pb.dart';

abstract class CommunityReactionServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ListCommunityReactionsResponse> listCommunityReactions(
      $pb.ServerContext ctx, $1.ListCommunityReactionsRequest request);
  $async.Future<$1.SetCommunityReactionResponse> setCommunityReaction(
      $pb.ServerContext ctx, $1.SetCommunityReactionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListCommunityReactions':
        return $1.ListCommunityReactionsRequest();
      case 'SetCommunityReaction':
        return $1.SetCommunityReactionRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListCommunityReactions':
        return listCommunityReactions(
            ctx, request as $1.ListCommunityReactionsRequest);
      case 'SetCommunityReaction':
        return setCommunityReaction(
            ctx, request as $1.SetCommunityReactionRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      CommunityReactionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => CommunityReactionServiceBase$messageJson;
}
