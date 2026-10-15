import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';

enum LocalFailureCode {
  cameraDenied,
  cameraUnavailable,
  cameraFrame,
  cameraStopped,

  positionsLoad,
  positionsSave,
  channelChanged,
  channelUnavailable,
  eventsUnsupported,
  cursorRejected,
  deviceRevoked,
  qrTooLarge,
  qrFileTooLarge,
  qrImageInvalid,
  qrUnreadable,
  keyStorageMismatch,
  keyStorageSave,
  keyJournalInvalid,

  permissionDenied,
  unauthenticated,
  serverLimit,
  connectionFailed,
  tlsRejected,
  protocolInvalid,
  connectRequired,
  identityInvalid,
  addressInvalid,
  operationFailed,
  nicknameTaken,
  nicknameInvalid,
  conflict,
  cardCorrupt,
  passwordInvalid,
  cardTooLarge,
  cardUnsupported,
  cardAuthentication,
  releaseInvalid,
  platformUnsupported,
  downloadAddress,
  downloadFailed,
  redirectLimit,
  releaseSize,
  hashMismatch,
  archiveInvalid,
  executePermission,
  homeStartFailed,
  homeStopFailed,
  homeUpdatePending,
  homeJournalInvalid,
  homeBackupMissing,
  homeBackupInvalid,
  homeRecoveryInvalid,
  homeUpdateFailed,
  homeSpaceLow,
  homeSpaceUnknown,
}

/// Стабильный код передаётся из вычислителя в интерфейс, включая isolate.
class LocalFailure extends FormatException {
  const LocalFailure(this.code, String message) : super(message);
  final LocalFailureCode code;
}

LocalFailureCode classifyFailure(Object problem) {
  if (problem is LocalFailure) return problem.code;
  if (problem is HandshakeException) return LocalFailureCode.tlsRejected;
  if (problem is SocketException || problem is TimeoutException) {
    return LocalFailureCode.connectionFailed;
  }
  if (problem is GrpcError) {
    return switch (problem.code) {
      StatusCode.aborted => LocalFailureCode.conflict,
      StatusCode.permissionDenied => LocalFailureCode.permissionDenied,
      StatusCode.unauthenticated => LocalFailureCode.unauthenticated,
      StatusCode.resourceExhausted => LocalFailureCode.serverLimit,
      StatusCode.unavailable ||
      StatusCode.deadlineExceeded => LocalFailureCode.connectionFailed,
      StatusCode.dataLoss ||
      StatusCode.unimplemented => LocalFailureCode.protocolInvalid,
      _ => LocalFailureCode.operationFailed,
    };
  }
  if (problem is FormatException) return LocalFailureCode.protocolInvalid;
  return LocalFailureCode.operationFailed;
}
