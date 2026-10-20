import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'voice_audio_settings.dart';

class VoiceDeviceChoice {
  const VoiceDeviceChoice({
    this.input,
    this.output,
    this.inputLabel,
    this.outputLabel,
    this.audio = const VoiceAudioSettings(),
  });
  final String? input, output, inputLabel, outputLabel;
  final VoiceAudioSettings audio;

  VoiceDeviceChoice change(String id, {required bool input, String? label}) =>
      VoiceDeviceChoice(
        input: input ? id : this.input,
        output: input ? output : id,
        inputLabel: input ? label : inputLabel,
        outputLabel: input ? outputLabel : label,
        audio: audio,
      );

  VoiceDeviceChoice changeAudio(VoiceAudioSettings settings) =>
      VoiceDeviceChoice(
        input: input,
        output: output,
        inputLabel: inputLabel,
        outputLabel: outputLabel,
        audio: settings,
      );
}

abstract interface class VoiceDevicePreferences {
  Future<VoiceDeviceChoice> load();
  Future<void> save(VoiceDeviceChoice choice);
}

class SavedVoiceDevicePreferences implements VoiceDevicePreferences {
  static const key = 'space.voice.devices';

  @override
  Future<VoiceDeviceChoice> load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.get(key);
    if (saved is! String) return const VoiceDeviceChoice();
    try {
      return _decode(saved);
    } on FormatException {
      return const VoiceDeviceChoice();
    }
  }

  VoiceDeviceChoice _decode(String saved) {
    final value = jsonDecode(saved);
    if (value is! Map<String, dynamic>) return const VoiceDeviceChoice();
    return VoiceDeviceChoice(
      input: _deviceId(value['input']),
      output: _deviceId(value['output']),
      inputLabel: _deviceId(value['inputLabel']),
      outputLabel: _deviceId(value['outputLabel']),
      audio: VoiceAudioSettings.fromJson(value['audio']),
    );
  }

  String? _deviceId(Object? value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty && value.length <= 4096) {
      return value;
    }
    return null;
  }

  @override
  Future<void> save(VoiceDeviceChoice choice) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      key,
      jsonEncode({
        'input': choice.input,
        'output': choice.output,
        'inputLabel': choice.inputLabel,
        'outputLabel': choice.outputLabel,
        'audio': choice.audio.toJson(),
      }),
    );
    if (!saved) throw StateError('Не удалось сохранить выбор аудиоустройств');
  }
}
