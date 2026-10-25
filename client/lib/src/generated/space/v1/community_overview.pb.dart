// This is a generated file - do not edit.
//
// Generated from space/v1/community_overview.proto.

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

import 'community_search.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetCommunityOverviewRequest extends $pb.GeneratedMessage {
  factory GetCommunityOverviewRequest({
    $core.String? channelId,
    $core.int? limit,
  }) {
    final result = GetCommunityOverviewRequest._();
    if (channelId != null) result.channelId = channelId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetCommunityOverviewRequest._();

  factory GetCommunityOverviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityOverviewRequest()..mergeFromBuffer(data, registry);
  factory GetCommunityOverviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityOverviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCommunityOverviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetCommunityOverviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityOverviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityOverviewRequest copyWith(
          void Function(GetCommunityOverviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCommunityOverviewRequest))
          as GetCommunityOverviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCommunityOverviewRequest() / GetCommunityOverviewRequest.new instead')
  static GetCommunityOverviewRequest create() =>
      GetCommunityOverviewRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCommunityOverviewRequest._();
  @$core.override
  GetCommunityOverviewRequest createEmptyInstance() =>
      GetCommunityOverviewRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCommunityOverviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCommunityOverviewRequest>(
          GetCommunityOverviewRequest.$_createMessage);
  static GetCommunityOverviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class CommunityOverviewEntry extends $pb.GeneratedMessage {
  factory CommunityOverviewEntry({
    $0.CommunitySearchResult? content,
    $fixnum.Int64? unreadCount,
    $core.bool? readStateSupported,
    $fixnum.Int64? unreadRepliesToYou,
    $fixnum.Int64? firstUnreadReplySequence,
  }) {
    final result = CommunityOverviewEntry._();
    if (content != null) result.content = content;
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (readStateSupported != null)
      result.readStateSupported = readStateSupported;
    if (unreadRepliesToYou != null)
      result.unreadRepliesToYou = unreadRepliesToYou;
    if (firstUnreadReplySequence != null)
      result.firstUnreadReplySequence = firstUnreadReplySequence;
    return result;
  }

  CommunityOverviewEntry._();

  factory CommunityOverviewEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityOverviewEntry()..mergeFromBuffer(data, registry);
  factory CommunityOverviewEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityOverviewEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunityOverviewEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunityOverviewEntry.$_createMessage)
    ..aOM<$0.CommunitySearchResult>(1, _omitFieldNames ? '' : 'content',
        subBuilder: $0.CommunitySearchResult.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'unreadCount')
    ..aOB(3, _omitFieldNames ? '' : 'readStateSupported')
    ..aInt64(4, _omitFieldNames ? '' : 'unreadRepliesToYou')
    ..aInt64(5, _omitFieldNames ? '' : 'firstUnreadReplySequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityOverviewEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityOverviewEntry copyWith(
          void Function(CommunityOverviewEntry) updates) =>
      super.copyWith((message) => updates(message as CommunityOverviewEntry))
          as CommunityOverviewEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommunityOverviewEntry() / CommunityOverviewEntry.new instead')
  static CommunityOverviewEntry create() => CommunityOverviewEntry._();
  static $pb.GeneratedMessage $_createMessage() => CommunityOverviewEntry._();
  @$core.override
  CommunityOverviewEntry createEmptyInstance() => CommunityOverviewEntry._();
  @$core.pragma('dart2js:noInline')
  static CommunityOverviewEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommunityOverviewEntry>(
          CommunityOverviewEntry.$_createMessage);
  static CommunityOverviewEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CommunitySearchResult get content => $_getN(0);
  @$pb.TagNumber(1)
  set content($0.CommunitySearchResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.CommunitySearchResult ensureContent() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get unreadCount => $_getI64(1);
  @$pb.TagNumber(2)
  set unreadCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnreadCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnreadCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get readStateSupported => $_getBF(2);
  @$pb.TagNumber(3)
  set readStateSupported($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReadStateSupported() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadStateSupported() => $_clearField(3);

  /// Видимые непрочитанные ответы других участников автору темы.
  @$pb.TagNumber(4)
  $fixnum.Int64 get unreadRepliesToYou => $_getI64(3);
  @$pb.TagNumber(4)
  set unreadRepliesToYou($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreadRepliesToYou() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadRepliesToYou() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get firstUnreadReplySequence => $_getI64(4);
  @$pb.TagNumber(5)
  set firstUnreadReplySequence($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFirstUnreadReplySequence() => $_has(4);
  @$pb.TagNumber(5)
  void clearFirstUnreadReplySequence() => $_clearField(5);
}

class GetCommunityOverviewResponse extends $pb.GeneratedMessage {
  factory GetCommunityOverviewResponse({
    $core.Iterable<CommunityOverviewEntry>? recent,
    $core.Iterable<CommunityOverviewEntry>? repliesToYou,
    $fixnum.Int64? pendingReports,
    $core.bool? canModerate,
    $core.Iterable<CommunityOverviewEntry>? mentions,
  }) {
    final result = GetCommunityOverviewResponse._();
    if (recent != null) result.recent.addAll(recent);
    if (repliesToYou != null) result.repliesToYou.addAll(repliesToYou);
    if (pendingReports != null) result.pendingReports = pendingReports;
    if (canModerate != null) result.canModerate = canModerate;
    if (mentions != null) result.mentions.addAll(mentions);
    return result;
  }

  GetCommunityOverviewResponse._();

  factory GetCommunityOverviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityOverviewResponse()..mergeFromBuffer(data, registry);
  factory GetCommunityOverviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCommunityOverviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCommunityOverviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetCommunityOverviewResponse.$_createMessage)
    ..pPM<CommunityOverviewEntry>(1, _omitFieldNames ? '' : 'recent',
        subBuilder: CommunityOverviewEntry.$_createMessage)
    ..pPM<CommunityOverviewEntry>(2, _omitFieldNames ? '' : 'repliesToYou',
        subBuilder: CommunityOverviewEntry.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'pendingReports')
    ..aOB(4, _omitFieldNames ? '' : 'canModerate')
    ..pPM<CommunityOverviewEntry>(5, _omitFieldNames ? '' : 'mentions',
        subBuilder: CommunityOverviewEntry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityOverviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCommunityOverviewResponse copyWith(
          void Function(GetCommunityOverviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetCommunityOverviewResponse))
          as GetCommunityOverviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCommunityOverviewResponse() / GetCommunityOverviewResponse.new instead')
  static GetCommunityOverviewResponse create() =>
      GetCommunityOverviewResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCommunityOverviewResponse._();
  @$core.override
  GetCommunityOverviewResponse createEmptyInstance() =>
      GetCommunityOverviewResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCommunityOverviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCommunityOverviewResponse>(
          GetCommunityOverviewResponse.$_createMessage);
  static GetCommunityOverviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommunityOverviewEntry> get recent => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<CommunityOverviewEntry> get repliesToYou => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get pendingReports => $_getI64(2);
  @$pb.TagNumber(3)
  set pendingReports($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPendingReports() => $_has(2);
  @$pb.TagNumber(3)
  void clearPendingReports() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get canModerate => $_getBF(3);
  @$pb.TagNumber(4)
  set canModerate($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanModerate() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanModerate() => $_clearField(4);

  /// Непросмотренные упоминания текущего principal; не включает скрытые объекты.
  @$pb.TagNumber(5)
  $pb.PbList<CommunityOverviewEntry> get mentions => $_getList(4);
}

/// core.community.overview.v1: персональная сводка одного доступного раздела.
class CommunityOverviewServiceApi {
  final $pb.RpcClient _client;

  CommunityOverviewServiceApi(this._client);

  $async.Future<GetCommunityOverviewResponse> getCommunityOverview(
          $pb.ClientContext? ctx, GetCommunityOverviewRequest request) =>
      _client.invoke<GetCommunityOverviewResponse>(
          ctx,
          'CommunityOverviewService',
          'GetCommunityOverview',
          request,
          GetCommunityOverviewResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
