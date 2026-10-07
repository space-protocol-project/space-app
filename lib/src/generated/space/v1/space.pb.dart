// This is a generated file - do not edit.
//
// Generated from space/v1/space.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest() => LogoutRequest._();

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: LogoutRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LogoutRequest() / LogoutRequest.new instead')
  static LogoutRequest create() => LogoutRequest._();
  static $pb.GeneratedMessage $_createMessage() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => LogoutRequest._();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(
          LogoutRequest.$_createMessage);
  static LogoutRequest? _defaultInstance;
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse() => LogoutResponse._();

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LogoutResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: LogoutResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LogoutResponse() / LogoutResponse.new instead')
  static LogoutResponse create() => LogoutResponse._();
  static $pb.GeneratedMessage $_createMessage() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => LogoutResponse._();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(
          LogoutResponse.$_createMessage);
  static LogoutResponse? _defaultInstance;
}

class Member extends $pb.GeneratedMessage {
  factory Member({
    $core.String? principalId,
    $core.String? role,
    $core.bool? blocked,
    $fixnum.Int64? revision,
  }) {
    final result = Member._();
    if (principalId != null) result.principalId = principalId;
    if (role != null) result.role = role;
    if (blocked != null) result.blocked = blocked;
    if (revision != null) result.revision = revision;
    return result;
  }

  Member._();

  factory Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Member()..mergeFromBuffer(data, registry);
  factory Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Member()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Member',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Member.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOB(3, _omitFieldNames ? '' : 'blocked')
    ..aInt64(4, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member copyWith(void Function(Member) updates) =>
      super.copyWith((message) => updates(message as Member)) as Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Member() / Member.new instead')
  static Member create() => Member._();
  static $pb.GeneratedMessage $_createMessage() => Member._();
  @$core.override
  Member createEmptyInstance() => Member._();
  @$core.pragma('dart2js:noInline')
  static Member getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Member>(Member.$_createMessage);
  static Member? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get principalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set principalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrincipalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrincipalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get blocked => $_getBF(2);
  @$pb.TagNumber(3)
  set blocked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBlocked() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlocked() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get revision => $_getI64(3);
  @$pb.TagNumber(4)
  set revision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevision() => $_clearField(4);
}

class ListMembersRequest extends $pb.GeneratedMessage {
  factory ListMembersRequest({
    $core.String? after,
  }) {
    final result = ListMembersRequest._();
    if (after != null) result.after = after;
    return result;
  }

  ListMembersRequest._();

  factory ListMembersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersRequest()..mergeFromBuffer(data, registry);
  factory ListMembersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMembersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMembersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersRequest copyWith(void Function(ListMembersRequest) updates) =>
      super.copyWith((message) => updates(message as ListMembersRequest))
          as ListMembersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListMembersRequest() / ListMembersRequest.new instead')
  static ListMembersRequest create() => ListMembersRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListMembersRequest._();
  @$core.override
  ListMembersRequest createEmptyInstance() => ListMembersRequest._();
  @$core.pragma('dart2js:noInline')
  static ListMembersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMembersRequest>(
          ListMembersRequest.$_createMessage);
  static ListMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get after => $_getSZ(0);
  @$pb.TagNumber(1)
  set after($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfter() => $_clearField(1);
}

class ListMembersResponse extends $pb.GeneratedMessage {
  factory ListMembersResponse({
    $core.Iterable<Member>? members,
    $core.String? nextCursor,
  }) {
    final result = ListMembersResponse._();
    if (members != null) result.members.addAll(members);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListMembersResponse._();

  factory ListMembersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersResponse()..mergeFromBuffer(data, registry);
  factory ListMembersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListMembersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMembersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListMembersResponse.$_createMessage)
    ..pPM<Member>(1, _omitFieldNames ? '' : 'members',
        subBuilder: Member.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMembersResponse copyWith(void Function(ListMembersResponse) updates) =>
      super.copyWith((message) => updates(message as ListMembersResponse))
          as ListMembersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListMembersResponse() / ListMembersResponse.new instead')
  static ListMembersResponse create() => ListMembersResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListMembersResponse._();
  @$core.override
  ListMembersResponse createEmptyInstance() => ListMembersResponse._();
  @$core.pragma('dart2js:noInline')
  static ListMembersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMembersResponse>(
          ListMembersResponse.$_createMessage);
  static ListMembersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Member> get members => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class UpdateMemberRequest extends $pb.GeneratedMessage {
  factory UpdateMemberRequest({
    $core.String? principalId,
    $core.String? role,
    $core.bool? blocked,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = UpdateMemberRequest._();
    if (principalId != null) result.principalId = principalId;
    if (role != null) result.role = role;
    if (blocked != null) result.blocked = blocked;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  UpdateMemberRequest._();

  factory UpdateMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberRequest()..mergeFromBuffer(data, registry);
  factory UpdateMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateMemberRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'principalId')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOB(3, _omitFieldNames ? '' : 'blocked')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRequest copyWith(void Function(UpdateMemberRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateMemberRequest))
          as UpdateMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateMemberRequest() / UpdateMemberRequest.new instead')
  static UpdateMemberRequest create() => UpdateMemberRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateMemberRequest._();
  @$core.override
  UpdateMemberRequest createEmptyInstance() => UpdateMemberRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberRequest>(
          UpdateMemberRequest.$_createMessage);
  static UpdateMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get principalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set principalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrincipalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrincipalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get blocked => $_getBF(2);
  @$pb.TagNumber(3)
  set blocked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBlocked() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlocked() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedRevision() => $_clearField(4);
}

class UpdateMemberResponse extends $pb.GeneratedMessage {
  factory UpdateMemberResponse({
    Member? member,
  }) {
    final result = UpdateMemberResponse._();
    if (member != null) result.member = member;
    return result;
  }

  UpdateMemberResponse._();

  factory UpdateMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberResponse()..mergeFromBuffer(data, registry);
  factory UpdateMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMemberResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateMemberResponse.$_createMessage)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member',
        subBuilder: Member.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberResponse copyWith(void Function(UpdateMemberResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateMemberResponse))
          as UpdateMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateMemberResponse() / UpdateMemberResponse.new instead')
  static UpdateMemberResponse create() => UpdateMemberResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateMemberResponse._();
  @$core.override
  UpdateMemberResponse createEmptyInstance() => UpdateMemberResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberResponse>(
          UpdateMemberResponse.$_createMessage);
  static UpdateMemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);
}

class Invite extends $pb.GeneratedMessage {
  factory Invite({
    $core.String? id,
    $core.String? role,
    $fixnum.Int64? expiresAt,
    $core.int? maxUses,
    $core.int? uses,
    $core.bool? revoked,
  }) {
    final result = Invite._();
    if (id != null) result.id = id;
    if (role != null) result.role = role;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (maxUses != null) result.maxUses = maxUses;
    if (uses != null) result.uses = uses;
    if (revoked != null) result.revoked = revoked;
    return result;
  }

