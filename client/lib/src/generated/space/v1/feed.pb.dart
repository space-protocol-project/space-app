// This is a generated file - do not edit.
//
// Generated from space/v1/feed.proto.

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

/// Собственные эффективные права; read/manage берутся из ACL канала.
class FeedPermissions extends $pb.GeneratedMessage {
  factory FeedPermissions({
    $core.bool? publish,
    $core.bool? comment,
  }) {
    final result = FeedPermissions._();
    if (publish != null) result.publish = publish;
    if (comment != null) result.comment = comment;
    return result;
  }

  FeedPermissions._();

  factory FeedPermissions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPermissions()..mergeFromBuffer(data, registry);
  factory FeedPermissions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPermissions()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedPermissions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: FeedPermissions.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'publish')
    ..aOB(2, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPermissions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPermissions copyWith(void Function(FeedPermissions) updates) =>
      super.copyWith((message) => updates(message as FeedPermissions))
          as FeedPermissions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeedPermissions() / FeedPermissions.new instead')
  static FeedPermissions create() => FeedPermissions._();
  static $pb.GeneratedMessage $_createMessage() => FeedPermissions._();
  @$core.override
  FeedPermissions createEmptyInstance() => FeedPermissions._();
  @$core.pragma('dart2js:noInline')
  static FeedPermissions getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedPermissions>(
          FeedPermissions.$_createMessage);
  static FeedPermissions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get publish => $_getBF(0);
  @$pb.TagNumber(1)
  set publish($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublish() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublish() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get comment => $_getBF(1);
  @$pb.TagNumber(2)
  set comment($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasComment() => $_has(1);
  @$pb.TagNumber(2)
  void clearComment() => $_clearField(2);
}

class FeedPost extends $pb.GeneratedMessage {
  factory FeedPost({
    $core.String? id,
    $core.String? channelId,
    $core.String? authorId,
    $core.String? authorName,
    $core.String? text,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? sequence,
    $fixnum.Int64? revision,
    $fixnum.Int64? commentCount,
    $core.Iterable<$0.Asset>? attachments,
    $core.bool? hidden,
    $core.bool? readStateSupported,
    $core.bool? seen,
    $fixnum.Int64? readSequence,
    $fixnum.Int64? unreadCount,
  }) {
    final result = FeedPost._();
    if (id != null) result.id = id;
    if (channelId != null) result.channelId = channelId;
    if (authorId != null) result.authorId = authorId;
    if (authorName != null) result.authorName = authorName;
    if (text != null) result.text = text;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (sequence != null) result.sequence = sequence;
    if (revision != null) result.revision = revision;
    if (commentCount != null) result.commentCount = commentCount;
    if (attachments != null) result.attachments.addAll(attachments);
    if (hidden != null) result.hidden = hidden;
    if (readStateSupported != null)
      result.readStateSupported = readStateSupported;
    if (seen != null) result.seen = seen;
    if (readSequence != null) result.readSequence = readSequence;
    if (unreadCount != null) result.unreadCount = unreadCount;
    return result;
  }

  FeedPost._();

  factory FeedPost.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPost()..mergeFromBuffer(data, registry);
  factory FeedPost.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPost()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedPost',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: FeedPost.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'channelId')
    ..aOS(3, _omitFieldNames ? '' : 'authorId')
    ..aOS(4, _omitFieldNames ? '' : 'authorName')
    ..aOS(5, _omitFieldNames ? '' : 'text')
    ..aInt64(6, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(7, _omitFieldNames ? '' : 'sequence')
    ..aInt64(8, _omitFieldNames ? '' : 'revision')
    ..aInt64(9, _omitFieldNames ? '' : 'commentCount')
    ..pPM<$0.Asset>(10, _omitFieldNames ? '' : 'attachments',
        subBuilder: $0.Asset.$_createMessage)
    ..aOB(11, _omitFieldNames ? '' : 'hidden')
    ..aOB(12, _omitFieldNames ? '' : 'readStateSupported')
    ..aOB(13, _omitFieldNames ? '' : 'seen')
    ..aInt64(14, _omitFieldNames ? '' : 'readSequence')
    ..aInt64(15, _omitFieldNames ? '' : 'unreadCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPost clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPost copyWith(void Function(FeedPost) updates) =>
      super.copyWith((message) => updates(message as FeedPost)) as FeedPost;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeedPost() / FeedPost.new instead')
  static FeedPost create() => FeedPost._();
  static $pb.GeneratedMessage $_createMessage() => FeedPost._();
  @$core.override
  FeedPost createEmptyInstance() => FeedPost._();
  @$core.pragma('dart2js:noInline')
  static FeedPost getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FeedPost>(FeedPost.$_createMessage);
  static FeedPost? _defaultInstance;

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
  $fixnum.Int64 get revision => $_getI64(7);
  @$pb.TagNumber(8)
  set revision($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRevision() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevision() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get commentCount => $_getI64(8);
  @$pb.TagNumber(9)
  set commentCount($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCommentCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearCommentCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$0.Asset> get attachments => $_getList(9);

  /// Скрытая запись не содержит автора, текста, файлов и числа комментариев.
  @$pb.TagNumber(11)
  $core.bool get hidden => $_getBF(10);
  @$pb.TagNumber(11)
  set hidden($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHidden() => $_has(10);
  @$pb.TagNumber(11)
  void clearHidden() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get readStateSupported => $_getBF(11);
  @$pb.TagNumber(12)
  set readStateSupported($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReadStateSupported() => $_has(11);
  @$pb.TagNumber(12)
  void clearReadStateSupported() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get seen => $_getBF(12);
  @$pb.TagNumber(13)
  set seen($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSeen() => $_has(12);
  @$pb.TagNumber(13)
  void clearSeen() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get readSequence => $_getI64(13);
  @$pb.TagNumber(14)
  set readSequence($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasReadSequence() => $_has(13);
  @$pb.TagNumber(14)
  void clearReadSequence() => $_clearField(14);

  /// Невидимая ещё публикация плюс видимые комментарии после read_sequence.
  @$pb.TagNumber(15)
  $fixnum.Int64 get unreadCount => $_getI64(14);
  @$pb.TagNumber(15)
  set unreadCount($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasUnreadCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearUnreadCount() => $_clearField(15);
}

class MarkFeedPostReadRequest extends $pb.GeneratedMessage {
  factory MarkFeedPostReadRequest({
    $core.String? channelId,
    $core.String? postId,
    $fixnum.Int64? throughSequence,
  }) {
    final result = MarkFeedPostReadRequest._();
    if (channelId != null) result.channelId = channelId;
    if (postId != null) result.postId = postId;
    if (throughSequence != null) result.throughSequence = throughSequence;
    return result;
  }

  MarkFeedPostReadRequest._();

  factory MarkFeedPostReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkFeedPostReadRequest()..mergeFromBuffer(data, registry);
  factory MarkFeedPostReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkFeedPostReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkFeedPostReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MarkFeedPostReadRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aInt64(3, _omitFieldNames ? '' : 'throughSequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkFeedPostReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkFeedPostReadRequest copyWith(
          void Function(MarkFeedPostReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkFeedPostReadRequest))
          as MarkFeedPostReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkFeedPostReadRequest() / MarkFeedPostReadRequest.new instead')
  static MarkFeedPostReadRequest create() => MarkFeedPostReadRequest._();
  static $pb.GeneratedMessage $_createMessage() => MarkFeedPostReadRequest._();
  @$core.override
  MarkFeedPostReadRequest createEmptyInstance() => MarkFeedPostReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkFeedPostReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkFeedPostReadRequest>(
          MarkFeedPostReadRequest.$_createMessage);
  static MarkFeedPostReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

  /// 0 подтверждает публикацию; положительное значение — комментарии до курсора.
  /// Не больше последнего видимого комментария либо уже сохранённого курсора.
  @$pb.TagNumber(3)
  $fixnum.Int64 get throughSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set throughSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThroughSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearThroughSequence() => $_clearField(3);
}

class MarkFeedPostReadResponse extends $pb.GeneratedMessage {
  factory MarkFeedPostReadResponse({
    FeedPost? post,
  }) {
    final result = MarkFeedPostReadResponse._();
    if (post != null) result.post = post;
    return result;
  }

  MarkFeedPostReadResponse._();

  factory MarkFeedPostReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkFeedPostReadResponse()..mergeFromBuffer(data, registry);
  factory MarkFeedPostReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkFeedPostReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkFeedPostReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: MarkFeedPostReadResponse.$_createMessage)
    ..aOM<FeedPost>(1, _omitFieldNames ? '' : 'post',
        subBuilder: FeedPost.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkFeedPostReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkFeedPostReadResponse copyWith(
          void Function(MarkFeedPostReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkFeedPostReadResponse))
          as MarkFeedPostReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MarkFeedPostReadResponse() / MarkFeedPostReadResponse.new instead')
  static MarkFeedPostReadResponse create() => MarkFeedPostReadResponse._();
  static $pb.GeneratedMessage $_createMessage() => MarkFeedPostReadResponse._();
  @$core.override
  MarkFeedPostReadResponse createEmptyInstance() =>
      MarkFeedPostReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkFeedPostReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkFeedPostReadResponse>(
          MarkFeedPostReadResponse.$_createMessage);
  static MarkFeedPostReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedPost get post => $_getN(0);
  @$pb.TagNumber(1)
  set post(FeedPost value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPost() => $_has(0);
  @$pb.TagNumber(1)
  void clearPost() => $_clearField(1);
  @$pb.TagNumber(1)
  FeedPost ensurePost() => $_ensure(0);
}

class FeedComment extends $pb.GeneratedMessage {
  factory FeedComment({
    $core.String? id,
    $core.String? postId,
    $core.String? authorId,
    $core.String? authorName,
    $core.String? text,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? sequence,
    $fixnum.Int64? revision,
    $core.Iterable<$0.Asset>? attachments,
    $core.bool? hidden,
  }) {
    final result = FeedComment._();
    if (id != null) result.id = id;
    if (postId != null) result.postId = postId;
    if (authorId != null) result.authorId = authorId;
    if (authorName != null) result.authorName = authorName;
    if (text != null) result.text = text;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (sequence != null) result.sequence = sequence;
    if (revision != null) result.revision = revision;
    if (attachments != null) result.attachments.addAll(attachments);
    if (hidden != null) result.hidden = hidden;
    return result;
  }

  FeedComment._();

  factory FeedComment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedComment()..mergeFromBuffer(data, registry);
  factory FeedComment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedComment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedComment',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: FeedComment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aOS(3, _omitFieldNames ? '' : 'authorId')
    ..aOS(4, _omitFieldNames ? '' : 'authorName')
    ..aOS(5, _omitFieldNames ? '' : 'text')
    ..aInt64(6, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(7, _omitFieldNames ? '' : 'sequence')
    ..aInt64(8, _omitFieldNames ? '' : 'revision')
    ..pPM<$0.Asset>(9, _omitFieldNames ? '' : 'attachments',
        subBuilder: $0.Asset.$_createMessage)
    ..aOB(10, _omitFieldNames ? '' : 'hidden')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedComment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedComment copyWith(void Function(FeedComment) updates) =>
      super.copyWith((message) => updates(message as FeedComment))
          as FeedComment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeedComment() / FeedComment.new instead')
  static FeedComment create() => FeedComment._();
  static $pb.GeneratedMessage $_createMessage() => FeedComment._();
  @$core.override
  FeedComment createEmptyInstance() => FeedComment._();
  @$core.pragma('dart2js:noInline')
  static FeedComment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedComment>(
          FeedComment.$_createMessage);
  static FeedComment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

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
  $fixnum.Int64 get revision => $_getI64(7);
  @$pb.TagNumber(8)
  set revision($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRevision() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevision() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$0.Asset> get attachments => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get hidden => $_getBF(9);
  @$pb.TagNumber(10)
  set hidden($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHidden() => $_has(9);
  @$pb.TagNumber(10)
  void clearHidden() => $_clearField(10);
}

/// sequence DESC; before=0 начинает список, next=0 означает конец.
class ListFeedPostsRequest extends $pb.GeneratedMessage {
  factory ListFeedPostsRequest({
    $core.String? channelId,
    $fixnum.Int64? beforeSequence,
    $core.int? limit,
  }) {
    final result = ListFeedPostsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (beforeSequence != null) result.beforeSequence = beforeSequence;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListFeedPostsRequest._();

  factory ListFeedPostsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedPostsRequest()..mergeFromBuffer(data, registry);
  factory ListFeedPostsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedPostsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFeedPostsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFeedPostsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'beforeSequence')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedPostsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedPostsRequest copyWith(void Function(ListFeedPostsRequest) updates) =>
      super.copyWith((message) => updates(message as ListFeedPostsRequest))
          as ListFeedPostsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFeedPostsRequest() / ListFeedPostsRequest.new instead')
  static ListFeedPostsRequest create() => ListFeedPostsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListFeedPostsRequest._();
  @$core.override
  ListFeedPostsRequest createEmptyInstance() => ListFeedPostsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListFeedPostsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFeedPostsRequest>(
          ListFeedPostsRequest.$_createMessage);
  static ListFeedPostsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get beforeSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set beforeSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBeforeSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearBeforeSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class ListFeedPostsResponse extends $pb.GeneratedMessage {
  factory ListFeedPostsResponse({
    $core.Iterable<FeedPost>? posts,
    $fixnum.Int64? nextBeforeSequence,
    FeedPermissions? permissions,
  }) {
    final result = ListFeedPostsResponse._();
    if (posts != null) result.posts.addAll(posts);
    if (nextBeforeSequence != null)
      result.nextBeforeSequence = nextBeforeSequence;
    if (permissions != null) result.permissions = permissions;
    return result;
  }

  ListFeedPostsResponse._();

  factory ListFeedPostsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedPostsResponse()..mergeFromBuffer(data, registry);
  factory ListFeedPostsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedPostsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFeedPostsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFeedPostsResponse.$_createMessage)
    ..pPM<FeedPost>(1, _omitFieldNames ? '' : 'posts',
        subBuilder: FeedPost.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextBeforeSequence')
    ..aOM<FeedPermissions>(3, _omitFieldNames ? '' : 'permissions',
        subBuilder: FeedPermissions.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedPostsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedPostsResponse copyWith(
          void Function(ListFeedPostsResponse) updates) =>
      super.copyWith((message) => updates(message as ListFeedPostsResponse))
          as ListFeedPostsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFeedPostsResponse() / ListFeedPostsResponse.new instead')
  static ListFeedPostsResponse create() => ListFeedPostsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListFeedPostsResponse._();
  @$core.override
  ListFeedPostsResponse createEmptyInstance() => ListFeedPostsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListFeedPostsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFeedPostsResponse>(
          ListFeedPostsResponse.$_createMessage);
  static ListFeedPostsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FeedPost> get posts => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextBeforeSequence => $_getI64(1);
  @$pb.TagNumber(2)
  set nextBeforeSequence($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextBeforeSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextBeforeSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  FeedPermissions get permissions => $_getN(2);
  @$pb.TagNumber(3)
  set permissions(FeedPermissions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPermissions() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissions() => $_clearField(3);
  @$pb.TagNumber(3)
  FeedPermissions ensurePermissions() => $_ensure(2);
}

/// Комментарии sequence ASC; скрытый родитель не возвращает комментарии.
class GetFeedPostRequest extends $pb.GeneratedMessage {
  factory GetFeedPostRequest({
    $core.String? channelId,
    $core.String? postId,
    $fixnum.Int64? afterSequence,
    $core.int? limit,
  }) {
    final result = GetFeedPostRequest._();
    if (channelId != null) result.channelId = channelId;
    if (postId != null) result.postId = postId;
    if (afterSequence != null) result.afterSequence = afterSequence;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetFeedPostRequest._();

  factory GetFeedPostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedPostRequest()..mergeFromBuffer(data, registry);
  factory GetFeedPostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedPostRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFeedPostRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetFeedPostRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aInt64(3, _omitFieldNames ? '' : 'afterSequence')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedPostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedPostRequest copyWith(void Function(GetFeedPostRequest) updates) =>
      super.copyWith((message) => updates(message as GetFeedPostRequest))
          as GetFeedPostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetFeedPostRequest() / GetFeedPostRequest.new instead')
  static GetFeedPostRequest create() => GetFeedPostRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetFeedPostRequest._();
  @$core.override
  GetFeedPostRequest createEmptyInstance() => GetFeedPostRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFeedPostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFeedPostRequest>(
          GetFeedPostRequest.$_createMessage);
  static GetFeedPostRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

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

class GetFeedPostResponse extends $pb.GeneratedMessage {
  factory GetFeedPostResponse({
    FeedPost? post,
    $core.Iterable<FeedComment>? comments,
    $fixnum.Int64? nextSequence,
    FeedPermissions? permissions,
  }) {
    final result = GetFeedPostResponse._();
    if (post != null) result.post = post;
    if (comments != null) result.comments.addAll(comments);
    if (nextSequence != null) result.nextSequence = nextSequence;
    if (permissions != null) result.permissions = permissions;
    return result;
  }

  GetFeedPostResponse._();

  factory GetFeedPostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedPostResponse()..mergeFromBuffer(data, registry);
  factory GetFeedPostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedPostResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFeedPostResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetFeedPostResponse.$_createMessage)
    ..aOM<FeedPost>(1, _omitFieldNames ? '' : 'post',
        subBuilder: FeedPost.$_createMessage)
    ..pPM<FeedComment>(2, _omitFieldNames ? '' : 'comments',
        subBuilder: FeedComment.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'nextSequence')
    ..aOM<FeedPermissions>(4, _omitFieldNames ? '' : 'permissions',
        subBuilder: FeedPermissions.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedPostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedPostResponse copyWith(void Function(GetFeedPostResponse) updates) =>
      super.copyWith((message) => updates(message as GetFeedPostResponse))
          as GetFeedPostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetFeedPostResponse() / GetFeedPostResponse.new instead')
  static GetFeedPostResponse create() => GetFeedPostResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetFeedPostResponse._();
  @$core.override
  GetFeedPostResponse createEmptyInstance() => GetFeedPostResponse._();
  @$core.pragma('dart2js:noInline')
  static GetFeedPostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFeedPostResponse>(
          GetFeedPostResponse.$_createMessage);
  static GetFeedPostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedPost get post => $_getN(0);
  @$pb.TagNumber(1)
  set post(FeedPost value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPost() => $_has(0);
  @$pb.TagNumber(1)
  void clearPost() => $_clearField(1);
  @$pb.TagNumber(1)
  FeedPost ensurePost() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<FeedComment> get comments => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nextSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set nextSequence($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextSequence() => $_clearField(3);

  @$pb.TagNumber(4)
  FeedPermissions get permissions => $_getN(3);
  @$pb.TagNumber(4)
  set permissions(FeedPermissions value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPermissions() => $_has(3);
  @$pb.TagNumber(4)
  void clearPermissions() => $_clearField(4);
  @$pb.TagNumber(4)
  FeedPermissions ensurePermissions() => $_ensure(3);
}

/// Текст до 8192 байт UTF-8; пустой только с файлом. До пяти файлов.
/// Ключ 1..128 байт, автор берётся из сессии; правила повтора — ADR-046.
class CreateFeedPostRequest extends $pb.GeneratedMessage {
  factory CreateFeedPostRequest({
    $core.String? channelId,
    $core.String? text,
    $core.String? idempotencyKey,
    $core.Iterable<$core.String>? attachmentIds,
  }) {
    final result = CreateFeedPostRequest._();
    if (channelId != null) result.channelId = channelId;
    if (text != null) result.text = text;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (attachmentIds != null) result.attachmentIds.addAll(attachmentIds);
    return result;
  }

  CreateFeedPostRequest._();

  factory CreateFeedPostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFeedPostRequest()..mergeFromBuffer(data, registry);
  factory CreateFeedPostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFeedPostRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFeedPostRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateFeedPostRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..pPS(4, _omitFieldNames ? '' : 'attachmentIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedPostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedPostRequest copyWith(
          void Function(CreateFeedPostRequest) updates) =>
      super.copyWith((message) => updates(message as CreateFeedPostRequest))
          as CreateFeedPostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateFeedPostRequest() / CreateFeedPostRequest.new instead')
  static CreateFeedPostRequest create() => CreateFeedPostRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateFeedPostRequest._();
  @$core.override
  CreateFeedPostRequest createEmptyInstance() => CreateFeedPostRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateFeedPostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFeedPostRequest>(
          CreateFeedPostRequest.$_createMessage);
  static CreateFeedPostRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get attachmentIds => $_getList(3);
}

class CreateFeedPostResponse extends $pb.GeneratedMessage {
  factory CreateFeedPostResponse({
    FeedPost? post,
  }) {
    final result = CreateFeedPostResponse._();
    if (post != null) result.post = post;
    return result;
  }

  CreateFeedPostResponse._();

  factory CreateFeedPostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFeedPostResponse()..mergeFromBuffer(data, registry);
  factory CreateFeedPostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateFeedPostResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFeedPostResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateFeedPostResponse.$_createMessage)
    ..aOM<FeedPost>(1, _omitFieldNames ? '' : 'post',
        subBuilder: FeedPost.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedPostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedPostResponse copyWith(
          void Function(CreateFeedPostResponse) updates) =>
      super.copyWith((message) => updates(message as CreateFeedPostResponse))
          as CreateFeedPostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateFeedPostResponse() / CreateFeedPostResponse.new instead')
  static CreateFeedPostResponse create() => CreateFeedPostResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateFeedPostResponse._();
  @$core.override
  CreateFeedPostResponse createEmptyInstance() => CreateFeedPostResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateFeedPostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFeedPostResponse>(
          CreateFeedPostResponse.$_createMessage);
  static CreateFeedPostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedPost get post => $_getN(0);
  @$pb.TagNumber(1)
  set post(FeedPost value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPost() => $_has(0);
  @$pb.TagNumber(1)
  void clearPost() => $_clearField(1);
  @$pb.TagNumber(1)
  FeedPost ensurePost() => $_ensure(0);
}

class CommentFeedPostRequest extends $pb.GeneratedMessage {
  factory CommentFeedPostRequest({
    $core.String? channelId,
    $core.String? postId,
    $core.String? text,
    $core.String? idempotencyKey,
    $core.Iterable<$core.String>? attachmentIds,
  }) {
    final result = CommentFeedPostRequest._();
    if (channelId != null) result.channelId = channelId;
    if (postId != null) result.postId = postId;
    if (text != null) result.text = text;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (attachmentIds != null) result.attachmentIds.addAll(attachmentIds);
    return result;
  }

  CommentFeedPostRequest._();

  factory CommentFeedPostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentFeedPostRequest()..mergeFromBuffer(data, registry);
  factory CommentFeedPostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentFeedPostRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommentFeedPostRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommentFeedPostRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..pPS(5, _omitFieldNames ? '' : 'attachmentIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentFeedPostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentFeedPostRequest copyWith(
          void Function(CommentFeedPostRequest) updates) =>
      super.copyWith((message) => updates(message as CommentFeedPostRequest))
          as CommentFeedPostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommentFeedPostRequest() / CommentFeedPostRequest.new instead')
  static CommentFeedPostRequest create() => CommentFeedPostRequest._();
  static $pb.GeneratedMessage $_createMessage() => CommentFeedPostRequest._();
  @$core.override
  CommentFeedPostRequest createEmptyInstance() => CommentFeedPostRequest._();
  @$core.pragma('dart2js:noInline')
  static CommentFeedPostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommentFeedPostRequest>(
          CommentFeedPostRequest.$_createMessage);
  static CommentFeedPostRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

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

class CommentFeedPostResponse extends $pb.GeneratedMessage {
  factory CommentFeedPostResponse({
    FeedComment? comment,
    FeedPost? post,
  }) {
    final result = CommentFeedPostResponse._();
    if (comment != null) result.comment = comment;
    if (post != null) result.post = post;
    return result;
  }

  CommentFeedPostResponse._();

  factory CommentFeedPostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentFeedPostResponse()..mergeFromBuffer(data, registry);
  factory CommentFeedPostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentFeedPostResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommentFeedPostResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommentFeedPostResponse.$_createMessage)
    ..aOM<FeedComment>(1, _omitFieldNames ? '' : 'comment',
        subBuilder: FeedComment.$_createMessage)
    ..aOM<FeedPost>(2, _omitFieldNames ? '' : 'post',
        subBuilder: FeedPost.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentFeedPostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentFeedPostResponse copyWith(
          void Function(CommentFeedPostResponse) updates) =>
      super.copyWith((message) => updates(message as CommentFeedPostResponse))
          as CommentFeedPostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommentFeedPostResponse() / CommentFeedPostResponse.new instead')
  static CommentFeedPostResponse create() => CommentFeedPostResponse._();
  static $pb.GeneratedMessage $_createMessage() => CommentFeedPostResponse._();
  @$core.override
  CommentFeedPostResponse createEmptyInstance() => CommentFeedPostResponse._();
  @$core.pragma('dart2js:noInline')
  static CommentFeedPostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommentFeedPostResponse>(
          CommentFeedPostResponse.$_createMessage);
  static CommentFeedPostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedComment get comment => $_getN(0);
  @$pb.TagNumber(1)
  set comment(FeedComment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComment() => $_has(0);
  @$pb.TagNumber(1)
  void clearComment() => $_clearField(1);
  @$pb.TagNumber(1)
  FeedComment ensureComment() => $_ensure(0);

  @$pb.TagNumber(2)
  FeedPost get post => $_getN(1);
  @$pb.TagNumber(2)
  set post(FeedPost value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPost() => $_has(1);
  @$pb.TagNumber(2)
  void clearPost() => $_clearField(2);
  @$pb.TagNumber(2)
  FeedPost ensurePost() => $_ensure(1);
}

/// Ровно один субъект: role=member/reader либо principal_id.
/// Индивидуальное правило заменяет правило роли; отсутствие = запрет.
class FeedAccessRule extends $pb.GeneratedMessage {
  factory FeedAccessRule({
    $core.String? role,
    $core.String? principalId,
    FeedPermissions? permissions,
  }) {
    final result = FeedAccessRule._();
    if (role != null) result.role = role;
    if (principalId != null) result.principalId = principalId;
    if (permissions != null) result.permissions = permissions;
    return result;
  }

  FeedAccessRule._();

  factory FeedAccessRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedAccessRule()..mergeFromBuffer(data, registry);
  factory FeedAccessRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedAccessRule()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedAccessRule',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: FeedAccessRule.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aOS(2, _omitFieldNames ? '' : 'principalId')
    ..aOM<FeedPermissions>(3, _omitFieldNames ? '' : 'permissions',
        subBuilder: FeedPermissions.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedAccessRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedAccessRule copyWith(void Function(FeedAccessRule) updates) =>
      super.copyWith((message) => updates(message as FeedAccessRule))
          as FeedAccessRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeedAccessRule() / FeedAccessRule.new instead')
  static FeedAccessRule create() => FeedAccessRule._();
  static $pb.GeneratedMessage $_createMessage() => FeedAccessRule._();
  @$core.override
  FeedAccessRule createEmptyInstance() => FeedAccessRule._();
  @$core.pragma('dart2js:noInline')
  static FeedAccessRule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedAccessRule>(
          FeedAccessRule.$_createMessage);
  static FeedAccessRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get principalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set principalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrincipalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalId() => $_clearField(2);

  @$pb.TagNumber(3)
  FeedPermissions get permissions => $_getN(2);
  @$pb.TagNumber(3)
  set permissions(FeedPermissions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPermissions() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissions() => $_clearField(3);
  @$pb.TagNumber(3)
  FeedPermissions ensurePermissions() => $_ensure(2);
}

/// Получение и изменение правил требует read/manage и space.manage.
class GetFeedAccessRequest extends $pb.GeneratedMessage {
  factory GetFeedAccessRequest({
    $core.String? channelId,
  }) {
    final result = GetFeedAccessRequest._();
    if (channelId != null) result.channelId = channelId;
    return result;
  }

  GetFeedAccessRequest._();

  factory GetFeedAccessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedAccessRequest()..mergeFromBuffer(data, registry);
  factory GetFeedAccessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedAccessRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFeedAccessRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetFeedAccessRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedAccessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedAccessRequest copyWith(void Function(GetFeedAccessRequest) updates) =>
      super.copyWith((message) => updates(message as GetFeedAccessRequest))
          as GetFeedAccessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetFeedAccessRequest() / GetFeedAccessRequest.new instead')
  static GetFeedAccessRequest create() => GetFeedAccessRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetFeedAccessRequest._();
  @$core.override
  GetFeedAccessRequest createEmptyInstance() => GetFeedAccessRequest._();
  @$core.pragma('dart2js:noInline')
  static GetFeedAccessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFeedAccessRequest>(
          GetFeedAccessRequest.$_createMessage);
  static GetFeedAccessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);
}

class GetFeedAccessResponse extends $pb.GeneratedMessage {
  factory GetFeedAccessResponse({
    $core.String? channelId,
    $fixnum.Int64? revision,
    $core.Iterable<FeedAccessRule>? rules,
  }) {
    final result = GetFeedAccessResponse._();
    if (channelId != null) result.channelId = channelId;
    if (revision != null) result.revision = revision;
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  GetFeedAccessResponse._();

  factory GetFeedAccessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedAccessResponse()..mergeFromBuffer(data, registry);
  factory GetFeedAccessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetFeedAccessResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFeedAccessResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetFeedAccessResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..pPM<FeedAccessRule>(3, _omitFieldNames ? '' : 'rules',
        subBuilder: FeedAccessRule.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedAccessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFeedAccessResponse copyWith(
          void Function(GetFeedAccessResponse) updates) =>
      super.copyWith((message) => updates(message as GetFeedAccessResponse))
          as GetFeedAccessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetFeedAccessResponse() / GetFeedAccessResponse.new instead')
  static GetFeedAccessResponse create() => GetFeedAccessResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetFeedAccessResponse._();
  @$core.override
  GetFeedAccessResponse createEmptyInstance() => GetFeedAccessResponse._();
  @$core.pragma('dart2js:noInline')
  static GetFeedAccessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFeedAccessResponse>(
          GetFeedAccessResponse.$_createMessage);
  static GetFeedAccessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FeedAccessRule> get rules => $_getList(2);
}

class UpdateFeedAccessRequest extends $pb.GeneratedMessage {
  factory UpdateFeedAccessRequest({
    $core.String? channelId,
    $fixnum.Int64? expectedRevision,
    $core.Iterable<FeedAccessRule>? rules,
  }) {
    final result = UpdateFeedAccessRequest._();
    if (channelId != null) result.channelId = channelId;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  UpdateFeedAccessRequest._();

  factory UpdateFeedAccessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateFeedAccessRequest()..mergeFromBuffer(data, registry);
  factory UpdateFeedAccessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateFeedAccessRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateFeedAccessRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateFeedAccessRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedRevision')
    ..pPM<FeedAccessRule>(3, _omitFieldNames ? '' : 'rules',
        subBuilder: FeedAccessRule.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFeedAccessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFeedAccessRequest copyWith(
          void Function(UpdateFeedAccessRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateFeedAccessRequest))
          as UpdateFeedAccessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateFeedAccessRequest() / UpdateFeedAccessRequest.new instead')
  static UpdateFeedAccessRequest create() => UpdateFeedAccessRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateFeedAccessRequest._();
  @$core.override
  UpdateFeedAccessRequest createEmptyInstance() => UpdateFeedAccessRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateFeedAccessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateFeedAccessRequest>(
          UpdateFeedAccessRequest.$_createMessage);
  static UpdateFeedAccessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedRevision => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FeedAccessRule> get rules => $_getList(2);
}

class UpdateFeedAccessResponse extends $pb.GeneratedMessage {
  factory UpdateFeedAccessResponse({
    $core.String? channelId,
    $fixnum.Int64? revision,
    $core.Iterable<FeedAccessRule>? rules,
  }) {
    final result = UpdateFeedAccessResponse._();
    if (channelId != null) result.channelId = channelId;
    if (revision != null) result.revision = revision;
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  UpdateFeedAccessResponse._();

  factory UpdateFeedAccessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateFeedAccessResponse()..mergeFromBuffer(data, registry);
  factory UpdateFeedAccessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateFeedAccessResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateFeedAccessResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateFeedAccessResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..pPM<FeedAccessRule>(3, _omitFieldNames ? '' : 'rules',
        subBuilder: FeedAccessRule.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFeedAccessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFeedAccessResponse copyWith(
          void Function(UpdateFeedAccessResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateFeedAccessResponse))
          as UpdateFeedAccessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateFeedAccessResponse() / UpdateFeedAccessResponse.new instead')
  static UpdateFeedAccessResponse create() => UpdateFeedAccessResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateFeedAccessResponse._();
  @$core.override
  UpdateFeedAccessResponse createEmptyInstance() =>
      UpdateFeedAccessResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateFeedAccessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateFeedAccessResponse>(
          UpdateFeedAccessResponse.$_createMessage);
  static UpdateFeedAccessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FeedAccessRule> get rules => $_getList(2);
}

/// Обе операции требуют read/manage, space.manage, причину 1..1024 байт.
class ModerateFeedPostRequest extends $pb.GeneratedMessage {
  factory ModerateFeedPostRequest({
    $core.String? channelId,
    $core.String? postId,
    $core.bool? hidden,
    $core.String? reason,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = ModerateFeedPostRequest._();
    if (channelId != null) result.channelId = channelId;
    if (postId != null) result.postId = postId;
    if (hidden != null) result.hidden = hidden;
    if (reason != null) result.reason = reason;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ModerateFeedPostRequest._();

  factory ModerateFeedPostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedPostRequest()..mergeFromBuffer(data, registry);
  factory ModerateFeedPostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedPostRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateFeedPostRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateFeedPostRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aOB(3, _omitFieldNames ? '' : 'hidden')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedPostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedPostRequest copyWith(
          void Function(ModerateFeedPostRequest) updates) =>
      super.copyWith((message) => updates(message as ModerateFeedPostRequest))
          as ModerateFeedPostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateFeedPostRequest() / ModerateFeedPostRequest.new instead')
  static ModerateFeedPostRequest create() => ModerateFeedPostRequest._();
  static $pb.GeneratedMessage $_createMessage() => ModerateFeedPostRequest._();
  @$core.override
  ModerateFeedPostRequest createEmptyInstance() => ModerateFeedPostRequest._();
  @$core.pragma('dart2js:noInline')
  static ModerateFeedPostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateFeedPostRequest>(
          ModerateFeedPostRequest.$_createMessage);
  static ModerateFeedPostRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hidden => $_getBF(2);
  @$pb.TagNumber(3)
  set hidden($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHidden() => $_has(2);
  @$pb.TagNumber(3)
  void clearHidden() => $_clearField(3);

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

class ModerateFeedPostResponse extends $pb.GeneratedMessage {
  factory ModerateFeedPostResponse({
    FeedPost? post,
  }) {
    final result = ModerateFeedPostResponse._();
    if (post != null) result.post = post;
    return result;
  }

  ModerateFeedPostResponse._();

  factory ModerateFeedPostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedPostResponse()..mergeFromBuffer(data, registry);
  factory ModerateFeedPostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedPostResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateFeedPostResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateFeedPostResponse.$_createMessage)
    ..aOM<FeedPost>(1, _omitFieldNames ? '' : 'post',
        subBuilder: FeedPost.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedPostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedPostResponse copyWith(
          void Function(ModerateFeedPostResponse) updates) =>
      super.copyWith((message) => updates(message as ModerateFeedPostResponse))
          as ModerateFeedPostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateFeedPostResponse() / ModerateFeedPostResponse.new instead')
  static ModerateFeedPostResponse create() => ModerateFeedPostResponse._();
  static $pb.GeneratedMessage $_createMessage() => ModerateFeedPostResponse._();
  @$core.override
  ModerateFeedPostResponse createEmptyInstance() =>
      ModerateFeedPostResponse._();
  @$core.pragma('dart2js:noInline')
  static ModerateFeedPostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateFeedPostResponse>(
          ModerateFeedPostResponse.$_createMessage);
  static ModerateFeedPostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedPost get post => $_getN(0);
  @$pb.TagNumber(1)
  set post(FeedPost value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPost() => $_has(0);
  @$pb.TagNumber(1)
  void clearPost() => $_clearField(1);
  @$pb.TagNumber(1)
  FeedPost ensurePost() => $_ensure(0);
}

class ModerateFeedCommentRequest extends $pb.GeneratedMessage {
  factory ModerateFeedCommentRequest({
    $core.String? channelId,
    $core.String? postId,
    $core.String? commentId,
    $core.bool? hidden,
    $core.String? reason,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = ModerateFeedCommentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (postId != null) result.postId = postId;
    if (commentId != null) result.commentId = commentId;
    if (hidden != null) result.hidden = hidden;
    if (reason != null) result.reason = reason;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ModerateFeedCommentRequest._();

  factory ModerateFeedCommentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedCommentRequest()..mergeFromBuffer(data, registry);
  factory ModerateFeedCommentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedCommentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateFeedCommentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateFeedCommentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aOS(3, _omitFieldNames ? '' : 'commentId')
    ..aOB(4, _omitFieldNames ? '' : 'hidden')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aInt64(6, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedCommentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedCommentRequest copyWith(
          void Function(ModerateFeedCommentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ModerateFeedCommentRequest))
          as ModerateFeedCommentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateFeedCommentRequest() / ModerateFeedCommentRequest.new instead')
  static ModerateFeedCommentRequest create() => ModerateFeedCommentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ModerateFeedCommentRequest._();
  @$core.override
  ModerateFeedCommentRequest createEmptyInstance() =>
      ModerateFeedCommentRequest._();
  @$core.pragma('dart2js:noInline')
  static ModerateFeedCommentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateFeedCommentRequest>(
          ModerateFeedCommentRequest.$_createMessage);
  static ModerateFeedCommentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set commentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentId() => $_clearField(3);

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

class ModerateFeedCommentResponse extends $pb.GeneratedMessage {
  factory ModerateFeedCommentResponse({
    FeedComment? comment,
    FeedPost? post,
  }) {
    final result = ModerateFeedCommentResponse._();
    if (comment != null) result.comment = comment;
    if (post != null) result.post = post;
    return result;
  }

  ModerateFeedCommentResponse._();

  factory ModerateFeedCommentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedCommentResponse()..mergeFromBuffer(data, registry);
  factory ModerateFeedCommentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerateFeedCommentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateFeedCommentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ModerateFeedCommentResponse.$_createMessage)
    ..aOM<FeedComment>(1, _omitFieldNames ? '' : 'comment',
        subBuilder: FeedComment.$_createMessage)
    ..aOM<FeedPost>(2, _omitFieldNames ? '' : 'post',
        subBuilder: FeedPost.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedCommentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateFeedCommentResponse copyWith(
          void Function(ModerateFeedCommentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ModerateFeedCommentResponse))
          as ModerateFeedCommentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ModerateFeedCommentResponse() / ModerateFeedCommentResponse.new instead')
  static ModerateFeedCommentResponse create() =>
      ModerateFeedCommentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ModerateFeedCommentResponse._();
  @$core.override
  ModerateFeedCommentResponse createEmptyInstance() =>
      ModerateFeedCommentResponse._();
  @$core.pragma('dart2js:noInline')
  static ModerateFeedCommentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateFeedCommentResponse>(
          ModerateFeedCommentResponse.$_createMessage);
  static ModerateFeedCommentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedComment get comment => $_getN(0);
  @$pb.TagNumber(1)
  set comment(FeedComment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComment() => $_has(0);
  @$pb.TagNumber(1)
  void clearComment() => $_clearField(1);
  @$pb.TagNumber(1)
  FeedComment ensureComment() => $_ensure(0);

  @$pb.TagNumber(2)
  FeedPost get post => $_getN(1);
  @$pb.TagNumber(2)
  set post(FeedPost value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPost() => $_has(1);
  @$pb.TagNumber(2)
  void clearPost() => $_clearField(2);
  @$pb.TagNumber(2)
  FeedPost ensurePost() => $_ensure(1);
}

/// Журнал доступен только модератору; курсор id ASC, 0 начинает чтение.
class ListFeedModerationRequest extends $pb.GeneratedMessage {
  factory ListFeedModerationRequest({
    $core.String? channelId,
    $core.String? postId,
    $fixnum.Int64? afterId,
    $core.int? limit,
  }) {
    final result = ListFeedModerationRequest._();
    if (channelId != null) result.channelId = channelId;
    if (postId != null) result.postId = postId;
    if (afterId != null) result.afterId = afterId;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListFeedModerationRequest._();

  factory ListFeedModerationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedModerationRequest()..mergeFromBuffer(data, registry);
  factory ListFeedModerationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedModerationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFeedModerationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFeedModerationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aInt64(3, _omitFieldNames ? '' : 'afterId')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedModerationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedModerationRequest copyWith(
          void Function(ListFeedModerationRequest) updates) =>
      super.copyWith((message) => updates(message as ListFeedModerationRequest))
          as ListFeedModerationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFeedModerationRequest() / ListFeedModerationRequest.new instead')
  static ListFeedModerationRequest create() => ListFeedModerationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListFeedModerationRequest._();
  @$core.override
  ListFeedModerationRequest createEmptyInstance() =>
      ListFeedModerationRequest._();
  @$core.pragma('dart2js:noInline')
  static ListFeedModerationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFeedModerationRequest>(
          ListFeedModerationRequest.$_createMessage);
  static ListFeedModerationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

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

class FeedModerationEvent extends $pb.GeneratedMessage {
  factory FeedModerationEvent({
    $fixnum.Int64? id,
    $core.String? postId,
    $core.String? commentId,
    $core.String? action,
    $core.String? reason,
    $core.String? actorId,
    $fixnum.Int64? revision,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? reportId,
  }) {
    final result = FeedModerationEvent._();
    if (id != null) result.id = id;
    if (postId != null) result.postId = postId;
    if (commentId != null) result.commentId = commentId;
    if (action != null) result.action = action;
    if (reason != null) result.reason = reason;
    if (actorId != null) result.actorId = actorId;
    if (revision != null) result.revision = revision;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (reportId != null) result.reportId = reportId;
    return result;
  }

  FeedModerationEvent._();

  factory FeedModerationEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedModerationEvent()..mergeFromBuffer(data, registry);
  factory FeedModerationEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedModerationEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedModerationEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: FeedModerationEvent.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aOS(3, _omitFieldNames ? '' : 'commentId')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOS(6, _omitFieldNames ? '' : 'actorId')
    ..aInt64(7, _omitFieldNames ? '' : 'revision')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(9, _omitFieldNames ? '' : 'reportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedModerationEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedModerationEvent copyWith(void Function(FeedModerationEvent) updates) =>
      super.copyWith((message) => updates(message as FeedModerationEvent))
          as FeedModerationEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use FeedModerationEvent() / FeedModerationEvent.new instead')
  static FeedModerationEvent create() => FeedModerationEvent._();
  static $pb.GeneratedMessage $_createMessage() => FeedModerationEvent._();
  @$core.override
  FeedModerationEvent createEmptyInstance() => FeedModerationEvent._();
  @$core.pragma('dart2js:noInline')
  static FeedModerationEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FeedModerationEvent>(
          FeedModerationEvent.$_createMessage);
  static FeedModerationEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set commentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentId() => $_clearField(3);

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

  @$pb.TagNumber(9)
  $fixnum.Int64 get reportId => $_getI64(8);
  @$pb.TagNumber(9)
  set reportId($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReportId() => $_has(8);
  @$pb.TagNumber(9)
  void clearReportId() => $_clearField(9);
}

class ListFeedModerationResponse extends $pb.GeneratedMessage {
  factory ListFeedModerationResponse({
    $core.Iterable<FeedModerationEvent>? events,
    $fixnum.Int64? nextId,
  }) {
    final result = ListFeedModerationResponse._();
    if (events != null) result.events.addAll(events);
    if (nextId != null) result.nextId = nextId;
    return result;
  }

  ListFeedModerationResponse._();

  factory ListFeedModerationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedModerationResponse()..mergeFromBuffer(data, registry);
  factory ListFeedModerationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedModerationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFeedModerationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFeedModerationResponse.$_createMessage)
    ..pPM<FeedModerationEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: FeedModerationEvent.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedModerationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedModerationResponse copyWith(
          void Function(ListFeedModerationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListFeedModerationResponse))
          as ListFeedModerationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFeedModerationResponse() / ListFeedModerationResponse.new instead')
  static ListFeedModerationResponse create() => ListFeedModerationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListFeedModerationResponse._();
  @$core.override
  ListFeedModerationResponse createEmptyInstance() =>
      ListFeedModerationResponse._();
  @$core.pragma('dart2js:noInline')
  static ListFeedModerationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFeedModerationResponse>(
          ListFeedModerationResponse.$_createMessage);
  static ListFeedModerationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FeedModerationEvent> get events => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextId => $_getI64(1);
  @$pb.TagNumber(2)
  set nextId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextId() => $_clearField(2);
}

/// Не содержит заявителя или копий исходного текста/файлов.
class FeedReport extends $pb.GeneratedMessage {
  factory FeedReport({
    $fixnum.Int64? id,
    $core.String? postId,
    $core.String? commentId,
    $core.String? reason,
    $core.String? decision,
    $core.String? decisionReason,
    $core.String? moderatorId,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? resolvedAtUnix,
  }) {
    final result = FeedReport._();
    if (id != null) result.id = id;
    if (postId != null) result.postId = postId;
    if (commentId != null) result.commentId = commentId;
    if (reason != null) result.reason = reason;
    if (decision != null) result.decision = decision;
    if (decisionReason != null) result.decisionReason = decisionReason;
    if (moderatorId != null) result.moderatorId = moderatorId;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (resolvedAtUnix != null) result.resolvedAtUnix = resolvedAtUnix;
    return result;
  }

  FeedReport._();

  factory FeedReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedReport()..mergeFromBuffer(data, registry);
  factory FeedReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedReport()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: FeedReport.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aOS(3, _omitFieldNames ? '' : 'commentId')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'decision')
    ..aOS(6, _omitFieldNames ? '' : 'decisionReason')
    ..aOS(7, _omitFieldNames ? '' : 'moderatorId')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(9, _omitFieldNames ? '' : 'resolvedAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedReport copyWith(void Function(FeedReport) updates) =>
      super.copyWith((message) => updates(message as FeedReport)) as FeedReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeedReport() / FeedReport.new instead')
  static FeedReport create() => FeedReport._();
  static $pb.GeneratedMessage $_createMessage() => FeedReport._();
  @$core.override
  FeedReport createEmptyInstance() => FeedReport._();
  @$core.pragma('dart2js:noInline')
  static FeedReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FeedReport>(FeedReport.$_createMessage);
  static FeedReport? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set commentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get decision => $_getSZ(4);
  @$pb.TagNumber(5)
  set decision($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDecision() => $_has(4);
  @$pb.TagNumber(5)
  void clearDecision() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get decisionReason => $_getSZ(5);
  @$pb.TagNumber(6)
  set decisionReason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDecisionReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearDecisionReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get moderatorId => $_getSZ(6);
  @$pb.TagNumber(7)
  set moderatorId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasModeratorId() => $_has(6);
  @$pb.TagNumber(7)
  void clearModeratorId() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAtUnix => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAtUnix() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAtUnix() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get resolvedAtUnix => $_getI64(8);
  @$pb.TagNumber(9)
  set resolvedAtUnix($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasResolvedAtUnix() => $_has(8);
  @$pb.TagNumber(9)
  void clearResolvedAtUnix() => $_clearField(9);
}

/// Доступно читателю; comment_id пусто для жалобы на публикацию.
class ReportFeedContentRequest extends $pb.GeneratedMessage {
  factory ReportFeedContentRequest({
    $core.String? channelId,
    $core.String? postId,
    $core.String? commentId,
    $core.String? reason,
  }) {
    final result = ReportFeedContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (postId != null) result.postId = postId;
    if (commentId != null) result.commentId = commentId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReportFeedContentRequest._();

  factory ReportFeedContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportFeedContentRequest()..mergeFromBuffer(data, registry);
  factory ReportFeedContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportFeedContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportFeedContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReportFeedContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'postId')
    ..aOS(3, _omitFieldNames ? '' : 'commentId')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportFeedContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportFeedContentRequest copyWith(
          void Function(ReportFeedContentRequest) updates) =>
      super.copyWith((message) => updates(message as ReportFeedContentRequest))
          as ReportFeedContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReportFeedContentRequest() / ReportFeedContentRequest.new instead')
  static ReportFeedContentRequest create() => ReportFeedContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReportFeedContentRequest._();
  @$core.override
  ReportFeedContentRequest createEmptyInstance() =>
      ReportFeedContentRequest._();
  @$core.pragma('dart2js:noInline')
  static ReportFeedContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportFeedContentRequest>(
          ReportFeedContentRequest.$_createMessage);
  static ReportFeedContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get postId => $_getSZ(1);
  @$pb.TagNumber(2)
  set postId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set commentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class ReportFeedContentResponse extends $pb.GeneratedMessage {
  factory ReportFeedContentResponse() => ReportFeedContentResponse._();

  ReportFeedContentResponse._();

  factory ReportFeedContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportFeedContentResponse()..mergeFromBuffer(data, registry);
  factory ReportFeedContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportFeedContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportFeedContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReportFeedContentResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportFeedContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportFeedContentResponse copyWith(
          void Function(ReportFeedContentResponse) updates) =>
      super.copyWith((message) => updates(message as ReportFeedContentResponse))
          as ReportFeedContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReportFeedContentResponse() / ReportFeedContentResponse.new instead')
  static ReportFeedContentResponse create() => ReportFeedContentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReportFeedContentResponse._();
  @$core.override
  ReportFeedContentResponse createEmptyInstance() =>
      ReportFeedContentResponse._();
  @$core.pragma('dart2js:noInline')
  static ReportFeedContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportFeedContentResponse>(
          ReportFeedContentResponse.$_createMessage);
  static ReportFeedContentResponse? _defaultInstance;
}

class ListFeedReportsRequest extends $pb.GeneratedMessage {
  factory ListFeedReportsRequest({
    $core.String? channelId,
    $fixnum.Int64? afterId,
    $core.int? limit,
    $core.bool? resolved,
  }) {
    final result = ListFeedReportsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (afterId != null) result.afterId = afterId;
    if (limit != null) result.limit = limit;
    if (resolved != null) result.resolved = resolved;
    return result;
  }

  ListFeedReportsRequest._();

  factory ListFeedReportsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedReportsRequest()..mergeFromBuffer(data, registry);
  factory ListFeedReportsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedReportsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFeedReportsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFeedReportsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'afterId')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aOB(4, _omitFieldNames ? '' : 'resolved')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedReportsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedReportsRequest copyWith(
          void Function(ListFeedReportsRequest) updates) =>
      super.copyWith((message) => updates(message as ListFeedReportsRequest))
          as ListFeedReportsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFeedReportsRequest() / ListFeedReportsRequest.new instead')
  static ListFeedReportsRequest create() => ListFeedReportsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListFeedReportsRequest._();
  @$core.override
  ListFeedReportsRequest createEmptyInstance() => ListFeedReportsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListFeedReportsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFeedReportsRequest>(
          ListFeedReportsRequest.$_createMessage);
  static ListFeedReportsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get afterId => $_getI64(1);
  @$pb.TagNumber(2)
  set afterId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get resolved => $_getBF(3);
  @$pb.TagNumber(4)
  set resolved($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResolved() => $_has(3);
  @$pb.TagNumber(4)
  void clearResolved() => $_clearField(4);
}

class ListFeedReportsResponse extends $pb.GeneratedMessage {
  factory ListFeedReportsResponse({
    $core.Iterable<FeedReport>? reports,
    $fixnum.Int64? nextId,
  }) {
    final result = ListFeedReportsResponse._();
    if (reports != null) result.reports.addAll(reports);
    if (nextId != null) result.nextId = nextId;
    return result;
  }

  ListFeedReportsResponse._();

  factory ListFeedReportsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedReportsResponse()..mergeFromBuffer(data, registry);
  factory ListFeedReportsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFeedReportsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFeedReportsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListFeedReportsResponse.$_createMessage)
    ..pPM<FeedReport>(1, _omitFieldNames ? '' : 'reports',
        subBuilder: FeedReport.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedReportsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFeedReportsResponse copyWith(
          void Function(ListFeedReportsResponse) updates) =>
      super.copyWith((message) => updates(message as ListFeedReportsResponse))
          as ListFeedReportsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFeedReportsResponse() / ListFeedReportsResponse.new instead')
  static ListFeedReportsResponse create() => ListFeedReportsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListFeedReportsResponse._();
  @$core.override
  ListFeedReportsResponse createEmptyInstance() => ListFeedReportsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListFeedReportsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFeedReportsResponse>(
          ListFeedReportsResponse.$_createMessage);
  static ListFeedReportsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FeedReport> get reports => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextId => $_getI64(1);
  @$pb.TagNumber(2)
  set nextId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextId() => $_clearField(2);
}

class ResolveFeedReportRequest extends $pb.GeneratedMessage {
  factory ResolveFeedReportRequest({
    $core.String? channelId,
    $fixnum.Int64? reportId,
    $core.String? decision,
    $core.String? reason,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = ResolveFeedReportRequest._();
    if (channelId != null) result.channelId = channelId;
    if (reportId != null) result.reportId = reportId;
    if (decision != null) result.decision = decision;
    if (reason != null) result.reason = reason;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  ResolveFeedReportRequest._();

  factory ResolveFeedReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveFeedReportRequest()..mergeFromBuffer(data, registry);
  factory ResolveFeedReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveFeedReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveFeedReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ResolveFeedReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aInt64(2, _omitFieldNames ? '' : 'reportId')
    ..aOS(3, _omitFieldNames ? '' : 'decision')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveFeedReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveFeedReportRequest copyWith(
          void Function(ResolveFeedReportRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveFeedReportRequest))
          as ResolveFeedReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResolveFeedReportRequest() / ResolveFeedReportRequest.new instead')
  static ResolveFeedReportRequest create() => ResolveFeedReportRequest._();
  static $pb.GeneratedMessage $_createMessage() => ResolveFeedReportRequest._();
  @$core.override
  ResolveFeedReportRequest createEmptyInstance() =>
      ResolveFeedReportRequest._();
  @$core.pragma('dart2js:noInline')
  static ResolveFeedReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveFeedReportRequest>(
          ResolveFeedReportRequest.$_createMessage);
  static ResolveFeedReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get reportId => $_getI64(1);
  @$pb.TagNumber(2)
  set reportId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReportId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReportId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get decision => $_getSZ(2);
  @$pb.TagNumber(3)
  set decision($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDecision() => $_has(2);
  @$pb.TagNumber(3)
  void clearDecision() => $_clearField(3);

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

class ResolveFeedReportResponse extends $pb.GeneratedMessage {
  factory ResolveFeedReportResponse({
    FeedReport? report,
  }) {
    final result = ResolveFeedReportResponse._();
    if (report != null) result.report = report;
    return result;
  }

  ResolveFeedReportResponse._();

  factory ResolveFeedReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveFeedReportResponse()..mergeFromBuffer(data, registry);
  factory ResolveFeedReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResolveFeedReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveFeedReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ResolveFeedReportResponse.$_createMessage)
    ..aOM<FeedReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: FeedReport.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveFeedReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveFeedReportResponse copyWith(
          void Function(ResolveFeedReportResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveFeedReportResponse))
          as ResolveFeedReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ResolveFeedReportResponse() / ResolveFeedReportResponse.new instead')
  static ResolveFeedReportResponse create() => ResolveFeedReportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ResolveFeedReportResponse._();
  @$core.override
  ResolveFeedReportResponse createEmptyInstance() =>
      ResolveFeedReportResponse._();
  @$core.pragma('dart2js:noInline')
  static ResolveFeedReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveFeedReportResponse>(
          ResolveFeedReportResponse.$_createMessage);
  static ResolveFeedReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(FeedReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  FeedReport ensureReport() => $_ensure(0);
}

/// core.feed.v1: экспериментальная лента публикаций по ADR-046.
class FeedServiceApi {
  final $pb.RpcClient _client;

  FeedServiceApi(this._client);

  $async.Future<ListFeedPostsResponse> listFeedPosts(
          $pb.ClientContext? ctx, ListFeedPostsRequest request) =>
      _client.invoke<ListFeedPostsResponse>(ctx, 'FeedService', 'ListFeedPosts',
          request, ListFeedPostsResponse());
  $async.Future<GetFeedPostResponse> getFeedPost(
          $pb.ClientContext? ctx, GetFeedPostRequest request) =>
      _client.invoke<GetFeedPostResponse>(
          ctx, 'FeedService', 'GetFeedPost', request, GetFeedPostResponse());
  $async.Future<CreateFeedPostResponse> createFeedPost(
          $pb.ClientContext? ctx, CreateFeedPostRequest request) =>
      _client.invoke<CreateFeedPostResponse>(ctx, 'FeedService',
          'CreateFeedPost', request, CreateFeedPostResponse());
  $async.Future<CommentFeedPostResponse> commentFeedPost(
          $pb.ClientContext? ctx, CommentFeedPostRequest request) =>
      _client.invoke<CommentFeedPostResponse>(ctx, 'FeedService',
          'CommentFeedPost', request, CommentFeedPostResponse());
  $async.Future<GetFeedAccessResponse> getFeedAccess(
          $pb.ClientContext? ctx, GetFeedAccessRequest request) =>
      _client.invoke<GetFeedAccessResponse>(ctx, 'FeedService', 'GetFeedAccess',
          request, GetFeedAccessResponse());
  $async.Future<UpdateFeedAccessResponse> updateFeedAccess(
          $pb.ClientContext? ctx, UpdateFeedAccessRequest request) =>
      _client.invoke<UpdateFeedAccessResponse>(ctx, 'FeedService',
          'UpdateFeedAccess', request, UpdateFeedAccessResponse());
  $async.Future<ModerateFeedPostResponse> moderateFeedPost(
          $pb.ClientContext? ctx, ModerateFeedPostRequest request) =>
      _client.invoke<ModerateFeedPostResponse>(ctx, 'FeedService',
          'ModerateFeedPost', request, ModerateFeedPostResponse());
  $async.Future<ModerateFeedCommentResponse> moderateFeedComment(
          $pb.ClientContext? ctx, ModerateFeedCommentRequest request) =>
      _client.invoke<ModerateFeedCommentResponse>(ctx, 'FeedService',
          'ModerateFeedComment', request, ModerateFeedCommentResponse());
  $async.Future<ListFeedModerationResponse> listFeedModeration(
          $pb.ClientContext? ctx, ListFeedModerationRequest request) =>
      _client.invoke<ListFeedModerationResponse>(ctx, 'FeedService',
          'ListFeedModeration', request, ListFeedModerationResponse());
  $async.Future<ReportFeedContentResponse> reportFeedContent(
          $pb.ClientContext? ctx, ReportFeedContentRequest request) =>
      _client.invoke<ReportFeedContentResponse>(ctx, 'FeedService',
          'ReportFeedContent', request, ReportFeedContentResponse());
  $async.Future<ListFeedReportsResponse> listFeedReports(
          $pb.ClientContext? ctx, ListFeedReportsRequest request) =>
      _client.invoke<ListFeedReportsResponse>(ctx, 'FeedService',
          'ListFeedReports', request, ListFeedReportsResponse());
  $async.Future<ResolveFeedReportResponse> resolveFeedReport(
          $pb.ClientContext? ctx, ResolveFeedReportRequest request) =>
      _client.invoke<ResolveFeedReportResponse>(ctx, 'FeedService',
          'ResolveFeedReport', request, ResolveFeedReportResponse());

  /// core.feed.read.v1: персональная монотонная отметка, общая для устройств.
  $async.Future<MarkFeedPostReadResponse> markFeedPostRead(
          $pb.ClientContext? ctx, MarkFeedPostReadRequest request) =>
      _client.invoke<MarkFeedPostReadResponse>(ctx, 'FeedService',
          'MarkFeedPostRead', request, MarkFeedPostReadResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
