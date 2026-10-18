import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'generated/space/v1/voice.pb.dart';
import 'voice_media.dart';
import 'voice_signaling.dart';

enum VoicePhase { idle, joining, connected, failed }

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
    this.canPublish = false,
  });
  final VoicePhase phase;
  final String title, room, error;
  final bool muted, deafened, busy, canPublish;
  final VoiceRoomState? roster;
  bool get active =>
      phase == VoicePhase.joining || phase == VoicePhase.connected;
}

class VoiceController extends Cubit<VoiceState> {
  VoiceController({
    VoiceMedia Function()? mediaFactory,
    this.heartbeat = const Duration(seconds: 3),
  }) : mediaFactory = mediaFactory ?? NativeVoiceMedia.new,
       super(const VoiceState());
  final VoiceMedia Function() mediaFactory;
  final Duration heartbeat;
  VoiceMedia? _media;
  VoiceSignaling? _api;
  StreamSubscription<VoiceMediaStatus>? _subscription;
  StreamSubscription<void>? _disconnected;
  Future<void>? _leaving;
  Timer? _timer;
  String _id = '';
  int _generation = 0;
  bool _closed = false, _joining = false;
  int? _pollingGeneration;

  Future<void> join(VoiceSignaling api, String room, String title) async {
    if (_joining || _closed) {
      return;
    }
    _joining = true;
    try {
      await _join(api, room, title);
    } finally {
      _joining = false;
    }
  }

  Future<void> _join(VoiceSignaling api, String room, String title) async {
    final cleanup = leave();
    final generation = _generation;
    await cleanup;
    if (_closed || generation != _generation) {
      return;
    }
    final media = mediaFactory();
    _media = media;
    _api = api;
    _disconnected = api.disconnected.listen((_) {
      if (generation == _generation) {
        unawaited(leave());
      }
    });
    emit(VoiceState(phase: VoicePhase.joining, room: room, title: title));
    _subscription = media.changes.listen(
      (status) => _mediaChanged(status, generation),
    );
    try {
      final offer = await media.offer();
      if (generation != _generation) {
        return;
      }
      final reply = await api.join(room, offer);
      if (generation != _generation) {
        await _quietLeave(api, room, reply.sessionId);
        return;
      }
      if (reply.sessionId.isEmpty ||
          !reply.hasState() ||
          reply.state.capacity != 2) {
        throw StateError('Некорректный ответ голосового сервера');
      }
      _id = reply.sessionId;
      await media.answer(reply.answerSdp);
      if (generation != _generation) {
        return;
      }
      _publish(roster: reply.state);
      _timer = Timer.periodic(
        heartbeat,
        (_) => unawaited(_refresh(generation)),
      );
    } catch (error) {
      if (generation == _generation) {
        await _fail(error);
      }
    }
  }

  void _mediaChanged(VoiceMediaStatus status, int generation) {
    if (generation != _generation || _closed) {
      return;
    }
    if (status == VoiceMediaStatus.failed) {
      unawaited(_fail(StateError('Голосовое соединение прервано')));
      return;
    }
    if (status == VoiceMediaStatus.connected) {
      _publish(phase: VoicePhase.connected);
    }
  }

  void _publish({
    VoicePhase? phase,
    VoiceRoomState? roster,
    bool? muted,
    bool? deafened,
    bool? busy,
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
      ),
    );
  }

  Future<void> _refresh(int generation) async {
    if (_pollingGeneration == generation ||
        state.busy ||
        _id.isEmpty ||
        generation != _generation) {
      return;
    }
    _pollingGeneration = generation;
    try {
      final roster = await _api!.update(
        state.room,
        _id,
        state.muted,
        state.deafened,
      );
      if (generation == _generation) {
        await _applyRoster(roster, generation);
      }
    } catch (error) {
      if (generation == _generation) {
        await _fail(error);
      }
    } finally {
      if (_pollingGeneration == generation) {
        _pollingGeneration = null;
      }
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
    if (state.busy || state.phase != VoicePhase.connected || state.deafened) {
      return;
    }
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
      final roster = await api.update(room, id, muted, deafened);
      if (generation != _generation) {
        return;
      }
      if (!muted) {
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
      final roster = await api.update(room, id, true, deafened);
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
        await _fail(other);
      }
    }
  }

  Future<void> toggleDeafened() async {
    if (state.busy || state.phase != VoicePhase.connected) {
      return;
    }
    final generation = _generation;
    final api = _api!, media = _media!, room = state.room, id = _id;
    final deafened = !state.deafened;
    _publish(busy: true);
    try {
      await media.microphone(false);
      await media.deafen(deafened);
      final roster = await api.update(room, id, true, deafened);
      if (generation == _generation) {
        _publish(muted: true, deafened: deafened, busy: false, roster: roster);
      }
    } catch (error) {
      if (generation == _generation) {
        await _fail(error);
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

  Future<void> leave() {
    _generation++;
    return _leaving ??= _release().whenComplete(() => _leaving = null);
  }

  Future<void> _release() async {
    if (!_closed && state.active) {
      _publish(busy: true);
    }
    _timer?.cancel();
    _timer = null;
    final media = _media, api = _api, id = _id, room = state.room;
    _media = null;
    _api = null;
    _id = '';
    _cancel(_subscription);
    _subscription = null;
    _cancel(_disconnected);
    _disconnected = null;
    Object? failure;
    try {
      await media?.close();
    } catch (error) {
      failure = error;
    } finally {
      if (api != null) {
        await _quietLeave(api, room, id);
      }
    }
    if (!_closed) {
      emit(
        failure == null
            ? const VoiceState()
            : VoiceState(phase: VoicePhase.failed, error: failure.toString()),
      );
    }
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
    await super.close();
  }
}
