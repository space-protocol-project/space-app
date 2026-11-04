import 'package:flutter_bloc/flutter_bloc.dart';

import 'local_sessions.dart';

typedef LocalProfileIdentity = ({String device, String profile, String actor});
typedef LocalProfileAuthenticator = Future<LocalProfileIdentity?> Function();

enum LocalSessionStatus { locked, authenticating, unlocked, unavailable }

class LocalSessionCubit extends Cubit<LocalSessionStatus> {
  LocalSessionCubit({LocalProfileAuthenticator? authenticate})
    : _authenticate = authenticate,
      super(
        authenticate == null
            ? LocalSessionStatus.unavailable
            : LocalSessionStatus.locked,
      );

  final LocalProfileAuthenticator? _authenticate;
  final sessions = LocalExtensionSessions();
  LocalExtensionSession? _session;
  Future<bool>? _pending;
  bool _foreground = false;
  bool _stopping = false;
  int _epoch = 0;

  LocalExtensionSession get session {
    final current = _session;
    if (isClosed || state != LocalSessionStatus.unlocked || current == null) {
      throw StateError('PermissionDenied');
    }
    sessions.require(current, '${current.device}/${current.profile}');
    return current;
  }

  Future<bool> unlock() {
    if (isClosed || !_foreground || _stopping || _authenticate == null) {
      return Future.value(false);
    }
    return _pending ??= _unlock().whenComplete(() => _pending = null);
  }

  Future<bool> _unlock() async {
    lock();
    final epoch = _epoch;
    emit(LocalSessionStatus.authenticating);
    try {
      final identity = await _authenticate!();
      if (!_current(epoch) || identity == null) return false;
      _session = sessions.unlock(
        identity.device,
        identity.profile,
        identity.actor,
      );
      emit(LocalSessionStatus.unlocked);
      return true;
    } catch (_) {
      return false;
    } finally {
      if (_current(epoch) && state != LocalSessionStatus.unlocked) lock();
    }
  }

  bool _current(int epoch) =>
      !isClosed && !_stopping && _foreground && _epoch == epoch;

  void setForeground(bool value) {
    _foreground = value;
    if (!value) lock();
  }

  void lock() {
    _epoch++;
    _session = null;
    sessions.lock();
    if (!isClosed) {
      emit(
        _authenticate == null
            ? LocalSessionStatus.unavailable
            : LocalSessionStatus.locked,
      );
    }
  }

  void stop() {
    _stopping = true;
    lock();
  }

  @override
  Future<void> close() {
    stop();
    return super.close();
  }
}
