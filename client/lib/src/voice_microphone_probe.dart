import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'voice_audio_native.dart';
import 'voice_audio_settings.dart';
import 'voice_media.dart';

abstract interface class VoiceMicrophoneProbe {
  Future<void> open(String? device, VoiceAudioSettings settings);
  Future<void> configure(VoiceAudioSettings settings);
  Future<double> level();
  Future<void> close();
}

class NativeVoiceMicrophoneProbe implements VoiceMicrophoneProbe {
  MediaStream? _stream;
  RTCPeerConnection? _sender, _receiver;
  final _remote = <MediaStreamTrack>[];
  final _cancelled = Completer<void>();
  VoiceAudioSettings _settings = const VoiceAudioSettings();
  Object? _failure;
  bool _closed = false;
  Future<void>? _closing;

  void _check() {
    if (_closed) throw StateError('Проверка микрофона остановлена');
  }

  @override
  Future<void> open(String? device, VoiceAudioSettings settings) async {
    _check();
    await VoiceAudioNative.gain(settings.inputGain);
    await VoiceAudioNative.transmission(true);
    _check();
    _settings = settings;
    final stream = await navigator.mediaDevices.getUserMedia(
      voiceMicrophoneConstraints(device, settings),
    );
    if (_closed) {
      await _stopStream(stream);
      _check();
    }
    _stream = stream;
    await _peer(sender: true);
    _check();
    await _peer(sender: false);
    _check();
    _receiver!.onTrack = _track;
    _receiver!.onConnectionState = (state) {
      if (!_closed &&
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        _failure = StateError(
          'Не удалось запустить локальную проверку микрофона',
        );
      }
    };
    await _sender!.addTrack(stream.getAudioTracks().single, stream);
    _check();
    final offer = await _description(_sender!, await _sender!.createOffer());
    _check();
    await _receiver!.setRemoteDescription(offer);
    _check();
    final answer = await _description(
      _receiver!,
      await _receiver!.createAnswer(),
    );
    _check();
    await _sender!.setRemoteDescription(answer);
    _check();
  }

  Future<void> _peer({required bool sender}) async {
    final peer = await createPeerConnection({
      'iceServers': <Object>[],
      'sdpSemantics': 'unified-plan',
    });
    if (_closed) {
      await _closePeer(peer);
      _check();
    }
    if (sender) {
      _sender = peer;
    } else {
      _receiver = peer;
    }
  }

  Future<RTCSessionDescription> _description(
    RTCPeerConnection peer,
    RTCSessionDescription description,
  ) async {
    _check();
    final gathered = Completer<void>();
    peer.onIceGatheringState = (state) {
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete &&
          !gathered.isCompleted) {
        gathered.complete();
      }
    };
    await peer.setLocalDescription(description);
    _check();
    if (peer.iceGatheringState !=
        RTCIceGatheringState.RTCIceGatheringStateComplete) {
      await Future.any([gathered.future, _cancelled.future])
          .timeout(const Duration(seconds: 10));
    }
    _check();
    return (await peer.getLocalDescription())!;
  }

  void _track(RTCTrackEvent event) {
    event.track.enabled = false;
    if (_closed || event.track.kind != 'audio') return;
    _remote.add(event.track);
    unawaited(
      _volume(event.track).catchError((Object error) {
        _failure = error;
      }),
    );
  }

  Future<void> _volume(MediaStreamTrack track) async {
    await Helper.setVolume(_settings.outputGain, track);
    if (!_closed) track.enabled = true;
  }

  @override
  Future<void> configure(VoiceAudioSettings settings) async {
    _check();
    await VoiceAudioNative.gain(settings.inputGain);
    _check();
    _settings = settings;
    for (final track in List.of(_remote)) {
      await _volume(track);
    }
  }

  @override
  Future<double> level() async {
    _check();
    if (_failure != null) throw _failure!;
    return VoiceAudioNative.level();
  }

  Future<void> _stopStream(MediaStream stream) async {
    try {
      for (final track in stream.getTracks()) {
        await track.stop();
      }
    } finally {
      await stream.dispose();
    }
  }

  Future<void> _closePeer(RTCPeerConnection? peer) async {
    try {
      await peer?.close();
    } finally {
      await peer?.dispose();
    }
  }

  @override
  Future<void> close() {
    _closed = true;
    if (!_cancelled.isCompleted) _cancelled.complete();
    return _closing ??= _release();
  }

  Future<void> _release() async {
    for (final track in _remote) {
      track.enabled = false;
    }
    try {
      final stream = _stream;
      _stream = null;
      if (stream != null) await _stopStream(stream);
    } finally {
      try {
        await _closePeer(_sender);
      } finally {
        await _closePeer(_receiver);
      }
    }
  }
}
