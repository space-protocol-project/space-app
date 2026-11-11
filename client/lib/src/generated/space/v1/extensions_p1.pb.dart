// This is a generated file - do not edit.
//
// Generated from space/v1/extensions_p1.proto.

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

import 'extensions_p1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'extensions_p1.pbenum.dart';

class ExtensionContribution extends $pb.GeneratedMessage {
  factory ExtensionContribution({
    $core.String? id,
    ExtensionContributionKind? kind,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? title,
    $core.String? query,
  }) {
    final result = ExtensionContribution._();
    if (id != null) result.id = id;
    if (kind != null) result.kind = kind;
    if (title != null) result.title.addEntries(title);
    if (query != null) result.query = query;
    return result;
  }

  ExtensionContribution._();

  factory ExtensionContribution.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionContribution()..mergeFromBuffer(data, registry);
  factory ExtensionContribution.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionContribution()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionContribution',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExtensionContribution.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<ExtensionContributionKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ExtensionContributionKind.values)
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'title',
        entryClassName: 'ExtensionContribution.TitleEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('space.v1'))
    ..aOS(4, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionContribution clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionContribution copyWith(
          void Function(ExtensionContribution) updates) =>
      super.copyWith((message) => updates(message as ExtensionContribution))
          as ExtensionContribution;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExtensionContribution() / ExtensionContribution.new instead')
  static ExtensionContribution create() => ExtensionContribution._();
  static $pb.GeneratedMessage $_createMessage() => ExtensionContribution._();
  @$core.override
  ExtensionContribution createEmptyInstance() => ExtensionContribution._();
  @$core.pragma('dart2js:noInline')
  static ExtensionContribution getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionContribution>(
          ExtensionContribution.$_createMessage);
  static ExtensionContribution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  ExtensionContributionKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ExtensionContributionKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get title => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get query => $_getSZ(3);
  @$pb.TagNumber(4)
  set query($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuery() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuery() => $_clearField(4);
}

/// Чтение конкретного экземпляра: сессия, read ACL и enabled lifecycle.
/// Пустой instance_id не означает перечисление всего пространства.
class ListExtensionContributionsRequest extends $pb.GeneratedMessage {
  factory ListExtensionContributionsRequest({
    $core.String? instanceId,
    ExtensionContributionKind? kind,
  }) {
    final result = ListExtensionContributionsRequest._();
    if (instanceId != null) result.instanceId = instanceId;
    if (kind != null) result.kind = kind;
    return result;
  }

  ListExtensionContributionsRequest._();

  factory ListExtensionContributionsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionContributionsRequest()..mergeFromBuffer(data, registry);
  factory ListExtensionContributionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionContributionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExtensionContributionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListExtensionContributionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instanceId')
    ..aE<ExtensionContributionKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ExtensionContributionKind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionContributionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionContributionsRequest copyWith(
          void Function(ListExtensionContributionsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ListExtensionContributionsRequest))
          as ListExtensionContributionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExtensionContributionsRequest() / ListExtensionContributionsRequest.new instead')
  static ListExtensionContributionsRequest create() =>
      ListExtensionContributionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListExtensionContributionsRequest._();
  @$core.override
  ListExtensionContributionsRequest createEmptyInstance() =>
      ListExtensionContributionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListExtensionContributionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExtensionContributionsRequest>(
          ListExtensionContributionsRequest.$_createMessage);
  static ListExtensionContributionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceId() => $_clearField(1);

  @$pb.TagNumber(2)
  ExtensionContributionKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ExtensionContributionKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);
}

class ListExtensionContributionsResponse extends $pb.GeneratedMessage {
  factory ListExtensionContributionsResponse({
    $core.Iterable<ExtensionContribution>? contributions,
    $core.List<$core.int>? registrySha256,
  }) {
    final result = ListExtensionContributionsResponse._();
    if (contributions != null) result.contributions.addAll(contributions);
    if (registrySha256 != null) result.registrySha256 = registrySha256;
    return result;
  }

  ListExtensionContributionsResponse._();

  factory ListExtensionContributionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionContributionsResponse()..mergeFromBuffer(data, registry);
  factory ListExtensionContributionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionContributionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExtensionContributionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListExtensionContributionsResponse.$_createMessage)
    ..pPM<ExtensionContribution>(1, _omitFieldNames ? '' : 'contributions',
        subBuilder: ExtensionContribution.$_createMessage)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'registrySha256', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionContributionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionContributionsResponse copyWith(
          void Function(ListExtensionContributionsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListExtensionContributionsResponse))
          as ListExtensionContributionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExtensionContributionsResponse() / ListExtensionContributionsResponse.new instead')
  static ListExtensionContributionsResponse create() =>
      ListExtensionContributionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListExtensionContributionsResponse._();
  @$core.override
  ListExtensionContributionsResponse createEmptyInstance() =>
      ListExtensionContributionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListExtensionContributionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExtensionContributionsResponse>(
          ListExtensionContributionsResponse.$_createMessage);
  static ListExtensionContributionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ExtensionContribution> get contributions => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrySha256 => $_getN(1);
  @$pb.TagNumber(2)
  set registrySha256($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrySha256() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrySha256() => $_clearField(2);
}

/// Административный API P1: текущая сессия с space.manage, владелец и manage ACL
/// всех каналов установки. Не устанавливает пакеты и не принимает роль system.
class ExtensionInstallation extends $pb.GeneratedMessage {
  factory ExtensionInstallation({
    $core.String? installationId,
    $core.String? state,
    $fixnum.Int64? revision,
    $core.String? generation,
    $core.List<$core.int>? bindingSha256,
  }) {
    final result = ExtensionInstallation._();
    if (installationId != null) result.installationId = installationId;
    if (state != null) result.state = state;
    if (revision != null) result.revision = revision;
    if (generation != null) result.generation = generation;
    if (bindingSha256 != null) result.bindingSha256 = bindingSha256;
    return result;
  }

  ExtensionInstallation._();

