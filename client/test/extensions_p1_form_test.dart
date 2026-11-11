import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/actions.dart';
import 'package:space_client/src/extensions_p1/document.dart';
import 'package:space_client/src/extensions_p1/form_cubit.dart';
import 'package:space_client/ui/extensions_p1.dart';

Map<String, dynamic> source() =>
    jsonDecode(File('$fixtureRoot/ui-form.json').readAsStringSync())
        as Map<String, dynamic>;
const fixtureRoot = String.fromEnvironment(
  'P1_FIXTURES',
  defaultValue: 'test/fixtures/extensions_p1',
);
ExtensionDocument parse(Map<String, dynamic> value) =>
    ExtensionDocument.parse(utf8.encode(jsonEncode(value)), {'acknowledge'});
ExtensionDocument document() => parse(source());

void main() {
  test('Форма отклоняет неизвестные поля, команды и вложенные формы', () {
    for (final change in <void Function(Map<String, dynamic>)>[
      (d) => d['body'][0]['command'] = 'grant_admin',
      (d) => d['body'][0]['children'][0]['max_length'] = 513,
      (d) => d['body'][0]['children'][0]['required'] = 'true',
      (d) => d['body'][0]['children'][0]['script'] = 'run()',
      (d) => d['body'][0]['children'][0]['component'] = 'form.v1',
      (d) => d['body'][0]['children'][1]['options'][1]['value'] = 'a',
      (d) => d['body'][0]['children'][1]['options'][1]['label_key'] = 'missing',
      (d) => d['body'][0]['children'][2]['id'] = 'message',
      (d) => d['body'] = [d['body'][0]['children'][0]],
    ]) {
      final value = source();
      change(value);
      expect(() => parse(value), throwsFormatException);
    }
  });

  test('Недопустимые значения не вызывают команду, Unicode считается по кодовым точкам', () async {
    var calls = 0;
    final cubit = ExtensionFormCubit(document().body.single.children, (
      _,
    ) async {
      calls++;
      return true;
    });
    addTearDown(cubit.close);
    await cubit.submit();
    expect(cubit.state.errors, {'message', 'kind'});
    cubit.change('message', '😀' * 65);
    cubit.change('kind', 'forbidden');
    cubit.change('enabled', 'true');
    await cubit.submit();
    expect(cubit.state.errors, {'message', 'kind', 'enabled'});
    expect(calls, 0);
    cubit.change('message', '😀' * 64);
    cubit.change('kind', 'a');
    cubit.change('enabled', true);
    await cubit.submit();
    expect(calls, 1);
    expect(cubit.state.status, ExtensionFormStatus.succeeded);
  });

  test('Снимок отправки, повтор, отказ и закрытие Cubit', () async {
    final pending = Completer<bool>();
    var calls = 0;
    final cubit = ExtensionFormCubit(document().body.single.children, (values) {
      calls++;
      expect(() => values['message'] = 'changed', throwsUnsupportedError);
      return pending.future;
    });
    cubit.change('message', 'draft');
    cubit.change('kind', 'a');
    final running = cubit.submit();
    cubit.change('message', 'lost');
    await cubit.submit();
    expect(calls, 1);
    expect(cubit.state.values['message'], 'draft');
    pending.complete(false);
    await running;
    expect(cubit.state.status, ExtensionFormStatus.failed);
    expect(cubit.state.values['message'], 'draft');
    await cubit.close();
    await cubit.submit();
    expect(calls, 1);
  });

  test('Закрытие во время отправки не создаёт поздних событий', () async {
    final pending = Completer<bool>();
    final cubit = ExtensionFormCubit(
      document().body.single.children,
      (_) => pending.future,
    );
    cubit.change('message', 'draft');
    cubit.change('kind', 'a');
    final running = cubit.submit();
    await cubit.close();
    pending.complete(true);
    await running;
  });

  testWidgets('Ввод, выбор и переключатель передают проверенный снимок', (
    tester,
  ) async {
    Map<String, Object>? sent;
    final actions = ExtensionActions(
      {},
      forms: {
        'acknowledge': (value) async {
          sent = value;
        },
      },
    );
    addTearDown(actions.close);
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExtensionPanel(
              document: document(),
              actions: actions,
              locale: 'ru',
              originLabel: 'Расширение: форма',
              errorText: 'Повторите',
            ),
          ),
        ),
      );
      await tester.tap(find.text('Отправить'));
      await tester.pumpAndSettle();
      expect(sent, isNull);
      expect(find.text('Проверьте поля формы'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'Привет 😀');
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Первый').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отправить'));
      await tester.pumpAndSettle();
      expect(sent, {'message': 'Привет 😀', 'kind': 'a', 'enabled': true});
      expect(find.text('Отправлено'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('Узкий экран, крупный текст и английский fallback', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final actions = ExtensionActions({}, forms: {'acknowledge': (_) async {}});
    addTearDown(actions.close);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: ExtensionPanel(
              document: document(),
              actions: actions,
              locale: 'de',
              originLabel: 'Extension',
              errorText: 'Retry',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Send'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
