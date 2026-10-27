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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CreateDirectoryTransferRequest extends $pb.GeneratedMessage {
  factory CreateDirectoryTransferRequest({
    $core.String? profile,
  }) {
    final result = CreateDirectoryTransferRequest._();
    if (profile != null) result.profile = profile;
    return result;
  }

  CreateDirectoryTransferRequest._();

  factory CreateDirectoryTransferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateDirectoryTransferRequest()..mergeFromBuffer(data, registry);
  factory CreateDirectoryTransferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateDirectoryTransferRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateDirectoryTransferRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateDirectoryTransferRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'profile')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateDirectoryTransferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateDirectoryTransferRequest copyWith(
          void Function(CreateDirectoryTransferRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CreateDirectoryTransferRequest))
          as CreateDirectoryTransferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateDirectoryTransferRequest() / CreateDirectoryTransferRequest.new instead')
  static CreateDirectoryTransferRequest create() =>
      CreateDirectoryTransferRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateDirectoryTransferRequest._();
  @$core.override
  CreateDirectoryTransferRequest createEmptyInstance() =>
      CreateDirectoryTransferRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateDirectoryTransferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateDirectoryTransferRequest>(
          CreateDirectoryTransferRequest.$_createMessage);
  static CreateDirectoryTransferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get profile => $_getSZ(0);
  @$pb.TagNumber(1)
  set profile($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);
}

