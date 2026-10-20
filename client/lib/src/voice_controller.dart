import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'generated/space/v1/voice.pb.dart';
import 'voice_media.dart';
import 'voice_connection_info.dart';
import 'voice_activity.dart';
import 'voice_devices.dart';
import 'voice_signaling.dart';
import 'voice_recovery.dart';
import 'voice_audio_settings.dart';
import 'voice_microphone_test.dart';

enum VoicePhase { idle, joining, reconnecting, connected, failed }

class _VoiceTarget {
  _VoiceTarget(this.api, this.room, this.title);
  final VoiceSignaling api;
  final String room, title;
  bool deafened = false;
}

class VoiceState {
  const VoiceState({
    this.phase = VoicePhase.idle,
    this.title = '',
    this.room = '',
    this.muted = true,
    this.deafened = false,
    this.busy = false,
    this.error = '',
    this.roster,
    this.speaking = const {},
    this.canPublish = false,
    this.connection = const VoiceConnectionInfo(),
  });
  final VoicePhase phase;
  final String title, room, error;
  final bool muted, deafened, busy, canPublish;
  final VoiceRoomState? roster;
  final Set<String> speaking;
  final VoiceConnectionInfo connection;
  bool get active =>
      phase == VoicePhase.joining ||
      phase == VoicePhase.reconnecting ||
      phase == VoicePhase.connected;
}

class VoiceController extends Cubit<VoiceState> {
  VoiceController({
    VoiceMedia Function()? mediaFactory,
    VoiceDevices? audioDevices,
    VoiceMicrophoneTest? microphoneTest,
    this.heartbeat = const Duration(seconds: 3),
    List<Duration> retryDelays = VoiceRecovery.defaults,
    this.signalingTimeout = const Duration(seconds: 15),
    this.connectionTimeout = const Duration(seconds: 45),
  }) : mediaFactory = mediaFactory ?? NativeVoiceMedia.new,
       devices = audioDevices ?? VoiceDevices(),
       microphoneTest = microphoneTest ?? VoiceMicrophoneTest(),
       _manageDevices = mediaFactory == null || audioDevices != null,
       _recovery = VoiceRecovery(retryDelays),
       super(const VoiceState()) {
    devices.onAudioChanged = _changeAudio;
    devices.beforeDeviceChanged = _prepareDeviceChange;
    this.microphoneTest.prepare = _prepareMicrophoneTest;
    this.microphoneTest.validate = _validateMicrophoneTest;
  }
  final VoiceMedia Function() mediaFactory;
  final Duration heartbeat, signalingTimeout, connectionTimeout;
  final VoiceRecovery _recovery;
  final VoiceDevices devices;
  final VoiceMicrophoneTest microphoneTest;
  final bool _manageDevices;
  _VoiceTarget? _target, _connectingTarget;
  VoiceMedia? _media;
  VoiceSignaling? _api;
  StreamSubscription<VoiceMediaStatus>? _subscription;
  StreamSubscription<void>? _disconnected;
  Future<Object?>? _leaving;
  Timer? _timer;
  VoiceActivityMonitor? _activity;
  Timer? _connectionDeadline;
  String _id = '';
  int _generation = 0;
  bool _closed = false;
  int? _pollingGeneration, _connectingGeneration;
  int? _statisticsGeneration;

  String get localSessionId => _id;

  bool matches(VoiceSignaling api, String room) {
    final current = _target?.api;
    final same =
        identical(api, current) ||
        (api is SessionVoiceSignaling &&
            current is SessionVoiceSignaling &&
            identical(api.session, current.session));
    return same && state.room == room && state.active;
  }

  Future<void> join(VoiceSignaling api, String room, String title) async {
    if (matches(api, room)) return;
    if (_closed || (_connectingGeneration == _generation && _target != null)) {
      return;
    }
    final cleanup = leave();
    final generation = _generation;
    await cleanup;
    if (_closed || generation != _generation) return;
    final target = _VoiceTarget(api, room, title);
    _target = target;
    _disconnected = api.disconnected.listen((_) {
      if (_target == target) unawaited(leave());
    });
    await _attempt(target, reconnecting: false);
  }

