import 'dart:async';

import 'chat_controller.dart';
import 'core.dart';
import 'event_controller.dart';

part 'workspace_events.dart';
part 'workspace_state.dart';

class ServerWorkspaces
    extends EventController<WorkspaceEvent<dynamic>, WorkspaceState> {
  ServerWorkspaces({required this.vault, this.create, this.resume})
    : super(const WorkspaceState()) {
    on<WorkspaceStatePublished>(
      (event, emit) => event.runAndComplete(() => emit(event.state)),
    );
    on<WorkspacesSynchronized>(
      (event, _) => handleRequest(event, () => _synchronize(event.origins)),
    );
    on<WorkspaceAdopted>(
      (event, _) => handleRequest(
        event,
        () => _adopt(event.origin, event.controller, owned: event.owned),
      ),
    );
    on<WorkspacesRefreshed>((event, _) => handleRequest(event, _refresh));
    on<WorkspaceReconnected>(
      (event, _) => handleRequest(event, () => _reconnect(event.origin)),
    );
    on<WorkspaceRemoved>(
      (event, _) => handleRequest(event, () => _remove(event.origin)),
    );
  }
  Future<void> synchronize(Iterable<String> origins) =>
      sendRequest(WorkspacesSynchronized(origins));
  Future<void> adopt(
    String origin,
    ChatController controller, {
    bool owned = true,
  }) => sendRequest(WorkspaceAdopted(origin, controller, owned: owned));
  Future<void> refresh() => sendRequest(WorkspacesRefreshed());
  Future<void> reconnect(String origin) =>
      sendRequest(WorkspaceReconnected(origin));
  Future<void> remove(String origin) => sendRequest(WorkspaceRemoved(origin));

  final Map<ChatController, StreamSubscription<ChatState>> _subscriptions = {};
  void _listen(ChatController controller) {
    _unlisten(controller);
    _subscriptions[controller] = controller.stream.listen((_) => _changed());
  }

  void _unlisten(ChatController controller) {
    unawaited(_subscriptions.remove(controller)?.cancel());
  }

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

  void _synchronize(Iterable<String> origins) {
    if (_disposed) return;
    var changed = false;
    for (final origin in origins) {
      if (_controllers.containsKey(origin)) continue;
      final controller = create?.call(origin) ?? ChatController(vault);
      _controllers[origin] = controller;
      _owned.add(controller);
      _listen(controller);
      changed = true;
    }
    if (changed) {
      _changed();
      unawaited(_refresh());
    }
  }

  void _adopt(String origin, ChatController controller, {bool owned = true}) {
    if (_disposed || identical(_controllers[origin], controller)) return;
    final aliases = _controllers.entries
        .where((entry) => identical(entry.value, controller))
        .map((entry) => entry.key)
        .toList();
    for (final alias in aliases) {
      _controllers.remove(alias);
    }
    _unlisten(controller);
    final old = _controllers.remove(origin);
    if (old != null) {
      _unlisten(old);
      if (_owned.remove(old)) old.dispose();
    }
    _controllers[origin] = controller;
    if (owned) _owned.add(controller);
    _listen(controller);
    _changed();
  }

  Future<void> _refresh() async {
    _refreshRequested = true;
    if (_refreshing || _disposed) return;
    _refreshing = true;
    try {
      do {
        _refreshRequested = false;
        final origins = _controllers.keys.toList();
        for (var start = 0; start < origins.length && !_disposed; start += 4) {
          await Future.wait(origins.skip(start).take(4).map(_reconnect));
        }
      } while (_refreshRequested && !_disposed);
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _reconnect(String origin) async {
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
    if (!_disposed) publishState();
  }

  void publishState() {
    if (!_disposed && !isClosed) {
      publishStateEvent(
        WorkspaceStatePublished(
          WorkspaceState(
            chats: Map.unmodifiable(
              _controllers.map(
                (origin, controller) => MapEntry(origin, controller.state),
              ),
            ),
            loading: Set.unmodifiable(_loading),
          ),
        ),
      );
    }
  }

  void _remove(String origin) {
    final controller = _controllers.remove(origin);
    if (controller == null) return;
    _unlisten(controller);
    if (_owned.remove(controller)) controller.dispose();
    _changed();
  }

  @override
  Future<void> close() async {
    _disposed = true;
    for (final controller in _controllers.values.toSet()) {
      _unlisten(controller);
      if (_owned.contains(controller)) controller.dispose();
    }
    _controllers.clear();
    _owned.clear();
    await super.close();
  }
}