class CreateDirectoryTransferResponse extends $pb.GeneratedMessage {
  factory CreateDirectoryTransferResponse({
    $core.String? id,
    $core.String? ownerToken,
    $core.String? code,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? expiresAt,
  }) {
    final result = CreateDirectoryTransferResponse._();
    if (id != null) result.id = id;
    if (ownerToken != null) result.ownerToken = ownerToken;
    if (code != null) result.code = code;
    if (createdAt != null) result.createdAt = createdAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  CreateDirectoryTransferResponse._();

  factory CreateDirectoryTransferResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateDirectoryTransferResponse()..mergeFromBuffer(data, registry);
  factory CreateDirectoryTransferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateDirectoryTransferResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateDirectoryTransferResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateDirectoryTransferResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'ownerToken')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aInt64(4, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(5, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateDirectoryTransferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateDirectoryTransferResponse copyWith(
          void Function(CreateDirectoryTransferResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateDirectoryTransferResponse))
          as CreateDirectoryTransferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateDirectoryTransferResponse() / CreateDirectoryTransferResponse.new instead')
  static CreateDirectoryTransferResponse create() =>
      CreateDirectoryTransferResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateDirectoryTransferResponse._();
  @$core.override
  CreateDirectoryTransferResponse createEmptyInstance() =>
      CreateDirectoryTransferResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateDirectoryTransferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateDirectoryTransferResponse>(
          CreateDirectoryTransferResponse.$_createMessage);
  static CreateDirectoryTransferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createdAt => $_getI64(3);
  @$pb.TagNumber(4)
  set createdAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expiresAt => $_getI64(4);
  @$pb.TagNumber(5)
  set expiresAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
}

class OpenDirectoryTransferRequest extends $pb.GeneratedMessage {
  factory OpenDirectoryTransferRequest({
    $core.String? code,
  }) {
    final result = OpenDirectoryTransferRequest._();
    if (code != null) result.code = code;
    return result;
  }

  OpenDirectoryTransferRequest._();

  factory OpenDirectoryTransferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenDirectoryTransferRequest()..mergeFromBuffer(data, registry);
  factory OpenDirectoryTransferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenDirectoryTransferRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenDirectoryTransferRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: OpenDirectoryTransferRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenDirectoryTransferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenDirectoryTransferRequest copyWith(
          void Function(OpenDirectoryTransferRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpenDirectoryTransferRequest))
          as OpenDirectoryTransferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpenDirectoryTransferRequest() / OpenDirectoryTransferRequest.new instead')
  static OpenDirectoryTransferRequest create() =>
      OpenDirectoryTransferRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpenDirectoryTransferRequest._();
  @$core.override
  OpenDirectoryTransferRequest createEmptyInstance() =>
      OpenDirectoryTransferRequest._();
  @$core.pragma('dart2js:noInline')
  static OpenDirectoryTransferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenDirectoryTransferRequest>(
          OpenDirectoryTransferRequest.$_createMessage);
  static OpenDirectoryTransferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class OpenDirectoryTransferResponse extends $pb.GeneratedMessage {
  factory OpenDirectoryTransferResponse({
    $core.String? id,
    $core.String? peerToken,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? expiresAt,
  }) {
    final result = OpenDirectoryTransferResponse._();
    if (id != null) result.id = id;
    if (peerToken != null) result.peerToken = peerToken;
    if (createdAt != null) result.createdAt = createdAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  OpenDirectoryTransferResponse._();

  factory OpenDirectoryTransferResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenDirectoryTransferResponse()..mergeFromBuffer(data, registry);
  factory OpenDirectoryTransferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenDirectoryTransferResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenDirectoryTransferResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: OpenDirectoryTransferResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'peerToken')
    ..aInt64(3, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenDirectoryTransferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenDirectoryTransferResponse copyWith(
          void Function(OpenDirectoryTransferResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpenDirectoryTransferResponse))
          as OpenDirectoryTransferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpenDirectoryTransferResponse() / OpenDirectoryTransferResponse.new instead')
  static OpenDirectoryTransferResponse create() =>
      OpenDirectoryTransferResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpenDirectoryTransferResponse._();
  @$core.override
  OpenDirectoryTransferResponse createEmptyInstance() =>
      OpenDirectoryTransferResponse._();
  @$core.pragma('dart2js:noInline')
  static OpenDirectoryTransferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenDirectoryTransferResponse>(
          OpenDirectoryTransferResponse.$_createMessage);
  static OpenDirectoryTransferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get peerToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set peerToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeerToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createdAt => $_getI64(2);
  @$pb.TagNumber(3)
  set createdAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

class WriteDirectoryFrameRequest extends $pb.GeneratedMessage {
  factory WriteDirectoryFrameRequest({
    $core.String? id,
    $core.String? token,
    $core.int? sequence,
    $core.List<$core.int>? data,
    $core.bool? finalRecord,
  }) {
    final result = WriteDirectoryFrameRequest._();
    if (id != null) result.id = id;
    if (token != null) result.token = token;
    if (sequence != null) result.sequence = sequence;
    if (data != null) result.data = data;
    if (finalRecord != null) result.finalRecord = finalRecord;
    return result;
  }

  WriteDirectoryFrameRequest._();

  factory WriteDirectoryFrameRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WriteDirectoryFrameRequest()..mergeFromBuffer(data, registry);
  factory WriteDirectoryFrameRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WriteDirectoryFrameRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteDirectoryFrameRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: WriteDirectoryFrameRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aI(3, _omitFieldNames ? '' : 'sequence', fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOB(5, _omitFieldNames ? '' : 'finalRecord')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteDirectoryFrameRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteDirectoryFrameRequest copyWith(
          void Function(WriteDirectoryFrameRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WriteDirectoryFrameRequest))
          as WriteDirectoryFrameRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WriteDirectoryFrameRequest() / WriteDirectoryFrameRequest.new instead')
  static WriteDirectoryFrameRequest create() => WriteDirectoryFrameRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WriteDirectoryFrameRequest._();
  @$core.override
  WriteDirectoryFrameRequest createEmptyInstance() =>
      WriteDirectoryFrameRequest._();
  @$core.pragma('dart2js:noInline')
  static WriteDirectoryFrameRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteDirectoryFrameRequest>(
          WriteDirectoryFrameRequest.$_createMessage);
  static WriteDirectoryFrameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sequence => $_getIZ(2);
  @$pb.TagNumber(3)
  set sequence($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearSequence() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(3);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get finalRecord => $_getBF(4);
  @$pb.TagNumber(5)
  set finalRecord($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFinalRecord() => $_has(4);
  @$pb.TagNumber(5)
  void clearFinalRecord() => $_clearField(5);
}

class WriteDirectoryFrameResponse extends $pb.GeneratedMessage {
  factory WriteDirectoryFrameResponse() => WriteDirectoryFrameResponse._();

  WriteDirectoryFrameResponse._();

  factory WriteDirectoryFrameResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WriteDirectoryFrameResponse()..mergeFromBuffer(data, registry);
  factory WriteDirectoryFrameResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WriteDirectoryFrameResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteDirectoryFrameResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: WriteDirectoryFrameResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteDirectoryFrameResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteDirectoryFrameResponse copyWith(
          void Function(WriteDirectoryFrameResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WriteDirectoryFrameResponse))
          as WriteDirectoryFrameResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WriteDirectoryFrameResponse() / WriteDirectoryFrameResponse.new instead')
  static WriteDirectoryFrameResponse create() =>
      WriteDirectoryFrameResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WriteDirectoryFrameResponse._();
  @$core.override
  WriteDirectoryFrameResponse createEmptyInstance() =>
      WriteDirectoryFrameResponse._();
  @$core.pragma('dart2js:noInline')
  static WriteDirectoryFrameResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteDirectoryFrameResponse>(
          WriteDirectoryFrameResponse.$_createMessage);
  static WriteDirectoryFrameResponse? _defaultInstance;
}

class ReadDirectoryFrameRequest extends $pb.GeneratedMessage {
  factory ReadDirectoryFrameRequest({
    $core.String? id,
    $core.String? token,
    $core.int? sequence,
  }) {
    final result = ReadDirectoryFrameRequest._();
    if (id != null) result.id = id;
    if (token != null) result.token = token;
    if (sequence != null) result.sequence = sequence;
    return result;
  }

  ReadDirectoryFrameRequest._();

  factory ReadDirectoryFrameRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadDirectoryFrameRequest()..mergeFromBuffer(data, registry);
  factory ReadDirectoryFrameRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadDirectoryFrameRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadDirectoryFrameRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReadDirectoryFrameRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aI(3, _omitFieldNames ? '' : 'sequence', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadDirectoryFrameRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadDirectoryFrameRequest copyWith(
          void Function(ReadDirectoryFrameRequest) updates) =>
      super.copyWith((message) => updates(message as ReadDirectoryFrameRequest))
          as ReadDirectoryFrameRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReadDirectoryFrameRequest() / ReadDirectoryFrameRequest.new instead')
  static ReadDirectoryFrameRequest create() => ReadDirectoryFrameRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReadDirectoryFrameRequest._();
  @$core.override
  ReadDirectoryFrameRequest createEmptyInstance() =>
      ReadDirectoryFrameRequest._();
  @$core.pragma('dart2js:noInline')
  static ReadDirectoryFrameRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadDirectoryFrameRequest>(
          ReadDirectoryFrameRequest.$_createMessage);
  static ReadDirectoryFrameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sequence => $_getIZ(2);
  @$pb.TagNumber(3)
  set sequence($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearSequence() => $_clearField(3);
}

class ReadDirectoryFrameResponse extends $pb.GeneratedMessage {
  factory ReadDirectoryFrameResponse({
    $core.bool? available,
    $core.List<$core.int>? data,
    $core.bool? finalRecord,
    $fixnum.Int64? expiresAt,
  }) {
    final result = ReadDirectoryFrameResponse._();
    if (available != null) result.available = available;
    if (data != null) result.data = data;
    if (finalRecord != null) result.finalRecord = finalRecord;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  ReadDirectoryFrameResponse._();

  factory ReadDirectoryFrameResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadDirectoryFrameResponse()..mergeFromBuffer(data, registry);
  factory ReadDirectoryFrameResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadDirectoryFrameResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadDirectoryFrameResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReadDirectoryFrameResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'available')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOB(3, _omitFieldNames ? '' : 'finalRecord')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadDirectoryFrameResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadDirectoryFrameResponse copyWith(
          void Function(ReadDirectoryFrameResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ReadDirectoryFrameResponse))
          as ReadDirectoryFrameResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReadDirectoryFrameResponse() / ReadDirectoryFrameResponse.new instead')
  static ReadDirectoryFrameResponse create() => ReadDirectoryFrameResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReadDirectoryFrameResponse._();
  @$core.override
  ReadDirectoryFrameResponse createEmptyInstance() =>
      ReadDirectoryFrameResponse._();
  @$core.pragma('dart2js:noInline')
  static ReadDirectoryFrameResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadDirectoryFrameResponse>(
          ReadDirectoryFrameResponse.$_createMessage);
  static ReadDirectoryFrameResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get available => $_getBF(0);
  @$pb.TagNumber(1)
  set available($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailable() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get finalRecord => $_getBF(2);
  @$pb.TagNumber(3)
  set finalRecord($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFinalRecord() => $_has(2);
  @$pb.TagNumber(3)
  void clearFinalRecord() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

class CloseDirectoryTransferRequest extends $pb.GeneratedMessage {
  factory CloseDirectoryTransferRequest({
    $core.String? id,
    $core.String? token,
  }) {
    final result = CloseDirectoryTransferRequest._();
    if (id != null) result.id = id;
    if (token != null) result.token = token;
    return result;
  }

  CloseDirectoryTransferRequest._();

  factory CloseDirectoryTransferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseDirectoryTransferRequest()..mergeFromBuffer(data, registry);
  factory CloseDirectoryTransferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseDirectoryTransferRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseDirectoryTransferRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CloseDirectoryTransferRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDirectoryTransferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDirectoryTransferRequest copyWith(
          void Function(CloseDirectoryTransferRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CloseDirectoryTransferRequest))
          as CloseDirectoryTransferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CloseDirectoryTransferRequest() / CloseDirectoryTransferRequest.new instead')
  static CloseDirectoryTransferRequest create() =>
      CloseDirectoryTransferRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CloseDirectoryTransferRequest._();
  @$core.override
  CloseDirectoryTransferRequest createEmptyInstance() =>
      CloseDirectoryTransferRequest._();
  @$core.pragma('dart2js:noInline')
  static CloseDirectoryTransferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseDirectoryTransferRequest>(
          CloseDirectoryTransferRequest.$_createMessage);
  static CloseDirectoryTransferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

class CloseDirectoryTransferResponse extends $pb.GeneratedMessage {
  factory CloseDirectoryTransferResponse() =>
      CloseDirectoryTransferResponse._();

  CloseDirectoryTransferResponse._();

  factory CloseDirectoryTransferResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseDirectoryTransferResponse()..mergeFromBuffer(data, registry);
  factory CloseDirectoryTransferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseDirectoryTransferResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseDirectoryTransferResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CloseDirectoryTransferResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDirectoryTransferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDirectoryTransferResponse copyWith(
          void Function(CloseDirectoryTransferResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CloseDirectoryTransferResponse))
          as CloseDirectoryTransferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CloseDirectoryTransferResponse() / CloseDirectoryTransferResponse.new instead')
  static CloseDirectoryTransferResponse create() =>
      CloseDirectoryTransferResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CloseDirectoryTransferResponse._();
  @$core.override
  CloseDirectoryTransferResponse createEmptyInstance() =>
      CloseDirectoryTransferResponse._();
  @$core.pragma('dart2js:noInline')
  static CloseDirectoryTransferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseDirectoryTransferResponse>(
          CloseDirectoryTransferResponse.$_createMessage);
  static CloseDirectoryTransferResponse? _defaultInstance;
}

/// Непрозрачный relay; эти методы не выдают grants и не читают каталог.
class DirectoryPairingServiceApi {
  final $pb.RpcClient _client;

  DirectoryPairingServiceApi(this._client);

  $async.Future<CreateDirectoryTransferResponse> createDirectoryTransfer(
          $pb.ClientContext? ctx, CreateDirectoryTransferRequest request) =>
      _client.invoke<CreateDirectoryTransferResponse>(
          ctx,
          'DirectoryPairingService',
          'CreateDirectoryTransfer',
          request,
          CreateDirectoryTransferResponse());
  $async.Future<OpenDirectoryTransferResponse> openDirectoryTransfer(
          $pb.ClientContext? ctx, OpenDirectoryTransferRequest request) =>
      _client.invoke<OpenDirectoryTransferResponse>(
          ctx,
          'DirectoryPairingService',
          'OpenDirectoryTransfer',
          request,
          OpenDirectoryTransferResponse());
  $async.Future<WriteDirectoryFrameResponse> writeDirectoryFrame(
          $pb.ClientContext? ctx, WriteDirectoryFrameRequest request) =>
      _client.invoke<WriteDirectoryFrameResponse>(
          ctx,
          'DirectoryPairingService',
          'WriteDirectoryFrame',
          request,
          WriteDirectoryFrameResponse());
  $async.Future<ReadDirectoryFrameResponse> readDirectoryFrame(
          $pb.ClientContext? ctx, ReadDirectoryFrameRequest request) =>
      _client.invoke<ReadDirectoryFrameResponse>(ctx, 'DirectoryPairingService',
          'ReadDirectoryFrame', request, ReadDirectoryFrameResponse());
  $async.Future<CloseDirectoryTransferResponse> closeDirectoryTransfer(
          $pb.ClientContext? ctx, CloseDirectoryTransferRequest request) =>
      _client.invoke<CloseDirectoryTransferResponse>(
          ctx,
          'DirectoryPairingService',
          'CloseDirectoryTransfer',
          request,
          CloseDirectoryTransferResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
