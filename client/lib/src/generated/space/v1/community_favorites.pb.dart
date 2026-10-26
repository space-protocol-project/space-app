// This is a generated file - do not edit.
//
// Generated from space/v1/community_favorites.proto.

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
import 'community_search.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CommunityFavoriteState extends $pb.GeneratedMessage {
  factory CommunityFavoriteState({
    $0.CommunityContentReference? content,
    $core.bool? saved,
    $fixnum.Int64? revision,
  }) {
    final result = CommunityFavoriteState._();
    if (content != null) result.content = content;
    if (saved != null) result.saved = saved;
    if (revision != null) result.revision = revision;
    return result;
  }

  CommunityFavoriteState._();

  factory CommunityFavoriteState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityFavoriteState()..mergeFromBuffer(data, registry);
  factory CommunityFavoriteState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityFavoriteState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunityFavoriteState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunityFavoriteState.$_createMessage)
    ..aOM<$0.CommunityContentReference>(1, _omitFieldNames ? '' : 'content',
        subBuilder: $0.CommunityContentReference.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'saved')
    ..aInt64(3, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityFavoriteState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityFavoriteState copyWith(
          void Function(CommunityFavoriteState) updates) =>
      super.copyWith((message) => updates(message as CommunityFavoriteState))
          as CommunityFavoriteState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommunityFavoriteState() / CommunityFavoriteState.new instead')
  static CommunityFavoriteState create() => CommunityFavoriteState._();
  static $pb.GeneratedMessage $_createMessage() => CommunityFavoriteState._();
  @$core.override
  CommunityFavoriteState createEmptyInstance() => CommunityFavoriteState._();
  @$core.pragma('dart2js:noInline')
  static CommunityFavoriteState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommunityFavoriteState>(
          CommunityFavoriteState.$_createMessage);
  static CommunityFavoriteState? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommunityContentReference get content => $_getN(0);
  @$pb.TagNumber(1)
  set content($0.CommunityContentReference value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.CommunityContentReference ensureContent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get saved => $_getBF(1);
  @$pb.TagNumber(2)
  set saved($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSaved() => $_has(1);
  @$pb.TagNumber(2)
  void clearSaved() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get revision => $_getI64(2);
  @$pb.TagNumber(3)
  set revision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);
}

class GetCommunityFavoriteStatesRequest extends $pb.GeneratedMessage {
  factory GetCommunityFavoriteStatesRequest({
    $core.String? channelId,
    $core.Iterable<$0.CommunityContentReference>? contents,
  }) {
    final result = GetCommunityFavoriteStatesRequest._();
    if (channelId != null) result.channelId = channelId;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  GetCommunityFavoriteStatesRequest._();

  factory GetCommunityFavoriteStatesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityFavoriteStatesRequest()..mergeFromBuffer(data, registry);
  factory GetCommunityFavoriteStatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityFavoriteStatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCommunityFavoriteStatesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetCommunityFavoriteStatesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..pPM<$0.CommunityContentReference>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: $0.CommunityContentReference.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityFavoriteStatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityFavoriteStatesRequest copyWith(
          void Function(GetCommunityFavoriteStatesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetCommunityFavoriteStatesRequest))
          as GetCommunityFavoriteStatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCommunityFavoriteStatesRequest() / GetCommunityFavoriteStatesRequest.new instead')
  static GetCommunityFavoriteStatesRequest create() =>
      GetCommunityFavoriteStatesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCommunityFavoriteStatesRequest._();
  @$core.override
  GetCommunityFavoriteStatesRequest createEmptyInstance() =>
      GetCommunityFavoriteStatesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCommunityFavoriteStatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCommunityFavoriteStatesRequest>(
          GetCommunityFavoriteStatesRequest.$_createMessage);
  static GetCommunityFavoriteStatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$0.CommunityContentReference> get contents => $_getList(1);
}

class GetCommunityFavoriteStatesResponse extends $pb.GeneratedMessage {
  factory GetCommunityFavoriteStatesResponse({
    $core.Iterable<CommunityFavoriteState>? states,
  }) {
    final result = GetCommunityFavoriteStatesResponse._();
    if (states != null) result.states.addAll(states);
    return result;
  }

  GetCommunityFavoriteStatesResponse._();

  factory GetCommunityFavoriteStatesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityFavoriteStatesResponse()..mergeFromBuffer(data, registry);
  factory GetCommunityFavoriteStatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityFavoriteStatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCommunityFavoriteStatesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetCommunityFavoriteStatesResponse.$_createMessage)
    ..pPM<CommunityFavoriteState>(1, _omitFieldNames ? '' : 'states',
        subBuilder: CommunityFavoriteState.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityFavoriteStatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityFavoriteStatesResponse copyWith(
          void Function(GetCommunityFavoriteStatesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetCommunityFavoriteStatesResponse))
          as GetCommunityFavoriteStatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCommunityFavoriteStatesResponse() / GetCommunityFavoriteStatesResponse.new instead')
  static GetCommunityFavoriteStatesResponse create() =>
      GetCommunityFavoriteStatesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCommunityFavoriteStatesResponse._();
  @$core.override
  GetCommunityFavoriteStatesResponse createEmptyInstance() =>
      GetCommunityFavoriteStatesResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCommunityFavoriteStatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCommunityFavoriteStatesResponse>(
          GetCommunityFavoriteStatesResponse.$_createMessage);
  static GetCommunityFavoriteStatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommunityFavoriteState> get states => $_getList(0);
}

class ListCommunityFavoritesRequest extends $pb.GeneratedMessage {
  factory ListCommunityFavoritesRequest({
    $core.String? channelId,
    $core.String? pageToken,
    $core.int? limit,
  }) {
    final result = ListCommunityFavoritesRequest._();
    if (channelId != null) result.channelId = channelId;
    if (pageToken != null) result.pageToken = pageToken;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListCommunityFavoritesRequest._();

  factory ListCommunityFavoritesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityFavoritesRequest()..mergeFromBuffer(data, registry);
  factory ListCommunityFavoritesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityFavoritesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommunityFavoritesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListCommunityFavoritesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityFavoritesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityFavoritesRequest copyWith(
          void Function(ListCommunityFavoritesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCommunityFavoritesRequest))
          as ListCommunityFavoritesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCommunityFavoritesRequest() / ListCommunityFavoritesRequest.new instead')
  static ListCommunityFavoritesRequest create() =>
      ListCommunityFavoritesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCommunityFavoritesRequest._();
  @$core.override
  ListCommunityFavoritesRequest createEmptyInstance() =>
      ListCommunityFavoritesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCommunityFavoritesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommunityFavoritesRequest>(
          ListCommunityFavoritesRequest.$_createMessage);
  static ListCommunityFavoritesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class CommunityFavorite extends $pb.GeneratedMessage {
  factory CommunityFavorite({
    $1.CommunitySearchResult? result,
    $fixnum.Int64? savedAtUnixMicros,
  }) {
    final result$ = CommunityFavorite._();
    if (result != null) result$.result = result;
    if (savedAtUnixMicros != null)
      result$.savedAtUnixMicros = savedAtUnixMicros;
    return result$;
  }

  CommunityFavorite._();

  factory CommunityFavorite.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityFavorite()..mergeFromBuffer(data, registry);
  factory CommunityFavorite.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityFavorite()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunityFavorite',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunityFavorite.$_createMessage)
    ..aOM<$1.CommunitySearchResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: $1.CommunitySearchResult.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'savedAtUnixMicros')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityFavorite clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityFavorite copyWith(void Function(CommunityFavorite) updates) =>
      super.copyWith((message) => updates(message as CommunityFavorite))
          as CommunityFavorite;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CommunityFavorite() / CommunityFavorite.new instead')
  static CommunityFavorite create() => CommunityFavorite._();
  static $pb.GeneratedMessage $_createMessage() => CommunityFavorite._();
  @$core.override
  CommunityFavorite createEmptyInstance() => CommunityFavorite._();
  @$core.pragma('dart2js:noInline')
  static CommunityFavorite getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommunityFavorite>(
          CommunityFavorite.$_createMessage);
  static CommunityFavorite? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommunitySearchResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result($1.CommunitySearchResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommunitySearchResult ensureResult() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get savedAtUnixMicros => $_getI64(1);
  @$pb.TagNumber(2)
  set savedAtUnixMicros($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSavedAtUnixMicros() => $_has(1);
  @$pb.TagNumber(2)
  void clearSavedAtUnixMicros() => $_clearField(2);
}

class ListCommunityFavoritesResponse extends $pb.GeneratedMessage {
  factory ListCommunityFavoritesResponse({
    $core.Iterable<CommunityFavorite>? favorites,
    $core.String? nextPageToken,
  }) {
    final result = ListCommunityFavoritesResponse._();
    if (favorites != null) result.favorites.addAll(favorites);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  ListCommunityFavoritesResponse._();

  factory ListCommunityFavoritesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityFavoritesResponse()..mergeFromBuffer(data, registry);
  factory ListCommunityFavoritesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityFavoritesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommunityFavoritesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListCommunityFavoritesResponse.$_createMessage)
    ..pPM<CommunityFavorite>(1, _omitFieldNames ? '' : 'favorites',
        subBuilder: CommunityFavorite.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityFavoritesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityFavoritesResponse copyWith(
          void Function(ListCommunityFavoritesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCommunityFavoritesResponse))
          as ListCommunityFavoritesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCommunityFavoritesResponse() / ListCommunityFavoritesResponse.new instead')
  static ListCommunityFavoritesResponse create() =>
      ListCommunityFavoritesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCommunityFavoritesResponse._();
  @$core.override
  ListCommunityFavoritesResponse createEmptyInstance() =>
      ListCommunityFavoritesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCommunityFavoritesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommunityFavoritesResponse>(
          ListCommunityFavoritesResponse.$_createMessage);
  static ListCommunityFavoritesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommunityFavorite> get favorites => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class SetCommunityFavoriteRequest extends $pb.GeneratedMessage {
  factory SetCommunityFavoriteRequest({
    $core.String? channelId,
    $0.CommunityContentReference? content,
    $core.bool? saved,
    $fixnum.Int64? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = SetCommunityFavoriteRequest._();
    if (channelId != null) result.channelId = channelId;
    if (content != null) result.content = content;
    if (saved != null) result.saved = saved;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  SetCommunityFavoriteRequest._();

  factory SetCommunityFavoriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityFavoriteRequest()..mergeFromBuffer(data, registry);
  factory SetCommunityFavoriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityFavoriteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetCommunityFavoriteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetCommunityFavoriteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOM<$0.CommunityContentReference>(2, _omitFieldNames ? '' : 'content',
        subBuilder: $0.CommunityContentReference.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'saved')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(5, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityFavoriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityFavoriteRequest copyWith(
          void Function(SetCommunityFavoriteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetCommunityFavoriteRequest))
          as SetCommunityFavoriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetCommunityFavoriteRequest() / SetCommunityFavoriteRequest.new instead')
  static SetCommunityFavoriteRequest create() =>
      SetCommunityFavoriteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetCommunityFavoriteRequest._();
  @$core.override
  SetCommunityFavoriteRequest createEmptyInstance() =>
      SetCommunityFavoriteRequest._();
  @$core.pragma('dart2js:noInline')
  static SetCommunityFavoriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetCommunityFavoriteRequest>(
          SetCommunityFavoriteRequest.$_createMessage);
  static SetCommunityFavoriteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.CommunityContentReference get content => $_getN(1);
  @$pb.TagNumber(2)
  set content($0.CommunityContentReference value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.CommunityContentReference ensureContent() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get saved => $_getBF(2);
  @$pb.TagNumber(3)
  set saved($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSaved() => $_has(2);
  @$pb.TagNumber(3)
  void clearSaved() => $_clearField(3);

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
}

class SetCommunityFavoriteResponse extends $pb.GeneratedMessage {
  factory SetCommunityFavoriteResponse({
    CommunityFavoriteState? state,
    $core.String? idempotencyKey,
    $fixnum.Int64? appliedRevision,
  }) {
    final result = SetCommunityFavoriteResponse._();
    if (state != null) result.state = state;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (appliedRevision != null) result.appliedRevision = appliedRevision;
    return result;
  }

  SetCommunityFavoriteResponse._();

  factory SetCommunityFavoriteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityFavoriteResponse()..mergeFromBuffer(data, registry);
  factory SetCommunityFavoriteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityFavoriteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetCommunityFavoriteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetCommunityFavoriteResponse.$_createMessage)
    ..aOM<CommunityFavoriteState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: CommunityFavoriteState.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'idempotencyKey')
    ..aInt64(3, _omitFieldNames ? '' : 'appliedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityFavoriteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityFavoriteResponse copyWith(
          void Function(SetCommunityFavoriteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetCommunityFavoriteResponse))
          as SetCommunityFavoriteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetCommunityFavoriteResponse() / SetCommunityFavoriteResponse.new instead')
  static SetCommunityFavoriteResponse create() =>
      SetCommunityFavoriteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetCommunityFavoriteResponse._();
  @$core.override
  SetCommunityFavoriteResponse createEmptyInstance() =>
      SetCommunityFavoriteResponse._();
  @$core.pragma('dart2js:noInline')
  static SetCommunityFavoriteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetCommunityFavoriteResponse>(
          SetCommunityFavoriteResponse.$_createMessage);
  static SetCommunityFavoriteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CommunityFavoriteState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(CommunityFavoriteState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  CommunityFavoriteState ensureState() => $_ensure(0);

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

/// core.community.favorites.v1: личное избранное участника, общее для его устройств.
class CommunityFavoriteServiceApi {
  final $pb.RpcClient _client;

  CommunityFavoriteServiceApi(this._client);

  $async.Future<GetCommunityFavoriteStatesResponse> getCommunityFavoriteStates(
          $pb.ClientContext? ctx, GetCommunityFavoriteStatesRequest request) =>
      _client.invoke<GetCommunityFavoriteStatesResponse>(
          ctx,
          'CommunityFavoriteService',
          'GetCommunityFavoriteStates',
          request,
          GetCommunityFavoriteStatesResponse());
  $async.Future<ListCommunityFavoritesResponse> listCommunityFavorites(
          $pb.ClientContext? ctx, ListCommunityFavoritesRequest request) =>
      _client.invoke<ListCommunityFavoritesResponse>(
          ctx,
          'CommunityFavoriteService',
          'ListCommunityFavorites',
          request,
          ListCommunityFavoritesResponse());
  $async.Future<SetCommunityFavoriteResponse> setCommunityFavorite(
          $pb.ClientContext? ctx, SetCommunityFavoriteRequest request) =>
      _client.invoke<SetCommunityFavoriteResponse>(
          ctx,
          'CommunityFavoriteService',
          'SetCommunityFavorite',
          request,
          SetCommunityFavoriteResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
