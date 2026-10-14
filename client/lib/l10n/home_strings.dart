import 'package:flutter/widgets.dart';

import '../src/home_controller.dart';
import 'strings.dart';

extension HomePhaseStrings on HomePhase {
  String label(BuildContext context) => switch (this) {
    HomePhase.idle => '',
    HomePhase.detectingIP => context.strings.homeDetectingIP,
    HomePhase.downloading => context.strings.homeDownloading,
    HomePhase.installing => context.strings.homeInstalling,
    HomePhase.transferring => context.strings.homeTransferring,
    HomePhase.updating => context.strings.homeUpdating,
    HomePhase.starting => context.strings.homeStarting,
    HomePhase.running => context.strings.homeRunning,
    HomePhase.stopping => context.strings.homeStopping,
    HomePhase.stopped => context.strings.homeStopped,
  };
}
