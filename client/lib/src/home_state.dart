part of 'home_controller.dart';

final class HomeState {
  const HomeState({
    this.busy = false,
    this.running = false,
    this.pendingUpdate = false,
    this.recoveryBlocked = false,
    this.updateAvailable = false,
    this.ip = '',
    this.error = '',
    this.installedVersion = '',
    this.availableVersion = '',
    this.availableReleaseNotes = '',
    this.recoverySummary = '',
    this.phase = HomePhase.idle,
    this.progress = 0,
    this.operationProgress = .01,
    this.elapsed = Duration.zero,
    this.downloadSecondsRemaining,
    this.server,
    this.failureCode,
    this.spaceReport,
  });
  factory HomeState.fromController(HomeController controller) => HomeState(
    busy: controller.busy,
    running: controller.running,
    pendingUpdate: controller.pendingUpdate,
    recoveryBlocked: controller.recoveryBlocked,
    updateAvailable: controller.updateAvailable,
    ip: controller.ip,
    error: controller.error,
    installedVersion: controller.installedVersion,
    availableVersion: controller.availableVersion,
    availableReleaseNotes: controller.availableReleaseNotes,
    recoverySummary: controller.recoverySummary,
    phase: controller.phase,
    progress: controller.progress,
    operationProgress: controller.operationProgress,
    elapsed: controller.elapsed,
    downloadSecondsRemaining: controller.downloadSecondsRemaining,
    server: controller.server,
    failureCode: controller.failureCode,
    spaceReport: controller.spaceReport,
  );
  final bool busy, running, pendingUpdate, recoveryBlocked, updateAvailable;
  final String ip,
      error,
      installedVersion,
      availableVersion,
      availableReleaseNotes,
      recoverySummary;
  final HomePhase phase;
  final double progress, operationProgress;
  final Duration elapsed;
  final int? downloadSecondsRemaining;
  final HomeServerState? server;
  final LocalFailureCode? failureCode;
  final HomeSpaceReport? spaceReport;
}
