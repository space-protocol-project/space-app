//
//  Generated code. Do not modify.
//  source: space/v1/remote_backup.proto
//

import "package:connectrpc/connect.dart" as connect;
import "remote_backup.pb.dart" as spacev1remote_backup;
import "remote_backup.connect.spec.dart" as specs;

/// core.directory.backup.v1: независимые хранилище и свидетель версии.
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

  Future<spacev1remote_backup.AdvanceBackupWitnessResponse> advanceBackupWitness(
    spacev1remote_backup.AdvanceBackupWitnessRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RemoteBackupService.advanceBackupWitness,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<spacev1remote_backup.ReadBackupWitnessResponse> readBackupWitness(
    spacev1remote_backup.ReadBackupWitnessRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RemoteBackupService.readBackupWitness,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
