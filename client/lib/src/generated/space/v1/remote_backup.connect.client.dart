//
//  Generated code. Do not modify.
//  source: space/v1/remote_backup.proto
//

import "package:connectrpc/connect.dart" as connect;
import "remote_backup.pb.dart" as spacev1remote_backup;
import "remote_backup.connect.spec.dart" as specs;

/// core.directory.backup.v1: зашифрованные копии на сервере пространства.
extension type RemoteBackupServiceClient (connect.Transport _transport) {
  Future<spacev1remote_backup.CreateBackupSlotResponse> createBackupSlot(
    spacev1remote_backup.CreateBackupSlotRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RemoteBackupService.createBackupSlot,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1remote_backup.RevokeBackupSlotResponse> revokeBackupSlot(
    spacev1remote_backup.RevokeBackupSlotRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RemoteBackupService.revokeBackupSlot,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1remote_backup.PutBackupResponse> putBackup(
    spacev1remote_backup.PutBackupRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RemoteBackupService.putBackup,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1remote_backup.GetBackupResponse> getBackup(
    spacev1remote_backup.GetBackupRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RemoteBackupService.getBackup,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1remote_backup.ReadBackupHeadResponse> readBackupHead(
    spacev1remote_backup.ReadBackupHeadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RemoteBackupService.readBackupHead,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
