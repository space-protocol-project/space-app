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
  }) {
    final result = ExecuteExtensionCommandRequest._();
    if (instanceId != null) result.instanceId = instanceId;
    if (command != null) result.command = command;
    if (payloadJson != null) result.payloadJson = payloadJson;
    if (effect != null) result.effect = effect;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (expectedStateRevision != null)
      result.expectedStateRevision = expectedStateRevision;
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

  /// P1 пока возвращает false/0: гарантированное окно до первой отправки ещё не реализовано.
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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
