// This is a generated file - do not edit.
//
// Generated from space/v1/participant_follows.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'participant_follows.pb.dart' as $3;
import 'participant_follows.pbjson.dart';

export 'participant_follows.pb.dart';

abstract class ParticipantFollowServiceBase extends $pb.GeneratedService {
  $async.Future<$3.GetParticipantFollowStatesResponse>
      getParticipantFollowStates(
          $pb.ServerContext ctx, $3.GetParticipantFollowStatesRequest request);
  $async.Future<$3.SetParticipantFollowResponse> setParticipantFollow(
      $pb.ServerContext ctx, $3.SetParticipantFollowRequest request);
  $async.Future<$3.ListFollowingParticipantsResponse> listFollowingParticipants(
      $pb.ServerContext ctx, $3.ListFollowingParticipantsRequest request);
  $async.Future<$3.ListPersonalFeedResponse> listPersonalFeed(
      $pb.ServerContext ctx, $3.ListPersonalFeedRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetParticipantFollowStates':
        return $3.GetParticipantFollowStatesRequest();
      case 'SetParticipantFollow':
        return $3.SetParticipantFollowRequest();
      case 'ListFollowingParticipants':
        return $3.ListFollowingParticipantsRequest();
      case 'ListPersonalFeed':
        return $3.ListPersonalFeedRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetParticipantFollowStates':
        return getParticipantFollowStates(
            ctx, request as $3.GetParticipantFollowStatesRequest);
      case 'SetParticipantFollow':
        return setParticipantFollow(
            ctx, request as $3.SetParticipantFollowRequest);
      case 'ListFollowingParticipants':
        return listFollowingParticipants(
            ctx, request as $3.ListFollowingParticipantsRequest);
      case 'ListPersonalFeed':
        return listPersonalFeed(ctx, request as $3.ListPersonalFeedRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      ParticipantFollowServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ParticipantFollowServiceBase$messageJson;
}
