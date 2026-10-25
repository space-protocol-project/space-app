// This is a generated file - do not edit.
//
// Generated from space/v1/personal_notifications.proto.

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

import 'personal_notifications.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'personal_notifications.pbenum.dart';

class PersonalNotification extends $pb.GeneratedMessage {
  factory PersonalNotification({
    $core.String? id,
    $fixnum.Int64? sequence,
    $core.String? channelId,
    NotificationTargetKind? targetKind,
    $core.String? contentId,
    $core.String? parentId,
    $fixnum.Int64? targetSequence,
    $core.String? authorId,
    $core.String? authorName,
    $core.String? title,
    $core.String? snippet,
    $core.int? reasons,
    $core.int? unreadReasons,
    $fixnum.Int64? createdAtUnix,
  }) {
    final result = PersonalNotification._();
    if (id != null) result.id = id;
    if (sequence != null) result.sequence = sequence;
    if (channelId != null) result.channelId = channelId;
    if (targetKind != null) result.targetKind = targetKind;
    if (contentId != null) result.contentId = contentId;
    if (parentId != null) result.parentId = parentId;
    if (targetSequence != null) result.targetSequence = targetSequence;
    if (authorId != null) result.authorId = authorId;
    if (authorName != null) result.authorName = authorName;
    if (title != null) result.title = title;
    if (snippet != null) result.snippet = snippet;
    if (reasons != null) result.reasons = reasons;
    if (unreadReasons != null) result.unreadReasons = unreadReasons;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    return result;
  }

  PersonalNotification._();

