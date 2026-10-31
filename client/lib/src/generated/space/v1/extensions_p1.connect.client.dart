//
//  Generated code. Do not modify.
//  source: space/v1/extensions_p1.proto
//

import "package:connectrpc/connect.dart" as connect;
import "extensions_p1.pb.dart" as spacev1extensions_p1;
import "extensions_p1.connect.spec.dart" as specs;

/// Эксперимент P1. Отдельная регистрация, без публичной capability v1.
extension type ExtensionP1ServiceClient (connect.Transport _transport) {
  Future<spacev1extensions_p1.QueryExtensionResponse> queryExtension(
    spacev1extensions_p1.QueryExtensionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtensionP1Service.queryExtension,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1extensions_p1.ExecuteExtensionCommandResponse> executeExtensionCommand(
    spacev1extensions_p1.ExecuteExtensionCommandRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtensionP1Service.executeExtensionCommand,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1extensions_p1.ReconcileExtensionCommandResponse> reconcileExtensionCommand(
    spacev1extensions_p1.ReconcileExtensionCommandRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtensionP1Service.reconcileExtensionCommand,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1extensions_p1.GetExtensionMutationContextResponse> getExtensionMutationContext(
    spacev1extensions_p1.GetExtensionMutationContextRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ExtensionP1Service.getExtensionMutationContext,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
