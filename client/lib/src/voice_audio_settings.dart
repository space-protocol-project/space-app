import 'voice_shortcut.dart';

enum VoiceInputProfile { speech, studio, custom }

class VoiceAudioSettings {
  const VoiceAudioSettings({
    this.inputGain = 1,
    this.outputGain = 1,
    this.noiseSuppression = true,
    this.echoCancellation = true,
    this.autoGainControl = true,
    this.pushToTalk = false,
    this.automaticSensitivity = true,
    this.thresholdDb = -45,
    this.shortcut = const VoiceShortcut(),
  });
  final double inputGain, outputGain;
  final bool noiseSuppression, echoCancellation, autoGainControl;
  final bool pushToTalk, automaticSensitivity;
  final double thresholdDb;
  final VoiceShortcut shortcut;

  VoiceInputProfile get profile {
    if (noiseSuppression && echoCancellation && autoGainControl) {
      return VoiceInputProfile.speech;
    }
    if (!noiseSuppression && !echoCancellation && !autoGainControl) {
      return VoiceInputProfile.studio;
    }
    return VoiceInputProfile.custom;
  }

  bool sameProcessing(VoiceAudioSettings other) =>
      noiseSuppression == other.noiseSuppression &&
      echoCancellation == other.echoCancellation &&
      autoGainControl == other.autoGainControl;

  VoiceAudioSettings copyWith({
    double? inputGain,
    double? outputGain,
    bool? noiseSuppression,
    bool? echoCancellation,
    bool? autoGainControl,
    bool? pushToTalk,
    bool? automaticSensitivity,
    double? thresholdDb,
    VoiceShortcut? shortcut,
  }) => VoiceAudioSettings(
    inputGain: _gain(inputGain ?? this.inputGain),
    outputGain: _gain(outputGain ?? this.outputGain),
    noiseSuppression: noiseSuppression ?? this.noiseSuppression,
    echoCancellation: echoCancellation ?? this.echoCancellation,
    autoGainControl: autoGainControl ?? this.autoGainControl,
    pushToTalk: pushToTalk ?? this.pushToTalk,
    automaticSensitivity: automaticSensitivity ?? this.automaticSensitivity,
    thresholdDb: _threshold(thresholdDb ?? this.thresholdDb),
    shortcut: shortcut ?? this.shortcut,
  );

  VoiceAudioSettings withProfile(VoiceInputProfile profile) {
    if (profile == VoiceInputProfile.custom) return this;
    final speech = profile == VoiceInputProfile.speech;
    return copyWith(
      noiseSuppression: speech,
      echoCancellation: speech,
      autoGainControl: speech,
    );
  }

  static double _gain(Object? value) =>
      value is num && value.isFinite ? value.toDouble().clamp(0, 2) : 1;

  static double _threshold(Object? value) =>
      value is num && value.isFinite ? value.toDouble().clamp(-60, -10) : -45;

  factory VoiceAudioSettings.fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return const VoiceAudioSettings();
    return VoiceAudioSettings(
      inputGain: _gain(value['inputGain']),
      outputGain: _gain(value['outputGain']),
      noiseSuppression: value['noiseSuppression'] != false,
      echoCancellation: value['echoCancellation'] != false,
      autoGainControl: value['autoGainControl'] != false,
      pushToTalk: value['pushToTalk'] == true,
      automaticSensitivity: value['automaticSensitivity'] != false,
      thresholdDb: _threshold(value['thresholdDb']),
      shortcut: VoiceShortcut.fromJson(value['shortcut']),
    );
  }

  Map<String, Object> toJson() => {
    'inputGain': inputGain,
    'outputGain': outputGain,
    'noiseSuppression': noiseSuppression,
    'echoCancellation': echoCancellation,
    'autoGainControl': autoGainControl,
    'pushToTalk': pushToTalk,
    'automaticSensitivity': automaticSensitivity,
    'thresholdDb': thresholdDb,
    'shortcut': shortcut.toJson(),
  };
}
