import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/demo_session.dart';
import 'package:space_client/ui/extensions_p1_demo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final previousOverrides = HttpOverrides.current;
  setUpAll(() {
    HttpOverrides.global = null;
  });
  tearDownAll(() {
    HttpOverrides.global = previousOverrides;
  });
  testWidgets('Настоящий dispatcher и WASM обновляют элемент Обзора', (
    tester,
  ) async {
    final endpoint = Uri.parse(Platform.environment['P1_DEMO_URL']!);
    final session = ExtensionDemoSession(
      ExtensionDemoConnection(
        endpoint,
        Platform.environment['P1_DEMO_EDITOR']!,
      ),
    );
    addTearDown(session.close);
    await tester.runAsync(() async {
      final loaded = session.stream.firstWhere(
        (state) => state is! ExtensionDemoLoading,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ExtensionDemoView(session: session)),
        ),
      );
      await loaded.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(find.text('Готово к проверке'), findsOneWidget);
    await tester.runAsync(() async {
      final changed = session.stream.first;
      await tester.tap(find.text('Выполнить команду'));
      await changed.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(find.text('Команда выполнена'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, skip: !Platform.environment.containsKey('P1_DEMO_URL'));

  testWidgets('Отказ команды не выдаёт детали и позволяет повторить query', (
    tester,
  ) async {
    final session = ExtensionDemoSession(
      ExtensionDemoConnection(
        Uri.parse(Platform.environment['P1_DEMO_URL']!),
        Platform.environment['P1_DEMO_READER']!,
      ),
    );
    addTearDown(session.close);
    await tester.runAsync(() async {
      final loaded = session.stream.firstWhere(
        (state) => state is! ExtensionDemoLoading,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ExtensionDemoView(session: session)),
        ),
      );
      await loaded.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(find.text('Готово к проверке'), findsOneWidget);
    await tester.runAsync(() async {
      final changed = session.stream.first;
      await tester.tap(find.text('Выполнить команду'));
      await changed.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(find.text('Расширение недоступно'), findsOneWidget);
    await tester.runAsync(() async {
      final changed = session.stream.first;
      await tester.tap(find.text('Повторить'));
      await changed.timeout(const Duration(seconds: 10));
    });
    await tester.pumpAndSettle();
    expect(find.text('Готово к проверке'), findsOneWidget);
  }, skip: !Platform.environment.containsKey('P1_DEMO_URL'));
}
