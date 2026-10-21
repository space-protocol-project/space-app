import 'dart:io';

import 'package:flutter/services.dart';

/// Служба удерживает разговор в фоне, но никогда не начинает захват сама.
class VoiceAndroidSession {
  static const _channel = MethodChannel('space/voice-session');
  bool _started = false;
  bool _closed = false;

  Future<void> start({bool microphone = false}) async {
    if (!Platform.isAndroid || _closed) return;
    final running = _started;
    _started = true;
    try {
      await _channel
          .invokeMethod<void>('start', {'microphone': microphone})
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      if (!running) await close();
      rethrow;
    }
    if (_closed) await close();
  }

  Future<void> capture(bool enabled) async {
    if (_started && !_closed) await start(microphone: enabled);
  }

  Future<void> close() async {
    _closed = true;
    if (!Platform.isAndroid || !_started) return;
    _started = false;
    await _channel.invokeMethod<void>('stop');
  }
}
