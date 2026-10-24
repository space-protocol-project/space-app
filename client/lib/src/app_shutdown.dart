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

  Future<bool> request() {
    if (state == AppShutdownState.stopped) return Future.value(true);
    return _pending ??= _run();
  }

  Future<bool> _run() async {
    emit(AppShutdownState.stopping);
    final operation = Future<void>.sync(() => prepare?.call());
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
