import 'dart:async';
import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/pairing_lifetime.dart';

void main() {
  final start = DateTime.utc(2026, 10, 27);
  test(
    'Отмена сразу очищает буфер, не ждёт сеть и выполняется один раз',
    () async {
      final seed = Uint8List.fromList(List.filled(32, 7));
      final release = Completer<void>();
      var calls = 0;
      final lifetime = PairingLifetime(
        seed,
        expiresAt: start.add(const Duration(minutes: 5)),
        now: () => start,
        release: () {
          calls++;
          return release.future;
        },
      );
      final ownedByCaller = lifetime.copySeed();
      final closed = lifetime.close();
      expect(identical(closed, lifetime.close()), isTrue);
      expect(lifetime.isClosed, isTrue);
      expect(seed, everyElement(0));
      expect(ownedByCaller, everyElement(7));
      expect(lifetime.copySeed, throwsStateError);
      expect(calls, 1);
      release.complete();
      await closed;
    },
  );

  test('Локальный срок истекает независимо от недоступного сервера', () {
    fakeAsync((async) {
      final seed = Uint8List.fromList(List.filled(32, 8));
      var releases = 0;
      final lifetime = PairingLifetime(
        seed,
        expiresAt: start.add(const Duration(seconds: 30)),
        now: async.getClock(start).now,
        release: () async {
          releases++;
          throw StateError('offline');
        },
      );
      async.elapse(const Duration(seconds: 29));
      expect(lifetime.isClosed, isFalse);
      async.elapse(const Duration(seconds: 1));
      async.flushMicrotasks();
      expect(lifetime.expired, isTrue);
      expect(seed, everyElement(0));
      expect(lifetime.copySeed, throwsStateError);
      expect(releases, 1);
    });
  });

  test('Даже далёкий срок сервера не продлевает локальные пять минут', () {
    fakeAsync((async) {
      final lifetime = PairingLifetime(
        Uint8List(32),
        expiresAt: start.add(const Duration(days: 1)),
        now: () => start,
        release: () async {},
      );
      async.elapse(const Duration(minutes: 5));
      async.flushMicrotasks();
      expect(lifetime.expired, isTrue);
    });
  });

  test(
    'Проверка срока защищает до запуска таймера после возобновления',
    () async {
      var now = start;
      final seed = Uint8List.fromList(List.filled(32, 4));
      final lifetime = PairingLifetime(
        seed,
        expiresAt: start.add(const Duration(minutes: 5)),
        now: () => now,
        release: () async {},
      );
      now = start.add(const Duration(minutes: 6));
      expect(lifetime.ensureActive, throwsStateError);
      expect(seed, everyElement(0));
      await lifetime.close();
    },
  );

  test('Поздний результат не получает ключ после отмены', () async {
    final lifetime = PairingLifetime(
      Uint8List(32),
      expiresAt: start.add(const Duration(minutes: 5)),
      now: () => start,
      release: () async {},
    );
    final gate = Completer<void>();
    Future<Uint8List> verify() async {
      await gate.future;
      return lifetime.copySeed();
    }

    final rejected = expectLater(verify(), throwsStateError);
    await lifetime.close();
    gate.complete();
    await rejected;
  });

  test('Закрытие допускает повторный вход из освобождения ресурса', () async {
    late PairingLifetime lifetime;
    var calls = 0;
    lifetime = PairingLifetime(
      Uint8List(32),
      expiresAt: start.add(const Duration(minutes: 5)),
      now: () => start,
      release: () {
        calls++;
        unawaited(lifetime.close());
        return Future.value();
      },
    );
    await lifetime.close();
    expect(calls, 1);
  });

  test('Неверный размер и уже истёкший срок не создают ресурс', () {
    expect(
      () => PairingLifetime(
        Uint8List(31),
        expiresAt: start,
        now: () => start,
        release: () async {},
      ),
      throwsArgumentError,
    );
    expect(
      () => PairingLifetime(
        Uint8List(32),
        expiresAt: start,
        now: () => start,
        release: () async {},
      ),
      throwsArgumentError,
    );
  });
}