  Future<void> _attempt(
    _VoiceTarget target, {
    required bool reconnecting,
  }) async {
    if (_closed ||
        _target != target ||
        (_connectingTarget == target && _connectingGeneration == _generation)) {
      return;
    }
    _connectingTarget = target;
    final generation = ++_generation;
    _connectingGeneration = generation;
    try {
      await _connect(target, generation, reconnecting);
    } catch (error) {
      if (generation == _generation) await _problem(error);
    } finally {
      if (_connectingGeneration == generation) {
        _connectingTarget = null;
        _connectingGeneration = null;
      }
    }
  }

  Future<void> _connect(
    _VoiceTarget target,
    int generation,
    bool reconnecting,
  ) async {
    final media = mediaFactory();
    _media = media;
    _api = target.api;
    emit(
      VoiceState(
        phase: reconnecting ? VoicePhase.reconnecting : VoicePhase.joining,
        room: target.room,
        title: target.title,
        deafened: target.deafened,
      ),
    );
    _subscription = media.changes.listen(
      (status) => _mediaChanged(status, generation),
    );
    _connectionDeadline = Timer(connectionTimeout, () {
      if (generation == _generation) {
        unawaited(
          _problem(
            TimeoutException(
              'Не удалось подключить голос. Проверьте STUN/TURN и медиа-порты.',
            ),
          ),
        );
      }
    });
    if (target.deafened) await media.deafen(true);
    if (generation != _generation) return;
    final offer = await _offer(target, media, generation);
    if (offer == null || generation != _generation) return;
    final reply = await _joinRoom(target, offer);
    if (generation != _generation) {
      await _quietLeave(target.api, target.room, reply.sessionId);
      return;
    }
    if (reply.sessionId.isEmpty) {
      throw StateError('Некорректный ответ голосового сервера');
    }
    _id = reply.sessionId;
    if (!reply.hasState() || reply.state.capacity != 8) {
      throw StateError('Некорректный ответ голосового сервера');
    }
    if (target.deafened) {
      await target.api
          .update(target.room, _id, true, true)
          .timeout(signalingTimeout);
    }
    if (generation != _generation) return;
    await media.answer(reply.answerSdp).timeout(signalingTimeout);
    if (generation != _generation) return;
    _publish(roster: reply.state);
    _timer = Timer.periodic(heartbeat, (_) => unawaited(_refresh(generation)));
  }

  Future<String?> _offer(
    _VoiceTarget target,
    VoiceMedia media,
    int generation,
  ) async {
    final network = await target.api
        .configure(target.room)
        .timeout(signalingTimeout);
    if (generation != _generation) return null;
    if (_manageDevices) await devices.refresh();
    if (generation != _generation) return null;
    await _prepareAudioOutput(target, media);
    if (generation != _generation) return null;
    _publish(deafened: target.deafened);
    if (media is VoiceAudioMedia) {
      await (media as VoiceAudioMedia).configureAudio(devices.state.audio);
    }
    if (generation != _generation) return null;
    return media.offer(network).timeout(signalingTimeout);
  }

  Future<void> _prepareAudioOutput(
    _VoiceTarget target,
    VoiceMedia media,
  ) async {
    if (!_manageDevices ||
        (devices.state.ready && !devices.state.outputUnavailable)) {
      return;
    }
    target.deafened = true;
    await media.deafen(true);
  }

  Future<void> _prepareDeviceChange() async {
    await microphoneTest.stop();
    if (state.phase == VoicePhase.connected && !state.muted) {
      await _changeMicrophone();
    }
  }

  Future<void> _prepareMicrophoneTest() async {
    if (_closed ||
        state.busy ||
        state.phase == VoicePhase.joining ||
        state.phase == VoicePhase.reconnecting) {
      throw StateError('Дождитесь завершения подключения к голосовой комнате');
    }
    if (state.phase == VoicePhase.connected && !state.deafened) {
      await toggleDeafened();
    }
    if (_closed || (state.active && (!state.deafened || !state.muted))) {
      throw StateError('Не удалось отключить звук комнаты перед проверкой');
    }
    await _validateMicrophoneTest();
  }

  Future<void> _validateMicrophoneTest() async {
    await devices.refresh();
    if (!devices.state.ready ||
        devices.state.inputUnavailable ||
        devices.state.outputUnavailable) {
      throw StateError('Выбранные аудиоустройства недоступны');
    }
  }

