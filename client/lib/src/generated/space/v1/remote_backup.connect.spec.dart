//
//  Generated code. Do not modify.
//  source: space/v1/remote_backup.proto
//

import "package:connectrpc/connect.dart" as connect;
import "remote_backup.pb.dart" as spacev1remote_backup;

/// core.directory.backup.v1: зашифрованные копии на сервере пространства.
abstract final class RemoteBackupService {
  /// Fully-qualified name of the RemoteBackupService service.
  static const name = 'space.v1.RemoteBackupService';

  static const createBackupSlot = connect.Spec(
    '/$name/CreateBackupSlot',
    connect.StreamType.unary,
    spacev1remote_backup.CreateBackupSlotRequest.new,
    spacev1remote_backup.CreateBackupSlotResponse.new,
  );

  static const revokeBackupSlot = connect.Spec(
    '/$name/RevokeBackupSlot',
    connect.StreamType.unary,
    spacev1remote_backup.RevokeBackupSlotRequest.new,
    spacev1remote_backup.RevokeBackupSlotResponse.new,
  );

  static const putBackup = connect.Spec(
    '/$name/PutBackup',
    connect.StreamType.unary,
    spacev1remote_backup.PutBackupRequest.new,
    spacev1remote_backup.PutBackupResponse.new,
  );

  static const getBackup = connect.Spec(
    '/$name/GetBackup',
    connect.StreamType.unary,
    spacev1remote_backup.GetBackupRequest.new,
    spacev1remote_backup.GetBackupResponse.new,
  );

  static const readBackupHead = connect.Spec(
    '/$name/ReadBackupHead',
    connect.StreamType.unary,
    spacev1remote_backup.ReadBackupHeadRequest.new,
    spacev1remote_backup.ReadBackupHeadResponse.new,
  );
}
