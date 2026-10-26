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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'feed.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ParticipantFollowState extends $pb.GeneratedMessage {
  factory ParticipantFollowState({
    $core.String? principalId,
    $core.bool? following,
  }) {
    final result = ParticipantFollowState._();
    if (principalId != null) result.principalId = principalId;
    if (following != null) result.following = following;
    return result;
  }

  ParticipantFollowState._();

  factory ParticipantFollowState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParticipantFollowState()..mergeFromBuffer(data, registry);
  factory ParticipantFollowState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParticipantFollowState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParticipantFollowState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ParticipantFollowState.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOB(2, _omitFieldNames ? '' : 'following')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantFollowState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantFollowState copyWith(
          void Function(ParticipantFollowState) updates) =>
      super.copyWith((message) => updates(message as ParticipantFollowState))
          as ParticipantFollowState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ParticipantFollowState() / ParticipantFollowState.new instead')
  static ParticipantFollowState create() => ParticipantFollowState._();
  static $pb.GeneratedMessage $_createMessage() => ParticipantFollowState._();
  @$core.override
  ParticipantFollowState createEmptyInstance() => ParticipantFollowState._();
  @$core.pragma('dart2js:noInline')
  static ParticipantFollowState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantFollowState>(
          ParticipantFollowState.$_createMessage);
  static ParticipantFollowState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get principalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set principalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrincipalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrincipalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get following => $_getBF(1);
  @$pb.TagNumber(2)
  set following($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFollowing() => $_has(1);
  @$pb.TagNumber(2)
  void clearFollowing() => $_clearField(2);
}

class GetParticipantFollowStatesRequest extends $pb.GeneratedMessage {
  factory GetParticipantFollowStatesRequest({
    $core.String? channelId,
    $core.Iterable<$core.String>? principalIds,
  }) {
    final result = GetParticipantFollowStatesRequest._();
    if (channelId != null) result.channelId = channelId;
    if (principalIds != null) result.principalIds.addAll(principalIds);
    return result;
  }

  GetParticipantFollowStatesRequest._();

  factory GetParticipantFollowStatesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantFollowStatesRequest()..mergeFromBuffer(data, registry);
  factory GetParticipantFollowStatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantFollowStatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetParticipantFollowStatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetParticipantFollowStatesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..pPS(2, _omitFieldNames ? '' : 'principalIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantFollowStatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantFollowStatesRequest copyWith(
          void Function(GetParticipantFollowStatesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetParticipantFollowStatesRequest))
          as GetParticipantFollowStatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetParticipantFollowStatesRequest() / GetParticipantFollowStatesRequest.new instead')
  static GetParticipantFollowStatesRequest create() =>
      GetParticipantFollowStatesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetParticipantFollowStatesRequest._();
  @$core.override
  GetParticipantFollowStatesRequest createEmptyInstance() =>
      GetParticipantFollowStatesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetParticipantFollowStatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetParticipantFollowStatesRequest>(
          GetParticipantFollowStatesRequest.$_createMessage);
  static GetParticipantFollowStatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get principalIds => $_getList(1);
}

class GetParticipantFollowStatesResponse extends $pb.GeneratedMessage {
  factory GetParticipantFollowStatesResponse({
    $core.Iterable<ParticipantFollowState>? states,
    $fixnum.Int64? revision,
  }) {
    final result = GetParticipantFollowStatesResponse._();
    if (states != null) result.states.addAll(states);
    if (revision != null) result.revision = revision;
    return result;
  }

  GetParticipantFollowStatesResponse._();

  factory GetParticipantFollowStatesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantFollowStatesResponse()..mergeFromBuffer(data, registry);
  factory GetParticipantFollowStatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantFollowStatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetParticipantFollowStatesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetParticipantFollowStatesResponse.$_createMessage)
    ..pPM<ParticipantFollowState>(1, _omitFieldNames ? '' : 'states',
        subBuilder: ParticipantFollowState.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantFollowStatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantFollowStatesResponse copyWith(
          void Function(GetParticipantFollowStatesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetParticipantFollowStatesResponse))
          as GetParticipantFollowStatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetParticipantFollowStatesResponse() / GetParticipantFollowStatesResponse.new instead')
  static GetParticipantFollowStatesResponse create() =>
      GetParticipantFollowStatesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetParticipantFollowStatesResponse._();
  @$core.override
  GetParticipantFollowStatesResponse createEmptyInstance() =>
      GetParticipantFollowStatesResponse._();
  @$core.pragma('dart2js:noInline')
  static GetParticipantFollowStatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetParticipantFollowStatesResponse>(
          GetParticipantFollowStatesResponse.$_createMessage);
  static GetParticipantFollowStatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ParticipantFollowState> get states => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
}

