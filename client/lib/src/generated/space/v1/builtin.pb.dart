// This is a generated file - do not edit.
//
// Generated from space/v1/builtin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart' as $1;

import 'space.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BuiltinSection extends $pb.GeneratedMessage {
  factory BuiltinSection({
    $core.String? instanceId,
    $core.String? installationId,
    $core.String? pluginId,
    $core.String? version,
    $core.String? viewId,
    $0.Channel? channel,
  }) {
    final result = BuiltinSection._();
    if (instanceId != null) result.instanceId = instanceId;
    if (installationId != null) result.installationId = installationId;
    if (pluginId != null) result.pluginId = pluginId;
    if (version != null) result.version = version;
    if (viewId != null) result.viewId = viewId;
    if (channel != null) result.channel = channel;
    return result;
  }

  BuiltinSection._();

  factory BuiltinSection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BuiltinSection()..mergeFromBuffer(data, registry);
  factory BuiltinSection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BuiltinSection()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BuiltinSection',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: BuiltinSection.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instanceId')
    ..aOS(2, _omitFieldNames ? '' : 'installationId')
    ..aOS(3, _omitFieldNames ? '' : 'pluginId')
    ..aOS(4, _omitFieldNames ? '' : 'version')
    ..aOS(5, _omitFieldNames ? '' : 'viewId')
    ..aOM<$0.Channel>(6, _omitFieldNames ? '' : 'channel',
        subBuilder: $0.Channel.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuiltinSection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuiltinSection copyWith(void Function(BuiltinSection) updates) =>
      super.copyWith((message) => updates(message as BuiltinSection))
          as BuiltinSection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BuiltinSection() / BuiltinSection.new instead')
  static BuiltinSection create() => BuiltinSection._();
  static $pb.GeneratedMessage $_createMessage() => BuiltinSection._();
  @$core.override
  BuiltinSection createEmptyInstance() => BuiltinSection._();
  @$core.pragma('dart2js:noInline')
  static BuiltinSection getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BuiltinSection>(
          BuiltinSection.$_createMessage);
  static BuiltinSection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get installationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set installationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstallationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstallationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pluginId => $_getSZ(2);
  @$pb.TagNumber(3)
  set pluginId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPluginId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPluginId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get viewId => $_getSZ(4);
  @$pb.TagNumber(5)
  set viewId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasViewId() => $_has(4);
  @$pb.TagNumber(5)
  void clearViewId() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Channel get channel => $_getN(5);
  @$pb.TagNumber(6)
  set channel($0.Channel value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasChannel() => $_has(5);
  @$pb.TagNumber(6)
  void clearChannel() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Channel ensureChannel() => $_ensure(5);
}

class ListBuiltinSectionsRequest extends $pb.GeneratedMessage {
  factory ListBuiltinSectionsRequest() => ListBuiltinSectionsRequest._();

  ListBuiltinSectionsRequest._();

  factory ListBuiltinSectionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBuiltinSectionsRequest()..mergeFromBuffer(data, registry);
  factory ListBuiltinSectionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBuiltinSectionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBuiltinSectionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListBuiltinSectionsRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBuiltinSectionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBuiltinSectionsRequest copyWith(
          void Function(ListBuiltinSectionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListBuiltinSectionsRequest))
          as ListBuiltinSectionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListBuiltinSectionsRequest() / ListBuiltinSectionsRequest.new instead')
  static ListBuiltinSectionsRequest create() => ListBuiltinSectionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListBuiltinSectionsRequest._();
  @$core.override
  ListBuiltinSectionsRequest createEmptyInstance() =>
      ListBuiltinSectionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListBuiltinSectionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBuiltinSectionsRequest>(
          ListBuiltinSectionsRequest.$_createMessage);
  static ListBuiltinSectionsRequest? _defaultInstance;
}

class ListBuiltinSectionsResponse extends $pb.GeneratedMessage {
  factory ListBuiltinSectionsResponse({
    $core.Iterable<BuiltinSection>? sections,
  }) {
    final result = ListBuiltinSectionsResponse._();
    if (sections != null) result.sections.addAll(sections);
    return result;
  }

  ListBuiltinSectionsResponse._();

  factory ListBuiltinSectionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBuiltinSectionsResponse()..mergeFromBuffer(data, registry);
  factory ListBuiltinSectionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBuiltinSectionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBuiltinSectionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ListBuiltinSectionsResponse.$_createMessage)
    ..pPM<BuiltinSection>(1, _omitFieldNames ? '' : 'sections',
        subBuilder: BuiltinSection.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBuiltinSectionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBuiltinSectionsResponse copyWith(
          void Function(ListBuiltinSectionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListBuiltinSectionsResponse))
          as ListBuiltinSectionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListBuiltinSectionsResponse() / ListBuiltinSectionsResponse.new instead')
  static ListBuiltinSectionsResponse create() =>
      ListBuiltinSectionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListBuiltinSectionsResponse._();
  @$core.override
  ListBuiltinSectionsResponse createEmptyInstance() =>
      ListBuiltinSectionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListBuiltinSectionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBuiltinSectionsResponse>(
          ListBuiltinSectionsResponse.$_createMessage);
  static ListBuiltinSectionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BuiltinSection> get sections => $_getList(0);
}

class OpenBuiltinSectionRequest extends $pb.GeneratedMessage {
  factory OpenBuiltinSectionRequest({
    $core.String? instanceId,
  }) {
    final result = OpenBuiltinSectionRequest._();
    if (instanceId != null) result.instanceId = instanceId;
    return result;
  }

  OpenBuiltinSectionRequest._();

  factory OpenBuiltinSectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenBuiltinSectionRequest()..mergeFromBuffer(data, registry);
  factory OpenBuiltinSectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenBuiltinSectionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenBuiltinSectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: OpenBuiltinSectionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instanceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenBuiltinSectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenBuiltinSectionRequest copyWith(
          void Function(OpenBuiltinSectionRequest) updates) =>
      super.copyWith((message) => updates(message as OpenBuiltinSectionRequest))
          as OpenBuiltinSectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpenBuiltinSectionRequest() / OpenBuiltinSectionRequest.new instead')
  static OpenBuiltinSectionRequest create() => OpenBuiltinSectionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpenBuiltinSectionRequest._();
  @$core.override
  OpenBuiltinSectionRequest createEmptyInstance() =>
      OpenBuiltinSectionRequest._();
  @$core.pragma('dart2js:noInline')
  static OpenBuiltinSectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenBuiltinSectionRequest>(
          OpenBuiltinSectionRequest.$_createMessage);
  static OpenBuiltinSectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceId() => $_clearField(1);
}

class OpenBuiltinSectionResponse extends $pb.GeneratedMessage {
  factory OpenBuiltinSectionResponse({
    BuiltinSection? section,
    $1.Any? content,
  }) {
    final result = OpenBuiltinSectionResponse._();
    if (section != null) result.section = section;
    if (content != null) result.content = content;
    return result;
  }

  OpenBuiltinSectionResponse._();

  factory OpenBuiltinSectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenBuiltinSectionResponse()..mergeFromBuffer(data, registry);
  factory OpenBuiltinSectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpenBuiltinSectionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenBuiltinSectionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: OpenBuiltinSectionResponse.$_createMessage)
    ..aOM<BuiltinSection>(1, _omitFieldNames ? '' : 'section',
        subBuilder: BuiltinSection.$_createMessage)
    ..aOM<$1.Any>(2, _omitFieldNames ? '' : 'content',
        subBuilder: $1.Any.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenBuiltinSectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenBuiltinSectionResponse copyWith(
          void Function(OpenBuiltinSectionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpenBuiltinSectionResponse))
          as OpenBuiltinSectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpenBuiltinSectionResponse() / OpenBuiltinSectionResponse.new instead')
  static OpenBuiltinSectionResponse create() => OpenBuiltinSectionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpenBuiltinSectionResponse._();
  @$core.override
  OpenBuiltinSectionResponse createEmptyInstance() =>
      OpenBuiltinSectionResponse._();
  @$core.pragma('dart2js:noInline')
  static OpenBuiltinSectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenBuiltinSectionResponse>(
          OpenBuiltinSectionResponse.$_createMessage);
  static OpenBuiltinSectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BuiltinSection get section => $_getN(0);
  @$pb.TagNumber(1)
  set section(BuiltinSection value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSection() => $_has(0);
  @$pb.TagNumber(1)
  void clearSection() => $_clearField(1);
  @$pb.TagNumber(1)
  BuiltinSection ensureSection() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Any get content => $_getN(1);
  @$pb.TagNumber(2)
  set content($1.Any value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Any ensureContent() => $_ensure(1);
}

class ExecuteBuiltinCommandRequest extends $pb.GeneratedMessage {
  factory ExecuteBuiltinCommandRequest({
    $core.String? instanceId,
    $1.Any? command,
  }) {
    final result = ExecuteBuiltinCommandRequest._();
    if (instanceId != null) result.instanceId = instanceId;
    if (command != null) result.command = command;
    return result;
  }

  ExecuteBuiltinCommandRequest._();

  factory ExecuteBuiltinCommandRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteBuiltinCommandRequest()..mergeFromBuffer(data, registry);
  factory ExecuteBuiltinCommandRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteBuiltinCommandRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteBuiltinCommandRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExecuteBuiltinCommandRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instanceId')
    ..aOM<$1.Any>(2, _omitFieldNames ? '' : 'command',
        subBuilder: $1.Any.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteBuiltinCommandRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteBuiltinCommandRequest copyWith(
          void Function(ExecuteBuiltinCommandRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExecuteBuiltinCommandRequest))
          as ExecuteBuiltinCommandRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecuteBuiltinCommandRequest() / ExecuteBuiltinCommandRequest.new instead')
  static ExecuteBuiltinCommandRequest create() =>
      ExecuteBuiltinCommandRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExecuteBuiltinCommandRequest._();
  @$core.override
  ExecuteBuiltinCommandRequest createEmptyInstance() =>
      ExecuteBuiltinCommandRequest._();
  @$core.pragma('dart2js:noInline')
  static ExecuteBuiltinCommandRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteBuiltinCommandRequest>(
          ExecuteBuiltinCommandRequest.$_createMessage);
  static ExecuteBuiltinCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceId() => $_clearField(1);

  /// Только типы из фиксированного списка встроенных команд. channel_id должен
  /// точно совпадать с каналом экземпляра. Ключи повторов передаются без изменения.
  /// Произвольный URL, метод или внешний пакет выполнить невозможно.
  @$pb.TagNumber(2)
  $1.Any get command => $_getN(1);
  @$pb.TagNumber(2)
  set command($1.Any value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCommand() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommand() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Any ensureCommand() => $_ensure(1);
}

class ExecuteBuiltinCommandResponse extends $pb.GeneratedMessage {
  factory ExecuteBuiltinCommandResponse({
    $1.Any? result,
  }) {
    final result$ = ExecuteBuiltinCommandResponse._();
    if (result != null) result$.result = result;
    return result$;
  }

  ExecuteBuiltinCommandResponse._();

  factory ExecuteBuiltinCommandResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteBuiltinCommandResponse()..mergeFromBuffer(data, registry);
  factory ExecuteBuiltinCommandResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteBuiltinCommandResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteBuiltinCommandResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'space.v1'),
      createEmptyInstance: ExecuteBuiltinCommandResponse.$_createMessage)
    ..aOM<$1.Any>(1, _omitFieldNames ? '' : 'result',
        subBuilder: $1.Any.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteBuiltinCommandResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteBuiltinCommandResponse copyWith(
          void Function(ExecuteBuiltinCommandResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ExecuteBuiltinCommandResponse))
          as ExecuteBuiltinCommandResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecuteBuiltinCommandResponse() / ExecuteBuiltinCommandResponse.new instead')
  static ExecuteBuiltinCommandResponse create() =>
      ExecuteBuiltinCommandResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExecuteBuiltinCommandResponse._();
  @$core.override
  ExecuteBuiltinCommandResponse createEmptyInstance() =>
      ExecuteBuiltinCommandResponse._();
  @$core.pragma('dart2js:noInline')
  static ExecuteBuiltinCommandResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteBuiltinCommandResponse>(
          ExecuteBuiltinCommandResponse.$_createMessage);
  static ExecuteBuiltinCommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Any get result => $_getN(0);
  @$pb.TagNumber(1)
  set result($1.Any value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Any ensureResult() => $_ensure(0);
}

/// Рабочий профиль P2 для встроенных адаптеров. Не предоставляет установку WASM.
class BuiltinExtensionServiceApi {
  final $pb.RpcClient _client;

  BuiltinExtensionServiceApi(this._client);

  $async.Future<ListBuiltinSectionsResponse> listBuiltinSections(
          $pb.ClientContext? ctx, ListBuiltinSectionsRequest request) =>
      _client.invoke<ListBuiltinSectionsResponse>(
          ctx,
          'BuiltinExtensionService',
          'ListBuiltinSections',
          request,
          ListBuiltinSectionsResponse());
  $async.Future<OpenBuiltinSectionResponse> openBuiltinSection(
          $pb.ClientContext? ctx, OpenBuiltinSectionRequest request) =>
      _client.invoke<OpenBuiltinSectionResponse>(ctx, 'BuiltinExtensionService',
          'OpenBuiltinSection', request, OpenBuiltinSectionResponse());
  $async.Future<ExecuteBuiltinCommandResponse> executeBuiltinCommand(
          $pb.ClientContext? ctx, ExecuteBuiltinCommandRequest request) =>
      _client.invoke<ExecuteBuiltinCommandResponse>(
          ctx,
          'BuiltinExtensionService',
          'ExecuteBuiltinCommand',
          request,
          ExecuteBuiltinCommandResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
