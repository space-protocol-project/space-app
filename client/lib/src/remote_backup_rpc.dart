import 'core.dart' show SpaceSession;
import 'generated/space/v1/remote_backup.pb.dart';
import 'generated/space/v1/remote_backup.connect.spec.dart' as specs;
import 'remote_backup_models.dart';
import 'rpc_connection.dart';

export 'generated/space/v1/remote_backup.pb.dart';

abstract interface class RemoteBackupApi {
  Future<BackupHead> put(PutBackupRequest request);
  Future<GetBackupResponse> get(GetBackupRequest request);
  Future<ReadBackupHeadResponse> read(ReadBackupHeadRequest request);
  Future<void> close();
}

class RpcRemoteBackup implements RemoteBackupApi {
  RpcRemoteBackup(RemoteBackupEndpoint endpoint)
    : connection = RpcConnection.connect(
        Uri.parse(endpoint.origin),
        endpoint.fingerprint,
      ),
      ownsConnection = true;
  RpcRemoteBackup.session(SpaceSession session)
    : connection = session.channel,
      ownsConnection = false;
  final RpcConnection connection;
  final bool ownsConnection;
  static const options = RpcOptions(timeout: Duration(seconds: 30));
  @override
  Future<BackupHead> put(PutBackupRequest request) async =>
      (await connection.unary(
        specs.RemoteBackupService.putBackup,
        request,
        options: options,
      )).head;
  @override
  Future<GetBackupResponse> get(GetBackupRequest request) => connection.unary(
    specs.RemoteBackupService.getBackup,
    request,
    options: options,
  );
  @override
  Future<ReadBackupHeadResponse> read(ReadBackupHeadRequest request) =>
      connection.unary(
        specs.RemoteBackupService.readBackupHead,
        request,
        options: options,
      );
  @override
  Future<void> close() async {
    if (ownsConnection) await connection.shutdown();
  }
}

Future<void> provisionRemoteBackup(
  SpaceSession session,
  CreateBackupSlotRequest request,
) => session.createRemoteBackupSlot(request);
