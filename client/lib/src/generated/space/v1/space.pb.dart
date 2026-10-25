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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'community_mentions.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest() => LogoutRequest._();

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: LogoutRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LogoutRequest() / LogoutRequest.new instead')
  static LogoutRequest create() => LogoutRequest._();
  static $pb.GeneratedMessage $_createMessage() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => LogoutRequest._();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(
          LogoutRequest.$_createMessage);
  static LogoutRequest? _defaultInstance;
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse() => LogoutResponse._();

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: LogoutResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LogoutResponse() / LogoutResponse.new instead')
  static LogoutResponse create() => LogoutResponse._();
  static $pb.GeneratedMessage $_createMessage() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => LogoutResponse._();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(
          LogoutResponse.$_createMessage);
  static LogoutResponse? _defaultInstance;
}

class ListDevicesRequest extends $pb.GeneratedMessage {
  factory ListDevicesRequest() => ListDevicesRequest._();

  ListDevicesRequest._();

  factory ListDevicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDevicesRequest()..mergeFromBuffer(data, registry);
  factory ListDevicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDevicesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDevicesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListDevicesRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesRequest copyWith(void Function(ListDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListDevicesRequest))
          as ListDevicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListDevicesRequest() / ListDevicesRequest.new instead')
  static ListDevicesRequest create() => ListDevicesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListDevicesRequest._();
  @$core.override
  ListDevicesRequest createEmptyInstance() => ListDevicesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDevicesRequest>(
          ListDevicesRequest.$_createMessage);
  static ListDevicesRequest? _defaultInstance;
}

class RevokeCurrentDeviceRequest extends $pb.GeneratedMessage {
  factory RevokeCurrentDeviceRequest() => RevokeCurrentDeviceRequest._();

  RevokeCurrentDeviceRequest._();

  factory RevokeCurrentDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeCurrentDeviceRequest()..mergeFromBuffer(data, registry);
  factory RevokeCurrentDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeCurrentDeviceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeCurrentDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeCurrentDeviceRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeCurrentDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeCurrentDeviceRequest copyWith(
          void Function(RevokeCurrentDeviceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RevokeCurrentDeviceRequest))
          as RevokeCurrentDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RevokeCurrentDeviceRequest() / RevokeCurrentDeviceRequest.new instead')
  static RevokeCurrentDeviceRequest create() => RevokeCurrentDeviceRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RevokeCurrentDeviceRequest._();
  @$core.override
  RevokeCurrentDeviceRequest createEmptyInstance() =>
      RevokeCurrentDeviceRequest._();
  @$core.pragma('dart2js:noInline')
  static RevokeCurrentDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeCurrentDeviceRequest>(
          RevokeCurrentDeviceRequest.$_createMessage);
  static RevokeCurrentDeviceRequest? _defaultInstance;
}

class RevokeCurrentDeviceResponse extends $pb.GeneratedMessage {
  factory RevokeCurrentDeviceResponse() => RevokeCurrentDeviceResponse._();

  RevokeCurrentDeviceResponse._();

  factory RevokeCurrentDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeCurrentDeviceResponse()..mergeFromBuffer(data, registry);
  factory RevokeCurrentDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeCurrentDeviceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeCurrentDeviceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeCurrentDeviceResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeCurrentDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeCurrentDeviceResponse copyWith(
          void Function(RevokeCurrentDeviceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RevokeCurrentDeviceResponse))
          as RevokeCurrentDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RevokeCurrentDeviceResponse() / RevokeCurrentDeviceResponse.new instead')
  static RevokeCurrentDeviceResponse create() =>
      RevokeCurrentDeviceResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RevokeCurrentDeviceResponse._();
  @$core.override
  RevokeCurrentDeviceResponse createEmptyInstance() =>
      RevokeCurrentDeviceResponse._();
  @$core.pragma('dart2js:noInline')
  static RevokeCurrentDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeCurrentDeviceResponse>(
          RevokeCurrentDeviceResponse.$_createMessage);
  static RevokeCurrentDeviceResponse? _defaultInstance;
}

class DeviceGrant extends $pb.GeneratedMessage {
  factory DeviceGrant({
    $core.String? id,
    $core.List<$core.int>? publicKey,
    $core.Iterable<$core.String>? scopes,
    $fixnum.Int64? expiresAt,
    $core.bool? revoked,
    $core.String? parentGrantId,
    $core.bool? recovery,
    $fixnum.Int64? authEpoch,
    $core.String? signatureKind,
    $core.List<$core.int>? registrationTranscript,
    $core.List<$core.int>? signature,
    $core.List<$core.int>? parentTranscript,
    $core.List<$core.int>? parentSignature,
    RetentionProof? retentionProof,
    $core.bool? retainable,
  }) {
    final result = DeviceGrant._();
    if (id != null) result.id = id;
    if (publicKey != null) result.publicKey = publicKey;
    if (scopes != null) result.scopes.addAll(scopes);
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (revoked != null) result.revoked = revoked;
    if (parentGrantId != null) result.parentGrantId = parentGrantId;
    if (recovery != null) result.recovery = recovery;
    if (authEpoch != null) result.authEpoch = authEpoch;
    if (signatureKind != null) result.signatureKind = signatureKind;
    if (registrationTranscript != null)
      result.registrationTranscript = registrationTranscript;
    if (signature != null) result.signature = signature;
    if (parentTranscript != null) result.parentTranscript = parentTranscript;
    if (parentSignature != null) result.parentSignature = parentSignature;
    if (retentionProof != null) result.retentionProof = retentionProof;
    if (retainable != null) result.retainable = retainable;
    return result;
  }

  DeviceGrant._();

