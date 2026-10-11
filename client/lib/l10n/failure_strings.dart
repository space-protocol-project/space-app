import 'package:flutter/widgets.dart';

import '../src/local_failure.dart';
import 'strings.dart';

String localFailureText(
  BuildContext context,
  LocalFailureCode code,
) => switch (code) {
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
};
