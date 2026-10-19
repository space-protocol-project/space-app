import 'package:flutter/services.dart';
import 'package:space_voice_native/space_voice_native.dart';

import 'voice_audio_settings.dart';

/// Контекст одного захвата; callback отсоединяется до освобождения памяти.
class VoiceDenoiser {
  VoiceDenoiser({this.create = DeepFilterContext.create});
  final Future<DeepFilterHandle> Function() create;
  static const _channel = MethodChannel('FlutterWebRTC.Method');
  DeepFilterHandle? _context;
  Future<void>? _closing;
  bool _closed = false;

  Future<void> open(VoiceAudioSettings settings) async {
    if (_closed) throw StateError('Захват микрофона отменён');
    if (settings.noiseMode != VoiceNoiseSuppression.deepFilter) return;
    final context = await create();
    if (_closed) {
      context.release();
      throw StateError('Захват микрофона отменён');
    }
    _context = context;
    await _channel.invokeMethod<void>('spaceVoiceDenoiser', {
      'context': context.address,
      'callback': context.callbackAddress,
      'expected': 0,
    });
    if (_closed) await close();
  }

  Future<void> close() {
    _closed = true;
    final context = _context;
    if (context == null) return Future.value();
    return _closing ??= _detach(context);
  }

  Future<void> _detach(DeepFilterHandle context) async {
    await _channel.invokeMethod<void>('spaceVoiceDenoiser', {
      'context': 0,
      'callback': 0,
      'expected': context.address,
    });
    // При ошибке отсоединения контекст сохраняется: callback ещё может его читать.
    context.release();
    if (_context == context) _context = null;
  }
}
