//
//  Generated code. Do not modify.
//  source: space/v1/builtin.proto
//

import "package:connectrpc/connect.dart" as connect;
import "builtin.pb.dart" as spacev1builtin;

/// Рабочий профиль P2 для встроенных адаптеров. Не предоставляет установку WASM.
abstract final class BuiltinExtensionService {
  /// Fully-qualified name of the BuiltinExtensionService service.
  static const name = 'space.v1.BuiltinExtensionService';

  static const listBuiltinSections = connect.Spec(
    '/$name/ListBuiltinSections',
    connect.StreamType.unary,
    spacev1builtin.ListBuiltinSectionsRequest.new,
    spacev1builtin.ListBuiltinSectionsResponse.new,
  );

  static const openBuiltinSection = connect.Spec(
    '/$name/OpenBuiltinSection',
    connect.StreamType.unary,
    spacev1builtin.OpenBuiltinSectionRequest.new,
    spacev1builtin.OpenBuiltinSectionResponse.new,
  );

  static const executeBuiltinCommand = connect.Spec(
    '/$name/ExecuteBuiltinCommand',
    connect.StreamType.unary,
    spacev1builtin.ExecuteBuiltinCommandRequest.new,
    spacev1builtin.ExecuteBuiltinCommandResponse.new,
  );
}