  factory ExtensionInstallation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionInstallation()..mergeFromBuffer(data, registry);
  factory ExtensionInstallation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionInstallation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionInstallation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExtensionInstallation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'installationId')
    ..aOS(2, _omitFieldNames ? '' : 'state')
    ..aInt64(3, _omitFieldNames ? '' : 'revision')
    ..aOS(4, _omitFieldNames ? '' : 'generation')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'bindingSha256', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionInstallation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionInstallation copyWith(
          void Function(ExtensionInstallation) updates) =>
      super.copyWith((message) => updates(message as ExtensionInstallation))
          as ExtensionInstallation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExtensionInstallation() / ExtensionInstallation.new instead')
  static ExtensionInstallation create() => ExtensionInstallation._();
  static $pb.GeneratedMessage $_createMessage() => ExtensionInstallation._();
  @$core.override
  ExtensionInstallation createEmptyInstance() => ExtensionInstallation._();
  @$core.pragma('dart2js:noInline')
  static ExtensionInstallation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionInstallation>(
          ExtensionInstallation.$_createMessage);
  static ExtensionInstallation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get installationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set installationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstallationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get state => $_getSZ(1);
  @$pb.TagNumber(2)
  set state($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get revision => $_getI64(2);
  @$pb.TagNumber(3)
  set revision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get generation => $_getSZ(3);
  @$pb.TagNumber(4)
  set generation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGeneration() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeneration() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get bindingSha256 => $_getN(4);
  @$pb.TagNumber(5)
  set bindingSha256($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBindingSha256() => $_has(4);
  @$pb.TagNumber(5)
  void clearBindingSha256() => $_clearField(5);
}

class ListExtensionInstallationsRequest extends $pb.GeneratedMessage {
  factory ListExtensionInstallationsRequest({
    $core.String? afterInstallationId,
    $core.int? pageSize,
    $core.String? generation,
  }) {
    final result = ListExtensionInstallationsRequest._();
    if (afterInstallationId != null)
      result.afterInstallationId = afterInstallationId;
    if (pageSize != null) result.pageSize = pageSize;
    if (generation != null) result.generation = generation;
    return result;
  }

  ListExtensionInstallationsRequest._();

  factory ListExtensionInstallationsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationsRequest()..mergeFromBuffer(data, registry);
  factory ListExtensionInstallationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExtensionInstallationsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListExtensionInstallationsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'afterInstallationId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'generation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationsRequest copyWith(
          void Function(ListExtensionInstallationsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ListExtensionInstallationsRequest))
          as ListExtensionInstallationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExtensionInstallationsRequest() / ListExtensionInstallationsRequest.new instead')
  static ListExtensionInstallationsRequest create() =>
      ListExtensionInstallationsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListExtensionInstallationsRequest._();
  @$core.override
  ListExtensionInstallationsRequest createEmptyInstance() =>
      ListExtensionInstallationsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListExtensionInstallationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExtensionInstallationsRequest>(
          ListExtensionInstallationsRequest.$_createMessage);
  static ListExtensionInstallationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get afterInstallationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set afterInstallationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfterInstallationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfterInstallationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get generation => $_getSZ(2);
  @$pb.TagNumber(3)
  set generation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGeneration() => $_has(2);
  @$pb.TagNumber(3)
  void clearGeneration() => $_clearField(3);
}

class ListExtensionInstallationsResponse extends $pb.GeneratedMessage {
  factory ListExtensionInstallationsResponse({
    $core.Iterable<ExtensionInstallation>? installations,
    $core.String? nextAfterInstallationId,
    $core.String? generation,
  }) {
    final result = ListExtensionInstallationsResponse._();
    if (installations != null) result.installations.addAll(installations);
    if (nextAfterInstallationId != null)
      result.nextAfterInstallationId = nextAfterInstallationId;
    if (generation != null) result.generation = generation;
    return result;
  }

  ListExtensionInstallationsResponse._();

  factory ListExtensionInstallationsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationsResponse()..mergeFromBuffer(data, registry);
  factory ListExtensionInstallationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExtensionInstallationsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListExtensionInstallationsResponse.$_createMessage)
    ..pPM<ExtensionInstallation>(1, _omitFieldNames ? '' : 'installations',
        subBuilder: ExtensionInstallation.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextAfterInstallationId')
    ..aOS(3, _omitFieldNames ? '' : 'generation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationsResponse copyWith(
          void Function(ListExtensionInstallationsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListExtensionInstallationsResponse))
          as ListExtensionInstallationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExtensionInstallationsResponse() / ListExtensionInstallationsResponse.new instead')
  static ListExtensionInstallationsResponse create() =>
      ListExtensionInstallationsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListExtensionInstallationsResponse._();
  @$core.override
  ListExtensionInstallationsResponse createEmptyInstance() =>
      ListExtensionInstallationsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListExtensionInstallationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExtensionInstallationsResponse>(
          ListExtensionInstallationsResponse.$_createMessage);
  static ListExtensionInstallationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ExtensionInstallation> get installations => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextAfterInstallationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextAfterInstallationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextAfterInstallationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextAfterInstallationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get generation => $_getSZ(2);
  @$pb.TagNumber(3)
  set generation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGeneration() => $_has(2);
  @$pb.TagNumber(3)
  void clearGeneration() => $_clearField(3);
}

class GetExtensionInstallationRequest extends $pb.GeneratedMessage {
  factory GetExtensionInstallationRequest({
    $core.String? installationId,
  }) {
    final result = GetExtensionInstallationRequest._();
    if (installationId != null) result.installationId = installationId;
    return result;
  }

  GetExtensionInstallationRequest._();

  factory GetExtensionInstallationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionInstallationRequest()..mergeFromBuffer(data, registry);
  factory GetExtensionInstallationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionInstallationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExtensionInstallationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetExtensionInstallationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'installationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionInstallationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionInstallationRequest copyWith(
          void Function(GetExtensionInstallationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetExtensionInstallationRequest))
          as GetExtensionInstallationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetExtensionInstallationRequest() / GetExtensionInstallationRequest.new instead')
  static GetExtensionInstallationRequest create() =>
      GetExtensionInstallationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetExtensionInstallationRequest._();
  @$core.override
  GetExtensionInstallationRequest createEmptyInstance() =>
      GetExtensionInstallationRequest._();
  @$core.pragma('dart2js:noInline')
  static GetExtensionInstallationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExtensionInstallationRequest>(
          GetExtensionInstallationRequest.$_createMessage);
  static GetExtensionInstallationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get installationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set installationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstallationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallationId() => $_clearField(1);
}

class GetExtensionInstallationResponse extends $pb.GeneratedMessage {
  factory GetExtensionInstallationResponse({
    ExtensionInstallation? installation,
  }) {
    final result = GetExtensionInstallationResponse._();
    if (installation != null) result.installation = installation;
    return result;
  }

  GetExtensionInstallationResponse._();

