import 'directory_validation.dart';
import 'voice_audio_settings.dart';

/// Пользовательский профиль обработки без локальных аудиоустройств.
class PortableVoiceProfile {
  const PortableVoiceProfile({
    required this.noiseMode,
    required this.echoCancellation,
    required this.autoGainControl,
    required this.highPassFilter,
    required this.customProfile,
  });

  final VoiceNoiseSuppression noiseMode;
  final bool echoCancellation, autoGainControl, highPassFilter, customProfile;

  factory PortableVoiceProfile.fromAudio(VoiceAudioSettings audio) =>
      PortableVoiceProfile(
        noiseMode: audio.noiseMode,
        echoCancellation: audio.echoCancellation,
        autoGainControl: audio.autoGainControl,
        highPassFilter: audio.highPassFilter,
        customProfile: audio.customProfile,
      );

  factory PortableVoiceProfile.parse(Object? value) {
    final data = directoryMap(
      value,
      'autoGainControl,customProfile,echoCancellation,highPassFilter,noiseMode',
    );
    final noise = VoiceNoiseSuppression.values
        .where((mode) => mode.name == data['noiseMode'])
        .firstOrNull;
    directoryRequire(noise != null);
    for (final key in [
      'autoGainControl',
      'customProfile',
      'echoCancellation',
      'highPassFilter',
    ]) {
      directoryRequire(data[key] is bool);
    }
    return PortableVoiceProfile(
      noiseMode: noise!,
      echoCancellation: data['echoCancellation'] as bool,
      autoGainControl: data['autoGainControl'] as bool,
      highPassFilter: data['highPassFilter'] as bool,
      customProfile: data['customProfile'] as bool,
    );
  }

  Map<String, Object> get data => {
    'noiseMode': noiseMode.name,
    'echoCancellation': echoCancellation,
    'autoGainControl': autoGainControl,
    'highPassFilter': highPassFilter,
    'customProfile': customProfile,
  };

  VoiceAudioSettings apply(VoiceAudioSettings local) => local.copyWith(
    noiseMode: noiseMode,
    echoCancellation: echoCancellation,
    autoGainControl: autoGainControl,
    highPassFilter: highPassFilter,
    customProfile: customProfile,
  );

  @override
  bool operator ==(Object other) =>
      other is PortableVoiceProfile &&
      noiseMode == other.noiseMode &&
      echoCancellation == other.echoCancellation &&
      autoGainControl == other.autoGainControl &&
      highPassFilter == other.highPassFilter &&
      customProfile == other.customProfile;

  @override
  int get hashCode => Object.hash(
    noiseMode,
    echoCancellation,
    autoGainControl,
    highPassFilter,
    customProfile,
  );
}