  factory PersonalNotification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PersonalNotification()..mergeFromBuffer(data, registry);
  factory PersonalNotification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PersonalNotification()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PersonalNotification',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PersonalNotification.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'sequence')
    ..aOS(3, _omitFieldNames ? '' : 'channelId')
    ..aE<NotificationTargetKind>(4, _omitFieldNames ? '' : 'targetKind',
        enumValues: NotificationTargetKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'contentId')
    ..aOS(6, _omitFieldNames ? '' : 'parentId')
    ..aInt64(7, _omitFieldNames ? '' : 'targetSequence')
    ..aOS(8, _omitFieldNames ? '' : 'authorId')
    ..aOS(9, _omitFieldNames ? '' : 'authorName')
    ..aOS(10, _omitFieldNames ? '' : 'title')
    ..aOS(11, _omitFieldNames ? '' : 'snippet')
    ..aI(12, _omitFieldNames ? '' : 'reasons')
    ..aI(13, _omitFieldNames ? '' : 'unreadReasons')
    ..aInt64(14, _omitFieldNames ? '' : 'createdAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PersonalNotification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PersonalNotification copyWith(void Function(PersonalNotification) updates) =>
      super.copyWith((message) => updates(message as PersonalNotification))
          as PersonalNotification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PersonalNotification() / PersonalNotification.new instead')
  static PersonalNotification create() => PersonalNotification._();
  static $pb.GeneratedMessage $_createMessage() => PersonalNotification._();
  @$core.override
  PersonalNotification createEmptyInstance() => PersonalNotification._();
  @$core.pragma('dart2js:noInline')
  static PersonalNotification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PersonalNotification>(
          PersonalNotification.$_createMessage);
  static PersonalNotification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sequence => $_getI64(1);
  @$pb.TagNumber(2)
  set sequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get channelId => $_getSZ(2);
  @$pb.TagNumber(3)
  set channelId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelId() => $_clearField(3);

  @$pb.TagNumber(4)
  NotificationTargetKind get targetKind => $_getN(3);
  @$pb.TagNumber(4)
  set targetKind(NotificationTargetKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentId => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get parentId => $_getSZ(5);
  @$pb.TagNumber(6)
  set parentId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParentId() => $_has(5);
  @$pb.TagNumber(6)
  void clearParentId() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get targetSequence => $_getI64(6);
  @$pb.TagNumber(7)
  set targetSequence($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetSequence() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetSequence() => $_clearField(7);

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
  $core.String get title => $_getSZ(9);
  @$pb.TagNumber(10)
  set title($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTitle() => $_has(9);
  @$pb.TagNumber(10)
  void clearTitle() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get snippet => $_getSZ(10);
  @$pb.TagNumber(11)
  set snippet($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSnippet() => $_has(10);
  @$pb.TagNumber(11)
  void clearSnippet() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get reasons => $_getIZ(11);
  @$pb.TagNumber(12)
  set reasons($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReasons() => $_has(11);
  @$pb.TagNumber(12)
  void clearReasons() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get unreadReasons => $_getIZ(12);
  @$pb.TagNumber(13)
  set unreadReasons($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUnreadReasons() => $_has(12);
  @$pb.TagNumber(13)
  void clearUnreadReasons() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get createdAtUnix => $_getI64(13);
  @$pb.TagNumber(14)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAtUnix() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAtUnix() => $_clearField(14);
}

class ListPersonalNotificationsRequest extends $pb.GeneratedMessage {
  factory ListPersonalNotificationsRequest({
    $core.String? channelId,
    $fixnum.Int64? afterSequence,
    $fixnum.Int64? throughSequence,
    $core.bool? unreadOnly,
    $core.int? limit,
    $core.bool? baselineOnly,
  }) {
    final result = ListPersonalNotificationsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (afterSequence != null) result.afterSequence = afterSequence;
    if (throughSequence != null) result.throughSequence = throughSequence;
    if (unreadOnly != null) result.unreadOnly = unreadOnly;
    if (limit != null) result.limit = limit;
    if (baselineOnly != null) result.baselineOnly = baselineOnly;
    return result;
  }

  ListPersonalNotificationsRequest._();

  factory ListPersonalNotificationsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalNotificationsRequest()..mergeFromBuffer(data, registry);
  factory ListPersonalNotificationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalNotificationsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPersonalNotificationsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListPersonalNotificationsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'afterSequence')
    ..aInt64(3, _omitFieldNames ? '' : 'throughSequence')
    ..aOB(4, _omitFieldNames ? '' : 'unreadOnly')
    ..aI(5, _omitFieldNames ? '' : 'limit')
    ..aOB(6, _omitFieldNames ? '' : 'baselineOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalNotificationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalNotificationsRequest copyWith(
          void Function(ListPersonalNotificationsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPersonalNotificationsRequest))
          as ListPersonalNotificationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPersonalNotificationsRequest() / ListPersonalNotificationsRequest.new instead')
  static ListPersonalNotificationsRequest create() =>
      ListPersonalNotificationsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListPersonalNotificationsRequest._();
  @$core.override
  ListPersonalNotificationsRequest createEmptyInstance() =>
      ListPersonalNotificationsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPersonalNotificationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPersonalNotificationsRequest>(
          ListPersonalNotificationsRequest.$_createMessage);
  static ListPersonalNotificationsRequest? _defaultInstance;

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

  @$pb.TagNumber(3)
  $fixnum.Int64 get throughSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set throughSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThroughSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearThroughSequence() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get unreadOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set unreadOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreadOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get limit => $_getIZ(4);
  @$pb.TagNumber(5)
  set limit($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLimit() => $_has(4);
  @$pb.TagNumber(5)
  void clearLimit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get baselineOnly => $_getBF(5);
  @$pb.TagNumber(6)
  set baselineOnly($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBaselineOnly() => $_has(5);
  @$pb.TagNumber(6)
  void clearBaselineOnly() => $_clearField(6);
}

class ListPersonalNotificationsResponse extends $pb.GeneratedMessage {
  factory ListPersonalNotificationsResponse({
    $core.Iterable<PersonalNotification>? notifications,
    $fixnum.Int64? nextSequence,
    $fixnum.Int64? throughSequence,
    $core.bool? hasMore,
  }) {
    final result = ListPersonalNotificationsResponse._();
    if (notifications != null) result.notifications.addAll(notifications);
    if (nextSequence != null) result.nextSequence = nextSequence;
    if (throughSequence != null) result.throughSequence = throughSequence;
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  ListPersonalNotificationsResponse._();

  factory ListPersonalNotificationsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalNotificationsResponse()..mergeFromBuffer(data, registry);
  factory ListPersonalNotificationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPersonalNotificationsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPersonalNotificationsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListPersonalNotificationsResponse.$_createMessage)
    ..pPM<PersonalNotification>(1, _omitFieldNames ? '' : 'notifications',
        subBuilder: PersonalNotification.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextSequence')
    ..aInt64(3, _omitFieldNames ? '' : 'throughSequence')
    ..aOB(4, _omitFieldNames ? '' : 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalNotificationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPersonalNotificationsResponse copyWith(
          void Function(ListPersonalNotificationsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListPersonalNotificationsResponse))
          as ListPersonalNotificationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPersonalNotificationsResponse() / ListPersonalNotificationsResponse.new instead')
  static ListPersonalNotificationsResponse create() =>
      ListPersonalNotificationsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListPersonalNotificationsResponse._();
  @$core.override
  ListPersonalNotificationsResponse createEmptyInstance() =>
      ListPersonalNotificationsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPersonalNotificationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPersonalNotificationsResponse>(
          ListPersonalNotificationsResponse.$_createMessage);
  static ListPersonalNotificationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PersonalNotification> get notifications => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set nextSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get throughSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set throughSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThroughSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearThroughSequence() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasMore => $_getBF(3);
  @$pb.TagNumber(4)
  set hasMore($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasMore() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasMore() => $_clearField(4);
}

class MarkPersonalNotificationsReadRequest extends $pb.GeneratedMessage {
  factory MarkPersonalNotificationsReadRequest({
    $core.String? channelId,
    $core.Iterable<$core.String>? ids,
    $core.Iterable<$core.String>? chatContentIds,
  }) {
    final result = MarkPersonalNotificationsReadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (ids != null) result.ids.addAll(ids);
    if (chatContentIds != null) result.chatContentIds.addAll(chatContentIds);
    return result;
  }

  MarkPersonalNotificationsReadRequest._();

  factory MarkPersonalNotificationsReadRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkPersonalNotificationsReadRequest()..mergeFromBuffer(data, registry);
  factory MarkPersonalNotificationsReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkPersonalNotificationsReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkPersonalNotificationsReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MarkPersonalNotificationsReadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..pPS(2, _omitFieldNames ? '' : 'ids')
    ..pPS(3, _omitFieldNames ? '' : 'chatContentIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkPersonalNotificationsReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkPersonalNotificationsReadRequest copyWith(
          void Function(MarkPersonalNotificationsReadRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MarkPersonalNotificationsReadRequest))
          as MarkPersonalNotificationsReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkPersonalNotificationsReadRequest() / MarkPersonalNotificationsReadRequest.new instead')
  static MarkPersonalNotificationsReadRequest create() =>
      MarkPersonalNotificationsReadRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkPersonalNotificationsReadRequest._();
  @$core.override
  MarkPersonalNotificationsReadRequest createEmptyInstance() =>
      MarkPersonalNotificationsReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkPersonalNotificationsReadRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MarkPersonalNotificationsReadRequest>(
          MarkPersonalNotificationsReadRequest.$_createMessage);
  static MarkPersonalNotificationsReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get ids => $_getList(1);

  /// Альтернатива ids для реально видимых сообщений обычного чата. Только
  /// выбранные упоминания текущего получателя; оба списка вместе запрещены.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get chatContentIds => $_getList(2);
}

class MarkPersonalNotificationsReadResponse extends $pb.GeneratedMessage {
  factory MarkPersonalNotificationsReadResponse() =>
      MarkPersonalNotificationsReadResponse._();

  MarkPersonalNotificationsReadResponse._();

  factory MarkPersonalNotificationsReadResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkPersonalNotificationsReadResponse()..mergeFromBuffer(data, registry);
  factory MarkPersonalNotificationsReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkPersonalNotificationsReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkPersonalNotificationsReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance:
          MarkPersonalNotificationsReadResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkPersonalNotificationsReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkPersonalNotificationsReadResponse copyWith(
          void Function(MarkPersonalNotificationsReadResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MarkPersonalNotificationsReadResponse))
          as MarkPersonalNotificationsReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkPersonalNotificationsReadResponse() / MarkPersonalNotificationsReadResponse.new instead')
  static MarkPersonalNotificationsReadResponse create() =>
      MarkPersonalNotificationsReadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkPersonalNotificationsReadResponse._();
  @$core.override
  MarkPersonalNotificationsReadResponse createEmptyInstance() =>
      MarkPersonalNotificationsReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkPersonalNotificationsReadResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MarkPersonalNotificationsReadResponse>(
          MarkPersonalNotificationsReadResponse.$_createMessage);
  static MarkPersonalNotificationsReadResponse? _defaultInstance;
}

/// core.personal.notifications.v1: только записи текущей личности в выбранном разделе.
class PersonalNotificationServiceApi {
  final $pb.RpcClient _client;

  PersonalNotificationServiceApi(this._client);

  $async.Future<ListPersonalNotificationsResponse> listPersonalNotifications(
          $pb.ClientContext? ctx, ListPersonalNotificationsRequest request) =>
      _client.invoke<ListPersonalNotificationsResponse>(
          ctx,
          'PersonalNotificationService',
          'ListPersonalNotifications',
          request,
          ListPersonalNotificationsResponse());
  $async.Future<MarkPersonalNotificationsReadResponse>
      markPersonalNotificationsRead($pb.ClientContext? ctx,
              MarkPersonalNotificationsReadRequest request) =>
          _client.invoke<MarkPersonalNotificationsReadResponse>(
              ctx,
              'PersonalNotificationService',
              'MarkPersonalNotificationsRead',
              request,
              MarkPersonalNotificationsReadResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
