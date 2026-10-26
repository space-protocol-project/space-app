//
//  Generated code. Do not modify.
//  source: space/v1/user_export.proto
//

import "package:connectrpc/connect.dart" as connect;
import "user_export.pb.dart" as spacev1user_export;
import "user_export.connect.spec.dart" as specs;

/// core.user.export.v1: собственное доступное содержимое, без ключей и токенов.
extension type UserExportServiceClient (connect.Transport _transport) {
  Future<spacev1user_export.ExportUserContentResponse> exportUserContent(
    spacev1user_export.ExportUserContentRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.UserExportService.exportUserContent,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
