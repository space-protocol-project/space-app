import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'local_session_cubit.dart';
import 'local_sessions.dart';
import 'local_lifecycle_host.dart';

class SpaceCatalogRuntime extends Cubit<int> {
  SpaceCatalogRuntime() : super(0);
  Future<void> Function(LocalExtensionSession)? prepare;
  Future<void> ensure(LocalExtensionSession session) async =>
      await prepare?.call(session);
  void changed() {
    if (!isClosed) emit(state + 1);
  }

  final _hosts = <String, LocalLifecycleHost>{};
  void attach(LocalExtensionSession session, LocalLifecycleHost host) {
    host.snapshot(session);
    _hosts['${session.device}/${session.profile}'] = host;
    changed();
  }

  void detach(LocalLifecycleHost host) {
    _hosts.removeWhere((_, h) => identical(h, host));
    changed();
  }

  LocalLifecycleHost? forSession(LocalExtensionSession session) =>
      _hosts['${session.device}/${session.profile}'];
}

sealed class CatalogScreenState {
  const CatalogScreenState();
}

class CatalogLocked extends CatalogScreenState {
  const CatalogLocked();
}

class CatalogTargets extends CatalogScreenState {
  const CatalogTargets(this.instances);
  final List<String> instances;
}

class CatalogWorking extends CatalogScreenState {
  const CatalogWorking();
}

class CatalogReauthenticate extends CatalogScreenState {
  const CatalogReauthenticate();
}

class CatalogReview extends CatalogScreenState {
  const CatalogReview(this.instance, this.package, this.path);
  final String instance, package, path;
}

class CatalogGranted extends CatalogScreenState {
  const CatalogGranted(this.instance, this.root);
  final String instance, root;
}

class CatalogFailed extends CatalogScreenState {
  const CatalogFailed();
}

class CatalogGrantCubit extends Cubit<CatalogScreenState> {
  CatalogGrantCubit(this.access, this.runtime) : super(const CatalogLocked()) {
    access.sessions.addListener(_locked);
    _runtimeChanges = runtime.stream.listen((_) {
      if (state is CatalogTargets) refresh();
    });
    if (runtime.prepare == null) {
      refresh();
    } else {
      unawaited(_load());
    }
  }
  final LocalSessionCubit access;
  final SpaceCatalogRuntime runtime;
  late final StreamSubscription<int> _runtimeChanges;
  CatalogGrantIntent? _intent;
  Timer? _expiry;
  int _epoch = 0;
  bool _ownLock = false;
  Future<void> _load() async {
    if (access.state != LocalSessionStatus.unlocked) {
      refresh();
      return;
    }
    final epoch = _epoch;
    emit(const CatalogWorking());
    try {
      await runtime.ensure(access.session);
      if (_current(epoch)) refresh();
    } catch (_) {
      if (_current(epoch)) emit(const CatalogFailed());
    }
  }

  void refresh() {
    if (access.state != LocalSessionStatus.unlocked) {
      emit(const CatalogLocked());
      return;
    }
    try {
      final session = access.session;
      emit(
        CatalogTargets(
          runtime.forSession(session)?.catalogInstances(session) ?? const [],
        ),
      );
    } catch (_) {
      emit(const CatalogFailed());
    }
  }

  Future<void> unlock() async {
    if (state is! CatalogLocked && state is! CatalogReauthenticate) return;
    final epoch = _epoch;
    final intent = _intent;
    emit(const CatalogWorking());
    try {
      if (!await access.unlock()) throw StateError('PermissionDenied');
      if (!_current(epoch)) return;
      await runtime.ensure(access.session);
      if (!_current(epoch)) return;
      if (intent == null) {
        refresh();
        return;
      }
      _checkHost(intent);
      intent.check(access.session);
      emit(CatalogReview(intent.instance, intent.package, intent.path!));
    } catch (_) {
      _failed(epoch);
    }
  }

  Future<void> choose(String instance) async {
    if (state is! CatalogTargets) return;
    final epoch = ++_epoch;
    try {
      final session = access.session;
      final intent = runtime
          .forSession(session)!
          .startCatalogChoice(session, instance);
      _intent = intent;
      emit(const CatalogWorking());
      _ownLock = true;
      try {
        access.lock();
      } finally {
        _ownLock = false;
      }
      await intent.pick();
      if (!_current(epoch)) return;
      _expiry = Timer(const Duration(minutes: 2), cancel);
      emit(const CatalogReauthenticate());
    } catch (_) {
      _failed(epoch);
    }
  }

  Future<void> approve() async {
    if (state is! CatalogReview) return;
    final epoch = _epoch;
    final intent = _intent!;
    emit(const CatalogWorking());
    try {
      _checkHost(intent);
      final id = await intent.approve(access.session, () => _checkHost(intent));
      if (!_current(epoch)) return;
      _discard();
      emit(CatalogGranted(intent.instance, id));
    } catch (_) {
      _failed(epoch);
    }
  }

  void _checkHost(CatalogGrantIntent intent) {
    if (!identical(runtime.forSession(access.session), intent.host)) {
      throw StateError('StaleBinding');
    }
  }

  bool _current(int epoch) => !isClosed && epoch == _epoch;
  void _failed(int epoch) {
    if (!_current(epoch)) return;
    _discard();
    emit(const CatalogFailed());
  }

  void _locked() {
    if (_ownLock) return;
    _discard();
    emit(const CatalogLocked());
  }

  void _discard() {
    _epoch++;
    _expiry?.cancel();
    _intent?.close();
    _intent = null;
  }

  void cancel() {
    _discard();
    unawaited(_load());
  }

  @override
  Future<void> close() async {
    access.sessions.removeListener(_locked);
    _discard();
    await _runtimeChanges.cancel();
    await super.close();
  }
}
