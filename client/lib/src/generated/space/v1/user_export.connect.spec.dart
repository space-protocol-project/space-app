//
//  Generated code. Do not modify.
//  source: space/v1/user_export.proto
//

import "package:connectrpc/connect.dart" as connect;
import "user_export.pb.dart" as spacev1user_export;

/// core.user.export.v1: собственное доступное содержимое, без ключей и токенов.
abstract final class UserExportService {
  /// Fully-qualified name of the UserExportService service.
  static const name = 'space.v1.UserExportService';

  static const exportUserContent = connect.Spec(
    '/$name/ExportUserContent',
    connect.StreamType.unary,
    spacev1user_export.ExportUserContentRequest.new,
    spacev1user_export.ExportUserContentResponse.new,
  );
}
