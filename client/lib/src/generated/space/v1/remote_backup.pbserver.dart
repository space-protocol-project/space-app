// This is a generated file - do not edit.
//
// Generated from space/v1/remote_backup.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'remote_backup.pb.dart' as $0;
import 'remote_backup.pbjson.dart';

export 'remote_backup.pb.dart';

abstract class RemoteBackupServiceBase extends $pb.GeneratedService {
  $async.Future<$0.CreateBackupSlotResponse> createBackupSlot(
      $pb.ServerContext ctx, $0.CreateBackupSlotRequest request);
  $async.Future<$0.RevokeBackupSlotResponse> revokeBackupSlot(
      $pb.ServerContext ctx, $0.RevokeBackupSlotRequest request);
  $async.Future<$0.PutBackupResponse> putBackup(
      $pb.ServerContext ctx, $0.PutBackupRequest request);
  $async.Future<$0.GetBackupResponse> getBackup(
      $pb.ServerContext ctx, $0.GetBackupRequest request);
  $async.Future<$0.AdvanceBackupWitnessResponse> advanceBackupWitness(
      $pb.ServerContext ctx, $0.AdvanceBackupWitnessRequest request);
  $async.Future<$0.ReadBackupWitnessResponse> readBackupWitness(
      $pb.ServerContext ctx, $0.ReadBackupWitnessRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateBackupSlot':
        return $0.CreateBackupSlotRequest();
      case 'RevokeBackupSlot':
        return $0.RevokeBackupSlotRequest();
      case 'PutBackup':
        return $0.PutBackupRequest();
      case 'GetBackup':
        return $0.GetBackupRequest();
      case 'AdvanceBackupWitness':
        return $0.AdvanceBackupWitnessRequest();
      case 'ReadBackupWitness':
        return $0.ReadBackupWitnessRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateBackupSlot':
        return createBackupSlot(ctx, request as $0.CreateBackupSlotRequest);
      case 'RevokeBackupSlot':
        return revokeBackupSlot(ctx, request as $0.RevokeBackupSlotRequest);
      case 'PutBackup':
        return putBackup(ctx, request as $0.PutBackupRequest);
      case 'GetBackup':
        return getBackup(ctx, request as $0.GetBackupRequest);
      case 'AdvanceBackupWitness':
        return advanceBackupWitness(
            ctx, request as $0.AdvanceBackupWitnessRequest);
      case 'ReadBackupWitness':
        return readBackupWitness(ctx, request as $0.ReadBackupWitnessRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      RemoteBackupServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => RemoteBackupServiceBase$messageJson;
}
