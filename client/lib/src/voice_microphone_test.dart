import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'voice_audio_settings.dart';
import 'voice_microphone_probe.dart';

class VoiceMicrophoneTestState {
  const VoiceMicrophoneTestState({
    this.active = false,
    this.busy = false,
    this.level = 0,
    this.error = '',
  });
  final bool active, busy;
  final double level;
  final String error;
}

class VoiceMicrophoneTest extends Cubit<VoiceMicrophoneTestState> {
  VoiceMicrophoneTest({
    VoiceMicrophoneProbe Function()? factory,
    this.interval = const Duration(milliseconds: 100),
    this.duration = const Duration(seconds: 60),
  }) : factory = factory ?? NativeVoiceMicrophoneProbe.new,
       super(const VoiceMicrophoneTestState());
  final VoiceMicrophoneProbe Function() factory;
  final Duration interval, duration;
  Future<void> Function()? prepare;
  Future<void> Function()? validate;
  VoiceMicrophoneProbe? _probe;
  Timer? _timer, _deadline, _deviceTimer;
  int _generation = 0;
  int? _pollingGeneration;
  int? _checkingGeneration;
  bool _blocked = false;
  Future<void>? _stopping;
  bool get running => state.active || state.busy;
  bool get ownsMicrophone => running || _blocked;

  Future<void> start(String? device, VoiceAudioSettings settings) async {
    if (isClosed || running || _blocked || _stopping != null) return;
    final generation = ++_generation;
    emit(const VoiceMicrophoneTestState(busy: true));
    try {
      await prepare?.call();
      if (isClosed || generation != _generation) return;
      final probe = factory();
      _probe = probe;
      await probe.open(device, settings);
      if (isClosed || generation != _generation) return;
      emit(const VoiceMicrophoneTestState(active: true));
      _timer = Timer.periodic(
        interval,
        (_) => unawaited(_sample(generation, probe)),
      );
      _deadline = Timer(duration, () => unawaited(stop()));
      if (validate != null) {
        _deviceTimer = Timer.periodic(
          const Duration(seconds: 2),
          (_) => unawaited(_verifyDevices(generation)),
        );
      }
    } catch (error) {
      if (generation == _generation) await _failed(error);
    }
  }

  Future<void> _verifyDevices(int generation) async {
    if (_checkingGeneration == generation) return;
    _checkingGeneration = generation;
    try {
      await validate?.call();
    } catch (error) {
      if (generation == _generation) await _failed(error);
    } finally {
      if (_checkingGeneration == generation) _checkingGeneration = null;
    }
  }

  Future<void> _sample(int generation, VoiceMicrophoneProbe probe) async {
    if (_pollingGeneration == generation) return;
    _pollingGeneration = generation;
    try {
      final level = await probe.level();
      if (!isClosed && generation == _generation) {
        emit(
          VoiceMicrophoneTestState(
            active: true,
            level: level.isFinite ? level.clamp(0, 1) : 0,
          ),
        );
      }
    } catch (error) {
      if (generation == _generation) await _failed(error);
    } finally {
      if (_pollingGeneration == generation) _pollingGeneration = null;
    }
  }

  Future<void> configure(VoiceAudioSettings settings) async {
    await _probe?.configure(settings);
  }

  Future<void> _failed(Object error) async {
    final generation = _generation;
    await stop();
    if (!isClosed && !_blocked && _generation == generation + 1) {
      emit(VoiceMicrophoneTestState(error: error.toString()));
    }
  }

  Future<void> stop() {
    if (_stopping != null) return _stopping!;
    _generation++;
    _timer?.cancel();
    _deadline?.cancel();
    _deviceTimer?.cancel();
    _timer = null;
    _deadline = null;
    _deviceTimer = null;
    final probe = _probe;
    _probe = null;
    return _stopping = _release(probe).whenComplete(() => _stopping = null);
  }

  Future<void> _release(VoiceMicrophoneProbe? probe) async {
    if (!isClosed) emit(const VoiceMicrophoneTestState(busy: true));
    try {
      await probe?.close();
      if (!isClosed && !_blocked) emit(const VoiceMicrophoneTestState());
    } catch (error) {
      _blocked = true;
      if (!isClosed) emit(VoiceMicrophoneTestState(error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await stop();
    await super.close();
  }
}
