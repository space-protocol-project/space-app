import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceAudioNative {
  static const _channel = MethodChannel('FlutterWebRTC.Method');
  static Future<void> gain(double value) async {
    if (!value.isFinite || value < 0 || value > 2) {
      throw ArgumentError.value(value);
    }
    await WebRTC.initialize(options: {'logSeverity': 'error'});
    await _channel.invokeMethod<void>('spaceVoiceGain', {'gain': value});
  }

  static Future<double> level() async {
    final level = await _channel.invokeMethod<double>('spaceVoiceLevel') ?? 0;
    return level.isFinite ? level.clamp(0, 1) : 0;
  }

  static Future<void> transmission(bool enabled) =>
      _channel.invokeMethod<void>('spaceVoiceTransmit', {'enabled': enabled});
}
