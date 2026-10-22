import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'voice_network.dart';
import 'voice_connection_info.dart';
import 'voice_audio_native.dart';
import 'voice_audio_settings.dart';
import 'voice_transmission.dart';
import 'voice_denoiser.dart';
import 'voice_activity.dart';
import 'voice_android_session.dart';

enum VoiceMediaStatus {
  connecting,
  connected,
  failed,
  processingFailed,
  microphoneInterrupted,
}

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

abstract interface class VoiceAudioMedia {
  Future<void> configureAudio(VoiceAudioSettings settings);
}

class NativeVoiceMedia
    implements
        VoiceMedia,
        VoiceAudioMedia,
        VoiceConnectionMedia,
        VoiceActivityMedia {
  NativeVoiceMedia({this.playbackVolume = 1.0});
  final double playbackVolume;
  bool _transmitting = false;
  double _inputLevel = 0;
  final _audioLevels = VoiceAudioLevels();
  int _transmissionRevision = 0;
  bool _interruptionReported = false;
  // Подтверждённое нативным обработчиком состояние, без записи звука.
  bool get transmitting => _transmitting;
  String? inputDeviceId;
  VoiceAudioSettings _audio = const VoiceAudioSettings();
  var _androidSession = VoiceAndroidSession();
  bool _ownsAndroidSession = true;

  // Служба принадлежит всему разговору и переживает замену WebRTC-соединения.
  void bindAndroidSession(VoiceAndroidSession session) {
    if (_peer != null || _microphone != null || _closed) {
      throw StateError('Нельзя заменить службу начатого разговора');
    }
    _androidSession = session;
    _ownsAndroidSession = false;
  }

  late final _transmission = VoiceTransmission(
    level: _level,
    transmit: _transmit,
    allowTouch: Platform.isAndroid,
  );

  Future<double> _level() async {
    try {
      _inputLevel = await VoiceAudioNative.level();
      return _inputLevel;
    } on PlatformException catch (error) {
      if (error.code == 'audio_interrupted') {
        _reportInterruption();
      } else if (!_closed) {
        _changes.add(VoiceMediaStatus.processingFailed);
      }
      rethrow;
    } catch (_) {
      if (!_closed) _changes.add(VoiceMediaStatus.processingFailed);
      rethrow;
    }
  }

  void _reportInterruption() {
    if (_closed || _interruptionReported) return;
    _interruptionReported = true;
    _changes.add(VoiceMediaStatus.microphoneInterrupted);
  }

  void _transmit(bool enabled) {
    final revision = ++_transmissionRevision;
    final value = enabled && !_closed && !_deafened;
    unawaited(
      VoiceAudioNative.transmission(value)
          .then((_) {
            if (revision == _transmissionRevision) _transmitting = value;
          })
          .catchError((Object _) {
            _transmitting = false;
            for (final track
                in _microphone?.getAudioTracks() ?? <MediaStreamTrack>[]) {
              track.enabled = false;
            }
            if (!_closed) _changes.add(VoiceMediaStatus.failed);
          }),
    );
  }

  final _changes = StreamController<VoiceMediaStatus>.broadcast();
  RTCPeerConnection? _peer;
  RTCRtpSender? _sender;
  MediaStream? _microphone;
  VoiceDenoiser? _denoiser;
  final _remote = <MediaStreamTrack>[];
  bool _closed = false, _deafened = false;
  @override
  Stream<VoiceMediaStatus> get changes => _changes.stream;

  @override
  Future<String> offer([
    VoiceNetworkSettings settings = const VoiceNetworkSettings.local(),
  ]) async {
    if (Platform.isIOS) {
      throw UnsupportedError('Голосовой срез доступен на компьютере');
    }
    await VoiceAudioNative.initialize();
    await _androidSession.start();
    final peer = await createPeerConnection(settings.peerConfiguration);
    if (_closed) {
      await peer.close();
      await peer.dispose();
      throw StateError('Вход отменён');
    }
    _peer = peer;
    peer.onConnectionState = _connectionChanged;
    peer.onTrack = _track;
    _sender = await _prepareAudio(peer, settings.mediaCapacity);
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
    if (sdp == null || sdp.length > 65536) {
      throw StateError('Некорректное предложение WebRTC');
    }
    return sdp;
  }

  Future<RTCRtpSender> _prepareAudio(
    RTCPeerConnection peer,
    int capacity,
  ) async {
    final outgoing = await peer.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.SendRecv),
    );
    for (var index = 1; index < capacity - 1; index++) {
      await peer.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
      );
    }
    return outgoing.sender;
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
    if (playbackVolume * _audio.outputGain == 1.0) {
      event.track.enabled = !_deafened;
      return;
    }
    event.track.enabled = false;
    unawaited(_configureVolume(event.track));
  }

  Future<void> _configureVolume(MediaStreamTrack track) async {
    try {
      await Helper.setVolume(playbackVolume * _audio.outputGain, track);
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
  Future<void> configureAudio(VoiceAudioSettings settings) async {
    if (_closed) return;
    if (!_audio.sameProcessing(settings) && _microphone != null) {
      await _stopMicrophone();
    }
    await VoiceAudioNative.gain(settings.inputGain);
    if (_closed) return;
    _audio = settings;
    _transmission.configure(settings);
    for (final track in List.of(_remote)) {
      track.enabled = false;
      await Helper.setVolume(playbackVolume * settings.outputGain, track);
      if (!_closed) track.enabled = !_deafened;
    }
  }

  @override
  Future<void> answer(String sdp) async {
    _audioLevels.configure(sdp);
    if (_closed || sdp.length > 65536) {
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
    try {
      _interruptionReported = false;
      await VoiceAudioNative.capture(true);
      await VoiceAudioNative.transmission(false);
      final denoiser = VoiceDenoiser();
      _denoiser = denoiser;
      await denoiser.open(_audio);
      await _openMicrophone();
    } catch (_) {
      await _stopMicrophone();
      rethrow;
    }
  }

  Future<void> _openMicrophone() async {
    if (_closed || _deafened) {
      throw StateError('Включение микрофона отменено');
    }
    final stream = await navigator.mediaDevices.getUserMedia(
      voiceMicrophoneConstraints(inputDeviceId, _audio),
    );
    if (_closed || _deafened) {
      await _stopStream(stream);
      throw StateError('Включение микрофона отменено');
    }
    _microphone = stream;
    await _androidSession.capture(true);
    _transmit(false);
    _transmission.start(_audio);
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
    _transmission.stop();
    _inputLevel = 0;
    final stream = _microphone;
    _microphone = null;
    final denoiser = _denoiser;
    try {
      if (stream != null) {
        try {
          await _sender?.replaceTrack(null);
        } finally {
          await _stopStream(stream);
        }
      }
    } finally {
      try {
        await denoiser?.close();
        if (_denoiser == denoiser) _denoiser = null;
      } finally {
        await VoiceAudioNative.capture(false);
        if (!_closed || !_ownsAndroidSession) {
          await _androidSession.capture(false);
        }
      }
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
          if (_ownsAndroidSession) await _androidSession.close();
          _remote.clear();
          unawaited(_changes.close());
        }
      }
    }
  }

  @override
  Future<VoiceAudioActivity> activity() async => VoiceAudioActivity(
    local:
        !_closed &&
        !_deafened &&
        _microphone != null &&
        _transmitting &&
        _inputLevel > .008,
    remoteSlots: _audioLevels.read(await statistics()),
  );

  Future<List<StatsReport>> statistics() async => await _peer?.getStats() ?? [];

  @override
  Future<VoiceConnectionInfo> connectionInfo() async =>
      VoiceConnectionInfo.fromStats(await statistics());
}

// Нативный desktop-плагин читает вход через optional.sourceId.
// audio.deviceId в его C++ реализации выбирает устройство вывода.
Map<String, dynamic> voiceMicrophoneConstraints(
  String? inputDeviceId, [
  VoiceAudioSettings audio = const VoiceAudioSettings(),
]) => {
  'audio': {
    'echoCancellation': audio.echoCancellation,
    'noiseSuppression': audio.webRtcNoiseSuppression,
    'autoGainControl': audio.autoGainControl,
    'highpassFilter': audio.highPassFilter,
    'channelCount': 1,
    'optional': [
      if (inputDeviceId != null) {'sourceId': inputDeviceId},
      {'googEchoCancellation': audio.echoCancellation},
      {'googNoiseSuppression': audio.webRtcNoiseSuppression},
      {'googAutoGainControl': audio.autoGainControl},
      {'googHighpassFilter': audio.highPassFilter},
    ],
  },
  'video': false,
};
