import 'dart:async';
import 'dart:io';

import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'voice_network.dart';

enum VoiceMediaStatus { connecting, connected, failed }

abstract interface class VoiceMedia {
  Stream<VoiceMediaStatus> get changes;
  Future<String> offer([
    VoiceNetworkSettings settings = const VoiceNetworkSettings.local(),
  ]);
  Future<void> answer(String sdp);
  Future<void> microphone(bool enabled);
  Future<void> deafen(bool enabled);
  Future<void> close();
}

class NativeVoiceMedia implements VoiceMedia {
  NativeVoiceMedia({this.playbackVolume = 1.0});
  final double playbackVolume;
  final _changes = StreamController<VoiceMediaStatus>.broadcast();
  RTCPeerConnection? _peer;
  RTCRtpSender? _sender;
  MediaStream? _microphone;
  final _remote = <MediaStreamTrack>[];
  bool _closed = false, _deafened = false;
  @override
  Stream<VoiceMediaStatus> get changes => _changes.stream;

  @override
  Future<String> offer([
    VoiceNetworkSettings settings = const VoiceNetworkSettings.local(),
  ]) async {
    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      throw UnsupportedError('Голосовой срез доступен на компьютере');
    }
    await WebRTC.initialize(options: {'logSeverity': 'error'});
    final peer = await createPeerConnection(settings.peerConfiguration);
    if (_closed) {
      await peer.close();
      await peer.dispose();
      throw StateError('Вход отменён');
    }
    _peer = peer;
    peer.onConnectionState = _connectionChanged;
    peer.onTrack = _track;
    final transceiver = await peer.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.SendRecv),
    );
    _sender = transceiver.sender;
    final gathered = Completer<void>();
    peer.onIceGatheringState = (state) {
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete &&
          !gathered.isCompleted) {
        gathered.complete();
      }
    };
    await peer.setLocalDescription(
      await peer.createOffer({
        'mandatory': {
          'OfferToReceiveAudio': true,
          'OfferToReceiveVideo': false,
        },
        'optional': <Map<String, dynamic>>[],
      }),
    );
    if (peer.iceGatheringState ==
            RTCIceGatheringState.RTCIceGatheringStateComplete &&
        !gathered.isCompleted) {
      gathered.complete();
    }
    await gathered.future.timeout(const Duration(seconds: 15));
    if (_closed) {
      throw StateError('Вход отменён');
    }
    final sdp = (await peer.getLocalDescription())?.sdp;
    if (sdp == null || sdp.length > 12288) {
      throw StateError('Некорректное предложение WebRTC');
    }
    return sdp;
  }

  void _connectionChanged(RTCPeerConnectionState state) {
    if (_closed) {
      return;
    }
    final status = switch (state) {
      RTCPeerConnectionState.RTCPeerConnectionStateConnected =>
        VoiceMediaStatus.connected,
      RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
      RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
      RTCPeerConnectionState.RTCPeerConnectionStateClosed =>
        VoiceMediaStatus.failed,
      _ => VoiceMediaStatus.connecting,
    };
    _changes.add(status);
  }

  void _track(RTCTrackEvent event) {
    if (_closed || event.track.kind != 'audio') {
      return;
    }
    _remote.add(event.track);
    if (playbackVolume == 1.0) {
      event.track.enabled = !_deafened;
      return;
    }
    event.track.enabled = false;
    unawaited(_configureVolume(event.track));
  }

  Future<void> _configureVolume(MediaStreamTrack track) async {
    try {
      await Helper.setVolume(playbackVolume, track);
      if (!_closed) {
        track.enabled = !_deafened;
      }
    } catch (_) {
      if (!_closed) {
        _changes.add(VoiceMediaStatus.failed);
      }
    }
  }

  @override
  Future<void> answer(String sdp) async {
    if (_closed || sdp.length > 16384) {
      throw StateError('Подключение закрыто');
    }
    await _peer!
        .setRemoteDescription(RTCSessionDescription(sdp, 'answer'))
        .timeout(const Duration(seconds: 15));
  }

  @override
  Future<void> microphone(bool enabled) async {
    if (!enabled) {
      await _stopMicrophone();
      return;
    }
    if (_closed || _deafened) {
      throw StateError('Микрофон недоступен');
    }
    if (_microphone != null) {
      return;
    }
    final stream = await navigator.mediaDevices.getUserMedia({
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'autoGainControl': true,
      },
      'video': false,
    });
    if (_closed || _deafened) {
      await _stopStream(stream);
      throw StateError('Включение микрофона отменено');
    }
    _microphone = stream;
    try {
      await _sender!.replaceTrack(stream.getAudioTracks().single);
    } catch (_) {
      await _stopMicrophone();
      rethrow;
    }
  }

  Future<void> _stopStream(MediaStream stream) async {
    for (final track in stream.getTracks()) {
      await track.stop();
    }
    await stream.dispose();
  }

  Future<void> _stopMicrophone() async {
    final stream = _microphone;
    _microphone = null;
    if (stream == null) {
      return;
    }
    try {
      await _sender?.replaceTrack(null);
    } finally {
      await _stopStream(stream);
    }
  }

  @override
  Future<void> deafen(bool enabled) async {
    _deafened = enabled;
    if (enabled) {
      await _stopMicrophone();
    }
    for (final track in _remote) {
      track.enabled = !enabled;
    }
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    try {
      await _stopMicrophone();
    } finally {
      try {
        await _peer?.close();
      } finally {
        try {
          await _peer?.dispose();
        } finally {
          _remote.clear();
          unawaited(_changes.close());
        }
      }
    }
  }

  Future<List<StatsReport>> statistics() async => await _peer?.getStats() ?? [];
}
