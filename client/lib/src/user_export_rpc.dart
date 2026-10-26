part of 'core.dart';

class SessionUserExportApi implements UserExportApi {
  SessionUserExportApi(this.session);
  final SpaceSession session;
  @override String get scopeId=>'${session.positionScope}|${session.currentGrantId}';
  @override String get principalId=>session.principalId;
  @override String get serverId=>session.server.serverId;
  @override Future<user_export_pb.ExportUserContentResponse> export(user_export_pb.ExportUserContentRequest request) async {
    if(!session.userExportSupported) throw const GrpcError.unimplemented();
    await session._ensureSession();
    return session.channel.unary(user_export_specs.UserExportService.exportUserContent,request,options:session._options);
  }
}
