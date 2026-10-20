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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class VoiceParticipant extends $pb.GeneratedMessage {
  factory VoiceParticipant({
    $core.String? sessionId,
    $core.String? principalId,
    $core.String? deviceId,
    $core.String? nickname,
    $core.bool? muted,
    $core.bool? deafened,
    $core.int? audioSlot,
  }) {
    final result = VoiceParticipant._();
    if (sessionId != null) result.sessionId = sessionId;
    if (principalId != null) result.principalId = principalId;
    if (deviceId != null) result.deviceId = deviceId;
    if (nickname != null) result.nickname = nickname;
    if (muted != null) result.muted = muted;
    if (deafened != null) result.deafened = deafened;
    if (audioSlot != null) result.audioSlot = audioSlot;
    return result;
  }

  VoiceParticipant._();

  factory VoiceParticipant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceParticipant()..mergeFromBuffer(data, registry);
  factory VoiceParticipant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceParticipant()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceParticipant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: VoiceParticipant.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'principalId')
    ..aOS(3, _omitFieldNames ? '' : 'deviceId')
    ..aOS(4, _omitFieldNames ? '' : 'nickname')
    ..aOB(5, _omitFieldNames ? '' : 'muted')
    ..aOB(6, _omitFieldNames ? '' : 'deafened')
    ..aI(7, _omitFieldNames ? '' : 'audioSlot', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceParticipant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceParticipant copyWith(void Function(VoiceParticipant) updates) =>
      super.copyWith((message) => updates(message as VoiceParticipant))
          as VoiceParticipant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoiceParticipant() / VoiceParticipant.new instead')
  static VoiceParticipant create() => VoiceParticipant._();
  static $pb.GeneratedMessage $_createMessage() => VoiceParticipant._();
  @$core.override
  VoiceParticipant createEmptyInstance() => VoiceParticipant._();
  @$core.pragma('dart2js:noInline')
  static VoiceParticipant getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoiceParticipant>(
          VoiceParticipant.$_createMessage);
  static VoiceParticipant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get principalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set principalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrincipalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nickname => $_getSZ(3);
  @$pb.TagNumber(4)
  set nickname($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNickname() => $_has(3);
  @$pb.TagNumber(4)
  void clearNickname() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get muted => $_getBF(4);
  @$pb.TagNumber(5)
  set muted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMuted() => $_has(4);
  @$pb.TagNumber(5)
  void clearMuted() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get deafened => $_getBF(5);
  @$pb.TagNumber(6)
  set deafened($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeafened() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeafened() => $_clearField(6);

  /// Стабильное место участника в комнате (0..7), не состояние микрофона.
  @$pb.TagNumber(7)
  $core.int get audioSlot => $_getIZ(6);
  @$pb.TagNumber(7)
  set audioSlot($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAudioSlot() => $_has(6);
  @$pb.TagNumber(7)
  void clearAudioSlot() => $_clearField(7);
}

class VoiceRoomState extends $pb.GeneratedMessage {
  factory VoiceRoomState({
    $core.Iterable<VoiceParticipant>? participants,
    $core.bool? canPublish,
    $core.int? capacity,
  }) {
    final result = VoiceRoomState._();
    if (participants != null) result.participants.addAll(participants);
    if (canPublish != null) result.canPublish = canPublish;
    if (capacity != null) result.capacity = capacity;
    return result;
  }

  VoiceRoomState._();

  factory VoiceRoomState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceRoomState()..mergeFromBuffer(data, registry);
  factory VoiceRoomState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceRoomState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceRoomState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: VoiceRoomState.$_createMessage)
    ..pPM<VoiceParticipant>(1, _omitFieldNames ? '' : 'participants',
        subBuilder: VoiceParticipant.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'canPublish')
    ..aI(3, _omitFieldNames ? '' : 'capacity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceRoomState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceRoomState copyWith(void Function(VoiceRoomState) updates) =>
      super.copyWith((message) => updates(message as VoiceRoomState))
          as VoiceRoomState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoiceRoomState() / VoiceRoomState.new instead')
  static VoiceRoomState create() => VoiceRoomState._();
  static $pb.GeneratedMessage $_createMessage() => VoiceRoomState._();
  @$core.override
  VoiceRoomState createEmptyInstance() => VoiceRoomState._();
  @$core.pragma('dart2js:noInline')
  static VoiceRoomState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoiceRoomState>(
          VoiceRoomState.$_createMessage);
  static VoiceRoomState? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VoiceParticipant> get participants => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get canPublish => $_getBF(1);
  @$pb.TagNumber(2)
  set canPublish($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCanPublish() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanPublish() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get capacity => $_getIZ(2);
  @$pb.TagNumber(3)
  set capacity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCapacity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCapacity() => $_clearField(3);
}

class JoinVoiceRoomRequest extends $pb.GeneratedMessage {
  factory JoinVoiceRoomRequest({
    $core.String? channelId,
    $core.String? offerSdp,
  }) {
    final result = JoinVoiceRoomRequest._();
    if (channelId != null) result.channelId = channelId;
    if (offerSdp != null) result.offerSdp = offerSdp;
    return result;
  }

  JoinVoiceRoomRequest._();

  factory JoinVoiceRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinVoiceRoomRequest()..mergeFromBuffer(data, registry);
  factory JoinVoiceRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinVoiceRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinVoiceRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: JoinVoiceRoomRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'offerSdp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinVoiceRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinVoiceRoomRequest copyWith(void Function(JoinVoiceRoomRequest) updates) =>
      super.copyWith((message) => updates(message as JoinVoiceRoomRequest))
          as JoinVoiceRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use JoinVoiceRoomRequest() / JoinVoiceRoomRequest.new instead')
  static JoinVoiceRoomRequest create() => JoinVoiceRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => JoinVoiceRoomRequest._();
  @$core.override
  JoinVoiceRoomRequest createEmptyInstance() => JoinVoiceRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static JoinVoiceRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinVoiceRoomRequest>(
          JoinVoiceRoomRequest.$_createMessage);
  static JoinVoiceRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerSdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerSdp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferSdp() => $_clearField(2);
}

class JoinVoiceRoomResponse extends $pb.GeneratedMessage {
  factory JoinVoiceRoomResponse({
    $core.String? sessionId,
    $core.String? answerSdp,
    VoiceRoomState? state,
  }) {
    final result = JoinVoiceRoomResponse._();
    if (sessionId != null) result.sessionId = sessionId;
    if (answerSdp != null) result.answerSdp = answerSdp;
    if (state != null) result.state = state;
    return result;
  }

  JoinVoiceRoomResponse._();

  factory JoinVoiceRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinVoiceRoomResponse()..mergeFromBuffer(data, registry);
  factory JoinVoiceRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      JoinVoiceRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinVoiceRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: JoinVoiceRoomResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'answerSdp')
    ..aOM<VoiceRoomState>(3, _omitFieldNames ? '' : 'state',
        subBuilder: VoiceRoomState.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinVoiceRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinVoiceRoomResponse copyWith(
          void Function(JoinVoiceRoomResponse) updates) =>
      super.copyWith((message) => updates(message as JoinVoiceRoomResponse))
          as JoinVoiceRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use JoinVoiceRoomResponse() / JoinVoiceRoomResponse.new instead')
  static JoinVoiceRoomResponse create() => JoinVoiceRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => JoinVoiceRoomResponse._();
  @$core.override
  JoinVoiceRoomResponse createEmptyInstance() => JoinVoiceRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static JoinVoiceRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinVoiceRoomResponse>(
          JoinVoiceRoomResponse.$_createMessage);
  static JoinVoiceRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get answerSdp => $_getSZ(1);
  @$pb.TagNumber(2)
  set answerSdp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAnswerSdp() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnswerSdp() => $_clearField(2);

  @$pb.TagNumber(3)
  VoiceRoomState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(VoiceRoomState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);
  @$pb.TagNumber(3)
  VoiceRoomState ensureState() => $_ensure(2);
}

class UpdateVoiceRoomRequest extends $pb.GeneratedMessage {
  factory UpdateVoiceRoomRequest({
    $core.String? channelId,
    $core.String? sessionId,
    $core.bool? muted,
    $core.bool? deafened,
  }) {
    final result = UpdateVoiceRoomRequest._();
    if (channelId != null) result.channelId = channelId;
    if (sessionId != null) result.sessionId = sessionId;
    if (muted != null) result.muted = muted;
    if (deafened != null) result.deafened = deafened;
    return result;
  }

  UpdateVoiceRoomRequest._();

  factory UpdateVoiceRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateVoiceRoomRequest()..mergeFromBuffer(data, registry);
  factory UpdateVoiceRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateVoiceRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateVoiceRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateVoiceRoomRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOB(3, _omitFieldNames ? '' : 'muted')
    ..aOB(4, _omitFieldNames ? '' : 'deafened')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateVoiceRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateVoiceRoomRequest copyWith(
          void Function(UpdateVoiceRoomRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateVoiceRoomRequest))
          as UpdateVoiceRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateVoiceRoomRequest() / UpdateVoiceRoomRequest.new instead')
  static UpdateVoiceRoomRequest create() => UpdateVoiceRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateVoiceRoomRequest._();
  @$core.override
  UpdateVoiceRoomRequest createEmptyInstance() => UpdateVoiceRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateVoiceRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateVoiceRoomRequest>(
          UpdateVoiceRoomRequest.$_createMessage);
  static UpdateVoiceRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get muted => $_getBF(2);
  @$pb.TagNumber(3)
  set muted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMuted() => $_has(2);
  @$pb.TagNumber(3)
  void clearMuted() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get deafened => $_getBF(3);
  @$pb.TagNumber(4)
  set deafened($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeafened() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeafened() => $_clearField(4);
}

class UpdateVoiceRoomResponse extends $pb.GeneratedMessage {
  factory UpdateVoiceRoomResponse({
    VoiceRoomState? state,
  }) {
    final result = UpdateVoiceRoomResponse._();
    if (state != null) result.state = state;
    return result;
  }

  UpdateVoiceRoomResponse._();

  factory UpdateVoiceRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateVoiceRoomResponse()..mergeFromBuffer(data, registry);
  factory UpdateVoiceRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateVoiceRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateVoiceRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateVoiceRoomResponse.$_createMessage)
    ..aOM<VoiceRoomState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: VoiceRoomState.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateVoiceRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateVoiceRoomResponse copyWith(
          void Function(UpdateVoiceRoomResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateVoiceRoomResponse))
          as UpdateVoiceRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateVoiceRoomResponse() / UpdateVoiceRoomResponse.new instead')
  static UpdateVoiceRoomResponse create() => UpdateVoiceRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateVoiceRoomResponse._();
  @$core.override
  UpdateVoiceRoomResponse createEmptyInstance() => UpdateVoiceRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateVoiceRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateVoiceRoomResponse>(
          UpdateVoiceRoomResponse.$_createMessage);
  static UpdateVoiceRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VoiceRoomState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(VoiceRoomState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  VoiceRoomState ensureState() => $_ensure(0);
}

class LeaveVoiceRoomRequest extends $pb.GeneratedMessage {
  factory LeaveVoiceRoomRequest({
    $core.String? channelId,
    $core.String? sessionId,
  }) {
    final result = LeaveVoiceRoomRequest._();
    if (channelId != null) result.channelId = channelId;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  LeaveVoiceRoomRequest._();

  factory LeaveVoiceRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveVoiceRoomRequest()..mergeFromBuffer(data, registry);
  factory LeaveVoiceRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveVoiceRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveVoiceRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: LeaveVoiceRoomRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveVoiceRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveVoiceRoomRequest copyWith(
          void Function(LeaveVoiceRoomRequest) updates) =>
      super.copyWith((message) => updates(message as LeaveVoiceRoomRequest))
          as LeaveVoiceRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LeaveVoiceRoomRequest() / LeaveVoiceRoomRequest.new instead')
  static LeaveVoiceRoomRequest create() => LeaveVoiceRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => LeaveVoiceRoomRequest._();
  @$core.override
  LeaveVoiceRoomRequest createEmptyInstance() => LeaveVoiceRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static LeaveVoiceRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveVoiceRoomRequest>(
          LeaveVoiceRoomRequest.$_createMessage);
  static LeaveVoiceRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class LeaveVoiceRoomResponse extends $pb.GeneratedMessage {
  factory LeaveVoiceRoomResponse() => LeaveVoiceRoomResponse._();

  LeaveVoiceRoomResponse._();

  factory LeaveVoiceRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveVoiceRoomResponse()..mergeFromBuffer(data, registry);
  factory LeaveVoiceRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaveVoiceRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveVoiceRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: LeaveVoiceRoomResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveVoiceRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveVoiceRoomResponse copyWith(
          void Function(LeaveVoiceRoomResponse) updates) =>
      super.copyWith((message) => updates(message as LeaveVoiceRoomResponse))
          as LeaveVoiceRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LeaveVoiceRoomResponse() / LeaveVoiceRoomResponse.new instead')
  static LeaveVoiceRoomResponse create() => LeaveVoiceRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => LeaveVoiceRoomResponse._();
  @$core.override
  LeaveVoiceRoomResponse createEmptyInstance() => LeaveVoiceRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static LeaveVoiceRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveVoiceRoomResponse>(
          LeaveVoiceRoomResponse.$_createMessage);
  static LeaveVoiceRoomResponse? _defaultInstance;
}

class GetVoiceRoomRequest extends $pb.GeneratedMessage {
  factory GetVoiceRoomRequest({
    $core.String? channelId,
  }) {
    final result = GetVoiceRoomRequest._();
    if (channelId != null) result.channelId = channelId;
    return result;
  }

  GetVoiceRoomRequest._();

  factory GetVoiceRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceRoomRequest()..mergeFromBuffer(data, registry);
  factory GetVoiceRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceRoomRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVoiceRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetVoiceRoomRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceRoomRequest copyWith(void Function(GetVoiceRoomRequest) updates) =>
      super.copyWith((message) => updates(message as GetVoiceRoomRequest))
          as GetVoiceRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetVoiceRoomRequest() / GetVoiceRoomRequest.new instead')
  static GetVoiceRoomRequest create() => GetVoiceRoomRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetVoiceRoomRequest._();
  @$core.override
  GetVoiceRoomRequest createEmptyInstance() => GetVoiceRoomRequest._();
  @$core.pragma('dart2js:noInline')
  static GetVoiceRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVoiceRoomRequest>(
          GetVoiceRoomRequest.$_createMessage);
  static GetVoiceRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);
}

class GetVoiceRoomResponse extends $pb.GeneratedMessage {
  factory GetVoiceRoomResponse({
    VoiceRoomState? state,
  }) {
    final result = GetVoiceRoomResponse._();
    if (state != null) result.state = state;
    return result;
  }

  GetVoiceRoomResponse._();

  factory GetVoiceRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceRoomResponse()..mergeFromBuffer(data, registry);
  factory GetVoiceRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceRoomResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVoiceRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetVoiceRoomResponse.$_createMessage)
    ..aOM<VoiceRoomState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: VoiceRoomState.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceRoomResponse copyWith(void Function(GetVoiceRoomResponse) updates) =>
      super.copyWith((message) => updates(message as GetVoiceRoomResponse))
          as GetVoiceRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetVoiceRoomResponse() / GetVoiceRoomResponse.new instead')
  static GetVoiceRoomResponse create() => GetVoiceRoomResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetVoiceRoomResponse._();
  @$core.override
  GetVoiceRoomResponse createEmptyInstance() => GetVoiceRoomResponse._();
  @$core.pragma('dart2js:noInline')
  static GetVoiceRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVoiceRoomResponse>(
          GetVoiceRoomResponse.$_createMessage);
  static GetVoiceRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VoiceRoomState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(VoiceRoomState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  VoiceRoomState ensureState() => $_ensure(0);
}

/// Выдаётся только после проверки доступа к комнате. Общий TURN-секрет
/// остаётся на runtime; клиент получает временный пароль без идентификатора личности.
class VoiceIceServer extends $pb.GeneratedMessage {
  factory VoiceIceServer({
    $core.Iterable<$core.String>? urls,
    $core.String? username,
    $core.String? credential,
  }) {
    final result = VoiceIceServer._();
    if (urls != null) result.urls.addAll(urls);
    if (username != null) result.username = username;
    if (credential != null) result.credential = credential;
    return result;
  }

  VoiceIceServer._();

  factory VoiceIceServer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceIceServer()..mergeFromBuffer(data, registry);
  factory VoiceIceServer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceIceServer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceIceServer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: VoiceIceServer.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'urls')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'credential')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceIceServer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceIceServer copyWith(void Function(VoiceIceServer) updates) =>
      super.copyWith((message) => updates(message as VoiceIceServer))
          as VoiceIceServer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoiceIceServer() / VoiceIceServer.new instead')
  static VoiceIceServer create() => VoiceIceServer._();
  static $pb.GeneratedMessage $_createMessage() => VoiceIceServer._();
  @$core.override
  VoiceIceServer createEmptyInstance() => VoiceIceServer._();
  @$core.pragma('dart2js:noInline')
  static VoiceIceServer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoiceIceServer>(
          VoiceIceServer.$_createMessage);
  static VoiceIceServer? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get urls => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get credential => $_getSZ(2);
  @$pb.TagNumber(3)
  set credential($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCredential() => $_has(2);
  @$pb.TagNumber(3)
  void clearCredential() => $_clearField(3);
}

class GetVoiceConfigurationRequest extends $pb.GeneratedMessage {
  factory GetVoiceConfigurationRequest({
    $core.String? channelId,
  }) {
    final result = GetVoiceConfigurationRequest._();
    if (channelId != null) result.channelId = channelId;
    return result;
  }

  GetVoiceConfigurationRequest._();

  factory GetVoiceConfigurationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceConfigurationRequest()..mergeFromBuffer(data, registry);
  factory GetVoiceConfigurationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceConfigurationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVoiceConfigurationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetVoiceConfigurationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceConfigurationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceConfigurationRequest copyWith(
          void Function(GetVoiceConfigurationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetVoiceConfigurationRequest))
          as GetVoiceConfigurationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetVoiceConfigurationRequest() / GetVoiceConfigurationRequest.new instead')
  static GetVoiceConfigurationRequest create() =>
      GetVoiceConfigurationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetVoiceConfigurationRequest._();
  @$core.override
  GetVoiceConfigurationRequest createEmptyInstance() =>
      GetVoiceConfigurationRequest._();
  @$core.pragma('dart2js:noInline')
  static GetVoiceConfigurationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVoiceConfigurationRequest>(
          GetVoiceConfigurationRequest.$_createMessage);
  static GetVoiceConfigurationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);
}

class GetVoiceConfigurationResponse extends $pb.GeneratedMessage {
  factory GetVoiceConfigurationResponse({
    $core.Iterable<VoiceIceServer>? iceServers,
    $core.bool? relayOnly,
    $fixnum.Int64? expiresAtUnix,
  }) {
    final result = GetVoiceConfigurationResponse._();
    if (iceServers != null) result.iceServers.addAll(iceServers);
    if (relayOnly != null) result.relayOnly = relayOnly;
    if (expiresAtUnix != null) result.expiresAtUnix = expiresAtUnix;
    return result;
  }

  GetVoiceConfigurationResponse._();

  factory GetVoiceConfigurationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceConfigurationResponse()..mergeFromBuffer(data, registry);
  factory GetVoiceConfigurationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetVoiceConfigurationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVoiceConfigurationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetVoiceConfigurationResponse.$_createMessage)
    ..pPM<VoiceIceServer>(1, _omitFieldNames ? '' : 'iceServers',
        subBuilder: VoiceIceServer.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'relayOnly')
    ..aInt64(3, _omitFieldNames ? '' : 'expiresAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceConfigurationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVoiceConfigurationResponse copyWith(
          void Function(GetVoiceConfigurationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetVoiceConfigurationResponse))
          as GetVoiceConfigurationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetVoiceConfigurationResponse() / GetVoiceConfigurationResponse.new instead')
  static GetVoiceConfigurationResponse create() =>
      GetVoiceConfigurationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetVoiceConfigurationResponse._();
  @$core.override
  GetVoiceConfigurationResponse createEmptyInstance() =>
      GetVoiceConfigurationResponse._();
  @$core.pragma('dart2js:noInline')
  static GetVoiceConfigurationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVoiceConfigurationResponse>(
          GetVoiceConfigurationResponse.$_createMessage);
  static GetVoiceConfigurationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VoiceIceServer> get iceServers => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get relayOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set relayOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRelayOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearRelayOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresAtUnix => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresAtUnix($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAtUnix() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAtUnix() => $_clearField(3);
}

/// Голос передаётся WebRTC, через RPC проходит только управление и SDP.
class VoiceServiceApi {
  final $pb.RpcClient _client;

  VoiceServiceApi(this._client);

  $async.Future<GetVoiceConfigurationResponse> getVoiceConfiguration(
          $pb.ClientContext? ctx, GetVoiceConfigurationRequest request) =>
      _client.invoke<GetVoiceConfigurationResponse>(ctx, 'VoiceService',
          'GetVoiceConfiguration', request, GetVoiceConfigurationResponse());
  $async.Future<JoinVoiceRoomResponse> joinVoiceRoom(
          $pb.ClientContext? ctx, JoinVoiceRoomRequest request) =>
      _client.invoke<JoinVoiceRoomResponse>(ctx, 'VoiceService',
          'JoinVoiceRoom', request, JoinVoiceRoomResponse());
  $async.Future<UpdateVoiceRoomResponse> updateVoiceRoom(
          $pb.ClientContext? ctx, UpdateVoiceRoomRequest request) =>
      _client.invoke<UpdateVoiceRoomResponse>(ctx, 'VoiceService',
          'UpdateVoiceRoom', request, UpdateVoiceRoomResponse());
  $async.Future<LeaveVoiceRoomResponse> leaveVoiceRoom(
          $pb.ClientContext? ctx, LeaveVoiceRoomRequest request) =>
      _client.invoke<LeaveVoiceRoomResponse>(ctx, 'VoiceService',
          'LeaveVoiceRoom', request, LeaveVoiceRoomResponse());
  $async.Future<GetVoiceRoomResponse> getVoiceRoom(
          $pb.ClientContext? ctx, GetVoiceRoomRequest request) =>
      _client.invoke<GetVoiceRoomResponse>(
          ctx, 'VoiceService', 'GetVoiceRoom', request, GetVoiceRoomResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
