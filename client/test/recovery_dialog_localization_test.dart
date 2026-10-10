import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

void main() {
  testWidgets(
    'Смена языка сохраняет пароли и переводит ошибку без подтверждения',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final locale = ValueNotifier(const Locale('ru'));
      addTearDown(locale.dispose);
      String? result;
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, language, _) => MaterialApp(
            locale: language,
            supportedLocales: AdminLocalizations.supportedLocales,
            localizationsDelegates: AdminLocalizations.localizationsDelegates,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async => result = await askRecoveryPassword(
                    context,
                    creating: true,
                  ),
                  child: const Text('fixture'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('fixture'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'short');
      await tester.tap(find.text('Зашифровать'));
      await tester.pumpAndSettle();
      for (final language in ['zh', 'en', 'ru']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        final strings = lookupAdminLocalizations(Locale(language));
        expect(find.text(strings.recoveryPasswordInvalid), findsOneWidget);
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText).first)
              .controller
              .text,
          'short',
        );
        expect(result, isNull);
        expect(tester.takeException(), isNull);
      }
      const password = 'пароль-未翻译-secret';
      await tester.enterText(find.byType(TextField).first, password);
      await tester.enterText(find.byType(TextField).last, password);
      locale.value = const Locale('en');
      await tester.pumpAndSettle();
      for (final field in tester.widgetList<EditableText>(
        find.byType(EditableText),
      )) {
        expect(field.controller.text, password);
      }
      expect(result, isNull);
      await tester.tap(find.text('Encrypt'));
      await tester.pumpAndSettle();
      expect(result, password);
      await tester.tap(find.text('fixture'));
      await tester.pumpAndSettle();
      for (final field in tester.widgetList<EditableText>(
        find.byType(EditableText),
      )) {
        expect(field.controller.text, isEmpty);
      }
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(tester.takeException(), isNull);
    },
  );
}
