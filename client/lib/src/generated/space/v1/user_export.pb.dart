// This is a generated file - do not edit.
//
// Generated from space/v1/user_export.proto.

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

import 'space_search.pbenum.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ExportUserContentRequest extends $pb.GeneratedMessage {
  factory ExportUserContentRequest({
    $core.String? channelId,
    $fixnum.Int64? createdAfterUnixMs,
    $fixnum.Int64? createdBeforeUnixMs,
  }) {
    final result = ExportUserContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (createdAfterUnixMs != null)
      result.createdAfterUnixMs = createdAfterUnixMs;
    if (createdBeforeUnixMs != null)
      result.createdBeforeUnixMs = createdBeforeUnixMs;
    return result;
  }

  ExportUserContentRequest._();

  factory ExportUserContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportUserContentRequest()..mergeFromBuffer(data, registry);
  factory ExportUserContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportUserContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportUserContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExportUserContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'createdAfterUnixMs')
    ..aInt64(3, _omitFieldNames ? '' : 'createdBeforeUnixMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportUserContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportUserContentRequest copyWith(
          void Function(ExportUserContentRequest) updates) =>
      super.copyWith((message) => updates(message as ExportUserContentRequest))
          as ExportUserContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportUserContentRequest() / ExportUserContentRequest.new instead')
  static ExportUserContentRequest create() => ExportUserContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => ExportUserContentRequest._();
  @$core.override
  ExportUserContentRequest createEmptyInstance() =>
      ExportUserContentRequest._();
  @$core.pragma('dart2js:noInline')
  static ExportUserContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportUserContentRequest>(
          ExportUserContentRequest.$_createMessage);
  static ExportUserContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createdAfterUnixMs => $_getI64(1);
  @$pb.TagNumber(2)
  set createdAfterUnixMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreatedAfterUnixMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAfterUnixMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createdBeforeUnixMs => $_getI64(2);
  @$pb.TagNumber(3)
  set createdBeforeUnixMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedBeforeUnixMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedBeforeUnixMs() => $_clearField(3);
}

class UserExportAttachment extends $pb.GeneratedMessage {
  factory UserExportAttachment({
    $core.String? id,
    $core.String? name,
    $core.String? mimeType,
    $fixnum.Int64? byteSize,
    $core.List<$core.int>? sha256,
  }) {
    final result = UserExportAttachment._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (mimeType != null) result.mimeType = mimeType;
    if (byteSize != null) result.byteSize = byteSize;
    if (sha256 != null) result.sha256 = sha256;
    return result;
  }

  UserExportAttachment._();

  factory UserExportAttachment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserExportAttachment()..mergeFromBuffer(data, registry);
  factory UserExportAttachment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserExportAttachment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserExportAttachment',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UserExportAttachment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'mimeType')
    ..aInt64(4, _omitFieldNames ? '' : 'byteSize')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'sha256', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserExportAttachment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserExportAttachment copyWith(void Function(UserExportAttachment) updates) =>
      super.copyWith((message) => updates(message as UserExportAttachment))
          as UserExportAttachment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UserExportAttachment() / UserExportAttachment.new instead')
  static UserExportAttachment create() => UserExportAttachment._();
  static $pb.GeneratedMessage $_createMessage() => UserExportAttachment._();
  @$core.override
  UserExportAttachment createEmptyInstance() => UserExportAttachment._();
  @$core.pragma('dart2js:noInline')
  static UserExportAttachment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserExportAttachment>(
          UserExportAttachment.$_createMessage);
  static UserExportAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get mimeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set mimeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMimeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearMimeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get byteSize => $_getI64(3);
  @$pb.TagNumber(4)
  set byteSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasByteSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearByteSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get sha256 => $_getN(4);
  @$pb.TagNumber(5)
  set sha256($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSha256() => $_has(4);
  @$pb.TagNumber(5)
  void clearSha256() => $_clearField(5);
}

class UserExportEntry extends $pb.GeneratedMessage {
  factory UserExportEntry({
    $0.SpaceSearchKind? kind,
    $core.String? id,
    $core.String? channelId,
    $core.String? channelTitle,
    $core.String? parentId,
    $core.String? title,
    $core.String? text,
    $fixnum.Int64? createdAtUnixMs,
    $fixnum.Int64? revision,
    $core.Iterable<UserExportAttachment>? attachments,
    $core.String? repostOf,
  }) {
    final result = UserExportEntry._();
    if (kind != null) result.kind = kind;
    if (id != null) result.id = id;
    if (channelId != null) result.channelId = channelId;
    if (channelTitle != null) result.channelTitle = channelTitle;
    if (parentId != null) result.parentId = parentId;
    if (title != null) result.title = title;
    if (text != null) result.text = text;
    if (createdAtUnixMs != null) result.createdAtUnixMs = createdAtUnixMs;
    if (revision != null) result.revision = revision;
    if (attachments != null) result.attachments.addAll(attachments);
    if (repostOf != null) result.repostOf = repostOf;
    return result;
  }

