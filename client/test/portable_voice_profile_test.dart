import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/portable_voice_profile.dart';
import 'package:space_client/src/voice_audio_settings.dart';

void main() {
  test('Профиль переносит обработку, сохраняя локальные параметры', () {
    const incoming = VoiceAudioSettings(
      noiseMode: VoiceNoiseSuppression.webrtc,
      echoCancellation: false,
      autoGainControl: false,
      highPassFilter: false,
      customProfile: true,
    );
    const local = VoiceAudioSettings(
      inputGain: 1.5,
      outputGain: 0.5,
      pushToTalk: true,
      automaticSensitivity: false,
      thresholdDb: -30,
      releaseDelayMs: 600,
    );
    final profile = PortableVoiceProfile.fromAudio(incoming);
    final parsed = PortableVoiceProfile.parse(profile.data);
    expect(parsed, profile);
    expect(parsed.hashCode, profile.hashCode);
    final restored = parsed.apply(local);
    expect(restored.noiseMode, VoiceNoiseSuppression.webrtc);
    expect(restored.echoCancellation, isFalse);
    expect(restored.autoGainControl, isFalse);
    expect(restored.highPassFilter, isFalse);
    expect(restored.customProfile, isTrue);
    expect(restored.inputGain, local.inputGain);
    expect(restored.outputGain, local.outputGain);
    expect(restored.pushToTalk, local.pushToTalk);
    expect(restored.automaticSensitivity, local.automaticSensitivity);
    expect(restored.thresholdDb, local.thresholdDb);
    expect(restored.releaseDelayMs, local.releaseDelayMs);
    expect(restored.shortcut, same(local.shortcut));
  });

  test('Неизвестные поля и недопустимые значения отклоняются', () {
    final profile = PortableVoiceProfile.fromAudio(const VoiceAudioSettings());
    for (final value in [
      {...profile.data, 'noiseMode': 'unknown'},
      {...profile.data, 'echoCancellation': 1},
      {...profile.data, 'device': 'microphone'},
      Map<String, Object>.from(profile.data)..remove('customProfile'),
    ]) {
      expect(() => PortableVoiceProfile.parse(value), throwsFormatException);
    }
  });
}
