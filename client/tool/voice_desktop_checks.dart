part of 'voice_desktop_probe.dart';

void probeKey(
  LogicalKeyboardKey logical,
  PhysicalKeyboardKey physical,
  bool down,
) {
  final KeyEvent event = down
      ? KeyDownEvent(
          physicalKey: physical,
          logicalKey: logical,
          timeStamp: Duration.zero,
        )
      : KeyUpEvent(
          physicalKey: physical,
          logicalKey: logical,
          timeStamp: Duration.zero,
        );
  HardwareKeyboard.instance.handleKeyEvent(event);
}

Future<void> expectTransmission(ProbeMedia media, bool value) async {
  await Future<void>.delayed(const Duration(milliseconds: 100));
  if (media.transmitting != value) {
    throw StateError(
      'Неверное состояние нативной передачи: ожидается $value',
    );
  }
}

Future<void> checkPushToTalk(
  VoiceController controller,
  ProbeMedia media,
) async {
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.resumed,
  );
  await controller.devices.updateAudio(probeAudio.copyWith(pushToTalk: true));
  if (!controller.devices.state.audio.pushToTalk || controller.state.muted) {
    throw StateError(
      'Режим рации не применён: ${controller.devices.state.error}; ${controller.state.error}',
    );
  }
  await expectTransmission(media, false);
  probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, true);
  await expectTransmission(media, true);
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.inactive,
  );
  await expectTransmission(media, false);
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.resumed,
  );
  await expectTransmission(media, false);
  probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, false);
  probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, true);
  await expectTransmission(media, true);
  voiceShortcutRecording.value = true;
  await expectTransmission(media, false);
  voiceShortcutRecording.value = false;
  await expectTransmission(media, false);
  probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, false);
  await controller.devices.updateAudio(
    probeAudio.copyWith(
      pushToTalk: true,
      shortcut: VoiceShortcut(key: LogicalKeyboardKey.f9, control: true),
    ),
  );
  probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, true);
  await expectTransmission(media, false);
  probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, false);
  probeKey(
    LogicalKeyboardKey.controlLeft,
    PhysicalKeyboardKey.controlLeft,
    true,
  );
  probeKey(LogicalKeyboardKey.f9, PhysicalKeyboardKey.f9, true);
  await expectTransmission(media, true);
  probeKey(
    LogicalKeyboardKey.controlLeft,
    PhysicalKeyboardKey.controlLeft,
    false,
  );
  await expectTransmission(media, false);
  probeKey(LogicalKeyboardKey.f9, PhysicalKeyboardKey.f9, false);
  await controller.devices.updateAudio(probeAudio);
}

Future<void> checkReconnect(
  Directory work,
  String role,
  VoiceController controller,
  List<ProbeMedia> media,
) async {
  var recovering = false;
  final subscription = controller.stream.listen((state) {
    if (state.phase == VoicePhase.reconnecting && !recovering) {
      recovering = true;
      unawaited(flag(work, '$role-reconnecting', 'ready'));
    }
  });
  try {
    await controller.devices.updateAudio(probeAudio.copyWith(pushToTalk: true));
    WidgetsBinding.instance.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, true);
    await expectTransmission(media.last, true);
    await flag(work, '$role-recovery-ready', 'ready');
    await waitUntil(
      () => recovering && controller.state.phase == VoicePhase.connected,
    );
    if (!controller.state.muted ||
        media.length < 2 ||
        media.last.transmitting) {
      throw StateError(
        'Переподключение не остановило микрофон',
      );
    }
    await flag(work, '$role-recovered', 'ready');
    if (Platform.isAndroid) await androidProbeBarrier('foreground-restored');
    await barrier(work, role == 'A' ? 'B-recovered' : 'A-recovered');
    if (role == 'B') await barrier(work, 'A-resumed-microphone');
    await controller.toggleMicrophone();
    if (controller.state.muted) {
      throw StateError(
        'Микрофон не включился вручную после восстановления',
      );
    }
    await expectTransmission(media.last, false);
    probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, false);
    WidgetsBinding.instance.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, true);
    await expectTransmission(media.last, true);
    probeKey(LogicalKeyboardKey.f8, PhysicalKeyboardKey.f8, false);
    await expectTransmission(media.last, false);
    await controller.devices.updateAudio(probeAudio);
    await flag(work, '$role-resumed-microphone', 'ready');
    await barrier(
      work,
      role == 'A' ? 'B-resumed-microphone' : 'A-resumed-microphone',
    );
    final counts = await waitForAudio(media.last);
    await sampleAudio(work, role, 'recovered', media.last);
    await flag(work, '$role-recovered-audio', jsonEncode(counts));
    await barrier(
      work,
      role == 'A' ? 'B-recovered-audio' : 'A-recovered-audio',
    );
  } finally {
    await subscription.cancel();
  }
}