  Invite._();

  factory Invite.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Invite()..mergeFromBuffer(data, registry);
  factory Invite.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Invite()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Invite',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Invite.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aInt64(3, _omitFieldNames ? '' : 'expiresAt')
    ..aI(4, _omitFieldNames ? '' : 'maxUses')
    ..aI(5, _omitFieldNames ? '' : 'uses')
    ..aOB(6, _omitFieldNames ? '' : 'revoked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invite clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invite copyWith(void Function(Invite) updates) =>
      super.copyWith((message) => updates(message as Invite)) as Invite;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Invite() / Invite.new instead')
  static Invite create() => Invite._();
  static $pb.GeneratedMessage $_createMessage() => Invite._();
  @$core.override
  Invite createEmptyInstance() => Invite._();
  @$core.pragma('dart2js:noInline')
  static Invite getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Invite>(Invite.$_createMessage);
  static Invite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresAt => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxUses => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxUses($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxUses() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxUses() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get uses => $_getIZ(4);
  @$pb.TagNumber(5)
  set uses($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUses() => $_has(4);
  @$pb.TagNumber(5)
  void clearUses() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get revoked => $_getBF(5);
  @$pb.TagNumber(6)
  set revoked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRevoked() => $_has(5);
  @$pb.TagNumber(6)
  void clearRevoked() => $_clearField(6);
}

class CreateInviteRequest extends $pb.GeneratedMessage {
  factory CreateInviteRequest({
    $core.String? role,
    $core.int? ttlSeconds,
    $core.int? maxUses,
  }) {
    final result = CreateInviteRequest._();
    if (role != null) result.role = role;
    if (ttlSeconds != null) result.ttlSeconds = ttlSeconds;
    if (maxUses != null) result.maxUses = maxUses;
    return result;
  }

  CreateInviteRequest._();

  factory CreateInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteRequest()..mergeFromBuffer(data, registry);
  factory CreateInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aI(2, _omitFieldNames ? '' : 'ttlSeconds')
    ..aI(3, _omitFieldNames ? '' : 'maxUses')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteRequest copyWith(void Function(CreateInviteRequest) updates) =>
      super.copyWith((message) => updates(message as CreateInviteRequest))
          as CreateInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CreateInviteRequest() / CreateInviteRequest.new instead')
  static CreateInviteRequest create() => CreateInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateInviteRequest._();
  @$core.override
  CreateInviteRequest createEmptyInstance() => CreateInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateInviteRequest>(
          CreateInviteRequest.$_createMessage);
  static CreateInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get ttlSeconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set ttlSeconds($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTtlSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearTtlSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxUses => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxUses($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxUses() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxUses() => $_clearField(3);
}

class CreateInviteResponse extends $pb.GeneratedMessage {
  factory CreateInviteResponse({
    Invite? invite,
    $core.String? token,
  }) {
    final result = CreateInviteResponse._();
    if (invite != null) result.invite = invite;
    if (token != null) result.token = token;
    return result;
  }

  CreateInviteResponse._();

  factory CreateInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteResponse()..mergeFromBuffer(data, registry);
  factory CreateInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateInviteResponse.$_createMessage)
    ..aOM<Invite>(1, _omitFieldNames ? '' : 'invite',
        subBuilder: Invite.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateInviteResponse copyWith(void Function(CreateInviteResponse) updates) =>
      super.copyWith((message) => updates(message as CreateInviteResponse))
          as CreateInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateInviteResponse() / CreateInviteResponse.new instead')
  static CreateInviteResponse create() => CreateInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateInviteResponse._();
  @$core.override
  CreateInviteResponse createEmptyInstance() => CreateInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateInviteResponse>(
          CreateInviteResponse.$_createMessage);
  static CreateInviteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Invite get invite => $_getN(0);
  @$pb.TagNumber(1)
  set invite(Invite value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInvite() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvite() => $_clearField(1);
  @$pb.TagNumber(1)
  Invite ensureInvite() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

class ListInvitesRequest extends $pb.GeneratedMessage {
  factory ListInvitesRequest({
    $core.String? after,
  }) {
    final result = ListInvitesRequest._();
    if (after != null) result.after = after;
    return result;
  }

  ListInvitesRequest._();

  factory ListInvitesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesRequest()..mergeFromBuffer(data, registry);
  factory ListInvitesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvitesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListInvitesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesRequest copyWith(void Function(ListInvitesRequest) updates) =>
      super.copyWith((message) => updates(message as ListInvitesRequest))
          as ListInvitesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListInvitesRequest() / ListInvitesRequest.new instead')
  static ListInvitesRequest create() => ListInvitesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListInvitesRequest._();
  @$core.override
  ListInvitesRequest createEmptyInstance() => ListInvitesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListInvitesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvitesRequest>(
          ListInvitesRequest.$_createMessage);
  static ListInvitesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get after => $_getSZ(0);
  @$pb.TagNumber(1)
  set after($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfter() => $_clearField(1);
}

class ListInvitesResponse extends $pb.GeneratedMessage {
  factory ListInvitesResponse({
    $core.Iterable<Invite>? invites,
    $core.String? nextCursor,
  }) {
    final result = ListInvitesResponse._();
    if (invites != null) result.invites.addAll(invites);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListInvitesResponse._();

  factory ListInvitesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesResponse()..mergeFromBuffer(data, registry);
  factory ListInvitesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvitesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvitesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListInvitesResponse.$_createMessage)
    ..pPM<Invite>(1, _omitFieldNames ? '' : 'invites',
        subBuilder: Invite.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvitesResponse copyWith(void Function(ListInvitesResponse) updates) =>
      super.copyWith((message) => updates(message as ListInvitesResponse))
          as ListInvitesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListInvitesResponse() / ListInvitesResponse.new instead')
  static ListInvitesResponse create() => ListInvitesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListInvitesResponse._();
  @$core.override
  ListInvitesResponse createEmptyInstance() => ListInvitesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListInvitesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvitesResponse>(
          ListInvitesResponse.$_createMessage);
  static ListInvitesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Invite> get invites => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class RevokeInviteRequest extends $pb.GeneratedMessage {
  factory RevokeInviteRequest({
    $core.String? inviteId,
  }) {
    final result = RevokeInviteRequest._();
    if (inviteId != null) result.inviteId = inviteId;
    return result;
  }

  RevokeInviteRequest._();

  factory RevokeInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteRequest()..mergeFromBuffer(data, registry);
  factory RevokeInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'inviteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteRequest copyWith(void Function(RevokeInviteRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeInviteRequest))
          as RevokeInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RevokeInviteRequest() / RevokeInviteRequest.new instead')
  static RevokeInviteRequest create() => RevokeInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => RevokeInviteRequest._();
  @$core.override
  RevokeInviteRequest createEmptyInstance() => RevokeInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static RevokeInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeInviteRequest>(
          RevokeInviteRequest.$_createMessage);
  static RevokeInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get inviteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set inviteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInviteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInviteId() => $_clearField(1);
}

class RevokeInviteResponse extends $pb.GeneratedMessage {
  factory RevokeInviteResponse() => RevokeInviteResponse._();

  RevokeInviteResponse._();

  factory RevokeInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteResponse()..mergeFromBuffer(data, registry);
  factory RevokeInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: RevokeInviteResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeInviteResponse copyWith(void Function(RevokeInviteResponse) updates) =>
      super.copyWith((message) => updates(message as RevokeInviteResponse))
          as RevokeInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RevokeInviteResponse() / RevokeInviteResponse.new instead')
  static RevokeInviteResponse create() => RevokeInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => RevokeInviteResponse._();
  @$core.override
  RevokeInviteResponse createEmptyInstance() => RevokeInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static RevokeInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeInviteResponse>(
          RevokeInviteResponse.$_createMessage);
  static RevokeInviteResponse? _defaultInstance;
}

class PreviewInviteRequest extends $pb.GeneratedMessage {
  factory PreviewInviteRequest({
    $core.String? token,
  }) {
    final result = PreviewInviteRequest._();
    if (token != null) result.token = token;
    return result;
  }

  PreviewInviteRequest._();

  factory PreviewInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteRequest()..mergeFromBuffer(data, registry);
  factory PreviewInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PreviewInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteRequest copyWith(void Function(PreviewInviteRequest) updates) =>
      super.copyWith((message) => updates(message as PreviewInviteRequest))
          as PreviewInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PreviewInviteRequest() / PreviewInviteRequest.new instead')
  static PreviewInviteRequest create() => PreviewInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => PreviewInviteRequest._();
  @$core.override
  PreviewInviteRequest createEmptyInstance() => PreviewInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static PreviewInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewInviteRequest>(
          PreviewInviteRequest.$_createMessage);
  static PreviewInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class PreviewInviteResponse extends $pb.GeneratedMessage {
  factory PreviewInviteResponse({
    $core.String? role,
    $core.String? serverId,
    $core.String? title,
    $fixnum.Int64? expiresAt,
  }) {
    final result = PreviewInviteResponse._();
    if (role != null) result.role = role;
    if (serverId != null) result.serverId = serverId;
    if (title != null) result.title = title;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  PreviewInviteResponse._();

  factory PreviewInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteResponse()..mergeFromBuffer(data, registry);
  factory PreviewInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PreviewInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: PreviewInviteResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'role')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewInviteResponse copyWith(
          void Function(PreviewInviteResponse) updates) =>
      super.copyWith((message) => updates(message as PreviewInviteResponse))
          as PreviewInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PreviewInviteResponse() / PreviewInviteResponse.new instead')
  static PreviewInviteResponse create() => PreviewInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => PreviewInviteResponse._();
  @$core.override
  PreviewInviteResponse createEmptyInstance() => PreviewInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static PreviewInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewInviteResponse>(
          PreviewInviteResponse.$_createMessage);
  static PreviewInviteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get role => $_getSZ(0);
  @$pb.TagNumber(1)
  set role($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

class AcceptInviteRequest extends $pb.GeneratedMessage {
  factory AcceptInviteRequest({
    $core.String? token,
  }) {
    final result = AcceptInviteRequest._();
    if (token != null) result.token = token;
    return result;
  }

  AcceptInviteRequest._();

  factory AcceptInviteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteRequest()..mergeFromBuffer(data, registry);
  factory AcceptInviteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptInviteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: AcceptInviteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteRequest copyWith(void Function(AcceptInviteRequest) updates) =>
      super.copyWith((message) => updates(message as AcceptInviteRequest))
          as AcceptInviteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use AcceptInviteRequest() / AcceptInviteRequest.new instead')
  static AcceptInviteRequest create() => AcceptInviteRequest._();
  static $pb.GeneratedMessage $_createMessage() => AcceptInviteRequest._();
  @$core.override
  AcceptInviteRequest createEmptyInstance() => AcceptInviteRequest._();
  @$core.pragma('dart2js:noInline')
  static AcceptInviteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptInviteRequest>(
          AcceptInviteRequest.$_createMessage);
  static AcceptInviteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class AcceptInviteResponse extends $pb.GeneratedMessage {
  factory AcceptInviteResponse({
    Member? member,
  }) {
    final result = AcceptInviteResponse._();
    if (member != null) result.member = member;
    return result;
  }

  AcceptInviteResponse._();

  factory AcceptInviteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteResponse()..mergeFromBuffer(data, registry);
  factory AcceptInviteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AcceptInviteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptInviteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: AcceptInviteResponse.$_createMessage)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member',
        subBuilder: Member.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptInviteResponse copyWith(void Function(AcceptInviteResponse) updates) =>
      super.copyWith((message) => updates(message as AcceptInviteResponse))
          as AcceptInviteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AcceptInviteResponse() / AcceptInviteResponse.new instead')
  static AcceptInviteResponse create() => AcceptInviteResponse._();
  static $pb.GeneratedMessage $_createMessage() => AcceptInviteResponse._();
  @$core.override
  AcceptInviteResponse createEmptyInstance() => AcceptInviteResponse._();
  @$core.pragma('dart2js:noInline')
  static AcceptInviteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptInviteResponse>(
          AcceptInviteResponse.$_createMessage);
  static AcceptInviteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);
}

class GetMembershipRequest extends $pb.GeneratedMessage {
  factory GetMembershipRequest() => GetMembershipRequest._();

  GetMembershipRequest._();

  factory GetMembershipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipRequest()..mergeFromBuffer(data, registry);
  factory GetMembershipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMembershipRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetMembershipRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipRequest copyWith(void Function(GetMembershipRequest) updates) =>
      super.copyWith((message) => updates(message as GetMembershipRequest))
          as GetMembershipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMembershipRequest() / GetMembershipRequest.new instead')
  static GetMembershipRequest create() => GetMembershipRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMembershipRequest._();
  @$core.override
  GetMembershipRequest createEmptyInstance() => GetMembershipRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMembershipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMembershipRequest>(
          GetMembershipRequest.$_createMessage);
  static GetMembershipRequest? _defaultInstance;
}

class GetMembershipResponse extends $pb.GeneratedMessage {
  factory GetMembershipResponse({
    Member? member,
  }) {
    final result = GetMembershipResponse._();
    if (member != null) result.member = member;
    return result;
  }

  GetMembershipResponse._();

  factory GetMembershipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipResponse()..mergeFromBuffer(data, registry);
  factory GetMembershipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMembershipResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMembershipResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetMembershipResponse.$_createMessage)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member',
        subBuilder: Member.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMembershipResponse copyWith(
          void Function(GetMembershipResponse) updates) =>
      super.copyWith((message) => updates(message as GetMembershipResponse))
          as GetMembershipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMembershipResponse() / GetMembershipResponse.new instead')
  static GetMembershipResponse create() => GetMembershipResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetMembershipResponse._();
  @$core.override
  GetMembershipResponse createEmptyInstance() => GetMembershipResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMembershipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMembershipResponse>(
          GetMembershipResponse.$_createMessage);
  static GetMembershipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);
}

class GetSetupStatusRequest extends $pb.GeneratedMessage {
  factory GetSetupStatusRequest() => GetSetupStatusRequest._();

  GetSetupStatusRequest._();

  factory GetSetupStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusRequest()..mergeFromBuffer(data, registry);
  factory GetSetupStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSetupStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSetupStatusRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusRequest copyWith(
          void Function(GetSetupStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetSetupStatusRequest))
          as GetSetupStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSetupStatusRequest() / GetSetupStatusRequest.new instead')
  static GetSetupStatusRequest create() => GetSetupStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSetupStatusRequest._();
  @$core.override
  GetSetupStatusRequest createEmptyInstance() => GetSetupStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSetupStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSetupStatusRequest>(
          GetSetupStatusRequest.$_createMessage);
  static GetSetupStatusRequest? _defaultInstance;
}

class GetSetupStatusResponse extends $pb.GeneratedMessage {
  factory GetSetupStatusResponse({
    $core.bool? initialized,
  }) {
    final result = GetSetupStatusResponse._();
    if (initialized != null) result.initialized = initialized;
    return result;
  }

  GetSetupStatusResponse._();

  factory GetSetupStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusResponse()..mergeFromBuffer(data, registry);
  factory GetSetupStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSetupStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSetupStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSetupStatusResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'initialized')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetupStatusResponse copyWith(
          void Function(GetSetupStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetSetupStatusResponse))
          as GetSetupStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSetupStatusResponse() / GetSetupStatusResponse.new instead')
  static GetSetupStatusResponse create() => GetSetupStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSetupStatusResponse._();
  @$core.override
  GetSetupStatusResponse createEmptyInstance() => GetSetupStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSetupStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSetupStatusResponse>(
          GetSetupStatusResponse.$_createMessage);
  static GetSetupStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get initialized => $_getBF(0);
  @$pb.TagNumber(1)
  set initialized($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInitialized() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialized() => $_clearField(1);
}

class ClaimOwnerRequest extends $pb.GeneratedMessage {
  factory ClaimOwnerRequest({
    $core.String? setupCode,
  }) {
    final result = ClaimOwnerRequest._();
    if (setupCode != null) result.setupCode = setupCode;
    return result;
  }

  ClaimOwnerRequest._();

  factory ClaimOwnerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerRequest()..mergeFromBuffer(data, registry);
  factory ClaimOwnerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimOwnerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ClaimOwnerRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'setupCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerRequest copyWith(void Function(ClaimOwnerRequest) updates) =>
      super.copyWith((message) => updates(message as ClaimOwnerRequest))
          as ClaimOwnerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClaimOwnerRequest() / ClaimOwnerRequest.new instead')
  static ClaimOwnerRequest create() => ClaimOwnerRequest._();
  static $pb.GeneratedMessage $_createMessage() => ClaimOwnerRequest._();
  @$core.override
  ClaimOwnerRequest createEmptyInstance() => ClaimOwnerRequest._();
  @$core.pragma('dart2js:noInline')
  static ClaimOwnerRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClaimOwnerRequest>(
          ClaimOwnerRequest.$_createMessage);
  static ClaimOwnerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get setupCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set setupCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetupCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetupCode() => $_clearField(1);
}

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => GetSettingsRequest._();

  GetSettingsRequest._();

  factory GetSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsRequest()..mergeFromBuffer(data, registry);
  factory GetSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSettingsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsRequest))
          as GetSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetSettingsRequest() / GetSettingsRequest.new instead')
  static GetSettingsRequest create() => GetSettingsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSettingsRequest._();
  @$core.override
  GetSettingsRequest createEmptyInstance() => GetSettingsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(
          GetSettingsRequest.$_createMessage);
  static GetSettingsRequest? _defaultInstance;
}

class ClaimOwnerResponse extends $pb.GeneratedMessage {
  factory ClaimOwnerResponse({
    SpaceSettings? settings,
  }) {
    final result = ClaimOwnerResponse._();
    if (settings != null) result.settings = settings;
    return result;
  }

  ClaimOwnerResponse._();

  factory ClaimOwnerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerResponse()..mergeFromBuffer(data, registry);
  factory ClaimOwnerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimOwnerResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimOwnerResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ClaimOwnerResponse.$_createMessage)
    ..aOM<SpaceSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: SpaceSettings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimOwnerResponse copyWith(void Function(ClaimOwnerResponse) updates) =>
      super.copyWith((message) => updates(message as ClaimOwnerResponse))
          as ClaimOwnerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClaimOwnerResponse() / ClaimOwnerResponse.new instead')
  static ClaimOwnerResponse create() => ClaimOwnerResponse._();
  static $pb.GeneratedMessage $_createMessage() => ClaimOwnerResponse._();
  @$core.override
  ClaimOwnerResponse createEmptyInstance() => ClaimOwnerResponse._();
  @$core.pragma('dart2js:noInline')
  static ClaimOwnerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClaimOwnerResponse>(
          ClaimOwnerResponse.$_createMessage);
  static ClaimOwnerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SpaceSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(SpaceSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  SpaceSettings ensureSettings() => $_ensure(0);
}

class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    SpaceSettings? settings,
  }) {
    final result = GetSettingsResponse._();
    if (settings != null) result.settings = settings;
    return result;
  }

  GetSettingsResponse._();

  factory GetSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsResponse()..mergeFromBuffer(data, registry);
  factory GetSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSettingsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetSettingsResponse.$_createMessage)
    ..aOM<SpaceSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: SpaceSettings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSettingsResponse))
          as GetSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetSettingsResponse() / GetSettingsResponse.new instead')
  static GetSettingsResponse create() => GetSettingsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSettingsResponse._();
  @$core.override
  GetSettingsResponse createEmptyInstance() => GetSettingsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(
          GetSettingsResponse.$_createMessage);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SpaceSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(SpaceSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  SpaceSettings ensureSettings() => $_ensure(0);
}

class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    SpaceSettings? settings,
  }) {
    final result = UpdateSettingsResponse._();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsResponse._();

  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsResponse()..mergeFromBuffer(data, registry);
  factory UpdateSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateSettingsResponse.$_createMessage)
    ..aOM<SpaceSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: SpaceSettings.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse copyWith(
          void Function(UpdateSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsResponse))
          as UpdateSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateSettingsResponse() / UpdateSettingsResponse.new instead')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateSettingsResponse._();
  @$core.override
  UpdateSettingsResponse createEmptyInstance() => UpdateSettingsResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(
          UpdateSettingsResponse.$_createMessage);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SpaceSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(SpaceSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  SpaceSettings ensureSettings() => $_ensure(0);
}

class SpaceSettings extends $pb.GeneratedMessage {
  factory SpaceSettings({
    $core.String? title,
    $core.String? chatTitle,
    $core.bool? chatEnabled,
    $core.String? registrationPolicy,
    $fixnum.Int64? revision,
  }) {
    final result = SpaceSettings._();
    if (title != null) result.title = title;
    if (chatTitle != null) result.chatTitle = chatTitle;
    if (chatEnabled != null) result.chatEnabled = chatEnabled;
    if (registrationPolicy != null)
      result.registrationPolicy = registrationPolicy;
    if (revision != null) result.revision = revision;
    return result;
  }

