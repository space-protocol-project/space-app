import 'generated/space/v1/user_export.pb.dart';
export 'generated/space/v1/user_export.pb.dart';

abstract interface class UserExportApi {
  String get scopeId;
  String get principalId;
  String get serverId;
  Future<ExportUserContentResponse> export(ExportUserContentRequest request);
}

abstract interface class UserExportSource {
  UserExportApi? get userExport;
}
