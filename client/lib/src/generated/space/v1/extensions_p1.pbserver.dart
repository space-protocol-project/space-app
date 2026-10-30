// This is a generated file - do not edit.
//
// Generated from space/v1/extensions_p1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'extensions_p1.pb.dart' as $0;
import 'extensions_p1.pbjson.dart';

export 'extensions_p1.pb.dart';

abstract class ExtensionP1ServiceBase extends $pb.GeneratedService {
  $async.Future<$0.QueryExtensionResponse> queryExtension(
      $pb.ServerContext ctx, $0.QueryExtensionRequest request);
  $async.Future<$0.ExecuteExtensionCommandResponse> executeExtensionCommand(
      $pb.ServerContext ctx, $0.ExecuteExtensionCommandRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'QueryExtension':
        return $0.QueryExtensionRequest();
      case 'ExecuteExtensionCommand':
        return $0.ExecuteExtensionCommandRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'QueryExtension':
        return queryExtension(ctx, request as $0.QueryExtensionRequest);
      case 'ExecuteExtensionCommand':
        return executeExtensionCommand(
            ctx, request as $0.ExecuteExtensionCommandRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      ExtensionP1ServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ExtensionP1ServiceBase$messageJson;
}
