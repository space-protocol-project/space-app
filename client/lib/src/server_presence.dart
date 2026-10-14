import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'core.dart';
import 'event_controller.dart';

part 'presence_events.dart';
part 'presence_state.dart';

typedef PresenceProbe = Future<bool?> Function(String origin);

class ServerPresenceChange {
  const ServerPresenceChange(this.origin, this.online);
  final String origin;
  final bool online;
}

/// Проверка не выполняет вход и не принимает новые ключи сервера.
Future<bool?> probeSavedServer(String origin, IdentityVault vault) async {
  DeviceRecord? record;
  try {
    record = await vault.load(origin).timeout(const Duration(seconds: 5));
  } catch (_) {
    return null;
  }
  if (record == null) return null;
  try {
    final server = await discover(
      origin,
      tlsFingerprint: record.tlsFingerprint,
    );
    checkTrust(server, record);
    return true;
  } on SocketException {
    return false;
  } on TimeoutException {
    return false;
  } on HandshakeException {
    return false;
  } catch (_) {
    // Повреждённый профиль, ошибка хранилища или смена identity — не онлайн.
    return null;
  }
}

class ServerPresence
    extends EventController<PresenceEvent<dynamic>, PresenceState> {
  ServerPresence({
    required this.probe,
    this.interval = const Duration(seconds: 20),
  }) : super(const PresenceState()) {
    on<PresenceProbeCompleted>(
      (event, _) => handleRequest(
        event,
        () => _recordProbe(event.origin, event.generation, event.online),
      ),
    );
    on<PresenceStatePublished>(
      (event, emit) => event.runAndComplete(() => emit(event.state)),
    );
    on<PresenceWatched>(
      (event, _) => handleRequest(event, () => _watch(event.origins)),
    );
    on<PresenceChecked>((event, _) => handleRequest(event, _check));
  }
  Future<void> watch(Iterable<String> origins) =>
      sendRequest(PresenceWatched(origins));
  Future<void> check() => sendRequest(PresenceChecked());

  final PresenceProbe probe;
  final Duration interval;
  Stream<ServerPresenceChange> get changes => stream
      .where((state) => state.change != null)
      .map((state) => state.change!);
  final Map<String, bool> _states = {};
  final Map<String, int> _failures = {};
  Set<String> _origins = {};
  Timer? _timer;
  bool _checking = false, _disposed = false;
  int _generation = 0;
  bool? online(String origin) => _states[origin];

  void _watch(Iterable<String> origins) {
    if (_disposed) return;
    final next = origins.toSet();
    if (setEquals(next, _origins)) return;
    _generation++;
    _origins = next;
    _states.removeWhere((origin, _) => !next.contains(origin));
    _failures.removeWhere((origin, _) => !next.contains(origin));
    _timer?.cancel();
    if (next.isNotEmpty) {
      _timer = Timer.periodic(interval, (_) => unawaited(check()));
      unawaited(check());
    }
    publishState();
  }

  Future<void> _check() async {
    if (_checking || _disposed || _origins.isEmpty) return;
    _checking = true;
    final generation = _generation;
    try {
      final origins = _origins.toList();
      for (var start = 0; start < origins.length; start += 4) {
        await Future.wait(
          origins
              .skip(start)
              .take(4)
              .map((origin) => _probe(origin, generation)),
        );
        if (_disposed || generation != _generation) break;
      }
      if (!_disposed) publishState();
    } finally {
      _checking = false;
    }
  }

  Future<void> _probe(String origin, int generation) async {
    bool? result;
    try {
      result = await probe(origin).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      result = false;
    } catch (_) {
      result = null;
    }
    if (!_disposed && !isClosed) {
      await sendRequest(PresenceProbeCompleted(origin, generation, result));
    }
  }

  void _recordProbe(String origin, int generation, bool? result) {
    if (_disposed || generation != _generation) return;
    if (result == null) {
      _states.remove(origin);
      _failures.remove(origin);
      return;
    }
    if (!result) {
      final count = (_failures[origin] ?? 0) + 1;
      _failures[origin] = count;
      if (count < 2) return;
    } else {
      _failures[origin] = 0;
    }
    final previous = _states[origin];
    _states[origin] = result;
    if (previous != null && previous != result) {
      publishState(change: ServerPresenceChange(origin, result));
    }
  }

  void publishState({ServerPresenceChange? change}) {
    if (!_disposed && !isClosed) {
      publishStateEvent(
        PresenceStatePublished(
          PresenceState(online: Map.unmodifiable(_states), change: change),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _disposed = true;
    _generation++;
    _timer?.cancel();
    await super.close();
  }
}
