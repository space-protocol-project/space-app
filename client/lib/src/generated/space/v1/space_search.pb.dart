// This is a generated file - do not edit.
//
// Generated from space/v1/space_search.proto.

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

import 'space_search.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'space_search.pbenum.dart';

class SearchSpaceRequest extends $pb.GeneratedMessage {
  factory SearchSpaceRequest({
    $core.String? query,
    $core.String? pageToken,
    $core.int? limit,
  }) {
    final result = SearchSpaceRequest._();
    if (query != null) result.query = query;
    if (pageToken != null) result.pageToken = pageToken;
    if (limit != null) result.limit = limit;
    return result;
  }

  SearchSpaceRequest._();

  factory SearchSpaceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSpaceRequest()..mergeFromBuffer(data, registry);
  factory SearchSpaceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSpaceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSpaceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SearchSpaceRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpaceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpaceRequest copyWith(void Function(SearchSpaceRequest) updates) =>
      super.copyWith((message) => updates(message as SearchSpaceRequest))
          as SearchSpaceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchSpaceRequest() / SearchSpaceRequest.new instead')
  static SearchSpaceRequest create() => SearchSpaceRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchSpaceRequest._();
  @$core.override
  SearchSpaceRequest createEmptyInstance() => SearchSpaceRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchSpaceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSpaceRequest>(
          SearchSpaceRequest.$_createMessage);
  static SearchSpaceRequest? _defaultInstance;

  /// Буквальная подстрока, 1..256 байт UTF-8 после trim.
  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  /// Курсор привязан к запросу и личности, но не предоставляет прав доступа.
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

class SpaceSearchResult extends $pb.GeneratedMessage {
  factory SpaceSearchResult({
    $core.String? channelId,
    $core.String? channelTitle,
    SpaceSearchKind? kind,
    $core.String? id,
    $core.String? parentId,
    $core.String? title,
    $core.String? snippet,
    $core.String? authorId,
    $core.String? authorName,
    $fixnum.Int64? createdAtUnixMs,
    $fixnum.Int64? sequence,
  }) {
    final result = SpaceSearchResult._();
    if (channelId != null) result.channelId = channelId;
    if (channelTitle != null) result.channelTitle = channelTitle;
    if (kind != null) result.kind = kind;
    if (id != null) result.id = id;
    if (parentId != null) result.parentId = parentId;
    if (title != null) result.title = title;
    if (snippet != null) result.snippet = snippet;
    if (authorId != null) result.authorId = authorId;
    if (authorName != null) result.authorName = authorName;
    if (createdAtUnixMs != null) result.createdAtUnixMs = createdAtUnixMs;
    if (sequence != null) result.sequence = sequence;
    return result;
  }

  SpaceSearchResult._();

  factory SpaceSearchResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpaceSearchResult()..mergeFromBuffer(data, registry);
  factory SpaceSearchResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpaceSearchResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpaceSearchResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SpaceSearchResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'channelTitle')
    ..aE<SpaceSearchKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: SpaceSearchKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'id')
    ..aOS(5, _omitFieldNames ? '' : 'parentId')
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'snippet')
    ..aOS(8, _omitFieldNames ? '' : 'authorId')
    ..aOS(9, _omitFieldNames ? '' : 'authorName')
    ..aInt64(10, _omitFieldNames ? '' : 'createdAtUnixMs')
    ..aInt64(11, _omitFieldNames ? '' : 'sequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpaceSearchResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpaceSearchResult copyWith(void Function(SpaceSearchResult) updates) =>
      super.copyWith((message) => updates(message as SpaceSearchResult))
          as SpaceSearchResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SpaceSearchResult() / SpaceSearchResult.new instead')
  static SpaceSearchResult create() => SpaceSearchResult._();
  static $pb.GeneratedMessage $_createMessage() => SpaceSearchResult._();
  @$core.override
  SpaceSearchResult createEmptyInstance() => SpaceSearchResult._();
  @$core.pragma('dart2js:noInline')
  static SpaceSearchResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpaceSearchResult>(
          SpaceSearchResult.$_createMessage);
  static SpaceSearchResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get channelTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set channelTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChannelTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  SpaceSearchKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(SpaceSearchKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get id => $_getSZ(3);
  @$pb.TagNumber(4)
  set id($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => $_clearField(4);

  /// Для сообщения/темы/публикации совпадает с id; иначе тема/публикация родителя.
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

  /// Обычный текст до 240 Unicode code points, без файлов и полного содержимого.
  @$pb.TagNumber(7)
  $core.String get snippet => $_getSZ(6);
  @$pb.TagNumber(7)
  set snippet($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSnippet() => $_has(6);
  @$pb.TagNumber(7)
  void clearSnippet() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get authorId => $_getSZ(7);
  @$pb.TagNumber(8)
  set authorId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthorId() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthorId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get authorName => $_getSZ(8);
  @$pb.TagNumber(9)
  set authorName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthorName() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthorName() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdAtUnixMs => $_getI64(9);
  @$pb.TagNumber(10)
  set createdAtUnixMs($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAtUnixMs() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAtUnixMs() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get sequence => $_getI64(10);
  @$pb.TagNumber(11)
  set sequence($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSequence() => $_has(10);
  @$pb.TagNumber(11)
  void clearSequence() => $_clearField(11);
}

class SearchSpaceResponse extends $pb.GeneratedMessage {
  factory SearchSpaceResponse({
    $core.Iterable<SpaceSearchResult>? results,
    $core.String? nextPageToken,
  }) {
    final result = SearchSpaceResponse._();
    if (results != null) result.results.addAll(results);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  SearchSpaceResponse._();

  factory SearchSpaceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSpaceResponse()..mergeFromBuffer(data, registry);
  factory SearchSpaceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchSpaceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSpaceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SearchSpaceResponse.$_createMessage)
    ..pPM<SpaceSearchResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: SpaceSearchResult.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpaceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSpaceResponse copyWith(void Function(SearchSpaceResponse) updates) =>
      super.copyWith((message) => updates(message as SearchSpaceResponse))
          as SearchSpaceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use SearchSpaceResponse() / SearchSpaceResponse.new instead')
  static SearchSpaceResponse create() => SearchSpaceResponse._();
  static $pb.GeneratedMessage $_createMessage() => SearchSpaceResponse._();
  @$core.override
  SearchSpaceResponse createEmptyInstance() => SearchSpaceResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchSpaceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSpaceResponse>(
          SearchSpaceResponse.$_createMessage);
  static SearchSpaceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SpaceSearchResult> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

/// core.space.search.v1: общий поиск по доступным обычным чатам, форуму и ленте.
class SpaceSearchServiceApi {
  final $pb.RpcClient _client;

  SpaceSearchServiceApi(this._client);

  $async.Future<SearchSpaceResponse> searchSpace(
          $pb.ClientContext? ctx, SearchSpaceRequest request) =>
      _client.invoke<SearchSpaceResponse>(ctx, 'SpaceSearchService',
          'SearchSpace', request, SearchSpaceResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
