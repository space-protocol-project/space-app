//
//  Generated code. Do not modify.
//  source: space/v1/extensions_p1.proto
//

import "package:connectrpc/connect.dart" as connect;
import "extensions_p1.pb.dart" as spacev1extensions_p1;

/// Эксперимент P1. Отдельная регистрация, без публичной capability v1.
abstract final class ExtensionP1Service {
  /// Fully-qualified name of the ExtensionP1Service service.
  static const name = 'space.v1.ExtensionP1Service';

  static const queryExtension = connect.Spec(
    '/$name/QueryExtension',
    connect.StreamType.unary,
    spacev1extensions_p1.QueryExtensionRequest.new,
    spacev1extensions_p1.QueryExtensionResponse.new,
  );

  static const executeExtensionCommand = connect.Spec(
    '/$name/ExecuteExtensionCommand',
    connect.StreamType.unary,
    spacev1extensions_p1.ExecuteExtensionCommandRequest.new,
    spacev1extensions_p1.ExecuteExtensionCommandResponse.new,
  );

  static const reconcileExtensionCommand = connect.Spec(
    '/$name/ReconcileExtensionCommand',
    connect.StreamType.unary,
    spacev1extensions_p1.ReconcileExtensionCommandRequest.new,
    spacev1extensions_p1.ReconcileExtensionCommandResponse.new,
  );

  static const getExtensionMutationContext = connect.Spec(
    '/$name/GetExtensionMutationContext',
    connect.StreamType.unary,
    spacev1extensions_p1.GetExtensionMutationContextRequest.new,
    spacev1extensions_p1.GetExtensionMutationContextResponse.new,
  );
}