  factory GetExtensionInstallationResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionInstallationResponse()..mergeFromBuffer(data, registry);
  factory GetExtensionInstallationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionInstallationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExtensionInstallationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetExtensionInstallationResponse.$_createMessage)
    ..aOM<ExtensionInstallation>(1, _omitFieldNames ? '' : 'installation',
        subBuilder: ExtensionInstallation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionInstallationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionInstallationResponse copyWith(
          void Function(GetExtensionInstallationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetExtensionInstallationResponse))
          as GetExtensionInstallationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetExtensionInstallationResponse() / GetExtensionInstallationResponse.new instead')
  static GetExtensionInstallationResponse create() =>
      GetExtensionInstallationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetExtensionInstallationResponse._();
  @$core.override
  GetExtensionInstallationResponse createEmptyInstance() =>
      GetExtensionInstallationResponse._();
  @$core.pragma('dart2js:noInline')
  static GetExtensionInstallationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExtensionInstallationResponse>(
          GetExtensionInstallationResponse.$_createMessage);
  static GetExtensionInstallationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ExtensionInstallation get installation => $_getN(0);
  @$pb.TagNumber(1)
  set installation(ExtensionInstallation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstallation() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallation() => $_clearField(1);
  @$pb.TagNumber(1)
  ExtensionInstallation ensureInstallation() => $_ensure(0);
}

class ChangeExtensionInstallationRequest extends $pb.GeneratedMessage {
  factory ChangeExtensionInstallationRequest({
    $core.String? installationId,
    $core.String? generation,
    $fixnum.Int64? expectedRevision,
    $core.String? action,
  }) {
    final result = ChangeExtensionInstallationRequest._();
    if (installationId != null) result.installationId = installationId;
    if (generation != null) result.generation = generation;
    if (expectedRevision != null) result.expectedRevision = expectedRevision;
    if (action != null) result.action = action;
    return result;
  }

  ChangeExtensionInstallationRequest._();

  factory ChangeExtensionInstallationRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangeExtensionInstallationRequest()..mergeFromBuffer(data, registry);
  factory ChangeExtensionInstallationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangeExtensionInstallationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeExtensionInstallationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ChangeExtensionInstallationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'installationId')
    ..aOS(2, _omitFieldNames ? '' : 'generation')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedRevision')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeExtensionInstallationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeExtensionInstallationRequest copyWith(
          void Function(ChangeExtensionInstallationRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ChangeExtensionInstallationRequest))
          as ChangeExtensionInstallationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ChangeExtensionInstallationRequest() / ChangeExtensionInstallationRequest.new instead')
  static ChangeExtensionInstallationRequest create() =>
      ChangeExtensionInstallationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ChangeExtensionInstallationRequest._();
  @$core.override
  ChangeExtensionInstallationRequest createEmptyInstance() =>
      ChangeExtensionInstallationRequest._();
  @$core.pragma('dart2js:noInline')
  static ChangeExtensionInstallationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeExtensionInstallationRequest>(
          ChangeExtensionInstallationRequest.$_createMessage);
  static ChangeExtensionInstallationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get installationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set installationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstallationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get generation => $_getSZ(1);
  @$pb.TagNumber(2)
  set generation($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGeneration() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneration() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);
}

class ChangeExtensionInstallationResponse extends $pb.GeneratedMessage {
  factory ChangeExtensionInstallationResponse({
    $core.String? state,
    $fixnum.Int64? revision,
    $core.String? generation,
  }) {
    final result = ChangeExtensionInstallationResponse._();
    if (state != null) result.state = state;
    if (revision != null) result.revision = revision;
    if (generation != null) result.generation = generation;
    return result;
  }

  ChangeExtensionInstallationResponse._();

  factory ChangeExtensionInstallationResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangeExtensionInstallationResponse()..mergeFromBuffer(data, registry);
  factory ChangeExtensionInstallationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangeExtensionInstallationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeExtensionInstallationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ChangeExtensionInstallationResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'state')
    ..aInt64(2, _omitFieldNames ? '' : 'revision')
    ..aOS(3, _omitFieldNames ? '' : 'generation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeExtensionInstallationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeExtensionInstallationResponse copyWith(
          void Function(ChangeExtensionInstallationResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ChangeExtensionInstallationResponse))
          as ChangeExtensionInstallationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ChangeExtensionInstallationResponse() / ChangeExtensionInstallationResponse.new instead')
  static ChangeExtensionInstallationResponse create() =>
      ChangeExtensionInstallationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ChangeExtensionInstallationResponse._();
  @$core.override
  ChangeExtensionInstallationResponse createEmptyInstance() =>
      ChangeExtensionInstallationResponse._();
  @$core.pragma('dart2js:noInline')
  static ChangeExtensionInstallationResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ChangeExtensionInstallationResponse>(
          ChangeExtensionInstallationResponse.$_createMessage);
  static ChangeExtensionInstallationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get state => $_getSZ(0);
  @$pb.TagNumber(1)
  set state($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get revision => $_getI64(1);
  @$pb.TagNumber(2)
  set revision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get generation => $_getSZ(2);
  @$pb.TagNumber(3)
  set generation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGeneration() => $_has(2);
  @$pb.TagNumber(3)
  void clearGeneration() => $_clearField(3);
}

