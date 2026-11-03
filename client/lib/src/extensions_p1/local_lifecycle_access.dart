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

  void _cancel(String? instance) {
    for (final call in _calls) {
      if (instance == null || call.instance == instance) call._cancelled = true;
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
