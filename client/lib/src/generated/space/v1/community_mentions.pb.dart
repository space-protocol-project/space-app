// This is a generated file - do not edit.
//
// Generated from space/v1/community_mentions.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'community_search.pbenum.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// core.community.mentions.v1. Диапазоны измеряются в UTF-16 code units.
/// Не больше десяти непересекающихся диапазонов в порядке start.
class CommunityMention extends $pb.GeneratedMessage {
  factory CommunityMention({
    $core.String? principalId,
    $core.String? displayName,
    $core.int? start,
    $core.int? length,
  }) {
    final result = CommunityMention._();
    if (principalId != null) result.principalId = principalId;
    if (displayName != null) result.displayName = displayName;
    if (start != null) result.start = start;
    if (length != null) result.length = length;
    return result;
  }

  CommunityMention._();

  factory CommunityMention.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityMention()..mergeFromBuffer(data, registry);
  factory CommunityMention.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityMention()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunityMention',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunityMention.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aI(3, _omitFieldNames ? '' : 'start')
    ..aI(4, _omitFieldNames ? '' : 'length')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityMention clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityMention copyWith(void Function(CommunityMention) updates) =>
      super.copyWith((message) => updates(message as CommunityMention))
          as CommunityMention;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CommunityMention() / CommunityMention.new instead')
  static CommunityMention create() => CommunityMention._();
  static $pb.GeneratedMessage $_createMessage() => CommunityMention._();
  @$core.override
  CommunityMention createEmptyInstance() => CommunityMention._();
  @$core.pragma('dart2js:noInline')
  static CommunityMention getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommunityMention>(
          CommunityMention.$_createMessage);
  static CommunityMention? _defaultInstance;

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
  $core.int get start => $_getIZ(2);
  @$pb.TagNumber(3)
  set start($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearStart() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get length => $_getIZ(3);
  @$pb.TagNumber(4)
  set length($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLength() => $_has(3);
  @$pb.TagNumber(4)
  void clearLength() => $_clearField(4);
}

class ListMentionCandidatesRequest extends $pb.GeneratedMessage {
  factory ListMentionCandidatesRequest({
    $core.String? channelId,
    $core.String? parentId,
    $core.String? query,
  }) {
    final result = ListMentionCandidatesRequest._();
    if (channelId != null) result.channelId = channelId;
    if (parentId != null) result.parentId = parentId;
    if (query != null) result.query = query;
    return result;
  }

  ListMentionCandidatesRequest._();

  factory ListMentionCandidatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMentionCandidatesRequest()..mergeFromBuffer(data, registry);
  factory ListMentionCandidatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMentionCandidatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMentionCandidatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMentionCandidatesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'parentId')
    ..aOS(3, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMentionCandidatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMentionCandidatesRequest copyWith(
          void Function(ListMentionCandidatesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListMentionCandidatesRequest))
          as ListMentionCandidatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListMentionCandidatesRequest() / ListMentionCandidatesRequest.new instead')
  static ListMentionCandidatesRequest create() =>
      ListMentionCandidatesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListMentionCandidatesRequest._();
  @$core.override
  ListMentionCandidatesRequest createEmptyInstance() =>
      ListMentionCandidatesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListMentionCandidatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMentionCandidatesRequest>(
          ListMentionCandidatesRequest.$_createMessage);
  static ListMentionCandidatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get query => $_getSZ(2);
  @$pb.TagNumber(3)
  set query($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuery() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuery() => $_clearField(3);
}

class MentionCandidate extends $pb.GeneratedMessage {
  factory MentionCandidate({
    $core.String? principalId,
    $core.String? displayName,
  }) {
    final result = MentionCandidate._();
    if (principalId != null) result.principalId = principalId;
    if (displayName != null) result.displayName = displayName;
    return result;
  }

  MentionCandidate._();

  factory MentionCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MentionCandidate()..mergeFromBuffer(data, registry);
  factory MentionCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MentionCandidate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MentionCandidate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MentionCandidate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MentionCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MentionCandidate copyWith(void Function(MentionCandidate) updates) =>
      super.copyWith((message) => updates(message as MentionCandidate))
          as MentionCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MentionCandidate() / MentionCandidate.new instead')
  static MentionCandidate create() => MentionCandidate._();
  static $pb.GeneratedMessage $_createMessage() => MentionCandidate._();
  @$core.override
  MentionCandidate createEmptyInstance() => MentionCandidate._();
  @$core.pragma('dart2js:noInline')
  static MentionCandidate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MentionCandidate>(
          MentionCandidate.$_createMessage);
  static MentionCandidate? _defaultInstance;

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
}

class ListMentionCandidatesResponse extends $pb.GeneratedMessage {
  factory ListMentionCandidatesResponse({
    $core.Iterable<MentionCandidate>? candidates,
  }) {
    final result = ListMentionCandidatesResponse._();
    if (candidates != null) result.candidates.addAll(candidates);
    return result;
  }

  ListMentionCandidatesResponse._();

  factory ListMentionCandidatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMentionCandidatesResponse()..mergeFromBuffer(data, registry);
  factory ListMentionCandidatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMentionCandidatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMentionCandidatesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMentionCandidatesResponse.$_createMessage)
    ..pPM<MentionCandidate>(1, _omitFieldNames ? '' : 'candidates',
        subBuilder: MentionCandidate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMentionCandidatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMentionCandidatesResponse copyWith(
          void Function(ListMentionCandidatesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListMentionCandidatesResponse))
          as ListMentionCandidatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListMentionCandidatesResponse() / ListMentionCandidatesResponse.new instead')
  static ListMentionCandidatesResponse create() =>
      ListMentionCandidatesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListMentionCandidatesResponse._();
  @$core.override
  ListMentionCandidatesResponse createEmptyInstance() =>
      ListMentionCandidatesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListMentionCandidatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMentionCandidatesResponse>(
          ListMentionCandidatesResponse.$_createMessage);
  static ListMentionCandidatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MentionCandidate> get candidates => $_getList(0);
}

class CommunityContentReference extends $pb.GeneratedMessage {
  factory CommunityContentReference({
    $0.CommunitySearchKind? kind,
    $core.String? id,
  }) {
    final result = CommunityContentReference._();
    if (kind != null) result.kind = kind;
    if (id != null) result.id = id;
    return result;
  }

  CommunityContentReference._();

  factory CommunityContentReference.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityContentReference()..mergeFromBuffer(data, registry);
  factory CommunityContentReference.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityContentReference()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunityContentReference',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunityContentReference.$_createMessage)
    ..aE<$0.CommunitySearchKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: $0.CommunitySearchKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityContentReference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityContentReference copyWith(
          void Function(CommunityContentReference) updates) =>
      super.copyWith((message) => updates(message as CommunityContentReference))
          as CommunityContentReference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommunityContentReference() / CommunityContentReference.new instead')
  static CommunityContentReference create() => CommunityContentReference._();
  static $pb.GeneratedMessage $_createMessage() =>
      CommunityContentReference._();
  @$core.override
  CommunityContentReference createEmptyInstance() =>
      CommunityContentReference._();
  @$core.pragma('dart2js:noInline')
  static CommunityContentReference getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommunityContentReference>(
          CommunityContentReference.$_createMessage);
  static CommunityContentReference? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommunitySearchKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind($0.CommunitySearchKind value) => $_setField(1, value);
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
}

class MarkCommunityMentionsReadRequest extends $pb.GeneratedMessage {
  factory MarkCommunityMentionsReadRequest({
    $core.String? channelId,
    $core.Iterable<CommunityContentReference>? contents,
  }) {
    final result = MarkCommunityMentionsReadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  MarkCommunityMentionsReadRequest._();

  factory MarkCommunityMentionsReadRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkCommunityMentionsReadRequest()..mergeFromBuffer(data, registry);
  factory MarkCommunityMentionsReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkCommunityMentionsReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkCommunityMentionsReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MarkCommunityMentionsReadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..pPM<CommunityContentReference>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: CommunityContentReference.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkCommunityMentionsReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkCommunityMentionsReadRequest copyWith(
          void Function(MarkCommunityMentionsReadRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MarkCommunityMentionsReadRequest))
          as MarkCommunityMentionsReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkCommunityMentionsReadRequest() / MarkCommunityMentionsReadRequest.new instead')
  static MarkCommunityMentionsReadRequest create() =>
      MarkCommunityMentionsReadRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkCommunityMentionsReadRequest._();
  @$core.override
  MarkCommunityMentionsReadRequest createEmptyInstance() =>
      MarkCommunityMentionsReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkCommunityMentionsReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkCommunityMentionsReadRequest>(
          MarkCommunityMentionsReadRequest.$_createMessage);
  static MarkCommunityMentionsReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<CommunityContentReference> get contents => $_getList(1);
}

class MarkCommunityMentionsReadResponse extends $pb.GeneratedMessage {
  factory MarkCommunityMentionsReadResponse() =>
      MarkCommunityMentionsReadResponse._();

  MarkCommunityMentionsReadResponse._();

  factory MarkCommunityMentionsReadResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkCommunityMentionsReadResponse()..mergeFromBuffer(data, registry);
  factory MarkCommunityMentionsReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkCommunityMentionsReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkCommunityMentionsReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MarkCommunityMentionsReadResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkCommunityMentionsReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkCommunityMentionsReadResponse copyWith(
          void Function(MarkCommunityMentionsReadResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MarkCommunityMentionsReadResponse))
          as MarkCommunityMentionsReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkCommunityMentionsReadResponse() / MarkCommunityMentionsReadResponse.new instead')
  static MarkCommunityMentionsReadResponse create() =>
      MarkCommunityMentionsReadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkCommunityMentionsReadResponse._();
  @$core.override
  MarkCommunityMentionsReadResponse createEmptyInstance() =>
      MarkCommunityMentionsReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkCommunityMentionsReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkCommunityMentionsReadResponse>(
          MarkCommunityMentionsReadResponse.$_createMessage);
  static MarkCommunityMentionsReadResponse? _defaultInstance;
}

class CommunityMentionServiceApi {
  final $pb.RpcClient _client;

  CommunityMentionServiceApi(this._client);

  $async.Future<ListMentionCandidatesResponse> listMentionCandidates(
          $pb.ClientContext? ctx, ListMentionCandidatesRequest request) =>
      _client.invoke<ListMentionCandidatesResponse>(
          ctx,
          'CommunityMentionService',
          'ListMentionCandidates',
          request,
          ListMentionCandidatesResponse());
  $async.Future<MarkCommunityMentionsReadResponse> markCommunityMentionsRead(
          $pb.ClientContext? ctx, MarkCommunityMentionsReadRequest request) =>
      _client.invoke<MarkCommunityMentionsReadResponse>(
          ctx,
          'CommunityMentionService',
          'MarkCommunityMentionsRead',
          request,
          MarkCommunityMentionsReadResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
