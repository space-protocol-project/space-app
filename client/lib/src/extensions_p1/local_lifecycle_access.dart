part of 'local_lifecycle_host.dart';

final class LocalReadLease {
  LocalReadLease._(
    this._host,
    this._session,
    this.instance,
    this.root,
    this._generation,
  );
  final LocalLifecycleHost _host;
  final LocalExtensionSession _session;
  final String instance;
  final String root;
  final String _generation;
  bool _cancelled = false;
  bool _closed = false;
  void Function()? onCancel;
  bool get isCancelled => _cancelled || _closed;

  T deliver<T>(T value) {
    if (isCancelled) throw StateError('PermissionDenied');
    final entry = _host._readable(_session, instance, root);
    if (lifecycleOf(entry)['generation'] != _generation) {
      throw StateError('StaleBinding');
    }
    return value;
  }

  void close() {
    onCancel = null;
    _closed = true;
    _host._calls.remove(this);
  }
}

extension LocalLifecycleAccess on LocalLifecycleHost {
  LocalReadLease beginRead(
    LocalExtensionSession session,
    String instance,
    String root,
  ) {
    final entry = _readable(session, instance, root);
    final lease = LocalReadLease._(
      this,
      session,
      instance,
      root,
      lifecycleOf(entry)['generation']! as String,
    );
    _calls.add(lease);
    return lease;
  }

  Map<String, Object?> _readable(
    LocalExtensionSession session,
    String instance,
    String root,
  ) {
    final entry = snapshot(session).entries[instance];
    if (entry == null || entry['state'] != 'enabled') {
      throw StateError('PermissionDenied');
    }
    final record = lifecycleOf(entry);
    final grant = registryObject(record['grants'])[root];
    if (grant == null ||
        registryObject(grant)['active'] != true ||
        !(record['requested']! as List).contains('device.catalog.read')) {
      throw StateError('PermissionDenied');
    }
    return entry;
  }

  Future<void> listCatalog(
    LocalExtensionSession session,
    String instance,
    String root,
    void Function(CatalogPage) deliver, {
    int limit = 128,
    String? cursor,
  }) => _catalogCall(
    session,
    instance,
    root,
    (source) => source.list(limit, cursor),
    deliver,
  );

  Future<void> readCatalog(
    LocalExtensionSession session,
    String instance,
    String root,
    String handle,
    void Function(CatalogChunk) deliver, {
    required int offset,
    required int limit,
  }) => _catalogCall(
    session,
    instance,
    root,
    (source) => source.read(handle, offset, limit),
    deliver,
  );

  Future<void> _catalogCall<T>(
    LocalExtensionSession session,
    String instance,
    String root,
    Future<T> Function(LocalCatalogRoot) operation,
    void Function(T) deliver,
  ) async {
    final lease = beginRead(session, instance, root);
    try {
      final binding = _roots[root];
      if (binding == null || binding.instance != instance) {
        throw StateError('StaleBinding');
      }
      late T value;
      try {
        value = await operation(binding.root);
      } catch (_) {
        if (lease.isCancelled) throw StateError('PermissionDenied');
        rethrow;
      }
      deliver(lease.deliver(value));
    } finally {
      lease.close();
    }
  }

  void _cancel(String? instance) {
    _cancelPendingSelections(instance);
    for (final item in _roots.entries.toList()) {
      if (instance == null || item.value.instance == instance) {
        _roots.remove(item.key);
        item.value.root.close();
      }
    }
    for (final call in _calls) {
      if (instance == null || call.instance == instance) {
        call._cancelled = true;
        call.onCancel?.call();
      }
    }
  }

  void _cancelPendingSelections(String? instance) {
    for (final item in _pendingRoots.entries.toList()) {
      if (instance != null && item.value != instance) continue;
      _pendingRoots.remove(item.key);
      item.key.close();
    }
  }

  void _requireIdle(LocalLifecycleCommand command) {
    if ([
      LocalLifecycleAction.disable,
      LocalLifecycleAction.quarantine,
      LocalLifecycleAction.revoke,
    ].contains(command.action)) {
      return;
    }
    if (_calls.any((call) => call.instance == command.instance)) {
      throw StateError('Busy');
    }
  }
}
