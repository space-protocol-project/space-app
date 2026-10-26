import 'dart:async';
import 'dart:typed_data';

/// Владеет только временным буфером; выданные копии принадлежат получателю.
class PairingLifetime {
  PairingLifetime(
    this._seed, {
    required this.expiresAt,
    required this._release,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    final remaining = expiresAt.difference(_now());
    if (_seed.length != 32 || remaining <= Duration.zero) {
      _seed.fillRange(0, _seed.length, 0);
      throw ArgumentError('Неверный срок или временный ключ сопряжения');
    }
    const maximum = Duration(minutes: 5);
    _timer = Timer(remaining > maximum ? maximum : remaining, _expire);
  }

  final Uint8List _seed;
  final DateTime expiresAt;
  final DateTime Function() _now;
  final Future<void> Function() _release;
  late final Timer _timer;
  Future<void>? _closing;
  bool _expired = false;
  bool get isClosed => _closing != null;
  bool get expired => _expired;

  void ensureActive() {
    if (!isClosed && !_now().isBefore(expiresAt)) _expire();
    if (isClosed) throw StateError('Запрос сопряжения закрыт');
  }

  Uint8List copySeed() {
    ensureActive();
    return Uint8List.fromList(_seed);
  }

  void _expire() {
    _expired = true;
    unawaited(close());
  }

  Future<void> close() {
    final previous = _closing;
    if (previous != null) return previous;
    final done = Completer<void>();
    _closing = done.future;
    _timer.cancel();
    _seed.fillRange(0, _seed.length, 0);
    Future<void>.sync(_release).then(
      (_) => done.complete(),
      onError: (Object error, StackTrace stack) => done.complete(),
    );
    return done.future;
  }
}