  UserExportEntry._();

  factory UserExportEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserExportEntry()..mergeFromBuffer(data, registry);
  factory UserExportEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserExportEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserExportEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UserExportEntry.$_createMessage)
    ..aE<$0.SpaceSearchKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: $0.SpaceSearchKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'channelId')
    ..aOS(4, _omitFieldNames ? '' : 'channelTitle')
    ..aOS(5, _omitFieldNames ? '' : 'parentId')
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'text')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtUnixMs')
    ..aInt64(9, _omitFieldNames ? '' : 'revision')
    ..pPM<UserExportAttachment>(10, _omitFieldNames ? '' : 'attachments',
        subBuilder: UserExportAttachment.$_createMessage)
    ..aOS(11, _omitFieldNames ? '' : 'repostOf')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserExportEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserExportEntry copyWith(void Function(UserExportEntry) updates) =>
      super.copyWith((message) => updates(message as UserExportEntry))
          as UserExportEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserExportEntry() / UserExportEntry.new instead')
  static UserExportEntry create() => UserExportEntry._();
  static $pb.GeneratedMessage $_createMessage() => UserExportEntry._();
  @$core.override
  UserExportEntry createEmptyInstance() => UserExportEntry._();
  @$core.pragma('dart2js:noInline')
  static UserExportEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserExportEntry>(
          UserExportEntry.$_createMessage);
  static UserExportEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SpaceSearchKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind($0.SpaceSearchKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get channelId => $_getSZ(2);
  @$pb.TagNumber(3)
  set channelId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get channelTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set channelTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChannelTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearChannelTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get parentId => $_getSZ(4);
  @$pb.TagNumber(5)
  set parentId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasParentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearParentId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get text => $_getSZ(6);
  @$pb.TagNumber(7)
  set text($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasText() => $_has(6);
  @$pb.TagNumber(7)
  void clearText() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAtUnixMs => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAtUnixMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAtUnixMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAtUnixMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get revision => $_getI64(8);
  @$pb.TagNumber(9)
  set revision($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRevision() => $_has(8);
  @$pb.TagNumber(9)
  void clearRevision() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<UserExportAttachment> get attachments => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get repostOf => $_getSZ(10);
  @$pb.TagNumber(11)
  set repostOf($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRepostOf() => $_has(10);
  @$pb.TagNumber(11)
  void clearRepostOf() => $_clearField(11);
}

class ExportUserContentResponse extends $pb.GeneratedMessage {
  factory ExportUserContentResponse({
    $core.int? formatVersion,
    $core.String? serverId,
    $core.String? principalId,
    $fixnum.Int64? generatedAtUnixMs,
    $core.Iterable<UserExportEntry>? entries,
  }) {
    final result = ExportUserContentResponse._();
    if (formatVersion != null) result.formatVersion = formatVersion;
    if (serverId != null) result.serverId = serverId;
    if (principalId != null) result.principalId = principalId;
    if (generatedAtUnixMs != null) result.generatedAtUnixMs = generatedAtUnixMs;
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ExportUserContentResponse._();

  factory ExportUserContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportUserContentResponse()..mergeFromBuffer(data, registry);
  factory ExportUserContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportUserContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportUserContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExportUserContentResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'formatVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'principalId')
    ..aInt64(4, _omitFieldNames ? '' : 'generatedAtUnixMs')
    ..pPM<UserExportEntry>(5, _omitFieldNames ? '' : 'entries',
        subBuilder: UserExportEntry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportUserContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportUserContentResponse copyWith(
          void Function(ExportUserContentResponse) updates) =>
      super.copyWith((message) => updates(message as ExportUserContentResponse))
          as ExportUserContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportUserContentResponse() / ExportUserContentResponse.new instead')
  static ExportUserContentResponse create() => ExportUserContentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExportUserContentResponse._();
  @$core.override
  ExportUserContentResponse createEmptyInstance() =>
      ExportUserContentResponse._();
  @$core.pragma('dart2js:noInline')
  static ExportUserContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportUserContentResponse>(
          ExportUserContentResponse.$_createMessage);
  static ExportUserContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get formatVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set formatVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFormatVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormatVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get principalId => $_getSZ(2);
  @$pb.TagNumber(3)
  set principalId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrincipalId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrincipalId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get generatedAtUnixMs => $_getI64(3);
  @$pb.TagNumber(4)
  set generatedAtUnixMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGeneratedAtUnixMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeneratedAtUnixMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<UserExportEntry> get entries => $_getList(4);
}

/// core.user.export.v1: собственное доступное содержимое, без ключей и токенов.
class UserExportServiceApi {
  final $pb.RpcClient _client;

  UserExportServiceApi(this._client);

  $async.Future<ExportUserContentResponse> exportUserContent(
          $pb.ClientContext? ctx, ExportUserContentRequest request) =>
      _client.invoke<ExportUserContentResponse>(ctx, 'UserExportService',
          'ExportUserContent', request, ExportUserContentResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