class ExtensionInstallationAuditEntry extends $pb.GeneratedMessage {
  factory ExtensionInstallationAuditEntry({
    $fixnum.Int64? revision,
    $core.String? generation,
    $core.String? action,
    $core.String? actor,
    $core.String? principalId,
    $core.String? previousState,
    $core.String? state,
    $core.String? createdAt,
  }) {
    final result = ExtensionInstallationAuditEntry._();
    if (revision != null) result.revision = revision;
    if (generation != null) result.generation = generation;
    if (action != null) result.action = action;
    if (actor != null) result.actor = actor;
    if (principalId != null) result.principalId = principalId;
    if (previousState != null) result.previousState = previousState;
    if (state != null) result.state = state;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ExtensionInstallationAuditEntry._();

  factory ExtensionInstallationAuditEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionInstallationAuditEntry()..mergeFromBuffer(data, registry);
  factory ExtensionInstallationAuditEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionInstallationAuditEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionInstallationAuditEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExtensionInstallationAuditEntry.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'revision')
    ..aOS(2, _omitFieldNames ? '' : 'generation')
    ..aOS(3, _omitFieldNames ? '' : 'action')
    ..aOS(4, _omitFieldNames ? '' : 'actor')
    ..aOS(5, _omitFieldNames ? '' : 'principalId')
    ..aOS(6, _omitFieldNames ? '' : 'previousState')
    ..aOS(7, _omitFieldNames ? '' : 'state')
    ..aOS(8, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionInstallationAuditEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionInstallationAuditEntry copyWith(
          void Function(ExtensionInstallationAuditEntry) updates) =>
      super.copyWith(
              (message) => updates(message as ExtensionInstallationAuditEntry))
          as ExtensionInstallationAuditEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExtensionInstallationAuditEntry() / ExtensionInstallationAuditEntry.new instead')
  static ExtensionInstallationAuditEntry create() =>
      ExtensionInstallationAuditEntry._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExtensionInstallationAuditEntry._();
  @$core.override
  ExtensionInstallationAuditEntry createEmptyInstance() =>
      ExtensionInstallationAuditEntry._();
  @$core.pragma('dart2js:noInline')
  static ExtensionInstallationAuditEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionInstallationAuditEntry>(
          ExtensionInstallationAuditEntry.$_createMessage);
  static ExtensionInstallationAuditEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get revision => $_getI64(0);
  @$pb.TagNumber(1)
  set revision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get generation => $_getSZ(1);
  @$pb.TagNumber(2)
  set generation($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGeneration() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneration() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get action => $_getSZ(2);
  @$pb.TagNumber(3)
  set action($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get actor => $_getSZ(3);
  @$pb.TagNumber(4)
  set actor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActor() => $_has(3);
  @$pb.TagNumber(4)
  void clearActor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get principalId => $_getSZ(4);
  @$pb.TagNumber(5)
  set principalId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrincipalId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrincipalId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get previousState => $_getSZ(5);
  @$pb.TagNumber(6)
  set previousState($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPreviousState() => $_has(5);
  @$pb.TagNumber(6)
  void clearPreviousState() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get state => $_getSZ(6);
  @$pb.TagNumber(7)
  set state($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get createdAt => $_getSZ(7);
  @$pb.TagNumber(8)
  set createdAt($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
}

class ListExtensionInstallationAuditRequest extends $pb.GeneratedMessage {
  factory ListExtensionInstallationAuditRequest({
    $core.String? installationId,
    $core.String? generation,
    $fixnum.Int64? afterRevision,
    $fixnum.Int64? throughRevision,
    $core.int? pageSize,
  }) {
    final result = ListExtensionInstallationAuditRequest._();
    if (installationId != null) result.installationId = installationId;
    if (generation != null) result.generation = generation;
    if (afterRevision != null) result.afterRevision = afterRevision;
    if (throughRevision != null) result.throughRevision = throughRevision;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListExtensionInstallationAuditRequest._();

  factory ListExtensionInstallationAuditRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationAuditRequest()..mergeFromBuffer(data, registry);
  factory ListExtensionInstallationAuditRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationAuditRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExtensionInstallationAuditRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance:
          ListExtensionInstallationAuditRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'installationId')
    ..aOS(2, _omitFieldNames ? '' : 'generation')
    ..aInt64(3, _omitFieldNames ? '' : 'afterRevision')
    ..aInt64(4, _omitFieldNames ? '' : 'throughRevision')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationAuditRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationAuditRequest copyWith(
          void Function(ListExtensionInstallationAuditRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ListExtensionInstallationAuditRequest))
          as ListExtensionInstallationAuditRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExtensionInstallationAuditRequest() / ListExtensionInstallationAuditRequest.new instead')
  static ListExtensionInstallationAuditRequest create() =>
      ListExtensionInstallationAuditRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListExtensionInstallationAuditRequest._();
  @$core.override
  ListExtensionInstallationAuditRequest createEmptyInstance() =>
      ListExtensionInstallationAuditRequest._();
  @$core.pragma('dart2js:noInline')
  static ListExtensionInstallationAuditRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ListExtensionInstallationAuditRequest>(
          ListExtensionInstallationAuditRequest.$_createMessage);
  static ListExtensionInstallationAuditRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get installationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set installationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstallationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get generation => $_getSZ(1);
  @$pb.TagNumber(2)
  set generation($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGeneration() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneration() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get afterRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set afterRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get throughRevision => $_getI64(3);
  @$pb.TagNumber(4)
  set throughRevision($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasThroughRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearThroughRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListExtensionInstallationAuditResponse extends $pb.GeneratedMessage {
  factory ListExtensionInstallationAuditResponse({
    $core.Iterable<ExtensionInstallationAuditEntry>? entries,
    $fixnum.Int64? nextAfterRevision,
    $fixnum.Int64? throughRevision,
    $core.String? generation,
  }) {
    final result = ListExtensionInstallationAuditResponse._();
    if (entries != null) result.entries.addAll(entries);
    if (nextAfterRevision != null) result.nextAfterRevision = nextAfterRevision;
    if (throughRevision != null) result.throughRevision = throughRevision;
    if (generation != null) result.generation = generation;
    return result;
  }

  ListExtensionInstallationAuditResponse._();

  factory ListExtensionInstallationAuditResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationAuditResponse()..mergeFromBuffer(data, registry);
  factory ListExtensionInstallationAuditResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListExtensionInstallationAuditResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExtensionInstallationAuditResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance:
          ListExtensionInstallationAuditResponse.$_createMessage)
    ..pPM<ExtensionInstallationAuditEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: ExtensionInstallationAuditEntry.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'nextAfterRevision')
    ..aInt64(3, _omitFieldNames ? '' : 'throughRevision')
    ..aOS(4, _omitFieldNames ? '' : 'generation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationAuditResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExtensionInstallationAuditResponse copyWith(
          void Function(ListExtensionInstallationAuditResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListExtensionInstallationAuditResponse))
          as ListExtensionInstallationAuditResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListExtensionInstallationAuditResponse() / ListExtensionInstallationAuditResponse.new instead')
  static ListExtensionInstallationAuditResponse create() =>
      ListExtensionInstallationAuditResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListExtensionInstallationAuditResponse._();
  @$core.override
  ListExtensionInstallationAuditResponse createEmptyInstance() =>
      ListExtensionInstallationAuditResponse._();
  @$core.pragma('dart2js:noInline')
  static ListExtensionInstallationAuditResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ListExtensionInstallationAuditResponse>(
          ListExtensionInstallationAuditResponse.$_createMessage);
  static ListExtensionInstallationAuditResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ExtensionInstallationAuditEntry> get entries => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nextAfterRevision => $_getI64(1);
  @$pb.TagNumber(2)
  set nextAfterRevision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextAfterRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextAfterRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get throughRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set throughRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThroughRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearThroughRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get generation => $_getSZ(3);
  @$pb.TagNumber(4)
  set generation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGeneration() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeneration() => $_clearField(4);
}

/// Доверенный контекст получают до первой отправки и сохраняют вместе с командой.
class GetExtensionMutationContextRequest extends $pb.GeneratedMessage {
  factory GetExtensionMutationContextRequest({
    $core.String? instanceId,
    $core.bool? requestRetryWindow,
  }) {
    final result = GetExtensionMutationContextRequest._();
    if (instanceId != null) result.instanceId = instanceId;
    if (requestRetryWindow != null)
      result.requestRetryWindow = requestRetryWindow;
    return result;
  }

  GetExtensionMutationContextRequest._();

  factory GetExtensionMutationContextRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionMutationContextRequest()..mergeFromBuffer(data, registry);
  factory GetExtensionMutationContextRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionMutationContextRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExtensionMutationContextRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetExtensionMutationContextRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instanceId')
    ..aOB(2, _omitFieldNames ? '' : 'requestRetryWindow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionMutationContextRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionMutationContextRequest copyWith(
          void Function(GetExtensionMutationContextRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetExtensionMutationContextRequest))
          as GetExtensionMutationContextRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetExtensionMutationContextRequest() / GetExtensionMutationContextRequest.new instead')
  static GetExtensionMutationContextRequest create() =>
      GetExtensionMutationContextRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetExtensionMutationContextRequest._();
  @$core.override
  GetExtensionMutationContextRequest createEmptyInstance() =>
      GetExtensionMutationContextRequest._();
  @$core.pragma('dart2js:noInline')
  static GetExtensionMutationContextRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExtensionMutationContextRequest>(
          GetExtensionMutationContextRequest.$_createMessage);
  static GetExtensionMutationContextRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceId() => $_clearField(1);

  /// Только перед новой командой; повтор не запрашивает новое разрешение.
  @$pb.TagNumber(2)
  $core.bool get requestRetryWindow => $_getBF(1);
  @$pb.TagNumber(2)
  set requestRetryWindow($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestRetryWindow() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestRetryWindow() => $_clearField(2);
}

class GetExtensionMutationContextResponse extends $pb.GeneratedMessage {
  factory GetExtensionMutationContextResponse({
    $core.String? historyId,
    $core.String? retryLeaseId,
    $fixnum.Int64? retryWindowRemainingMs,
  }) {
    final result = GetExtensionMutationContextResponse._();
    if (historyId != null) result.historyId = historyId;
    if (retryLeaseId != null) result.retryLeaseId = retryLeaseId;
    if (retryWindowRemainingMs != null)
      result.retryWindowRemainingMs = retryWindowRemainingMs;
    return result;
  }

  GetExtensionMutationContextResponse._();

  factory GetExtensionMutationContextResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionMutationContextResponse()..mergeFromBuffer(data, registry);
  factory GetExtensionMutationContextResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExtensionMutationContextResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExtensionMutationContextResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: GetExtensionMutationContextResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'historyId')
    ..aOS(2, _omitFieldNames ? '' : 'retryLeaseId')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'retryWindowRemainingMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionMutationContextResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExtensionMutationContextResponse copyWith(
          void Function(GetExtensionMutationContextResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetExtensionMutationContextResponse))
          as GetExtensionMutationContextResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetExtensionMutationContextResponse() / GetExtensionMutationContextResponse.new instead')
  static GetExtensionMutationContextResponse create() =>
      GetExtensionMutationContextResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetExtensionMutationContextResponse._();
  @$core.override
  GetExtensionMutationContextResponse createEmptyInstance() =>
      GetExtensionMutationContextResponse._();
  @$core.pragma('dart2js:noInline')
  static GetExtensionMutationContextResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              GetExtensionMutationContextResponse>(
          GetExtensionMutationContextResponse.$_createMessage);
  static GetExtensionMutationContextResponse? _defaultInstance;

  /// 32 строчных шестнадцатеричных символа; меняется при restore, но не restart.
  @$pb.TagNumber(1)
  $core.String get historyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set historyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHistoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHistoryId() => $_clearField(1);

  /// Короткое разрешение, привязанное к principal, экземпляру и истории.
  /// Недействительно после перезапуска исполнителя. Не сохранять как новое окно при resume.
  @$pb.TagNumber(2)
  $core.String get retryLeaseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set retryLeaseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRetryLeaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRetryLeaseId() => $_clearField(2);

  /// 30000 мс от выдачи; клиент отсчитывает от начала RPC монотонными часами.
  @$pb.TagNumber(3)
  $fixnum.Int64 get retryWindowRemainingMs => $_getI64(2);
  @$pb.TagNumber(3)
  set retryWindowRemainingMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRetryWindowRemainingMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearRetryWindowRemainingMs() => $_clearField(3);
}

class QueryExtensionRequest extends $pb.GeneratedMessage {
  factory QueryExtensionRequest({
    $core.String? instanceId,
    $core.String? query,
    $core.List<$core.int>? payloadJson,
  }) {
    final result = QueryExtensionRequest._();
    if (instanceId != null) result.instanceId = instanceId;
    if (query != null) result.query = query;
    if (payloadJson != null) result.payloadJson = payloadJson;
    return result;
  }

  QueryExtensionRequest._();

  factory QueryExtensionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QueryExtensionRequest()..mergeFromBuffer(data, registry);
  factory QueryExtensionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QueryExtensionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueryExtensionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: QueryExtensionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instanceId')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'payloadJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryExtensionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryExtensionRequest copyWith(
          void Function(QueryExtensionRequest) updates) =>
      super.copyWith((message) => updates(message as QueryExtensionRequest))
          as QueryExtensionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use QueryExtensionRequest() / QueryExtensionRequest.new instead')
  static QueryExtensionRequest create() => QueryExtensionRequest._();
  static $pb.GeneratedMessage $_createMessage() => QueryExtensionRequest._();
  @$core.override
  QueryExtensionRequest createEmptyInstance() => QueryExtensionRequest._();
  @$core.pragma('dart2js:noInline')
  static QueryExtensionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryExtensionRequest>(
          QueryExtensionRequest.$_createMessage);
  static QueryExtensionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get payloadJson => $_getN(2);
  @$pb.TagNumber(3)
  set payloadJson($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPayloadJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayloadJson() => $_clearField(3);
}

class QueryExtensionResponse extends $pb.GeneratedMessage {
  factory QueryExtensionResponse({
    $core.List<$core.int>? documentJson,
    $core.String? uiApi,
  }) {
    final result = QueryExtensionResponse._();
    if (documentJson != null) result.documentJson = documentJson;
    if (uiApi != null) result.uiApi = uiApi;
    return result;
  }

  QueryExtensionResponse._();

  factory QueryExtensionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QueryExtensionResponse()..mergeFromBuffer(data, registry);
  factory QueryExtensionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QueryExtensionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueryExtensionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: QueryExtensionResponse.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'documentJson', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'uiApi')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryExtensionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueryExtensionResponse copyWith(
          void Function(QueryExtensionResponse) updates) =>
      super.copyWith((message) => updates(message as QueryExtensionResponse))
          as QueryExtensionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use QueryExtensionResponse() / QueryExtensionResponse.new instead')
  static QueryExtensionResponse create() => QueryExtensionResponse._();
  static $pb.GeneratedMessage $_createMessage() => QueryExtensionResponse._();
  @$core.override
  QueryExtensionResponse createEmptyInstance() => QueryExtensionResponse._();
  @$core.pragma('dart2js:noInline')
  static QueryExtensionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryExtensionResponse>(
          QueryExtensionResponse.$_createMessage);
  static QueryExtensionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get documentJson => $_getN(0);
  @$pb.TagNumber(1)
  set documentJson($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentJson() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get uiApi => $_getSZ(1);
  @$pb.TagNumber(2)
  set uiApi($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUiApi() => $_has(1);
  @$pb.TagNumber(2)
  void clearUiApi() => $_clearField(2);
}

class ExecuteExtensionCommandRequest extends $pb.GeneratedMessage {
  factory ExecuteExtensionCommandRequest({
    $core.String? instanceId,
    $core.String? command,
    $core.List<$core.int>? payloadJson,
    ExtensionCommandEffect? effect,
    $core.String? idempotencyKey,
    $fixnum.Int64? expectedStateRevision,
    $core.String? historyId,
    $core.String? retryLeaseId,
  }) {
    final result = ExecuteExtensionCommandRequest._();
    if (instanceId != null) result.instanceId = instanceId;
    if (command != null) result.command = command;
    if (payloadJson != null) result.payloadJson = payloadJson;
    if (effect != null) result.effect = effect;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (expectedStateRevision != null)
      result.expectedStateRevision = expectedStateRevision;
    if (historyId != null) result.historyId = historyId;
    if (retryLeaseId != null) result.retryLeaseId = retryLeaseId;
    return result;
  }

  ExecuteExtensionCommandRequest._();

  factory ExecuteExtensionCommandRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteExtensionCommandRequest()..mergeFromBuffer(data, registry);
  factory ExecuteExtensionCommandRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteExtensionCommandRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteExtensionCommandRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExecuteExtensionCommandRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instanceId')
    ..aOS(2, _omitFieldNames ? '' : 'command')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'payloadJson', $pb.PbFieldType.OY)
    ..aE<ExtensionCommandEffect>(4, _omitFieldNames ? '' : 'effect',
        enumValues: ExtensionCommandEffect.values)
    ..aOS(5, _omitFieldNames ? '' : 'idempotencyKey')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'expectedStateRevision', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(7, _omitFieldNames ? '' : 'historyId')
    ..aOS(8, _omitFieldNames ? '' : 'retryLeaseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteExtensionCommandRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteExtensionCommandRequest copyWith(
          void Function(ExecuteExtensionCommandRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExecuteExtensionCommandRequest))
          as ExecuteExtensionCommandRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecuteExtensionCommandRequest() / ExecuteExtensionCommandRequest.new instead')
  static ExecuteExtensionCommandRequest create() =>
      ExecuteExtensionCommandRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExecuteExtensionCommandRequest._();
  @$core.override
  ExecuteExtensionCommandRequest createEmptyInstance() =>
      ExecuteExtensionCommandRequest._();
  @$core.pragma('dart2js:noInline')
  static ExecuteExtensionCommandRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteExtensionCommandRequest>(
          ExecuteExtensionCommandRequest.$_createMessage);
  static ExecuteExtensionCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get command => $_getSZ(1);
  @$pb.TagNumber(2)
  set command($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommand() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommand() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get payloadJson => $_getN(2);
  @$pb.TagNumber(3)
  set payloadJson($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPayloadJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayloadJson() => $_clearField(3);

  /// Должен совпадать с доверенным описанием команды. Клиент не выдаёт полномочия.
  @$pb.TagNumber(4)
  ExtensionCommandEffect get effect => $_getN(3);
  @$pb.TagNumber(4)
  set effect(ExtensionCommandEffect value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEffect() => $_has(3);
  @$pb.TagNumber(4)
  void clearEffect() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get idempotencyKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set idempotencyKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIdempotencyKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdempotencyKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expectedStateRevision => $_getI64(5);
  @$pb.TagNumber(6)
  set expectedStateRevision($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedStateRevision() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedStateRevision() => $_clearField(6);

  /// Обязателен для исполнения MUTATION. При повторе менять запрещено.
  /// Для сверки старой квитанции сохраняется исходное значение, включая пустое v1/v2.
  @$pb.TagNumber(7)
  $core.String get historyId => $_getSZ(6);
  @$pb.TagNumber(7)
  set historyId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHistoryId() => $_has(6);
  @$pb.TagNumber(7)
  void clearHistoryId() => $_clearField(7);

  /// Неизменная часть команды/digest. Пустое значение не разрешает автоматический повтор.
  @$pb.TagNumber(8)
  $core.String get retryLeaseId => $_getSZ(7);
  @$pb.TagNumber(8)
  set retryLeaseId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRetryLeaseId() => $_has(7);
  @$pb.TagNumber(8)
  void clearRetryLeaseId() => $_clearField(8);
}

class ExecuteExtensionCommandResponse extends $pb.GeneratedMessage {
  factory ExecuteExtensionCommandResponse({
    $core.List<$core.int>? documentJson,
    ExtensionCommandEffect? effect,
    $fixnum.Int64? stateRevision,
    $core.bool? replayed,
  }) {
    final result = ExecuteExtensionCommandResponse._();
    if (documentJson != null) result.documentJson = documentJson;
    if (effect != null) result.effect = effect;
    if (stateRevision != null) result.stateRevision = stateRevision;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  ExecuteExtensionCommandResponse._();

  factory ExecuteExtensionCommandResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteExtensionCommandResponse()..mergeFromBuffer(data, registry);
  factory ExecuteExtensionCommandResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteExtensionCommandResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteExtensionCommandResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExecuteExtensionCommandResponse.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'documentJson', $pb.PbFieldType.OY)
    ..aE<ExtensionCommandEffect>(2, _omitFieldNames ? '' : 'effect',
        enumValues: ExtensionCommandEffect.values)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'stateRevision', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(4, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteExtensionCommandResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteExtensionCommandResponse copyWith(
          void Function(ExecuteExtensionCommandResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ExecuteExtensionCommandResponse))
          as ExecuteExtensionCommandResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecuteExtensionCommandResponse() / ExecuteExtensionCommandResponse.new instead')
  static ExecuteExtensionCommandResponse create() =>
      ExecuteExtensionCommandResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExecuteExtensionCommandResponse._();
  @$core.override
  ExecuteExtensionCommandResponse createEmptyInstance() =>
      ExecuteExtensionCommandResponse._();
  @$core.pragma('dart2js:noInline')
  static ExecuteExtensionCommandResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteExtensionCommandResponse>(
          ExecuteExtensionCommandResponse.$_createMessage);
  static ExecuteExtensionCommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get documentJson => $_getN(0);
  @$pb.TagNumber(1)
  set documentJson($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDocumentJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearDocumentJson() => $_clearField(1);

  @$pb.TagNumber(2)
  ExtensionCommandEffect get effect => $_getN(1);
  @$pb.TagNumber(2)
  set effect(ExtensionCommandEffect value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffect() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffect() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get stateRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set stateRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStateRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearStateRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get replayed => $_getBF(3);
  @$pb.TagNumber(4)
  set replayed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReplayed() => $_has(3);
  @$pb.TagNumber(4)
  void clearReplayed() => $_clearField(4);
}

/// Проверяет точный исходный запрос, не исполняя команду и не вызывая WASM.
class ReconcileExtensionCommandRequest extends $pb.GeneratedMessage {
  factory ReconcileExtensionCommandRequest({
    ExecuteExtensionCommandRequest? command,
  }) {
    final result = ReconcileExtensionCommandRequest._();
    if (command != null) result.command = command;
    return result;
  }

  ReconcileExtensionCommandRequest._();

  factory ReconcileExtensionCommandRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileExtensionCommandRequest()..mergeFromBuffer(data, registry);
  factory ReconcileExtensionCommandRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileExtensionCommandRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileExtensionCommandRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReconcileExtensionCommandRequest.$_createMessage)
    ..aOM<ExecuteExtensionCommandRequest>(1, _omitFieldNames ? '' : 'command',
        subBuilder: ExecuteExtensionCommandRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileExtensionCommandRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileExtensionCommandRequest copyWith(
          void Function(ReconcileExtensionCommandRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ReconcileExtensionCommandRequest))
          as ReconcileExtensionCommandRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconcileExtensionCommandRequest() / ReconcileExtensionCommandRequest.new instead')
  static ReconcileExtensionCommandRequest create() =>
      ReconcileExtensionCommandRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconcileExtensionCommandRequest._();
  @$core.override
  ReconcileExtensionCommandRequest createEmptyInstance() =>
      ReconcileExtensionCommandRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconcileExtensionCommandRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileExtensionCommandRequest>(
          ReconcileExtensionCommandRequest.$_createMessage);
  static ReconcileExtensionCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ExecuteExtensionCommandRequest get command => $_getN(0);
  @$pb.TagNumber(1)
  set command(ExecuteExtensionCommandRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => $_clearField(1);
  @$pb.TagNumber(1)
  ExecuteExtensionCommandRequest ensureCommand() => $_ensure(0);
}

class ReconcileExtensionCommandResponse extends $pb.GeneratedMessage {
  factory ReconcileExtensionCommandResponse({
    ExtensionCommandOutcome? outcome,
    ExecuteExtensionCommandResponse? receipt,
    $core.bool? retryWindowKnown,
    $fixnum.Int64? retryWindowRemainingMs,
  }) {
    final result = ReconcileExtensionCommandResponse._();
    if (outcome != null) result.outcome = outcome;
    if (receipt != null) result.receipt = receipt;
    if (retryWindowKnown != null) result.retryWindowKnown = retryWindowKnown;
    if (retryWindowRemainingMs != null)
      result.retryWindowRemainingMs = retryWindowRemainingMs;
    return result;
  }

  ReconcileExtensionCommandResponse._();

  factory ReconcileExtensionCommandResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileExtensionCommandResponse()..mergeFromBuffer(data, registry);
  factory ReconcileExtensionCommandResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcileExtensionCommandResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileExtensionCommandResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ReconcileExtensionCommandResponse.$_createMessage)
    ..aE<ExtensionCommandOutcome>(1, _omitFieldNames ? '' : 'outcome',
        enumValues: ExtensionCommandOutcome.values)
    ..aOM<ExecuteExtensionCommandResponse>(2, _omitFieldNames ? '' : 'receipt',
        subBuilder: ExecuteExtensionCommandResponse.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'retryWindowKnown')
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'retryWindowRemainingMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileExtensionCommandResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileExtensionCommandResponse copyWith(
          void Function(ReconcileExtensionCommandResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconcileExtensionCommandResponse))
          as ReconcileExtensionCommandResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconcileExtensionCommandResponse() / ReconcileExtensionCommandResponse.new instead')
  static ReconcileExtensionCommandResponse create() =>
      ReconcileExtensionCommandResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconcileExtensionCommandResponse._();
  @$core.override
  ReconcileExtensionCommandResponse createEmptyInstance() =>
      ReconcileExtensionCommandResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconcileExtensionCommandResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileExtensionCommandResponse>(
          ReconcileExtensionCommandResponse.$_createMessage);
  static ReconcileExtensionCommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ExtensionCommandOutcome get outcome => $_getN(0);
  @$pb.TagNumber(1)
  set outcome(ExtensionCommandOutcome value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutcome() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutcome() => $_clearField(1);

  /// Только для CONFIRMED; выдача требует текущих прав исполнения команды.
  @$pb.TagNumber(2)
  ExecuteExtensionCommandResponse get receipt => $_getN(1);
  @$pb.TagNumber(2)
  set receipt(ExecuteExtensionCommandResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReceipt() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceipt() => $_clearField(2);
  @$pb.TagNumber(2)
  ExecuteExtensionCommandResponse ensureReceipt() => $_ensure(1);

  /// Сверка возвращает false/0 и не открывает окно заново. Короткое окно выдаёт контекст новой команды.
  /// UNKNOWN никогда не разрешает повторную отправку сам по себе.
  @$pb.TagNumber(3)
  $core.bool get retryWindowKnown => $_getBF(2);
  @$pb.TagNumber(3)
  set retryWindowKnown($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRetryWindowKnown() => $_has(2);
  @$pb.TagNumber(3)
  void clearRetryWindowKnown() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get retryWindowRemainingMs => $_getI64(3);
  @$pb.TagNumber(4)
  set retryWindowRemainingMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRetryWindowRemainingMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearRetryWindowRemainingMs() => $_clearField(4);
}

/// Недоверенное предложение WASM, не SQL и не разрешение записи.
/// Приёмка требует новой проверки сессии/ACL внутри транзакции записи.
class ExtensionMutationPlan extends $pb.GeneratedMessage {
  factory ExtensionMutationPlan({
    $fixnum.Int64? expectedStateRevision,
    $core.Iterable<ExtensionMutationOperation>? operations,
    $core.Iterable<ExtensionMutationEvent>? events,
  }) {
    final result = ExtensionMutationPlan._();
    if (expectedStateRevision != null)
      result.expectedStateRevision = expectedStateRevision;
    if (operations != null) result.operations.addAll(operations);
    if (events != null) result.events.addAll(events);
    return result;
  }

  ExtensionMutationPlan._();

  factory ExtensionMutationPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionMutationPlan()..mergeFromBuffer(data, registry);
  factory ExtensionMutationPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionMutationPlan()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionMutationPlan',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExtensionMutationPlan.$_createMessage)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'expectedStateRevision', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPM<ExtensionMutationOperation>(2, _omitFieldNames ? '' : 'operations',
        subBuilder: ExtensionMutationOperation.$_createMessage)
    ..pPM<ExtensionMutationEvent>(3, _omitFieldNames ? '' : 'events',
        subBuilder: ExtensionMutationEvent.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionMutationPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionMutationPlan copyWith(
          void Function(ExtensionMutationPlan) updates) =>
      super.copyWith((message) => updates(message as ExtensionMutationPlan))
          as ExtensionMutationPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExtensionMutationPlan() / ExtensionMutationPlan.new instead')
  static ExtensionMutationPlan create() => ExtensionMutationPlan._();
  static $pb.GeneratedMessage $_createMessage() => ExtensionMutationPlan._();
  @$core.override
  ExtensionMutationPlan createEmptyInstance() => ExtensionMutationPlan._();
  @$core.pragma('dart2js:noInline')
  static ExtensionMutationPlan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionMutationPlan>(
          ExtensionMutationPlan.$_createMessage);
  static ExtensionMutationPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get expectedStateRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set expectedStateRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExpectedStateRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpectedStateRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ExtensionMutationOperation> get operations => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ExtensionMutationEvent> get events => $_getList(2);
}

enum ExtensionMutationOperation_Change { putJson, delete, notSet }

class ExtensionMutationOperation extends $pb.GeneratedMessage {
  factory ExtensionMutationOperation({
    $core.String? key,
    $core.List<$core.int>? putJson,
    $core.bool? delete,
  }) {
    final result = ExtensionMutationOperation._();
    if (key != null) result.key = key;
    if (putJson != null) result.putJson = putJson;
    if (delete != null) result.delete = delete;
    return result;
  }

  ExtensionMutationOperation._();

  factory ExtensionMutationOperation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionMutationOperation()..mergeFromBuffer(data, registry);
  factory ExtensionMutationOperation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionMutationOperation()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ExtensionMutationOperation_Change>
      _ExtensionMutationOperation_ChangeByTag = {
    2: ExtensionMutationOperation_Change.putJson,
    3: ExtensionMutationOperation_Change.delete,
    0: ExtensionMutationOperation_Change.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionMutationOperation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExtensionMutationOperation.$_createMessage)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'putJson', $pb.PbFieldType.OY)
    ..aOB(3, _omitFieldNames ? '' : 'delete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionMutationOperation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionMutationOperation copyWith(
          void Function(ExtensionMutationOperation) updates) =>
      super.copyWith(
              (message) => updates(message as ExtensionMutationOperation))
          as ExtensionMutationOperation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExtensionMutationOperation() / ExtensionMutationOperation.new instead')
  static ExtensionMutationOperation create() => ExtensionMutationOperation._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExtensionMutationOperation._();
  @$core.override
  ExtensionMutationOperation createEmptyInstance() =>
      ExtensionMutationOperation._();
  @$core.pragma('dart2js:noInline')
  static ExtensionMutationOperation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionMutationOperation>(
          ExtensionMutationOperation.$_createMessage);
  static ExtensionMutationOperation? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  ExtensionMutationOperation_Change whichChange() =>
      _ExtensionMutationOperation_ChangeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearChange() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get putJson => $_getN(1);
  @$pb.TagNumber(2)
  set putJson($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPutJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearPutJson() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get delete => $_getBF(2);
  @$pb.TagNumber(3)
  set delete($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDelete() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelete() => $_clearField(3);
}

class ExtensionMutationEvent extends $pb.GeneratedMessage {
  factory ExtensionMutationEvent({
    $core.String? type,
    $core.List<$core.int>? payloadJson,
  }) {
    final result = ExtensionMutationEvent._();
    if (type != null) result.type = type;
    if (payloadJson != null) result.payloadJson = payloadJson;
    return result;
  }

  ExtensionMutationEvent._();

  factory ExtensionMutationEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionMutationEvent()..mergeFromBuffer(data, registry);
  factory ExtensionMutationEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtensionMutationEvent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionMutationEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExtensionMutationEvent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'payloadJson', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionMutationEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionMutationEvent copyWith(
          void Function(ExtensionMutationEvent) updates) =>
      super.copyWith((message) => updates(message as ExtensionMutationEvent))
          as ExtensionMutationEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExtensionMutationEvent() / ExtensionMutationEvent.new instead')
  static ExtensionMutationEvent create() => ExtensionMutationEvent._();
  static $pb.GeneratedMessage $_createMessage() => ExtensionMutationEvent._();
  @$core.override
  ExtensionMutationEvent createEmptyInstance() => ExtensionMutationEvent._();
  @$core.pragma('dart2js:noInline')
  static ExtensionMutationEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionMutationEvent>(
          ExtensionMutationEvent.$_createMessage);
  static ExtensionMutationEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get payloadJson => $_getN(1);
  @$pb.TagNumber(2)
  set payloadJson($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPayloadJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayloadJson() => $_clearField(2);
}

/// Эксперимент P1. Отдельная регистрация, без публичной capability v1.
class ExtensionP1ServiceApi {
  final $pb.RpcClient _client;

  ExtensionP1ServiceApi(this._client);

  $async.Future<ListExtensionContributionsResponse> listExtensionContributions(
          $pb.ClientContext? ctx, ListExtensionContributionsRequest request) =>
      _client.invoke<ListExtensionContributionsResponse>(
          ctx,
          'ExtensionP1Service',
          'ListExtensionContributions',
          request,
          ListExtensionContributionsResponse());
  $async.Future<QueryExtensionResponse> queryExtension(
          $pb.ClientContext? ctx, QueryExtensionRequest request) =>
      _client.invoke<QueryExtensionResponse>(ctx, 'ExtensionP1Service',
          'QueryExtension', request, QueryExtensionResponse());
  $async.Future<ExecuteExtensionCommandResponse> executeExtensionCommand(
          $pb.ClientContext? ctx, ExecuteExtensionCommandRequest request) =>
      _client.invoke<ExecuteExtensionCommandResponse>(
          ctx,
          'ExtensionP1Service',
          'ExecuteExtensionCommand',
          request,
          ExecuteExtensionCommandResponse());
  $async.Future<ReconcileExtensionCommandResponse> reconcileExtensionCommand(
          $pb.ClientContext? ctx, ReconcileExtensionCommandRequest request) =>
      _client.invoke<ReconcileExtensionCommandResponse>(
          ctx,
          'ExtensionP1Service',
          'ReconcileExtensionCommand',
          request,
          ReconcileExtensionCommandResponse());
  $async.Future<GetExtensionMutationContextResponse>
      getExtensionMutationContext($pb.ClientContext? ctx,
              GetExtensionMutationContextRequest request) =>
          _client.invoke<GetExtensionMutationContextResponse>(
              ctx,
              'ExtensionP1Service',
              'GetExtensionMutationContext',
              request,
              GetExtensionMutationContextResponse());
  $async.Future<ListExtensionInstallationsResponse> listExtensionInstallations(
          $pb.ClientContext? ctx, ListExtensionInstallationsRequest request) =>
      _client.invoke<ListExtensionInstallationsResponse>(
          ctx,
          'ExtensionP1Service',
          'ListExtensionInstallations',
          request,
          ListExtensionInstallationsResponse());
  $async.Future<GetExtensionInstallationResponse> getExtensionInstallation(
          $pb.ClientContext? ctx, GetExtensionInstallationRequest request) =>
      _client.invoke<GetExtensionInstallationResponse>(
          ctx,
          'ExtensionP1Service',
          'GetExtensionInstallation',
          request,
          GetExtensionInstallationResponse());
  $async.Future<ChangeExtensionInstallationResponse>
      changeExtensionInstallation($pb.ClientContext? ctx,
              ChangeExtensionInstallationRequest request) =>
          _client.invoke<ChangeExtensionInstallationResponse>(
              ctx,
              'ExtensionP1Service',
              'ChangeExtensionInstallation',
              request,
              ChangeExtensionInstallationResponse());
  $async.Future<ListExtensionInstallationAuditResponse>
      listExtensionInstallationAudit($pb.ClientContext? ctx,
              ListExtensionInstallationAuditRequest request) =>
          _client.invoke<ListExtensionInstallationAuditResponse>(
              ctx,
              'ExtensionP1Service',
              'ListExtensionInstallationAudit',
              request,
              ListExtensionInstallationAuditResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