  Future<void> _changeAudio(VoiceAudioSettings settings) async {
    if (_closed || state.busy) {
      throw StateError('Дождитесь завершения операции со звуком');
    }
    final processingChanged = !devices.state.audio.sameProcessing(settings);
    if (processingChanged) {
      await microphoneTest.stop();
      if (state.phase == VoicePhase.connected && !state.muted) {
        await toggleMicrophone();
      }
    }
    await _configureAudioMedia(settings);
    await microphoneTest.configure(settings);
  }

  Future<void> _configureAudioMedia(VoiceAudioSettings settings) async {
    final media = _media;
    if (media is! VoiceAudioMedia) return;
    final generation = _generation;
    _publish(busy: true);
    try {
      await (media as VoiceAudioMedia).configureAudio(settings);
    } catch (error) {
      if (generation == _generation) await _fail(error);
      rethrow;
    } finally {
      if (generation == _generation) _publish(busy: false);
    }
  }

  Future<JoinVoiceRoomResponse> _joinRoom(_VoiceTarget target, String offer) {
    var timedOut = false;
    final pending = target.api.join(target.room, offer);
    unawaited(
      pending.then((reply) async {
        if (timedOut) {
          await _quietLeave(target.api, target.room, reply.sessionId);
        }
      }, onError: (Object _) {}),
    );
    return pending.timeout(
      signalingTimeout,
      onTimeout: () {
        timedOut = true;
        throw TimeoutException('Сервер не подтвердил вход в голосовую комнату');
      },
    );
  }

  void _mediaChanged(VoiceMediaStatus status, int generation) {
    if (generation != _generation || _closed) {
      return;
    }
    if (status == VoiceMediaStatus.processingFailed) {
      unawaited(
        _fail(
          StateError(
            'Ошибка обработки микрофона. Выберите другой режим шумоподавления.',
          ),
        ),
      );
      return;
    }
    if (status == VoiceMediaStatus.failed) {
      unawaited(
        Future<void>.microtask(() async {
          if (generation == _generation && !_closed) await _recover();
        }),
      );
      return;
    }
    if (status == VoiceMediaStatus.connected) {
      _connectionDeadline?.cancel();
      _connectionDeadline = null;
      _recovery.reset();
      _publish(phase: VoicePhase.connected);
      unawaited(_refreshConnection(generation));
      _startActivity(generation);
    }
  }

  void _publish({
    VoicePhase? phase,
    VoiceRoomState? roster,
    bool? muted,
    bool? deafened,
    bool? busy,
    VoiceConnectionInfo? connection,
    Set<String>? speaking,
    String error = '',
  }) {
    if (_closed) {
      return;
    }
    final roomState = roster ?? state.roster;
    emit(
      VoiceState(
        phase: phase ?? state.phase,
        title: state.title,
        room: state.room,
        muted: muted ?? state.muted,
        deafened: deafened ?? state.deafened,
        busy: busy ?? state.busy,
        error: error,
        roster: roomState,
        canPublish: roomState?.canPublish ?? false,
        connection: connection ?? state.connection,
        speaking: speaking ?? state.speaking,
      ),
    );
  }

  void _startActivity(int generation) {
    final media = _media;
    if (media is! VoiceActivityMedia || _activity != null) return;
    _activity = VoiceActivityMonitor(
      read: (media as VoiceActivityMedia).activity,
      publish: (value) {
        if (generation == _generation && state.phase == VoicePhase.connected) {
          _publish(speaking: _speakers(value));
        }
      },
    );
  }

  Set<String> _speakers(VoiceAudioActivity activity) {
    final people = state.roster?.participants ?? [];
    final local = people.where((p) => p.sessionId == _id).firstOrNull;
    final result = <String>{};
    if (activity.local && !state.muted && !state.deafened) result.add(_id);
    if (local == null || !local.hasAudioSlot() || local.audioSlot > 7) {
      return result;
    }
    for (final person in people) {
      if (!_audibleRemote(person)) continue;
      if (_remoteSpeaking(person.audioSlot, local.audioSlot, activity)) {
        result.add(person.sessionId);
      }
    }
    return Set.unmodifiable(result);
  }

  bool _remoteSpeaking(int slot, int local, VoiceAudioActivity activity) {
    if (slot > 7 || slot == local) return false;
    final output = slot > local ? slot - 1 : slot;
    return activity.remoteSlots.contains(output);
  }

