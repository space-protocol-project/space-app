import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'core.dart';

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

class ServerPresence extends ChangeNotifier {
  ServerPresence({
    required this.probe,
    this.interval = const Duration(seconds: 20),
  });
  final PresenceProbe probe;
  final Duration interval;
  final _changes = StreamController<ServerPresenceChange>.broadcast();
  Stream<ServerPresenceChange> get changes => _changes.stream;
  final Map<String, bool> _states = {};
  final Map<String, int> _failures = {};
  Set<String> _origins = {};
  Timer? _timer;
  bool _checking = false, _disposed = false;
  int _generation = 0;
  bool? online(String origin) => _states[origin];

  void watch(Iterable<String> origins) {
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
    notifyListeners();
  }

  Future<void> check() async {
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
      if (!_disposed) notifyListeners();
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
      _changes.add(ServerPresenceChange(origin, result));
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _timer?.cancel();
    unawaited(_changes.close());
    super.dispose();
  }
}
