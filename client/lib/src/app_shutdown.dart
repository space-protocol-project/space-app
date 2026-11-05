import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

enum AppShutdownState { ready, stopping, stopped, failed }

/// Объединяет запросы окна и ОС; таймаут не считается успешной остановкой.
class AppShutdown extends Cubit<AppShutdownState> {
  AppShutdown({this.timeout = const Duration(seconds: 100)})
    : super(AppShutdownState.ready);

  final Duration timeout;
  Future<void> Function()? prepare;
  Future<bool>? _pending;
  final _stopBarriers = <void Function()>{};
  final _drainBarriers = <Future<void> Function()>{};
  void addDrainBarrier(Future<void> Function() barrier) =>
      _drainBarriers.add(barrier);
  void removeDrainBarrier(Future<void> Function() barrier) =>
      _drainBarriers.remove(barrier);

  void addStopBarrier(void Function() barrier) => _stopBarriers.add(barrier);
  void removeStopBarrier(void Function() barrier) =>
      _stopBarriers.remove(barrier);

  Future<bool> request() {
    if (state == AppShutdownState.stopped) return Future.value(true);
    return _pending ??= _run();
  }

  Future<bool> _run() async {
    emit(AppShutdownState.stopping);
    final operation = Future<void>.sync(() async {
      for (final barrier in List.of(_stopBarriers)) {
        barrier();
      }
      if (_drainBarriers.isNotEmpty) {
        await Future.wait(List.of(_drainBarriers).map((drain) => drain()));
      }
      return prepare?.call();
    });
    // timeout не отменяет Future. Не запускаем вторую очистку поверх первой.
    unawaited(
      operation
          .then<void>((_) {}, onError: (Object _) {})
          .whenComplete(() => scheduleMicrotask(() => _pending = null)),
    );
    try {
      await operation.timeout(timeout);
      emit(AppShutdownState.stopped);
      return true;
    } catch (_) {
      emit(AppShutdownState.failed);
      return false;
    }
  }
}
