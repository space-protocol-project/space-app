import 'package:flutter/widgets.dart';

import '../src/local_failure.dart';
import '../src/chat_controller.dart';
import 'strings.dart';

String localFailureText(
  BuildContext context,
  LocalFailureCode code,
) => switch (code) {
  LocalFailureCode.cameraDenied => context.strings.failureCameraDenied,
  LocalFailureCode.cameraUnavailable =>
    context.strings.failureCameraUnavailable,
  LocalFailureCode.cameraFrame => context.strings.failureCameraFrame,
  LocalFailureCode.cameraStopped => context.strings.failureCameraStopped,
  LocalFailureCode.positionsLoad => context.strings.failurePositionsLoad,
  LocalFailureCode.positionsSave => context.strings.failurePositionsSave,
  LocalFailureCode.channelChanged => context.strings.failureChannelChanged,
  LocalFailureCode.channelUnavailable =>
    context.strings.failureChannelUnavailable,
  LocalFailureCode.eventsUnsupported =>
    context.strings.failureEventsUnsupported,
  LocalFailureCode.cursorRejected => context.strings.failureCursorRejected,
  LocalFailureCode.deviceRevoked => context.strings.failureDeviceRevoked,
  LocalFailureCode.qrTooLarge => context.strings.failureQrTooLarge,
  LocalFailureCode.qrFileTooLarge => context.strings.failureQrFileTooLarge,
  LocalFailureCode.qrImageInvalid => context.strings.failureQrImageInvalid,
  LocalFailureCode.qrUnreadable => context.strings.failureQrUnreadable,
  LocalFailureCode.keyStorageMismatch =>
    context.strings.failureKeyStorageMismatch,
  LocalFailureCode.keyStorageSave => context.strings.failureKeyStorageSave,
  LocalFailureCode.keyJournalInvalid =>
    context.strings.failureKeyJournalInvalid,
  LocalFailureCode.permissionDenied => context.strings.failurePermissionDenied,
  LocalFailureCode.unauthenticated => context.strings.failureUnauthenticated,
  LocalFailureCode.serverLimit => context.strings.failureServerLimit,
  LocalFailureCode.connectionFailed => context.strings.failureConnectionFailed,
  LocalFailureCode.tlsRejected => context.strings.failureTlsRejected,
  LocalFailureCode.protocolInvalid => context.strings.failureProtocolInvalid,
  LocalFailureCode.connectRequired => context.strings.failureConnectRequired,
  LocalFailureCode.identityInvalid => context.strings.failureIdentityInvalid,
  LocalFailureCode.addressInvalid => context.strings.failureAddressInvalid,
  LocalFailureCode.operationFailed => context.strings.failureOperationFailed,
  LocalFailureCode.cardCorrupt => context.strings.failureCardCorrupt,
  LocalFailureCode.passwordInvalid => context.strings.failurePasswordInvalid,
  LocalFailureCode.cardTooLarge => context.strings.failureCardTooLarge,
  LocalFailureCode.cardUnsupported => context.strings.failureCardUnsupported,
  LocalFailureCode.cardAuthentication =>
    context.strings.failureCardAuthentication,
  LocalFailureCode.releaseInvalid => context.strings.failureReleaseInvalid,
  LocalFailureCode.platformUnsupported =>
    context.strings.failurePlatformUnsupported,
  LocalFailureCode.downloadAddress => context.strings.failureDownloadAddress,
  LocalFailureCode.downloadFailed => context.strings.failureDownloadFailed,
  LocalFailureCode.redirectLimit => context.strings.failureRedirectLimit,
  LocalFailureCode.releaseSize => context.strings.failureReleaseSize,
  LocalFailureCode.hashMismatch => context.strings.failureHashMismatch,
  LocalFailureCode.archiveInvalid => context.strings.failureArchiveInvalid,
  LocalFailureCode.executePermission =>
    context.strings.failureExecutePermission,
  LocalFailureCode.homeStartFailed => context.strings.failureHomeStartFailed,
  LocalFailureCode.homeStopFailed => context.strings.failureHomeStopFailed,
  LocalFailureCode.homeUpdatePending =>
    context.strings.failureHomeUpdatePending,
  LocalFailureCode.homeJournalInvalid =>
    context.strings.failureHomeJournalInvalid,
  LocalFailureCode.homeBackupMissing =>
    context.strings.failureHomeBackupMissing,
  LocalFailureCode.homeBackupInvalid =>
    context.strings.failureHomeBackupInvalid,
  LocalFailureCode.homeRecoveryInvalid =>
    context.strings.failureHomeRecoveryInvalid,
  LocalFailureCode.homeUpdateFailed => context.strings.failureHomeUpdateFailed,
  LocalFailureCode.homeSpaceLow => context.strings.failureHomeSpaceLow,
  LocalFailureCode.homeSpaceUnknown => context.strings.failureHomeSpaceUnknown,
};

String chatFailureText(BuildContext context, ChatController controller) {
  final code = controller.failureCode;
  if (code == null) return controller.error;
  final text = localFailureText(context, code);
  return controller.failureRetry
      ? '$text ${context.strings.failureRetrySameRequest}'
      : text;
}
