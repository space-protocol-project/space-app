import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ViewFocusEvent, ViewFocusState;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'voice_audio_settings.dart';
import 'voice_shortcut.dart';

/// Разрешение передачи применяется только к уже включённому микрофону.
class VoiceTransmission with WidgetsBindingObserver {
  VoiceTransmission({required this.level, required this.transmit});
  final Future<double> Function() level;
  final void Function(bool) transmit;
  VoiceAudioSettings settings = const VoiceAudioSettings();
  Timer? _timer;
  bool _active = false, _held = false, _sampling = false, _focused = true;
  double _noise = -55;
  int _tail = 0, _generation = 0;

  void start(VoiceAudioSettings value) {
    stop();
    settings = value;
    _active = true;
    _focused =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    HardwareKeyboard.instance.addHandler(_key);
    voiceShortcutRecording.addListener(_shortcutRecordingChanged);
    transmit(false);
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) => _sample());
  }

  void configure(VoiceAudioSettings value) {
    _generation++;
    settings = value;
    _held = false;
    _tail = 0;
    if (_active) transmit(false);
  }

  bool _key(KeyEvent event) {
    if (!settings.pushToTalk || voiceShortcutRecording.value) return false;
    final shortcut = settings.shortcut;
    if (_held && !shortcut.modifiersMatch) {
      _held = false;
      transmit(false);
    }
    if (event.logicalKey != shortcut.key || !shortcut.modifiersMatch) {
      return false;
    }
    if (event is KeyDownEvent &&
        !event.synthesized &&
        _focused &&
        shortcut.modifiersMatch) {
      _held = true;
    }
    if (event is KeyUpEvent) _held = false;
    transmit(_active && _focused && _held);
    return true;
  }

  void _shortcutRecordingChanged() {
    _generation++;
    _held = false;
    _tail = 0;
    if (_active) transmit(false);
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) =>
      _focus(event.state == ViewFocusState.focused);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      _focus(state == AppLifecycleState.resumed);

  void _focus(bool value) {
    _focused = value;
    _held = false;
    _tail = 0;
    if (_active) transmit(false);
  }

  Future<void> _sample() async {
    if (!_active ||
        _sampling ||
        settings.pushToTalk ||
        voiceShortcutRecording.value) {
      return;
    }
    _sampling = true;
    final generation = _generation;
    try {
      final value = await level();
      if (generation != _generation ||
          settings.pushToTalk ||
          voiceShortcutRecording.value) {
        return;
      }
      transmit(_gate(value));
    } catch (_) {
      if (generation == _generation) {
        _tail = 0;
        transmit(false);
      }
    } finally {
      _sampling = false;
    }
  }

  bool _gate(double value) {
    if (!value.isFinite || value <= 0) {
      _tail = 0;
      return false;
    }
    final db = 20 * math.log(value) / math.ln10;
    final threshold = settings.automaticSensitivity
        ? (_noise + 10).clamp(-50.0, -25.0)
        : settings.thresholdDb;
    if (db < threshold) _noise = _noise * .98 + db.clamp(-70, -25) * .02;
    if (db >= threshold) _tail = 6;
    final open = _tail > 0;
    if (_tail > 0) _tail--;
    return open;
  }

  void stop() {
    _generation++;
    _timer?.cancel();
    _timer = null;
    if (!_active) return;
    _active = false;
    _held = false;
    HardwareKeyboard.instance.removeHandler(_key);
    voiceShortcutRecording.removeListener(_shortcutRecordingChanged);
    WidgetsBinding.instance.removeObserver(this);
    transmit(false);
  }
}