  bool _audibleRemote(VoiceParticipant person) =>
      person.sessionId != _id &&
      !person.muted &&
      !person.deafened &&
      person.hasAudioSlot();

  Future<void> _refresh(int generation) async {
    unawaited(_refreshConnection(generation));
    if (_pollingGeneration == generation ||
        state.busy ||
        _id.isEmpty ||
        generation != _generation) {
      return;
    }
    _pollingGeneration = generation;
    try {
      await _checkAudioDevices(generation);
      if (generation != _generation || state.busy) return;
      final roster = await _api!
          .update(state.room, _id, state.muted, state.deafened)
          .timeout(signalingTimeout);
      if (generation == _generation) {
        await _applyRoster(roster, generation);
      }
    } catch (error) {
      if (generation == _generation) {
        await _problem(error, missingSession: true);
      }
    } finally {
      if (_pollingGeneration == generation) {
        _pollingGeneration = null;
      }
    }
  }

  Future<void> _refreshConnection(int generation) async {
    final media = _media;
    if (generation != _generation ||
        _statisticsGeneration == generation ||
        state.phase != VoicePhase.connected ||
        media is! VoiceConnectionMedia) {
      return;
    }
    _statisticsGeneration = generation;
    var info = const VoiceConnectionInfo();
    try {
      final pending = Future<VoiceConnectionInfo>.sync(
        () => (media as VoiceConnectionMedia).connectionInfo(),
      );
      unawaited(
        pending.then(
          (_) => _finishStatistics(generation),
          onError: (Object _, StackTrace stack) =>
              _finishStatistics(generation),
        ),
      );
      info = await pending.timeout(const Duration(seconds: 2));
    } catch (_) {
      // Диагностика не должна прерывать разговор или heartbeat комнаты.
    }
    if (generation == _generation && state.phase == VoicePhase.connected) {
      _publish(connection: info, error: state.error);
    }
  }

  void _finishStatistics(int generation) {
    if (_statisticsGeneration == generation) _statisticsGeneration = null;
  }

  Future<void> _checkAudioDevices(int generation) async {
    if (!_manageDevices) return;
    await devices.refresh();
    if (generation != _generation || state.busy) return;
    if ((!devices.state.ready || devices.state.outputUnavailable) &&
        !state.deafened) {
      await toggleDeafened();
    } else if (devices.state.inputUnavailable && !state.muted) {
      await toggleMicrophone();
    }
  }

  Future<void> _applyRoster(VoiceRoomState roster, int generation) async {
    if (!roster.canPublish && !state.muted) {
      await _media?.microphone(false);
    }
    if (generation == _generation) {
      _publish(roster: roster, muted: !roster.canPublish || state.muted);
    }
  }

  Future<void> toggleMicrophone() async {
    if (microphoneTest.ownsMicrophone) return;
    if (state.busy || state.phase != VoicePhase.connected || state.deafened) {
      return;
    }
    if (!state.muted) {
      await _changeMicrophone();
      return;
    }
    if (_manageDevices) {
      final generation = _generation;
      await devices.refresh();
      if (generation != _generation ||
          state.busy ||
          state.deafened ||
          state.phase != VoicePhase.connected) {
        return;
      }
      if (!devices.state.ready || devices.state.inputUnavailable) {
        return;
      }
    }
    await _changeMicrophone();
  }

  Future<void> _changeMicrophone() async {
    final api = _api!,
        media = _media!,
        room = state.room,
        id = _id,
        deafened = state.deafened;
    final muted = !state.muted;
    final generation = _generation;
    _publish(busy: true);
    try {
      if (muted) {
        await media.microphone(false);
      }
      final roster = await api
          .update(room, id, muted, deafened)
          .timeout(signalingTimeout);
      if (generation != _generation) {
        return;
      }
      if (!muted) {
        if (media is NativeVoiceMedia) {
          media.inputDeviceId = devices.state.input;
        }
        await media.microphone(true);
      }
      if (generation == _generation) {
        _publish(muted: muted, roster: roster, busy: false);
      }
    } catch (error) {
      if (generation == _generation) {
        await _microphoneFailed(
          error,
          api,
          media,
          room,
          id,
          generation,
          deafened,
        );
      }
    }
  }