  SpaceSettings._();

  factory SpaceSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpaceSettings()..mergeFromBuffer(data, registry);
  factory SpaceSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpaceSettings()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpaceSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SpaceSettings.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'chatTitle')
    ..aOB(3, _omitFieldNames ? '' : 'chatEnabled')
    ..aOS(4, _omitFieldNames ? '' : 'registrationPolicy')
    ..aInt64(5, _omitFieldNames ? '' : 'revision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpaceSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpaceSettings copyWith(void Function(SpaceSettings) updates) =>
      super.copyWith((message) => updates(message as SpaceSettings))
          as SpaceSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SpaceSettings() / SpaceSettings.new instead')
  static SpaceSettings create() => SpaceSettings._();
  static $pb.GeneratedMessage $_createMessage() => SpaceSettings._();
  @$core.override
  SpaceSettings createEmptyInstance() => SpaceSettings._();
  @$core.pragma('dart2js:noInline')
  static SpaceSettings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpaceSettings>(
          SpaceSettings.$_createMessage);
  static SpaceSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chatTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set chatTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChatTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearChatTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get chatEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set chatEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChatEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearChatEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get registrationPolicy => $_getSZ(3);
  @$pb.TagNumber(4)
  set registrationPolicy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRegistrationPolicy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegistrationPolicy() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get revision => $_getI64(4);
  @$pb.TagNumber(5)
  set revision($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevision() => $_clearField(5);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    $core.String? title,
    $core.String? chatTitle,
    $core.bool? chatEnabled,
    $core.String? registrationPolicy,
    $fixnum.Int64? expectedRevision,
  }) {
    final result = UpdateSettingsRequest._();
    if (title != null) result.title = title;
    if (chatTitle != null) result.chatTitle = chatTitle;
    if (chatEnabled != null) result.chatEnabled = chatEnabled;
    if (registrationPolicy != null)
      result.registrationPolicy = registrationPolicy;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    return result;
  }

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsRequest()..mergeFromBuffer(data, registry);
  factory UpdateSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSettingsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: UpdateSettingsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'chatTitle')
    ..aOB(3, _omitFieldNames ? '' : 'chatEnabled')
    ..aOS(4, _omitFieldNames ? '' : 'registrationPolicy')
    ..aInt64(5, _omitFieldNames ? '' : 'expectedRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest copyWith(
          void Function(UpdateSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsRequest))
          as UpdateSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateSettingsRequest() / UpdateSettingsRequest.new instead')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateSettingsRequest._();
  @$core.override
  UpdateSettingsRequest createEmptyInstance() => UpdateSettingsRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(
          UpdateSettingsRequest.$_createMessage);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chatTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set chatTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChatTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearChatTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get chatEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set chatEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChatEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearChatEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get registrationPolicy => $_getSZ(3);
  @$pb.TagNumber(4)
  set registrationPolicy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRegistrationPolicy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegistrationPolicy() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expectedRevision => $_getI64(4);
  @$pb.TagNumber(5)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpectedRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpectedRevision() => $_clearField(5);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = SubscribeRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  SubscribeRequest._();