  factory DeviceGrant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeviceGrant()..mergeFromBuffer(data, registry);
  factory DeviceGrant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeviceGrant()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceGrant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: DeviceGrant.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..pPS(3, _omitFieldNames ? '' : 'scopes')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..aOB(5, _omitFieldNames ? '' : 'revoked')
    ..aOS(6, _omitFieldNames ? '' : 'parentGrantId')
    ..aOB(7, _omitFieldNames ? '' : 'recovery')
    ..aInt64(8, _omitFieldNames ? '' : 'authEpoch')
    ..aOS(9, _omitFieldNames ? '' : 'signatureKind')
    ..a<$core.List<$core.int>>(
        10, _omitFieldNames ? '' : 'registrationTranscript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        11, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        12, _omitFieldNames ? '' : 'parentTranscript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        13, _omitFieldNames ? '' : 'parentSignature', $pb.PbFieldType.OY)
    ..aOM<RetentionProof>(14, _omitFieldNames ? '' : 'retentionProof',
        subBuilder: RetentionProof.$_createMessage)
    ..aOB(15, _omitFieldNames ? '' : 'retainable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceGrant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceGrant copyWith(void Function(DeviceGrant) updates) =>
      super.copyWith((message) => updates(message as DeviceGrant))
          as DeviceGrant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeviceGrant() / DeviceGrant.new instead')
  static DeviceGrant create() => DeviceGrant._();
  static $pb.GeneratedMessage $_createMessage() => DeviceGrant._();
  @$core.override
  DeviceGrant createEmptyInstance() => DeviceGrant._();
  @$core.pragma('dart2js:noInline')
  static DeviceGrant getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceGrant>(
          DeviceGrant.$_createMessage);
  static DeviceGrant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get scopes => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get revoked => $_getBF(4);
  @$pb.TagNumber(5)
  set revoked($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevoked() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevoked() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get parentGrantId => $_getSZ(5);
  @$pb.TagNumber(6)
  set parentGrantId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParentGrantId() => $_has(5);
  @$pb.TagNumber(6)
  void clearParentGrantId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get recovery => $_getBF(6);
  @$pb.TagNumber(7)
  set recovery($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecovery() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecovery() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get authEpoch => $_getI64(7);
  @$pb.TagNumber(8)
  set authEpoch($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthEpoch() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthEpoch() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get signatureKind => $_getSZ(8);
  @$pb.TagNumber(9)
  set signatureKind($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSignatureKind() => $_has(8);
  @$pb.TagNumber(9)
  void clearSignatureKind() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.List<$core.int> get registrationTranscript => $_getN(9);
  @$pb.TagNumber(10)
  set registrationTranscript($core.List<$core.int> value) =>
      $_setBytes(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRegistrationTranscript() => $_has(9);
  @$pb.TagNumber(10)
  void clearRegistrationTranscript() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.int> get signature => $_getN(10);
  @$pb.TagNumber(11)
  set signature($core.List<$core.int> value) => $_setBytes(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSignature() => $_has(10);
  @$pb.TagNumber(11)
  void clearSignature() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.List<$core.int> get parentTranscript => $_getN(11);
  @$pb.TagNumber(12)
  set parentTranscript($core.List<$core.int> value) => $_setBytes(11, value);
  @$pb.TagNumber(12)
  $core.bool hasParentTranscript() => $_has(11);
  @$pb.TagNumber(12)
  void clearParentTranscript() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.List<$core.int> get parentSignature => $_getN(12);
  @$pb.TagNumber(13)
  set parentSignature($core.List<$core.int> value) => $_setBytes(12, value);
  @$pb.TagNumber(13)
  $core.bool hasParentSignature() => $_has(12);
  @$pb.TagNumber(13)
  void clearParentSignature() => $_clearField(13);

  @$pb.TagNumber(14)
  RetentionProof get retentionProof => $_getN(13);
  @$pb.TagNumber(14)
  set retentionProof(RetentionProof value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasRetentionProof() => $_has(13);
  @$pb.TagNumber(14)
  void clearRetentionProof() => $_clearField(14);
  @$pb.TagNumber(14)
  RetentionProof ensureRetentionProof() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.bool get retainable => $_getBF(14);
  @$pb.TagNumber(15)
  set retainable($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRetainable() => $_has(14);
  @$pb.TagNumber(15)
  void clearRetainable() => $_clearField(15);
}

class RetentionProof extends $pb.GeneratedMessage {
  factory RetentionProof({
    $core.String? grantId,
    $core.List<$core.int>? publicKey,
    $core.Iterable<$core.String>? scopes,
    $fixnum.Int64? expiresAt,
    $core.int? index,
    $core.int? count,
    $core.Iterable<$core.List<$core.int>>? siblings,
  }) {
    final result = RetentionProof._();
    if (grantId != null) result.grantId = grantId;
    if (publicKey != null) result.publicKey = publicKey;
    if (scopes != null) result.scopes.addAll(scopes);
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (index != null) result.index = index;
    if (count != null) result.count = count;
    if (siblings != null) result.siblings.addAll(siblings);
    return result;
  }

  RetentionProof._();

  factory RetentionProof.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetentionProof()..mergeFromBuffer(data, registry);
  factory RetentionProof.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetentionProof()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetentionProof',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RetentionProof.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'grantId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..pPS(3, _omitFieldNames ? '' : 'scopes')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..aI(5, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.OU3)
    ..p<$core.List<$core.int>>(
        7, _omitFieldNames ? '' : 'siblings', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetentionProof clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetentionProof copyWith(void Function(RetentionProof) updates) =>
      super.copyWith((message) => updates(message as RetentionProof))
          as RetentionProof;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RetentionProof() / RetentionProof.new instead')
  static RetentionProof create() => RetentionProof._();
  static $pb.GeneratedMessage $_createMessage() => RetentionProof._();
  @$core.override
  RetentionProof createEmptyInstance() => RetentionProof._();
  @$core.pragma('dart2js:noInline')
  static RetentionProof getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetentionProof>(
          RetentionProof.$_createMessage);
  static RetentionProof? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get grantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set grantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGrantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGrantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get scopes => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get index => $_getIZ(4);
  @$pb.TagNumber(5)
  set index($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIndex() => $_has(4);
  @$pb.TagNumber(5)
  void clearIndex() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get count => $_getIZ(5);
  @$pb.TagNumber(6)
  set count($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.List<$core.int>> get siblings => $_getList(6);
}

class ListDevicesResponse extends $pb.GeneratedMessage {
  factory ListDevicesResponse({
    $core.Iterable<DeviceGrant>? devices,
  }) {
    final result = ListDevicesResponse._();
    if (devices != null) result.devices.addAll(devices);
    return result;
  }

  ListDevicesResponse._();

  factory ListDevicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDevicesResponse()..mergeFromBuffer(data, registry);
  factory ListDevicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDevicesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDevicesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListDevicesResponse.$_createMessage)
    ..pPM<DeviceGrant>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: DeviceGrant.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse copyWith(void Function(ListDevicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListDevicesResponse))
          as ListDevicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListDevicesResponse() / ListDevicesResponse.new instead')
  static ListDevicesResponse create() => ListDevicesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListDevicesResponse._();
  @$core.override
  ListDevicesResponse createEmptyInstance() => ListDevicesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDevicesResponse>(
          ListDevicesResponse.$_createMessage);
  static ListDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DeviceGrant> get devices => $_getList(0);
}

class Pairing extends $pb.GeneratedMessage {
  factory Pairing({
    $core.String? id,
    $core.String? deviceName,
    $core.List<$core.int>? publicKey,
    $core.bool? administrative,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? expiresAt,
    $core.String? state,
    $core.List<$core.int>? proposedRootPublicKey,
  }) {
    final result = Pairing._();
    if (id != null) result.id = id;
    if (deviceName != null) result.deviceName = deviceName;
    if (publicKey != null) result.publicKey = publicKey;
    if (administrative != null) result.administrative = administrative;
    if (createdAt != null) result.createdAt = createdAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (state != null) result.state = state;
    if (proposedRootPublicKey != null)
      result.proposedRootPublicKey = proposedRootPublicKey;
    return result;
  }

  Pairing._();

  factory Pairing.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pairing()..mergeFromBuffer(data, registry);
  factory Pairing.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pairing()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pairing',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Pairing.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..aOB(4, _omitFieldNames ? '' : 'administrative')
    ..aInt64(5, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(6, _omitFieldNames ? '' : 'expiresAt')
    ..aOS(7, _omitFieldNames ? '' : 'state')
    ..a<$core.List<$core.int>>(
        8, _omitFieldNames ? '' : 'proposedRootPublicKey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pairing clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pairing copyWith(void Function(Pairing) updates) =>
      super.copyWith((message) => updates(message as Pairing)) as Pairing;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Pairing() / Pairing.new instead')
  static Pairing create() => Pairing._();
  static $pb.GeneratedMessage $_createMessage() => Pairing._();
  @$core.override
  Pairing createEmptyInstance() => Pairing._();
  @$core.pragma('dart2js:noInline')
  static Pairing getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Pairing>(Pairing.$_createMessage);
  static Pairing? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get publicKey => $_getN(2);
  @$pb.TagNumber(3)
  set publicKey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublicKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get administrative => $_getBF(3);
  @$pb.TagNumber(4)
  set administrative($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAdministrative() => $_has(3);
  @$pb.TagNumber(4)
  void clearAdministrative() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get createdAt => $_getI64(4);
  @$pb.TagNumber(5)
  set createdAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expiresAt => $_getI64(5);
  @$pb.TagNumber(6)
  set expiresAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get state => $_getSZ(6);
  @$pb.TagNumber(7)
  set state($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get proposedRootPublicKey => $_getN(7);
  @$pb.TagNumber(8)
  set proposedRootPublicKey($core.List<$core.int> value) =>
      $_setBytes(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProposedRootPublicKey() => $_has(7);
  @$pb.TagNumber(8)
  void clearProposedRootPublicKey() => $_clearField(8);
}

class CreatePairingRequest extends $pb.GeneratedMessage {
  factory CreatePairingRequest({
    $core.List<$core.int>? publicKey,
    $core.String? deviceName,
    $core.bool? administrative,
  }) {
    final result = CreatePairingRequest._();
    if (publicKey != null) result.publicKey = publicKey;
    if (deviceName != null) result.deviceName = deviceName;
    if (administrative != null) result.administrative = administrative;
    return result;
  }

  CreatePairingRequest._();

  factory CreatePairingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePairingRequest()..mergeFromBuffer(data, registry);
  factory CreatePairingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePairingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePairingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreatePairingRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aOB(3, _omitFieldNames ? '' : 'administrative')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePairingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePairingRequest copyWith(void Function(CreatePairingRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePairingRequest))
          as CreatePairingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreatePairingRequest() / CreatePairingRequest.new instead')
  static CreatePairingRequest create() => CreatePairingRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreatePairingRequest._();
  @$core.override
  CreatePairingRequest createEmptyInstance() => CreatePairingRequest._();
  @$core.pragma('dart2js:noInline')
  static CreatePairingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePairingRequest>(
          CreatePairingRequest.$_createMessage);
  static CreatePairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get administrative => $_getBF(2);
  @$pb.TagNumber(3)
  set administrative($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAdministrative() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdministrative() => $_clearField(3);
}

class CreatePairingResponse extends $pb.GeneratedMessage {
  factory CreatePairingResponse({
    Pairing? pairing,
    $core.String? code,
    $core.String? pollToken,
  }) {
    final result = CreatePairingResponse._();
    if (pairing != null) result.pairing = pairing;
    if (code != null) result.code = code;
    if (pollToken != null) result.pollToken = pollToken;
    return result;
  }

  CreatePairingResponse._();

  factory CreatePairingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePairingResponse()..mergeFromBuffer(data, registry);
  factory CreatePairingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePairingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePairingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreatePairingResponse.$_createMessage)
    ..aOM<Pairing>(1, _omitFieldNames ? '' : 'pairing',
        subBuilder: Pairing.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'pollToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePairingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePairingResponse copyWith(
          void Function(CreatePairingResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePairingResponse))
          as CreatePairingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreatePairingResponse() / CreatePairingResponse.new instead')
  static CreatePairingResponse create() => CreatePairingResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreatePairingResponse._();
  @$core.override
  CreatePairingResponse createEmptyInstance() => CreatePairingResponse._();
  @$core.pragma('dart2js:noInline')
  static CreatePairingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePairingResponse>(
          CreatePairingResponse.$_createMessage);
  static CreatePairingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Pairing get pairing => $_getN(0);
  @$pb.TagNumber(1)
  set pairing(Pairing value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPairing() => $_has(0);
  @$pb.TagNumber(1)
  void clearPairing() => $_clearField(1);
  @$pb.TagNumber(1)
  Pairing ensurePairing() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pollToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pollToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPollToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPollToken() => $_clearField(3);
}

class InspectPairingRequest extends $pb.GeneratedMessage {
  factory InspectPairingRequest({
    $core.String? code,
  }) {
    final result = InspectPairingRequest._();
    if (code != null) result.code = code;
    return result;
  }

  InspectPairingRequest._();

  factory InspectPairingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InspectPairingRequest()..mergeFromBuffer(data, registry);
  factory InspectPairingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InspectPairingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InspectPairingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: InspectPairingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectPairingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectPairingRequest copyWith(
          void Function(InspectPairingRequest) updates) =>
      super.copyWith((message) => updates(message as InspectPairingRequest))
          as InspectPairingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InspectPairingRequest() / InspectPairingRequest.new instead')
  static InspectPairingRequest create() => InspectPairingRequest._();
  static $pb.GeneratedMessage $_createMessage() => InspectPairingRequest._();
  @$core.override
  InspectPairingRequest createEmptyInstance() => InspectPairingRequest._();
  @$core.pragma('dart2js:noInline')
  static InspectPairingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InspectPairingRequest>(
          InspectPairingRequest.$_createMessage);
  static InspectPairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class InspectPairingResponse extends $pb.GeneratedMessage {
  factory InspectPairingResponse({
    Pairing? pairing,
  }) {
    final result = InspectPairingResponse._();
    if (pairing != null) result.pairing = pairing;
    return result;
  }

  InspectPairingResponse._();

  factory InspectPairingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InspectPairingResponse()..mergeFromBuffer(data, registry);
  factory InspectPairingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InspectPairingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InspectPairingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: InspectPairingResponse.$_createMessage)
    ..aOM<Pairing>(1, _omitFieldNames ? '' : 'pairing',
        subBuilder: Pairing.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectPairingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectPairingResponse copyWith(
          void Function(InspectPairingResponse) updates) =>
      super.copyWith((message) => updates(message as InspectPairingResponse))
          as InspectPairingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InspectPairingResponse() / InspectPairingResponse.new instead')
  static InspectPairingResponse create() => InspectPairingResponse._();
  static $pb.GeneratedMessage $_createMessage() => InspectPairingResponse._();
  @$core.override
  InspectPairingResponse createEmptyInstance() => InspectPairingResponse._();
  @$core.pragma('dart2js:noInline')
  static InspectPairingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InspectPairingResponse>(
          InspectPairingResponse.$_createMessage);
  static InspectPairingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Pairing get pairing => $_getN(0);
  @$pb.TagNumber(1)
  set pairing(Pairing value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPairing() => $_has(0);
  @$pb.TagNumber(1)
  void clearPairing() => $_clearField(1);
  @$pb.TagNumber(1)
  Pairing ensurePairing() => $_ensure(0);
}

class PollPairingRequest extends $pb.GeneratedMessage {
  factory PollPairingRequest({
    $core.String? pollToken,
  }) {
    final result = PollPairingRequest._();
    if (pollToken != null) result.pollToken = pollToken;
    return result;
  }

  PollPairingRequest._();

  factory PollPairingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PollPairingRequest()..mergeFromBuffer(data, registry);
  factory PollPairingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PollPairingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PollPairingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PollPairingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pollToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollPairingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollPairingRequest copyWith(void Function(PollPairingRequest) updates) =>
      super.copyWith((message) => updates(message as PollPairingRequest))
          as PollPairingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PollPairingRequest() / PollPairingRequest.new instead')
  static PollPairingRequest create() => PollPairingRequest._();
  static $pb.GeneratedMessage $_createMessage() => PollPairingRequest._();
  @$core.override
  PollPairingRequest createEmptyInstance() => PollPairingRequest._();
  @$core.pragma('dart2js:noInline')
  static PollPairingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PollPairingRequest>(
          PollPairingRequest.$_createMessage);
  static PollPairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pollToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set pollToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPollToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPollToken() => $_clearField(1);
}

class PollPairingResponse extends $pb.GeneratedMessage {
  factory PollPairingResponse({
    Pairing? pairing,
    $core.String? grantId,
    $core.List<$core.int>? rootPublicKey,
    $core.List<$core.int>? transcript,
    $core.List<$core.int>? signature,
    $core.List<$core.int>? parentTranscript,
    $core.List<$core.int>? parentSignature,
    $core.String? parentGrantId,
    $core.Iterable<RootHistoryProof>? rootHistory,
  }) {
    final result = PollPairingResponse._();
    if (pairing != null) result.pairing = pairing;
    if (grantId != null) result.grantId = grantId;
    if (rootPublicKey != null) result.rootPublicKey = rootPublicKey;
    if (transcript != null) result.transcript = transcript;
    if (signature != null) result.signature = signature;
    if (parentTranscript != null) result.parentTranscript = parentTranscript;
    if (parentSignature != null) result.parentSignature = parentSignature;
    if (parentGrantId != null) result.parentGrantId = parentGrantId;
    if (rootHistory != null) result.rootHistory.addAll(rootHistory);
    return result;
  }

  PollPairingResponse._();

  factory PollPairingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PollPairingResponse()..mergeFromBuffer(data, registry);
  factory PollPairingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PollPairingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PollPairingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PollPairingResponse.$_createMessage)
    ..aOM<Pairing>(1, _omitFieldNames ? '' : 'pairing',
        subBuilder: Pairing.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'grantId')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'rootPublicKey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'transcript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'parentTranscript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        7, _omitFieldNames ? '' : 'parentSignature', $pb.PbFieldType.OY)
    ..aOS(8, _omitFieldNames ? '' : 'parentGrantId')
    ..pPM<RootHistoryProof>(9, _omitFieldNames ? '' : 'rootHistory',
        subBuilder: RootHistoryProof.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollPairingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollPairingResponse copyWith(void Function(PollPairingResponse) updates) =>
      super.copyWith((message) => updates(message as PollPairingResponse))
          as PollPairingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PollPairingResponse() / PollPairingResponse.new instead')
  static PollPairingResponse create() => PollPairingResponse._();
  static $pb.GeneratedMessage $_createMessage() => PollPairingResponse._();
  @$core.override
  PollPairingResponse createEmptyInstance() => PollPairingResponse._();
  @$core.pragma('dart2js:noInline')
  static PollPairingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PollPairingResponse>(
          PollPairingResponse.$_createMessage);
  static PollPairingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Pairing get pairing => $_getN(0);
  @$pb.TagNumber(1)
  set pairing(Pairing value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPairing() => $_has(0);
  @$pb.TagNumber(1)
  void clearPairing() => $_clearField(1);
  @$pb.TagNumber(1)
  Pairing ensurePairing() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get grantId => $_getSZ(1);
  @$pb.TagNumber(2)
  set grantId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGrantId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGrantId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get rootPublicKey => $_getN(2);
  @$pb.TagNumber(3)
  set rootPublicKey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRootPublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearRootPublicKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get transcript => $_getN(3);
  @$pb.TagNumber(4)
  set transcript($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTranscript() => $_has(3);
  @$pb.TagNumber(4)
  void clearTranscript() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get signature => $_getN(4);
  @$pb.TagNumber(5)
  set signature($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignature() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get parentTranscript => $_getN(5);
  @$pb.TagNumber(6)
  set parentTranscript($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParentTranscript() => $_has(5);
  @$pb.TagNumber(6)
  void clearParentTranscript() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get parentSignature => $_getN(6);
  @$pb.TagNumber(7)
  set parentSignature($core.List<$core.int> value) => $_setBytes(6, value);
  @$pb.TagNumber(7)
  $core.bool hasParentSignature() => $_has(6);
  @$pb.TagNumber(7)
  void clearParentSignature() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get parentGrantId => $_getSZ(7);
  @$pb.TagNumber(8)
  set parentGrantId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasParentGrantId() => $_has(7);
  @$pb.TagNumber(8)
  void clearParentGrantId() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<RootHistoryProof> get rootHistory => $_getList(8);
}

class CancelPairingRequest extends $pb.GeneratedMessage {
  factory CancelPairingRequest({
    $core.String? pollToken,
  }) {
    final result = CancelPairingRequest._();
    if (pollToken != null) result.pollToken = pollToken;
    return result;
  }

  CancelPairingRequest._();

  factory CancelPairingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPairingRequest()..mergeFromBuffer(data, registry);
  factory CancelPairingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPairingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPairingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CancelPairingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pollToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPairingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPairingRequest copyWith(void Function(CancelPairingRequest) updates) =>
      super.copyWith((message) => updates(message as CancelPairingRequest))
          as CancelPairingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelPairingRequest() / CancelPairingRequest.new instead')
  static CancelPairingRequest create() => CancelPairingRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelPairingRequest._();
  @$core.override
  CancelPairingRequest createEmptyInstance() => CancelPairingRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelPairingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelPairingRequest>(
          CancelPairingRequest.$_createMessage);
  static CancelPairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pollToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set pollToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPollToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPollToken() => $_clearField(1);
}

class CancelPairingResponse extends $pb.GeneratedMessage {
  factory CancelPairingResponse() => CancelPairingResponse._();

  CancelPairingResponse._();

  factory CancelPairingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPairingResponse()..mergeFromBuffer(data, registry);
  factory CancelPairingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPairingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPairingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CancelPairingResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPairingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPairingResponse copyWith(
          void Function(CancelPairingResponse) updates) =>
      super.copyWith((message) => updates(message as CancelPairingResponse))
          as CancelPairingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelPairingResponse() / CancelPairingResponse.new instead')
  static CancelPairingResponse create() => CancelPairingResponse._();
  static $pb.GeneratedMessage $_createMessage() => CancelPairingResponse._();
  @$core.override
  CancelPairingResponse createEmptyInstance() => CancelPairingResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelPairingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelPairingResponse>(
          CancelPairingResponse.$_createMessage);
  static CancelPairingResponse? _defaultInstance;
}

class ClaimPairingRequest extends $pb.GeneratedMessage {
  factory ClaimPairingRequest({
    $core.String? pairingId,
  }) {
    final result = ClaimPairingRequest._();
    if (pairingId != null) result.pairingId = pairingId;
    return result;
  }

  ClaimPairingRequest._();

  factory ClaimPairingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimPairingRequest()..mergeFromBuffer(data, registry);
  factory ClaimPairingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimPairingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimPairingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ClaimPairingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pairingId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimPairingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimPairingRequest copyWith(void Function(ClaimPairingRequest) updates) =>
      super.copyWith((message) => updates(message as ClaimPairingRequest))
          as ClaimPairingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ClaimPairingRequest() / ClaimPairingRequest.new instead')
  static ClaimPairingRequest create() => ClaimPairingRequest._();
  static $pb.GeneratedMessage $_createMessage() => ClaimPairingRequest._();
  @$core.override
  ClaimPairingRequest createEmptyInstance() => ClaimPairingRequest._();
  @$core.pragma('dart2js:noInline')
  static ClaimPairingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClaimPairingRequest>(
          ClaimPairingRequest.$_createMessage);
  static ClaimPairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pairingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pairingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPairingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPairingId() => $_clearField(1);
}

class ClaimPairingResponse extends $pb.GeneratedMessage {
  factory ClaimPairingResponse() => ClaimPairingResponse._();

  ClaimPairingResponse._();

  factory ClaimPairingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimPairingResponse()..mergeFromBuffer(data, registry);
  factory ClaimPairingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimPairingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimPairingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ClaimPairingResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimPairingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimPairingResponse copyWith(void Function(ClaimPairingResponse) updates) =>
      super.copyWith((message) => updates(message as ClaimPairingResponse))
          as ClaimPairingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClaimPairingResponse() / ClaimPairingResponse.new instead')
  static ClaimPairingResponse create() => ClaimPairingResponse._();
  static $pb.GeneratedMessage $_createMessage() => ClaimPairingResponse._();
  @$core.override
  ClaimPairingResponse createEmptyInstance() => ClaimPairingResponse._();
  @$core.pragma('dart2js:noInline')
  static ClaimPairingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClaimPairingResponse>(
          ClaimPairingResponse.$_createMessage);
  static ClaimPairingResponse? _defaultInstance;
}

class ProposePairingRequest extends $pb.GeneratedMessage {
  factory ProposePairingRequest({
    $core.String? pairingId,
  }) {
    final result = ProposePairingRequest._();
    if (pairingId != null) result.pairingId = pairingId;
    return result;
  }

  ProposePairingRequest._();

  factory ProposePairingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProposePairingRequest()..mergeFromBuffer(data, registry);
  factory ProposePairingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProposePairingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProposePairingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ProposePairingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pairingId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposePairingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposePairingRequest copyWith(
          void Function(ProposePairingRequest) updates) =>
      super.copyWith((message) => updates(message as ProposePairingRequest))
          as ProposePairingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProposePairingRequest() / ProposePairingRequest.new instead')
  static ProposePairingRequest create() => ProposePairingRequest._();
  static $pb.GeneratedMessage $_createMessage() => ProposePairingRequest._();
  @$core.override
  ProposePairingRequest createEmptyInstance() => ProposePairingRequest._();
  @$core.pragma('dart2js:noInline')
  static ProposePairingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProposePairingRequest>(
          ProposePairingRequest.$_createMessage);
  static ProposePairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pairingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pairingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPairingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPairingId() => $_clearField(1);
}

class ProposePairingResponse extends $pb.GeneratedMessage {
  factory ProposePairingResponse() => ProposePairingResponse._();

  ProposePairingResponse._();

  factory ProposePairingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProposePairingResponse()..mergeFromBuffer(data, registry);
  factory ProposePairingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProposePairingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProposePairingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ProposePairingResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposePairingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposePairingResponse copyWith(
          void Function(ProposePairingResponse) updates) =>
      super.copyWith((message) => updates(message as ProposePairingResponse))
          as ProposePairingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProposePairingResponse() / ProposePairingResponse.new instead')
  static ProposePairingResponse create() => ProposePairingResponse._();
  static $pb.GeneratedMessage $_createMessage() => ProposePairingResponse._();
  @$core.override
  ProposePairingResponse createEmptyInstance() => ProposePairingResponse._();
  @$core.pragma('dart2js:noInline')
  static ProposePairingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProposePairingResponse>(
          ProposePairingResponse.$_createMessage);
  static ProposePairingResponse? _defaultInstance;
}

class ParticipantProfile extends $pb.GeneratedMessage {
  factory ParticipantProfile({
    $core.String? principalId,
    $core.String? displayName,
    $core.List<$core.int>? avatarPng,
    $fixnum.Int64? revision,
  }) {
    final result = ParticipantProfile._();
    if (principalId != null) result.principalId = principalId;
    if (displayName != null) result.displayName = displayName;
    if (avatarPng != null) result.avatarPng = avatarPng;
    if (revision != null) result.revision = revision;
    return result;
  }

  ParticipantProfile._();

  factory ParticipantProfile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParticipantProfile()..mergeFromBuffer(data, registry);
  factory ParticipantProfile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ParticipantProfile()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParticipantProfile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ParticipantProfile.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'avatarPng', $pb.PbFieldType.OY)
    ..aInt64(4, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantProfile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParticipantProfile copyWith(void Function(ParticipantProfile) updates) =>
      super.copyWith((message) => updates(message as ParticipantProfile))
          as ParticipantProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ParticipantProfile() / ParticipantProfile.new instead')
  static ParticipantProfile create() => ParticipantProfile._();
  static $pb.GeneratedMessage $_createMessage() => ParticipantProfile._();
  @$core.override
  ParticipantProfile createEmptyInstance() => ParticipantProfile._();
  @$core.pragma('dart2js:noInline')
  static ParticipantProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParticipantProfile>(
          ParticipantProfile.$_createMessage);
  static ParticipantProfile? _defaultInstance;

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
  $core.List<$core.int> get avatarPng => $_getN(2);
  @$pb.TagNumber(3)
  set avatarPng($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatarPng() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatarPng() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get revision => $_getI64(3);
  @$pb.TagNumber(4)
  set revision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);
}

class GetParticipantProfileRequest extends $pb.GeneratedMessage {
  factory GetParticipantProfileRequest() => GetParticipantProfileRequest._();

  GetParticipantProfileRequest._();

  factory GetParticipantProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantProfileRequest()..mergeFromBuffer(data, registry);
  factory GetParticipantProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantProfileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetParticipantProfileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetParticipantProfileRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantProfileRequest copyWith(
          void Function(GetParticipantProfileRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetParticipantProfileRequest))
          as GetParticipantProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetParticipantProfileRequest() / GetParticipantProfileRequest.new instead')
  static GetParticipantProfileRequest create() =>
      GetParticipantProfileRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetParticipantProfileRequest._();
  @$core.override
  GetParticipantProfileRequest createEmptyInstance() =>
      GetParticipantProfileRequest._();
  @$core.pragma('dart2js:noInline')
  static GetParticipantProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetParticipantProfileRequest>(
          GetParticipantProfileRequest.$_createMessage);
  static GetParticipantProfileRequest? _defaultInstance;
}

class GetParticipantProfileResponse extends $pb.GeneratedMessage {
  factory GetParticipantProfileResponse({
    ParticipantProfile? profile,
  }) {
    final result = GetParticipantProfileResponse._();
    if (profile != null) result.profile = profile;
    return result;
  }

  GetParticipantProfileResponse._();

  factory GetParticipantProfileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantProfileResponse()..mergeFromBuffer(data, registry);
  factory GetParticipantProfileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetParticipantProfileResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetParticipantProfileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetParticipantProfileResponse.$_createMessage)
    ..aOM<ParticipantProfile>(1, _omitFieldNames ? '' : 'profile',
        subBuilder: ParticipantProfile.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantProfileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParticipantProfileResponse copyWith(
          void Function(GetParticipantProfileResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetParticipantProfileResponse))
          as GetParticipantProfileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetParticipantProfileResponse() / GetParticipantProfileResponse.new instead')
  static GetParticipantProfileResponse create() =>
      GetParticipantProfileResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetParticipantProfileResponse._();
  @$core.override
  GetParticipantProfileResponse createEmptyInstance() =>
      GetParticipantProfileResponse._();
  @$core.pragma('dart2js:noInline')
  static GetParticipantProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetParticipantProfileResponse>(
          GetParticipantProfileResponse.$_createMessage);
  static GetParticipantProfileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ParticipantProfile get profile => $_getN(0);
  @$pb.TagNumber(1)
  set profile(ParticipantProfile value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);
  @$pb.TagNumber(1)
  ParticipantProfile ensureProfile() => $_ensure(0);
}

class UpdateParticipantProfileRequest extends $pb.GeneratedMessage {
  factory UpdateParticipantProfileRequest({
    $core.String? displayName,
    $core.List<$core.int>? avatarPng,
    $core.bool? removeAvatar,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = UpdateParticipantProfileRequest._();
    if (displayName != null) result.displayName = displayName;
    if (avatarPng != null) result.avatarPng = avatarPng;
    if (removeAvatar != null) result.removeAvatar = removeAvatar;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  UpdateParticipantProfileRequest._();

  factory UpdateParticipantProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateParticipantProfileRequest()..mergeFromBuffer(data, registry);
  factory UpdateParticipantProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateParticipantProfileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateParticipantProfileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateParticipantProfileRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'displayName')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'avatarPng', $pb.PbFieldType.OY)
    ..aOB(3, _omitFieldNames ? '' : 'removeAvatar')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateParticipantProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateParticipantProfileRequest copyWith(
          void Function(UpdateParticipantProfileRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateParticipantProfileRequest))
          as UpdateParticipantProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateParticipantProfileRequest() / UpdateParticipantProfileRequest.new instead')
  static UpdateParticipantProfileRequest create() =>
      UpdateParticipantProfileRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateParticipantProfileRequest._();
  @$core.override
  UpdateParticipantProfileRequest createEmptyInstance() =>
      UpdateParticipantProfileRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateParticipantProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateParticipantProfileRequest>(
          UpdateParticipantProfileRequest.$_createMessage);
  static UpdateParticipantProfileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get displayName => $_getSZ(0);
  @$pb.TagNumber(1)
  set displayName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisplayName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisplayName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get avatarPng => $_getN(1);
  @$pb.TagNumber(2)
  set avatarPng($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvatarPng() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvatarPng() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get removeAvatar => $_getBF(2);
  @$pb.TagNumber(3)
  set removeAvatar($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRemoveAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemoveAvatar() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedRevision() => $_clearField(4);
}

class UpdateParticipantProfileResponse extends $pb.GeneratedMessage {
  factory UpdateParticipantProfileResponse({
    ParticipantProfile? profile,
  }) {
    final result = UpdateParticipantProfileResponse._();
    if (profile != null) result.profile = profile;
    return result;
  }

  UpdateParticipantProfileResponse._();

  factory UpdateParticipantProfileResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateParticipantProfileResponse()..mergeFromBuffer(data, registry);
  factory UpdateParticipantProfileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateParticipantProfileResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateParticipantProfileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateParticipantProfileResponse.$_createMessage)
    ..aOM<ParticipantProfile>(1, _omitFieldNames ? '' : 'profile',
        subBuilder: ParticipantProfile.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateParticipantProfileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateParticipantProfileResponse copyWith(
          void Function(UpdateParticipantProfileResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateParticipantProfileResponse))
          as UpdateParticipantProfileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateParticipantProfileResponse() / UpdateParticipantProfileResponse.new instead')
  static UpdateParticipantProfileResponse create() =>
      UpdateParticipantProfileResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateParticipantProfileResponse._();
  @$core.override
  UpdateParticipantProfileResponse createEmptyInstance() =>
      UpdateParticipantProfileResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateParticipantProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateParticipantProfileResponse>(
          UpdateParticipantProfileResponse.$_createMessage);
  static UpdateParticipantProfileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ParticipantProfile get profile => $_getN(0);
  @$pb.TagNumber(1)
  set profile(ParticipantProfile value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);
  @$pb.TagNumber(1)
  ParticipantProfile ensureProfile() => $_ensure(0);
}

class ListParticipantProfilesRequest extends $pb.GeneratedMessage {
  factory ListParticipantProfilesRequest({
    $core.String? channelId,
    $core.Iterable<$core.String>? principalIds,
  }) {
    final result = ListParticipantProfilesRequest._();
    if (channelId != null) result.channelId = channelId;
    if (principalIds != null) result.principalIds.addAll(principalIds);
    return result;
  }

  ListParticipantProfilesRequest._();

  factory ListParticipantProfilesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListParticipantProfilesRequest()..mergeFromBuffer(data, registry);
  factory ListParticipantProfilesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListParticipantProfilesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListParticipantProfilesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListParticipantProfilesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..pPS(2, _omitFieldNames ? '' : 'principalIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParticipantProfilesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParticipantProfilesRequest copyWith(
          void Function(ListParticipantProfilesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListParticipantProfilesRequest))
          as ListParticipantProfilesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListParticipantProfilesRequest() / ListParticipantProfilesRequest.new instead')
  static ListParticipantProfilesRequest create() =>
      ListParticipantProfilesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListParticipantProfilesRequest._();
  @$core.override
  ListParticipantProfilesRequest createEmptyInstance() =>
      ListParticipantProfilesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListParticipantProfilesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListParticipantProfilesRequest>(
          ListParticipantProfilesRequest.$_createMessage);
  static ListParticipantProfilesRequest? _defaultInstance;

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

class ListParticipantProfilesResponse extends $pb.GeneratedMessage {
  factory ListParticipantProfilesResponse({
    $core.Iterable<ParticipantProfile>? profiles,
  }) {
    final result = ListParticipantProfilesResponse._();
    if (profiles != null) result.profiles.addAll(profiles);
    return result;
  }

  ListParticipantProfilesResponse._();

  factory ListParticipantProfilesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListParticipantProfilesResponse()..mergeFromBuffer(data, registry);
  factory ListParticipantProfilesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListParticipantProfilesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListParticipantProfilesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListParticipantProfilesResponse.$_createMessage)
    ..pPM<ParticipantProfile>(1, _omitFieldNames ? '' : 'profiles',
        subBuilder: ParticipantProfile.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParticipantProfilesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParticipantProfilesResponse copyWith(
          void Function(ListParticipantProfilesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListParticipantProfilesResponse))
          as ListParticipantProfilesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListParticipantProfilesResponse() / ListParticipantProfilesResponse.new instead')
  static ListParticipantProfilesResponse create() =>
      ListParticipantProfilesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListParticipantProfilesResponse._();
  @$core.override
  ListParticipantProfilesResponse createEmptyInstance() =>
      ListParticipantProfilesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListParticipantProfilesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListParticipantProfilesResponse>(
          ListParticipantProfilesResponse.$_createMessage);
  static ListParticipantProfilesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ParticipantProfile> get profiles => $_getList(0);
}

class Member extends $pb.GeneratedMessage {
  factory Member({
    $core.String? principalId,
    $core.String? role,
    $core.bool? blocked,
    $fixnum.Int64? revision,
    $fixnum.Int64? storageLimitBytes,
    $core.String? nickname,
    $core.List<$core.int>? avatarPng,
  }) {
    final result = Member._();
    if (principalId != null) result.principalId = principalId;
    if (role != null) result.role = role;
    if (blocked != null) result.blocked = blocked;
    if (revision != null) result.revision = revision;
    if (storageLimitBytes != null) result.storageLimitBytes = storageLimitBytes;
    if (nickname != null) result.nickname = nickname;
    if (avatarPng != null) result.avatarPng = avatarPng;
    return result;
  }

  Member._();

  factory Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Member()..mergeFromBuffer(data, registry);
  factory Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Member()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Member',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Member.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOB(3, _omitFieldNames ? '' : 'blocked')
    ..aInt64(4, _omitFieldNames ? '' : 'revision')
    ..aInt64(5, _omitFieldNames ? '' : 'storageLimitBytes')
    ..aOS(6, _omitFieldNames ? '' : 'nickname')
    ..a<$core.List<$core.int>>(
        7, _omitFieldNames ? '' : 'avatarPng', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member copyWith(void Function(Member) updates) =>
      super.copyWith((message) => updates(message as Member)) as Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Member() / Member.new instead')
  static Member create() => Member._();
  static $pb.GeneratedMessage $_createMessage() => Member._();
  @$core.override
  Member createEmptyInstance() => Member._();
  @$core.pragma('dart2js:noInline')
  static Member getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Member>(Member.$_createMessage);
  static Member? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get principalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set principalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrincipalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrincipalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get blocked => $_getBF(2);
  @$pb.TagNumber(3)
  set blocked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBlocked() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlocked() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get revision => $_getI64(3);
  @$pb.TagNumber(4)
  set revision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get storageLimitBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set storageLimitBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStorageLimitBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearStorageLimitBytes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get nickname => $_getSZ(5);
  @$pb.TagNumber(6)
  set nickname($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNickname() => $_has(5);
  @$pb.TagNumber(6)
  void clearNickname() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get avatarPng => $_getN(6);
  @$pb.TagNumber(7)
  set avatarPng($core.List<$core.int> value) => $_setBytes(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAvatarPng() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvatarPng() => $_clearField(7);
}

class ListMembersRequest extends $pb.GeneratedMessage {
  factory ListMembersRequest({
    $core.String? after,
  }) {
    final result = ListMembersRequest._();
    if (after != null) result.after = after;
    return result;
  }

  ListMembersRequest._();

  factory ListMembersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersRequest()..mergeFromBuffer(data, registry);
  factory ListMembersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMembersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMembersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersRequest copyWith(void Function(ListMembersRequest) updates) =>
      super.copyWith((message) => updates(message as ListMembersRequest))
          as ListMembersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListMembersRequest() / ListMembersRequest.new instead')
  static ListMembersRequest create() => ListMembersRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListMembersRequest._();
  @$core.override
  ListMembersRequest createEmptyInstance() => ListMembersRequest._();
  @$core.pragma('dart2js:noInline')
  static ListMembersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMembersRequest>(
          ListMembersRequest.$_createMessage);
  static ListMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get after => $_getSZ(0);
  @$pb.TagNumber(1)
  set after($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfter() => $_clearField(1);
}

class ListMembersResponse extends $pb.GeneratedMessage {
  factory ListMembersResponse({
    $core.Iterable<Member>? members,
    $core.String? nextCursor,
  }) {
    final result = ListMembersResponse._();
    if (members != null) result.members.addAll(members);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListMembersResponse._();

  factory ListMembersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersResponse()..mergeFromBuffer(data, registry);
  factory ListMembersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMembersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMembersResponse.$_createMessage)
    ..pPM<Member>(1, _omitFieldNames ? '' : 'members',
        subBuilder: Member.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersResponse copyWith(void Function(ListMembersResponse) updates) =>
      super.copyWith((message) => updates(message as ListMembersResponse))
          as ListMembersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListMembersResponse() / ListMembersResponse.new instead')
  static ListMembersResponse create() => ListMembersResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListMembersResponse._();
  @$core.override
  ListMembersResponse createEmptyInstance() => ListMembersResponse._();
  @$core.pragma('dart2js:noInline')
  static ListMembersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMembersResponse>(
          ListMembersResponse.$_createMessage);
  static ListMembersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Member> get members => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class UpdateMemberRequest extends $pb.GeneratedMessage {
  factory UpdateMemberRequest({
    $core.String? principalId,
    $core.String? role,
    $core.bool? blocked,
    $fixnum.Int64? expectedRevision,
    $fixnum.Int64? storageLimitBytes,
    $core.bool? resetStorageLimit,
  }) {
    final result = UpdateMemberRequest._();
    if (principalId != null) result.principalId = principalId;
    if (role != null) result.role = role;
    if (blocked != null) result.blocked = blocked;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (storageLimitBytes != null) result.storageLimitBytes = storageLimitBytes;
    if (resetStorageLimit != null) result.resetStorageLimit = resetStorageLimit;
    return result;
  }

  UpdateMemberRequest._();

  factory UpdateMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberRequest()..mergeFromBuffer(data, registry);
  factory UpdateMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateMemberRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOB(3, _omitFieldNames ? '' : 'blocked')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..aInt64(5, _omitFieldNames ? '' : 'storageLimitBytes')
    ..aOB(6, _omitFieldNames ? '' : 'resetStorageLimit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRequest copyWith(void Function(UpdateMemberRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateMemberRequest))
          as UpdateMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateMemberRequest() / UpdateMemberRequest.new instead')
  static UpdateMemberRequest create() => UpdateMemberRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateMemberRequest._();
  @$core.override
  UpdateMemberRequest createEmptyInstance() => UpdateMemberRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberRequest>(
          UpdateMemberRequest.$_createMessage);
  static UpdateMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get principalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set principalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrincipalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrincipalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get blocked => $_getBF(2);
  @$pb.TagNumber(3)
  set blocked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBlocked() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlocked() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get storageLimitBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set storageLimitBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStorageLimitBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearStorageLimitBytes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get resetStorageLimit => $_getBF(5);
  @$pb.TagNumber(6)
  set resetStorageLimit($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResetStorageLimit() => $_has(5);
  @$pb.TagNumber(6)
  void clearResetStorageLimit() => $_clearField(6);
}

class UpdateMemberResponse extends $pb.GeneratedMessage {
  factory UpdateMemberResponse({
    Member? member,
  }) {
    final result = UpdateMemberResponse._();
    if (member != null) result.member = member;
    return result;
  }

  UpdateMemberResponse._();

  factory UpdateMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberResponse()..mergeFromBuffer(data, registry);
  factory UpdateMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateMemberResponse.$_createMessage)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member',
        subBuilder: Member.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberResponse copyWith(void Function(UpdateMemberResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateMemberResponse))
          as UpdateMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateMemberResponse() / UpdateMemberResponse.new instead')
  static UpdateMemberResponse create() => UpdateMemberResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateMemberResponse._();
  @$core.override
  UpdateMemberResponse createEmptyInstance() => UpdateMemberResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberResponse>(
          UpdateMemberResponse.$_createMessage);
  static UpdateMemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);
}

class Invite extends $pb.GeneratedMessage {
  factory Invite({
    $core.String? id,
    $core.String? role,
    $fixnum.Int64? expiresAt,
    $core.int? maxUses,
    $core.int? uses,
    $core.bool? revoked,
  }) {
    final result = Invite._();
    if (id != null) result.id = id;
    if (role != null) result.role = role;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (maxUses != null) result.maxUses = maxUses;
    if (uses != null) result.uses = uses;
    if (revoked != null) result.revoked = revoked;
    return result;
  }

  Invite._();

  factory Invite.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Invite()..mergeFromBuffer(data, registry);
  factory Invite.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Invite()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Invite',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Invite.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aInt64(3, _omitFieldNames ? '' : 'expiresAt')
    ..aI(4, _omitFieldNames ? '' : 'maxUses')
    ..aI(5, _omitFieldNames ? '' : 'uses')
    ..aOB(6, _omitFieldNames ? '' : 'revoked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invite clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invite copyWith(void Function(Invite) updates) =>
      super.copyWith((message) => updates(message as Invite)) as Invite;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Invite() / Invite.new instead')
  static Invite create() => Invite._();
  static $pb.GeneratedMessage $_createMessage() => Invite._();
  @$core.override
  Invite createEmptyInstance() => Invite._();
  @$core.pragma('dart2js:noInline')
  static Invite getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Invite>(Invite.$_createMessage);
  static Invite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresAt => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxUses => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxUses($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxUses() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxUses() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get uses => $_getIZ(4);
  @$pb.TagNumber(5)
  set uses($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUses() => $_has(4);
  @$pb.TagNumber(5)
  void clearUses() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get revoked => $_getBF(5);
  @$pb.TagNumber(6)
  set revoked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRevoked() => $_has(5);
  @$pb.TagNumber(6)
  void clearRevoked() => $_clearField(6);
}

class CreateInviteRequest extends $pb.GeneratedMessage {
  factory CreateInviteRequest({
    $core.String? role,
    $core.int? ttlSeconds,
    $core.int? maxUses,
  }) {
    final result = CreateInviteRequest._();
    if (role != null) result.role = role;
    if (ttlSeconds != null) result.ttlSeconds = ttlSeconds;
    if (maxUses != null) result.maxUses = maxUses;
    return result;
  }

  CreateInviteRequest._();

  factory CreateInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteRequest()..mergeFromBuffer(data, registry);
  factory CreateInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aI(2, _omitFieldNames ? '' : 'ttlSeconds')
    ..aI(3, _omitFieldNames ? '' : 'maxUses')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteRequest copyWith(void Function(CreateInviteRequest) updates) =>
      super.copyWith((message) => updates(message as CreateInviteRequest))
          as CreateInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CreateInviteRequest() / CreateInviteRequest.new instead')
  static CreateInviteRequest create() => CreateInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateInviteRequest._();
  @$core.override
  CreateInviteRequest createEmptyInstance() => CreateInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateInviteRequest>(
          CreateInviteRequest.$_createMessage);
  static CreateInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get ttlSeconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set ttlSeconds($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTtlSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearTtlSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxUses => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxUses($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxUses() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxUses() => $_clearField(3);
}

class CreateInviteResponse extends $pb.GeneratedMessage {
  factory CreateInviteResponse({
    Invite? invite,
    $core.String? token,
  }) {
    final result = CreateInviteResponse._();
    if (invite != null) result.invite = invite;
    if (token != null) result.token = token;
    return result;
  }

  CreateInviteResponse._();

  factory CreateInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteResponse()..mergeFromBuffer(data, registry);
  factory CreateInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateInviteResponse.$_createMessage)
    ..aOM<Invite>(1, _omitFieldNames ? '' : 'invite',
        subBuilder: Invite.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteResponse copyWith(void Function(CreateInviteResponse) updates) =>
      super.copyWith((message) => updates(message as CreateInviteResponse))
          as CreateInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateInviteResponse() / CreateInviteResponse.new instead')
  static CreateInviteResponse create() => CreateInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateInviteResponse._();
  @$core.override
  CreateInviteResponse createEmptyInstance() => CreateInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateInviteResponse>(
          CreateInviteResponse.$_createMessage);
  static CreateInviteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Invite get invite => $_getN(0);
  @$pb.TagNumber(1)
  set invite(Invite value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInvite() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvite() => $_clearField(1);
  @$pb.TagNumber(1)
  Invite ensureInvite() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

class ListInvitesRequest extends $pb.GeneratedMessage {
  factory ListInvitesRequest({
    $core.String? after,
  }) {
    final result = ListInvitesRequest._();
    if (after != null) result.after = after;
    return result;
  }

  ListInvitesRequest._();

  factory ListInvitesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesRequest()..mergeFromBuffer(data, registry);
  factory ListInvitesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvitesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListInvitesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesRequest copyWith(void Function(ListInvitesRequest) updates) =>
      super.copyWith((message) => updates(message as ListInvitesRequest))
          as ListInvitesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListInvitesRequest() / ListInvitesRequest.new instead')
  static ListInvitesRequest create() => ListInvitesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListInvitesRequest._();
  @$core.override
  ListInvitesRequest createEmptyInstance() => ListInvitesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListInvitesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvitesRequest>(
          ListInvitesRequest.$_createMessage);
  static ListInvitesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get after => $_getSZ(0);
  @$pb.TagNumber(1)
  set after($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfter() => $_clearField(1);
}

class ListInvitesResponse extends $pb.GeneratedMessage {
  factory ListInvitesResponse({
    $core.Iterable<Invite>? invites,
    $core.String? nextCursor,
  }) {
    final result = ListInvitesResponse._();
    if (invites != null) result.invites.addAll(invites);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListInvitesResponse._();

  factory ListInvitesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesResponse()..mergeFromBuffer(data, registry);
  factory ListInvitesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvitesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListInvitesResponse.$_createMessage)
    ..pPM<Invite>(1, _omitFieldNames ? '' : 'invites',
        subBuilder: Invite.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesResponse copyWith(void Function(ListInvitesResponse) updates) =>
      super.copyWith((message) => updates(message as ListInvitesResponse))
          as ListInvitesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListInvitesResponse() / ListInvitesResponse.new instead')
  static ListInvitesResponse create() => ListInvitesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListInvitesResponse._();
  @$core.override
  ListInvitesResponse createEmptyInstance() => ListInvitesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListInvitesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvitesResponse>(
          ListInvitesResponse.$_createMessage);
  static ListInvitesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Invite> get invites => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class RevokeInviteRequest extends $pb.GeneratedMessage {
  factory RevokeInviteRequest({
    $core.String? inviteId,
  }) {
    final result = RevokeInviteRequest._();
    if (inviteId != null) result.inviteId = inviteId;
    return result;
  }

  RevokeInviteRequest._();

  factory RevokeInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteRequest()..mergeFromBuffer(data, registry);
  factory RevokeInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'inviteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteRequest copyWith(void Function(RevokeInviteRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeInviteRequest))
          as RevokeInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RevokeInviteRequest() / RevokeInviteRequest.new instead')
  static RevokeInviteRequest create() => RevokeInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => RevokeInviteRequest._();
  @$core.override
  RevokeInviteRequest createEmptyInstance() => RevokeInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static RevokeInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeInviteRequest>(
          RevokeInviteRequest.$_createMessage);
  static RevokeInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get inviteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set inviteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInviteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInviteId() => $_clearField(1);
}

class RevokeInviteResponse extends $pb.GeneratedMessage {
  factory RevokeInviteResponse() => RevokeInviteResponse._();

  RevokeInviteResponse._();

  factory RevokeInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteResponse()..mergeFromBuffer(data, registry);
  factory RevokeInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeInviteResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteResponse copyWith(void Function(RevokeInviteResponse) updates) =>
      super.copyWith((message) => updates(message as RevokeInviteResponse))
          as RevokeInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RevokeInviteResponse() / RevokeInviteResponse.new instead')
  static RevokeInviteResponse create() => RevokeInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => RevokeInviteResponse._();
  @$core.override
  RevokeInviteResponse createEmptyInstance() => RevokeInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static RevokeInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeInviteResponse>(
          RevokeInviteResponse.$_createMessage);
  static RevokeInviteResponse? _defaultInstance;
}

class PreviewInviteRequest extends $pb.GeneratedMessage {
  factory PreviewInviteRequest({
    $core.String? token,
  }) {
    final result = PreviewInviteRequest._();
    if (token != null) result.token = token;
    return result;
  }

  PreviewInviteRequest._();

  factory PreviewInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteRequest()..mergeFromBuffer(data, registry);
  factory PreviewInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PreviewInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteRequest copyWith(void Function(PreviewInviteRequest) updates) =>
      super.copyWith((message) => updates(message as PreviewInviteRequest))
          as PreviewInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PreviewInviteRequest() / PreviewInviteRequest.new instead')
  static PreviewInviteRequest create() => PreviewInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => PreviewInviteRequest._();
  @$core.override
  PreviewInviteRequest createEmptyInstance() => PreviewInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static PreviewInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewInviteRequest>(
          PreviewInviteRequest.$_createMessage);
  static PreviewInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class PreviewInviteResponse extends $pb.GeneratedMessage {
  factory PreviewInviteResponse({
    $core.String? role,
    $core.String? serverId,
    $core.String? title,
    $fixnum.Int64? expiresAt,
  }) {
    final result = PreviewInviteResponse._();
    if (role != null) result.role = role;
    if (serverId != null) result.serverId = serverId;
    if (title != null) result.title = title;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  PreviewInviteResponse._();

  factory PreviewInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteResponse()..mergeFromBuffer(data, registry);
  factory PreviewInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PreviewInviteResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteResponse copyWith(
          void Function(PreviewInviteResponse) updates) =>
      super.copyWith((message) => updates(message as PreviewInviteResponse))
          as PreviewInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PreviewInviteResponse() / PreviewInviteResponse.new instead')
  static PreviewInviteResponse create() => PreviewInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => PreviewInviteResponse._();
  @$core.override
  PreviewInviteResponse createEmptyInstance() => PreviewInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static PreviewInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewInviteResponse>(
          PreviewInviteResponse.$_createMessage);
  static PreviewInviteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

class AcceptInviteRequest extends $pb.GeneratedMessage {
  factory AcceptInviteRequest({
    $core.String? token,
  }) {
    final result = AcceptInviteRequest._();
    if (token != null) result.token = token;
    return result;
  }

  AcceptInviteRequest._();

  factory AcceptInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteRequest()..mergeFromBuffer(data, registry);
  factory AcceptInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: AcceptInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteRequest copyWith(void Function(AcceptInviteRequest) updates) =>
      super.copyWith((message) => updates(message as AcceptInviteRequest))
          as AcceptInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use AcceptInviteRequest() / AcceptInviteRequest.new instead')
  static AcceptInviteRequest create() => AcceptInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => AcceptInviteRequest._();
  @$core.override
  AcceptInviteRequest createEmptyInstance() => AcceptInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static AcceptInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptInviteRequest>(
          AcceptInviteRequest.$_createMessage);
  static AcceptInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class AcceptInviteResponse extends $pb.GeneratedMessage {
  factory AcceptInviteResponse({
    Member? member,
  }) {
    final result = AcceptInviteResponse._();
    if (member != null) result.member = member;
    return result;
  }

  AcceptInviteResponse._();

  factory AcceptInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteResponse()..mergeFromBuffer(data, registry);
  factory AcceptInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: AcceptInviteResponse.$_createMessage)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member',
        subBuilder: Member.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteResponse copyWith(void Function(AcceptInviteResponse) updates) =>
      super.copyWith((message) => updates(message as AcceptInviteResponse))
          as AcceptInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AcceptInviteResponse() / AcceptInviteResponse.new instead')
  static AcceptInviteResponse create() => AcceptInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => AcceptInviteResponse._();
  @$core.override
  AcceptInviteResponse createEmptyInstance() => AcceptInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static AcceptInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptInviteResponse>(
          AcceptInviteResponse.$_createMessage);
  static AcceptInviteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);
}

class GetMembershipRequest extends $pb.GeneratedMessage {
  factory GetMembershipRequest() => GetMembershipRequest._();

  GetMembershipRequest._();

  factory GetMembershipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipRequest()..mergeFromBuffer(data, registry);
  factory GetMembershipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMembershipRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetMembershipRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipRequest copyWith(void Function(GetMembershipRequest) updates) =>
      super.copyWith((message) => updates(message as GetMembershipRequest))
          as GetMembershipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMembershipRequest() / GetMembershipRequest.new instead')
  static GetMembershipRequest create() => GetMembershipRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMembershipRequest._();
  @$core.override
  GetMembershipRequest createEmptyInstance() => GetMembershipRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMembershipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMembershipRequest>(
          GetMembershipRequest.$_createMessage);
  static GetMembershipRequest? _defaultInstance;
}

class GetMembershipResponse extends $pb.GeneratedMessage {
  factory GetMembershipResponse({
    Member? member,
  }) {
    final result = GetMembershipResponse._();
    if (member != null) result.member = member;
    return result;
  }

  GetMembershipResponse._();

  factory GetMembershipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipResponse()..mergeFromBuffer(data, registry);
  factory GetMembershipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMembershipResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetMembershipResponse.$_createMessage)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member',
        subBuilder: Member.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipResponse copyWith(
          void Function(GetMembershipResponse) updates) =>
      super.copyWith((message) => updates(message as GetMembershipResponse))
          as GetMembershipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMembershipResponse() / GetMembershipResponse.new instead')
  static GetMembershipResponse create() => GetMembershipResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetMembershipResponse._();
  @$core.override
  GetMembershipResponse createEmptyInstance() => GetMembershipResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMembershipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMembershipResponse>(
          GetMembershipResponse.$_createMessage);
  static GetMembershipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);
}

class GetSetupStatusRequest extends $pb.GeneratedMessage {
  factory GetSetupStatusRequest() => GetSetupStatusRequest._();

  GetSetupStatusRequest._();

  factory GetSetupStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusRequest()..mergeFromBuffer(data, registry);
  factory GetSetupStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSetupStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSetupStatusRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusRequest copyWith(
          void Function(GetSetupStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetSetupStatusRequest))
          as GetSetupStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSetupStatusRequest() / GetSetupStatusRequest.new instead')
  static GetSetupStatusRequest create() => GetSetupStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSetupStatusRequest._();
  @$core.override
  GetSetupStatusRequest createEmptyInstance() => GetSetupStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSetupStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSetupStatusRequest>(
          GetSetupStatusRequest.$_createMessage);
  static GetSetupStatusRequest? _defaultInstance;
}

class GetSetupStatusResponse extends $pb.GeneratedMessage {
  factory GetSetupStatusResponse({
    $core.bool? initialized,
    $core.bool? firstLoginOwner,
  }) {
    final result = GetSetupStatusResponse._();
    if (initialized != null) result.initialized = initialized;
    if (firstLoginOwner != null) result.firstLoginOwner = firstLoginOwner;
    return result;
  }

  GetSetupStatusResponse._();

  factory GetSetupStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusResponse()..mergeFromBuffer(data, registry);
  factory GetSetupStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSetupStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSetupStatusResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'initialized')
    ..aOB(2, _omitFieldNames ? '' : 'firstLoginOwner')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusResponse copyWith(
          void Function(GetSetupStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetSetupStatusResponse))
          as GetSetupStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSetupStatusResponse() / GetSetupStatusResponse.new instead')
  static GetSetupStatusResponse create() => GetSetupStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSetupStatusResponse._();
  @$core.override
  GetSetupStatusResponse createEmptyInstance() => GetSetupStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSetupStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSetupStatusResponse>(
          GetSetupStatusResponse.$_createMessage);
  static GetSetupStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get initialized => $_getBF(0);
  @$pb.TagNumber(1)
  set initialized($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInitialized() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialized() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get firstLoginOwner => $_getBF(1);
  @$pb.TagNumber(2)
  set firstLoginOwner($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFirstLoginOwner() => $_has(1);
  @$pb.TagNumber(2)
  void clearFirstLoginOwner() => $_clearField(2);
}

class ClaimOwnerRequest extends $pb.GeneratedMessage {
  factory ClaimOwnerRequest({
    $core.String? setupCode,
  }) {
    final result = ClaimOwnerRequest._();
    if (setupCode != null) result.setupCode = setupCode;
    return result;
  }

  ClaimOwnerRequest._();

  factory ClaimOwnerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerRequest()..mergeFromBuffer(data, registry);
  factory ClaimOwnerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimOwnerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ClaimOwnerRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'setupCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerRequest copyWith(void Function(ClaimOwnerRequest) updates) =>
      super.copyWith((message) => updates(message as ClaimOwnerRequest))
          as ClaimOwnerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClaimOwnerRequest() / ClaimOwnerRequest.new instead')
  static ClaimOwnerRequest create() => ClaimOwnerRequest._();
  static $pb.GeneratedMessage $_createMessage() => ClaimOwnerRequest._();
  @$core.override
  ClaimOwnerRequest createEmptyInstance() => ClaimOwnerRequest._();
  @$core.pragma('dart2js:noInline')
  static ClaimOwnerRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClaimOwnerRequest>(
          ClaimOwnerRequest.$_createMessage);
  static ClaimOwnerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get setupCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set setupCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetupCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetupCode() => $_clearField(1);
}

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => GetSettingsRequest._();

  GetSettingsRequest._();

  factory GetSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsRequest()..mergeFromBuffer(data, registry);
  factory GetSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSettingsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsRequest))
          as GetSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetSettingsRequest() / GetSettingsRequest.new instead')
  static GetSettingsRequest create() => GetSettingsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSettingsRequest._();
  @$core.override
  GetSettingsRequest createEmptyInstance() => GetSettingsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(
          GetSettingsRequest.$_createMessage);
  static GetSettingsRequest? _defaultInstance;
}

class ClaimOwnerResponse extends $pb.GeneratedMessage {
  factory ClaimOwnerResponse({
    SpaceSettings? settings,
  }) {
    final result = ClaimOwnerResponse._();
    if (settings != null) result.settings = settings;
    return result;
  }

  ClaimOwnerResponse._();

  factory ClaimOwnerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerResponse()..mergeFromBuffer(data, registry);
  factory ClaimOwnerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimOwnerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ClaimOwnerResponse.$_createMessage)
    ..aOM<SpaceSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: SpaceSettings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerResponse copyWith(void Function(ClaimOwnerResponse) updates) =>
      super.copyWith((message) => updates(message as ClaimOwnerResponse))
          as ClaimOwnerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClaimOwnerResponse() / ClaimOwnerResponse.new instead')
  static ClaimOwnerResponse create() => ClaimOwnerResponse._();
  static $pb.GeneratedMessage $_createMessage() => ClaimOwnerResponse._();
  @$core.override
  ClaimOwnerResponse createEmptyInstance() => ClaimOwnerResponse._();
  @$core.pragma('dart2js:noInline')
  static ClaimOwnerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClaimOwnerResponse>(
          ClaimOwnerResponse.$_createMessage);
  static ClaimOwnerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SpaceSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(SpaceSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  SpaceSettings ensureSettings() => $_ensure(0);
}

class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    SpaceSettings? settings,
  }) {
    final result = GetSettingsResponse._();
    if (settings != null) result.settings = settings;
    return result;
  }

  GetSettingsResponse._();

  factory GetSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsResponse()..mergeFromBuffer(data, registry);
  factory GetSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSettingsResponse.$_createMessage)
    ..aOM<SpaceSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: SpaceSettings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSettingsResponse))
          as GetSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetSettingsResponse() / GetSettingsResponse.new instead')
  static GetSettingsResponse create() => GetSettingsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSettingsResponse._();
  @$core.override
  GetSettingsResponse createEmptyInstance() => GetSettingsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(
          GetSettingsResponse.$_createMessage);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SpaceSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(SpaceSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  SpaceSettings ensureSettings() => $_ensure(0);
}

class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    SpaceSettings? settings,
  }) {
    final result = UpdateSettingsResponse._();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsResponse._();

  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsResponse()..mergeFromBuffer(data, registry);
  factory UpdateSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateSettingsResponse.$_createMessage)
    ..aOM<SpaceSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: SpaceSettings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse copyWith(
          void Function(UpdateSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsResponse))
          as UpdateSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateSettingsResponse() / UpdateSettingsResponse.new instead')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateSettingsResponse._();
  @$core.override
  UpdateSettingsResponse createEmptyInstance() => UpdateSettingsResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(
          UpdateSettingsResponse.$_createMessage);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SpaceSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(SpaceSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  SpaceSettings ensureSettings() => $_ensure(0);
}

class ServerIcon extends $pb.GeneratedMessage {
  factory ServerIcon({
    $core.String? preset,
    $core.String? mediaType,
    $core.List<$core.int>? data,
  }) {
    final result = ServerIcon._();
    if (preset != null) result.preset = preset;
    if (mediaType != null) result.mediaType = mediaType;
    if (data != null) result.data = data;
    return result;
  }

  ServerIcon._();

  factory ServerIcon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerIcon()..mergeFromBuffer(data, registry);
  factory ServerIcon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerIcon()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerIcon',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ServerIcon.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'preset')
    ..aOS(2, _omitFieldNames ? '' : 'mediaType')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerIcon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerIcon copyWith(void Function(ServerIcon) updates) =>
      super.copyWith((message) => updates(message as ServerIcon)) as ServerIcon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ServerIcon() / ServerIcon.new instead')
  static ServerIcon create() => ServerIcon._();
  static $pb.GeneratedMessage $_createMessage() => ServerIcon._();
  @$core.override
  ServerIcon createEmptyInstance() => ServerIcon._();
  @$core.pragma('dart2js:noInline')
  static ServerIcon getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerIcon>(ServerIcon.$_createMessage);
  static ServerIcon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get preset => $_getSZ(0);
  @$pb.TagNumber(1)
  set preset($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreset() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
}

class SpaceSettings extends $pb.GeneratedMessage {
  factory SpaceSettings({
    $core.String? title,
    $core.String? chatTitle,
    $core.bool? chatEnabled,
    $core.String? registrationPolicy,
    $fixnum.Int64? revision,
    ServerIcon? icon,
    $fixnum.Int64? storageLimitBytes,
    $fixnum.Int64? memberStorageLimitBytes,
    $core.bool? attachmentsEnabled,
  }) {
    final result = SpaceSettings._();
    if (title != null) result.title = title;
    if (chatTitle != null) result.chatTitle = chatTitle;
    if (chatEnabled != null) result.chatEnabled = chatEnabled;
    if (registrationPolicy != null)
      result.registrationPolicy = registrationPolicy;
    if (revision != null) result.revision = revision;
    if (icon != null) result.icon = icon;
    if (storageLimitBytes != null) result.storageLimitBytes = storageLimitBytes;
    if (memberStorageLimitBytes != null)
      result.memberStorageLimitBytes = memberStorageLimitBytes;
    if (attachmentsEnabled != null)
      result.attachmentsEnabled = attachmentsEnabled;
    return result;
  }

  SpaceSettings._();

  factory SpaceSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpaceSettings()..mergeFromBuffer(data, registry);
  factory SpaceSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpaceSettings()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpaceSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SpaceSettings.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'chatTitle')
    ..aOB(3, _omitFieldNames ? '' : 'chatEnabled')
    ..aOS(4, _omitFieldNames ? '' : 'registrationPolicy')
    ..aInt64(5, _omitFieldNames ? '' : 'revision')
    ..aOM<ServerIcon>(6, _omitFieldNames ? '' : 'icon',
        subBuilder: ServerIcon.$_createMessage)
    ..aInt64(7, _omitFieldNames ? '' : 'storageLimitBytes')
    ..aInt64(8, _omitFieldNames ? '' : 'memberStorageLimitBytes')
    ..aOB(9, _omitFieldNames ? '' : 'attachmentsEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpaceSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpaceSettings copyWith(void Function(SpaceSettings) updates) =>
      super.copyWith((message) => updates(message as SpaceSettings))
          as SpaceSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SpaceSettings() / SpaceSettings.new instead')
  static SpaceSettings create() => SpaceSettings._();
  static $pb.GeneratedMessage $_createMessage() => SpaceSettings._();
  @$core.override
  SpaceSettings createEmptyInstance() => SpaceSettings._();
  @$core.pragma('dart2js:noInline')
  static SpaceSettings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpaceSettings>(
          SpaceSettings.$_createMessage);
  static SpaceSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chatTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set chatTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChatTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearChatTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get chatEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set chatEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChatEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearChatEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get registrationPolicy => $_getSZ(3);
  @$pb.TagNumber(4)
  set registrationPolicy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRegistrationPolicy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegistrationPolicy() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get revision => $_getI64(4);
  @$pb.TagNumber(5)
  set revision($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  ServerIcon get icon => $_getN(5);
  @$pb.TagNumber(6)
  set icon(ServerIcon value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIcon() => $_has(5);
  @$pb.TagNumber(6)
  void clearIcon() => $_clearField(6);
  @$pb.TagNumber(6)
  ServerIcon ensureIcon() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get storageLimitBytes => $_getI64(6);
  @$pb.TagNumber(7)
  set storageLimitBytes($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStorageLimitBytes() => $_has(6);
  @$pb.TagNumber(7)
  void clearStorageLimitBytes() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get memberStorageLimitBytes => $_getI64(7);
  @$pb.TagNumber(8)
  set memberStorageLimitBytes($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMemberStorageLimitBytes() => $_has(7);
  @$pb.TagNumber(8)
  void clearMemberStorageLimitBytes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get attachmentsEnabled => $_getBF(8);
  @$pb.TagNumber(9)
  set attachmentsEnabled($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAttachmentsEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearAttachmentsEnabled() => $_clearField(9);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    $core.String? title,
    $core.String? chatTitle,
    $core.bool? chatEnabled,
    $core.String? registrationPolicy,
    $fixnum.Int64? expectedRevision,
    ServerIcon? icon,
    $fixnum.Int64? storageLimitBytes,
    $fixnum.Int64? memberStorageLimitBytes,
    $core.bool? attachmentsEnabled,
  }) {
    final result = UpdateSettingsRequest._();
    if (title != null) result.title = title;
    if (chatTitle != null) result.chatTitle = chatTitle;
    if (chatEnabled != null) result.chatEnabled = chatEnabled;
    if (registrationPolicy != null)
      result.registrationPolicy = registrationPolicy;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (icon != null) result.icon = icon;
    if (storageLimitBytes != null) result.storageLimitBytes = storageLimitBytes;
    if (memberStorageLimitBytes != null)
      result.memberStorageLimitBytes = memberStorageLimitBytes;
    if (attachmentsEnabled != null)
      result.attachmentsEnabled = attachmentsEnabled;
    return result;
  }

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsRequest()..mergeFromBuffer(data, registry);
  factory UpdateSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateSettingsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'chatTitle')
    ..aOB(3, _omitFieldNames ? '' : 'chatEnabled')
    ..aOS(4, _omitFieldNames ? '' : 'registrationPolicy')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedRevision')
    ..aOM<ServerIcon>(6, _omitFieldNames ? '' : 'icon',
        subBuilder: ServerIcon.$_createMessage)
    ..aInt64(7, _omitFieldNames ? '' : 'storageLimitBytes')
    ..aInt64(8, _omitFieldNames ? '' : 'memberStorageLimitBytes')
    ..aOB(9, _omitFieldNames ? '' : 'attachmentsEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest copyWith(
          void Function(UpdateSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsRequest))
          as UpdateSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateSettingsRequest() / UpdateSettingsRequest.new instead')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateSettingsRequest._();
  @$core.override
  UpdateSettingsRequest createEmptyInstance() => UpdateSettingsRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(
          UpdateSettingsRequest.$_createMessage);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chatTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set chatTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChatTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearChatTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get chatEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set chatEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChatEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearChatEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get registrationPolicy => $_getSZ(3);
  @$pb.TagNumber(4)
  set registrationPolicy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRegistrationPolicy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegistrationPolicy() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expectedRevision => $_getI64(4);
  @$pb.TagNumber(5)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpectedRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpectedRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  ServerIcon get icon => $_getN(5);
  @$pb.TagNumber(6)
  set icon(ServerIcon value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIcon() => $_has(5);
  @$pb.TagNumber(6)
  void clearIcon() => $_clearField(6);
  @$pb.TagNumber(6)
  ServerIcon ensureIcon() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get storageLimitBytes => $_getI64(6);
  @$pb.TagNumber(7)
  set storageLimitBytes($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStorageLimitBytes() => $_has(6);
  @$pb.TagNumber(7)
  void clearStorageLimitBytes() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get memberStorageLimitBytes => $_getI64(7);
  @$pb.TagNumber(8)
  set memberStorageLimitBytes($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMemberStorageLimitBytes() => $_has(7);
  @$pb.TagNumber(8)
  void clearMemberStorageLimitBytes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get attachmentsEnabled => $_getBF(8);
  @$pb.TagNumber(9)
  set attachmentsEnabled($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAttachmentsEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearAttachmentsEnabled() => $_clearField(9);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = SubscribeRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  SubscribeRequest._();

  factory SubscribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeRequest()..mergeFromBuffer(data, registry);
  factory SubscribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SubscribeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest))
          as SubscribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SubscribeRequest() / SubscribeRequest.new instead')
  static SubscribeRequest create() => SubscribeRequest._();
  static $pb.GeneratedMessage $_createMessage() => SubscribeRequest._();
  @$core.override
  SubscribeRequest createEmptyInstance() => SubscribeRequest._();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(
          SubscribeRequest.$_createMessage);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class SubscribeResponse extends $pb.GeneratedMessage {
  factory SubscribeResponse({
    Event? event,
    $core.String? cursor,
    $core.bool? heartbeat,
  }) {
    final result = SubscribeResponse._();
    if (event != null) result.event = event;
    if (cursor != null) result.cursor = cursor;
    if (heartbeat != null) result.heartbeat = heartbeat;
    return result;
  }

  SubscribeResponse._();

  factory SubscribeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeResponse()..mergeFromBuffer(data, registry);
  factory SubscribeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SubscribeResponse.$_createMessage)
    ..aOM<Event>(1, _omitFieldNames ? '' : 'event',
        subBuilder: Event.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'heartbeat')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeResponse copyWith(void Function(SubscribeResponse) updates) =>
      super.copyWith((message) => updates(message as SubscribeResponse))
          as SubscribeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SubscribeResponse() / SubscribeResponse.new instead')
  static SubscribeResponse create() => SubscribeResponse._();
  static $pb.GeneratedMessage $_createMessage() => SubscribeResponse._();
  @$core.override
  SubscribeResponse createEmptyInstance() => SubscribeResponse._();
  @$core.pragma('dart2js:noInline')
  static SubscribeResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeResponse>(
          SubscribeResponse.$_createMessage);
  static SubscribeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Event get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(Event value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  Event ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get heartbeat => $_getBF(2);
  @$pb.TagNumber(3)
  set heartbeat($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeartbeat() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeartbeat() => $_clearField(3);
}

class CreateChallengeRequest extends $pb.GeneratedMessage {
  factory CreateChallengeRequest({
    $core.String? purpose,
    $core.List<$core.int>? rootPublicKey,
    $core.List<$core.int>? devicePublicKey,
    $core.String? grantId,
    $core.bool? administrative,
    $core.bool? recovery,
    $core.String? recoveryGrantId,
    $core.String? pairingId,
  }) {
    final result = CreateChallengeRequest._();
    if (purpose != null) result.purpose = purpose;
    if (rootPublicKey != null) result.rootPublicKey = rootPublicKey;
    if (devicePublicKey != null) result.devicePublicKey = devicePublicKey;
    if (grantId != null) result.grantId = grantId;
    if (administrative != null) result.administrative = administrative;
    if (recovery != null) result.recovery = recovery;
    if (recoveryGrantId != null) result.recoveryGrantId = recoveryGrantId;
    if (pairingId != null) result.pairingId = pairingId;
    return result;
  }

  CreateChallengeRequest._();

  factory CreateChallengeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeRequest()..mergeFromBuffer(data, registry);
  factory CreateChallengeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChallengeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateChallengeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'purpose')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'rootPublicKey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'devicePublicKey', $pb.PbFieldType.OY)
    ..aOS(4, _omitFieldNames ? '' : 'grantId')
    ..aOB(5, _omitFieldNames ? '' : 'administrative')
    ..aOB(6, _omitFieldNames ? '' : 'recovery')
    ..aOS(7, _omitFieldNames ? '' : 'recoveryGrantId')
    ..aOS(8, _omitFieldNames ? '' : 'pairingId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeRequest copyWith(
          void Function(CreateChallengeRequest) updates) =>
      super.copyWith((message) => updates(message as CreateChallengeRequest))
          as CreateChallengeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateChallengeRequest() / CreateChallengeRequest.new instead')
  static CreateChallengeRequest create() => CreateChallengeRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateChallengeRequest._();
  @$core.override
  CreateChallengeRequest createEmptyInstance() => CreateChallengeRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateChallengeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChallengeRequest>(
          CreateChallengeRequest.$_createMessage);
  static CreateChallengeRequest? _defaultInstance;

  /// device.register / auth.login / device.revoke.
  @$pb.TagNumber(1)
  $core.String get purpose => $_getSZ(0);
  @$pb.TagNumber(1)
  set purpose($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurpose() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurpose() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get rootPublicKey => $_getN(1);
  @$pb.TagNumber(2)
  set rootPublicKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRootPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearRootPublicKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get devicePublicKey => $_getN(2);
  @$pb.TagNumber(3)
  set devicePublicKey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDevicePublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevicePublicKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get grantId => $_getSZ(3);
  @$pb.TagNumber(4)
  set grantId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGrantId() => $_has(3);
  @$pb.TagNumber(4)
  void clearGrantId() => $_clearField(4);

  /// Только регистрация: root явно разрешает space.manage этому устройству.
  @$pb.TagNumber(5)
  $core.bool get administrative => $_getBF(4);
  @$pb.TagNumber(5)
  set administrative($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdministrative() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdministrative() => $_clearField(5);

  /// Root явно делегирует восстановление отдельному ключу.
  @$pb.TagNumber(6)
  $core.bool get recovery => $_getBF(5);
  @$pb.TagNumber(6)
  set recovery($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecovery() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecovery() => $_clearField(6);

  /// device.delegate / recovery.device.revoke: действующий recovery grant.
  @$pb.TagNumber(7)
  $core.String get recoveryGrantId => $_getSZ(6);
  @$pb.TagNumber(7)
  set recoveryGrantId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecoveryGrantId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecoveryGrantId() => $_clearField(7);

  /// Root-подписанное сопряжение с неизменяемым целевым public key.
  @$pb.TagNumber(8)
  $core.String get pairingId => $_getSZ(7);
  @$pb.TagNumber(8)
  set pairingId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPairingId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPairingId() => $_clearField(8);
}

class CreateChallengeResponse extends $pb.GeneratedMessage {
  factory CreateChallengeResponse({
    $core.String? challengeId,
    $core.List<$core.int>? transcript,
    $core.Iterable<RootHistoryProof>? rootHistory,
    RetentionProof? retentionProof,
  }) {
    final result = CreateChallengeResponse._();
    if (challengeId != null) result.challengeId = challengeId;
    if (transcript != null) result.transcript = transcript;
    if (rootHistory != null) result.rootHistory.addAll(rootHistory);
    if (retentionProof != null) result.retentionProof = retentionProof;
    return result;
  }

  CreateChallengeResponse._();

  factory CreateChallengeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeResponse()..mergeFromBuffer(data, registry);
  factory CreateChallengeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChallengeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateChallengeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'challengeId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'transcript', $pb.PbFieldType.OY)
    ..pPM<RootHistoryProof>(3, _omitFieldNames ? '' : 'rootHistory',
        subBuilder: RootHistoryProof.$_createMessage)
    ..aOM<RetentionProof>(4, _omitFieldNames ? '' : 'retentionProof',
        subBuilder: RetentionProof.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeResponse copyWith(
          void Function(CreateChallengeResponse) updates) =>
      super.copyWith((message) => updates(message as CreateChallengeResponse))
          as CreateChallengeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateChallengeResponse() / CreateChallengeResponse.new instead')
  static CreateChallengeResponse create() => CreateChallengeResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateChallengeResponse._();
  @$core.override
  CreateChallengeResponse createEmptyInstance() => CreateChallengeResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateChallengeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChallengeResponse>(
          CreateChallengeResponse.$_createMessage);
  static CreateChallengeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get challengeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set challengeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallengeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallengeId() => $_clearField(1);

  /// Клиент проверяет поля и восстанавливает байты по фиксированному профилю.
  @$pb.TagNumber(2)
  $core.List<$core.int> get transcript => $_getN(1);
  @$pb.TagNumber(2)
  set transcript($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTranscript() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranscript() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<RootHistoryProof> get rootHistory => $_getList(2);

  @$pb.TagNumber(4)
  RetentionProof get retentionProof => $_getN(3);
  @$pb.TagNumber(4)
  set retentionProof(RetentionProof value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRetentionProof() => $_has(3);
  @$pb.TagNumber(4)
  void clearRetentionProof() => $_clearField(4);
  @$pb.TagNumber(4)
  RetentionProof ensureRetentionProof() => $_ensure(3);
}

class CompleteChallengeRequest extends $pb.GeneratedMessage {
  factory CompleteChallengeRequest({
    $core.String? challengeId,
    $core.List<$core.int>? signature,
    $core.String? invitationToken,
  }) {
    final result = CompleteChallengeRequest._();
    if (challengeId != null) result.challengeId = challengeId;
    if (signature != null) result.signature = signature;
    if (invitationToken != null) result.invitationToken = invitationToken;
    return result;
  }

  CompleteChallengeRequest._();

  factory CompleteChallengeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeRequest()..mergeFromBuffer(data, registry);
  factory CompleteChallengeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteChallengeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteChallengeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'challengeId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'invitationToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeRequest copyWith(
          void Function(CompleteChallengeRequest) updates) =>
      super.copyWith((message) => updates(message as CompleteChallengeRequest))
          as CompleteChallengeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteChallengeRequest() / CompleteChallengeRequest.new instead')
  static CompleteChallengeRequest create() => CompleteChallengeRequest._();
  static $pb.GeneratedMessage $_createMessage() => CompleteChallengeRequest._();
  @$core.override
  CompleteChallengeRequest createEmptyInstance() =>
      CompleteChallengeRequest._();
  @$core.pragma('dart2js:noInline')
  static CompleteChallengeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteChallengeRequest>(
          CompleteChallengeRequest.$_createMessage);
  static CompleteChallengeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get challengeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set challengeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallengeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallengeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signature => $_getN(1);
  @$pb.TagNumber(2)
  set signature($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignature() => $_clearField(2);

  /// Только device.register: вступление атомарно с регистрацией устройства.
  @$pb.TagNumber(3)
  $core.String get invitationToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set invitationToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInvitationToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearInvitationToken() => $_clearField(3);
}

class CompleteChallengeResponse extends $pb.GeneratedMessage {
  factory CompleteChallengeResponse({
    $core.String? grantId,
    $core.String? principalId,
    $core.String? accessToken,
    $fixnum.Int64? expiresAt,
  }) {
    final result = CompleteChallengeResponse._();
    if (grantId != null) result.grantId = grantId;
    if (principalId != null) result.principalId = principalId;
    if (accessToken != null) result.accessToken = accessToken;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  CompleteChallengeResponse._();

  factory CompleteChallengeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeResponse()..mergeFromBuffer(data, registry);
  factory CompleteChallengeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteChallengeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteChallengeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'grantId')
    ..aOS(2, _omitFieldNames ? '' : 'principalId')
    ..aOS(3, _omitFieldNames ? '' : 'accessToken')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeResponse copyWith(
          void Function(CompleteChallengeResponse) updates) =>
      super.copyWith((message) => updates(message as CompleteChallengeResponse))
          as CompleteChallengeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteChallengeResponse() / CompleteChallengeResponse.new instead')
  static CompleteChallengeResponse create() => CompleteChallengeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompleteChallengeResponse._();
  @$core.override
  CompleteChallengeResponse createEmptyInstance() =>
      CompleteChallengeResponse._();
  @$core.pragma('dart2js:noInline')
  static CompleteChallengeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteChallengeResponse>(
          CompleteChallengeResponse.$_createMessage);
  static CompleteChallengeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get grantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set grantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGrantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGrantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get principalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set principalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrincipalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get accessToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set accessToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccessToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccessToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

class ListEventsRequest extends $pb.GeneratedMessage {
  factory ListEventsRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = ListEventsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  ListEventsRequest._();

  factory ListEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsRequest()..mergeFromBuffer(data, registry);
  factory ListEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEventsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListEventsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsRequest copyWith(void Function(ListEventsRequest) updates) =>
      super.copyWith((message) => updates(message as ListEventsRequest))
          as ListEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListEventsRequest() / ListEventsRequest.new instead')
  static ListEventsRequest create() => ListEventsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListEventsRequest._();
  @$core.override
  ListEventsRequest createEmptyInstance() => ListEventsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListEventsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListEventsRequest>(
          ListEventsRequest.$_createMessage);
  static ListEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class ListEventsResponse extends $pb.GeneratedMessage {
  factory ListEventsResponse({
    $core.Iterable<Event>? events,
    $core.String? nextCursor,
  }) {
    final result = ListEventsResponse._();
    if (events != null) result.events.addAll(events);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListEventsResponse._();

  factory ListEventsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsResponse()..mergeFromBuffer(data, registry);
  factory ListEventsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEventsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListEventsResponse.$_createMessage)
    ..pPM<Event>(1, _omitFieldNames ? '' : 'events',
        subBuilder: Event.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsResponse copyWith(void Function(ListEventsResponse) updates) =>
      super.copyWith((message) => updates(message as ListEventsResponse))
          as ListEventsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListEventsResponse() / ListEventsResponse.new instead')
  static ListEventsResponse create() => ListEventsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListEventsResponse._();
  @$core.override
  ListEventsResponse createEmptyInstance() => ListEventsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListEventsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEventsResponse>(
          ListEventsResponse.$_createMessage);
  static ListEventsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Event> get events => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class Event extends $pb.GeneratedMessage {
  factory Event({
    $core.String? cursor,
    $core.String? type,
    Content? content,
  }) {
    final result = Event._();
    if (cursor != null) result.cursor = cursor;
    if (type != null) result.type = type;
    if (content != null) result.content = content;
    return result;
  }

  Event._();

  factory Event.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Event()..mergeFromBuffer(data, registry);
  factory Event.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Event()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Event',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Event.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cursor')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOM<Content>(3, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event copyWith(void Function(Event) updates) =>
      super.copyWith((message) => updates(message as Event)) as Event;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Event() / Event.new instead')
  static Event create() => Event._();
  static $pb.GeneratedMessage $_createMessage() => Event._();
  @$core.override
  Event createEmptyInstance() => Event._();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Event>(Event.$_createMessage);
  static Event? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cursor => $_getSZ(0);
  @$pb.TagNumber(1)
  set cursor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  Content get content => $_getN(2);
  @$pb.TagNumber(3)
  set content(Content value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);
  @$pb.TagNumber(3)
  Content ensureContent() => $_ensure(2);
}

class GetManifestRequest extends $pb.GeneratedMessage {
  factory GetManifestRequest() => GetManifestRequest._();

  GetManifestRequest._();

  factory GetManifestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestRequest()..mergeFromBuffer(data, registry);
  factory GetManifestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetManifestRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetManifestRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestRequest copyWith(void Function(GetManifestRequest) updates) =>
      super.copyWith((message) => updates(message as GetManifestRequest))
          as GetManifestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetManifestRequest() / GetManifestRequest.new instead')
  static GetManifestRequest create() => GetManifestRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetManifestRequest._();
  @$core.override
  GetManifestRequest createEmptyInstance() => GetManifestRequest._();
  @$core.pragma('dart2js:noInline')
  static GetManifestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetManifestRequest>(
          GetManifestRequest.$_createMessage);
  static GetManifestRequest? _defaultInstance;
}

class GetManifestResponse extends $pb.GeneratedMessage {
  factory GetManifestResponse({
    $core.String? protocolVersion,
    $core.String? serverId,
    $core.Iterable<Channel>? channels,
    $core.String? title,
    ServerIcon? icon,
    $core.bool? attachmentsEnabled,
    $core.bool? mlsSupported,
    $core.bool? ordinaryRepliesSupported,
    $core.Iterable<$core.String>? capabilities,
  }) {
    final result = GetManifestResponse._();
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    if (serverId != null) result.serverId = serverId;
    if (channels != null) result.channels.addAll(channels);
    if (title != null) result.title = title;
    if (icon != null) result.icon = icon;
    if (attachmentsEnabled != null)
      result.attachmentsEnabled = attachmentsEnabled;
    if (mlsSupported != null) result.mlsSupported = mlsSupported;
    if (ordinaryRepliesSupported != null)
      result.ordinaryRepliesSupported = ordinaryRepliesSupported;
    if (capabilities != null) result.capabilities.addAll(capabilities);
    return result;
  }

  GetManifestResponse._();

  factory GetManifestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestResponse()..mergeFromBuffer(data, registry);
  factory GetManifestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetManifestResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetManifestResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'protocolVersion')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..pPM<Channel>(3, _omitFieldNames ? '' : 'channels',
        subBuilder: Channel.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOM<ServerIcon>(5, _omitFieldNames ? '' : 'icon',
        subBuilder: ServerIcon.$_createMessage)
    ..aOB(6, _omitFieldNames ? '' : 'attachmentsEnabled')
    ..aOB(7, _omitFieldNames ? '' : 'mlsSupported')
    ..aOB(8, _omitFieldNames ? '' : 'ordinaryRepliesSupported')
    ..pPS(9, _omitFieldNames ? '' : 'capabilities')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestResponse copyWith(void Function(GetManifestResponse) updates) =>
      super.copyWith((message) => updates(message as GetManifestResponse))
          as GetManifestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetManifestResponse() / GetManifestResponse.new instead')
  static GetManifestResponse create() => GetManifestResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetManifestResponse._();
  @$core.override
  GetManifestResponse createEmptyInstance() => GetManifestResponse._();
  @$core.pragma('dart2js:noInline')
  static GetManifestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetManifestResponse>(
          GetManifestResponse.$_createMessage);
  static GetManifestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get protocolVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set protocolVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProtocolVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearProtocolVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Channel> get channels => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  ServerIcon get icon => $_getN(4);
  @$pb.TagNumber(5)
  set icon(ServerIcon value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearIcon() => $_clearField(5);
  @$pb.TagNumber(5)
  ServerIcon ensureIcon() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get attachmentsEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set attachmentsEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAttachmentsEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttachmentsEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get mlsSupported => $_getBF(6);
  @$pb.TagNumber(7)
  set mlsSupported($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMlsSupported() => $_has(6);
  @$pb.TagNumber(7)
  void clearMlsSupported() => $_clearField(7);

  /// Только ответы обычных каналов. MLS-ответы согласуются отдельно.
  @$pb.TagNumber(8)
  $core.bool get ordinaryRepliesSupported => $_getBF(7);
  @$pb.TagNumber(8)
  set ordinaryRepliesSupported($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOrdinaryRepliesSupported() => $_has(7);
  @$pb.TagNumber(8)
  void clearOrdinaryRepliesSupported() => $_clearField(8);

  /// Поддерживаемые расширения, например core.forum.v1.
  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get capabilities => $_getList(8);
}

class Channel extends $pb.GeneratedMessage {
  factory Channel({
    $core.String? id,
    $core.String? title,
    $core.Iterable<View>? views,
    $core.int? position,
    $core.bool? archived,
    $fixnum.Int64? revision,
    ChannelPermissions? permissions,
    $core.bool? publicPreview,
    $fixnum.Int64? latestMessageSequence,
    $core.List<$core.int>? mlsGroupId,
    $core.int? voiceCapacity,
  }) {
    final result = Channel._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (views != null) result.views.addAll(views);
    if (position != null) result.position = position;
    if (archived != null) result.archived = archived;
    if (revision != null) result.revision = revision;
    if (permissions != null) result.permissions = permissions;
    if (publicPreview != null) result.publicPreview = publicPreview;
    if (latestMessageSequence != null)
      result.latestMessageSequence = latestMessageSequence;
    if (mlsGroupId != null) result.mlsGroupId = mlsGroupId;
    if (voiceCapacity != null) result.voiceCapacity = voiceCapacity;
    return result;
  }

  Channel._();

  factory Channel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Channel()..mergeFromBuffer(data, registry);
  factory Channel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Channel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Channel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Channel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..pPM<View>(3, _omitFieldNames ? '' : 'views',
        subBuilder: View.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'position')
    ..aOB(5, _omitFieldNames ? '' : 'archived')
    ..aInt64(6, _omitFieldNames ? '' : 'revision')
    ..aOM<ChannelPermissions>(7, _omitFieldNames ? '' : 'permissions',
        subBuilder: ChannelPermissions.$_createMessage)
    ..aOB(8, _omitFieldNames ? '' : 'publicPreview')
    ..aInt64(9, _omitFieldNames ? '' : 'latestMessageSequence')
    ..a<$core.List<$core.int>>(
        10, _omitFieldNames ? '' : 'mlsGroupId', $pb.PbFieldType.OY)
    ..aI(11, _omitFieldNames ? '' : 'voiceCapacity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Channel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Channel copyWith(void Function(Channel) updates) =>
      super.copyWith((message) => updates(message as Channel)) as Channel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Channel() / Channel.new instead')
  static Channel create() => Channel._();
  static $pb.GeneratedMessage $_createMessage() => Channel._();
  @$core.override
  Channel createEmptyInstance() => Channel._();
  @$core.pragma('dart2js:noInline')
  static Channel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Channel>(Channel.$_createMessage);
  static Channel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<View> get views => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get position => $_getIZ(3);
  @$pb.TagNumber(4)
  set position($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get archived => $_getBF(4);
  @$pb.TagNumber(5)
  set archived($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasArchived() => $_has(4);
  @$pb.TagNumber(5)
  void clearArchived() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get revision => $_getI64(5);
  @$pb.TagNumber(6)
  set revision($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearRevision() => $_clearField(6);

  @$pb.TagNumber(7)
  ChannelPermissions get permissions => $_getN(6);
  @$pb.TagNumber(7)
  set permissions(ChannelPermissions value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPermissions() => $_has(6);
  @$pb.TagNumber(7)
  void clearPermissions() => $_clearField(7);
  @$pb.TagNumber(7)
  ChannelPermissions ensurePermissions() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get publicPreview => $_getBF(7);
  @$pb.TagNumber(8)
  set publicPreview($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPublicPreview() => $_has(7);
  @$pb.TagNumber(8)
  void clearPublicPreview() => $_clearField(8);

  /// Только для авторизованного read; иначе 0.
  @$pb.TagNumber(9)
  $fixnum.Int64 get latestMessageSequence => $_getI64(8);
  @$pb.TagNumber(9)
  set latestMessageSequence($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLatestMessageSequence() => $_has(8);
  @$pb.TagNumber(9)
  void clearLatestMessageSequence() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.List<$core.int> get mlsGroupId => $_getN(9);
  @$pb.TagNumber(10)
  set mlsGroupId($core.List<$core.int> value) => $_setBytes(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMlsGroupId() => $_has(9);
  @$pb.TagNumber(10)
  void clearMlsGroupId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get voiceCapacity => $_getIZ(10);
  @$pb.TagNumber(11)
  set voiceCapacity($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVoiceCapacity() => $_has(10);
  @$pb.TagNumber(11)
  void clearVoiceCapacity() => $_clearField(11);
}

/// write требует read, read и manage требуют visible.
class ChannelPermissions extends $pb.GeneratedMessage {
  factory ChannelPermissions({
    $core.bool? visible,
    $core.bool? read,
    $core.bool? write,
    $core.bool? manage,
  }) {
    final result = ChannelPermissions._();
    if (visible != null) result.visible = visible;
    if (read != null) result.read = read;
    if (write != null) result.write = write;
    if (manage != null) result.manage = manage;
    return result;
  }

  ChannelPermissions._();

  factory ChannelPermissions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelPermissions()..mergeFromBuffer(data, registry);
  factory ChannelPermissions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelPermissions()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelPermissions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ChannelPermissions.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'visible')
    ..aOB(2, _omitFieldNames ? '' : 'read')
    ..aOB(3, _omitFieldNames ? '' : 'write')
    ..aOB(4, _omitFieldNames ? '' : 'manage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelPermissions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelPermissions copyWith(void Function(ChannelPermissions) updates) =>
      super.copyWith((message) => updates(message as ChannelPermissions))
          as ChannelPermissions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChannelPermissions() / ChannelPermissions.new instead')
  static ChannelPermissions create() => ChannelPermissions._();
  static $pb.GeneratedMessage $_createMessage() => ChannelPermissions._();
  @$core.override
  ChannelPermissions createEmptyInstance() => ChannelPermissions._();
  @$core.pragma('dart2js:noInline')
  static ChannelPermissions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChannelPermissions>(
          ChannelPermissions.$_createMessage);
  static ChannelPermissions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get visible => $_getBF(0);
  @$pb.TagNumber(1)
  set visible($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisible() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisible() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get read => $_getBF(1);
  @$pb.TagNumber(2)
  set read($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRead() => $_has(1);
  @$pb.TagNumber(2)
  void clearRead() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get write => $_getBF(2);
  @$pb.TagNumber(3)
  set write($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWrite() => $_has(2);
  @$pb.TagNumber(3)
  void clearWrite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get manage => $_getBF(3);
  @$pb.TagNumber(4)
  set manage($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasManage() => $_has(3);
  @$pb.TagNumber(4)
  void clearManage() => $_clearField(4);
}

/// Ровно один субъект: role (member/reader) или principal_id.
class ChannelAccessRule extends $pb.GeneratedMessage {
  factory ChannelAccessRule({
    $core.String? role,
    $core.String? principalId,
    ChannelPermissions? permissions,
  }) {
    final result = ChannelAccessRule._();
    if (role != null) result.role = role;
    if (principalId != null) result.principalId = principalId;
    if (permissions != null) result.permissions = permissions;
    return result;
  }

  ChannelAccessRule._();

  factory ChannelAccessRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelAccessRule()..mergeFromBuffer(data, registry);
  factory ChannelAccessRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelAccessRule()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelAccessRule',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ChannelAccessRule.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aOS(2, _omitFieldNames ? '' : 'principalId')
    ..aOM<ChannelPermissions>(3, _omitFieldNames ? '' : 'permissions',
        subBuilder: ChannelPermissions.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelAccessRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelAccessRule copyWith(void Function(ChannelAccessRule) updates) =>
      super.copyWith((message) => updates(message as ChannelAccessRule))
          as ChannelAccessRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChannelAccessRule() / ChannelAccessRule.new instead')
  static ChannelAccessRule create() => ChannelAccessRule._();
  static $pb.GeneratedMessage $_createMessage() => ChannelAccessRule._();
  @$core.override
  ChannelAccessRule createEmptyInstance() => ChannelAccessRule._();
  @$core.pragma('dart2js:noInline')
  static ChannelAccessRule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChannelAccessRule>(
          ChannelAccessRule.$_createMessage);
  static ChannelAccessRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get principalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set principalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrincipalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalId() => $_clearField(2);

  @$pb.TagNumber(3)
  ChannelPermissions get permissions => $_getN(2);
  @$pb.TagNumber(3)
  set permissions(ChannelPermissions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPermissions() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissions() => $_clearField(3);
  @$pb.TagNumber(3)
  ChannelPermissions ensurePermissions() => $_ensure(2);
}

class ListChannelsRequest extends $pb.GeneratedMessage {
  factory ListChannelsRequest({
    $core.bool? includeArchived,
  }) {
    final result = ListChannelsRequest._();
    if (includeArchived != null) result.includeArchived = includeArchived;
    return result;
  }

  ListChannelsRequest._();

  factory ListChannelsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelsRequest()..mergeFromBuffer(data, registry);
  factory ListChannelsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChannelsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListChannelsRequest.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'includeArchived')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelsRequest copyWith(void Function(ListChannelsRequest) updates) =>
      super.copyWith((message) => updates(message as ListChannelsRequest))
          as ListChannelsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListChannelsRequest() / ListChannelsRequest.new instead')
  static ListChannelsRequest create() => ListChannelsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListChannelsRequest._();
  @$core.override
  ListChannelsRequest createEmptyInstance() => ListChannelsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListChannelsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChannelsRequest>(
          ListChannelsRequest.$_createMessage);
  static ListChannelsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get includeArchived => $_getBF(0);
  @$pb.TagNumber(1)
  set includeArchived($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeArchived() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeArchived() => $_clearField(1);
}

class ListChannelsResponse extends $pb.GeneratedMessage {
  factory ListChannelsResponse({
    $core.Iterable<Channel>? channels,
  }) {
    final result = ListChannelsResponse._();
    if (channels != null) result.channels.addAll(channels);
    return result;
  }

  ListChannelsResponse._();

  factory ListChannelsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelsResponse()..mergeFromBuffer(data, registry);
  factory ListChannelsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChannelsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListChannelsResponse.$_createMessage)
    ..pPM<Channel>(1, _omitFieldNames ? '' : 'channels',
        subBuilder: Channel.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelsResponse copyWith(void Function(ListChannelsResponse) updates) =>
      super.copyWith((message) => updates(message as ListChannelsResponse))
          as ListChannelsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListChannelsResponse() / ListChannelsResponse.new instead')
  static ListChannelsResponse create() => ListChannelsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListChannelsResponse._();
  @$core.override
  ListChannelsResponse createEmptyInstance() => ListChannelsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListChannelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChannelsResponse>(
          ListChannelsResponse.$_createMessage);
  static ListChannelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Channel> get channels => $_getList(0);
}

class CreateChannelRequest extends $pb.GeneratedMessage {
  factory CreateChannelRequest({
    $core.String? channelId,
    $core.String? title,
    $core.String? viewType,
    $core.int? position,
    $core.bool? publicPreview,
    $core.List<$core.int>? mlsGroupId,
    $core.int? voiceCapacity,
  }) {
    final result = CreateChannelRequest._();
    if (channelId != null) result.channelId = channelId;
    if (title != null) result.title = title;
    if (viewType != null) result.viewType = viewType;
    if (position != null) result.position = position;
    if (publicPreview != null) result.publicPreview = publicPreview;
    if (mlsGroupId != null) result.mlsGroupId = mlsGroupId;
    if (voiceCapacity != null) result.voiceCapacity = voiceCapacity;
    return result;
  }

  CreateChannelRequest._();

  factory CreateChannelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChannelRequest()..mergeFromBuffer(data, registry);
  factory CreateChannelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChannelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChannelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateChannelRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'viewType')
    ..aI(4, _omitFieldNames ? '' : 'position')
    ..aOB(5, _omitFieldNames ? '' : 'publicPreview')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'mlsGroupId', $pb.PbFieldType.OY)
    ..aI(7, _omitFieldNames ? '' : 'voiceCapacity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChannelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChannelRequest copyWith(void Function(CreateChannelRequest) updates) =>
      super.copyWith((message) => updates(message as CreateChannelRequest))
          as CreateChannelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateChannelRequest() / CreateChannelRequest.new instead')
  static CreateChannelRequest create() => CreateChannelRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateChannelRequest._();
  @$core.override
  CreateChannelRequest createEmptyInstance() => CreateChannelRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateChannelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChannelRequest>(
          CreateChannelRequest.$_createMessage);
  static CreateChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get viewType => $_getSZ(2);
  @$pb.TagNumber(3)
  set viewType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasViewType() => $_has(2);
  @$pb.TagNumber(3)
  void clearViewType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get position => $_getIZ(3);
  @$pb.TagNumber(4)
  set position($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get publicPreview => $_getBF(4);
  @$pb.TagNumber(5)
  set publicPreview($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPublicPreview() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicPreview() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get mlsGroupId => $_getN(5);
  @$pb.TagNumber(6)
  set mlsGroupId($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMlsGroupId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMlsGroupId() => $_clearField(6);

  /// 0 сохраняет значение по умолчанию: 8. Только для voice_room.
  @$pb.TagNumber(7)
  $core.int get voiceCapacity => $_getIZ(6);
  @$pb.TagNumber(7)
  set voiceCapacity($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVoiceCapacity() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoiceCapacity() => $_clearField(7);
}

class UpdateChannelRequest extends $pb.GeneratedMessage {
  factory UpdateChannelRequest({
    $core.String? channelId,
    $core.String? title,
    $core.int? position,
    $core.bool? archived,
    $core.bool? publicPreview,
    $fixnum.Int64? expectedRevision,
    $core.int? voiceCapacity,
  }) {
    final result = UpdateChannelRequest._();
    if (channelId != null) result.channelId = channelId;
    if (title != null) result.title = title;
    if (position != null) result.position = position;
    if (archived != null) result.archived = archived;
    if (publicPreview != null) result.publicPreview = publicPreview;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (voiceCapacity != null) result.voiceCapacity = voiceCapacity;
    return result;
  }

  UpdateChannelRequest._();

  factory UpdateChannelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelRequest()..mergeFromBuffer(data, registry);
  factory UpdateChannelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateChannelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateChannelRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aI(3, _omitFieldNames ? '' : 'position')
    ..aOB(4, _omitFieldNames ? '' : 'archived')
    ..aOB(5, _omitFieldNames ? '' : 'publicPreview')
    ..aInt64(6, _omitFieldNames ? '' : 'expectedRevision')
    ..aI(7, _omitFieldNames ? '' : 'voiceCapacity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelRequest copyWith(void Function(UpdateChannelRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateChannelRequest))
          as UpdateChannelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateChannelRequest() / UpdateChannelRequest.new instead')
  static UpdateChannelRequest create() => UpdateChannelRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateChannelRequest._();
  @$core.override
  UpdateChannelRequest createEmptyInstance() => UpdateChannelRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateChannelRequest>(
          UpdateChannelRequest.$_createMessage);
  static UpdateChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get position => $_getIZ(2);
  @$pb.TagNumber(3)
  set position($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get archived => $_getBF(3);
  @$pb.TagNumber(4)
  set archived($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasArchived() => $_has(3);
  @$pb.TagNumber(4)
  void clearArchived() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get publicPreview => $_getBF(4);
  @$pb.TagNumber(5)
  set publicPreview($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPublicPreview() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicPreview() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expectedRevision => $_getI64(5);
  @$pb.TagNumber(6)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedRevision() => $_clearField(6);

  /// 0 оставляет прежний лимит. Допустимо 2..32.
  @$pb.TagNumber(7)
  $core.int get voiceCapacity => $_getIZ(6);
  @$pb.TagNumber(7)
  set voiceCapacity($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVoiceCapacity() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoiceCapacity() => $_clearField(7);
}

class DeleteChannelRequest extends $pb.GeneratedMessage {
  factory DeleteChannelRequest({
    $core.String? channelId,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = DeleteChannelRequest._();
    if (channelId != null) result.channelId = channelId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  DeleteChannelRequest._();

  factory DeleteChannelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteChannelRequest()..mergeFromBuffer(data, registry);
  factory DeleteChannelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteChannelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteChannelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: DeleteChannelRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChannelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChannelRequest copyWith(void Function(DeleteChannelRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteChannelRequest))
          as DeleteChannelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteChannelRequest() / DeleteChannelRequest.new instead')
  static DeleteChannelRequest create() => DeleteChannelRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteChannelRequest._();
  @$core.override
  DeleteChannelRequest createEmptyInstance() => DeleteChannelRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteChannelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteChannelRequest>(
          DeleteChannelRequest.$_createMessage);
  static DeleteChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedRevision => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);
}

class DeleteChannelResponse extends $pb.GeneratedMessage {
  factory DeleteChannelResponse() => DeleteChannelResponse._();

  DeleteChannelResponse._();

  factory DeleteChannelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteChannelResponse()..mergeFromBuffer(data, registry);
  factory DeleteChannelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteChannelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteChannelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: DeleteChannelResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChannelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChannelResponse copyWith(
          void Function(DeleteChannelResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteChannelResponse))
          as DeleteChannelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteChannelResponse() / DeleteChannelResponse.new instead')
  static DeleteChannelResponse create() => DeleteChannelResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteChannelResponse._();
  @$core.override
  DeleteChannelResponse createEmptyInstance() => DeleteChannelResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteChannelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteChannelResponse>(
          DeleteChannelResponse.$_createMessage);
  static DeleteChannelResponse? _defaultInstance;
}

class CreateChannelResponse extends $pb.GeneratedMessage {
  factory CreateChannelResponse({
    Channel? channel,
  }) {
    final result = CreateChannelResponse._();
    if (channel != null) result.channel = channel;
    return result;
  }

  CreateChannelResponse._();

  factory CreateChannelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChannelResponse()..mergeFromBuffer(data, registry);
  factory CreateChannelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChannelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChannelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateChannelResponse.$_createMessage)
    ..aOM<Channel>(1, _omitFieldNames ? '' : 'channel',
        subBuilder: Channel.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChannelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChannelResponse copyWith(
          void Function(CreateChannelResponse) updates) =>
      super.copyWith((message) => updates(message as CreateChannelResponse))
          as CreateChannelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateChannelResponse() / CreateChannelResponse.new instead')
  static CreateChannelResponse create() => CreateChannelResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateChannelResponse._();
  @$core.override
  CreateChannelResponse createEmptyInstance() => CreateChannelResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateChannelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChannelResponse>(
          CreateChannelResponse.$_createMessage);
  static CreateChannelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Channel get channel => $_getN(0);
  @$pb.TagNumber(1)
  set channel(Channel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);
  @$pb.TagNumber(1)
  Channel ensureChannel() => $_ensure(0);
}

class UpdateChannelResponse extends $pb.GeneratedMessage {
  factory UpdateChannelResponse({
    Channel? channel,
  }) {
    final result = UpdateChannelResponse._();
    if (channel != null) result.channel = channel;
    return result;
  }

  UpdateChannelResponse._();

  factory UpdateChannelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelResponse()..mergeFromBuffer(data, registry);
  factory UpdateChannelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateChannelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateChannelResponse.$_createMessage)
    ..aOM<Channel>(1, _omitFieldNames ? '' : 'channel',
        subBuilder: Channel.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelResponse copyWith(
          void Function(UpdateChannelResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateChannelResponse))
          as UpdateChannelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateChannelResponse() / UpdateChannelResponse.new instead')
  static UpdateChannelResponse create() => UpdateChannelResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateChannelResponse._();
  @$core.override
  UpdateChannelResponse createEmptyInstance() => UpdateChannelResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateChannelResponse>(
          UpdateChannelResponse.$_createMessage);
  static UpdateChannelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Channel get channel => $_getN(0);
  @$pb.TagNumber(1)
  set channel(Channel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);
  @$pb.TagNumber(1)
  Channel ensureChannel() => $_ensure(0);
}

class GetChannelAccessRequest extends $pb.GeneratedMessage {
  factory GetChannelAccessRequest({
    $core.String? channelId,
  }) {
    final result = GetChannelAccessRequest._();
    if (channelId != null) result.channelId = channelId;
    return result;
  }

  GetChannelAccessRequest._();

  factory GetChannelAccessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChannelAccessRequest()..mergeFromBuffer(data, registry);
  factory GetChannelAccessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChannelAccessRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChannelAccessRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetChannelAccessRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChannelAccessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChannelAccessRequest copyWith(
          void Function(GetChannelAccessRequest) updates) =>
      super.copyWith((message) => updates(message as GetChannelAccessRequest))
          as GetChannelAccessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetChannelAccessRequest() / GetChannelAccessRequest.new instead')
  static GetChannelAccessRequest create() => GetChannelAccessRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetChannelAccessRequest._();
  @$core.override
  GetChannelAccessRequest createEmptyInstance() => GetChannelAccessRequest._();
  @$core.pragma('dart2js:noInline')
  static GetChannelAccessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChannelAccessRequest>(
          GetChannelAccessRequest.$_createMessage);
  static GetChannelAccessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);
}

class UpdateChannelAccessRequest extends $pb.GeneratedMessage {
  factory UpdateChannelAccessRequest({
    $core.String? channelId,
    $fixnum.Int64? expectedRevision,
    $core.Iterable<ChannelAccessRule>? rules,
  }) {
    final result = UpdateChannelAccessRequest._();
    if (channelId != null) result.channelId = channelId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  UpdateChannelAccessRequest._();

  factory UpdateChannelAccessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelAccessRequest()..mergeFromBuffer(data, registry);
  factory UpdateChannelAccessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelAccessRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateChannelAccessRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateChannelAccessRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedRevision')
    ..pPM<ChannelAccessRule>(3, _omitFieldNames ? '' : 'rules',
        subBuilder: ChannelAccessRule.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelAccessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelAccessRequest copyWith(
          void Function(UpdateChannelAccessRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateChannelAccessRequest))
          as UpdateChannelAccessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateChannelAccessRequest() / UpdateChannelAccessRequest.new instead')
  static UpdateChannelAccessRequest create() => UpdateChannelAccessRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateChannelAccessRequest._();
  @$core.override
  UpdateChannelAccessRequest createEmptyInstance() =>
      UpdateChannelAccessRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelAccessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateChannelAccessRequest>(
          UpdateChannelAccessRequest.$_createMessage);
  static UpdateChannelAccessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedRevision => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ChannelAccessRule> get rules => $_getList(2);
}

class GetChannelAccessResponse extends $pb.GeneratedMessage {
  factory GetChannelAccessResponse({
    $core.String? channelId,
    $fixnum.Int64? revision,
    $core.Iterable<ChannelAccessRule>? rules,
  }) {
    final result = GetChannelAccessResponse._();
    if (channelId != null) result.channelId = channelId;
    if (revision != null) result.revision = revision;
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  GetChannelAccessResponse._();

  factory GetChannelAccessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChannelAccessResponse()..mergeFromBuffer(data, registry);
  factory GetChannelAccessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChannelAccessResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChannelAccessResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetChannelAccessResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..pPM<ChannelAccessRule>(3, _omitFieldNames ? '' : 'rules',
        subBuilder: ChannelAccessRule.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChannelAccessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChannelAccessResponse copyWith(
          void Function(GetChannelAccessResponse) updates) =>
      super.copyWith((message) => updates(message as GetChannelAccessResponse))
          as GetChannelAccessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetChannelAccessResponse() / GetChannelAccessResponse.new instead')
  static GetChannelAccessResponse create() => GetChannelAccessResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetChannelAccessResponse._();
  @$core.override
  GetChannelAccessResponse createEmptyInstance() =>
      GetChannelAccessResponse._();
  @$core.pragma('dart2js:noInline')
  static GetChannelAccessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChannelAccessResponse>(
          GetChannelAccessResponse.$_createMessage);
  static GetChannelAccessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ChannelAccessRule> get rules => $_getList(2);
}

class View extends $pb.GeneratedMessage {
  factory View({
    $core.String? id,
    $core.String? type,
  }) {
    final result = View._();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    return result;
  }

  View._();

  factory View.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      View()..mergeFromBuffer(data, registry);
  factory View.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      View()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'View',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: View.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  View clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  View copyWith(void Function(View) updates) =>
      super.copyWith((message) => updates(message as View)) as View;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use View() / View.new instead')
  static View create() => View._();
  static $pb.GeneratedMessage $_createMessage() => View._();
  @$core.override
  View createEmptyInstance() => View._();
  @$core.pragma('dart2js:noInline')
  static View getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<View>(View.$_createMessage);
  static View? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);
}

class Content extends $pb.GeneratedMessage {
  factory Content({
    $core.String? id,
    $core.String? channelId,
    $core.String? text,
    $core.String? authorId,
    $fixnum.Int64? sequence,
    $fixnum.Int64? createdAtUnixMs,
    $fixnum.Int64? revision,
    $fixnum.Int64? updatedAtUnixMs,
    $core.bool? deleted,
    $core.Iterable<Asset>? attachments,
    $core.Iterable<Reaction>? reactions,
    $core.String? replyToId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        participantNames,
    $core.Iterable<$0.CommunityMention>? mentions,
  }) {
    final result = Content._();
    if (id != null) result.id = id;
    if (channelId != null) result.channelId = channelId;
    if (text != null) result.text = text;
    if (authorId != null) result.authorId = authorId;
    if (sequence != null) result.sequence = sequence;
    if (createdAtUnixMs != null) result.createdAtUnixMs = createdAtUnixMs;
    if (revision != null) result.revision = revision;
    if (updatedAtUnixMs != null) result.updatedAtUnixMs = updatedAtUnixMs;
    if (deleted != null) result.deleted = deleted;
    if (attachments != null) result.attachments.addAll(attachments);
    if (reactions != null) result.reactions.addAll(reactions);
    if (replyToId != null) result.replyToId = replyToId;
    if (participantNames != null)
      result.participantNames.addEntries(participantNames);
    if (mentions != null) result.mentions.addAll(mentions);
    return result;
  }

  Content._();

  factory Content.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Content()..mergeFromBuffer(data, registry);
  factory Content.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Content()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Content',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Content.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'channelId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'authorId')
    ..aInt64(5, _omitFieldNames ? '' : 'sequence')
    ..aInt64(6, _omitFieldNames ? '' : 'createdAtUnixMs')
    ..aInt64(7, _omitFieldNames ? '' : 'revision')
    ..aInt64(8, _omitFieldNames ? '' : 'updatedAtUnixMs')
    ..aOB(9, _omitFieldNames ? '' : 'deleted')
    ..pPM<Asset>(10, _omitFieldNames ? '' : 'attachments',
        subBuilder: Asset.$_createMessage)
    ..pPM<Reaction>(11, _omitFieldNames ? '' : 'reactions',
        subBuilder: Reaction.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'replyToId')
    ..m<$core.String, $core.String>(
        13, _omitFieldNames ? '' : 'participantNames',
        entryClassName: 'Content.ParticipantNamesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('space.v1'))
    ..pPM<$0.CommunityMention>(14, _omitFieldNames ? '' : 'mentions',
        subBuilder: $0.CommunityMention.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Content clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Content copyWith(void Function(Content) updates) =>
      super.copyWith((message) => updates(message as Content)) as Content;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Content() / Content.new instead')
  static Content create() => Content._();
  static $pb.GeneratedMessage $_createMessage() => Content._();
  @$core.override
  Content createEmptyInstance() => Content._();
  @$core.pragma('dart2js:noInline')
  static Content getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Content>(Content.$_createMessage);
  static Content? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get channelId => $_getSZ(1);
  @$pb.TagNumber(2)
  set channelId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChannelId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get sequence => $_getI64(4);
  @$pb.TagNumber(5)
  set sequence($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSequence() => $_has(4);
  @$pb.TagNumber(5)
  void clearSequence() => $_clearField(5);

  /// Серверное время создания в миллисекундах Unix; 0 означает неизвестное время.
  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAtUnixMs => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAtUnixMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAtUnixMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAtUnixMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get revision => $_getI64(6);
  @$pb.TagNumber(7)
  set revision($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearRevision() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get updatedAtUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set updatedAtUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAtUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAtUnixMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get deleted => $_getBF(8);
  @$pb.TagNumber(9)
  set deleted($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeleted() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeleted() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<Asset> get attachments => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<Reaction> get reactions => $_getList(10);

  /// Ответ только на сообщение того же обычного канала; без копии текста.
  @$pb.TagNumber(12)
  $core.String get replyToId => $_getSZ(11);
  @$pb.TagNumber(12)
  set replyToId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReplyToId() => $_has(11);
  @$pb.TagNumber(12)
  void clearReplyToId() => $_clearField(12);

  /// Актуальные имена видимых авторов и участников реакций; идентификаторы не меняются.
  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get participantNames => $_getMap(12);

  @$pb.TagNumber(14)
  $pb.PbList<$0.CommunityMention> get mentions => $_getList(13);
}

class UpdateContentRequest extends $pb.GeneratedMessage {
  factory UpdateContentRequest({
    $core.String? channelId,
    $core.String? id,
    $core.String? text,
    $fixnum.Int64? expectedRevision,
    $core.String? idempotencyKey,
    $core.Iterable<$0.CommunityMention>? mentions,
  }) {
    final result = UpdateContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (id != null) result.id = id;
    if (text != null) result.text = text;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (mentions != null) result.mentions.addAll(mentions);
    return result;
  }

  UpdateContentRequest._();

  factory UpdateContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateContentRequest()..mergeFromBuffer(data, registry);
  factory UpdateContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(5, _omitFieldNames ? '' : 'idempotencyKey')
    ..pPM<$0.CommunityMention>(6, _omitFieldNames ? '' : 'mentions',
        subBuilder: $0.CommunityMention.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentRequest copyWith(void Function(UpdateContentRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateContentRequest))
          as UpdateContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateContentRequest() / UpdateContentRequest.new instead')
  static UpdateContentRequest create() => UpdateContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateContentRequest._();
  @$core.override
  UpdateContentRequest createEmptyInstance() => UpdateContentRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateContentRequest>(
          UpdateContentRequest.$_createMessage);
  static UpdateContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get idempotencyKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set idempotencyKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIdempotencyKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdempotencyKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$0.CommunityMention> get mentions => $_getList(5);
}

class UpdateContentResponse extends $pb.GeneratedMessage {
  factory UpdateContentResponse({
    Content? content,
    $core.String? idempotencyKey,
    $fixnum.Int64? appliedRevision,
  }) {
    final result = UpdateContentResponse._();
    if (content != null) result.content = content;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (appliedRevision != null) result.appliedRevision = appliedRevision;
    return result;
  }

  UpdateContentResponse._();

  factory UpdateContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateContentResponse()..mergeFromBuffer(data, registry);
  factory UpdateContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateContentResponse.$_createMessage)
    ..aOM<Content>(1, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'idempotencyKey')
    ..aInt64(3, _omitFieldNames ? '' : 'appliedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentResponse copyWith(
          void Function(UpdateContentResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateContentResponse))
          as UpdateContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateContentResponse() / UpdateContentResponse.new instead')
  static UpdateContentResponse create() => UpdateContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateContentResponse._();
  @$core.override
  UpdateContentResponse createEmptyInstance() => UpdateContentResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateContentResponse>(
          UpdateContentResponse.$_createMessage);
  static UpdateContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Content get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(Content value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  Content ensureContent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get idempotencyKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set idempotencyKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdempotencyKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdempotencyKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get appliedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set appliedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppliedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppliedRevision() => $_clearField(3);
}

class DeleteContentRequest extends $pb.GeneratedMessage {
  factory DeleteContentRequest({
    $core.String? channelId,
    $core.String? id,
    $fixnum.Int64? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = DeleteContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (id != null) result.id = id;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  DeleteContentRequest._();

  factory DeleteContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteContentRequest()..mergeFromBuffer(data, registry);
  factory DeleteContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: DeleteContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteContentRequest copyWith(void Function(DeleteContentRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteContentRequest))
          as DeleteContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteContentRequest() / DeleteContentRequest.new instead')
  static DeleteContentRequest create() => DeleteContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteContentRequest._();
  @$core.override
  DeleteContentRequest createEmptyInstance() => DeleteContentRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteContentRequest>(
          DeleteContentRequest.$_createMessage);
  static DeleteContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => $_clearField(4);
}

class DeleteContentResponse extends $pb.GeneratedMessage {
  factory DeleteContentResponse({
    Content? content,
    $core.String? idempotencyKey,
    $fixnum.Int64? appliedRevision,
  }) {
    final result = DeleteContentResponse._();
    if (content != null) result.content = content;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (appliedRevision != null) result.appliedRevision = appliedRevision;
    return result;
  }

  DeleteContentResponse._();

  factory DeleteContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteContentResponse()..mergeFromBuffer(data, registry);
  factory DeleteContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: DeleteContentResponse.$_createMessage)
    ..aOM<Content>(1, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'idempotencyKey')
    ..aInt64(3, _omitFieldNames ? '' : 'appliedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteContentResponse copyWith(
          void Function(DeleteContentResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteContentResponse))
          as DeleteContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteContentResponse() / DeleteContentResponse.new instead')
  static DeleteContentResponse create() => DeleteContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteContentResponse._();
  @$core.override
  DeleteContentResponse createEmptyInstance() => DeleteContentResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteContentResponse>(
          DeleteContentResponse.$_createMessage);
  static DeleteContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Content get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(Content value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  Content ensureContent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get idempotencyKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set idempotencyKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdempotencyKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdempotencyKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get appliedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set appliedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppliedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppliedRevision() => $_clearField(3);
}

class CreateContentRequest extends $pb.GeneratedMessage {
  factory CreateContentRequest({
    $core.String? channelId,
    $core.String? text,
    $core.String? idempotencyKey,
    $core.Iterable<$core.String>? attachmentIds,
    $core.String? replyToId,
    $core.Iterable<$0.CommunityMention>? mentions,
  }) {
    final result = CreateContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (text != null) result.text = text;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (attachmentIds != null) result.attachmentIds.addAll(attachmentIds);
    if (replyToId != null) result.replyToId = replyToId;
    if (mentions != null) result.mentions.addAll(mentions);
    return result;
  }

  CreateContentRequest._();

  factory CreateContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentRequest()..mergeFromBuffer(data, registry);
  factory CreateContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..pPS(4, _omitFieldNames ? '' : 'attachmentIds')
    ..aOS(5, _omitFieldNames ? '' : 'replyToId')
    ..pPM<$0.CommunityMention>(6, _omitFieldNames ? '' : 'mentions',
        subBuilder: $0.CommunityMention.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentRequest copyWith(void Function(CreateContentRequest) updates) =>
      super.copyWith((message) => updates(message as CreateContentRequest))
          as CreateContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateContentRequest() / CreateContentRequest.new instead')
  static CreateContentRequest create() => CreateContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateContentRequest._();
  @$core.override
  CreateContentRequest createEmptyInstance() => CreateContentRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateContentRequest>(
          CreateContentRequest.$_createMessage);
  static CreateContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get attachmentIds => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get replyToId => $_getSZ(4);
  @$pb.TagNumber(5)
  set replyToId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReplyToId() => $_has(4);
  @$pb.TagNumber(5)
  void clearReplyToId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$0.CommunityMention> get mentions => $_getList(5);
}

class CreateContentResponse extends $pb.GeneratedMessage {
  factory CreateContentResponse({
    Content? content,
  }) {
    final result = CreateContentResponse._();
    if (content != null) result.content = content;
    return result;
  }

  CreateContentResponse._();

  factory CreateContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentResponse()..mergeFromBuffer(data, registry);
  factory CreateContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateContentResponse.$_createMessage)
    ..aOM<Content>(1, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentResponse copyWith(
          void Function(CreateContentResponse) updates) =>
      super.copyWith((message) => updates(message as CreateContentResponse))
          as CreateContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateContentResponse() / CreateContentResponse.new instead')
  static CreateContentResponse create() => CreateContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateContentResponse._();
  @$core.override
  CreateContentResponse createEmptyInstance() => CreateContentResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateContentResponse>(
          CreateContentResponse.$_createMessage);
  static CreateContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Content get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(Content value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  Content ensureContent() => $_ensure(0);
}

class ListContentRequest extends $pb.GeneratedMessage {
  factory ListContentRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = ListContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  ListContentRequest._();

  factory ListContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentRequest()..mergeFromBuffer(data, registry);
  factory ListContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentRequest copyWith(void Function(ListContentRequest) updates) =>
      super.copyWith((message) => updates(message as ListContentRequest))
          as ListContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListContentRequest() / ListContentRequest.new instead')
  static ListContentRequest create() => ListContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListContentRequest._();
  @$core.override
  ListContentRequest createEmptyInstance() => ListContentRequest._();
  @$core.pragma('dart2js:noInline')
  static ListContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContentRequest>(
          ListContentRequest.$_createMessage);
  static ListContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  /// Непрозрачный курсор последнего полученного сообщения.
  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class ListContentResponse extends $pb.GeneratedMessage {
  factory ListContentResponse({
    $core.Iterable<Content>? contents,
    $core.String? nextCursor,
  }) {
    final result = ListContentResponse._();
    if (contents != null) result.contents.addAll(contents);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListContentResponse._();

  factory ListContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentResponse()..mergeFromBuffer(data, registry);
  factory ListContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListContentResponse.$_createMessage)
    ..pPM<Content>(1, _omitFieldNames ? '' : 'contents',
        subBuilder: Content.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentResponse copyWith(void Function(ListContentResponse) updates) =>
      super.copyWith((message) => updates(message as ListContentResponse))
          as ListContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListContentResponse() / ListContentResponse.new instead')
  static ListContentResponse create() => ListContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListContentResponse._();
  @$core.override
  ListContentResponse createEmptyInstance() => ListContentResponse._();
  @$core.pragma('dart2js:noInline')
  static ListContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContentResponse>(
          ListContentResponse.$_createMessage);
  static ListContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Content> get contents => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class CreateRootRotationRequest extends $pb.GeneratedMessage {
  factory CreateRootRotationRequest({
    $core.String? operationId,
    $fixnum.Int64? expectedAuthEpoch,
    $core.List<$core.int>? newRootPublicKey,
    $core.List<$core.int>? newDevicePublicKey,
    $core.String? profile,
    $core.Iterable<$core.String>? retainedGrantIds,
    $core.List<$core.int>? retainedDevicesHash,
  }) {
    final result = CreateRootRotationRequest._();
    if (operationId != null) result.operationId = operationId;
    if (expectedAuthEpoch != null) result.expectedAuthEpoch = expectedAuthEpoch;
    if (newRootPublicKey != null) result.newRootPublicKey = newRootPublicKey;
    if (newDevicePublicKey != null)
      result.newDevicePublicKey = newDevicePublicKey;
    if (profile != null) result.profile = profile;
    if (retainedGrantIds != null)
      result.retainedGrantIds.addAll(retainedGrantIds);
    if (retainedDevicesHash != null)
      result.retainedDevicesHash = retainedDevicesHash;
    return result;
  }

  CreateRootRotationRequest._();

  factory CreateRootRotationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRootRotationRequest()..mergeFromBuffer(data, registry);
  factory CreateRootRotationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRootRotationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRootRotationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateRootRotationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'operationId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedAuthEpoch')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'newRootPublicKey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'newDevicePublicKey', $pb.PbFieldType.OY)
    ..aOS(5, _omitFieldNames ? '' : 'profile')
    ..pPS(6, _omitFieldNames ? '' : 'retainedGrantIds')
    ..a<$core.List<$core.int>>(
        7, _omitFieldNames ? '' : 'retainedDevicesHash', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRootRotationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRootRotationRequest copyWith(
          void Function(CreateRootRotationRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRootRotationRequest))
          as CreateRootRotationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateRootRotationRequest() / CreateRootRotationRequest.new instead')
  static CreateRootRotationRequest create() => CreateRootRotationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateRootRotationRequest._();
  @$core.override
  CreateRootRotationRequest createEmptyInstance() =>
      CreateRootRotationRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateRootRotationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRootRotationRequest>(
          CreateRootRotationRequest.$_createMessage);
  static CreateRootRotationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get operationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set operationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOperationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedAuthEpoch => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedAuthEpoch($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedAuthEpoch() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedAuthEpoch() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get newRootPublicKey => $_getN(2);
  @$pb.TagNumber(3)
  set newRootPublicKey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewRootPublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewRootPublicKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get newDevicePublicKey => $_getN(3);
  @$pb.TagNumber(4)
  set newDevicePublicKey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewDevicePublicKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewDevicePublicKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get profile => $_getSZ(4);
  @$pb.TagNumber(5)
  set profile($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProfile() => $_has(4);
  @$pb.TagNumber(5)
  void clearProfile() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get retainedGrantIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<$core.int> get retainedDevicesHash => $_getN(6);
  @$pb.TagNumber(7)
  set retainedDevicesHash($core.List<$core.int> value) => $_setBytes(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRetainedDevicesHash() => $_has(6);
  @$pb.TagNumber(7)
  void clearRetainedDevicesHash() => $_clearField(7);
}

class CreateRootRotationResponse extends $pb.GeneratedMessage {
  factory CreateRootRotationResponse({
    $core.String? challengeId,
    $core.List<$core.int>? transcript,
  }) {
    final result = CreateRootRotationResponse._();
    if (challengeId != null) result.challengeId = challengeId;
    if (transcript != null) result.transcript = transcript;
    return result;
  }

  CreateRootRotationResponse._();

  factory CreateRootRotationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRootRotationResponse()..mergeFromBuffer(data, registry);
  factory CreateRootRotationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRootRotationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRootRotationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateRootRotationResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'challengeId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'transcript', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRootRotationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRootRotationResponse copyWith(
          void Function(CreateRootRotationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateRootRotationResponse))
          as CreateRootRotationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateRootRotationResponse() / CreateRootRotationResponse.new instead')
  static CreateRootRotationResponse create() => CreateRootRotationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateRootRotationResponse._();
  @$core.override
  CreateRootRotationResponse createEmptyInstance() =>
      CreateRootRotationResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateRootRotationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRootRotationResponse>(
          CreateRootRotationResponse.$_createMessage);
  static CreateRootRotationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get challengeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set challengeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallengeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallengeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get transcript => $_getN(1);
  @$pb.TagNumber(2)
  set transcript($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTranscript() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranscript() => $_clearField(2);
}

class CompleteRootRotationRequest extends $pb.GeneratedMessage {
  factory CompleteRootRotationRequest({
    $core.String? challengeId,
    $core.List<$core.int>? oldSignature,
    $core.List<$core.int>? newSignature,
  }) {
    final result = CompleteRootRotationRequest._();
    if (challengeId != null) result.challengeId = challengeId;
    if (oldSignature != null) result.oldSignature = oldSignature;
    if (newSignature != null) result.newSignature = newSignature;
    return result;
  }

  CompleteRootRotationRequest._();

  factory CompleteRootRotationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteRootRotationRequest()..mergeFromBuffer(data, registry);
  factory CompleteRootRotationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteRootRotationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteRootRotationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteRootRotationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'challengeId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'oldSignature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'newSignature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRootRotationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRootRotationRequest copyWith(
          void Function(CompleteRootRotationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteRootRotationRequest))
          as CompleteRootRotationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteRootRotationRequest() / CompleteRootRotationRequest.new instead')
  static CompleteRootRotationRequest create() =>
      CompleteRootRotationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompleteRootRotationRequest._();
  @$core.override
  CompleteRootRotationRequest createEmptyInstance() =>
      CompleteRootRotationRequest._();
  @$core.pragma('dart2js:noInline')
  static CompleteRootRotationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteRootRotationRequest>(
          CompleteRootRotationRequest.$_createMessage);
  static CompleteRootRotationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get challengeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set challengeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallengeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallengeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get oldSignature => $_getN(1);
  @$pb.TagNumber(2)
  set oldSignature($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOldSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearOldSignature() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get newSignature => $_getN(2);
  @$pb.TagNumber(3)
  set newSignature($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewSignature() => $_clearField(3);
}

class CompleteRootRotationResponse extends $pb.GeneratedMessage {
  factory CompleteRootRotationResponse({
    $core.String? principalId,
    $fixnum.Int64? authEpoch,
    $core.String? grantId,
    $core.List<$core.int>? transcript,
    $core.List<$core.int>? oldSignature,
    $core.List<$core.int>? newSignature,
  }) {
    final result = CompleteRootRotationResponse._();
    if (principalId != null) result.principalId = principalId;
    if (authEpoch != null) result.authEpoch = authEpoch;
    if (grantId != null) result.grantId = grantId;
    if (transcript != null) result.transcript = transcript;
    if (oldSignature != null) result.oldSignature = oldSignature;
    if (newSignature != null) result.newSignature = newSignature;
    return result;
  }

  CompleteRootRotationResponse._();

  factory CompleteRootRotationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteRootRotationResponse()..mergeFromBuffer(data, registry);
  factory CompleteRootRotationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteRootRotationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteRootRotationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteRootRotationResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aInt64(2, _omitFieldNames ? '' : 'authEpoch')
    ..aOS(3, _omitFieldNames ? '' : 'grantId')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'transcript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'oldSignature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'newSignature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRootRotationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteRootRotationResponse copyWith(
          void Function(CompleteRootRotationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteRootRotationResponse))
          as CompleteRootRotationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteRootRotationResponse() / CompleteRootRotationResponse.new instead')
  static CompleteRootRotationResponse create() =>
      CompleteRootRotationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompleteRootRotationResponse._();
  @$core.override
  CompleteRootRotationResponse createEmptyInstance() =>
      CompleteRootRotationResponse._();
  @$core.pragma('dart2js:noInline')
  static CompleteRootRotationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteRootRotationResponse>(
          CompleteRootRotationResponse.$_createMessage);
  static CompleteRootRotationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get principalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set principalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrincipalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrincipalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get authEpoch => $_getI64(1);
  @$pb.TagNumber(2)
  set authEpoch($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthEpoch() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthEpoch() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get grantId => $_getSZ(2);
  @$pb.TagNumber(3)
  set grantId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGrantId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGrantId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get transcript => $_getN(3);
  @$pb.TagNumber(4)
  set transcript($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTranscript() => $_has(3);
  @$pb.TagNumber(4)
  void clearTranscript() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get oldSignature => $_getN(4);
  @$pb.TagNumber(5)
  set oldSignature($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOldSignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearOldSignature() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get newSignature => $_getN(5);
  @$pb.TagNumber(6)
  set newSignature($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNewSignature() => $_has(5);
  @$pb.TagNumber(6)
  void clearNewSignature() => $_clearField(6);
}

class RootHistoryProof extends $pb.GeneratedMessage {
  factory RootHistoryProof({
    $core.List<$core.int>? transcript,
    $core.List<$core.int>? oldSignature,
    $core.List<$core.int>? newSignature,
  }) {
    final result = RootHistoryProof._();
    if (transcript != null) result.transcript = transcript;
    if (oldSignature != null) result.oldSignature = oldSignature;
    if (newSignature != null) result.newSignature = newSignature;
    return result;
  }

  RootHistoryProof._();

  factory RootHistoryProof.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RootHistoryProof()..mergeFromBuffer(data, registry);
  factory RootHistoryProof.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RootHistoryProof()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RootHistoryProof',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RootHistoryProof.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'transcript', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'oldSignature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'newSignature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RootHistoryProof clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RootHistoryProof copyWith(void Function(RootHistoryProof) updates) =>
      super.copyWith((message) => updates(message as RootHistoryProof))
          as RootHistoryProof;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RootHistoryProof() / RootHistoryProof.new instead')
  static RootHistoryProof create() => RootHistoryProof._();
  static $pb.GeneratedMessage $_createMessage() => RootHistoryProof._();
  @$core.override
  RootHistoryProof createEmptyInstance() => RootHistoryProof._();
  @$core.pragma('dart2js:noInline')
  static RootHistoryProof getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RootHistoryProof>(
          RootHistoryProof.$_createMessage);
  static RootHistoryProof? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get transcript => $_getN(0);
  @$pb.TagNumber(1)
  set transcript($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTranscript() => $_has(0);
  @$pb.TagNumber(1)
  void clearTranscript() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get oldSignature => $_getN(1);
  @$pb.TagNumber(2)
  set oldSignature($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOldSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearOldSignature() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get newSignature => $_getN(2);
  @$pb.TagNumber(3)
  set newSignature($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewSignature() => $_clearField(3);
}

class UpdateChannelAccessResponse extends $pb.GeneratedMessage {
  factory UpdateChannelAccessResponse({
    $core.String? channelId,
    $fixnum.Int64? revision,
    $core.Iterable<ChannelAccessRule>? rules,
  }) {
    final result = UpdateChannelAccessResponse._();
    if (channelId != null) result.channelId = channelId;
    if (revision != null) result.revision = revision;
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  UpdateChannelAccessResponse._();

  factory UpdateChannelAccessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelAccessResponse()..mergeFromBuffer(data, registry);
  factory UpdateChannelAccessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateChannelAccessResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateChannelAccessResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateChannelAccessResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..pPM<ChannelAccessRule>(3, _omitFieldNames ? '' : 'rules',
        subBuilder: ChannelAccessRule.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelAccessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChannelAccessResponse copyWith(
          void Function(UpdateChannelAccessResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateChannelAccessResponse))
          as UpdateChannelAccessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateChannelAccessResponse() / UpdateChannelAccessResponse.new instead')
  static UpdateChannelAccessResponse create() =>
      UpdateChannelAccessResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateChannelAccessResponse._();
  @$core.override
  UpdateChannelAccessResponse createEmptyInstance() =>
      UpdateChannelAccessResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateChannelAccessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateChannelAccessResponse>(
          UpdateChannelAccessResponse.$_createMessage);
  static UpdateChannelAccessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ChannelAccessRule> get rules => $_getList(2);
}

/// Полный авторизованный каталог; его изменения не используют курсор сообщений.
class WatchChannelsRequest extends $pb.GeneratedMessage {
  factory WatchChannelsRequest({
    $core.bool? includeArchived,
  }) {
    final result = WatchChannelsRequest._();
    if (includeArchived != null) result.includeArchived = includeArchived;
    return result;
  }

  WatchChannelsRequest._();

  factory WatchChannelsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchChannelsRequest()..mergeFromBuffer(data, registry);
  factory WatchChannelsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchChannelsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchChannelsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: WatchChannelsRequest.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'includeArchived')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchChannelsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchChannelsRequest copyWith(void Function(WatchChannelsRequest) updates) =>
      super.copyWith((message) => updates(message as WatchChannelsRequest))
          as WatchChannelsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchChannelsRequest() / WatchChannelsRequest.new instead')
  static WatchChannelsRequest create() => WatchChannelsRequest._();
  static $pb.GeneratedMessage $_createMessage() => WatchChannelsRequest._();
  @$core.override
  WatchChannelsRequest createEmptyInstance() => WatchChannelsRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchChannelsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchChannelsRequest>(
          WatchChannelsRequest.$_createMessage);
  static WatchChannelsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get includeArchived => $_getBF(0);
  @$pb.TagNumber(1)
  set includeArchived($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeArchived() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeArchived() => $_clearField(1);
}

class WatchChannelsResponse extends $pb.GeneratedMessage {
  factory WatchChannelsResponse({
    $core.Iterable<Channel>? channels,
    $core.String? spaceTitle,
    $core.String? role,
    $core.bool? heartbeat,
    $core.String? serverId,
    ServerIcon? icon,
    $core.bool? attachmentsEnabled,
  }) {
    final result = WatchChannelsResponse._();
    if (channels != null) result.channels.addAll(channels);
    if (spaceTitle != null) result.spaceTitle = spaceTitle;
    if (role != null) result.role = role;
    if (heartbeat != null) result.heartbeat = heartbeat;
    if (serverId != null) result.serverId = serverId;
    if (icon != null) result.icon = icon;
    if (attachmentsEnabled != null)
      result.attachmentsEnabled = attachmentsEnabled;
    return result;
  }

  WatchChannelsResponse._();

  factory WatchChannelsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchChannelsResponse()..mergeFromBuffer(data, registry);
  factory WatchChannelsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchChannelsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchChannelsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: WatchChannelsResponse.$_createMessage)
    ..pPM<Channel>(1, _omitFieldNames ? '' : 'channels',
        subBuilder: Channel.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'spaceTitle')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOB(4, _omitFieldNames ? '' : 'heartbeat')
    ..aOS(5, _omitFieldNames ? '' : 'serverId')
    ..aOM<ServerIcon>(6, _omitFieldNames ? '' : 'icon',
        subBuilder: ServerIcon.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'attachmentsEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchChannelsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchChannelsResponse copyWith(
          void Function(WatchChannelsResponse) updates) =>
      super.copyWith((message) => updates(message as WatchChannelsResponse))
          as WatchChannelsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchChannelsResponse() / WatchChannelsResponse.new instead')
  static WatchChannelsResponse create() => WatchChannelsResponse._();
  static $pb.GeneratedMessage $_createMessage() => WatchChannelsResponse._();
  @$core.override
  WatchChannelsResponse createEmptyInstance() => WatchChannelsResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchChannelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchChannelsResponse>(
          WatchChannelsResponse.$_createMessage);
  static WatchChannelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Channel> get channels => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get spaceTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set spaceTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSpaceTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpaceTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get heartbeat => $_getBF(3);
  @$pb.TagNumber(4)
  set heartbeat($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHeartbeat() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeartbeat() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get serverId => $_getSZ(4);
  @$pb.TagNumber(5)
  set serverId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasServerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearServerId() => $_clearField(5);

  @$pb.TagNumber(6)
  ServerIcon get icon => $_getN(5);
  @$pb.TagNumber(6)
  set icon(ServerIcon value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIcon() => $_has(5);
  @$pb.TagNumber(6)
  void clearIcon() => $_clearField(6);
  @$pb.TagNumber(6)
  ServerIcon ensureIcon() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get attachmentsEnabled => $_getBF(6);
  @$pb.TagNumber(7)
  set attachmentsEnabled($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAttachmentsEnabled() => $_has(6);
  @$pb.TagNumber(7)
  void clearAttachmentsEnabled() => $_clearField(7);
}

class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $core.String? id,
    $core.String? channelId,
    $core.String? authorId,
    $core.String? name,
    $fixnum.Int64? byteSize,
    $core.List<$core.int>? sha256,
    $core.String? mediaType,
    $fixnum.Int64? createdAtUnixMs,
    $core.String? storageGroup,
  }) {
    final result = Asset._();
    if (id != null) result.id = id;
    if (channelId != null) result.channelId = channelId;
    if (authorId != null) result.authorId = authorId;
    if (name != null) result.name = name;
    if (byteSize != null) result.byteSize = byteSize;
    if (sha256 != null) result.sha256 = sha256;
    if (mediaType != null) result.mediaType = mediaType;
    if (createdAtUnixMs != null) result.createdAtUnixMs = createdAtUnixMs;
    if (storageGroup != null) result.storageGroup = storageGroup;
    return result;
  }

  Asset._();

  factory Asset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Asset()..mergeFromBuffer(data, registry);
  factory Asset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Asset()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Asset.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'channelId')
    ..aOS(3, _omitFieldNames ? '' : 'authorId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aInt64(5, _omitFieldNames ? '' : 'byteSize')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'sha256', $pb.PbFieldType.OY)
    ..aOS(7, _omitFieldNames ? '' : 'mediaType')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtUnixMs')
    ..aOS(9, _omitFieldNames ? '' : 'storageGroup')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset copyWith(void Function(Asset) updates) =>
      super.copyWith((message) => updates(message as Asset)) as Asset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Asset() / Asset.new instead')
  static Asset create() => Asset._();
  static $pb.GeneratedMessage $_createMessage() => Asset._();
  @$core.override
  Asset createEmptyInstance() => Asset._();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Asset>(Asset.$_createMessage);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get channelId => $_getSZ(1);
  @$pb.TagNumber(2)
  set channelId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChannelId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get authorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get byteSize => $_getI64(4);
  @$pb.TagNumber(5)
  set byteSize($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasByteSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearByteSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get sha256 => $_getN(5);
  @$pb.TagNumber(6)
  set sha256($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSha256() => $_has(5);
  @$pb.TagNumber(6)
  void clearSha256() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get mediaType => $_getSZ(6);
  @$pb.TagNumber(7)
  set mediaType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMediaType() => $_has(6);
  @$pb.TagNumber(7)
  void clearMediaType() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAtUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAtUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAtUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAtUnixMs() => $_clearField(8);

  /// Серверная группа хранения: principal_id/YYYY/MM/DD, дата UTC.
  @$pb.TagNumber(9)
  $core.String get storageGroup => $_getSZ(8);
  @$pb.TagNumber(9)
  set storageGroup($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStorageGroup() => $_has(8);
  @$pb.TagNumber(9)
  void clearStorageGroup() => $_clearField(9);
}

class BeginUploadRequest extends $pb.GeneratedMessage {
  factory BeginUploadRequest({
    $core.String? channelId,
    $core.String? name,
    $fixnum.Int64? byteSize,
    $core.List<$core.int>? sha256,
    $core.String? idempotencyKey,
    $core.bool? encrypted,
  }) {
    final result = BeginUploadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (name != null) result.name = name;
    if (byteSize != null) result.byteSize = byteSize;
    if (sha256 != null) result.sha256 = sha256;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (encrypted != null) result.encrypted = encrypted;
    return result;
  }

  BeginUploadRequest._();

  factory BeginUploadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BeginUploadRequest()..mergeFromBuffer(data, registry);
  factory BeginUploadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BeginUploadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BeginUploadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: BeginUploadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'byteSize')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'sha256', $pb.PbFieldType.OY)
    ..aOS(5, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOB(6, _omitFieldNames ? '' : 'encrypted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BeginUploadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BeginUploadRequest copyWith(void Function(BeginUploadRequest) updates) =>
      super.copyWith((message) => updates(message as BeginUploadRequest))
          as BeginUploadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BeginUploadRequest() / BeginUploadRequest.new instead')
  static BeginUploadRequest create() => BeginUploadRequest._();
  static $pb.GeneratedMessage $_createMessage() => BeginUploadRequest._();
  @$core.override
  BeginUploadRequest createEmptyInstance() => BeginUploadRequest._();
  @$core.pragma('dart2js:noInline')
  static BeginUploadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BeginUploadRequest>(
          BeginUploadRequest.$_createMessage);
  static BeginUploadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get byteSize => $_getI64(2);
  @$pb.TagNumber(3)
  set byteSize($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasByteSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearByteSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get sha256 => $_getN(3);
  @$pb.TagNumber(4)
  set sha256($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSha256() => $_has(3);
  @$pb.TagNumber(4)
  void clearSha256() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get idempotencyKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set idempotencyKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIdempotencyKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdempotencyKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get encrypted => $_getBF(5);
  @$pb.TagNumber(6)
  set encrypted($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEncrypted() => $_has(5);
  @$pb.TagNumber(6)
  void clearEncrypted() => $_clearField(6);
}

class BeginUploadResponse extends $pb.GeneratedMessage {
  factory BeginUploadResponse({
    Asset? asset,
    $fixnum.Int64? receivedBytes,
    $core.int? chunkSize,
  }) {
    final result = BeginUploadResponse._();
    if (asset != null) result.asset = asset;
    if (receivedBytes != null) result.receivedBytes = receivedBytes;
    if (chunkSize != null) result.chunkSize = chunkSize;
    return result;
  }

  BeginUploadResponse._();

  factory BeginUploadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BeginUploadResponse()..mergeFromBuffer(data, registry);
  factory BeginUploadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BeginUploadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BeginUploadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: BeginUploadResponse.$_createMessage)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'receivedBytes')
    ..aI(3, _omitFieldNames ? '' : 'chunkSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BeginUploadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BeginUploadResponse copyWith(void Function(BeginUploadResponse) updates) =>
      super.copyWith((message) => updates(message as BeginUploadResponse))
          as BeginUploadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use BeginUploadResponse() / BeginUploadResponse.new instead')
  static BeginUploadResponse create() => BeginUploadResponse._();
  static $pb.GeneratedMessage $_createMessage() => BeginUploadResponse._();
  @$core.override
  BeginUploadResponse createEmptyInstance() => BeginUploadResponse._();
  @$core.pragma('dart2js:noInline')
  static BeginUploadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BeginUploadResponse>(
          BeginUploadResponse.$_createMessage);
  static BeginUploadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receivedBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set receivedBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceivedBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceivedBytes() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get chunkSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set chunkSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChunkSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunkSize() => $_clearField(3);
}

class UploadChunkRequest extends $pb.GeneratedMessage {
  factory UploadChunkRequest({
    $core.String? assetId,
    $fixnum.Int64? offset,
    $core.List<$core.int>? data,
  }) {
    final result = UploadChunkRequest._();
    if (assetId != null) result.assetId = assetId;
    if (offset != null) result.offset = offset;
    if (data != null) result.data = data;
    return result;
  }

  UploadChunkRequest._();

  factory UploadChunkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadChunkRequest()..mergeFromBuffer(data, registry);
  factory UploadChunkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadChunkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadChunkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UploadChunkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aInt64(2, _omitFieldNames ? '' : 'offset')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkRequest copyWith(void Function(UploadChunkRequest) updates) =>
      super.copyWith((message) => updates(message as UploadChunkRequest))
          as UploadChunkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UploadChunkRequest() / UploadChunkRequest.new instead')
  static UploadChunkRequest create() => UploadChunkRequest._();
  static $pb.GeneratedMessage $_createMessage() => UploadChunkRequest._();
  @$core.override
  UploadChunkRequest createEmptyInstance() => UploadChunkRequest._();
  @$core.pragma('dart2js:noInline')
  static UploadChunkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadChunkRequest>(
          UploadChunkRequest.$_createMessage);
  static UploadChunkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offset => $_getI64(1);
  @$pb.TagNumber(2)
  set offset($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
}

class UploadChunkResponse extends $pb.GeneratedMessage {
  factory UploadChunkResponse({
    $fixnum.Int64? receivedBytes,
  }) {
    final result = UploadChunkResponse._();
    if (receivedBytes != null) result.receivedBytes = receivedBytes;
    return result;
  }

  UploadChunkResponse._();

  factory UploadChunkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadChunkResponse()..mergeFromBuffer(data, registry);
  factory UploadChunkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadChunkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadChunkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UploadChunkResponse.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'receivedBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkResponse copyWith(void Function(UploadChunkResponse) updates) =>
      super.copyWith((message) => updates(message as UploadChunkResponse))
          as UploadChunkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UploadChunkResponse() / UploadChunkResponse.new instead')
  static UploadChunkResponse create() => UploadChunkResponse._();
  static $pb.GeneratedMessage $_createMessage() => UploadChunkResponse._();
  @$core.override
  UploadChunkResponse createEmptyInstance() => UploadChunkResponse._();
  @$core.pragma('dart2js:noInline')
  static UploadChunkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadChunkResponse>(
          UploadChunkResponse.$_createMessage);
  static UploadChunkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get receivedBytes => $_getI64(0);
  @$pb.TagNumber(1)
  set receivedBytes($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceivedBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceivedBytes() => $_clearField(1);
}

class CompleteUploadRequest extends $pb.GeneratedMessage {
  factory CompleteUploadRequest({
    $core.String? assetId,
  }) {
    final result = CompleteUploadRequest._();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  CompleteUploadRequest._();

  factory CompleteUploadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteUploadRequest()..mergeFromBuffer(data, registry);
  factory CompleteUploadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteUploadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteUploadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteUploadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteUploadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteUploadRequest copyWith(
          void Function(CompleteUploadRequest) updates) =>
      super.copyWith((message) => updates(message as CompleteUploadRequest))
          as CompleteUploadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteUploadRequest() / CompleteUploadRequest.new instead')
  static CompleteUploadRequest create() => CompleteUploadRequest._();
  static $pb.GeneratedMessage $_createMessage() => CompleteUploadRequest._();
  @$core.override
  CompleteUploadRequest createEmptyInstance() => CompleteUploadRequest._();
  @$core.pragma('dart2js:noInline')
  static CompleteUploadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteUploadRequest>(
          CompleteUploadRequest.$_createMessage);
  static CompleteUploadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class CompleteUploadResponse extends $pb.GeneratedMessage {
  factory CompleteUploadResponse({
    Asset? asset,
  }) {
    final result = CompleteUploadResponse._();
    if (asset != null) result.asset = asset;
    return result;
  }

  CompleteUploadResponse._();

  factory CompleteUploadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteUploadResponse()..mergeFromBuffer(data, registry);
  factory CompleteUploadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteUploadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteUploadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteUploadResponse.$_createMessage)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteUploadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteUploadResponse copyWith(
          void Function(CompleteUploadResponse) updates) =>
      super.copyWith((message) => updates(message as CompleteUploadResponse))
          as CompleteUploadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteUploadResponse() / CompleteUploadResponse.new instead')
  static CompleteUploadResponse create() => CompleteUploadResponse._();
  static $pb.GeneratedMessage $_createMessage() => CompleteUploadResponse._();
  @$core.override
  CompleteUploadResponse createEmptyInstance() => CompleteUploadResponse._();
  @$core.pragma('dart2js:noInline')
  static CompleteUploadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteUploadResponse>(
          CompleteUploadResponse.$_createMessage);
  static CompleteUploadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class CancelUploadRequest extends $pb.GeneratedMessage {
  factory CancelUploadRequest({
    $core.String? assetId,
  }) {
    final result = CancelUploadRequest._();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  CancelUploadRequest._();

  factory CancelUploadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelUploadRequest()..mergeFromBuffer(data, registry);
  factory CancelUploadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelUploadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelUploadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CancelUploadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelUploadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelUploadRequest copyWith(void Function(CancelUploadRequest) updates) =>
      super.copyWith((message) => updates(message as CancelUploadRequest))
          as CancelUploadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CancelUploadRequest() / CancelUploadRequest.new instead')
  static CancelUploadRequest create() => CancelUploadRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelUploadRequest._();
  @$core.override
  CancelUploadRequest createEmptyInstance() => CancelUploadRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelUploadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelUploadRequest>(
          CancelUploadRequest.$_createMessage);
  static CancelUploadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class CancelUploadResponse extends $pb.GeneratedMessage {
  factory CancelUploadResponse() => CancelUploadResponse._();

  CancelUploadResponse._();

  factory CancelUploadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelUploadResponse()..mergeFromBuffer(data, registry);
  factory CancelUploadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelUploadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelUploadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CancelUploadResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelUploadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelUploadResponse copyWith(void Function(CancelUploadResponse) updates) =>
      super.copyWith((message) => updates(message as CancelUploadResponse))
          as CancelUploadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelUploadResponse() / CancelUploadResponse.new instead')
  static CancelUploadResponse create() => CancelUploadResponse._();
  static $pb.GeneratedMessage $_createMessage() => CancelUploadResponse._();
  @$core.override
  CancelUploadResponse createEmptyInstance() => CancelUploadResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelUploadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelUploadResponse>(
          CancelUploadResponse.$_createMessage);
  static CancelUploadResponse? _defaultInstance;
}

class DownloadChunkRequest extends $pb.GeneratedMessage {
  factory DownloadChunkRequest({
    $core.String? assetId,
    $fixnum.Int64? offset,
  }) {
    final result = DownloadChunkRequest._();
    if (assetId != null) result.assetId = assetId;
    if (offset != null) result.offset = offset;
    return result;
  }

  DownloadChunkRequest._();

  factory DownloadChunkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadChunkRequest()..mergeFromBuffer(data, registry);
  factory DownloadChunkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadChunkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadChunkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: DownloadChunkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aInt64(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadChunkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadChunkRequest copyWith(void Function(DownloadChunkRequest) updates) =>
      super.copyWith((message) => updates(message as DownloadChunkRequest))
          as DownloadChunkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DownloadChunkRequest() / DownloadChunkRequest.new instead')
  static DownloadChunkRequest create() => DownloadChunkRequest._();
  static $pb.GeneratedMessage $_createMessage() => DownloadChunkRequest._();
  @$core.override
  DownloadChunkRequest createEmptyInstance() => DownloadChunkRequest._();
  @$core.pragma('dart2js:noInline')
  static DownloadChunkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadChunkRequest>(
          DownloadChunkRequest.$_createMessage);
  static DownloadChunkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offset => $_getI64(1);
  @$pb.TagNumber(2)
  set offset($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class DownloadChunkResponse extends $pb.GeneratedMessage {
  factory DownloadChunkResponse({
    Asset? asset,
    $core.List<$core.int>? data,
    $fixnum.Int64? nextOffset,
  }) {
    final result = DownloadChunkResponse._();
    if (asset != null) result.asset = asset;
    if (data != null) result.data = data;
    if (nextOffset != null) result.nextOffset = nextOffset;
    return result;
  }

  DownloadChunkResponse._();

  factory DownloadChunkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadChunkResponse()..mergeFromBuffer(data, registry);
  factory DownloadChunkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadChunkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadChunkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: DownloadChunkResponse.$_createMessage)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'nextOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadChunkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadChunkResponse copyWith(
          void Function(DownloadChunkResponse) updates) =>
      super.copyWith((message) => updates(message as DownloadChunkResponse))
          as DownloadChunkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DownloadChunkResponse() / DownloadChunkResponse.new instead')
  static DownloadChunkResponse create() => DownloadChunkResponse._();
  static $pb.GeneratedMessage $_createMessage() => DownloadChunkResponse._();
  @$core.override
  DownloadChunkResponse createEmptyInstance() => DownloadChunkResponse._();
  @$core.pragma('dart2js:noInline')
  static DownloadChunkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadChunkResponse>(
          DownloadChunkResponse.$_createMessage);
  static DownloadChunkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nextOffset => $_getI64(2);
  @$pb.TagNumber(3)
  set nextOffset($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextOffset() => $_clearField(3);
}

class ListMyAssetsRequest extends $pb.GeneratedMessage {
  factory ListMyAssetsRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = ListMyAssetsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  ListMyAssetsRequest._();

  factory ListMyAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMyAssetsRequest()..mergeFromBuffer(data, registry);
  factory ListMyAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMyAssetsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyAssetsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMyAssetsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyAssetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyAssetsRequest copyWith(void Function(ListMyAssetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListMyAssetsRequest))
          as ListMyAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListMyAssetsRequest() / ListMyAssetsRequest.new instead')
  static ListMyAssetsRequest create() => ListMyAssetsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListMyAssetsRequest._();
  @$core.override
  ListMyAssetsRequest createEmptyInstance() => ListMyAssetsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListMyAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyAssetsRequest>(
          ListMyAssetsRequest.$_createMessage);
  static ListMyAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class ListMyAssetsResponse extends $pb.GeneratedMessage {
  factory ListMyAssetsResponse({
    $core.Iterable<Asset>? assets,
    $core.String? nextCursor,
  }) {
    final result = ListMyAssetsResponse._();
    if (assets != null) result.assets.addAll(assets);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListMyAssetsResponse._();

  factory ListMyAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMyAssetsResponse()..mergeFromBuffer(data, registry);
  factory ListMyAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMyAssetsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyAssetsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMyAssetsResponse.$_createMessage)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets',
        subBuilder: Asset.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyAssetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyAssetsResponse copyWith(void Function(ListMyAssetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListMyAssetsResponse))
          as ListMyAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListMyAssetsResponse() / ListMyAssetsResponse.new instead')
  static ListMyAssetsResponse create() => ListMyAssetsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListMyAssetsResponse._();
  @$core.override
  ListMyAssetsResponse createEmptyInstance() => ListMyAssetsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListMyAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyAssetsResponse>(
          ListMyAssetsResponse.$_createMessage);
  static ListMyAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class ListChannelAssetsRequest extends $pb.GeneratedMessage {
  factory ListChannelAssetsRequest({
    $core.String? channelId,
    $core.String? after,
    $core.String? authorId,
  }) {
    final result = ListChannelAssetsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    if (authorId != null) result.authorId = authorId;
    return result;
  }

  ListChannelAssetsRequest._();

  factory ListChannelAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelAssetsRequest()..mergeFromBuffer(data, registry);
  factory ListChannelAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelAssetsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChannelAssetsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListChannelAssetsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..aOS(3, _omitFieldNames ? '' : 'authorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelAssetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelAssetsRequest copyWith(
          void Function(ListChannelAssetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListChannelAssetsRequest))
          as ListChannelAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListChannelAssetsRequest() / ListChannelAssetsRequest.new instead')
  static ListChannelAssetsRequest create() => ListChannelAssetsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListChannelAssetsRequest._();
  @$core.override
  ListChannelAssetsRequest createEmptyInstance() =>
      ListChannelAssetsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListChannelAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChannelAssetsRequest>(
          ListChannelAssetsRequest.$_createMessage);
  static ListChannelAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get authorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorId() => $_clearField(3);
}

class ListChannelAssetsResponse extends $pb.GeneratedMessage {
  factory ListChannelAssetsResponse({
    $core.Iterable<Asset>? assets,
    $core.String? nextCursor,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? authors,
  }) {
    final result = ListChannelAssetsResponse._();
    if (assets != null) result.assets.addAll(assets);
    if (nextCursor != null) result.nextCursor = nextCursor;
    if (authors != null) result.authors.addEntries(authors);
    return result;
  }

  ListChannelAssetsResponse._();

  factory ListChannelAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelAssetsResponse()..mergeFromBuffer(data, registry);
  factory ListChannelAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChannelAssetsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChannelAssetsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListChannelAssetsResponse.$_createMessage)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets',
        subBuilder: Asset.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'authors',
        entryClassName: 'ListChannelAssetsResponse.AuthorsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('space.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelAssetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelAssetsResponse copyWith(
          void Function(ListChannelAssetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListChannelAssetsResponse))
          as ListChannelAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListChannelAssetsResponse() / ListChannelAssetsResponse.new instead')
  static ListChannelAssetsResponse create() => ListChannelAssetsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListChannelAssetsResponse._();
  @$core.override
  ListChannelAssetsResponse createEmptyInstance() =>
      ListChannelAssetsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListChannelAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChannelAssetsResponse>(
          ListChannelAssetsResponse.$_createMessage);
  static ListChannelAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get authors => $_getMap(2);
}

class MlsDevice extends $pb.GeneratedMessage {
  factory MlsDevice({
    $core.String? grantId,
    $core.String? principalId,
    $core.List<$core.int>? binding,
    $core.List<$core.int>? keyPackage,
  }) {
    final result = MlsDevice._();
    if (grantId != null) result.grantId = grantId;
    if (principalId != null) result.principalId = principalId;
    if (binding != null) result.binding = binding;
    if (keyPackage != null) result.keyPackage = keyPackage;
    return result;
  }

  MlsDevice._();

  factory MlsDevice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MlsDevice()..mergeFromBuffer(data, registry);
  factory MlsDevice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MlsDevice()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MlsDevice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MlsDevice.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'grantId')
    ..aOS(2, _omitFieldNames ? '' : 'principalId')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'binding', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'keyPackage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MlsDevice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MlsDevice copyWith(void Function(MlsDevice) updates) =>
      super.copyWith((message) => updates(message as MlsDevice)) as MlsDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MlsDevice() / MlsDevice.new instead')
  static MlsDevice create() => MlsDevice._();
  static $pb.GeneratedMessage $_createMessage() => MlsDevice._();
  @$core.override
  MlsDevice createEmptyInstance() => MlsDevice._();
  @$core.pragma('dart2js:noInline')
  static MlsDevice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MlsDevice>(MlsDevice.$_createMessage);
  static MlsDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get grantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set grantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGrantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGrantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get principalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set principalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrincipalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get binding => $_getN(2);
  @$pb.TagNumber(3)
  set binding($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBinding() => $_has(2);
  @$pb.TagNumber(3)
  void clearBinding() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get keyPackage => $_getN(3);
  @$pb.TagNumber(4)
  set keyPackage($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKeyPackage() => $_has(3);
  @$pb.TagNumber(4)
  void clearKeyPackage() => $_clearField(4);
}

class RegisterMlsDeviceRequest extends $pb.GeneratedMessage {
  factory RegisterMlsDeviceRequest({
    $core.List<$core.int>? binding,
    $core.List<$core.int>? keyPackage,
  }) {
    final result = RegisterMlsDeviceRequest._();
    if (binding != null) result.binding = binding;
    if (keyPackage != null) result.keyPackage = keyPackage;
    return result;
  }

  RegisterMlsDeviceRequest._();

  factory RegisterMlsDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RegisterMlsDeviceRequest()..mergeFromBuffer(data, registry);
  factory RegisterMlsDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RegisterMlsDeviceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterMlsDeviceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RegisterMlsDeviceRequest.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'binding', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'keyPackage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMlsDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMlsDeviceRequest copyWith(
          void Function(RegisterMlsDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterMlsDeviceRequest))
          as RegisterMlsDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RegisterMlsDeviceRequest() / RegisterMlsDeviceRequest.new instead')
  static RegisterMlsDeviceRequest create() => RegisterMlsDeviceRequest._();
  static $pb.GeneratedMessage $_createMessage() => RegisterMlsDeviceRequest._();
  @$core.override
  RegisterMlsDeviceRequest createEmptyInstance() =>
      RegisterMlsDeviceRequest._();
  @$core.pragma('dart2js:noInline')
  static RegisterMlsDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterMlsDeviceRequest>(
          RegisterMlsDeviceRequest.$_createMessage);
  static RegisterMlsDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get binding => $_getN(0);
  @$pb.TagNumber(1)
  set binding($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBinding() => $_has(0);
  @$pb.TagNumber(1)
  void clearBinding() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get keyPackage => $_getN(1);
  @$pb.TagNumber(2)
  set keyPackage($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyPackage() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyPackage() => $_clearField(2);
}

class RegisterMlsDeviceResponse extends $pb.GeneratedMessage {
  factory RegisterMlsDeviceResponse({
    MlsDevice? device,
  }) {
    final result = RegisterMlsDeviceResponse._();
    if (device != null) result.device = device;
    return result;
  }

  RegisterMlsDeviceResponse._();

  factory RegisterMlsDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RegisterMlsDeviceResponse()..mergeFromBuffer(data, registry);
  factory RegisterMlsDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RegisterMlsDeviceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterMlsDeviceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RegisterMlsDeviceResponse.$_createMessage)
    ..aOM<MlsDevice>(1, _omitFieldNames ? '' : 'device',
        subBuilder: MlsDevice.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMlsDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterMlsDeviceResponse copyWith(
          void Function(RegisterMlsDeviceResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterMlsDeviceResponse))
          as RegisterMlsDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RegisterMlsDeviceResponse() / RegisterMlsDeviceResponse.new instead')
  static RegisterMlsDeviceResponse create() => RegisterMlsDeviceResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RegisterMlsDeviceResponse._();
  @$core.override
  RegisterMlsDeviceResponse createEmptyInstance() =>
      RegisterMlsDeviceResponse._();
  @$core.pragma('dart2js:noInline')
  static RegisterMlsDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterMlsDeviceResponse>(
          RegisterMlsDeviceResponse.$_createMessage);
  static RegisterMlsDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MlsDevice get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(MlsDevice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  MlsDevice ensureDevice() => $_ensure(0);
}

class ListMlsDevicesRequest extends $pb.GeneratedMessage {
  factory ListMlsDevicesRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = ListMlsDevicesRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  ListMlsDevicesRequest._();

  factory ListMlsDevicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsDevicesRequest()..mergeFromBuffer(data, registry);
  factory ListMlsDevicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsDevicesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMlsDevicesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMlsDevicesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsDevicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsDevicesRequest copyWith(
          void Function(ListMlsDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListMlsDevicesRequest))
          as ListMlsDevicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListMlsDevicesRequest() / ListMlsDevicesRequest.new instead')
  static ListMlsDevicesRequest create() => ListMlsDevicesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListMlsDevicesRequest._();
  @$core.override
  ListMlsDevicesRequest createEmptyInstance() => ListMlsDevicesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListMlsDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMlsDevicesRequest>(
          ListMlsDevicesRequest.$_createMessage);
  static ListMlsDevicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class ListMlsDevicesResponse extends $pb.GeneratedMessage {
  factory ListMlsDevicesResponse({
    $core.Iterable<MlsDevice>? devices,
    $core.String? nextCursor,
  }) {
    final result = ListMlsDevicesResponse._();
    if (devices != null) result.devices.addAll(devices);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListMlsDevicesResponse._();

  factory ListMlsDevicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsDevicesResponse()..mergeFromBuffer(data, registry);
  factory ListMlsDevicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsDevicesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMlsDevicesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMlsDevicesResponse.$_createMessage)
    ..pPM<MlsDevice>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: MlsDevice.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsDevicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsDevicesResponse copyWith(
          void Function(ListMlsDevicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListMlsDevicesResponse))
          as ListMlsDevicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListMlsDevicesResponse() / ListMlsDevicesResponse.new instead')
  static ListMlsDevicesResponse create() => ListMlsDevicesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListMlsDevicesResponse._();
  @$core.override
  ListMlsDevicesResponse createEmptyInstance() => ListMlsDevicesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListMlsDevicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMlsDevicesResponse>(
          ListMlsDevicesResponse.$_createMessage);
  static ListMlsDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MlsDevice> get devices => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class GetMlsChannelRequest extends $pb.GeneratedMessage {
  factory GetMlsChannelRequest({
    $core.String? channelId,
  }) {
    final result = GetMlsChannelRequest._();
    if (channelId != null) result.channelId = channelId;
    return result;
  }

  GetMlsChannelRequest._();

  factory GetMlsChannelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMlsChannelRequest()..mergeFromBuffer(data, registry);
  factory GetMlsChannelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMlsChannelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMlsChannelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetMlsChannelRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMlsChannelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMlsChannelRequest copyWith(void Function(GetMlsChannelRequest) updates) =>
      super.copyWith((message) => updates(message as GetMlsChannelRequest))
          as GetMlsChannelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMlsChannelRequest() / GetMlsChannelRequest.new instead')
  static GetMlsChannelRequest create() => GetMlsChannelRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMlsChannelRequest._();
  @$core.override
  GetMlsChannelRequest createEmptyInstance() => GetMlsChannelRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMlsChannelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMlsChannelRequest>(
          GetMlsChannelRequest.$_createMessage);
  static GetMlsChannelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);
}

class GetMlsChannelResponse extends $pb.GeneratedMessage {
  factory GetMlsChannelResponse({
    $core.List<$core.int>? groupId,
    $fixnum.Int64? epoch,
    $core.Iterable<MlsDevice>? devices,
  }) {
    final result = GetMlsChannelResponse._();
    if (groupId != null) result.groupId = groupId;
    if (epoch != null) result.epoch = epoch;
    if (devices != null) result.devices.addAll(devices);
    return result;
  }

  GetMlsChannelResponse._();

  factory GetMlsChannelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMlsChannelResponse()..mergeFromBuffer(data, registry);
  factory GetMlsChannelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMlsChannelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMlsChannelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetMlsChannelResponse.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'groupId', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'epoch')
    ..pPM<MlsDevice>(3, _omitFieldNames ? '' : 'devices',
        subBuilder: MlsDevice.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMlsChannelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMlsChannelResponse copyWith(
          void Function(GetMlsChannelResponse) updates) =>
      super.copyWith((message) => updates(message as GetMlsChannelResponse))
          as GetMlsChannelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMlsChannelResponse() / GetMlsChannelResponse.new instead')
  static GetMlsChannelResponse create() => GetMlsChannelResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetMlsChannelResponse._();
  @$core.override
  GetMlsChannelResponse createEmptyInstance() => GetMlsChannelResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMlsChannelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMlsChannelResponse>(
          GetMlsChannelResponse.$_createMessage);
  static GetMlsChannelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get groupId => $_getN(0);
  @$pb.TagNumber(1)
  set groupId($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get epoch => $_getI64(1);
  @$pb.TagNumber(2)
  set epoch($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpoch() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpoch() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<MlsDevice> get devices => $_getList(2);
}

class PublishMlsRequest extends $pb.GeneratedMessage {
  factory PublishMlsRequest({
    $core.String? channelId,
    $core.List<$core.int>? requestId,
    $fixnum.Int64? expectedEpoch,
    $core.String? kind,
    $core.List<$core.int>? ciphertext,
    $core.String? addGrantId,
    $core.String? removeGrantId,
    $core.List<$core.int>? welcome,
    $core.Iterable<$core.String>? attachmentIds,
    $core.String? newManagerGrantId,
  }) {
    final result = PublishMlsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (requestId != null) result.requestId = requestId;
    if (expectedEpoch != null) result.expectedEpoch = expectedEpoch;
    if (kind != null) result.kind = kind;
    if (ciphertext != null) result.ciphertext = ciphertext;
    if (addGrantId != null) result.addGrantId = addGrantId;
    if (removeGrantId != null) result.removeGrantId = removeGrantId;
    if (welcome != null) result.welcome = welcome;
    if (attachmentIds != null) result.attachmentIds.addAll(attachmentIds);
    if (newManagerGrantId != null) result.newManagerGrantId = newManagerGrantId;
    return result;
  }

  PublishMlsRequest._();

  factory PublishMlsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishMlsRequest()..mergeFromBuffer(data, registry);
  factory PublishMlsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishMlsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishMlsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PublishMlsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'expectedEpoch')
    ..aOS(4, _omitFieldNames ? '' : 'kind')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'ciphertext', $pb.PbFieldType.OY)
    ..aOS(6, _omitFieldNames ? '' : 'addGrantId')
    ..aOS(7, _omitFieldNames ? '' : 'removeGrantId')
    ..a<$core.List<$core.int>>(
        8, _omitFieldNames ? '' : 'welcome', $pb.PbFieldType.OY)
    ..pPS(9, _omitFieldNames ? '' : 'attachmentIds')
    ..aOS(10, _omitFieldNames ? '' : 'newManagerGrantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishMlsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishMlsRequest copyWith(void Function(PublishMlsRequest) updates) =>
      super.copyWith((message) => updates(message as PublishMlsRequest))
          as PublishMlsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PublishMlsRequest() / PublishMlsRequest.new instead')
  static PublishMlsRequest create() => PublishMlsRequest._();
  static $pb.GeneratedMessage $_createMessage() => PublishMlsRequest._();
  @$core.override
  PublishMlsRequest createEmptyInstance() => PublishMlsRequest._();
  @$core.pragma('dart2js:noInline')
  static PublishMlsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishMlsRequest>(
          PublishMlsRequest.$_createMessage);
  static PublishMlsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get requestId => $_getN(1);
  @$pb.TagNumber(2)
  set requestId($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedEpoch => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedEpoch($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedEpoch() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedEpoch() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get kind => $_getSZ(3);
  @$pb.TagNumber(4)
  set kind($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get ciphertext => $_getN(4);
  @$pb.TagNumber(5)
  set ciphertext($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCiphertext() => $_has(4);
  @$pb.TagNumber(5)
  void clearCiphertext() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get addGrantId => $_getSZ(5);
  @$pb.TagNumber(6)
  set addGrantId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAddGrantId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAddGrantId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get removeGrantId => $_getSZ(6);
  @$pb.TagNumber(7)
  set removeGrantId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRemoveGrantId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemoveGrantId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get welcome => $_getN(7);
  @$pb.TagNumber(8)
  set welcome($core.List<$core.int> value) => $_setBytes(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWelcome() => $_has(7);
  @$pb.TagNumber(8)
  void clearWelcome() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get attachmentIds => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get newManagerGrantId => $_getSZ(9);
  @$pb.TagNumber(10)
  set newManagerGrantId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNewManagerGrantId() => $_has(9);
  @$pb.TagNumber(10)
  void clearNewManagerGrantId() => $_clearField(10);
}

class MlsEnvelope extends $pb.GeneratedMessage {
  factory MlsEnvelope({
    $fixnum.Int64? sequence,
    $core.List<$core.int>? requestId,
    $fixnum.Int64? epoch,
    $core.String? kind,
    $core.List<$core.int>? ciphertext,
    $core.String? authorGrantId,
    $core.String? authorId,
    $fixnum.Int64? createdAtUnixMs,
    $core.String? addedGrantId,
    $core.String? removedGrantId,
    $core.List<$core.int>? welcome,
    $core.Iterable<MlsDevice>? roster,
    $core.String? newManagerGrantId,
  }) {
    final result = MlsEnvelope._();
    if (sequence != null) result.sequence = sequence;
    if (requestId != null) result.requestId = requestId;
    if (epoch != null) result.epoch = epoch;
    if (kind != null) result.kind = kind;
    if (ciphertext != null) result.ciphertext = ciphertext;
    if (authorGrantId != null) result.authorGrantId = authorGrantId;
    if (authorId != null) result.authorId = authorId;
    if (createdAtUnixMs != null) result.createdAtUnixMs = createdAtUnixMs;
    if (addedGrantId != null) result.addedGrantId = addedGrantId;
    if (removedGrantId != null) result.removedGrantId = removedGrantId;
    if (welcome != null) result.welcome = welcome;
    if (roster != null) result.roster.addAll(roster);
    if (newManagerGrantId != null) result.newManagerGrantId = newManagerGrantId;
    return result;
  }

  MlsEnvelope._();

  factory MlsEnvelope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MlsEnvelope()..mergeFromBuffer(data, registry);
  factory MlsEnvelope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MlsEnvelope()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MlsEnvelope',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MlsEnvelope.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'sequence')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'epoch')
    ..aOS(4, _omitFieldNames ? '' : 'kind')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'ciphertext', $pb.PbFieldType.OY)
    ..aOS(6, _omitFieldNames ? '' : 'authorGrantId')
    ..aOS(7, _omitFieldNames ? '' : 'authorId')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtUnixMs')
    ..aOS(9, _omitFieldNames ? '' : 'addedGrantId')
    ..aOS(10, _omitFieldNames ? '' : 'removedGrantId')
    ..a<$core.List<$core.int>>(
        11, _omitFieldNames ? '' : 'welcome', $pb.PbFieldType.OY)
    ..pPM<MlsDevice>(12, _omitFieldNames ? '' : 'roster',
        subBuilder: MlsDevice.$_createMessage)
    ..aOS(13, _omitFieldNames ? '' : 'newManagerGrantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MlsEnvelope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MlsEnvelope copyWith(void Function(MlsEnvelope) updates) =>
      super.copyWith((message) => updates(message as MlsEnvelope))
          as MlsEnvelope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MlsEnvelope() / MlsEnvelope.new instead')
  static MlsEnvelope create() => MlsEnvelope._();
  static $pb.GeneratedMessage $_createMessage() => MlsEnvelope._();
  @$core.override
  MlsEnvelope createEmptyInstance() => MlsEnvelope._();
  @$core.pragma('dart2js:noInline')
  static MlsEnvelope getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MlsEnvelope>(
          MlsEnvelope.$_createMessage);
  static MlsEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sequence => $_getI64(0);
  @$pb.TagNumber(1)
  set sequence($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get requestId => $_getN(1);
  @$pb.TagNumber(2)
  set requestId($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get epoch => $_getI64(2);
  @$pb.TagNumber(3)
  set epoch($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEpoch() => $_has(2);
  @$pb.TagNumber(3)
  void clearEpoch() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get kind => $_getSZ(3);
  @$pb.TagNumber(4)
  set kind($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get ciphertext => $_getN(4);
  @$pb.TagNumber(5)
  set ciphertext($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCiphertext() => $_has(4);
  @$pb.TagNumber(5)
  void clearCiphertext() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get authorGrantId => $_getSZ(5);
  @$pb.TagNumber(6)
  set authorGrantId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAuthorGrantId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthorGrantId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get authorId => $_getSZ(6);
  @$pb.TagNumber(7)
  set authorId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthorId() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthorId() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAtUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAtUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAtUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAtUnixMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get addedGrantId => $_getSZ(8);
  @$pb.TagNumber(9)
  set addedGrantId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAddedGrantId() => $_has(8);
  @$pb.TagNumber(9)
  void clearAddedGrantId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get removedGrantId => $_getSZ(9);
  @$pb.TagNumber(10)
  set removedGrantId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRemovedGrantId() => $_has(9);
  @$pb.TagNumber(10)
  void clearRemovedGrantId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.int> get welcome => $_getN(10);
  @$pb.TagNumber(11)
  set welcome($core.List<$core.int> value) => $_setBytes(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWelcome() => $_has(10);
  @$pb.TagNumber(11)
  void clearWelcome() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<MlsDevice> get roster => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get newManagerGrantId => $_getSZ(12);
  @$pb.TagNumber(13)
  set newManagerGrantId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNewManagerGrantId() => $_has(12);
  @$pb.TagNumber(13)
  void clearNewManagerGrantId() => $_clearField(13);
}

class PublishMlsResponse extends $pb.GeneratedMessage {
  factory PublishMlsResponse({
    MlsEnvelope? envelope,
  }) {
    final result = PublishMlsResponse._();
    if (envelope != null) result.envelope = envelope;
    return result;
  }

  PublishMlsResponse._();

  factory PublishMlsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishMlsResponse()..mergeFromBuffer(data, registry);
  factory PublishMlsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishMlsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishMlsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PublishMlsResponse.$_createMessage)
    ..aOM<MlsEnvelope>(1, _omitFieldNames ? '' : 'envelope',
        subBuilder: MlsEnvelope.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishMlsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishMlsResponse copyWith(void Function(PublishMlsResponse) updates) =>
      super.copyWith((message) => updates(message as PublishMlsResponse))
          as PublishMlsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PublishMlsResponse() / PublishMlsResponse.new instead')
  static PublishMlsResponse create() => PublishMlsResponse._();
  static $pb.GeneratedMessage $_createMessage() => PublishMlsResponse._();
  @$core.override
  PublishMlsResponse createEmptyInstance() => PublishMlsResponse._();
  @$core.pragma('dart2js:noInline')
  static PublishMlsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishMlsResponse>(
          PublishMlsResponse.$_createMessage);
  static PublishMlsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MlsEnvelope get envelope => $_getN(0);
  @$pb.TagNumber(1)
  set envelope(MlsEnvelope value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEnvelope() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnvelope() => $_clearField(1);
  @$pb.TagNumber(1)
  MlsEnvelope ensureEnvelope() => $_ensure(0);
}

class ListMlsEnvelopesRequest extends $pb.GeneratedMessage {
  factory ListMlsEnvelopesRequest({
    $core.String? channelId,
    $fixnum.Int64? afterSequence,
  }) {
    final result = ListMlsEnvelopesRequest._();
    if (channelId != null) result.channelId = channelId;
    if (afterSequence != null) result.afterSequence = afterSequence;
    return result;
  }

  ListMlsEnvelopesRequest._();

  factory ListMlsEnvelopesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsEnvelopesRequest()..mergeFromBuffer(data, registry);
  factory ListMlsEnvelopesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsEnvelopesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMlsEnvelopesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMlsEnvelopesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'afterSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsEnvelopesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsEnvelopesRequest copyWith(
          void Function(ListMlsEnvelopesRequest) updates) =>
      super.copyWith((message) => updates(message as ListMlsEnvelopesRequest))
          as ListMlsEnvelopesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListMlsEnvelopesRequest() / ListMlsEnvelopesRequest.new instead')
  static ListMlsEnvelopesRequest create() => ListMlsEnvelopesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListMlsEnvelopesRequest._();
  @$core.override
  ListMlsEnvelopesRequest createEmptyInstance() => ListMlsEnvelopesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListMlsEnvelopesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMlsEnvelopesRequest>(
          ListMlsEnvelopesRequest.$_createMessage);
  static ListMlsEnvelopesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get afterSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set afterSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfterSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfterSequence() => $_clearField(2);
}

class ListMlsEnvelopesResponse extends $pb.GeneratedMessage {
  factory ListMlsEnvelopesResponse({
    $core.Iterable<MlsEnvelope>? envelopes,
    $fixnum.Int64? nextSequence,
  }) {
    final result = ListMlsEnvelopesResponse._();
    if (envelopes != null) result.envelopes.addAll(envelopes);
    if (nextSequence != null) result.nextSequence = nextSequence;
    return result;
  }

  ListMlsEnvelopesResponse._();

  factory ListMlsEnvelopesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsEnvelopesResponse()..mergeFromBuffer(data, registry);
  factory ListMlsEnvelopesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMlsEnvelopesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMlsEnvelopesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMlsEnvelopesResponse.$_createMessage)
    ..pPM<MlsEnvelope>(1, _omitFieldNames ? '' : 'envelopes',
        subBuilder: MlsEnvelope.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsEnvelopesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMlsEnvelopesResponse copyWith(
          void Function(ListMlsEnvelopesResponse) updates) =>
      super.copyWith((message) => updates(message as ListMlsEnvelopesResponse))
          as ListMlsEnvelopesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListMlsEnvelopesResponse() / ListMlsEnvelopesResponse.new instead')
  static ListMlsEnvelopesResponse create() => ListMlsEnvelopesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListMlsEnvelopesResponse._();
  @$core.override
  ListMlsEnvelopesResponse createEmptyInstance() =>
      ListMlsEnvelopesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListMlsEnvelopesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMlsEnvelopesResponse>(
          ListMlsEnvelopesResponse.$_createMessage);
  static ListMlsEnvelopesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MlsEnvelope> get envelopes => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set nextSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextSequence() => $_clearField(2);
}

/// Один участник учитывается один раз, независимо от числа устройств.
class Reaction extends $pb.GeneratedMessage {
  factory Reaction({
    $core.String? emoji,
    $core.Iterable<$core.String>? principalIds,
  }) {
    final result = Reaction._();
    if (emoji != null) result.emoji = emoji;
    if (principalIds != null) result.principalIds.addAll(principalIds);
    return result;
  }

  Reaction._();

  factory Reaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Reaction()..mergeFromBuffer(data, registry);
  factory Reaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Reaction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Reaction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'emoji')
    ..pPS(2, _omitFieldNames ? '' : 'principalIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reaction copyWith(void Function(Reaction) updates) =>
      super.copyWith((message) => updates(message as Reaction)) as Reaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Reaction() / Reaction.new instead')
  static Reaction create() => Reaction._();
  static $pb.GeneratedMessage $_createMessage() => Reaction._();
  @$core.override
  Reaction createEmptyInstance() => Reaction._();
  @$core.pragma('dart2js:noInline')
  static Reaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Reaction>(Reaction.$_createMessage);
  static Reaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get emoji => $_getSZ(0);
  @$pb.TagNumber(1)
  set emoji($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmoji() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmoji() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get principalIds => $_getList(1);
}

class SetReactionRequest extends $pb.GeneratedMessage {
  factory SetReactionRequest({
    $core.String? channelId,
    $core.String? id,
    $core.String? emoji,
    $core.bool? active,
    $fixnum.Int64? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = SetReactionRequest._();
    if (channelId != null) result.channelId = channelId;
    if (id != null) result.id = id;
    if (emoji != null) result.emoji = emoji;
    if (active != null) result.active = active;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  SetReactionRequest._();

  factory SetReactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetReactionRequest()..mergeFromBuffer(data, registry);
  factory SetReactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetReactionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetReactionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetReactionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'emoji')
    ..aOB(4, _omitFieldNames ? '' : 'active')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(6, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetReactionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetReactionRequest copyWith(void Function(SetReactionRequest) updates) =>
      super.copyWith((message) => updates(message as SetReactionRequest))
          as SetReactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SetReactionRequest() / SetReactionRequest.new instead')
  static SetReactionRequest create() => SetReactionRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetReactionRequest._();
  @$core.override
  SetReactionRequest createEmptyInstance() => SetReactionRequest._();
  @$core.pragma('dart2js:noInline')
  static SetReactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetReactionRequest>(
          SetReactionRequest.$_createMessage);
  static SetReactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get emoji => $_getSZ(2);
  @$pb.TagNumber(3)
  set emoji($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmoji() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmoji() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get active => $_getBF(3);
  @$pb.TagNumber(4)
  set active($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActive() => $_has(3);
  @$pb.TagNumber(4)
  void clearActive() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expectedRevision => $_getI64(4);
  @$pb.TagNumber(5)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpectedRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpectedRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get idempotencyKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set idempotencyKey($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdempotencyKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdempotencyKey() => $_clearField(6);
}

class SetReactionResponse extends $pb.GeneratedMessage {
  factory SetReactionResponse({
    Content? content,
    $core.String? idempotencyKey,
    $fixnum.Int64? appliedRevision,
  }) {
    final result = SetReactionResponse._();
    if (content != null) result.content = content;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (appliedRevision != null) result.appliedRevision = appliedRevision;
    return result;
  }

  SetReactionResponse._();

  factory SetReactionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetReactionResponse()..mergeFromBuffer(data, registry);
  factory SetReactionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetReactionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetReactionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetReactionResponse.$_createMessage)
    ..aOM<Content>(1, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'idempotencyKey')
    ..aInt64(3, _omitFieldNames ? '' : 'appliedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetReactionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetReactionResponse copyWith(void Function(SetReactionResponse) updates) =>
      super.copyWith((message) => updates(message as SetReactionResponse))
          as SetReactionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use SetReactionResponse() / SetReactionResponse.new instead')
  static SetReactionResponse create() => SetReactionResponse._();
  static $pb.GeneratedMessage $_createMessage() => SetReactionResponse._();
  @$core.override
  SetReactionResponse createEmptyInstance() => SetReactionResponse._();
  @$core.pragma('dart2js:noInline')
  static SetReactionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetReactionResponse>(
          SetReactionResponse.$_createMessage);
  static SetReactionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Content get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(Content value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  Content ensureContent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get idempotencyKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set idempotencyKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdempotencyKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdempotencyKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get appliedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set appliedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppliedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppliedRevision() => $_clearField(3);
}

enum ApplyContentMutationRequest_Action { update, delete, reaction, notSet }

class ApplyContentMutationRequest extends $pb.GeneratedMessage {
  factory ApplyContentMutationRequest({
    UpdateContentRequest? update,
    DeleteContentRequest? delete,
    SetReactionRequest? reaction,
  }) {
    final result = ApplyContentMutationRequest._();
    if (update != null) result.update = update;
    if (delete != null) result.delete = delete;
    if (reaction != null) result.reaction = reaction;
    return result;
  }

  ApplyContentMutationRequest._();

  factory ApplyContentMutationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyContentMutationRequest()..mergeFromBuffer(data, registry);
  factory ApplyContentMutationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyContentMutationRequest()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ApplyContentMutationRequest_Action>
      _ApplyContentMutationRequest_ActionByTag = {
    1: ApplyContentMutationRequest_Action.update,
    2: ApplyContentMutationRequest_Action.delete,
    3: ApplyContentMutationRequest_Action.reaction,
    0: ApplyContentMutationRequest_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyContentMutationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ApplyContentMutationRequest.$_createMessage)
    ..oo(0, [1, 2, 3])
    ..aOM<UpdateContentRequest>(1, _omitFieldNames ? '' : 'update',
        subBuilder: UpdateContentRequest.$_createMessage)
    ..aOM<DeleteContentRequest>(2, _omitFieldNames ? '' : 'delete',
        subBuilder: DeleteContentRequest.$_createMessage)
    ..aOM<SetReactionRequest>(3, _omitFieldNames ? '' : 'reaction',
        subBuilder: SetReactionRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyContentMutationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyContentMutationRequest copyWith(
          void Function(ApplyContentMutationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApplyContentMutationRequest))
          as ApplyContentMutationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ApplyContentMutationRequest() / ApplyContentMutationRequest.new instead')
  static ApplyContentMutationRequest create() =>
      ApplyContentMutationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ApplyContentMutationRequest._();
  @$core.override
  ApplyContentMutationRequest createEmptyInstance() =>
      ApplyContentMutationRequest._();
  @$core.pragma('dart2js:noInline')
  static ApplyContentMutationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyContentMutationRequest>(
          ApplyContentMutationRequest.$_createMessage);
  static ApplyContentMutationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  ApplyContentMutationRequest_Action whichAction() =>
      _ApplyContentMutationRequest_ActionByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearAction() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  UpdateContentRequest get update => $_getN(0);
  @$pb.TagNumber(1)
  set update(UpdateContentRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdate() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdate() => $_clearField(1);
  @$pb.TagNumber(1)
  UpdateContentRequest ensureUpdate() => $_ensure(0);

  @$pb.TagNumber(2)
  DeleteContentRequest get delete => $_getN(1);
  @$pb.TagNumber(2)
  set delete(DeleteContentRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDelete() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelete() => $_clearField(2);
  @$pb.TagNumber(2)
  DeleteContentRequest ensureDelete() => $_ensure(1);

  @$pb.TagNumber(3)
  SetReactionRequest get reaction => $_getN(2);
  @$pb.TagNumber(3)
  set reaction(SetReactionRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReaction() => $_has(2);
  @$pb.TagNumber(3)
  void clearReaction() => $_clearField(3);
  @$pb.TagNumber(3)
  SetReactionRequest ensureReaction() => $_ensure(2);
}

class ApplyContentMutationResponse extends $pb.GeneratedMessage {
  factory ApplyContentMutationResponse({
    Content? content,
    $core.String? idempotencyKey,
    $fixnum.Int64? appliedRevision,
  }) {
    final result = ApplyContentMutationResponse._();
    if (content != null) result.content = content;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (appliedRevision != null) result.appliedRevision = appliedRevision;
    return result;
  }

  ApplyContentMutationResponse._();

  factory ApplyContentMutationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyContentMutationResponse()..mergeFromBuffer(data, registry);
  factory ApplyContentMutationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyContentMutationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyContentMutationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ApplyContentMutationResponse.$_createMessage)
    ..aOM<Content>(1, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'idempotencyKey')
    ..aInt64(3, _omitFieldNames ? '' : 'appliedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyContentMutationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyContentMutationResponse copyWith(
          void Function(ApplyContentMutationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ApplyContentMutationResponse))
          as ApplyContentMutationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ApplyContentMutationResponse() / ApplyContentMutationResponse.new instead')
  static ApplyContentMutationResponse create() =>
      ApplyContentMutationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ApplyContentMutationResponse._();
  @$core.override
  ApplyContentMutationResponse createEmptyInstance() =>
      ApplyContentMutationResponse._();
  @$core.pragma('dart2js:noInline')
  static ApplyContentMutationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyContentMutationResponse>(
          ApplyContentMutationResponse.$_createMessage);
  static ApplyContentMutationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Content get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(Content value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  Content ensureContent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get idempotencyKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set idempotencyKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdempotencyKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdempotencyKey() => $_clearField(2);

  /// Версия именно этого действия; content может содержать более новую версию.
  @$pb.TagNumber(3)
  $fixnum.Int64 get appliedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set appliedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppliedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppliedRevision() => $_clearField(3);
}

/// Буквальный поиск подстроки без учёта регистра в одном обычном канале.
/// Запрос: 2–128 символов, максимум 512 байт. Страница: не более 50 записей.
class SearchContentRequest extends $pb.GeneratedMessage {
  factory SearchContentRequest({
    $core.String? channelId,
    $core.String? query,
    $fixnum.Int64? beforeSequence,
  }) {
    final result = SearchContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (query != null) result.query = query;
    if (beforeSequence != null) result.beforeSequence = beforeSequence;
    return result;
  }

  SearchContentRequest._();

  factory SearchContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchContentRequest()..mergeFromBuffer(data, registry);
  factory SearchContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SearchContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..aInt64(3, _omitFieldNames ? '' : 'beforeSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchContentRequest copyWith(void Function(SearchContentRequest) updates) =>
      super.copyWith((message) => updates(message as SearchContentRequest))
          as SearchContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchContentRequest() / SearchContentRequest.new instead')
  static SearchContentRequest create() => SearchContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchContentRequest._();
  @$core.override
  SearchContentRequest createEmptyInstance() => SearchContentRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchContentRequest>(
          SearchContentRequest.$_createMessage);
  static SearchContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get beforeSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set beforeSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBeforeSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearBeforeSequence() => $_clearField(3);
}

class SearchContentResponse extends $pb.GeneratedMessage {
  factory SearchContentResponse({
    $core.Iterable<Content>? contents,
    $fixnum.Int64? nextBeforeSequence,
  }) {
    final result = SearchContentResponse._();
    if (contents != null) result.contents.addAll(contents);
    if (nextBeforeSequence != null)
      result.nextBeforeSequence = nextBeforeSequence;
    return result;
  }

  SearchContentResponse._();

  factory SearchContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchContentResponse()..mergeFromBuffer(data, registry);
  factory SearchContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SearchContentResponse.$_createMessage)
    ..pPM<Content>(1, _omitFieldNames ? '' : 'contents',
        subBuilder: Content.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextBeforeSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchContentResponse copyWith(
          void Function(SearchContentResponse) updates) =>
      super.copyWith((message) => updates(message as SearchContentResponse))
          as SearchContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchContentResponse() / SearchContentResponse.new instead')
  static SearchContentResponse create() => SearchContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => SearchContentResponse._();
  @$core.override
  SearchContentResponse createEmptyInstance() => SearchContentResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchContentResponse>(
          SearchContentResponse.$_createMessage);
  static SearchContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Content> get contents => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextBeforeSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set nextBeforeSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextBeforeSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextBeforeSequence() => $_clearField(2);
}

/// Свежая страница обычного канала. before_sequence=0 открывает конец истории.
class GetHistoryPageRequest extends $pb.GeneratedMessage {
  factory GetHistoryPageRequest({
    $core.String? channelId,
    $fixnum.Int64? beforeSequence,
  }) {
    final result = GetHistoryPageRequest._();
    if (channelId != null) result.channelId = channelId;
    if (beforeSequence != null) result.beforeSequence = beforeSequence;
    return result;
  }

  GetHistoryPageRequest._();

  factory GetHistoryPageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHistoryPageRequest()..mergeFromBuffer(data, registry);
  factory GetHistoryPageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHistoryPageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHistoryPageRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetHistoryPageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'beforeSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryPageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryPageRequest copyWith(
          void Function(GetHistoryPageRequest) updates) =>
      super.copyWith((message) => updates(message as GetHistoryPageRequest))
          as GetHistoryPageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHistoryPageRequest() / GetHistoryPageRequest.new instead')
  static GetHistoryPageRequest create() => GetHistoryPageRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetHistoryPageRequest._();
  @$core.override
  GetHistoryPageRequest createEmptyInstance() => GetHistoryPageRequest._();
  @$core.pragma('dart2js:noInline')
  static GetHistoryPageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHistoryPageRequest>(
          GetHistoryPageRequest.$_createMessage);
  static GetHistoryPageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get beforeSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set beforeSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBeforeSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearBeforeSequence() => $_clearField(2);
}

class GetHistoryPageResponse extends $pb.GeneratedMessage {
  factory GetHistoryPageResponse({
    $core.Iterable<Content>? contents,
    $fixnum.Int64? nextBeforeSequence,
    $core.String? eventCursor,
  }) {
    final result = GetHistoryPageResponse._();
    if (contents != null) result.contents.addAll(contents);
    if (nextBeforeSequence != null)
      result.nextBeforeSequence = nextBeforeSequence;
    if (eventCursor != null) result.eventCursor = eventCursor;
    return result;
  }

  GetHistoryPageResponse._();

  factory GetHistoryPageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHistoryPageResponse()..mergeFromBuffer(data, registry);
  factory GetHistoryPageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHistoryPageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHistoryPageResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetHistoryPageResponse.$_createMessage)
    ..pPM<Content>(1, _omitFieldNames ? '' : 'contents',
        subBuilder: Content.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextBeforeSequence')
    ..aOS(3, _omitFieldNames ? '' : 'eventCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryPageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHistoryPageResponse copyWith(
          void Function(GetHistoryPageResponse) updates) =>
      super.copyWith((message) => updates(message as GetHistoryPageResponse))
          as GetHistoryPageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHistoryPageResponse() / GetHistoryPageResponse.new instead')
  static GetHistoryPageResponse create() => GetHistoryPageResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetHistoryPageResponse._();
  @$core.override
  GetHistoryPageResponse createEmptyInstance() => GetHistoryPageResponse._();
  @$core.pragma('dart2js:noInline')
  static GetHistoryPageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHistoryPageResponse>(
          GetHistoryPageResponse.$_createMessage);
  static GetHistoryPageResponse? _defaultInstance;

  /// Не более 100 записей, по возрастанию sequence, включая tombstone.
  @$pb.TagNumber(1)
  $pb.PbList<Content> get contents => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextBeforeSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set nextBeforeSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextBeforeSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextBeforeSequence() => $_clearField(2);

  /// Курсор событий, согласованный со страницей в одной транзакции.
  @$pb.TagNumber(3)
  $core.String get eventCursor => $_getSZ(2);
  @$pb.TagNumber(3)
  set eventCursor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEventCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventCursor() => $_clearField(3);
}

/// Экспериментальный контракт первого локального прототипа.
class ChannelServiceApi {
  final $pb.RpcClient _client;

  ChannelServiceApi(this._client);

  $async.Future<WatchChannelsResponse> watchChannels(
          $pb.ClientContext? ctx, WatchChannelsRequest request) =>
      _client.invoke<WatchChannelsResponse>(ctx, 'ChannelService',
          'WatchChannels', request, WatchChannelsResponse());
  $async.Future<ListChannelsResponse> listChannels(
          $pb.ClientContext? ctx, ListChannelsRequest request) =>
      _client.invoke<ListChannelsResponse>(ctx, 'ChannelService',
          'ListChannels', request, ListChannelsResponse());
  $async.Future<CreateChannelResponse> createChannel(
          $pb.ClientContext? ctx, CreateChannelRequest request) =>
      _client.invoke<CreateChannelResponse>(ctx, 'ChannelService',
          'CreateChannel', request, CreateChannelResponse());
  $async.Future<UpdateChannelResponse> updateChannel(
          $pb.ClientContext? ctx, UpdateChannelRequest request) =>
      _client.invoke<UpdateChannelResponse>(ctx, 'ChannelService',
          'UpdateChannel', request, UpdateChannelResponse());
  $async.Future<DeleteChannelResponse> deleteChannel(
          $pb.ClientContext? ctx, DeleteChannelRequest request) =>
      _client.invoke<DeleteChannelResponse>(ctx, 'ChannelService',
          'DeleteChannel', request, DeleteChannelResponse());
  $async.Future<GetChannelAccessResponse> getChannelAccess(
          $pb.ClientContext? ctx, GetChannelAccessRequest request) =>
      _client.invoke<GetChannelAccessResponse>(ctx, 'ChannelService',
          'GetChannelAccess', request, GetChannelAccessResponse());
  $async.Future<UpdateChannelAccessResponse> updateChannelAccess(
          $pb.ClientContext? ctx, UpdateChannelAccessRequest request) =>
      _client.invoke<UpdateChannelAccessResponse>(ctx, 'ChannelService',
          'UpdateChannelAccess', request, UpdateChannelAccessResponse());
  $async.Future<GetManifestResponse> getManifest(
          $pb.ClientContext? ctx, GetManifestRequest request) =>
      _client.invoke<GetManifestResponse>(
          ctx, 'ChannelService', 'GetManifest', request, GetManifestResponse());
}

class ContentServiceApi {
  final $pb.RpcClient _client;

  ContentServiceApi(this._client);

  $async.Future<GetHistoryPageResponse> getHistoryPage(
          $pb.ClientContext? ctx, GetHistoryPageRequest request) =>
      _client.invoke<GetHistoryPageResponse>(ctx, 'ContentService',
          'GetHistoryPage', request, GetHistoryPageResponse());
  $async.Future<SearchContentResponse> searchContent(
          $pb.ClientContext? ctx, SearchContentRequest request) =>
      _client.invoke<SearchContentResponse>(ctx, 'ContentService',
          'SearchContent', request, SearchContentResponse());

  /// Постоянная очередь использует отдельный RPC: старый runtime отклоняет
  /// его до изменения данных, а не игнорирует неизвестный ключ запроса.
  $async.Future<ApplyContentMutationResponse> applyContentMutation(
          $pb.ClientContext? ctx, ApplyContentMutationRequest request) =>
      _client.invoke<ApplyContentMutationResponse>(ctx, 'ContentService',
          'ApplyContentMutation', request, ApplyContentMutationResponse());
  $async.Future<SetReactionResponse> setReaction(
          $pb.ClientContext? ctx, SetReactionRequest request) =>
      _client.invoke<SetReactionResponse>(
          ctx, 'ContentService', 'SetReaction', request, SetReactionResponse());
  $async.Future<UpdateContentResponse> updateContent(
          $pb.ClientContext? ctx, UpdateContentRequest request) =>
      _client.invoke<UpdateContentResponse>(ctx, 'ContentService',
          'UpdateContent', request, UpdateContentResponse());
  $async.Future<DeleteContentResponse> deleteContent(
          $pb.ClientContext? ctx, DeleteContentRequest request) =>
      _client.invoke<DeleteContentResponse>(ctx, 'ContentService',
          'DeleteContent', request, DeleteContentResponse());
  $async.Future<CreateContentResponse> createContent(
          $pb.ClientContext? ctx, CreateContentRequest request) =>
      _client.invoke<CreateContentResponse>(ctx, 'ContentService',
          'CreateContent', request, CreateContentResponse());
  $async.Future<ListContentResponse> listContent(
          $pb.ClientContext? ctx, ListContentRequest request) =>
      _client.invoke<ListContentResponse>(
          ctx, 'ContentService', 'ListContent', request, ListContentResponse());
}

/// Файлы передаются ограниченными частями; права проверяются на каждой операции.
class AssetServiceApi {
  final $pb.RpcClient _client;

  AssetServiceApi(this._client);

  $async.Future<BeginUploadResponse> beginUpload(
          $pb.ClientContext? ctx, BeginUploadRequest request) =>
      _client.invoke<BeginUploadResponse>(
          ctx, 'AssetService', 'BeginUpload', request, BeginUploadResponse());
  $async.Future<UploadChunkResponse> uploadChunk(
          $pb.ClientContext? ctx, UploadChunkRequest request) =>
      _client.invoke<UploadChunkResponse>(
          ctx, 'AssetService', 'UploadChunk', request, UploadChunkResponse());
  $async.Future<CompleteUploadResponse> completeUpload(
          $pb.ClientContext? ctx, CompleteUploadRequest request) =>
      _client.invoke<CompleteUploadResponse>(ctx, 'AssetService',
          'CompleteUpload', request, CompleteUploadResponse());
  $async.Future<CancelUploadResponse> cancelUpload(
          $pb.ClientContext? ctx, CancelUploadRequest request) =>
      _client.invoke<CancelUploadResponse>(
          ctx, 'AssetService', 'CancelUpload', request, CancelUploadResponse());
  $async.Future<DownloadChunkResponse> downloadChunk(
          $pb.ClientContext? ctx, DownloadChunkRequest request) =>
      _client.invoke<DownloadChunkResponse>(ctx, 'AssetService',
          'DownloadChunk', request, DownloadChunkResponse());
  $async.Future<ListMyAssetsResponse> listMyAssets(
          $pb.ClientContext? ctx, ListMyAssetsRequest request) =>
      _client.invoke<ListMyAssetsResponse>(
          ctx, 'AssetService', 'ListMyAssets', request, ListMyAssetsResponse());
  $async.Future<ListChannelAssetsResponse> listChannelAssets(
          $pb.ClientContext? ctx, ListChannelAssetsRequest request) =>
      _client.invoke<ListChannelAssetsResponse>(ctx, 'AssetService',
          'ListChannelAssets', request, ListChannelAssetsResponse());
}

class AuthServiceApi {
  final $pb.RpcClient _client;

  AuthServiceApi(this._client);

  /// Экспериментальный API; требует поддержки stable principal у клиента.
  $async.Future<CreateRootRotationResponse> createRootRotation(
          $pb.ClientContext? ctx, CreateRootRotationRequest request) =>
      _client.invoke<CreateRootRotationResponse>(ctx, 'AuthService',
          'CreateRootRotation', request, CreateRootRotationResponse());
  $async.Future<CompleteRootRotationResponse> completeRootRotation(
          $pb.ClientContext? ctx, CompleteRootRotationRequest request) =>
      _client.invoke<CompleteRootRotationResponse>(ctx, 'AuthService',
          'CompleteRootRotation', request, CompleteRootRotationResponse());
  $async.Future<ProposePairingResponse> proposePairing(
          $pb.ClientContext? ctx, ProposePairingRequest request) =>
      _client.invoke<ProposePairingResponse>(ctx, 'AuthService',
          'ProposePairing', request, ProposePairingResponse());
  $async.Future<CreatePairingResponse> createPairing(
          $pb.ClientContext? ctx, CreatePairingRequest request) =>
      _client.invoke<CreatePairingResponse>(ctx, 'AuthService', 'CreatePairing',
          request, CreatePairingResponse());
  $async.Future<InspectPairingResponse> inspectPairing(
          $pb.ClientContext? ctx, InspectPairingRequest request) =>
      _client.invoke<InspectPairingResponse>(ctx, 'AuthService',
          'InspectPairing', request, InspectPairingResponse());
  $async.Future<PollPairingResponse> pollPairing(
          $pb.ClientContext? ctx, PollPairingRequest request) =>
      _client.invoke<PollPairingResponse>(
          ctx, 'AuthService', 'PollPairing', request, PollPairingResponse());
  $async.Future<CancelPairingResponse> cancelPairing(
          $pb.ClientContext? ctx, CancelPairingRequest request) =>
      _client.invoke<CancelPairingResponse>(ctx, 'AuthService', 'CancelPairing',
          request, CancelPairingResponse());
  $async.Future<ClaimPairingResponse> claimPairing(
          $pb.ClientContext? ctx, ClaimPairingRequest request) =>
      _client.invoke<ClaimPairingResponse>(
          ctx, 'AuthService', 'ClaimPairing', request, ClaimPairingResponse());
  $async.Future<RevokeCurrentDeviceResponse> revokeCurrentDevice(
          $pb.ClientContext? ctx, RevokeCurrentDeviceRequest request) =>
      _client.invoke<RevokeCurrentDeviceResponse>(ctx, 'AuthService',
          'RevokeCurrentDevice', request, RevokeCurrentDeviceResponse());
  $async.Future<ListDevicesResponse> listDevices(
          $pb.ClientContext? ctx, ListDevicesRequest request) =>
      _client.invoke<ListDevicesResponse>(
          ctx, 'AuthService', 'ListDevices', request, ListDevicesResponse());
  $async.Future<LogoutResponse> logout(
          $pb.ClientContext? ctx, LogoutRequest request) =>
      _client.invoke<LogoutResponse>(
          ctx, 'AuthService', 'Logout', request, LogoutResponse());
  $async.Future<CreateChallengeResponse> createChallenge(
          $pb.ClientContext? ctx, CreateChallengeRequest request) =>
      _client.invoke<CreateChallengeResponse>(ctx, 'AuthService',
          'CreateChallenge', request, CreateChallengeResponse());
  $async.Future<CompleteChallengeResponse> completeChallenge(
          $pb.ClientContext? ctx, CompleteChallengeRequest request) =>
      _client.invoke<CompleteChallengeResponse>(ctx, 'AuthService',
          'CompleteChallenge', request, CompleteChallengeResponse());
}

class SyncServiceApi {
  final $pb.RpcClient _client;

  SyncServiceApi(this._client);

  $async.Future<SubscribeResponse> subscribe(
          $pb.ClientContext? ctx, SubscribeRequest request) =>
      _client.invoke<SubscribeResponse>(
          ctx, 'SyncService', 'Subscribe', request, SubscribeResponse());
  $async.Future<ListEventsResponse> listEvents(
          $pb.ClientContext? ctx, ListEventsRequest request) =>
      _client.invoke<ListEventsResponse>(
          ctx, 'SyncService', 'ListEvents', request, ListEventsResponse());
}

class AdminServiceApi {
  final $pb.RpcClient _client;

  AdminServiceApi(this._client);

  $async.Future<ListMembersResponse> listMembers(
          $pb.ClientContext? ctx, ListMembersRequest request) =>
      _client.invoke<ListMembersResponse>(
          ctx, 'AdminService', 'ListMembers', request, ListMembersResponse());
  $async.Future<UpdateMemberResponse> updateMember(
          $pb.ClientContext? ctx, UpdateMemberRequest request) =>
      _client.invoke<UpdateMemberResponse>(
          ctx, 'AdminService', 'UpdateMember', request, UpdateMemberResponse());
  $async.Future<CreateInviteResponse> createInvite(
          $pb.ClientContext? ctx, CreateInviteRequest request) =>
      _client.invoke<CreateInviteResponse>(
          ctx, 'AdminService', 'CreateInvite', request, CreateInviteResponse());
  $async.Future<ListInvitesResponse> listInvites(
          $pb.ClientContext? ctx, ListInvitesRequest request) =>
      _client.invoke<ListInvitesResponse>(
          ctx, 'AdminService', 'ListInvites', request, ListInvitesResponse());
  $async.Future<RevokeInviteResponse> revokeInvite(
          $pb.ClientContext? ctx, RevokeInviteRequest request) =>
      _client.invoke<RevokeInviteResponse>(
          ctx, 'AdminService', 'RevokeInvite', request, RevokeInviteResponse());
  $async.Future<GetSetupStatusResponse> getSetupStatus(
          $pb.ClientContext? ctx, GetSetupStatusRequest request) =>
      _client.invoke<GetSetupStatusResponse>(ctx, 'AdminService',
          'GetSetupStatus', request, GetSetupStatusResponse());
  $async.Future<ClaimOwnerResponse> claimOwner(
          $pb.ClientContext? ctx, ClaimOwnerRequest request) =>
      _client.invoke<ClaimOwnerResponse>(
          ctx, 'AdminService', 'ClaimOwner', request, ClaimOwnerResponse());
  $async.Future<GetSettingsResponse> getSettings(
          $pb.ClientContext? ctx, GetSettingsRequest request) =>
      _client.invoke<GetSettingsResponse>(
          ctx, 'AdminService', 'GetSettings', request, GetSettingsResponse());
  $async.Future<UpdateSettingsResponse> updateSettings(
          $pb.ClientContext? ctx, UpdateSettingsRequest request) =>
      _client.invoke<UpdateSettingsResponse>(ctx, 'AdminService',
          'UpdateSettings', request, UpdateSettingsResponse());
}

class MembershipServiceApi {
  final $pb.RpcClient _client;

  MembershipServiceApi(this._client);

  $async.Future<GetParticipantProfileResponse> getParticipantProfile(
          $pb.ClientContext? ctx, GetParticipantProfileRequest request) =>
      _client.invoke<GetParticipantProfileResponse>(ctx, 'MembershipService',
          'GetParticipantProfile', request, GetParticipantProfileResponse());
  $async.Future<UpdateParticipantProfileResponse> updateParticipantProfile(
          $pb.ClientContext? ctx, UpdateParticipantProfileRequest request) =>
      _client.invoke<UpdateParticipantProfileResponse>(
          ctx,
          'MembershipService',
          'UpdateParticipantProfile',
          request,
          UpdateParticipantProfileResponse());
  $async.Future<ListParticipantProfilesResponse> listParticipantProfiles(
          $pb.ClientContext? ctx, ListParticipantProfilesRequest request) =>
      _client.invoke<ListParticipantProfilesResponse>(
          ctx,
          'MembershipService',
          'ListParticipantProfiles',
          request,
          ListParticipantProfilesResponse());
  $async.Future<PreviewInviteResponse> previewInvite(
          $pb.ClientContext? ctx, PreviewInviteRequest request) =>
      _client.invoke<PreviewInviteResponse>(ctx, 'MembershipService',
          'PreviewInvite', request, PreviewInviteResponse());
  $async.Future<AcceptInviteResponse> acceptInvite(
          $pb.ClientContext? ctx, AcceptInviteRequest request) =>
      _client.invoke<AcceptInviteResponse>(ctx, 'MembershipService',
          'AcceptInvite', request, AcceptInviteResponse());
  $async.Future<GetMembershipResponse> getMembership(
          $pb.ClientContext? ctx, GetMembershipRequest request) =>
      _client.invoke<GetMembershipResponse>(ctx, 'MembershipService',
          'GetMembership', request, GetMembershipResponse());
}

/// Сервер доставляет непрозрачные MLS-пакеты. Состав проверяется клиентами.
class MlsServiceApi {
  final $pb.RpcClient _client;

  MlsServiceApi(this._client);

  $async.Future<RegisterMlsDeviceResponse> registerMlsDevice(
          $pb.ClientContext? ctx, RegisterMlsDeviceRequest request) =>
      _client.invoke<RegisterMlsDeviceResponse>(ctx, 'MlsService',
          'RegisterMlsDevice', request, RegisterMlsDeviceResponse());
  $async.Future<ListMlsDevicesResponse> listMlsDevices(
          $pb.ClientContext? ctx, ListMlsDevicesRequest request) =>
      _client.invoke<ListMlsDevicesResponse>(ctx, 'MlsService',
          'ListMlsDevices', request, ListMlsDevicesResponse());
  $async.Future<GetMlsChannelResponse> getMlsChannel(
          $pb.ClientContext? ctx, GetMlsChannelRequest request) =>
      _client.invoke<GetMlsChannelResponse>(
          ctx, 'MlsService', 'GetMlsChannel', request, GetMlsChannelResponse());
  $async.Future<PublishMlsResponse> publishMls(
          $pb.ClientContext? ctx, PublishMlsRequest request) =>
      _client.invoke<PublishMlsResponse>(
          ctx, 'MlsService', 'PublishMls', request, PublishMlsResponse());
  $async.Future<ListMlsEnvelopesResponse> listMlsEnvelopes(
          $pb.ClientContext? ctx, ListMlsEnvelopesRequest request) =>
      _client.invoke<ListMlsEnvelopesResponse>(ctx, 'MlsService',
          'ListMlsEnvelopes', request, ListMlsEnvelopesResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