class SetParticipantFollowRequest extends $pb.GeneratedMessage {
  factory SetParticipantFollowRequest({
    $core.String? channelId,
    $core.String? principalId,
    $core.bool? following,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = SetParticipantFollowRequest._();
    if (channelId != null) result.channelId = channelId;
    if (principalId != null) result.principalId = principalId;
    if (following != null) result.following = following;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  SetParticipantFollowRequest._();

  factory SetParticipantFollowRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetParticipantFollowRequest()..mergeFromBuffer(data, registry);
  factory SetParticipantFollowRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetParticipantFollowRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetParticipantFollowRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetParticipantFollowRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'principalId')
    ..aOB(3, _omitFieldNames ? '' : 'following')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParticipantFollowRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParticipantFollowRequest copyWith(
          void Function(SetParticipantFollowRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetParticipantFollowRequest))
          as SetParticipantFollowRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetParticipantFollowRequest() / SetParticipantFollowRequest.new instead')
  static SetParticipantFollowRequest create() =>
      SetParticipantFollowRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetParticipantFollowRequest._();
  @$core.override
  SetParticipantFollowRequest createEmptyInstance() =>
      SetParticipantFollowRequest._();
  @$core.pragma('dart2js:noInline')
  static SetParticipantFollowRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetParticipantFollowRequest>(
          SetParticipantFollowRequest.$_createMessage);
  static SetParticipantFollowRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get principalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set principalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrincipalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get following => $_getBF(2);
  @$pb.TagNumber(3)
  set following($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFollowing() => $_has(2);
  @$pb.TagNumber(3)
  void clearFollowing() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedRevision() => $_clearField(4);
}

class SetParticipantFollowResponse extends $pb.GeneratedMessage {
  factory SetParticipantFollowResponse({
    ParticipantFollowState? state,
    $fixnum.Int64? revision,
  }) {
    final result = SetParticipantFollowResponse._();
    if (state != null) result.state = state;
    if (revision != null) result.revision = revision;
    return result;
  }

  SetParticipantFollowResponse._();

  factory SetParticipantFollowResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetParticipantFollowResponse()..mergeFromBuffer(data, registry);
  factory SetParticipantFollowResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetParticipantFollowResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetParticipantFollowResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetParticipantFollowResponse.$_createMessage)
    ..aOM<ParticipantFollowState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: ParticipantFollowState.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParticipantFollowResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParticipantFollowResponse copyWith(
          void Function(SetParticipantFollowResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetParticipantFollowResponse))
          as SetParticipantFollowResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetParticipantFollowResponse() / SetParticipantFollowResponse.new instead')
  static SetParticipantFollowResponse create() =>
      SetParticipantFollowResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetParticipantFollowResponse._();
  @$core.override
  SetParticipantFollowResponse createEmptyInstance() =>
      SetParticipantFollowResponse._();
  @$core.pragma('dart2js:noInline')
  static SetParticipantFollowResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetParticipantFollowResponse>(
          SetParticipantFollowResponse.$_createMessage);
  static SetParticipantFollowResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ParticipantFollowState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(ParticipantFollowState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  ParticipantFollowState ensureState() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
}

class ListFollowingParticipantsRequest extends $pb.GeneratedMessage {
  factory ListFollowingParticipantsRequest({
    $core.String? pageToken,
    $core.int? limit,
  }) {
    final result = ListFollowingParticipantsRequest._();
    if (pageToken != null) result.pageToken = pageToken;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListFollowingParticipantsRequest._();

  factory ListFollowingParticipantsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFollowingParticipantsRequest()..mergeFromBuffer(data, registry);
  factory ListFollowingParticipantsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFollowingParticipantsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFollowingParticipantsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFollowingParticipantsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pageToken')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowingParticipantsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowingParticipantsRequest copyWith(
          void Function(ListFollowingParticipantsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListFollowingParticipantsRequest))
          as ListFollowingParticipantsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFollowingParticipantsRequest() / ListFollowingParticipantsRequest.new instead')
  static ListFollowingParticipantsRequest create() =>
      ListFollowingParticipantsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListFollowingParticipantsRequest._();
  @$core.override
  ListFollowingParticipantsRequest createEmptyInstance() =>
      ListFollowingParticipantsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListFollowingParticipantsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFollowingParticipantsRequest>(
          ListFollowingParticipantsRequest.$_createMessage);
  static ListFollowingParticipantsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pageToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set pageToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class FollowingParticipant extends $pb.GeneratedMessage {
  factory FollowingParticipant({
    $core.String? principalId,
    $core.String? displayName,
    $core.bool? available,
  }) {
    final result = FollowingParticipant._();
    if (principalId != null) result.principalId = principalId;
    if (displayName != null) result.displayName = displayName;
    if (available != null) result.available = available;
    return result;
  }

  FollowingParticipant._();

  factory FollowingParticipant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowingParticipant()..mergeFromBuffer(data, registry);
  factory FollowingParticipant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowingParticipant()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowingParticipant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: FollowingParticipant.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOB(3, _omitFieldNames ? '' : 'available')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowingParticipant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowingParticipant copyWith(void Function(FollowingParticipant) updates) =>
      super.copyWith((message) => updates(message as FollowingParticipant))
          as FollowingParticipant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowingParticipant() / FollowingParticipant.new instead')
  static FollowingParticipant create() => FollowingParticipant._();
  static $pb.GeneratedMessage $_createMessage() => FollowingParticipant._();
  @$core.override
  FollowingParticipant createEmptyInstance() => FollowingParticipant._();
  @$core.pragma('dart2js:noInline')
  static FollowingParticipant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowingParticipant>(
          FollowingParticipant.$_createMessage);
  static FollowingParticipant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get principalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set principalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrincipalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrincipalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get available => $_getBF(2);
  @$pb.TagNumber(3)
  set available($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailable() => $_clearField(3);
}

class ListFollowingParticipantsResponse extends $pb.GeneratedMessage {
  factory ListFollowingParticipantsResponse({
    $core.Iterable<FollowingParticipant>? participants,
    $core.String? nextPageToken,
    $fixnum.Int64? revision,
  }) {
    final result = ListFollowingParticipantsResponse._();
    if (participants != null) result.participants.addAll(participants);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (revision != null) result.revision = revision;
    return result;
  }

  ListFollowingParticipantsResponse._();

  factory ListFollowingParticipantsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFollowingParticipantsResponse()..mergeFromBuffer(data, registry);
  factory ListFollowingParticipantsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFollowingParticipantsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFollowingParticipantsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFollowingParticipantsResponse.$_createMessage)
    ..pPM<FollowingParticipant>(1, _omitFieldNames ? '' : 'participants',
        subBuilder: FollowingParticipant.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aInt64(3, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowingParticipantsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowingParticipantsResponse copyWith(
          void Function(ListFollowingParticipantsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListFollowingParticipantsResponse))
          as ListFollowingParticipantsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFollowingParticipantsResponse() / ListFollowingParticipantsResponse.new instead')
  static ListFollowingParticipantsResponse create() =>
      ListFollowingParticipantsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListFollowingParticipantsResponse._();
  @$core.override
  ListFollowingParticipantsResponse createEmptyInstance() =>
      ListFollowingParticipantsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListFollowingParticipantsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFollowingParticipantsResponse>(
          ListFollowingParticipantsResponse.$_createMessage);
  static ListFollowingParticipantsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FollowingParticipant> get participants => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get revision => $_getI64(2);
  @$pb.TagNumber(3)
  set revision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);
}

class ListPersonalFeedRequest extends $pb.GeneratedMessage {
  factory ListPersonalFeedRequest({
    $core.String? pageToken,
    $core.int? limit,
  }) {
    final result = ListPersonalFeedRequest._();
    if (pageToken != null) result.pageToken = pageToken;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListPersonalFeedRequest._();

  factory ListPersonalFeedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalFeedRequest()..mergeFromBuffer(data, registry);
  factory ListPersonalFeedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalFeedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPersonalFeedRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListPersonalFeedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pageToken')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalFeedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalFeedRequest copyWith(
          void Function(ListPersonalFeedRequest) updates) =>
      super.copyWith((message) => updates(message as ListPersonalFeedRequest))
          as ListPersonalFeedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPersonalFeedRequest() / ListPersonalFeedRequest.new instead')
  static ListPersonalFeedRequest create() => ListPersonalFeedRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPersonalFeedRequest._();
  @$core.override
  ListPersonalFeedRequest createEmptyInstance() => ListPersonalFeedRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPersonalFeedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPersonalFeedRequest>(
          ListPersonalFeedRequest.$_createMessage);
  static ListPersonalFeedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pageToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set pageToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class PersonalFeedEntry extends $pb.GeneratedMessage {
  factory PersonalFeedEntry({
    $core.String? channelTitle,
    $0.FeedPost? post,
  }) {
    final result = PersonalFeedEntry._();
    if (channelTitle != null) result.channelTitle = channelTitle;
    if (post != null) result.post = post;
    return result;
  }

  PersonalFeedEntry._();

  factory PersonalFeedEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PersonalFeedEntry()..mergeFromBuffer(data, registry);
  factory PersonalFeedEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PersonalFeedEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PersonalFeedEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PersonalFeedEntry.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelTitle')
    ..aOM<$0.FeedPost>(2, _omitFieldNames ? '' : 'post',
        subBuilder: $0.FeedPost.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PersonalFeedEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PersonalFeedEntry copyWith(void Function(PersonalFeedEntry) updates) =>
      super.copyWith((message) => updates(message as PersonalFeedEntry))
          as PersonalFeedEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PersonalFeedEntry() / PersonalFeedEntry.new instead')
  static PersonalFeedEntry create() => PersonalFeedEntry._();
  static $pb.GeneratedMessage $_createMessage() => PersonalFeedEntry._();
  @$core.override
  PersonalFeedEntry createEmptyInstance() => PersonalFeedEntry._();
  @$core.pragma('dart2js:noInline')
  static PersonalFeedEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PersonalFeedEntry>(
          PersonalFeedEntry.$_createMessage);
  static PersonalFeedEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelTitle => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelTitle($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.FeedPost get post => $_getN(1);
  @$pb.TagNumber(2)
  set post($0.FeedPost value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPost() => $_has(1);
  @$pb.TagNumber(2)
  void clearPost() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.FeedPost ensurePost() => $_ensure(1);
}

class ListPersonalFeedResponse extends $pb.GeneratedMessage {
  factory ListPersonalFeedResponse({
    $core.Iterable<PersonalFeedEntry>? entries,
    $core.String? nextPageToken,
    $fixnum.Int64? revision,
  }) {
    final result = ListPersonalFeedResponse._();
    if (entries != null) result.entries.addAll(entries);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (revision != null) result.revision = revision;
    return result;
  }

  ListPersonalFeedResponse._();

  factory ListPersonalFeedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalFeedResponse()..mergeFromBuffer(data, registry);
  factory ListPersonalFeedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalFeedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPersonalFeedResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListPersonalFeedResponse.$_createMessage)
    ..pPM<PersonalFeedEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: PersonalFeedEntry.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aInt64(3, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalFeedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalFeedResponse copyWith(
          void Function(ListPersonalFeedResponse) updates) =>
      super.copyWith((message) => updates(message as ListPersonalFeedResponse))
          as ListPersonalFeedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPersonalFeedResponse() / ListPersonalFeedResponse.new instead')
  static ListPersonalFeedResponse create() => ListPersonalFeedResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPersonalFeedResponse._();
  @$core.override
  ListPersonalFeedResponse createEmptyInstance() =>
      ListPersonalFeedResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPersonalFeedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPersonalFeedResponse>(
          ListPersonalFeedResponse.$_createMessage);
  static ListPersonalFeedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PersonalFeedEntry> get entries => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get revision => $_getI64(2);
  @$pb.TagNumber(3)
  set revision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);
}

/// core.participant.follows.v1: личные подписки и лента внутри пространства.
class ParticipantFollowServiceApi {
  final $pb.RpcClient _client;

  ParticipantFollowServiceApi(this._client);

  $async.Future<GetParticipantFollowStatesResponse> getParticipantFollowStates(
          $pb.ClientContext? ctx, GetParticipantFollowStatesRequest request) =>
      _client.invoke<GetParticipantFollowStatesResponse>(
          ctx,
          'ParticipantFollowService',
          'GetParticipantFollowStates',
          request,
          GetParticipantFollowStatesResponse());
  $async.Future<SetParticipantFollowResponse> setParticipantFollow(
          $pb.ClientContext? ctx, SetParticipantFollowRequest request) =>
      _client.invoke<SetParticipantFollowResponse>(
          ctx,
          'ParticipantFollowService',
          'SetParticipantFollow',
          request,
          SetParticipantFollowResponse());
  $async.Future<ListFollowingParticipantsResponse> listFollowingParticipants(
          $pb.ClientContext? ctx, ListFollowingParticipantsRequest request) =>
      _client.invoke<ListFollowingParticipantsResponse>(
          ctx,
          'ParticipantFollowService',
          'ListFollowingParticipants',
          request,
          ListFollowingParticipantsResponse());
  $async.Future<ListPersonalFeedResponse> listPersonalFeed(
          $pb.ClientContext? ctx, ListPersonalFeedRequest request) =>
      _client.invoke<ListPersonalFeedResponse>(ctx, 'ParticipantFollowService',
          'ListPersonalFeed', request, ListPersonalFeedResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
