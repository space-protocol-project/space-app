import 'dart:async';
import 'dart:ui' show AppExitResponse;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/app_shutdown.dart';

void main() {
  testWidgets(
    'Запрос выхода ОС проходит через общий контроллер и может быть отменён',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final shutdown = AppShutdown();
      await tester.pumpWidget(SpaceApp(shutdown: shutdown));
      await tester.pumpAndSettle();
      expect(shutdown.prepare, isNotNull);
      final prepare = shutdown.prepare;
      final release = Completer<void>();
      shutdown.prepare = () => release.future;
      final response = tester.binding.handleRequestAppExit();
      await tester.pump();
      await tester.pump();
      expect(shutdown.state, AppShutdownState.stopping);
      expect(
        find.text('Завершение операций и остановка домашнего сервера…'),
        findsOneWidget,
      );
      release.completeError(StateError('still running'));
      await tester.pumpAndSettle();
      expect(await response, AppExitResponse.cancel);
      expect(shutdown.state, AppShutdownState.failed);
      expect(
        find.text('Завершение операций и остановка домашнего сервера…'),
        findsNothing,
      );
      shutdown.prepare = prepare;
      final retry = tester.binding.handleRequestAppExit();
      await tester.pump();
      await tester.pump();
      expect(await retry, AppExitResponse.exit);
      await tester.pumpWidget(const SizedBox.shrink());
      await shutdown.close();
    },
  );

  test(
    'Окно и ОС ожидают одну остановку, успешный выход идемпотентен',
    () async {
      final shutdown = AppShutdown();
      addTearDown(shutdown.close);
      final release = Completer<void>();
      var calls = 0;
      shutdown.prepare = () {
        calls++;
        return release.future;
      };
      final first = shutdown.request();
      final second = shutdown.request();
      expect(identical(first, second), true);
      expect(shutdown.state, AppShutdownState.stopping);
      expect(calls, 1);
      release.complete();
      expect(await first, true);
      expect(await shutdown.request(), true);
      expect(calls, 1);
      expect(shutdown.state, AppShutdownState.stopped);
    },
  );

  test(
    'Ошибка сохраняет приложение открытым и разрешает повторить выход',
    () async {
      final shutdown = AppShutdown();
      addTearDown(shutdown.close);
      shutdown.prepare = () async => throw StateError('database still running');
      expect(await shutdown.request(), false);
      expect(shutdown.state, AppShutdownState.failed);
      shutdown.prepare = () async {};
      await Future<void>.delayed(Duration.zero);
      expect(await shutdown.request(), true);
    },
  );

  test('Таймаут не запускает параллельную очистку; позднее завершение не закрывает окно', () async {
    final shutdown = AppShutdown(timeout: const Duration(milliseconds: 10));
    addTearDown(shutdown.close);
    final release = Completer<void>();
    var calls = 0;
    shutdown.prepare = () {
      calls++;
      return release.future;
    };
    expect(await shutdown.request(), false);
    expect(await shutdown.request(), false);
    expect(calls, 1);
    release.complete();
    await Future<void>.delayed(Duration.zero);
    expect(shutdown.state, AppShutdownState.failed);
    expect(await shutdown.request(), true);
    expect(calls, 2);
  });
}
