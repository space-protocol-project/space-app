// This is a generated file - do not edit.
//
// Generated from space/v1/directory_pairing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'directory_pairing.pb.dart' as $0;
import 'directory_pairing.pbjson.dart';

export 'directory_pairing.pb.dart';

abstract class DirectoryPairingServiceBase extends $pb.GeneratedService {
  $async.Future<$0.CreateDirectoryTransferResponse> createDirectoryTransfer(
      $pb.ServerContext ctx, $0.CreateDirectoryTransferRequest request);
  $async.Future<$0.OpenDirectoryTransferResponse> openDirectoryTransfer(
      $pb.ServerContext ctx, $0.OpenDirectoryTransferRequest request);
  $async.Future<$0.WriteDirectoryFrameResponse> writeDirectoryFrame(
      $pb.ServerContext ctx, $0.WriteDirectoryFrameRequest request);
  $async.Future<$0.ReadDirectoryFrameResponse> readDirectoryFrame(
      $pb.ServerContext ctx, $0.ReadDirectoryFrameRequest request);
  $async.Future<$0.CloseDirectoryTransferResponse> closeDirectoryTransfer(
      $pb.ServerContext ctx, $0.CloseDirectoryTransferRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateDirectoryTransfer':
        return $0.CreateDirectoryTransferRequest();
      case 'OpenDirectoryTransfer':
        return $0.OpenDirectoryTransferRequest();
      case 'WriteDirectoryFrame':
        return $0.WriteDirectoryFrameRequest();
      case 'ReadDirectoryFrame':
        return $0.ReadDirectoryFrameRequest();
      case 'CloseDirectoryTransfer':
        return $0.CloseDirectoryTransferRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateDirectoryTransfer':
        return createDirectoryTransfer(
            ctx, request as $0.CreateDirectoryTransferRequest);
      case 'OpenDirectoryTransfer':
        return openDirectoryTransfer(
            ctx, request as $0.OpenDirectoryTransferRequest);
      case 'WriteDirectoryFrame':
        return writeDirectoryFrame(
            ctx, request as $0.WriteDirectoryFrameRequest);
      case 'ReadDirectoryFrame':
        return readDirectoryFrame(ctx, request as $0.ReadDirectoryFrameRequest);
      case 'CloseDirectoryTransfer':
        return closeDirectoryTransfer(
            ctx, request as $0.CloseDirectoryTransferRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      DirectoryPairingServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => DirectoryPairingServiceBase$messageJson;
}
