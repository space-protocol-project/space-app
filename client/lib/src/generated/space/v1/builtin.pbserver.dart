// This is a generated file - do not edit.
//
// Generated from space/v1/builtin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'builtin.pb.dart' as $2;
import 'builtin.pbjson.dart';

export 'builtin.pb.dart';

abstract class BuiltinExtensionServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ListBuiltinSectionsResponse> listBuiltinSections(
      $pb.ServerContext ctx, $2.ListBuiltinSectionsRequest request);
  $async.Future<$2.OpenBuiltinSectionResponse> openBuiltinSection(
      $pb.ServerContext ctx, $2.OpenBuiltinSectionRequest request);
  $async.Future<$2.ExecuteBuiltinCommandResponse> executeBuiltinCommand(
      $pb.ServerContext ctx, $2.ExecuteBuiltinCommandRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListBuiltinSections':
        return $2.ListBuiltinSectionsRequest();
      case 'OpenBuiltinSection':
        return $2.OpenBuiltinSectionRequest();
      case 'ExecuteBuiltinCommand':
        return $2.ExecuteBuiltinCommandRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListBuiltinSections':
        return listBuiltinSections(
            ctx, request as $2.ListBuiltinSectionsRequest);
      case 'OpenBuiltinSection':
        return openBuiltinSection(ctx, request as $2.OpenBuiltinSectionRequest);
      case 'ExecuteBuiltinCommand':
        return executeBuiltinCommand(
            ctx, request as $2.ExecuteBuiltinCommandRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      BuiltinExtensionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => BuiltinExtensionServiceBase$messageJson;
}
