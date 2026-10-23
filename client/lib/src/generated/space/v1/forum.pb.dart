// This is a generated file - do not edit.
//
// Generated from space/v1/forum.proto.

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

import 'space.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ForumThread extends $pb.GeneratedMessage {
  factory ForumThread({
    $core.String? id,
    $core.String? channelId,
    $core.String? authorId,
    $core.String? authorName,
    $core.String? title,
    $core.String? text,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? sequence,
    $fixnum.Int64? revision,
    $core.bool? closed,
    $fixnum.Int64? replyCount,
    $core.Iterable<$0.Asset>? attachments,
    $core.bool? pinned,
    $core.bool? readStateSupported,
    $core.bool? seen,
    $fixnum.Int64? readSequence,
    $fixnum.Int64? unreadCount,
    $core.bool? hidden,
  }) {
    final result = ForumThread._();
    if (id != null) result.id = id;
    if (channelId != null) result.channelId = channelId;
    if (authorId != null) result.authorId = authorId;
    if (authorName != null) result.authorName = authorName;
    if (title != null) result.title = title;
    if (text != null) result.text = text;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (sequence != null) result.sequence = sequence;
    if (revision != null) result.revision = revision;
    if (closed != null) result.closed = closed;
    if (replyCount != null) result.replyCount = replyCount;
    if (attachments != null) result.attachments.addAll(attachments);
    if (pinned != null) result.pinned = pinned;
    if (readStateSupported != null)
      result.readStateSupported = readStateSupported;
    if (seen != null) result.seen = seen;
    if (readSequence != null) result.readSequence = readSequence;
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (hidden != null) result.hidden = hidden;
    return result;
  }

  ForumThread._();

  factory ForumThread.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForumThread()..mergeFromBuffer(data, registry);
  factory ForumThread.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForumThread()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForumThread',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ForumThread.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'channelId')
    ..aOS(3, _omitFieldNames ? '' : 'authorId')
    ..aOS(4, _omitFieldNames ? '' : 'authorName')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'text')
    ..aInt64(7, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(8, _omitFieldNames ? '' : 'sequence')
    ..aInt64(9, _omitFieldNames ? '' : 'revision')
    ..aOB(10, _omitFieldNames ? '' : 'closed')
    ..aInt64(11, _omitFieldNames ? '' : 'replyCount')
    ..pPM<$0.Asset>(12, _omitFieldNames ? '' : 'attachments',
        subBuilder: $0.Asset.$_createMessage)
    ..aOB(13, _omitFieldNames ? '' : 'pinned')
    ..aOB(14, _omitFieldNames ? '' : 'readStateSupported')
    ..aOB(15, _omitFieldNames ? '' : 'seen')
    ..aInt64(16, _omitFieldNames ? '' : 'readSequence')
    ..aInt64(17, _omitFieldNames ? '' : 'unreadCount')
    ..aOB(18, _omitFieldNames ? '' : 'hidden')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForumThread clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForumThread copyWith(void Function(ForumThread) updates) =>
      super.copyWith((message) => updates(message as ForumThread))
          as ForumThread;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ForumThread() / ForumThread.new instead')
  static ForumThread create() => ForumThread._();
  static $pb.GeneratedMessage $_createMessage() => ForumThread._();
  @$core.override
  ForumThread createEmptyInstance() => ForumThread._();
  @$core.pragma('dart2js:noInline')
  static ForumThread getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ForumThread>(
          ForumThread.$_createMessage);
  static ForumThread? _defaultInstance;

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
  $core.String get authorName => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorName() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get text => $_getSZ(5);
  @$pb.TagNumber(6)
  set text($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasText() => $_has(5);
  @$pb.TagNumber(6)
  void clearText() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAtUnix => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAtUnix() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAtUnix() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get sequence => $_getI64(7);
  @$pb.TagNumber(8)
  set sequence($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSequence() => $_has(7);
  @$pb.TagNumber(8)
  void clearSequence() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get revision => $_getI64(8);
  @$pb.TagNumber(9)
  set revision($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRevision() => $_has(8);
  @$pb.TagNumber(9)
  void clearRevision() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get closed => $_getBF(9);
  @$pb.TagNumber(10)
  set closed($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClosed() => $_has(9);
  @$pb.TagNumber(10)
  void clearClosed() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get replyCount => $_getI64(10);
  @$pb.TagNumber(11)
  set replyCount($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReplyCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearReplyCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$0.Asset> get attachments => $_getList(11);

  @$pb.TagNumber(13)
  $core.bool get pinned => $_getBF(12);
  @$pb.TagNumber(13)
  set pinned($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPinned() => $_has(12);
  @$pb.TagNumber(13)
  void clearPinned() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get readStateSupported => $_getBF(13);
  @$pb.TagNumber(14)
  set readStateSupported($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasReadStateSupported() => $_has(13);
  @$pb.TagNumber(14)
  void clearReadStateSupported() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get seen => $_getBF(14);
  @$pb.TagNumber(15)
  set seen($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSeen() => $_has(14);
  @$pb.TagNumber(15)
  void clearSeen() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get readSequence => $_getI64(15);
  @$pb.TagNumber(16)
  set readSequence($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasReadSequence() => $_has(15);
  @$pb.TagNumber(16)
  void clearReadSequence() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get unreadCount => $_getI64(16);
  @$pb.TagNumber(17)
  set unreadCount($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasUnreadCount() => $_has(16);
  @$pb.TagNumber(17)
  void clearUnreadCount() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get hidden => $_getBF(17);
  @$pb.TagNumber(18)
  set hidden($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasHidden() => $_has(17);
  @$pb.TagNumber(18)
  void clearHidden() => $_clearField(18);
}

class ForumReply extends $pb.GeneratedMessage {
  factory ForumReply({
    $core.String? id,
    $core.String? threadId,
    $core.String? authorId,
    $core.String? authorName,
    $core.String? text,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? sequence,
    $core.Iterable<$0.Asset>? attachments,
    $core.bool? hidden,
    $fixnum.Int64? revision,
  }) {
    final result = ForumReply._();
    if (id != null) result.id = id;
    if (threadId != null) result.threadId = threadId;
    if (authorId != null) result.authorId = authorId;
    if (authorName != null) result.authorName = authorName;
    if (text != null) result.text = text;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (sequence != null) result.sequence = sequence;
    if (attachments != null) result.attachments.addAll(attachments);
    if (hidden != null) result.hidden = hidden;
    if (revision != null) result.revision = revision;
    return result;
  }

  ForumReply._();

  factory ForumReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForumReply()..mergeFromBuffer(data, registry);
  factory ForumReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForumReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForumReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ForumReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'authorId')
    ..aOS(4, _omitFieldNames ? '' : 'authorName')
    ..aOS(5, _omitFieldNames ? '' : 'text')
    ..aInt64(6, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(7, _omitFieldNames ? '' : 'sequence')
    ..pPM<$0.Asset>(8, _omitFieldNames ? '' : 'attachments',
        subBuilder: $0.Asset.$_createMessage)
    ..aOB(9, _omitFieldNames ? '' : 'hidden')
    ..aInt64(10, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForumReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForumReply copyWith(void Function(ForumReply) updates) =>
      super.copyWith((message) => updates(message as ForumReply)) as ForumReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ForumReply() / ForumReply.new instead')
  static ForumReply create() => ForumReply._();
  static $pb.GeneratedMessage $_createMessage() => ForumReply._();
  @$core.override
  ForumReply createEmptyInstance() => ForumReply._();
  @$core.pragma('dart2js:noInline')
  static ForumReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForumReply>(ForumReply.$_createMessage);
  static ForumReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get authorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authorName => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorName() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get text => $_getSZ(4);
  @$pb.TagNumber(5)
  set text($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasText() => $_has(4);
  @$pb.TagNumber(5)
  void clearText() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAtUnix => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAtUnix() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAtUnix() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get sequence => $_getI64(6);
  @$pb.TagNumber(7)
  set sequence($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSequence() => $_has(6);
  @$pb.TagNumber(7)
  void clearSequence() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$0.Asset> get attachments => $_getList(7);

  @$pb.TagNumber(9)
  $core.bool get hidden => $_getBF(8);
  @$pb.TagNumber(9)
  set hidden($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHidden() => $_has(8);
  @$pb.TagNumber(9)
  void clearHidden() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get revision => $_getI64(9);
  @$pb.TagNumber(10)
  set revision($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRevision() => $_has(9);
  @$pb.TagNumber(10)
  void clearRevision() => $_clearField(10);
}

/// Курсоры — sequence последней записи; 0 начинает чтение, limit 1..50 (0 = 50).
class ListForumThreadsRequest extends $pb.GeneratedMessage {
  factory ListForumThreadsRequest({
    $core.String? channelId,
    $fixnum.Int64? afterSequence,
    $core.int? limit,
    $core.bool? pinnedFirst,
    $core.bool? afterPinned,
  }) {
    final result = ListForumThreadsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (afterSequence != null) result.afterSequence = afterSequence;
    if (limit != null) result.limit = limit;
    if (pinnedFirst != null) result.pinnedFirst = pinnedFirst;
    if (afterPinned != null) result.afterPinned = afterPinned;
    return result;
  }

  ListForumThreadsRequest._();

  factory ListForumThreadsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumThreadsRequest()..mergeFromBuffer(data, registry);
  factory ListForumThreadsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumThreadsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListForumThreadsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListForumThreadsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'afterSequence')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aOB(4, _omitFieldNames ? '' : 'pinnedFirst')
    ..aOB(5, _omitFieldNames ? '' : 'afterPinned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumThreadsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumThreadsRequest copyWith(
          void Function(ListForumThreadsRequest) updates) =>
      super.copyWith((message) => updates(message as ListForumThreadsRequest))
          as ListForumThreadsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListForumThreadsRequest() / ListForumThreadsRequest.new instead')
  static ListForumThreadsRequest create() => ListForumThreadsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListForumThreadsRequest._();
  @$core.override
  ListForumThreadsRequest createEmptyInstance() => ListForumThreadsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListForumThreadsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListForumThreadsRequest>(
          ListForumThreadsRequest.$_createMessage);
  static ListForumThreadsRequest? _defaultInstance;

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
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get pinnedFirst => $_getBF(3);
  @$pb.TagNumber(4)
  set pinnedFirst($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPinnedFirst() => $_has(3);
  @$pb.TagNumber(4)
  void clearPinnedFirst() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get afterPinned => $_getBF(4);
  @$pb.TagNumber(5)
  set afterPinned($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAfterPinned() => $_has(4);
  @$pb.TagNumber(5)
  void clearAfterPinned() => $_clearField(5);
}

class ListForumThreadsResponse extends $pb.GeneratedMessage {
  factory ListForumThreadsResponse({
    $core.Iterable<ForumThread>? threads,
    $fixnum.Int64? nextSequence,
    $core.bool? nextPinned,
  }) {
    final result = ListForumThreadsResponse._();
    if (threads != null) result.threads.addAll(threads);
    if (nextSequence != null) result.nextSequence = nextSequence;
    if (nextPinned != null) result.nextPinned = nextPinned;
    return result;
  }

  ListForumThreadsResponse._();

  factory ListForumThreadsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumThreadsResponse()..mergeFromBuffer(data, registry);
  factory ListForumThreadsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumThreadsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListForumThreadsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListForumThreadsResponse.$_createMessage)
    ..pPM<ForumThread>(1, _omitFieldNames ? '' : 'threads',
        subBuilder: ForumThread.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextSequence')
    ..aOB(3, _omitFieldNames ? '' : 'nextPinned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumThreadsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumThreadsResponse copyWith(
          void Function(ListForumThreadsResponse) updates) =>
      super.copyWith((message) => updates(message as ListForumThreadsResponse))
          as ListForumThreadsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListForumThreadsResponse() / ListForumThreadsResponse.new instead')
  static ListForumThreadsResponse create() => ListForumThreadsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListForumThreadsResponse._();
  @$core.override
  ListForumThreadsResponse createEmptyInstance() =>
      ListForumThreadsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListForumThreadsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListForumThreadsResponse>(
          ListForumThreadsResponse.$_createMessage);
  static ListForumThreadsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ForumThread> get threads => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set nextSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get nextPinned => $_getBF(2);
  @$pb.TagNumber(3)
  set nextPinned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextPinned() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextPinned() => $_clearField(3);
}

class GetForumThreadRequest extends $pb.GeneratedMessage {
  factory GetForumThreadRequest({
    $core.String? channelId,
    $core.String? threadId,
    $fixnum.Int64? afterSequence,
    $core.int? limit,
  }) {
    final result = GetForumThreadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (afterSequence != null) result.afterSequence = afterSequence;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetForumThreadRequest._();

  factory GetForumThreadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetForumThreadRequest()..mergeFromBuffer(data, registry);
  factory GetForumThreadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetForumThreadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetForumThreadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetForumThreadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aInt64(3, _omitFieldNames ? '' : 'afterSequence')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetForumThreadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetForumThreadRequest copyWith(
          void Function(GetForumThreadRequest) updates) =>
      super.copyWith((message) => updates(message as GetForumThreadRequest))
          as GetForumThreadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetForumThreadRequest() / GetForumThreadRequest.new instead')
  static GetForumThreadRequest create() => GetForumThreadRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetForumThreadRequest._();
  @$core.override
  GetForumThreadRequest createEmptyInstance() => GetForumThreadRequest._();
  @$core.pragma('dart2js:noInline')
  static GetForumThreadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetForumThreadRequest>(
          GetForumThreadRequest.$_createMessage);
  static GetForumThreadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get afterSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set afterSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterSequence() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

class GetForumThreadResponse extends $pb.GeneratedMessage {
  factory GetForumThreadResponse({
    ForumThread? thread,
    $core.Iterable<ForumReply>? replies,
    $fixnum.Int64? nextSequence,
  }) {
    final result = GetForumThreadResponse._();
    if (thread != null) result.thread = thread;
    if (replies != null) result.replies.addAll(replies);
    if (nextSequence != null) result.nextSequence = nextSequence;
    return result;
  }

  GetForumThreadResponse._();

  factory GetForumThreadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetForumThreadResponse()..mergeFromBuffer(data, registry);
  factory GetForumThreadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetForumThreadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetForumThreadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetForumThreadResponse.$_createMessage)
    ..aOM<ForumThread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..pPM<ForumReply>(2, _omitFieldNames ? '' : 'replies',
        subBuilder: ForumReply.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'nextSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetForumThreadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetForumThreadResponse copyWith(
          void Function(GetForumThreadResponse) updates) =>
      super.copyWith((message) => updates(message as GetForumThreadResponse))
          as GetForumThreadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetForumThreadResponse() / GetForumThreadResponse.new instead')
  static GetForumThreadResponse create() => GetForumThreadResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetForumThreadResponse._();
  @$core.override
  GetForumThreadResponse createEmptyInstance() => GetForumThreadResponse._();
  @$core.pragma('dart2js:noInline')
  static GetForumThreadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetForumThreadResponse>(
          GetForumThreadResponse.$_createMessage);
  static GetForumThreadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumThread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(ForumThread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumThread ensureThread() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ForumReply> get replies => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nextSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set nextSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextSequence() => $_clearField(3);
}

/// Заголовок 1..320 байт UTF-8, текст до 8192, ключ 1..128; автор берётся из сессии.
/// Пустой текст разрешён только с вложением. До пяти файлов; core.forum.attachments.v1.
class CreateForumThreadRequest extends $pb.GeneratedMessage {
  factory CreateForumThreadRequest({
    $core.String? channelId,
    $core.String? title,
    $core.String? text,
    $core.String? idempotencyKey,
    $core.Iterable<$core.String>? attachmentIds,
  }) {
    final result = CreateForumThreadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (title != null) result.title = title;
    if (text != null) result.text = text;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (attachmentIds != null) result.attachmentIds.addAll(attachmentIds);
    return result;
  }

  CreateForumThreadRequest._();

  factory CreateForumThreadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateForumThreadRequest()..mergeFromBuffer(data, registry);
  factory CreateForumThreadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateForumThreadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateForumThreadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateForumThreadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..pPS(5, _omitFieldNames ? '' : 'attachmentIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateForumThreadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateForumThreadRequest copyWith(
          void Function(CreateForumThreadRequest) updates) =>
      super.copyWith((message) => updates(message as CreateForumThreadRequest))
          as CreateForumThreadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateForumThreadRequest() / CreateForumThreadRequest.new instead')
  static CreateForumThreadRequest create() => CreateForumThreadRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateForumThreadRequest._();
  @$core.override
  CreateForumThreadRequest createEmptyInstance() =>
      CreateForumThreadRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateForumThreadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateForumThreadRequest>(
          CreateForumThreadRequest.$_createMessage);
  static CreateForumThreadRequest? _defaultInstance;

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
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get attachmentIds => $_getList(4);
}

class CreateForumThreadResponse extends $pb.GeneratedMessage {
  factory CreateForumThreadResponse({
    ForumThread? thread,
  }) {
    final result = CreateForumThreadResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  CreateForumThreadResponse._();

  factory CreateForumThreadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateForumThreadResponse()..mergeFromBuffer(data, registry);
  factory CreateForumThreadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateForumThreadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateForumThreadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateForumThreadResponse.$_createMessage)
    ..aOM<ForumThread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateForumThreadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateForumThreadResponse copyWith(
          void Function(CreateForumThreadResponse) updates) =>
      super.copyWith((message) => updates(message as CreateForumThreadResponse))
          as CreateForumThreadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateForumThreadResponse() / CreateForumThreadResponse.new instead')
  static CreateForumThreadResponse create() => CreateForumThreadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateForumThreadResponse._();
  @$core.override
  CreateForumThreadResponse createEmptyInstance() =>
      CreateForumThreadResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateForumThreadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateForumThreadResponse>(
          CreateForumThreadResponse.$_createMessage);
  static CreateForumThreadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumThread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(ForumThread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumThread ensureThread() => $_ensure(0);
}

class ReplyForumThreadRequest extends $pb.GeneratedMessage {
  factory ReplyForumThreadRequest({
    $core.String? channelId,
    $core.String? threadId,
    $core.String? text,
    $core.String? idempotencyKey,
    $core.Iterable<$core.String>? attachmentIds,
  }) {
    final result = ReplyForumThreadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (text != null) result.text = text;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (attachmentIds != null) result.attachmentIds.addAll(attachmentIds);
    return result;
  }

  ReplyForumThreadRequest._();

  factory ReplyForumThreadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyForumThreadRequest()..mergeFromBuffer(data, registry);
  factory ReplyForumThreadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyForumThreadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyForumThreadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReplyForumThreadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..pPS(5, _omitFieldNames ? '' : 'attachmentIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyForumThreadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyForumThreadRequest copyWith(
          void Function(ReplyForumThreadRequest) updates) =>
      super.copyWith((message) => updates(message as ReplyForumThreadRequest))
          as ReplyForumThreadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReplyForumThreadRequest() / ReplyForumThreadRequest.new instead')
  static ReplyForumThreadRequest create() => ReplyForumThreadRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReplyForumThreadRequest._();
  @$core.override
  ReplyForumThreadRequest createEmptyInstance() => ReplyForumThreadRequest._();
  @$core.pragma('dart2js:noInline')
  static ReplyForumThreadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyForumThreadRequest>(
          ReplyForumThreadRequest.$_createMessage);
  static ReplyForumThreadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get attachmentIds => $_getList(4);
}

class ReplyForumThreadResponse extends $pb.GeneratedMessage {
  factory ReplyForumThreadResponse({
    ForumReply? reply,
    ForumThread? thread,
  }) {
    final result = ReplyForumThreadResponse._();
    if (reply != null) result.reply = reply;
    if (thread != null) result.thread = thread;
    return result;
  }

  ReplyForumThreadResponse._();

  factory ReplyForumThreadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyForumThreadResponse()..mergeFromBuffer(data, registry);
  factory ReplyForumThreadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyForumThreadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyForumThreadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReplyForumThreadResponse.$_createMessage)
    ..aOM<ForumReply>(1, _omitFieldNames ? '' : 'reply',
        subBuilder: ForumReply.$_createMessage)
    ..aOM<ForumThread>(2, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyForumThreadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyForumThreadResponse copyWith(
          void Function(ReplyForumThreadResponse) updates) =>
      super.copyWith((message) => updates(message as ReplyForumThreadResponse))
          as ReplyForumThreadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReplyForumThreadResponse() / ReplyForumThreadResponse.new instead')
  static ReplyForumThreadResponse create() => ReplyForumThreadResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReplyForumThreadResponse._();
  @$core.override
  ReplyForumThreadResponse createEmptyInstance() =>
      ReplyForumThreadResponse._();
  @$core.pragma('dart2js:noInline')
  static ReplyForumThreadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyForumThreadResponse>(
          ReplyForumThreadResponse.$_createMessage);
  static ReplyForumThreadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumReply get reply => $_getN(0);
  @$pb.TagNumber(1)
  set reply(ForumReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReply() => $_has(0);
  @$pb.TagNumber(1)
  void clearReply() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumReply ensureReply() => $_ensure(0);

  @$pb.TagNumber(2)
  ForumThread get thread => $_getN(1);
  @$pb.TagNumber(2)
  set thread(ForumThread value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasThread() => $_has(1);
  @$pb.TagNumber(2)
  void clearThread() => $_clearField(2);
  @$pb.TagNumber(2)
  ForumThread ensureThread() => $_ensure(1);
}

/// Требует manage и read; право автора само по себе не разрешает закрытие.
class CloseForumThreadRequest extends $pb.GeneratedMessage {
  factory CloseForumThreadRequest({
    $core.String? channelId,
    $core.String? threadId,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = CloseForumThreadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  CloseForumThreadRequest._();

  factory CloseForumThreadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseForumThreadRequest()..mergeFromBuffer(data, registry);
  factory CloseForumThreadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseForumThreadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseForumThreadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CloseForumThreadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseForumThreadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseForumThreadRequest copyWith(
          void Function(CloseForumThreadRequest) updates) =>
      super.copyWith((message) => updates(message as CloseForumThreadRequest))
          as CloseForumThreadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CloseForumThreadRequest() / CloseForumThreadRequest.new instead')
  static CloseForumThreadRequest create() => CloseForumThreadRequest._();
  static $pb.GeneratedMessage $_createMessage() => CloseForumThreadRequest._();
  @$core.override
  CloseForumThreadRequest createEmptyInstance() => CloseForumThreadRequest._();
  @$core.pragma('dart2js:noInline')
  static CloseForumThreadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseForumThreadRequest>(
          CloseForumThreadRequest.$_createMessage);
  static CloseForumThreadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedRevision() => $_clearField(3);
}

class CloseForumThreadResponse extends $pb.GeneratedMessage {
  factory CloseForumThreadResponse({
    ForumThread? thread,
  }) {
    final result = CloseForumThreadResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  CloseForumThreadResponse._();

  factory CloseForumThreadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseForumThreadResponse()..mergeFromBuffer(data, registry);
  factory CloseForumThreadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CloseForumThreadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseForumThreadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CloseForumThreadResponse.$_createMessage)
    ..aOM<ForumThread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseForumThreadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseForumThreadResponse copyWith(
          void Function(CloseForumThreadResponse) updates) =>
      super.copyWith((message) => updates(message as CloseForumThreadResponse))
          as CloseForumThreadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CloseForumThreadResponse() / CloseForumThreadResponse.new instead')
  static CloseForumThreadResponse create() => CloseForumThreadResponse._();
  static $pb.GeneratedMessage $_createMessage() => CloseForumThreadResponse._();
  @$core.override
  CloseForumThreadResponse createEmptyInstance() =>
      CloseForumThreadResponse._();
  @$core.pragma('dart2js:noInline')
  static CloseForumThreadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseForumThreadResponse>(
          CloseForumThreadResponse.$_createMessage);
  static CloseForumThreadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumThread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(ForumThread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumThread ensureThread() => $_ensure(0);
}

/// core.forum.navigation.v1. Закрепление требует read/manage и scope space.manage.
class SetForumThreadPinnedRequest extends $pb.GeneratedMessage {
  factory SetForumThreadPinnedRequest({
    $core.String? channelId,
    $core.String? threadId,
    $core.bool? pinned,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = SetForumThreadPinnedRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (pinned != null) result.pinned = pinned;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  SetForumThreadPinnedRequest._();

  factory SetForumThreadPinnedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetForumThreadPinnedRequest()..mergeFromBuffer(data, registry);
  factory SetForumThreadPinnedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetForumThreadPinnedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetForumThreadPinnedRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetForumThreadPinnedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOB(3, _omitFieldNames ? '' : 'pinned')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetForumThreadPinnedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetForumThreadPinnedRequest copyWith(
          void Function(SetForumThreadPinnedRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetForumThreadPinnedRequest))
          as SetForumThreadPinnedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetForumThreadPinnedRequest() / SetForumThreadPinnedRequest.new instead')
  static SetForumThreadPinnedRequest create() =>
      SetForumThreadPinnedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetForumThreadPinnedRequest._();
  @$core.override
  SetForumThreadPinnedRequest createEmptyInstance() =>
      SetForumThreadPinnedRequest._();
  @$core.pragma('dart2js:noInline')
  static SetForumThreadPinnedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetForumThreadPinnedRequest>(
          SetForumThreadPinnedRequest.$_createMessage);
  static SetForumThreadPinnedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get pinned => $_getBF(2);
  @$pb.TagNumber(3)
  set pinned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPinned() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinned() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedRevision() => $_clearField(4);
}

class SetForumThreadPinnedResponse extends $pb.GeneratedMessage {
  factory SetForumThreadPinnedResponse({
    ForumThread? thread,
  }) {
    final result = SetForumThreadPinnedResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  SetForumThreadPinnedResponse._();

  factory SetForumThreadPinnedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetForumThreadPinnedResponse()..mergeFromBuffer(data, registry);
  factory SetForumThreadPinnedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetForumThreadPinnedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetForumThreadPinnedResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetForumThreadPinnedResponse.$_createMessage)
    ..aOM<ForumThread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetForumThreadPinnedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetForumThreadPinnedResponse copyWith(
          void Function(SetForumThreadPinnedResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetForumThreadPinnedResponse))
          as SetForumThreadPinnedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetForumThreadPinnedResponse() / SetForumThreadPinnedResponse.new instead')
  static SetForumThreadPinnedResponse create() =>
      SetForumThreadPinnedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetForumThreadPinnedResponse._();
  @$core.override
  SetForumThreadPinnedResponse createEmptyInstance() =>
      SetForumThreadPinnedResponse._();
  @$core.pragma('dart2js:noInline')
  static SetForumThreadPinnedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetForumThreadPinnedResponse>(
          SetForumThreadPinnedResponse.$_createMessage);
  static SetForumThreadPinnedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumThread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(ForumThread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumThread ensureThread() => $_ensure(0);
}

/// Курсор чтения относится к principal сессии, монотонный; 0 отмечает первое сообщение.
class MarkForumThreadReadRequest extends $pb.GeneratedMessage {
  factory MarkForumThreadReadRequest({
    $core.String? channelId,
    $core.String? threadId,
    $fixnum.Int64? throughSequence,
  }) {
    final result = MarkForumThreadReadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (throughSequence != null) result.throughSequence = throughSequence;
    return result;
  }

  MarkForumThreadReadRequest._();

  factory MarkForumThreadReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkForumThreadReadRequest()..mergeFromBuffer(data, registry);
  factory MarkForumThreadReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkForumThreadReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkForumThreadReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MarkForumThreadReadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aInt64(3, _omitFieldNames ? '' : 'throughSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForumThreadReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForumThreadReadRequest copyWith(
          void Function(MarkForumThreadReadRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MarkForumThreadReadRequest))
          as MarkForumThreadReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkForumThreadReadRequest() / MarkForumThreadReadRequest.new instead')
  static MarkForumThreadReadRequest create() => MarkForumThreadReadRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkForumThreadReadRequest._();
  @$core.override
  MarkForumThreadReadRequest createEmptyInstance() =>
      MarkForumThreadReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkForumThreadReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkForumThreadReadRequest>(
          MarkForumThreadReadRequest.$_createMessage);
  static MarkForumThreadReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get throughSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set throughSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThroughSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearThroughSequence() => $_clearField(3);
}

class MarkForumThreadReadResponse extends $pb.GeneratedMessage {
  factory MarkForumThreadReadResponse({
    ForumThread? thread,
  }) {
    final result = MarkForumThreadReadResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  MarkForumThreadReadResponse._();

  factory MarkForumThreadReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkForumThreadReadResponse()..mergeFromBuffer(data, registry);
  factory MarkForumThreadReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkForumThreadReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkForumThreadReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MarkForumThreadReadResponse.$_createMessage)
    ..aOM<ForumThread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForumThreadReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkForumThreadReadResponse copyWith(
          void Function(MarkForumThreadReadResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MarkForumThreadReadResponse))
          as MarkForumThreadReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkForumThreadReadResponse() / MarkForumThreadReadResponse.new instead')
  static MarkForumThreadReadResponse create() =>
      MarkForumThreadReadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MarkForumThreadReadResponse._();
  @$core.override
  MarkForumThreadReadResponse createEmptyInstance() =>
      MarkForumThreadReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkForumThreadReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkForumThreadReadResponse>(
          MarkForumThreadReadResponse.$_createMessage);
  static MarkForumThreadReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumThread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(ForumThread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumThread ensureThread() => $_ensure(0);
}

/// core.forum.moderation.v1. Все операции требуют read/manage и scope space.manage.
/// Причина 1..1024 байт UTF-8 обязательна; скрытое содержимое не возвращается даже автору.
class ModerateForumThreadRequest extends $pb.GeneratedMessage {
  factory ModerateForumThreadRequest({
    $core.String? channelId,
    $core.String? threadId,
    $core.String? action,
    $core.String? reason,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = ModerateForumThreadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (action != null) result.action = action;
    if (reason != null) result.reason = reason;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ModerateForumThreadRequest._();

  factory ModerateForumThreadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumThreadRequest()..mergeFromBuffer(data, registry);
  factory ModerateForumThreadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumThreadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateForumThreadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateForumThreadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'action')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumThreadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumThreadRequest copyWith(
          void Function(ModerateForumThreadRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ModerateForumThreadRequest))
          as ModerateForumThreadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateForumThreadRequest() / ModerateForumThreadRequest.new instead')
  static ModerateForumThreadRequest create() => ModerateForumThreadRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ModerateForumThreadRequest._();
  @$core.override
  ModerateForumThreadRequest createEmptyInstance() =>
      ModerateForumThreadRequest._();
  @$core.pragma('dart2js:noInline')
  static ModerateForumThreadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateForumThreadRequest>(
          ModerateForumThreadRequest.$_createMessage);
  static ModerateForumThreadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get action => $_getSZ(2);
  @$pb.TagNumber(3)
  set action($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expectedRevision => $_getI64(4);
  @$pb.TagNumber(5)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpectedRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpectedRevision() => $_clearField(5);
}

class ModerateForumThreadResponse extends $pb.GeneratedMessage {
  factory ModerateForumThreadResponse({
    ForumThread? thread,
  }) {
    final result = ModerateForumThreadResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  ModerateForumThreadResponse._();

  factory ModerateForumThreadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumThreadResponse()..mergeFromBuffer(data, registry);
  factory ModerateForumThreadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumThreadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateForumThreadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateForumThreadResponse.$_createMessage)
    ..aOM<ForumThread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumThreadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumThreadResponse copyWith(
          void Function(ModerateForumThreadResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ModerateForumThreadResponse))
          as ModerateForumThreadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateForumThreadResponse() / ModerateForumThreadResponse.new instead')
  static ModerateForumThreadResponse create() =>
      ModerateForumThreadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ModerateForumThreadResponse._();
  @$core.override
  ModerateForumThreadResponse createEmptyInstance() =>
      ModerateForumThreadResponse._();
  @$core.pragma('dart2js:noInline')
  static ModerateForumThreadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateForumThreadResponse>(
          ModerateForumThreadResponse.$_createMessage);
  static ModerateForumThreadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumThread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(ForumThread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumThread ensureThread() => $_ensure(0);
}

/// action темы: reopen, hide, restore. Ответы сохраняют последовательность при скрытии.
class ModerateForumReplyRequest extends $pb.GeneratedMessage {
  factory ModerateForumReplyRequest({
    $core.String? channelId,
    $core.String? threadId,
    $core.String? replyId,
    $core.bool? hidden,
    $core.String? reason,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = ModerateForumReplyRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (replyId != null) result.replyId = replyId;
    if (hidden != null) result.hidden = hidden;
    if (reason != null) result.reason = reason;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ModerateForumReplyRequest._();

  factory ModerateForumReplyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumReplyRequest()..mergeFromBuffer(data, registry);
  factory ModerateForumReplyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumReplyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateForumReplyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateForumReplyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'replyId')
    ..aOB(4, _omitFieldNames ? '' : 'hidden')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aInt64(6, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumReplyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumReplyRequest copyWith(
          void Function(ModerateForumReplyRequest) updates) =>
      super.copyWith((message) => updates(message as ModerateForumReplyRequest))
          as ModerateForumReplyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateForumReplyRequest() / ModerateForumReplyRequest.new instead')
  static ModerateForumReplyRequest create() => ModerateForumReplyRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ModerateForumReplyRequest._();
  @$core.override
  ModerateForumReplyRequest createEmptyInstance() =>
      ModerateForumReplyRequest._();
  @$core.pragma('dart2js:noInline')
  static ModerateForumReplyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateForumReplyRequest>(
          ModerateForumReplyRequest.$_createMessage);
  static ModerateForumReplyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get replyId => $_getSZ(2);
  @$pb.TagNumber(3)
  set replyId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReplyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplyId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hidden => $_getBF(3);
  @$pb.TagNumber(4)
  set hidden($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHidden() => $_has(3);
  @$pb.TagNumber(4)
  void clearHidden() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expectedRevision => $_getI64(5);
  @$pb.TagNumber(6)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedRevision() => $_clearField(6);
}

class ModerateForumReplyResponse extends $pb.GeneratedMessage {
  factory ModerateForumReplyResponse({
    ForumReply? reply,
    ForumThread? thread,
  }) {
    final result = ModerateForumReplyResponse._();
    if (reply != null) result.reply = reply;
    if (thread != null) result.thread = thread;
    return result;
  }

  ModerateForumReplyResponse._();

  factory ModerateForumReplyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumReplyResponse()..mergeFromBuffer(data, registry);
  factory ModerateForumReplyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateForumReplyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateForumReplyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateForumReplyResponse.$_createMessage)
    ..aOM<ForumReply>(1, _omitFieldNames ? '' : 'reply',
        subBuilder: ForumReply.$_createMessage)
    ..aOM<ForumThread>(2, _omitFieldNames ? '' : 'thread',
        subBuilder: ForumThread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumReplyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateForumReplyResponse copyWith(
          void Function(ModerateForumReplyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ModerateForumReplyResponse))
          as ModerateForumReplyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateForumReplyResponse() / ModerateForumReplyResponse.new instead')
  static ModerateForumReplyResponse create() => ModerateForumReplyResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ModerateForumReplyResponse._();
  @$core.override
  ModerateForumReplyResponse createEmptyInstance() =>
      ModerateForumReplyResponse._();
  @$core.pragma('dart2js:noInline')
  static ModerateForumReplyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateForumReplyResponse>(
          ModerateForumReplyResponse.$_createMessage);
  static ModerateForumReplyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ForumReply get reply => $_getN(0);
  @$pb.TagNumber(1)
  set reply(ForumReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReply() => $_has(0);
  @$pb.TagNumber(1)
  void clearReply() => $_clearField(1);
  @$pb.TagNumber(1)
  ForumReply ensureReply() => $_ensure(0);

  @$pb.TagNumber(2)
  ForumThread get thread => $_getN(1);
  @$pb.TagNumber(2)
  set thread(ForumThread value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasThread() => $_has(1);
  @$pb.TagNumber(2)
  void clearThread() => $_clearField(2);
  @$pb.TagNumber(2)
  ForumThread ensureThread() => $_ensure(1);
}

/// Журнал виден только модератору. Курсор id последней записи, 0 начинает чтение.
class ListForumModerationRequest extends $pb.GeneratedMessage {
  factory ListForumModerationRequest({
    $core.String? channelId,
    $core.String? threadId,
    $fixnum.Int64? afterId,
    $core.int? limit,
  }) {
    final result = ListForumModerationRequest._();
    if (channelId != null) result.channelId = channelId;
    if (threadId != null) result.threadId = threadId;
    if (afterId != null) result.afterId = afterId;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListForumModerationRequest._();

  factory ListForumModerationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumModerationRequest()..mergeFromBuffer(data, registry);
  factory ListForumModerationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumModerationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListForumModerationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListForumModerationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aInt64(3, _omitFieldNames ? '' : 'afterId')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumModerationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumModerationRequest copyWith(
          void Function(ListForumModerationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListForumModerationRequest))
          as ListForumModerationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListForumModerationRequest() / ListForumModerationRequest.new instead')
  static ListForumModerationRequest create() => ListForumModerationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListForumModerationRequest._();
  @$core.override
  ListForumModerationRequest createEmptyInstance() =>
      ListForumModerationRequest._();
  @$core.pragma('dart2js:noInline')
  static ListForumModerationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListForumModerationRequest>(
          ListForumModerationRequest.$_createMessage);
  static ListForumModerationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get afterId => $_getI64(2);
  @$pb.TagNumber(3)
  set afterId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

class ForumModerationEvent extends $pb.GeneratedMessage {
  factory ForumModerationEvent({
    $fixnum.Int64? id,
    $core.String? threadId,
    $core.String? replyId,
    $core.String? action,
    $core.String? reason,
    $core.String? actorId,
    $fixnum.Int64? revision,
    $fixnum.Int64? createdAtUnix,
  }) {
    final result = ForumModerationEvent._();
    if (id != null) result.id = id;
    if (threadId != null) result.threadId = threadId;
    if (replyId != null) result.replyId = replyId;
    if (action != null) result.action = action;
    if (reason != null) result.reason = reason;
    if (actorId != null) result.actorId = actorId;
    if (revision != null) result.revision = revision;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    return result;
  }

  ForumModerationEvent._();

  factory ForumModerationEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForumModerationEvent()..mergeFromBuffer(data, registry);
  factory ForumModerationEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ForumModerationEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForumModerationEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ForumModerationEvent.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'replyId')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOS(6, _omitFieldNames ? '' : 'actorId')
    ..aInt64(7, _omitFieldNames ? '' : 'revision')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForumModerationEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForumModerationEvent copyWith(void Function(ForumModerationEvent) updates) =>
      super.copyWith((message) => updates(message as ForumModerationEvent))
          as ForumModerationEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ForumModerationEvent() / ForumModerationEvent.new instead')
  static ForumModerationEvent create() => ForumModerationEvent._();
  static $pb.GeneratedMessage $_createMessage() => ForumModerationEvent._();
  @$core.override
  ForumModerationEvent createEmptyInstance() => ForumModerationEvent._();
  @$core.pragma('dart2js:noInline')
  static ForumModerationEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ForumModerationEvent>(
          ForumModerationEvent.$_createMessage);
  static ForumModerationEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get replyId => $_getSZ(2);
  @$pb.TagNumber(3)
  set replyId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReplyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplyId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get actorId => $_getSZ(5);
  @$pb.TagNumber(6)
  set actorId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActorId() => $_has(5);
  @$pb.TagNumber(6)
  void clearActorId() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get revision => $_getI64(6);
  @$pb.TagNumber(7)
  set revision($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearRevision() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAtUnix => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAtUnix() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAtUnix() => $_clearField(8);
}

class ListForumModerationResponse extends $pb.GeneratedMessage {
  factory ListForumModerationResponse({
    $core.Iterable<ForumModerationEvent>? events,
    $fixnum.Int64? nextId,
  }) {
    final result = ListForumModerationResponse._();
    if (events != null) result.events.addAll(events);
    if (nextId != null) result.nextId = nextId;
    return result;
  }

  ListForumModerationResponse._();

  factory ListForumModerationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumModerationResponse()..mergeFromBuffer(data, registry);
  factory ListForumModerationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListForumModerationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListForumModerationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListForumModerationResponse.$_createMessage)
    ..pPM<ForumModerationEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: ForumModerationEvent.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumModerationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListForumModerationResponse copyWith(
          void Function(ListForumModerationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListForumModerationResponse))
          as ListForumModerationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListForumModerationResponse() / ListForumModerationResponse.new instead')
  static ListForumModerationResponse create() =>
      ListForumModerationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListForumModerationResponse._();
  @$core.override
  ListForumModerationResponse createEmptyInstance() =>
      ListForumModerationResponse._();
  @$core.pragma('dart2js:noInline')
  static ListForumModerationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListForumModerationResponse>(
          ListForumModerationResponse.$_createMessage);
  static ListForumModerationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ForumModerationEvent> get events => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextId => $_getI64(1);
  @$pb.TagNumber(2)
  set nextId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextId() => $_clearField(2);
}

/// core.forum.v1: отдельные открытые форумные разделы с ACL канала.
class ForumServiceApi {
  final $pb.RpcClient _client;

  ForumServiceApi(this._client);

  $async.Future<ListForumThreadsResponse> listForumThreads(
          $pb.ClientContext? ctx, ListForumThreadsRequest request) =>
      _client.invoke<ListForumThreadsResponse>(ctx, 'ForumService',
          'ListForumThreads', request, ListForumThreadsResponse());
  $async.Future<GetForumThreadResponse> getForumThread(
          $pb.ClientContext? ctx, GetForumThreadRequest request) =>
      _client.invoke<GetForumThreadResponse>(ctx, 'ForumService',
          'GetForumThread', request, GetForumThreadResponse());
  $async.Future<CreateForumThreadResponse> createForumThread(
          $pb.ClientContext? ctx, CreateForumThreadRequest request) =>
      _client.invoke<CreateForumThreadResponse>(ctx, 'ForumService',
          'CreateForumThread', request, CreateForumThreadResponse());
  $async.Future<ReplyForumThreadResponse> replyForumThread(
          $pb.ClientContext? ctx, ReplyForumThreadRequest request) =>
      _client.invoke<ReplyForumThreadResponse>(ctx, 'ForumService',
          'ReplyForumThread', request, ReplyForumThreadResponse());
  $async.Future<SetForumThreadPinnedResponse> setForumThreadPinned(
          $pb.ClientContext? ctx, SetForumThreadPinnedRequest request) =>
      _client.invoke<SetForumThreadPinnedResponse>(ctx, 'ForumService',
          'SetForumThreadPinned', request, SetForumThreadPinnedResponse());
  $async.Future<MarkForumThreadReadResponse> markForumThreadRead(
          $pb.ClientContext? ctx, MarkForumThreadReadRequest request) =>
      _client.invoke<MarkForumThreadReadResponse>(ctx, 'ForumService',
          'MarkForumThreadRead', request, MarkForumThreadReadResponse());
  $async.Future<CloseForumThreadResponse> closeForumThread(
          $pb.ClientContext? ctx, CloseForumThreadRequest request) =>
      _client.invoke<CloseForumThreadResponse>(ctx, 'ForumService',
          'CloseForumThread', request, CloseForumThreadResponse());
  $async.Future<ModerateForumThreadResponse> moderateForumThread(
          $pb.ClientContext? ctx, ModerateForumThreadRequest request) =>
      _client.invoke<ModerateForumThreadResponse>(ctx, 'ForumService',
          'ModerateForumThread', request, ModerateForumThreadResponse());
  $async.Future<ModerateForumReplyResponse> moderateForumReply(
          $pb.ClientContext? ctx, ModerateForumReplyRequest request) =>
      _client.invoke<ModerateForumReplyResponse>(ctx, 'ForumService',
          'ModerateForumReply', request, ModerateForumReplyResponse());
  $async.Future<ListForumModerationResponse> listForumModeration(
          $pb.ClientContext? ctx, ListForumModerationRequest request) =>
      _client.invoke<ListForumModerationResponse>(ctx, 'ForumService',
          'ListForumModeration', request, ListForumModerationResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
