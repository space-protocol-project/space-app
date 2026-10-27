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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BackupHead extends $pb.GeneratedMessage {
  factory BackupHead({
    $core.String? id,
    $fixnum.Int64? revision,
    $core.String? digest,
    $core.String? parent,
    $core.String? archiveDigest,
  }) {
    final result = BackupHead._();
    if (id != null) result.id = id;
    if (revision != null) result.revision = revision;
    if (digest != null) result.digest = digest;
    if (parent != null) result.parent = parent;
    if (archiveDigest != null) result.archiveDigest = archiveDigest;
    return result;
  }

  BackupHead._();

  factory BackupHead.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackupHead()..mergeFromBuffer(data, registry);
  factory BackupHead.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BackupHead()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BackupHead',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: BackupHead.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..aOS(3, _omitFieldNames ? '' : 'digest')
    ..aOS(4, _omitFieldNames ? '' : 'parent')
    ..aOS(5, _omitFieldNames ? '' : 'archiveDigest')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupHead clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BackupHead copyWith(void Function(BackupHead) updates) =>
      super.copyWith((message) => updates(message as BackupHead)) as BackupHead;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BackupHead() / BackupHead.new instead')
  static BackupHead create() => BackupHead._();
  static $pb.GeneratedMessage $_createMessage() => BackupHead._();
  @$core.override
  BackupHead createEmptyInstance() => BackupHead._();
  @$core.pragma('dart2js:noInline')
  static BackupHead getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BackupHead>(BackupHead.$_createMessage);
  static BackupHead? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  /// SHA-256 цепочки ciphertext; отпечаток открытого манифеста не раскрывается.
  @$pb.TagNumber(3)
  $core.String get digest => $_getSZ(2);
  @$pb.TagNumber(3)
  set digest($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDigest() => $_has(2);
  @$pb.TagNumber(3)
  void clearDigest() => $_clearField(3);

  /// Предыдущий digest цепочки либо пустая строка у первой версии.
  @$pb.TagNumber(4)
  $core.String get parent => $_getSZ(3);
  @$pb.TagNumber(4)
  set parent($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParent() => $_has(3);
  @$pb.TagNumber(4)
  void clearParent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get archiveDigest => $_getSZ(4);
  @$pb.TagNumber(5)
  set archiveDigest($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasArchiveDigest() => $_has(4);
  @$pb.TagNumber(5)
  void clearArchiveDigest() => $_clearField(5);
}

class CreateBackupSlotResponse extends $pb.GeneratedMessage {
  factory CreateBackupSlotResponse({
    BackupHead? head,
  }) {
    final result = CreateBackupSlotResponse._();
    if (head != null) result.head = head;
    return result;
  }

  CreateBackupSlotResponse._();

  factory CreateBackupSlotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateBackupSlotResponse()..mergeFromBuffer(data, registry);
  factory CreateBackupSlotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateBackupSlotResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateBackupSlotResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateBackupSlotResponse.$_createMessage)
    ..aOM<BackupHead>(1, _omitFieldNames ? '' : 'head',
        subBuilder: BackupHead.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateBackupSlotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateBackupSlotResponse copyWith(
          void Function(CreateBackupSlotResponse) updates) =>
      super.copyWith((message) => updates(message as CreateBackupSlotResponse))
          as CreateBackupSlotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateBackupSlotResponse() / CreateBackupSlotResponse.new instead')
  static CreateBackupSlotResponse create() => CreateBackupSlotResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateBackupSlotResponse._();
  @$core.override
  CreateBackupSlotResponse createEmptyInstance() =>
      CreateBackupSlotResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateBackupSlotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateBackupSlotResponse>(
          CreateBackupSlotResponse.$_createMessage);
  static CreateBackupSlotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BackupHead get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(BackupHead value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => $_clearField(1);
  @$pb.TagNumber(1)
  BackupHead ensureHead() => $_ensure(0);
}

class RevokeBackupSlotRequest extends $pb.GeneratedMessage {
  factory RevokeBackupSlotRequest({
    $core.String? id,
  }) {
    final result = RevokeBackupSlotRequest._();
    if (id != null) result.id = id;
    return result;
  }

  RevokeBackupSlotRequest._();

  factory RevokeBackupSlotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeBackupSlotRequest()..mergeFromBuffer(data, registry);
  factory RevokeBackupSlotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeBackupSlotRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeBackupSlotRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeBackupSlotRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeBackupSlotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeBackupSlotRequest copyWith(
          void Function(RevokeBackupSlotRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeBackupSlotRequest))
          as RevokeBackupSlotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RevokeBackupSlotRequest() / RevokeBackupSlotRequest.new instead')
  static RevokeBackupSlotRequest create() => RevokeBackupSlotRequest._();
  static $pb.GeneratedMessage $_createMessage() => RevokeBackupSlotRequest._();
  @$core.override
  RevokeBackupSlotRequest createEmptyInstance() => RevokeBackupSlotRequest._();
  @$core.pragma('dart2js:noInline')
  static RevokeBackupSlotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeBackupSlotRequest>(
          RevokeBackupSlotRequest.$_createMessage);
  static RevokeBackupSlotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class RevokeBackupSlotResponse extends $pb.GeneratedMessage {
  factory RevokeBackupSlotResponse() => RevokeBackupSlotResponse._();

  RevokeBackupSlotResponse._();

  factory RevokeBackupSlotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeBackupSlotResponse()..mergeFromBuffer(data, registry);
  factory RevokeBackupSlotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeBackupSlotResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeBackupSlotResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeBackupSlotResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeBackupSlotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeBackupSlotResponse copyWith(
          void Function(RevokeBackupSlotResponse) updates) =>
      super.copyWith((message) => updates(message as RevokeBackupSlotResponse))
          as RevokeBackupSlotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RevokeBackupSlotResponse() / RevokeBackupSlotResponse.new instead')
  static RevokeBackupSlotResponse create() => RevokeBackupSlotResponse._();
  static $pb.GeneratedMessage $_createMessage() => RevokeBackupSlotResponse._();
  @$core.override
  RevokeBackupSlotResponse createEmptyInstance() =>
      RevokeBackupSlotResponse._();
  @$core.pragma('dart2js:noInline')
  static RevokeBackupSlotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeBackupSlotResponse>(
          RevokeBackupSlotResponse.$_createMessage);
  static RevokeBackupSlotResponse? _defaultInstance;
}

class PutBackupResponse extends $pb.GeneratedMessage {
  factory PutBackupResponse({
    BackupHead? head,
  }) {
    final result = PutBackupResponse._();
    if (head != null) result.head = head;
    return result;
  }

  PutBackupResponse._();

  factory PutBackupResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PutBackupResponse()..mergeFromBuffer(data, registry);
  factory PutBackupResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PutBackupResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PutBackupResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PutBackupResponse.$_createMessage)
    ..aOM<BackupHead>(1, _omitFieldNames ? '' : 'head',
        subBuilder: BackupHead.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PutBackupResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PutBackupResponse copyWith(void Function(PutBackupResponse) updates) =>
      super.copyWith((message) => updates(message as PutBackupResponse))
          as PutBackupResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PutBackupResponse() / PutBackupResponse.new instead')
  static PutBackupResponse create() => PutBackupResponse._();
  static $pb.GeneratedMessage $_createMessage() => PutBackupResponse._();
  @$core.override
  PutBackupResponse createEmptyInstance() => PutBackupResponse._();
  @$core.pragma('dart2js:noInline')
  static PutBackupResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PutBackupResponse>(
          PutBackupResponse.$_createMessage);
  static PutBackupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BackupHead get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(BackupHead value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => $_clearField(1);
  @$pb.TagNumber(1)
  BackupHead ensureHead() => $_ensure(0);
}

class AdvanceBackupWitnessResponse extends $pb.GeneratedMessage {
  factory AdvanceBackupWitnessResponse({
    BackupHead? head,
  }) {
    final result = AdvanceBackupWitnessResponse._();
    if (head != null) result.head = head;
    return result;
  }

  AdvanceBackupWitnessResponse._();

  factory AdvanceBackupWitnessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdvanceBackupWitnessResponse()..mergeFromBuffer(data, registry);
  factory AdvanceBackupWitnessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdvanceBackupWitnessResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceBackupWitnessResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: AdvanceBackupWitnessResponse.$_createMessage)
    ..aOM<BackupHead>(1, _omitFieldNames ? '' : 'head',
        subBuilder: BackupHead.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceBackupWitnessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceBackupWitnessResponse copyWith(
          void Function(AdvanceBackupWitnessResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AdvanceBackupWitnessResponse))
          as AdvanceBackupWitnessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AdvanceBackupWitnessResponse() / AdvanceBackupWitnessResponse.new instead')
  static AdvanceBackupWitnessResponse create() =>
      AdvanceBackupWitnessResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      AdvanceBackupWitnessResponse._();
  @$core.override
  AdvanceBackupWitnessResponse createEmptyInstance() =>
      AdvanceBackupWitnessResponse._();
  @$core.pragma('dart2js:noInline')
  static AdvanceBackupWitnessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceBackupWitnessResponse>(
          AdvanceBackupWitnessResponse.$_createMessage);
  static AdvanceBackupWitnessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BackupHead get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(BackupHead value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => $_clearField(1);
  @$pb.TagNumber(1)
  BackupHead ensureHead() => $_ensure(0);
}

class CreateBackupSlotRequest extends $pb.GeneratedMessage {
  factory CreateBackupSlotRequest({
    $core.String? id,
    $core.List<$core.int>? readHash,
    $core.List<$core.int>? writeHash,
    $core.bool? witness,
  }) {
    final result = CreateBackupSlotRequest._();
    if (id != null) result.id = id;
    if (readHash != null) result.readHash = readHash;
    if (writeHash != null) result.writeHash = writeHash;
    if (witness != null) result.witness = witness;
    return result;
  }

  CreateBackupSlotRequest._();

  factory CreateBackupSlotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateBackupSlotRequest()..mergeFromBuffer(data, registry);
  factory CreateBackupSlotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateBackupSlotRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateBackupSlotRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateBackupSlotRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'readHash', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'writeHash', $pb.PbFieldType.OY)
    ..aOB(4, _omitFieldNames ? '' : 'witness')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateBackupSlotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateBackupSlotRequest copyWith(
          void Function(CreateBackupSlotRequest) updates) =>
      super.copyWith((message) => updates(message as CreateBackupSlotRequest))
          as CreateBackupSlotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateBackupSlotRequest() / CreateBackupSlotRequest.new instead')
  static CreateBackupSlotRequest create() => CreateBackupSlotRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateBackupSlotRequest._();
  @$core.override
  CreateBackupSlotRequest createEmptyInstance() => CreateBackupSlotRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateBackupSlotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateBackupSlotRequest>(
          CreateBackupSlotRequest.$_createMessage);
  static CreateBackupSlotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get readHash => $_getN(1);
  @$pb.TagNumber(2)
  set readHash($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReadHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearReadHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get writeHash => $_getN(2);
  @$pb.TagNumber(3)
  set writeHash($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWriteHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearWriteHash() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get witness => $_getBF(3);
  @$pb.TagNumber(4)
  set witness($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWitness() => $_has(3);
  @$pb.TagNumber(4)
  void clearWitness() => $_clearField(4);
}

class PutBackupRequest extends $pb.GeneratedMessage {
  factory PutBackupRequest({
    BackupHead? head,
    $core.String? token,
    $core.List<$core.int>? archive,
  }) {
    final result = PutBackupRequest._();
    if (head != null) result.head = head;
    if (token != null) result.token = token;
    if (archive != null) result.archive = archive;
    return result;
  }

  PutBackupRequest._();

  factory PutBackupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PutBackupRequest()..mergeFromBuffer(data, registry);
  factory PutBackupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PutBackupRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PutBackupRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PutBackupRequest.$_createMessage)
    ..aOM<BackupHead>(1, _omitFieldNames ? '' : 'head',
        subBuilder: BackupHead.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'archive', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PutBackupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PutBackupRequest copyWith(void Function(PutBackupRequest) updates) =>
      super.copyWith((message) => updates(message as PutBackupRequest))
          as PutBackupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PutBackupRequest() / PutBackupRequest.new instead')
  static PutBackupRequest create() => PutBackupRequest._();
  static $pb.GeneratedMessage $_createMessage() => PutBackupRequest._();
  @$core.override
  PutBackupRequest createEmptyInstance() => PutBackupRequest._();
  @$core.pragma('dart2js:noInline')
  static PutBackupRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PutBackupRequest>(
          PutBackupRequest.$_createMessage);
  static PutBackupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BackupHead get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(BackupHead value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => $_clearField(1);
  @$pb.TagNumber(1)
  BackupHead ensureHead() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get archive => $_getN(2);
  @$pb.TagNumber(3)
  set archive($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArchive() => $_has(2);
  @$pb.TagNumber(3)
  void clearArchive() => $_clearField(3);
}

class GetBackupRequest extends $pb.GeneratedMessage {
  factory GetBackupRequest({
    $core.String? id,
    $core.String? token,
    $fixnum.Int64? revision,
  }) {
    final result = GetBackupRequest._();
    if (id != null) result.id = id;
    if (token != null) result.token = token;
    if (revision != null) result.revision = revision;
    return result;
  }

  GetBackupRequest._();

  factory GetBackupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBackupRequest()..mergeFromBuffer(data, registry);
  factory GetBackupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBackupRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBackupRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetBackupRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aInt64(3, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBackupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBackupRequest copyWith(void Function(GetBackupRequest) updates) =>
      super.copyWith((message) => updates(message as GetBackupRequest))
          as GetBackupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetBackupRequest() / GetBackupRequest.new instead')
  static GetBackupRequest create() => GetBackupRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetBackupRequest._();
  @$core.override
  GetBackupRequest createEmptyInstance() => GetBackupRequest._();
  @$core.pragma('dart2js:noInline')
  static GetBackupRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetBackupRequest>(
          GetBackupRequest.$_createMessage);
  static GetBackupRequest? _defaultInstance;

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
  $fixnum.Int64 get revision => $_getI64(2);
  @$pb.TagNumber(3)
  set revision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);
}

class GetBackupResponse extends $pb.GeneratedMessage {
  factory GetBackupResponse({
    BackupHead? head,
    $core.List<$core.int>? archive,
  }) {
    final result = GetBackupResponse._();
    if (head != null) result.head = head;
    if (archive != null) result.archive = archive;
    return result;
  }

  GetBackupResponse._();

  factory GetBackupResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBackupResponse()..mergeFromBuffer(data, registry);
  factory GetBackupResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBackupResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBackupResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetBackupResponse.$_createMessage)
    ..aOM<BackupHead>(1, _omitFieldNames ? '' : 'head',
        subBuilder: BackupHead.$_createMessage)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'archive', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBackupResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBackupResponse copyWith(void Function(GetBackupResponse) updates) =>
      super.copyWith((message) => updates(message as GetBackupResponse))
          as GetBackupResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetBackupResponse() / GetBackupResponse.new instead')
  static GetBackupResponse create() => GetBackupResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetBackupResponse._();
  @$core.override
  GetBackupResponse createEmptyInstance() => GetBackupResponse._();
  @$core.pragma('dart2js:noInline')
  static GetBackupResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetBackupResponse>(
          GetBackupResponse.$_createMessage);
  static GetBackupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BackupHead get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(BackupHead value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => $_clearField(1);
  @$pb.TagNumber(1)
  BackupHead ensureHead() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get archive => $_getN(1);
  @$pb.TagNumber(2)
  set archive($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasArchive() => $_has(1);
  @$pb.TagNumber(2)
  void clearArchive() => $_clearField(2);
}

class AdvanceBackupWitnessRequest extends $pb.GeneratedMessage {
  factory AdvanceBackupWitnessRequest({
    BackupHead? head,
    $core.String? token,
  }) {
    final result = AdvanceBackupWitnessRequest._();
    if (head != null) result.head = head;
    if (token != null) result.token = token;
    return result;
  }

  AdvanceBackupWitnessRequest._();

  factory AdvanceBackupWitnessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdvanceBackupWitnessRequest()..mergeFromBuffer(data, registry);
  factory AdvanceBackupWitnessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdvanceBackupWitnessRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceBackupWitnessRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: AdvanceBackupWitnessRequest.$_createMessage)
    ..aOM<BackupHead>(1, _omitFieldNames ? '' : 'head',
        subBuilder: BackupHead.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceBackupWitnessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceBackupWitnessRequest copyWith(
          void Function(AdvanceBackupWitnessRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AdvanceBackupWitnessRequest))
          as AdvanceBackupWitnessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AdvanceBackupWitnessRequest() / AdvanceBackupWitnessRequest.new instead')
  static AdvanceBackupWitnessRequest create() =>
      AdvanceBackupWitnessRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      AdvanceBackupWitnessRequest._();
  @$core.override
  AdvanceBackupWitnessRequest createEmptyInstance() =>
      AdvanceBackupWitnessRequest._();
  @$core.pragma('dart2js:noInline')
  static AdvanceBackupWitnessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceBackupWitnessRequest>(
          AdvanceBackupWitnessRequest.$_createMessage);
  static AdvanceBackupWitnessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BackupHead get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(BackupHead value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => $_clearField(1);
  @$pb.TagNumber(1)
  BackupHead ensureHead() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

class ReadBackupWitnessRequest extends $pb.GeneratedMessage {
  factory ReadBackupWitnessRequest({
    $core.String? id,
    $core.String? token,
    $core.String? challenge,
  }) {
    final result = ReadBackupWitnessRequest._();
    if (id != null) result.id = id;
    if (token != null) result.token = token;
    if (challenge != null) result.challenge = challenge;
    return result;
  }

  ReadBackupWitnessRequest._();

  factory ReadBackupWitnessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadBackupWitnessRequest()..mergeFromBuffer(data, registry);
  factory ReadBackupWitnessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadBackupWitnessRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadBackupWitnessRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReadBackupWitnessRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOS(3, _omitFieldNames ? '' : 'challenge')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadBackupWitnessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadBackupWitnessRequest copyWith(
          void Function(ReadBackupWitnessRequest) updates) =>
      super.copyWith((message) => updates(message as ReadBackupWitnessRequest))
          as ReadBackupWitnessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReadBackupWitnessRequest() / ReadBackupWitnessRequest.new instead')
  static ReadBackupWitnessRequest create() => ReadBackupWitnessRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReadBackupWitnessRequest._();
  @$core.override
  ReadBackupWitnessRequest createEmptyInstance() =>
      ReadBackupWitnessRequest._();
  @$core.pragma('dart2js:noInline')
  static ReadBackupWitnessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadBackupWitnessRequest>(
          ReadBackupWitnessRequest.$_createMessage);
  static ReadBackupWitnessRequest? _defaultInstance;

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
  $core.String get challenge => $_getSZ(2);
  @$pb.TagNumber(3)
  set challenge($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChallenge() => $_has(2);
  @$pb.TagNumber(3)
  void clearChallenge() => $_clearField(3);
}

class ReadBackupWitnessResponse extends $pb.GeneratedMessage {
  factory ReadBackupWitnessResponse({
    BackupHead? head,
    $core.String? challenge,
    $core.List<$core.int>? signature,
  }) {
    final result = ReadBackupWitnessResponse._();
    if (head != null) result.head = head;
    if (challenge != null) result.challenge = challenge;
    if (signature != null) result.signature = signature;
    return result;
  }

  ReadBackupWitnessResponse._();

  factory ReadBackupWitnessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadBackupWitnessResponse()..mergeFromBuffer(data, registry);
  factory ReadBackupWitnessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReadBackupWitnessResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadBackupWitnessResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReadBackupWitnessResponse.$_createMessage)
    ..aOM<BackupHead>(1, _omitFieldNames ? '' : 'head',
        subBuilder: BackupHead.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'challenge')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadBackupWitnessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadBackupWitnessResponse copyWith(
          void Function(ReadBackupWitnessResponse) updates) =>
      super.copyWith((message) => updates(message as ReadBackupWitnessResponse))
          as ReadBackupWitnessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReadBackupWitnessResponse() / ReadBackupWitnessResponse.new instead')
  static ReadBackupWitnessResponse create() => ReadBackupWitnessResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReadBackupWitnessResponse._();
  @$core.override
  ReadBackupWitnessResponse createEmptyInstance() =>
      ReadBackupWitnessResponse._();
  @$core.pragma('dart2js:noInline')
  static ReadBackupWitnessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadBackupWitnessResponse>(
          ReadBackupWitnessResponse.$_createMessage);
  static ReadBackupWitnessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BackupHead get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(BackupHead value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => $_clearField(1);
  @$pb.TagNumber(1)
  BackupHead ensureHead() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get challenge => $_getSZ(1);
  @$pb.TagNumber(2)
  set challenge($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChallenge() => $_has(1);
  @$pb.TagNumber(2)
  void clearChallenge() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get signature => $_getN(2);
  @$pb.TagNumber(3)
  set signature($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignature() => $_clearField(3);
}

/// core.directory.backup.v1: независимые хранилище и свидетель версии.
class RemoteBackupServiceApi {
  final $pb.RpcClient _client;

  RemoteBackupServiceApi(this._client);

  $async.Future<CreateBackupSlotResponse> createBackupSlot(
          $pb.ClientContext? ctx, CreateBackupSlotRequest request) =>
      _client.invoke<CreateBackupSlotResponse>(ctx, 'RemoteBackupService',
          'CreateBackupSlot', request, CreateBackupSlotResponse());
  $async.Future<RevokeBackupSlotResponse> revokeBackupSlot(
          $pb.ClientContext? ctx, RevokeBackupSlotRequest request) =>
      _client.invoke<RevokeBackupSlotResponse>(ctx, 'RemoteBackupService',
          'RevokeBackupSlot', request, RevokeBackupSlotResponse());
  $async.Future<PutBackupResponse> putBackup(
          $pb.ClientContext? ctx, PutBackupRequest request) =>
      _client.invoke<PutBackupResponse>(ctx, 'RemoteBackupService', 'PutBackup',
          request, PutBackupResponse());
  $async.Future<GetBackupResponse> getBackup(
          $pb.ClientContext? ctx, GetBackupRequest request) =>
      _client.invoke<GetBackupResponse>(ctx, 'RemoteBackupService', 'GetBackup',
          request, GetBackupResponse());
  $async.Future<AdvanceBackupWitnessResponse> advanceBackupWitness(
          $pb.ClientContext? ctx, AdvanceBackupWitnessRequest request) =>
      _client.invoke<AdvanceBackupWitnessResponse>(ctx, 'RemoteBackupService',
          'AdvanceBackupWitness', request, AdvanceBackupWitnessResponse());
  $async.Future<ReadBackupWitnessResponse> readBackupWitness(
          $pb.ClientContext? ctx, ReadBackupWitnessRequest request) =>
      _client.invoke<ReadBackupWitnessResponse>(ctx, 'RemoteBackupService',
          'ReadBackupWitness', request, ReadBackupWitnessResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
