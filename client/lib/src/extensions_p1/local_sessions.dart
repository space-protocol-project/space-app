import 'registry_validation.dart';

// Объект выдаёт только доверенный локальный интерфейс после разблокировки.
// Он не сериализуется в команду гостя и не связан с серверной SpaceSession.
final class LocalExtensionSession {
  LocalExtensionSession._(this.device, this.profile, this.actor);
  final String device;
  final String profile;
  final String actor;
}

class LocalExtensionSessions {
  LocalExtensionSession? _current;
  final _listeners = <void Function()>{};

  LocalExtensionSession unlock(String device, String profile, String actor) {
    for (final value in [device, profile, actor]) {
      validateRegistryName(value);
    }
    lock();
    return _current = LocalExtensionSession._(device, profile, actor);
  }

  void require(LocalExtensionSession session, String scope) {
    if (!identical(_current, session) ||
        '${session.device}/${session.profile}' != scope) {
      throw StateError('PermissionDenied');
    }
  }

  void lock() {
    _current = null;
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }

  void addListener(void Function() listener) => _listeners.add(listener);
  void removeListener(void Function() listener) => _listeners.remove(listener);
}
