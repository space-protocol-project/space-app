import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_platform.dart';
import 'package:space_client/src/voice_transmission.dart';

void main() {
  test('DeepFilter is the default; all explicit modes remain available', () {
    expect(voiceDefaultAudio.noiseMode, VoiceNoiseSuppression.deepFilter);
    for (final mode in VoiceNoiseSuppression.values) {
      final saved = VoiceAudioSettings(noiseMode: mode);
      final restored = VoiceAudioSettings.fromJson(saved.toJson());
      expect(restored.noiseMode, mode);
    }
  });

  testWidgets(
    'Voice activity continues in background and stops when capture ends',
    (tester) async {
      for (final background in [false, true]) {
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        final values = <bool>[];
        final gate = VoiceTransmission(
          level: () async => .5,
          transmit: values.add,
          allowTouch: background,
        );
        gate.start(const VoiceAudioSettings());
        gate.didChangeAppLifecycleState(AppLifecycleState.paused);
        await tester.pump(const Duration(milliseconds: 50));
        expect(values.last, true);
        gate.stop();
        await tester.pump(const Duration(milliseconds: 50));
        expect(values.last, false);
      }
    },
  );

  testWidgets('Touch PTT releases on background and needs a fresh press', (
    tester,
  ) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final values = <bool>[];
    final gate = VoiceTransmission(
      level: () async => 1,
      transmit: values.add,
      allowTouch: true,
    );
    gate.start(const VoiceAudioSettings(pushToTalk: true));
    voiceTouchTransmission.value = true;
    expect(values.last, true);
    gate.didChangeAppLifecycleState(AppLifecycleState.paused);
    expect(values.last, false);
    expect(voiceTouchTransmission.value, false);
    gate.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 100));
    expect(values.last, false);
    voiceTouchTransmission.value = true;
    expect(values.last, true);
    gate.stop();
    expect(values.last, false);
    expect(voiceTouchTransmission.value, false);
  });
}
