// This is a generated file - do not edit.
//
// Generated from space/v1/community_search.proto.

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

import 'community_search.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'community_search.pbenum.dart';

class SearchCommunityContentRequest extends $pb.GeneratedMessage {
  factory SearchCommunityContentRequest({
    $core.String? channelId,
    $core.String? query,
    $core.String? pageToken,
    $core.int? limit,
  }) {
    final result = SearchCommunityContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (query != null) result.query = query;
    if (pageToken != null) result.pageToken = pageToken;
    if (limit != null) result.limit = limit;
    return result;
  }

  SearchCommunityContentRequest._();

  factory SearchCommunityContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchCommunityContentRequest()..mergeFromBuffer(data, registry);
  factory SearchCommunityContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchCommunityContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchCommunityContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SearchCommunityContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchCommunityContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchCommunityContentRequest copyWith(
          void Function(SearchCommunityContentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SearchCommunityContentRequest))
          as SearchCommunityContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchCommunityContentRequest() / SearchCommunityContentRequest.new instead')
  static SearchCommunityContentRequest create() =>
      SearchCommunityContentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SearchCommunityContentRequest._();
  @$core.override
  SearchCommunityContentRequest createEmptyInstance() =>
      SearchCommunityContentRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchCommunityContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchCommunityContentRequest>(
          SearchCommunityContentRequest.$_createMessage);
  static SearchCommunityContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  /// Буквальная подстрока, 1..256 байт UTF-8 после удаления внешних пробелов.
  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);

  /// Непрозрачная страница связана с разделом, запросом и principal.
  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

class CommunitySearchResult extends $pb.GeneratedMessage {
  factory CommunitySearchResult({
    CommunitySearchKind? kind,
    $core.String? id,
    $core.String? parentId,
    $core.String? title,
    $core.String? snippet,
    $core.String? authorId,
    $core.String? authorName,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? sequence,
  }) {
    final result = CommunitySearchResult._();
    if (kind != null) result.kind = kind;
    if (id != null) result.id = id;
    if (parentId != null) result.parentId = parentId;
    if (title != null) result.title = title;
    if (snippet != null) result.snippet = snippet;
    if (authorId != null) result.authorId = authorId;
    if (authorName != null) result.authorName = authorName;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (sequence != null) result.sequence = sequence;
    return result;
  }

  CommunitySearchResult._();

  factory CommunitySearchResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunitySearchResult()..mergeFromBuffer(data, registry);
  factory CommunitySearchResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunitySearchResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunitySearchResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunitySearchResult.$_createMessage)
    ..aE<CommunitySearchKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: CommunitySearchKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'parentId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'snippet')
    ..aOS(6, _omitFieldNames ? '' : 'authorId')
    ..aOS(7, _omitFieldNames ? '' : 'authorName')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(9, _omitFieldNames ? '' : 'sequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunitySearchResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunitySearchResult copyWith(
          void Function(CommunitySearchResult) updates) =>
      super.copyWith((message) => updates(message as CommunitySearchResult))
          as CommunitySearchResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommunitySearchResult() / CommunitySearchResult.new instead')
  static CommunitySearchResult create() => CommunitySearchResult._();
  static $pb.GeneratedMessage $_createMessage() => CommunitySearchResult._();
  @$core.override
  CommunitySearchResult createEmptyInstance() => CommunitySearchResult._();
  @$core.pragma('dart2js:noInline')
  static CommunitySearchResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommunitySearchResult>(
          CommunitySearchResult.$_createMessage);
  static CommunitySearchResult? _defaultInstance;

  @$pb.TagNumber(1)
  CommunitySearchKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(CommunitySearchKind value) => $_setField(1, value);
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

  /// ID темы/публикации; для корневого результата совпадает с id.
  @$pb.TagNumber(3)
  $core.String get parentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  /// Обычный текст до 240 Unicode code points; не HTML/Markdown.
  @$pb.TagNumber(5)
  $core.String get snippet => $_getSZ(4);
  @$pb.TagNumber(5)
  set snippet($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSnippet() => $_has(4);
  @$pb.TagNumber(5)
  void clearSnippet() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get authorId => $_getSZ(5);
  @$pb.TagNumber(6)
  set authorId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAuthorId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthorId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get authorName => $_getSZ(6);
  @$pb.TagNumber(7)
  set authorName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthorName() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthorName() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAtUnix => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAtUnix() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAtUnix() => $_clearField(8);

  /// Порядок ответа/комментария для перехода непосредственно к результату.
  @$pb.TagNumber(9)
  $fixnum.Int64 get sequence => $_getI64(8);
  @$pb.TagNumber(9)
  set sequence($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSequence() => $_has(8);
  @$pb.TagNumber(9)
  void clearSequence() => $_clearField(9);
}

class SearchCommunityContentResponse extends $pb.GeneratedMessage {
  factory SearchCommunityContentResponse({
    $core.Iterable<CommunitySearchResult>? results,
    $core.String? nextPageToken,
  }) {
    final result = SearchCommunityContentResponse._();
    if (results != null) result.results.addAll(results);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  SearchCommunityContentResponse._();

  factory SearchCommunityContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchCommunityContentResponse()..mergeFromBuffer(data, registry);
  factory SearchCommunityContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchCommunityContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchCommunityContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SearchCommunityContentResponse.$_createMessage)
    ..pPM<CommunitySearchResult>(1, _omitFieldNames ? '' : 'results',
        subBuilder: CommunitySearchResult.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchCommunityContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchCommunityContentResponse copyWith(
          void Function(SearchCommunityContentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SearchCommunityContentResponse))
          as SearchCommunityContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SearchCommunityContentResponse() / SearchCommunityContentResponse.new instead')
  static SearchCommunityContentResponse create() =>
      SearchCommunityContentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SearchCommunityContentResponse._();
  @$core.override
  SearchCommunityContentResponse createEmptyInstance() =>
      SearchCommunityContentResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchCommunityContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchCommunityContentResponse>(
          SearchCommunityContentResponse.$_createMessage);
  static SearchCommunityContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommunitySearchResult> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

/// core.community.search.v1: только выбранный открытый forum/feed раздел.
class CommunitySearchServiceApi {
  final $pb.RpcClient _client;

  CommunitySearchServiceApi(this._client);

  $async.Future<SearchCommunityContentResponse> searchCommunityContent(
          $pb.ClientContext? ctx, SearchCommunityContentRequest request) =>
      _client.invoke<SearchCommunityContentResponse>(
          ctx,
          'CommunitySearchService',
          'SearchCommunityContent',
          request,
          SearchCommunityContentResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
