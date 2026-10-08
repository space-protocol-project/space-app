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

  /// Экспериментальный API; требует поддержки stable principal у клиента.
  $grpc.ResponseFuture<$0.CreateRootRotationResponse> createRootRotation(
    $0.CreateRootRotationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createRootRotation, request, options: options);
  }

  $grpc.ResponseFuture<$0.CompleteRootRotationResponse> completeRootRotation(
    $0.CompleteRootRotationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$completeRootRotation, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProposePairingResponse> proposePairing(
    $0.ProposePairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$proposePairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreatePairingResponse> createPairing(
    $0.CreatePairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.InspectPairingResponse> inspectPairing(
    $0.InspectPairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$inspectPairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.PollPairingResponse> pollPairing(
    $0.PollPairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pollPairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelPairingResponse> cancelPairing(
    $0.CancelPairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelPairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClaimPairingResponse> claimPairing(
    $0.ClaimPairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$claimPairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.RevokeCurrentDeviceResponse> revokeCurrentDevice(
    $0.RevokeCurrentDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$revokeCurrentDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListDevicesResponse> listDevices(
    $0.ListDevicesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listDevices, request, options: options);
  }

  $grpc.ResponseFuture<$0.LogoutResponse> logout(
    $0.LogoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$logout, request, options: options);
  }

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

  static final _$createRootRotation = $grpc.ClientMethod<
          $0.CreateRootRotationRequest, $0.CreateRootRotationResponse>(
      '/space.v1.AuthService/CreateRootRotation',
      ($0.CreateRootRotationRequest value) => value.writeToBuffer(),
      $0.CreateRootRotationResponse.fromBuffer);
  static final _$completeRootRotation = $grpc.ClientMethod<
          $0.CompleteRootRotationRequest, $0.CompleteRootRotationResponse>(
      '/space.v1.AuthService/CompleteRootRotation',
      ($0.CompleteRootRotationRequest value) => value.writeToBuffer(),
      $0.CompleteRootRotationResponse.fromBuffer);
  static final _$proposePairing =
      $grpc.ClientMethod<$0.ProposePairingRequest, $0.ProposePairingResponse>(
          '/space.v1.AuthService/ProposePairing',
          ($0.ProposePairingRequest value) => value.writeToBuffer(),
          $0.ProposePairingResponse.fromBuffer);
  static final _$createPairing =
      $grpc.ClientMethod<$0.CreatePairingRequest, $0.CreatePairingResponse>(
          '/space.v1.AuthService/CreatePairing',
          ($0.CreatePairingRequest value) => value.writeToBuffer(),
          $0.CreatePairingResponse.fromBuffer);
  static final _$inspectPairing =
      $grpc.ClientMethod<$0.InspectPairingRequest, $0.InspectPairingResponse>(
          '/space.v1.AuthService/InspectPairing',
          ($0.InspectPairingRequest value) => value.writeToBuffer(),
          $0.InspectPairingResponse.fromBuffer);
  static final _$pollPairing =
      $grpc.ClientMethod<$0.PollPairingRequest, $0.PollPairingResponse>(
          '/space.v1.AuthService/PollPairing',
          ($0.PollPairingRequest value) => value.writeToBuffer(),
          $0.PollPairingResponse.fromBuffer);
  static final _$cancelPairing =
      $grpc.ClientMethod<$0.CancelPairingRequest, $0.CancelPairingResponse>(
          '/space.v1.AuthService/CancelPairing',
          ($0.CancelPairingRequest value) => value.writeToBuffer(),
          $0.CancelPairingResponse.fromBuffer);
  static final _$claimPairing =
      $grpc.ClientMethod<$0.ClaimPairingRequest, $0.ClaimPairingResponse>(
          '/space.v1.AuthService/ClaimPairing',
          ($0.ClaimPairingRequest value) => value.writeToBuffer(),
          $0.ClaimPairingResponse.fromBuffer);
  static final _$revokeCurrentDevice = $grpc.ClientMethod<
          $0.RevokeCurrentDeviceRequest, $0.RevokeCurrentDeviceResponse>(
      '/space.v1.AuthService/RevokeCurrentDevice',
      ($0.RevokeCurrentDeviceRequest value) => value.writeToBuffer(),
      $0.RevokeCurrentDeviceResponse.fromBuffer);
  static final _$listDevices =
      $grpc.ClientMethod<$0.ListDevicesRequest, $0.ListDevicesResponse>(
          '/space.v1.AuthService/ListDevices',
          ($0.ListDevicesRequest value) => value.writeToBuffer(),
          $0.ListDevicesResponse.fromBuffer);
  static final _$logout =
      $grpc.ClientMethod<$0.LogoutRequest, $0.LogoutResponse>(
          '/space.v1.AuthService/Logout',
          ($0.LogoutRequest value) => value.writeToBuffer(),
          $0.LogoutResponse.fromBuffer);
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
    $addMethod($grpc.ServiceMethod<$0.CreateRootRotationRequest,
            $0.CreateRootRotationResponse>(
        'CreateRootRotation',
        createRootRotation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateRootRotationRequest.fromBuffer(value),
        ($0.CreateRootRotationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CompleteRootRotationRequest,
            $0.CompleteRootRotationResponse>(
        'CompleteRootRotation',
        completeRootRotation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CompleteRootRotationRequest.fromBuffer(value),
        ($0.CompleteRootRotationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProposePairingRequest,
            $0.ProposePairingResponse>(
        'ProposePairing',
        proposePairing_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProposePairingRequest.fromBuffer(value),
        ($0.ProposePairingResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreatePairingRequest, $0.CreatePairingResponse>(
            'CreatePairing',
            createPairing_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreatePairingRequest.fromBuffer(value),
            ($0.CreatePairingResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InspectPairingRequest,
            $0.InspectPairingResponse>(
        'InspectPairing',
        inspectPairing_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InspectPairingRequest.fromBuffer(value),
        ($0.InspectPairingResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PollPairingRequest, $0.PollPairingResponse>(
            'PollPairing',
            pollPairing_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PollPairingRequest.fromBuffer(value),
            ($0.PollPairingResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CancelPairingRequest, $0.CancelPairingResponse>(
            'CancelPairing',
            cancelPairing_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CancelPairingRequest.fromBuffer(value),
            ($0.CancelPairingResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ClaimPairingRequest, $0.ClaimPairingResponse>(
            'ClaimPairing',
            claimPairing_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ClaimPairingRequest.fromBuffer(value),
            ($0.ClaimPairingResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RevokeCurrentDeviceRequest,
            $0.RevokeCurrentDeviceResponse>(
        'RevokeCurrentDevice',
        revokeCurrentDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RevokeCurrentDeviceRequest.fromBuffer(value),
        ($0.RevokeCurrentDeviceResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListDevicesRequest, $0.ListDevicesResponse>(
            'ListDevices',
            listDevices_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListDevicesRequest.fromBuffer(value),
            ($0.ListDevicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
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

  $async.Future<$0.CreateRootRotationResponse> createRootRotation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateRootRotationRequest> $request) async {
    return createRootRotation($call, await $request);
  }

  $async.Future<$0.CreateRootRotationResponse> createRootRotation(
      $grpc.ServiceCall call, $0.CreateRootRotationRequest request);

  $async.Future<$0.CompleteRootRotationResponse> completeRootRotation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CompleteRootRotationRequest> $request) async {
    return completeRootRotation($call, await $request);
  }

  $async.Future<$0.CompleteRootRotationResponse> completeRootRotation(
      $grpc.ServiceCall call, $0.CompleteRootRotationRequest request);

  $async.Future<$0.ProposePairingResponse> proposePairing_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProposePairingRequest> $request) async {
    return proposePairing($call, await $request);
  }

  $async.Future<$0.ProposePairingResponse> proposePairing(
      $grpc.ServiceCall call, $0.ProposePairingRequest request);

  $async.Future<$0.CreatePairingResponse> createPairing_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreatePairingRequest> $request) async {
    return createPairing($call, await $request);
  }

  $async.Future<$0.CreatePairingResponse> createPairing(
      $grpc.ServiceCall call, $0.CreatePairingRequest request);

  $async.Future<$0.InspectPairingResponse> inspectPairing_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InspectPairingRequest> $request) async {
    return inspectPairing($call, await $request);
  }

  $async.Future<$0.InspectPairingResponse> inspectPairing(
      $grpc.ServiceCall call, $0.InspectPairingRequest request);

  $async.Future<$0.PollPairingResponse> pollPairing_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PollPairingRequest> $request) async {
    return pollPairing($call, await $request);
  }

  $async.Future<$0.PollPairingResponse> pollPairing(
      $grpc.ServiceCall call, $0.PollPairingRequest request);

  $async.Future<$0.CancelPairingResponse> cancelPairing_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CancelPairingRequest> $request) async {
    return cancelPairing($call, await $request);
  }

  $async.Future<$0.CancelPairingResponse> cancelPairing(
      $grpc.ServiceCall call, $0.CancelPairingRequest request);

  $async.Future<$0.ClaimPairingResponse> claimPairing_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClaimPairingRequest> $request) async {
    return claimPairing($call, await $request);
  }

  $async.Future<$0.ClaimPairingResponse> claimPairing(
      $grpc.ServiceCall call, $0.ClaimPairingRequest request);

  $async.Future<$0.RevokeCurrentDeviceResponse> revokeCurrentDevice_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RevokeCurrentDeviceRequest> $request) async {
    return revokeCurrentDevice($call, await $request);
  }

  $async.Future<$0.RevokeCurrentDeviceResponse> revokeCurrentDevice(
      $grpc.ServiceCall call, $0.RevokeCurrentDeviceRequest request);

  $async.Future<$0.ListDevicesResponse> listDevices_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListDevicesRequest> $request) async {
    return listDevices($call, await $request);
  }

  $async.Future<$0.ListDevicesResponse> listDevices(
      $grpc.ServiceCall call, $0.ListDevicesRequest request);

  $async.Future<$0.LogoutResponse> logout_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LogoutRequest> $request) async {
    return logout($call, await $request);
  }

  $async.Future<$0.LogoutResponse> logout(
      $grpc.ServiceCall call, $0.LogoutRequest request);

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

  $grpc.ResponseStream<$0.SubscribeResponse> subscribe(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribe, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.ListEventsResponse> listEvents(
    $0.ListEventsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listEvents, request, options: options);
  }

  // method descriptors

  static final _$subscribe =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.SubscribeResponse>(
          '/space.v1.SyncService/Subscribe',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.SubscribeResponse.fromBuffer);
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
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.SubscribeResponse>(
        'Subscribe',
        subscribe_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.SubscribeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListEventsRequest, $0.ListEventsResponse>(
        'ListEvents',
        listEvents_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListEventsRequest.fromBuffer(value),
        ($0.ListEventsResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.SubscribeResponse> subscribe_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* subscribe($call, await $request);
  }

  $async.Stream<$0.SubscribeResponse> subscribe(
      $grpc.ServiceCall call, $0.SubscribeRequest request);

  $async.Future<$0.ListEventsResponse> listEvents_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListEventsRequest> $request) async {
    return listEvents($call, await $request);
  }

  $async.Future<$0.ListEventsResponse> listEvents(
      $grpc.ServiceCall call, $0.ListEventsRequest request);
}

@$pb.GrpcServiceName('space.v1.AdminService')
class AdminServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AdminServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListMembersResponse> listMembers(
    $0.ListMembersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMembers, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateMemberResponse> updateMember(
    $0.UpdateMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateMember, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateInviteResponse> createInvite(
    $0.CreateInviteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createInvite, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListInvitesResponse> listInvites(
    $0.ListInvitesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listInvites, request, options: options);
  }

  $grpc.ResponseFuture<$0.RevokeInviteResponse> revokeInvite(
    $0.RevokeInviteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$revokeInvite, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSetupStatusResponse> getSetupStatus(
    $0.GetSetupStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSetupStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClaimOwnerResponse> claimOwner(
    $0.ClaimOwnerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$claimOwner, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSettingsResponse> getSettings(
    $0.GetSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateSettingsResponse> updateSettings(
    $0.UpdateSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateSettings, request, options: options);
  }

  // method descriptors

  static final _$listMembers =
      $grpc.ClientMethod<$0.ListMembersRequest, $0.ListMembersResponse>(
          '/space.v1.AdminService/ListMembers',
          ($0.ListMembersRequest value) => value.writeToBuffer(),
          $0.ListMembersResponse.fromBuffer);
  static final _$updateMember =
      $grpc.ClientMethod<$0.UpdateMemberRequest, $0.UpdateMemberResponse>(
          '/space.v1.AdminService/UpdateMember',
          ($0.UpdateMemberRequest value) => value.writeToBuffer(),
          $0.UpdateMemberResponse.fromBuffer);
  static final _$createInvite =
      $grpc.ClientMethod<$0.CreateInviteRequest, $0.CreateInviteResponse>(
          '/space.v1.AdminService/CreateInvite',
          ($0.CreateInviteRequest value) => value.writeToBuffer(),
          $0.CreateInviteResponse.fromBuffer);
  static final _$listInvites =
      $grpc.ClientMethod<$0.ListInvitesRequest, $0.ListInvitesResponse>(
          '/space.v1.AdminService/ListInvites',
          ($0.ListInvitesRequest value) => value.writeToBuffer(),
          $0.ListInvitesResponse.fromBuffer);
  static final _$revokeInvite =
      $grpc.ClientMethod<$0.RevokeInviteRequest, $0.RevokeInviteResponse>(
          '/space.v1.AdminService/RevokeInvite',
          ($0.RevokeInviteRequest value) => value.writeToBuffer(),
          $0.RevokeInviteResponse.fromBuffer);
  static final _$getSetupStatus =
      $grpc.ClientMethod<$0.GetSetupStatusRequest, $0.GetSetupStatusResponse>(
          '/space.v1.AdminService/GetSetupStatus',
          ($0.GetSetupStatusRequest value) => value.writeToBuffer(),
          $0.GetSetupStatusResponse.fromBuffer);
  static final _$claimOwner =
      $grpc.ClientMethod<$0.ClaimOwnerRequest, $0.ClaimOwnerResponse>(
          '/space.v1.AdminService/ClaimOwner',
          ($0.ClaimOwnerRequest value) => value.writeToBuffer(),
          $0.ClaimOwnerResponse.fromBuffer);
  static final _$getSettings =
      $grpc.ClientMethod<$0.GetSettingsRequest, $0.GetSettingsResponse>(
          '/space.v1.AdminService/GetSettings',
          ($0.GetSettingsRequest value) => value.writeToBuffer(),
          $0.GetSettingsResponse.fromBuffer);
  static final _$updateSettings =
      $grpc.ClientMethod<$0.UpdateSettingsRequest, $0.UpdateSettingsResponse>(
          '/space.v1.AdminService/UpdateSettings',
          ($0.UpdateSettingsRequest value) => value.writeToBuffer(),
          $0.UpdateSettingsResponse.fromBuffer);
}

@$pb.GrpcServiceName('space.v1.AdminService')
abstract class AdminServiceBase extends $grpc.Service {
  $core.String get $name => 'space.v1.AdminService';

  AdminServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListMembersRequest, $0.ListMembersResponse>(
            'ListMembers',
            listMembers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListMembersRequest.fromBuffer(value),
            ($0.ListMembersResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateMemberRequest, $0.UpdateMemberResponse>(
            'UpdateMember',
            updateMember_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateMemberRequest.fromBuffer(value),
            ($0.UpdateMemberResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreateInviteRequest, $0.CreateInviteResponse>(
            'CreateInvite',
            createInvite_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreateInviteRequest.fromBuffer(value),
            ($0.CreateInviteResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListInvitesRequest, $0.ListInvitesResponse>(
            'ListInvites',
            listInvites_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListInvitesRequest.fromBuffer(value),
            ($0.ListInvitesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RevokeInviteRequest, $0.RevokeInviteResponse>(
            'RevokeInvite',
            revokeInvite_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RevokeInviteRequest.fromBuffer(value),
            ($0.RevokeInviteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSetupStatusRequest,
            $0.GetSetupStatusResponse>(
        'GetSetupStatus',
        getSetupStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSetupStatusRequest.fromBuffer(value),
        ($0.GetSetupStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClaimOwnerRequest, $0.ClaimOwnerResponse>(
        'ClaimOwner',
        claimOwner_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ClaimOwnerRequest.fromBuffer(value),
        ($0.ClaimOwnerResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetSettingsRequest, $0.GetSettingsResponse>(
            'GetSettings',
            getSettings_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSettingsRequest.fromBuffer(value),
            ($0.GetSettingsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateSettingsRequest,
            $0.UpdateSettingsResponse>(
        'UpdateSettings',
        updateSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateSettingsRequest.fromBuffer(value),
        ($0.UpdateSettingsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListMembersResponse> listMembers_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListMembersRequest> $request) async {
    return listMembers($call, await $request);
  }

  $async.Future<$0.ListMembersResponse> listMembers(
      $grpc.ServiceCall call, $0.ListMembersRequest request);

  $async.Future<$0.UpdateMemberResponse> updateMember_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateMemberRequest> $request) async {
    return updateMember($call, await $request);
  }

  $async.Future<$0.UpdateMemberResponse> updateMember(
      $grpc.ServiceCall call, $0.UpdateMemberRequest request);

  $async.Future<$0.CreateInviteResponse> createInvite_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateInviteRequest> $request) async {
    return createInvite($call, await $request);
  }

  $async.Future<$0.CreateInviteResponse> createInvite(
      $grpc.ServiceCall call, $0.CreateInviteRequest request);

  $async.Future<$0.ListInvitesResponse> listInvites_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListInvitesRequest> $request) async {
    return listInvites($call, await $request);
  }

  $async.Future<$0.ListInvitesResponse> listInvites(
      $grpc.ServiceCall call, $0.ListInvitesRequest request);

  $async.Future<$0.RevokeInviteResponse> revokeInvite_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RevokeInviteRequest> $request) async {
    return revokeInvite($call, await $request);
  }

  $async.Future<$0.RevokeInviteResponse> revokeInvite(
      $grpc.ServiceCall call, $0.RevokeInviteRequest request);

  $async.Future<$0.GetSetupStatusResponse> getSetupStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSetupStatusRequest> $request) async {
    return getSetupStatus($call, await $request);
  }

  $async.Future<$0.GetSetupStatusResponse> getSetupStatus(
      $grpc.ServiceCall call, $0.GetSetupStatusRequest request);

  $async.Future<$0.ClaimOwnerResponse> claimOwner_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ClaimOwnerRequest> $request) async {
    return claimOwner($call, await $request);
  }

  $async.Future<$0.ClaimOwnerResponse> claimOwner(
      $grpc.ServiceCall call, $0.ClaimOwnerRequest request);

  $async.Future<$0.GetSettingsResponse> getSettings_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSettingsRequest> $request) async {
    return getSettings($call, await $request);
  }

  $async.Future<$0.GetSettingsResponse> getSettings(
      $grpc.ServiceCall call, $0.GetSettingsRequest request);

  $async.Future<$0.UpdateSettingsResponse> updateSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateSettingsRequest> $request) async {
    return updateSettings($call, await $request);
  }

  $async.Future<$0.UpdateSettingsResponse> updateSettings(
      $grpc.ServiceCall call, $0.UpdateSettingsRequest request);
}

@$pb.GrpcServiceName('space.v1.MembershipService')
class MembershipServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MembershipServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.PreviewInviteResponse> previewInvite(
    $0.PreviewInviteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$previewInvite, request, options: options);
  }

  $grpc.ResponseFuture<$0.AcceptInviteResponse> acceptInvite(
    $0.AcceptInviteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$acceptInvite, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetMembershipResponse> getMembership(
    $0.GetMembershipRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMembership, request, options: options);
  }

  // method descriptors

  static final _$previewInvite =
      $grpc.ClientMethod<$0.PreviewInviteRequest, $0.PreviewInviteResponse>(
          '/space.v1.MembershipService/PreviewInvite',
          ($0.PreviewInviteRequest value) => value.writeToBuffer(),
          $0.PreviewInviteResponse.fromBuffer);
  static final _$acceptInvite =
      $grpc.ClientMethod<$0.AcceptInviteRequest, $0.AcceptInviteResponse>(
          '/space.v1.MembershipService/AcceptInvite',
          ($0.AcceptInviteRequest value) => value.writeToBuffer(),
          $0.AcceptInviteResponse.fromBuffer);
  static final _$getMembership =
      $grpc.ClientMethod<$0.GetMembershipRequest, $0.GetMembershipResponse>(
          '/space.v1.MembershipService/GetMembership',
          ($0.GetMembershipRequest value) => value.writeToBuffer(),
          $0.GetMembershipResponse.fromBuffer);
}

@$pb.GrpcServiceName('space.v1.MembershipService')
abstract class MembershipServiceBase extends $grpc.Service {
  $core.String get $name => 'space.v1.MembershipService';

  MembershipServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.PreviewInviteRequest, $0.PreviewInviteResponse>(
            'PreviewInvite',
            previewInvite_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PreviewInviteRequest.fromBuffer(value),
            ($0.PreviewInviteResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AcceptInviteRequest, $0.AcceptInviteResponse>(
            'AcceptInvite',
            acceptInvite_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AcceptInviteRequest.fromBuffer(value),
            ($0.AcceptInviteResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetMembershipRequest, $0.GetMembershipResponse>(
            'GetMembership',
            getMembership_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetMembershipRequest.fromBuffer(value),
            ($0.GetMembershipResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.PreviewInviteResponse> previewInvite_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PreviewInviteRequest> $request) async {
    return previewInvite($call, await $request);
  }

  $async.Future<$0.PreviewInviteResponse> previewInvite(
      $grpc.ServiceCall call, $0.PreviewInviteRequest request);

  $async.Future<$0.AcceptInviteResponse> acceptInvite_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AcceptInviteRequest> $request) async {
    return acceptInvite($call, await $request);
  }

  $async.Future<$0.AcceptInviteResponse> acceptInvite(
      $grpc.ServiceCall call, $0.AcceptInviteRequest request);

  $async.Future<$0.GetMembershipResponse> getMembership_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMembershipRequest> $request) async {
    return getMembership($call, await $request);
  }

  $async.Future<$0.GetMembershipResponse> getMembership(
      $grpc.ServiceCall call, $0.GetMembershipRequest request);
}
