import 'voice_shortcut.dart';

enum VoiceInputProfile { speech, studio, custom }

enum VoiceNoiseSuppression { deepFilter, webrtc, disabled }

class VoiceAudioSettings {
  const VoiceAudioSettings({
    this.inputGain = 1,
    this.outputGain = 1,
    bool? noiseSuppression,
    VoiceNoiseSuppression? noiseMode,
    this.echoCancellation = true,
    this.autoGainControl = true,
    this.highPassFilter = true,
    this.customProfile = false,
    this.advancedActivation = true,
    this.releaseDelayMs = 300,
    this.pushToTalk = false,
    this.automaticSensitivity = true,
    this.thresholdDb = -45,
    this.shortcut = const VoiceShortcut(),
  }) : noiseMode =
           noiseMode ??
           (noiseSuppression == false
               ? VoiceNoiseSuppression.disabled
               : VoiceNoiseSuppression.deepFilter);
  final double inputGain, outputGain;
  final bool echoCancellation, autoGainControl;
  final VoiceNoiseSuppression noiseMode;
  bool get noiseSuppression => noiseMode != VoiceNoiseSuppression.disabled;
  bool get webRtcNoiseSuppression => noiseMode == VoiceNoiseSuppression.webrtc;
  final bool highPassFilter, customProfile, advancedActivation;
  final int releaseDelayMs;
  final bool pushToTalk, automaticSensitivity;
  final double thresholdDb;
  final VoiceShortcut shortcut;

  VoiceInputProfile get profile {
    if (customProfile) return VoiceInputProfile.custom;
    if (noiseMode == VoiceNoiseSuppression.deepFilter &&
        echoCancellation &&
        autoGainControl &&
        highPassFilter) {
      return VoiceInputProfile.speech;
    }
    if (!noiseSuppression &&
        !echoCancellation &&
        !autoGainControl &&
        !highPassFilter) {
      return VoiceInputProfile.studio;
    }
    return VoiceInputProfile.custom;
  }

  bool sameProcessing(VoiceAudioSettings other) =>
      noiseMode == other.noiseMode &&
      echoCancellation == other.echoCancellation &&
      autoGainControl == other.autoGainControl &&
      highPassFilter == other.highPassFilter;

  VoiceAudioSettings copyWith({
    double? inputGain,
    double? outputGain,
    bool? noiseSuppression,
    VoiceNoiseSuppression? noiseMode,
    bool? echoCancellation,
    bool? autoGainControl,
    bool? highPassFilter,
    bool? customProfile,
    bool? advancedActivation,
    int? releaseDelayMs,
    bool? pushToTalk,
    bool? automaticSensitivity,
    double? thresholdDb,
    VoiceShortcut? shortcut,
  }) => VoiceAudioSettings(
    inputGain: _gain(inputGain ?? this.inputGain),
    outputGain: _gain(outputGain ?? this.outputGain),
    noiseMode: noiseMode ?? _updatedNoise(noiseSuppression),
    echoCancellation: echoCancellation ?? this.echoCancellation,
    autoGainControl: autoGainControl ?? this.autoGainControl,
    highPassFilter: highPassFilter ?? this.highPassFilter,
    customProfile:
        customProfile ??
        _customProcessing([
          noiseSuppression,
          noiseMode,
          echoCancellation,
          autoGainControl,
          highPassFilter,
        ]),
    advancedActivation: advancedActivation ?? this.advancedActivation,
    releaseDelayMs: _delay(releaseDelayMs ?? this.releaseDelayMs),
    pushToTalk: pushToTalk ?? this.pushToTalk,
    automaticSensitivity: automaticSensitivity ?? this.automaticSensitivity,
    thresholdDb: _threshold(thresholdDb ?? this.thresholdDb),
    shortcut: shortcut ?? this.shortcut,
  );

  VoiceAudioSettings withProfile(VoiceInputProfile profile) {
    if (profile == VoiceInputProfile.custom) {
      return copyWith(customProfile: true);
    }
    final speech = profile == VoiceInputProfile.speech;
    return copyWith(
      noiseMode: speech
          ? VoiceNoiseSuppression.deepFilter
          : VoiceNoiseSuppression.disabled,
      echoCancellation: speech,
      autoGainControl: speech,
      highPassFilter: speech,
      customProfile: false,
    );
  }

  VoiceNoiseSuppression _updatedNoise(bool? enabled) {
    if (enabled == null) return noiseMode;
    if (!enabled) return VoiceNoiseSuppression.disabled;
    return noiseSuppression ? noiseMode : VoiceNoiseSuppression.deepFilter;
  }

  bool _customProcessing(List<Object?> changes) =>
      customProfile || changes.any((value) => value != null);

  static int _delay(Object? value) =>
      value is num && value.isFinite ? value.round().clamp(50, 1000) : 300;

  static double _gain(Object? value) =>
      value is num && value.isFinite ? value.toDouble().clamp(0, 2) : 1;

  static double _threshold(Object? value) =>
      value is num && value.isFinite ? value.toDouble().clamp(-60, -10) : -45;

  static bool _highPass(Map<String, dynamic> value) {
    final setting = value['highPassFilter'];
    return setting is bool ? setting : value['noiseSuppression'] != false;
  }

  factory VoiceAudioSettings.fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return const VoiceAudioSettings();
    return VoiceAudioSettings(
      inputGain: _gain(value['inputGain']),
      outputGain: _gain(value['outputGain']),
      noiseSuppression: value['noiseSuppression'] != false,
      noiseMode: _readNoise(value['noiseMode']),
      echoCancellation: value['echoCancellation'] != false,
      autoGainControl: value['autoGainControl'] != false,
      highPassFilter: _highPass(value),
      customProfile: value['customProfile'] == true,
      advancedActivation: value['advancedActivation'] != false,
      releaseDelayMs: _delay(value['releaseDelayMs']),
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
    'noiseMode': noiseMode.name,
    'echoCancellation': echoCancellation,
    'autoGainControl': autoGainControl,
    'highPassFilter': highPassFilter,
    'customProfile': customProfile,
    'advancedActivation': advancedActivation,
    'releaseDelayMs': releaseDelayMs,
    'pushToTalk': pushToTalk,
    'automaticSensitivity': automaticSensitivity,
    'thresholdDb': thresholdDb,
    'shortcut': shortcut.toJson(),
  };

  static VoiceNoiseSuppression? _readNoise(Object? value) {
    for (final mode in VoiceNoiseSuppression.values) {
      if (mode.name == value) return mode;
    }
    return null;
  }
}
