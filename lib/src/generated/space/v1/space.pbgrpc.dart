// This is a generated file - do not edit.
//
// Generated from space/v1/space.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'space.pb.dart' as $0;

export 'space.pb.dart';

/// Экспериментальный контракт первого локального прототипа.
@$pb.GrpcServiceName('space.v1.ChannelService')
class ChannelServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChannelServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetManifestResponse> getManifest(
    $0.GetManifestRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getManifest, request, options: options);
  }

  // method descriptors

  static final _$getManifest =
      $grpc.ClientMethod<$0.GetManifestRequest, $0.GetManifestResponse>(
          '/space.v1.ChannelService/GetManifest',
          ($0.GetManifestRequest value) => value.writeToBuffer(),
          $0.GetManifestResponse.fromBuffer);
}

@$pb.GrpcServiceName('space.v1.ChannelService')
abstract class ChannelServiceBase extends $grpc.Service {
  $core.String get $name => 'space.v1.ChannelService';

  ChannelServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetManifestRequest, $0.GetManifestResponse>(
            'GetManifest',
            getManifest_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetManifestRequest.fromBuffer(value),
            ($0.GetManifestResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetManifestResponse> getManifest_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetManifestRequest> $request) async {
    return getManifest($call, await $request);
  }

  $async.Future<$0.GetManifestResponse> getManifest(
      $grpc.ServiceCall call, $0.GetManifestRequest request);
}

@$pb.GrpcServiceName('space.v1.ContentService')
class ContentServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ContentServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateContentResponse> createContent(
    $0.CreateContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createContent, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListContentResponse> listContent(
    $0.ListContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listContent, request, options: options);
  }

  // method descriptors

  static final _$createContent =
      $grpc.ClientMethod<$0.CreateContentRequest, $0.CreateContentResponse>(
          '/space.v1.ContentService/CreateContent',
          ($0.CreateContentRequest value) => value.writeToBuffer(),
          $0.CreateContentResponse.fromBuffer);
  static final _$listContent =
      $grpc.ClientMethod<$0.ListContentRequest, $0.ListContentResponse>(
          '/space.v1.ContentService/ListContent',
          ($0.ListContentRequest value) => value.writeToBuffer(),
          $0.ListContentResponse.fromBuffer);
}

@$pb.GrpcServiceName('space.v1.ContentService')
abstract class ContentServiceBase extends $grpc.Service {
  $core.String get $name => 'space.v1.ContentService';

  ContentServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.CreateContentRequest, $0.CreateContentResponse>(
            'CreateContent',
            createContent_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateContentRequest.fromBuffer(value),
            ($0.CreateContentResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListContentRequest, $0.ListContentResponse>(
            'ListContent',
            listContent_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListContentRequest.fromBuffer(value),
            ($0.ListContentResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateContentResponse> createContent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateContentRequest> $request) async {
    return createContent($call, await $request);
  }

  $async.Future<$0.CreateContentResponse> createContent(
      $grpc.ServiceCall call, $0.CreateContentRequest request);

  $async.Future<$0.ListContentResponse> listContent_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListContentRequest> $request) async {
    return listContent($call, await $request);
  }

  $async.Future<$0.ListContentResponse> listContent(
      $grpc.ServiceCall call, $0.ListContentRequest request);
}

@$pb.GrpcServiceName('space.v1.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateChallengeResponse> createChallenge(
    $0.CreateChallengeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createChallenge, request, options: options);
  }

  $grpc.ResponseFuture<$0.CompleteChallengeResponse> completeChallenge(
    $0.CompleteChallengeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$completeChallenge, request, options: options);
  }

  // method descriptors

  static final _$createChallenge =
      $grpc.ClientMethod<$0.CreateChallengeRequest, $0.CreateChallengeResponse>(
          '/space.v1.AuthService/CreateChallenge',
          ($0.CreateChallengeRequest value) => value.writeToBuffer(),
          $0.CreateChallengeResponse.fromBuffer);
  static final _$completeChallenge = $grpc.ClientMethod<
          $0.CompleteChallengeRequest, $0.CompleteChallengeResponse>(
      '/space.v1.AuthService/CompleteChallenge',
      ($0.CompleteChallengeRequest value) => value.writeToBuffer(),
      $0.CompleteChallengeResponse.fromBuffer);
}

@$pb.GrpcServiceName('space.v1.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'space.v1.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateChallengeRequest,
            $0.CreateChallengeResponse>(
        'CreateChallenge',
        createChallenge_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateChallengeRequest.fromBuffer(value),
        ($0.CreateChallengeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CompleteChallengeRequest,
            $0.CompleteChallengeResponse>(
        'CompleteChallenge',
        completeChallenge_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompleteChallengeRequest.fromBuffer(value),
        ($0.CompleteChallengeResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateChallengeResponse> createChallenge_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateChallengeRequest> $request) async {
    return createChallenge($call, await $request);
  }

  $async.Future<$0.CreateChallengeResponse> createChallenge(
      $grpc.ServiceCall call, $0.CreateChallengeRequest request);

  $async.Future<$0.CompleteChallengeResponse> completeChallenge_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompleteChallengeRequest> $request) async {
    return completeChallenge($call, await $request);
  }

  $async.Future<$0.CompleteChallengeResponse> completeChallenge(
      $grpc.ServiceCall call, $0.CompleteChallengeRequest request);
}

@$pb.GrpcServiceName('space.v1.SyncService')
class SyncServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SyncServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListEventsResponse> listEvents(
    $0.ListEventsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listEvents, request, options: options);
  }

  // method descriptors

  static final _$listEvents =
      $grpc.ClientMethod<$0.ListEventsRequest, $0.ListEventsResponse>(
          '/space.v1.SyncService/ListEvents',
          ($0.ListEventsRequest value) => value.writeToBuffer(),
          $0.ListEventsResponse.fromBuffer);
}

@$pb.GrpcServiceName('space.v1.SyncService')
abstract class SyncServiceBase extends $grpc.Service {
  $core.String get $name => 'space.v1.SyncService';

  SyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListEventsRequest, $0.ListEventsResponse>(
        'ListEvents',
        listEvents_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListEventsRequest.fromBuffer(value),
        ($0.ListEventsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListEventsResponse> listEvents_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListEventsRequest> $request) async {
    return listEvents($call, await $request);
  }

  $async.Future<$0.ListEventsResponse> listEvents(
      $grpc.ServiceCall call, $0.ListEventsRequest request);
}
