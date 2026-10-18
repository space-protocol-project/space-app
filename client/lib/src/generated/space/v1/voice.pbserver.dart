// This is a generated file - do not edit.
//
// Generated from space/v1/voice.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'voice.pb.dart' as $0;
import 'voice.pbjson.dart';

export 'voice.pb.dart';

abstract class VoiceServiceBase extends $pb.GeneratedService {
  $async.Future<$0.JoinVoiceRoomResponse> joinVoiceRoom(
      $pb.ServerContext ctx, $0.JoinVoiceRoomRequest request);
  $async.Future<$0.UpdateVoiceRoomResponse> updateVoiceRoom(
      $pb.ServerContext ctx, $0.UpdateVoiceRoomRequest request);
  $async.Future<$0.LeaveVoiceRoomResponse> leaveVoiceRoom(
      $pb.ServerContext ctx, $0.LeaveVoiceRoomRequest request);
  $async.Future<$0.GetVoiceRoomResponse> getVoiceRoom(
      $pb.ServerContext ctx, $0.GetVoiceRoomRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'JoinVoiceRoom':
        return $0.JoinVoiceRoomRequest();
      case 'UpdateVoiceRoom':
        return $0.UpdateVoiceRoomRequest();
      case 'LeaveVoiceRoom':
        return $0.LeaveVoiceRoomRequest();
      case 'GetVoiceRoom':
        return $0.GetVoiceRoomRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'JoinVoiceRoom':
        return joinVoiceRoom(ctx, request as $0.JoinVoiceRoomRequest);
      case 'UpdateVoiceRoom':
        return updateVoiceRoom(ctx, request as $0.UpdateVoiceRoomRequest);
      case 'LeaveVoiceRoom':
        return leaveVoiceRoom(ctx, request as $0.LeaveVoiceRoomRequest);
      case 'GetVoiceRoom':
        return getVoiceRoom(ctx, request as $0.GetVoiceRoomRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => VoiceServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => VoiceServiceBase$messageJson;
}
