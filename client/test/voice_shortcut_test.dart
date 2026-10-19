import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_device_preferences.dart';
import 'package:space_client/src/voice_devices.dart';
import 'package:space_client/src/voice_shortcut.dart';
import 'package:space_client/src/voice_transmission.dart';
import 'package:space_client/ui/voice_shortcut_settings.dart';

import 'voice_devices_test.dart' show DevicesBackend;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => voiceShortcutRecording.value = false);

  test(
    'Старые и повреждённые настройки сохраняют F8; сочетание переносится',
    () async {
      expect(
        VoiceAudioSettings.fromJson({}).shortcut.key,
        LogicalKeyboardKey.f8,
      );
      expect(VoiceShortcut.fromJson({'key': -1}).key, LogicalKeyboardKey.f8);
      expect(VoiceShortcut.usable(LogicalKeyboardKey.controlLeft), false);
      const russian = VoiceShortcut(
        key: LogicalKeyboardKey(0x444),
        control: true,
      );
      expect(VoiceShortcut.fromJson(russian.toJson()).key, russian.key);
      expect(
        const VoiceShortcut(key: LogicalKeyboardKey.space, control: true).label,
        'Ctrl + Space',
      );
      const shortcut = VoiceShortcut(
        key: LogicalKeyboardKey.space,
        control: true,
        shift: true,
      );
      await SavedVoiceDevicePreferences().save(
        const VoiceDeviceChoice(
          audio: VoiceAudioSettings(pushToTalk: true, shortcut: shortcut),
        ),
      );
      final saved = (await SavedVoiceDevicePreferences().load()).audio;
      expect(saved.shortcut.toJson(), shortcut.toJson());
      expect(saved.copyWith(inputGain: 2).shortcut.toJson(), shortcut.toJson());
    },
  );

  testWidgets(
    'Сочетание закрывается при отпускании модификатора и потере фокуса',
    (tester) async {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final values = <bool>[];
      final gate = VoiceTransmission(
        level: () async => 1,
        transmit: values.add,
      );
      gate.start(
        const VoiceAudioSettings(
          pushToTalk: true,
          shortcut: VoiceShortcut(key: LogicalKeyboardKey.space, control: true),
        ),
      );
      addTearDown(gate.stop);
      final plainSpace = HardwareKeyboard.instance.handleKeyEvent(
        KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.space,
          logicalKey: LogicalKeyboardKey.space,
          timeStamp: Duration.zero,
        ),
      );
      expect(plainSpace, false);
      HardwareKeyboard.instance.handleKeyEvent(
        KeyUpEvent(
          physicalKey: PhysicalKeyboardKey.space,
          logicalKey: LogicalKeyboardKey.space,
          timeStamp: Duration.zero,
        ),
      );
      await tester.sendKeyDownEvent(LogicalKeyboardKey.f8);
      expect(values.last, false);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.f8);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      expect(values.last, true);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      expect(values.last, false);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      expect(values.last, false);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      expect(values.last, true);
      gate.didChangeAppLifecycleState(AppLifecycleState.inactive);
      expect(values.last, false);
      gate.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(values.last, false);
      voiceShortcutRecording.value = true;
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      expect(values.last, false);
      voiceShortcutRecording.value = false;
      expect(values.last, false);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      expect(values.last, true);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      gate.stop();
    },
  );

  testWidgets('Запись сочетания в настройках не открывает передачу', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final devices = VoiceDevices(backend: DevicesBackend());
    addTearDown(devices.close);
    final values = <bool>[];
    final gate = VoiceTransmission(level: () async => 1, transmit: values.add);
    gate.start(const VoiceAudioSettings(pushToTalk: true));
    addTearDown(gate.stop);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: VoiceShortcutSettings(devices: devices)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    expect(voiceShortcutRecording.value, true);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.f9);
    await tester.pump();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.f9);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    expect(values.last, false);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
    await tester.pump();
    expect(find.text('Ctrl + F9'), findsOneWidget);
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();
    expect(devices.state.audio.shortcut.key, LogicalKeyboardKey.f9);
    expect(devices.state.audio.shortcut.control, true);
    expect(voiceShortcutRecording.value, false);
    expect(values.last, false);
    expect(tester.takeException(), isNull);
    gate.stop();
  });
}
