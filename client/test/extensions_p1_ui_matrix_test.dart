import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/actions.dart';
import 'package:space_client/src/extensions_p1/document.dart';
import 'package:space_client/ui/extensions_p1.dart';

import 'extensions_p1_form_test.dart' as forms;

Widget panel(
  ExtensionActions actions, {
  ExtensionDocument? document,
  double scale = 1,
}) => MaterialApp(
  builder: (context, child) => Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: 320,
      height: 600,
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
    ),
  ),
  home: Scaffold(
    body: ExtensionPanel(
      document: document ?? forms.document(),
      actions: actions,
      locale: 'ru',
      originLabel: 'Расширение: форма',
      errorText: 'Повторите действие',
    ),
  ),
);

Future<void> key(WidgetTester tester, LogicalKeyboardKey value) async {
  await tester.sendKeyEvent(value);
  await tester.pumpAndSettle();
}

Future<void> fill(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), 'Черновик 😀');
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Первый').last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('E06: клавиатура проходит все поля и отправляет форму', (
    tester,
  ) async {
    Map<String, Object>? sent;
    final actions = ExtensionActions(
      {},
      forms: {'acknowledge': (values) async => sent = values},
    );
    addTearDown(actions.close);
    await tester.pumpWidget(panel(actions));
    await tester.enterText(find.byType(TextFormField), 'Клавиатура');
    await key(tester, LogicalKeyboardKey.tab);
    await key(tester, LogicalKeyboardKey.enter);
    await key(tester, LogicalKeyboardKey.arrowDown);
    await key(tester, LogicalKeyboardKey.enter);
    await key(tester, LogicalKeyboardKey.tab);
    await key(tester, LogicalKeyboardKey.space);
    await key(tester, LogicalKeyboardKey.tab);
    await key(tester, LogicalKeyboardKey.enter);
    expect(sent, isNotNull);
    expect(sent!['message'], 'Клавиатура');
    expect(sent!['enabled'], true);
    expect(find.text('Отправлено'), findsOneWidget);
  });

  testWidgets(
    'E06: ошибка доступна семантически, черновик и повтор сохранены',
    (tester) async {
      var attempts = 0;
      final actions = ExtensionActions(
        {},
        forms: {
          'acknowledge': (values) async {
            expect(values['message'], 'Черновик 😀');
            if (++attempts == 1) throw StateError('private failure');
          },
        },
      );
      addTearDown(actions.close);
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(panel(actions));
        await fill(tester);
        await tester.tap(find.text('Отправить'));
        await tester.pumpAndSettle();
        expect(find.text('Черновик 😀'), findsOneWidget);
        expect(find.textContaining('private failure'), findsNothing);
        final announcements = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.liveRegion == true,
        );
        expect(announcements, findsWidgets);
        expect(find.bySemanticsLabel('Повторите действие'), findsWidgets);
        await tester.tap(find.text('Отправить'));
        await tester.pumpAndSettle();
        expect(attempts, 2);
        expect(find.bySemanticsLabel('Отправлено'), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('E06: длинные варианты при 3x доступны в узкой форме', (
    tester,
  ) async {
    final source = forms.source();
    source['strings']['ru']['a'] = 'Длинное название варианта для выбора';
    final actions = ExtensionActions({}, forms: {'acknowledge': (_) async {}});
    addTearDown(actions.close);
    await tester.pumpWidget(
      panel(actions, document: forms.parse(source), scale: 3),
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Длинное название варианта для выбора').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Отправить'));
    await tester.tap(find.text('Отправить'));
    await tester.pumpAndSettle();
    expect(find.text('Проверьте поля формы'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