  Future<void> _microphoneFailed(
    Object error,
    VoiceSignaling api,
    VoiceMedia media,
    String room,
    String id,
    int generation,
    bool deafened,
  ) async {
    try {
      await media.microphone(false);
      final roster = await api
          .update(room, id, true, deafened)
          .timeout(signalingTimeout);
      if (generation == _generation) {
        _publish(
          muted: true,
          busy: false,
          roster: roster,
          error: error.toString(),
        );
      }
    } catch (other) {
      if (generation == _generation) {
        await _problem(other);
      }
    }
  }

  Future<void> toggleDeafened() async {
    if (microphoneTest.ownsMicrophone && state.deafened) return;
    if (state.busy || state.phase != VoicePhase.connected) {
      return;
    }
    if (_manageDevices &&
        state.deafened &&
        (!devices.state.ready || devices.state.outputUnavailable)) {
      return;
    }
    final generation = _generation;
    final api = _api!, media = _media!, room = state.room, id = _id;
    final deafened = !state.deafened;
    _target?.deafened = deafened;
    _publish(muted: true, deafened: deafened, busy: true);
    try {
      await media.microphone(false);
      await media.deafen(deafened);
      final roster = await api
          .update(room, id, true, deafened)
          .timeout(signalingTimeout);
      if (generation == _generation) {
        _publish(muted: true, deafened: deafened, busy: false, roster: roster);
      }
    } catch (error) {
      if (generation == _generation) {
        await _problem(error);
      }
    }
  }

  Future<void> _quietLeave(VoiceSignaling api, String room, String id) async {
    if (id.isEmpty) {
      return;
    }
    try {
      await api.leave(room, id).timeout(const Duration(seconds: 3));
    } catch (_) {
      /* Сервер завершит сеанс по сроку. */
    }
  }

  Future<void> leave() async {
    if (!_closed && state.active) _publish(busy: true, muted: true);
    _target = null;
    _recovery.reset();
    _cancel(_disconnected);
    _disconnected = null;
    final testCleanup = microphoneTest.stop();
    final cleanup = _disconnectMedia();
    final generation = _generation;
    final failure = await cleanup;
    await testCleanup;
    if (!_closed && generation == _generation) {
      emit(
        failure == null
            ? const VoiceState()
            : VoiceState(phase: VoicePhase.failed, error: failure.toString()),
      );
    }
  }

  Future<Object?> _disconnectMedia() {
    _generation++;
    return _leaving ??= _release().whenComplete(() => _leaving = null);
  }

  Future<Object?> _release() async {
    _timer?.cancel();
    _timer = null;
    _activity?.close();
    _activity = null;
    _connectionDeadline?.cancel();
    _connectionDeadline = null;
    final media = _media, api = _api, id = _id, room = state.room;
    _media = null;
    _api = null;
    _id = '';
    _cancel(_subscription);
    _subscription = null;
    try {
      await media?.close();
      return null;
    } catch (error) {
      return error;
    } finally {
      if (api != null) await _quietLeave(api, room, id);
    }
  }

  Future<void> _problem(Object error, {bool missingSession = false}) =>
      canRecoverVoice(error, missingSession: missingSession)
      ? _recover()
      : _fail(error);

  Future<void> _recover() async {
    final target = _target;
    if (_closed || target == null) return;
    final cleanup = _disconnectMedia();
    final generation = _generation;
    emit(
      VoiceState(
        phase: VoicePhase.reconnecting,
        room: target.room,
        title: target.title,
        deafened: target.deafened,
      ),
    );
    final failure = await cleanup;
    if (_closed || generation != _generation || _target != target) return;
    if (failure != null) {
      await _fail(failure);
      return;
    }
    _recovery.schedule(() => unawaited(_attempt(target, reconnecting: true)));
  }

  void _cancel(StreamSubscription<dynamic>? subscription) {
    if (subscription != null) {
      unawaited(subscription.cancel().catchError((Object _) {}));
    }
  }

  Future<void> _fail(Object error) async {
    final cleanup = leave();
    final generation = _generation;
    await cleanup;
    if (!_closed && generation == _generation) {
      emit(VoiceState(phase: VoicePhase.failed, error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    _closed = true;
    await leave();
    await devices.close();
    await microphoneTest.close();
    await super.close();
  }
}