  factory SubscribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeRequest()..mergeFromBuffer(data, registry);
  factory SubscribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SubscribeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest))
          as SubscribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SubscribeRequest() / SubscribeRequest.new instead')
  static SubscribeRequest create() => SubscribeRequest._();
  static $pb.GeneratedMessage $_createMessage() => SubscribeRequest._();
  @$core.override
  SubscribeRequest createEmptyInstance() => SubscribeRequest._();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(
          SubscribeRequest.$_createMessage);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class SubscribeResponse extends $pb.GeneratedMessage {
  factory SubscribeResponse({
    Event? event,
    $core.String? cursor,
    $core.bool? heartbeat,
  }) {
    final result = SubscribeResponse._();
    if (event != null) result.event = event;
    if (cursor != null) result.cursor = cursor;
    if (heartbeat != null) result.heartbeat = heartbeat;
    return result;
  }

  SubscribeResponse._();

  factory SubscribeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeResponse()..mergeFromBuffer(data, registry);
  factory SubscribeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: SubscribeResponse.$_createMessage)
    ..aOM<Event>(1, _omitFieldNames ? '' : 'event',
        subBuilder: Event.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'heartbeat')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeResponse copyWith(void Function(SubscribeResponse) updates) =>
      super.copyWith((message) => updates(message as SubscribeResponse))
          as SubscribeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SubscribeResponse() / SubscribeResponse.new instead')
  static SubscribeResponse create() => SubscribeResponse._();
  static $pb.GeneratedMessage $_createMessage() => SubscribeResponse._();
  @$core.override
  SubscribeResponse createEmptyInstance() => SubscribeResponse._();
  @$core.pragma('dart2js:noInline')
  static SubscribeResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeResponse>(
          SubscribeResponse.$_createMessage);
  static SubscribeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Event get event => $_getN(0);
  @$pb.TagNumber(1)
  set event(Event value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  Event ensureEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get heartbeat => $_getBF(2);
  @$pb.TagNumber(3)
  set heartbeat($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeartbeat() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeartbeat() => $_clearField(3);
}

class CreateChallengeRequest extends $pb.GeneratedMessage {
  factory CreateChallengeRequest({
    $core.String? purpose,
    $core.List<$core.int>? rootPublicKey,
    $core.List<$core.int>? devicePublicKey,
    $core.String? grantId,
    $core.bool? administrative,
  }) {
    final result = CreateChallengeRequest._();
    if (purpose != null) result.purpose = purpose;
    if (rootPublicKey != null) result.rootPublicKey = rootPublicKey;
    if (devicePublicKey != null) result.devicePublicKey = devicePublicKey;
    if (grantId != null) result.grantId = grantId;
    if (administrative != null) result.administrative = administrative;
    return result;
  }

  CreateChallengeRequest._();

  factory CreateChallengeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeRequest()..mergeFromBuffer(data, registry);
  factory CreateChallengeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChallengeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateChallengeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'purpose')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'rootPublicKey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'devicePublicKey', $pb.PbFieldType.OY)
    ..aOS(4, _omitFieldNames ? '' : 'grantId')
    ..aOB(5, _omitFieldNames ? '' : 'administrative')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeRequest copyWith(
          void Function(CreateChallengeRequest) updates) =>
      super.copyWith((message) => updates(message as CreateChallengeRequest))
          as CreateChallengeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateChallengeRequest() / CreateChallengeRequest.new instead')
  static CreateChallengeRequest create() => CreateChallengeRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateChallengeRequest._();
  @$core.override
  CreateChallengeRequest createEmptyInstance() => CreateChallengeRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateChallengeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChallengeRequest>(
          CreateChallengeRequest.$_createMessage);
  static CreateChallengeRequest? _defaultInstance;

  /// device.register / auth.login / device.revoke.
  @$pb.TagNumber(1)
  $core.String get purpose => $_getSZ(0);
  @$pb.TagNumber(1)
  set purpose($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurpose() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurpose() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get rootPublicKey => $_getN(1);
  @$pb.TagNumber(2)
  set rootPublicKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRootPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearRootPublicKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get devicePublicKey => $_getN(2);
  @$pb.TagNumber(3)
  set devicePublicKey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDevicePublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevicePublicKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get grantId => $_getSZ(3);
  @$pb.TagNumber(4)
  set grantId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGrantId() => $_has(3);
  @$pb.TagNumber(4)
  void clearGrantId() => $_clearField(4);

  /// Только регистрация: root явно разрешает space.manage этому устройству.
  @$pb.TagNumber(5)
  $core.bool get administrative => $_getBF(4);
  @$pb.TagNumber(5)
  set administrative($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdministrative() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdministrative() => $_clearField(5);
}

class CreateChallengeResponse extends $pb.GeneratedMessage {
  factory CreateChallengeResponse({
    $core.String? challengeId,
    $core.List<$core.int>? transcript,
  }) {
    final result = CreateChallengeResponse._();
    if (challengeId != null) result.challengeId = challengeId;
    if (transcript != null) result.transcript = transcript;
    return result;
  }

  CreateChallengeResponse._();

  factory CreateChallengeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeResponse()..mergeFromBuffer(data, registry);
  factory CreateChallengeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateChallengeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChallengeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateChallengeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'challengeId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'transcript', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChallengeResponse copyWith(
          void Function(CreateChallengeResponse) updates) =>
      super.copyWith((message) => updates(message as CreateChallengeResponse))
          as CreateChallengeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateChallengeResponse() / CreateChallengeResponse.new instead')
  static CreateChallengeResponse create() => CreateChallengeResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateChallengeResponse._();
  @$core.override
  CreateChallengeResponse createEmptyInstance() => CreateChallengeResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateChallengeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChallengeResponse>(
          CreateChallengeResponse.$_createMessage);
  static CreateChallengeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get challengeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set challengeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallengeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallengeId() => $_clearField(1);

  /// Клиент проверяет поля и восстанавливает байты по фиксированному профилю.
  @$pb.TagNumber(2)
  $core.List<$core.int> get transcript => $_getN(1);
  @$pb.TagNumber(2)
  set transcript($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTranscript() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranscript() => $_clearField(2);
}

class CompleteChallengeRequest extends $pb.GeneratedMessage {
  factory CompleteChallengeRequest({
    $core.String? challengeId,
    $core.List<$core.int>? signature,
    $core.String? invitationToken,
  }) {
    final result = CompleteChallengeRequest._();
    if (challengeId != null) result.challengeId = challengeId;
    if (signature != null) result.signature = signature;
    if (invitationToken != null) result.invitationToken = invitationToken;
    return result;
  }

  CompleteChallengeRequest._();

  factory CompleteChallengeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeRequest()..mergeFromBuffer(data, registry);
  factory CompleteChallengeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteChallengeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteChallengeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'challengeId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'invitationToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeRequest copyWith(
          void Function(CompleteChallengeRequest) updates) =>
      super.copyWith((message) => updates(message as CompleteChallengeRequest))
          as CompleteChallengeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteChallengeRequest() / CompleteChallengeRequest.new instead')
  static CompleteChallengeRequest create() => CompleteChallengeRequest._();
  static $pb.GeneratedMessage $_createMessage() => CompleteChallengeRequest._();
  @$core.override
  CompleteChallengeRequest createEmptyInstance() =>
      CompleteChallengeRequest._();
  @$core.pragma('dart2js:noInline')
  static CompleteChallengeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteChallengeRequest>(
          CompleteChallengeRequest.$_createMessage);
  static CompleteChallengeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get challengeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set challengeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallengeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallengeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signature => $_getN(1);
  @$pb.TagNumber(2)
  set signature($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignature() => $_clearField(2);

  /// Только device.register: вступление атомарно с регистрацией устройства.
  @$pb.TagNumber(3)
  $core.String get invitationToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set invitationToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInvitationToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearInvitationToken() => $_clearField(3);
}

class CompleteChallengeResponse extends $pb.GeneratedMessage {
  factory CompleteChallengeResponse({
    $core.String? grantId,
    $core.String? principalId,
    $core.String? accessToken,
    $fixnum.Int64? expiresAt,
  }) {
    final result = CompleteChallengeResponse._();
    if (grantId != null) result.grantId = grantId;
    if (principalId != null) result.principalId = principalId;
    if (accessToken != null) result.accessToken = accessToken;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  CompleteChallengeResponse._();

  factory CompleteChallengeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeResponse()..mergeFromBuffer(data, registry);
  factory CompleteChallengeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteChallengeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteChallengeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CompleteChallengeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'grantId')
    ..aOS(2, _omitFieldNames ? '' : 'principalId')
    ..aOS(3, _omitFieldNames ? '' : 'accessToken')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteChallengeResponse copyWith(
          void Function(CompleteChallengeResponse) updates) =>
      super.copyWith((message) => updates(message as CompleteChallengeResponse))
          as CompleteChallengeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteChallengeResponse() / CompleteChallengeResponse.new instead')
  static CompleteChallengeResponse create() => CompleteChallengeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompleteChallengeResponse._();
  @$core.override
  CompleteChallengeResponse createEmptyInstance() =>
      CompleteChallengeResponse._();
  @$core.pragma('dart2js:noInline')
  static CompleteChallengeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteChallengeResponse>(
          CompleteChallengeResponse.$_createMessage);
  static CompleteChallengeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get grantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set grantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGrantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGrantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get principalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set principalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrincipalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrincipalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get accessToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set accessToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccessToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccessToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

class ListEventsRequest extends $pb.GeneratedMessage {
  factory ListEventsRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = ListEventsRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  ListEventsRequest._();

  factory ListEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsRequest()..mergeFromBuffer(data, registry);
  factory ListEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEventsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListEventsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsRequest copyWith(void Function(ListEventsRequest) updates) =>
      super.copyWith((message) => updates(message as ListEventsRequest))
          as ListEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListEventsRequest() / ListEventsRequest.new instead')
  static ListEventsRequest create() => ListEventsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListEventsRequest._();
  @$core.override
  ListEventsRequest createEmptyInstance() => ListEventsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListEventsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListEventsRequest>(
          ListEventsRequest.$_createMessage);
  static ListEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class ListEventsResponse extends $pb.GeneratedMessage {
  factory ListEventsResponse({
    $core.Iterable<Event>? events,
    $core.String? nextCursor,
  }) {
    final result = ListEventsResponse._();
    if (events != null) result.events.addAll(events);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListEventsResponse._();

  factory ListEventsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsResponse()..mergeFromBuffer(data, registry);
  factory ListEventsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListEventsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEventsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListEventsResponse.$_createMessage)
    ..pPM<Event>(1, _omitFieldNames ? '' : 'events',
        subBuilder: Event.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEventsResponse copyWith(void Function(ListEventsResponse) updates) =>
      super.copyWith((message) => updates(message as ListEventsResponse))
          as ListEventsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListEventsResponse() / ListEventsResponse.new instead')
  static ListEventsResponse create() => ListEventsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListEventsResponse._();
  @$core.override
  ListEventsResponse createEmptyInstance() => ListEventsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListEventsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEventsResponse>(
          ListEventsResponse.$_createMessage);
  static ListEventsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Event> get events => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

class Event extends $pb.GeneratedMessage {
  factory Event({
    $core.String? cursor,
    $core.String? type,
    Content? content,
  }) {
    final result = Event._();
    if (cursor != null) result.cursor = cursor;
    if (type != null) result.type = type;
    if (content != null) result.content = content;
    return result;
  }

  Event._();

  factory Event.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Event()..mergeFromBuffer(data, registry);
  factory Event.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Event()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Event',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Event.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cursor')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOM<Content>(3, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event copyWith(void Function(Event) updates) =>
      super.copyWith((message) => updates(message as Event)) as Event;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Event() / Event.new instead')
  static Event create() => Event._();
  static $pb.GeneratedMessage $_createMessage() => Event._();
  @$core.override
  Event createEmptyInstance() => Event._();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Event>(Event.$_createMessage);
  static Event? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cursor => $_getSZ(0);
  @$pb.TagNumber(1)
  set cursor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  Content get content => $_getN(2);
  @$pb.TagNumber(3)
  set content(Content value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);
  @$pb.TagNumber(3)
  Content ensureContent() => $_ensure(2);
}

class GetManifestRequest extends $pb.GeneratedMessage {
  factory GetManifestRequest() => GetManifestRequest._();

  GetManifestRequest._();

  factory GetManifestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestRequest()..mergeFromBuffer(data, registry);
  factory GetManifestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetManifestRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetManifestRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestRequest copyWith(void Function(GetManifestRequest) updates) =>
      super.copyWith((message) => updates(message as GetManifestRequest))
          as GetManifestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetManifestRequest() / GetManifestRequest.new instead')
  static GetManifestRequest create() => GetManifestRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetManifestRequest._();
  @$core.override
  GetManifestRequest createEmptyInstance() => GetManifestRequest._();
  @$core.pragma('dart2js:noInline')
  static GetManifestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetManifestRequest>(
          GetManifestRequest.$_createMessage);
  static GetManifestRequest? _defaultInstance;
}

class GetManifestResponse extends $pb.GeneratedMessage {
  factory GetManifestResponse({
    $core.String? protocolVersion,
    $core.String? serverId,
    $core.Iterable<Channel>? channels,
    $core.String? title,
  }) {
    final result = GetManifestResponse._();
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    if (serverId != null) result.serverId = serverId;
    if (channels != null) result.channels.addAll(channels);
    if (title != null) result.title = title;
    return result;
  }

  GetManifestResponse._();

  factory GetManifestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestResponse()..mergeFromBuffer(data, registry);
  factory GetManifestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetManifestResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetManifestResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetManifestResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'protocolVersion')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..pPM<Channel>(3, _omitFieldNames ? '' : 'channels',
        subBuilder: Channel.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetManifestResponse copyWith(void Function(GetManifestResponse) updates) =>
      super.copyWith((message) => updates(message as GetManifestResponse))
          as GetManifestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetManifestResponse() / GetManifestResponse.new instead')
  static GetManifestResponse create() => GetManifestResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetManifestResponse._();
  @$core.override
  GetManifestResponse createEmptyInstance() => GetManifestResponse._();
  @$core.pragma('dart2js:noInline')
  static GetManifestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetManifestResponse>(
          GetManifestResponse.$_createMessage);
  static GetManifestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get protocolVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set protocolVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProtocolVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearProtocolVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Channel> get channels => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);
}

class Channel extends $pb.GeneratedMessage {
  factory Channel({
    $core.String? id,
    $core.String? title,
    $core.Iterable<View>? views,
  }) {
    final result = Channel._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (views != null) result.views.addAll(views);
    return result;
  }

  Channel._();

  factory Channel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Channel()..mergeFromBuffer(data, registry);
  factory Channel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Channel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Channel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Channel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..pPM<View>(3, _omitFieldNames ? '' : 'views',
        subBuilder: View.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Channel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Channel copyWith(void Function(Channel) updates) =>
      super.copyWith((message) => updates(message as Channel)) as Channel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Channel() / Channel.new instead')
  static Channel create() => Channel._();
  static $pb.GeneratedMessage $_createMessage() => Channel._();
  @$core.override
  Channel createEmptyInstance() => Channel._();
  @$core.pragma('dart2js:noInline')
  static Channel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Channel>(Channel.$_createMessage);
  static Channel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<View> get views => $_getList(2);
}

class View extends $pb.GeneratedMessage {
  factory View({
    $core.String? id,
    $core.String? type,
  }) {
    final result = View._();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    return result;
  }

  View._();

  factory View.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      View()..mergeFromBuffer(data, registry);
  factory View.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      View()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'View',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: View.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  View clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  View copyWith(void Function(View) updates) =>
      super.copyWith((message) => updates(message as View)) as View;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use View() / View.new instead')
  static View create() => View._();
  static $pb.GeneratedMessage $_createMessage() => View._();
  @$core.override
  View createEmptyInstance() => View._();
  @$core.pragma('dart2js:noInline')
  static View getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<View>(View.$_createMessage);
  static View? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);
}

class Content extends $pb.GeneratedMessage {
  factory Content({
    $core.String? id,
    $core.String? channelId,
    $core.String? text,
    $core.String? authorId,
  }) {
    final result = Content._();
    if (id != null) result.id = id;
    if (channelId != null) result.channelId = channelId;
    if (text != null) result.text = text;
    if (authorId != null) result.authorId = authorId;
    return result;
  }

  Content._();

  factory Content.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Content()..mergeFromBuffer(data, registry);
  factory Content.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Content()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Content',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: Content.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'channelId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'authorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Content clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Content copyWith(void Function(Content) updates) =>
      super.copyWith((message) => updates(message as Content)) as Content;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Content() / Content.new instead')
  static Content create() => Content._();
  static $pb.GeneratedMessage $_createMessage() => Content._();
  @$core.override
  Content createEmptyInstance() => Content._();
  @$core.pragma('dart2js:noInline')
  static Content getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Content>(Content.$_createMessage);
  static Content? _defaultInstance;

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
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorId() => $_clearField(4);
}

class CreateContentRequest extends $pb.GeneratedMessage {
  factory CreateContentRequest({
    $core.String? channelId,
    $core.String? text,
    $core.String? idempotencyKey,
  }) {
    final result = CreateContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (text != null) result.text = text;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  CreateContentRequest._();

  factory CreateContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentRequest()..mergeFromBuffer(data, registry);
  factory CreateContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentRequest copyWith(void Function(CreateContentRequest) updates) =>
      super.copyWith((message) => updates(message as CreateContentRequest))
          as CreateContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateContentRequest() / CreateContentRequest.new instead')
  static CreateContentRequest create() => CreateContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateContentRequest._();
  @$core.override
  CreateContentRequest createEmptyInstance() => CreateContentRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateContentRequest>(
          CreateContentRequest.$_createMessage);
  static CreateContentRequest? _defaultInstance;

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
}

class CreateContentResponse extends $pb.GeneratedMessage {
  factory CreateContentResponse({
    Content? content,
  }) {
    final result = CreateContentResponse._();
    if (content != null) result.content = content;
    return result;
  }

  CreateContentResponse._();

  factory CreateContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentResponse()..mergeFromBuffer(data, registry);
  factory CreateContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: CreateContentResponse.$_createMessage)
    ..aOM<Content>(1, _omitFieldNames ? '' : 'content',
        subBuilder: Content.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContentResponse copyWith(
          void Function(CreateContentResponse) updates) =>
      super.copyWith((message) => updates(message as CreateContentResponse))
          as CreateContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateContentResponse() / CreateContentResponse.new instead')
  static CreateContentResponse create() => CreateContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateContentResponse._();
  @$core.override
  CreateContentResponse createEmptyInstance() => CreateContentResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateContentResponse>(
          CreateContentResponse.$_createMessage);
  static CreateContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Content get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(Content value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  Content ensureContent() => $_ensure(0);
}

class ListContentRequest extends $pb.GeneratedMessage {
  factory ListContentRequest({
    $core.String? channelId,
    $core.String? after,
  }) {
    final result = ListContentRequest._();
    if (channelId != null) result.channelId = channelId;
    if (after != null) result.after = after;
    return result;
  }

  ListContentRequest._();

  factory ListContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentRequest()..mergeFromBuffer(data, registry);
  factory ListContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'after')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentRequest copyWith(void Function(ListContentRequest) updates) =>
      super.copyWith((message) => updates(message as ListContentRequest))
          as ListContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListContentRequest() / ListContentRequest.new instead')
  static ListContentRequest create() => ListContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListContentRequest._();
  @$core.override
  ListContentRequest createEmptyInstance() => ListContentRequest._();
  @$core.pragma('dart2js:noInline')
  static ListContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContentRequest>(
          ListContentRequest.$_createMessage);
  static ListContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  /// Непрозрачный курсор последнего полученного сообщения.
  @$pb.TagNumber(2)
  $core.String get after => $_getSZ(1);
  @$pb.TagNumber(2)
  set after($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
}

class ListContentResponse extends $pb.GeneratedMessage {
  factory ListContentResponse({
    $core.Iterable<Content>? contents,
    $core.String? nextCursor,
  }) {
    final result = ListContentResponse._();
    if (contents != null) result.contents.addAll(contents);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  ListContentResponse._();

  factory ListContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentResponse()..mergeFromBuffer(data, registry);
  factory ListContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListContentResponse.$_createMessage)
    ..pPM<Content>(1, _omitFieldNames ? '' : 'contents',
        subBuilder: Content.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentResponse copyWith(void Function(ListContentResponse) updates) =>
      super.copyWith((message) => updates(message as ListContentResponse))
          as ListContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListContentResponse() / ListContentResponse.new instead')
  static ListContentResponse create() => ListContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListContentResponse._();
  @$core.override
  ListContentResponse createEmptyInstance() => ListContentResponse._();
  @$core.pragma('dart2js:noInline')
  static ListContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContentResponse>(
          ListContentResponse.$_createMessage);
  static ListContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Content> get contents => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
