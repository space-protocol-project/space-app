// This is a generated file - do not edit.
//
// Generated from space/v1/community_reactions.proto.

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

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CommunityReaction extends $pb.GeneratedMessage {
  factory CommunityReaction({
    $core.String? emoji,
    $fixnum.Int64? count,
    $core.bool? selected,
  }) {
    final result = CommunityReaction._();
    if (emoji != null) result.emoji = emoji;
    if (count != null) result.count = count;
    if (selected != null) result.selected = selected;
    return result;
  }

  CommunityReaction._();

  factory CommunityReaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityReaction()..mergeFromBuffer(data, registry);
  factory CommunityReaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityReaction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunityReaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunityReaction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'emoji')
    ..aInt64(2, _omitFieldNames ? '' : 'count')
    ..aOB(3, _omitFieldNames ? '' : 'selected')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityReaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityReaction copyWith(void Function(CommunityReaction) updates) =>
      super.copyWith((message) => updates(message as CommunityReaction))
          as CommunityReaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CommunityReaction() / CommunityReaction.new instead')
  static CommunityReaction create() => CommunityReaction._();
  static $pb.GeneratedMessage $_createMessage() => CommunityReaction._();
  @$core.override
  CommunityReaction createEmptyInstance() => CommunityReaction._();
  @$core.pragma('dart2js:noInline')
  static CommunityReaction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommunityReaction>(
          CommunityReaction.$_createMessage);
  static CommunityReaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get emoji => $_getSZ(0);
  @$pb.TagNumber(1)
  set emoji($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmoji() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmoji() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get count => $_getI64(1);
  @$pb.TagNumber(2)
  set count($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get selected => $_getBF(2);
  @$pb.TagNumber(3)
  set selected($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSelected() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelected() => $_clearField(3);
}

class CommunityReactionState extends $pb.GeneratedMessage {
  factory CommunityReactionState({
    $0.CommunityContentReference? content,
    $fixnum.Int64? revision,
    $core.Iterable<CommunityReaction>? reactions,
    $core.bool? canReact,
  }) {
    final result = CommunityReactionState._();
    if (content != null) result.content = content;
    if (revision != null) result.revision = revision;
    if (reactions != null) result.reactions.addAll(reactions);
    if (canReact != null) result.canReact = canReact;
    return result;
  }

  CommunityReactionState._();

  factory CommunityReactionState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityReactionState()..mergeFromBuffer(data, registry);
  factory CommunityReactionState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommunityReactionState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunityReactionState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CommunityReactionState.$_createMessage)
    ..aOM<$0.CommunityContentReference>(1, _omitFieldNames ? '' : 'content',
        subBuilder: $0.CommunityContentReference.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..pPM<CommunityReaction>(3, _omitFieldNames ? '' : 'reactions',
        subBuilder: CommunityReaction.$_createMessage)
    ..aOB(4, _omitFieldNames ? '' : 'canReact')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityReactionState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunityReactionState copyWith(
          void Function(CommunityReactionState) updates) =>
      super.copyWith((message) => updates(message as CommunityReactionState))
          as CommunityReactionState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommunityReactionState() / CommunityReactionState.new instead')
  static CommunityReactionState create() => CommunityReactionState._();
  static $pb.GeneratedMessage $_createMessage() => CommunityReactionState._();
  @$core.override
  CommunityReactionState createEmptyInstance() => CommunityReactionState._();
  @$core.pragma('dart2js:noInline')
  static CommunityReactionState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommunityReactionState>(
          CommunityReactionState.$_createMessage);
  static CommunityReactionState? _defaultInstance;

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
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<CommunityReaction> get reactions => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get canReact => $_getBF(3);
  @$pb.TagNumber(4)
  set canReact($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanReact() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanReact() => $_clearField(4);
}

class ListCommunityReactionsRequest extends $pb.GeneratedMessage {
  factory ListCommunityReactionsRequest({
    $core.String? channelId,
    $core.Iterable<$0.CommunityContentReference>? contents,
  }) {
    final result = ListCommunityReactionsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  ListCommunityReactionsRequest._();

  factory ListCommunityReactionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityReactionsRequest()..mergeFromBuffer(data, registry);
  factory ListCommunityReactionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityReactionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommunityReactionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListCommunityReactionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..pPM<$0.CommunityContentReference>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: $0.CommunityContentReference.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityReactionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityReactionsRequest copyWith(
          void Function(ListCommunityReactionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCommunityReactionsRequest))
          as ListCommunityReactionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCommunityReactionsRequest() / ListCommunityReactionsRequest.new instead')
  static ListCommunityReactionsRequest create() =>
      ListCommunityReactionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCommunityReactionsRequest._();
  @$core.override
  ListCommunityReactionsRequest createEmptyInstance() =>
      ListCommunityReactionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCommunityReactionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommunityReactionsRequest>(
          ListCommunityReactionsRequest.$_createMessage);
  static ListCommunityReactionsRequest? _defaultInstance;

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

class ListCommunityReactionsResponse extends $pb.GeneratedMessage {
  factory ListCommunityReactionsResponse({
    $core.Iterable<CommunityReactionState>? states,
  }) {
    final result = ListCommunityReactionsResponse._();
    if (states != null) result.states.addAll(states);
    return result;
  }

  ListCommunityReactionsResponse._();

  factory ListCommunityReactionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityReactionsResponse()..mergeFromBuffer(data, registry);
  factory ListCommunityReactionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCommunityReactionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCommunityReactionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListCommunityReactionsResponse.$_createMessage)
    ..pPM<CommunityReactionState>(1, _omitFieldNames ? '' : 'states',
        subBuilder: CommunityReactionState.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityReactionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCommunityReactionsResponse copyWith(
          void Function(ListCommunityReactionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCommunityReactionsResponse))
          as ListCommunityReactionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCommunityReactionsResponse() / ListCommunityReactionsResponse.new instead')
  static ListCommunityReactionsResponse create() =>
      ListCommunityReactionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCommunityReactionsResponse._();
  @$core.override
  ListCommunityReactionsResponse createEmptyInstance() =>
      ListCommunityReactionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCommunityReactionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCommunityReactionsResponse>(
          ListCommunityReactionsResponse.$_createMessage);
  static ListCommunityReactionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommunityReactionState> get states => $_getList(0);
}

class SetCommunityReactionRequest extends $pb.GeneratedMessage {
  factory SetCommunityReactionRequest({
    $core.String? channelId,
    $0.CommunityContentReference? content,
    $core.String? emoji,
    $core.bool? active,
    $fixnum.Int64? expectedRevision,
    $core.String? idempotencyKey,
  }) {
    final result = SetCommunityReactionRequest._();
    if (channelId != null) result.channelId = channelId;
    if (content != null) result.content = content;
    if (emoji != null) result.emoji = emoji;
    if (active != null) result.active = active;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  SetCommunityReactionRequest._();

  factory SetCommunityReactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityReactionRequest()..mergeFromBuffer(data, registry);
  factory SetCommunityReactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityReactionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetCommunityReactionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetCommunityReactionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOM<$0.CommunityContentReference>(2, _omitFieldNames ? '' : 'content',
        subBuilder: $0.CommunityContentReference.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'emoji')
    ..aOB(4, _omitFieldNames ? '' : 'active')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(6, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityReactionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityReactionRequest copyWith(
          void Function(SetCommunityReactionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetCommunityReactionRequest))
          as SetCommunityReactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetCommunityReactionRequest() / SetCommunityReactionRequest.new instead')
  static SetCommunityReactionRequest create() =>
      SetCommunityReactionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetCommunityReactionRequest._();
  @$core.override
  SetCommunityReactionRequest createEmptyInstance() =>
      SetCommunityReactionRequest._();
  @$core.pragma('dart2js:noInline')
  static SetCommunityReactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetCommunityReactionRequest>(
          SetCommunityReactionRequest.$_createMessage);
  static SetCommunityReactionRequest? _defaultInstance;

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
  $core.String get emoji => $_getSZ(2);
  @$pb.TagNumber(3)
  set emoji($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmoji() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmoji() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get active => $_getBF(3);
  @$pb.TagNumber(4)
  set active($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActive() => $_has(3);
  @$pb.TagNumber(4)
  void clearActive() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expectedRevision => $_getI64(4);
  @$pb.TagNumber(5)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpectedRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpectedRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get idempotencyKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set idempotencyKey($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdempotencyKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdempotencyKey() => $_clearField(6);
}

class SetCommunityReactionResponse extends $pb.GeneratedMessage {
  factory SetCommunityReactionResponse({
    CommunityReactionState? state,
    $core.String? idempotencyKey,
    $fixnum.Int64? appliedRevision,
  }) {
    final result = SetCommunityReactionResponse._();
    if (state != null) result.state = state;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (appliedRevision != null) result.appliedRevision = appliedRevision;
    return result;
  }

  SetCommunityReactionResponse._();

  factory SetCommunityReactionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityReactionResponse()..mergeFromBuffer(data, registry);
  factory SetCommunityReactionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetCommunityReactionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetCommunityReactionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SetCommunityReactionResponse.$_createMessage)
    ..aOM<CommunityReactionState>(1, _omitFieldNames ? '' : 'state',
        subBuilder: CommunityReactionState.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'idempotencyKey')
    ..aInt64(3, _omitFieldNames ? '' : 'appliedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityReactionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetCommunityReactionResponse copyWith(
          void Function(SetCommunityReactionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetCommunityReactionResponse))
          as SetCommunityReactionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetCommunityReactionResponse() / SetCommunityReactionResponse.new instead')
  static SetCommunityReactionResponse create() =>
      SetCommunityReactionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetCommunityReactionResponse._();
  @$core.override
  SetCommunityReactionResponse createEmptyInstance() =>
      SetCommunityReactionResponse._();
  @$core.pragma('dart2js:noInline')
  static SetCommunityReactionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetCommunityReactionResponse>(
          SetCommunityReactionResponse.$_createMessage);
  static SetCommunityReactionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CommunityReactionState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(CommunityReactionState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);
  @$pb.TagNumber(1)
  CommunityReactionState ensureState() => $_ensure(0);

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

/// core.community.reactions.v1: только forum/feed, без списка чужих principal ID.
class CommunityReactionServiceApi {
  final $pb.RpcClient _client;

  CommunityReactionServiceApi(this._client);

  $async.Future<ListCommunityReactionsResponse> listCommunityReactions(
          $pb.ClientContext? ctx, ListCommunityReactionsRequest request) =>
      _client.invoke<ListCommunityReactionsResponse>(
          ctx,
          'CommunityReactionService',
          'ListCommunityReactions',
          request,
          ListCommunityReactionsResponse());
  $async.Future<SetCommunityReactionResponse> setCommunityReaction(
          $pb.ClientContext? ctx, SetCommunityReactionRequest request) =>
      _client.invoke<SetCommunityReactionResponse>(
          ctx,
          'CommunityReactionService',
          'SetCommunityReaction',
          request,
          SetCommunityReactionResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
