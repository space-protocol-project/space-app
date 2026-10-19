import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_transmission.dart';

void main() {
  test('Sensitivity preferences sanitize corrupt values and round trip', () {
    final settings = VoiceAudioSettings.fromJson({
      'pushToTalk': true,
      'automaticSensitivity': false,
      'thresholdDb': double.nan,
    });
    expect(settings.thresholdDb, -45);
    final restored = VoiceAudioSettings.fromJson(settings.toJson());
    expect(restored.pushToTalk, isTrue);
    expect(restored.automaticSensitivity, isFalse);
    expect(restored.copyWith(thresholdDb: -100).thresholdDb, -60);
  });

  testWidgets('PTT requires a fresh key press and releases on focus loss', (
    tester,
  ) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final values = <bool>[];
    final gate = VoiceTransmission(level: () async => 1, transmit: values.add);
    gate.start(const VoiceAudioSettings(pushToTalk: true));
    expect(values.last, isFalse);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.f8);
    expect(values.last, isTrue);
    gate.didChangeAppLifecycleState(AppLifecycleState.inactive);
    expect(values.last, isFalse);
    gate.didChangeAppLifecycleState(AppLifecycleState.resumed);
    expect(values.last, isFalse);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.f8);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.f8);
    expect(values.last, isTrue);
    gate.stop();
    expect(values.last, isFalse);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.f8);
  });

  testWidgets(
    'Manual threshold suppresses quiet input and closes after speech tail',
    (tester) async {
      var level = .001;
      final values = <bool>[];
      final gate = VoiceTransmission(
        level: () async => level,
        transmit: values.add,
      );
      gate.start(
        const VoiceAudioSettings(automaticSensitivity: false, thresholdDb: -40),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(values.last, isFalse);
      level = .1;
      await tester.pump(const Duration(milliseconds: 50));
      expect(values.last, isTrue);
      level = .001;
      for (var i = 0; i < 7; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(values.last, isFalse);
      gate.stop();
    },
  );

  testWidgets('Late level cannot reopen stopped or PTT microphone', (
    tester,
  ) async {
    final pending = Completer<double>();
    final values = <bool>[];
    final gate = VoiceTransmission(
      level: () => pending.future,
      transmit: values.add,
    );
    gate.start(const VoiceAudioSettings());
    await tester.pump(const Duration(milliseconds: 50));
    gate.configure(const VoiceAudioSettings(pushToTalk: true));
    pending.complete(1);
    await tester.pump();
    expect(values.last, isFalse);
    gate.stop();
    expect(values.last, isFalse);
  });

  testWidgets(
    'Automatic sensitivity rejects noise, passes speech and fails closed',
    (tester) async {
      var level = .0001;
      var failing = false;
      final values = <bool>[];
      final gate = VoiceTransmission(
        level: () async {
          if (failing) throw StateError('meter unavailable');
          return level;
        },
        transmit: values.add,
      );
      gate.start(const VoiceAudioSettings());
      await tester.pump(const Duration(milliseconds: 50));
      expect(values.last, isFalse);
      level = .1;
      await tester.pump(const Duration(milliseconds: 50));
      expect(values.last, isTrue);
      failing = true;
      await tester.pump(const Duration(milliseconds: 50));
      expect(values.last, isFalse);
      failing = false;
      level = .0001;
      await tester.pump(const Duration(milliseconds: 50));
      expect(values.last, isFalse);
      gate.stop();
    },
  );

  testWidgets('Capture finishing after stop stays closed', (tester) async {
    final pending = Completer<double>();
    final values = <bool>[];
    final gate = VoiceTransmission(
      level: () => pending.future,
      transmit: values.add,
    );
    gate.start(const VoiceAudioSettings());
    await tester.pump(const Duration(milliseconds: 50));
    gate.stop();
    final count = values.length;
    pending.complete(1);
    await tester.pump();
    expect(values.length, count);
    expect(values.last, isFalse);
  });

  testWidgets('Смена порога отменяет незавершённое измерение', (tester) async {
    final pending = Completer<double>();
    final values = <bool>[];
    final gate = VoiceTransmission(
      level: () => pending.future,
      transmit: values.add,
    );
    gate.start(const VoiceAudioSettings());
    await tester.pump(const Duration(milliseconds: 50));
    gate.configure(
      const VoiceAudioSettings(automaticSensitivity: false, thresholdDb: -30),
    );
    final count = values.length;
    pending.complete(1);
    await tester.pump();
    expect(values.length, count);
    expect(values.last, isFalse);
    gate.stop();
  });
}
