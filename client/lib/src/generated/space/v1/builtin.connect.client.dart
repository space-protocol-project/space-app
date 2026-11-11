//
//  Generated code. Do not modify.
//  source: space/v1/builtin.proto
//

import "package:connectrpc/connect.dart" as connect;
import "builtin.pb.dart" as spacev1builtin;
import "builtin.connect.spec.dart" as specs;

/// Рабочий профиль P2 для встроенных адаптеров. Не предоставляет установку WASM.
extension type BuiltinExtensionServiceClient (connect.Transport _transport) {
  Future<spacev1builtin.ListBuiltinSectionsResponse> listBuiltinSections(
    spacev1builtin.ListBuiltinSectionsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.BuiltinExtensionService.listBuiltinSections,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1builtin.OpenBuiltinSectionResponse> openBuiltinSection(
    spacev1builtin.OpenBuiltinSectionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.BuiltinExtensionService.openBuiltinSection,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1builtin.ExecuteBuiltinCommandResponse> executeBuiltinCommand(
    spacev1builtin.ExecuteBuiltinCommandRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.BuiltinExtensionService.executeBuiltinCommand,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
