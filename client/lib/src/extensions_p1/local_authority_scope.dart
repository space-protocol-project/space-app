import 'local_lifecycle_types.dart';

// Проверяем контекст с обеих сторон каждого ожидания: поздний ответ
// не должен даже открывать следующий диалог в уже заблокированном профиле.
class ScopedLocalAuthority implements LocalExtensionAuthority {
  ScopedLocalAuthority(this._delegate, this._guard, {this.select});
  final Future<String> Function(String, String)? select;
  final LocalExtensionAuthority _delegate;
  final void Function() _guard;

  Future<T> _run<T>(Future<T> Function() operation) async {
    _guard();
    final result = await operation();
    _guard();
    return result;
  }

  @override
  Future<LocalVerifiedPackage> verifyPackage(String digest) =>
      _run(() => _delegate.verifyPackage(digest));
  @override
  Future<void> verifyCheckpoint(String digest, String data) =>
      _run(() => _delegate.verifyCheckpoint(digest, data));
  @override
  Future<String> migrate(Map<String, Object?> plan, int step, String data) =>
      _run(() => _delegate.migrate(plan, step, data));
  @override
  Future<bool> confirm(
    String action,
    String instance,
    String package, {
    String? root,
  }) => _run(() => _delegate.confirm(action, instance, package, root: root));
  @override
  Future<String> selectDirectory(String instance, String package) =>
      _run(() => (select ?? _delegate.selectDirectory)(instance, package));
  @override
  Future<LocalRestoreSnapshot> restore(String checkpoint) =>
      _run(() => _delegate.restore(checkpoint));
}
