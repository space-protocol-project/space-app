import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chat_controller.dart';
import 'core.dart';

class ServerWorkspaces extends ChangeNotifier {
  ServerWorkspaces({required this.vault, this.create, this.resume});
  final IdentityVault vault;
  final ChatController Function(String)? create;
  final Future<void> Function(String, ChatController)? resume;
  final Map<String, ChatController> _controllers = {};
  final Set<String> _loading = {};
  final Set<ChatController> _owned = {};
  bool _disposed = false;
  bool _refreshing = false, _refreshRequested = false;
  Map<String, ChatController> get controllers => Map.unmodifiable(_controllers);
  ChatController? operator [](String origin) => _controllers[origin];

  void synchronize(Iterable<String> origins) {
    if (_disposed) return;
    var changed = false;
    for (final origin in origins) {
      if (_controllers.containsKey(origin)) continue;
      final controller = create?.call(origin) ?? ChatController(vault);
      _controllers[origin] = controller;
      _owned.add(controller);
      controller.addListener(_changed);
      changed = true;
    }
    if (changed) {
      _changed();
      unawaited(refresh());
    }
  }

  void adopt(String origin, ChatController controller, {bool owned = true}) {
    if (_disposed || identical(_controllers[origin], controller)) return;
    final aliases = _controllers.entries
        .where((entry) => identical(entry.value, controller))
        .map((entry) => entry.key)
        .toList();
    for (final alias in aliases) {
      _controllers.remove(alias);
    }
    controller.removeListener(_changed);
    final old = _controllers.remove(origin);
    if (old != null) {
      old.removeListener(_changed);
      if (_owned.remove(old)) old.dispose();
    }
    _controllers[origin] = controller;
    if (owned) _owned.add(controller);
    controller.addListener(_changed);
    _changed();
  }

  Future<void> refresh() async {
    _refreshRequested = true;
    if (_refreshing || _disposed) return;
    _refreshing = true;
    try {
      do {
        _refreshRequested = false;
        final origins = _controllers.keys.toList();
        for (var start = 0; start < origins.length && !_disposed; start += 4) {
          await Future.wait(origins.skip(start).take(4).map(reconnect));
        }
      } while (_refreshRequested && !_disposed);
    } finally {
      _refreshing = false;
    }
  }

  Future<void> reconnect(String origin) async {
    final controller = _controllers[origin];
    if (_disposed ||
        controller == null ||
        controller.connected ||
        controller.accessRemoved ||
        controller.busy ||
        !_loading.add(origin)) {
      return;
    }
    try {
      await controller.restoreHistory(origin);
      if (resume != null) {
        await resume!(origin, controller);
        return;
      }
      // Только сохранённый профиль: фоновые проверки не создают аккаунты.
      final record = await vault
          .load(origin)
          .timeout(const Duration(seconds: 5));
      if (record == null || _disposed) return;
      await controller.inspect(origin, tlsFingerprint: record.tlsFingerprint);
      if (_disposed || !identical(_controllers[origin], controller)) return;
      if (controller.preview != null) {
        await controller.connect(restoredRecord: record);
      }
    } catch (_) {
      // Ошибка одного сервера не мешает получить каталоги других.
    } finally {
      _loading.remove(origin);
      _changed();
    }
  }

  void _changed() {
    if (!_disposed) notifyListeners();
  }

  void remove(String origin) {
    final controller = _controllers.remove(origin);
    if (controller == null) return;
    controller.removeListener(_changed);
    if (_owned.remove(controller)) controller.dispose();
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    for (final controller in _controllers.values.toSet()) {
      controller.removeListener(_changed);
      if (_owned.contains(controller)) controller.dispose();
    }
    _controllers.clear();
    _owned.clear();
    super.dispose();
  }
}
