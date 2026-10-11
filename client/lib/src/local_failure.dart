enum LocalFailureCode {
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
}

/// Стабильный код передаётся из вычислителя в интерфейс, включая isolate.
class LocalFailure extends FormatException {
  const LocalFailure(this.code, String message) : super(message);
  final LocalFailureCode code;
}
