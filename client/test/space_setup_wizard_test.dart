import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/space_setup_wizard.dart';

void main() {
  for (final width in [390.0, 1024.0]) {
    testWidgets('Мастер сохраняет выбор и выдаёт приглашение: $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1024);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: [
            AdminLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SpaceSetupWizard(
              create: (title, icon, enabled) async {
                calls++;
                expect(title, 'Гавань');
                expect(icon['preset'], 'orbit');
                expect(enabled, false);
                return 'https://203.0.113.1:8443/#invite=test&tls=fingerprint';
              },
              manage: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Гавань');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Далее'));
      await tester.tap(find.text('Далее'));
      await tester.pumpAndSettle();
      final boxes = tester
          .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
          .toList();
      expect(boxes.skip(1).every((item) => item.onChanged == null), true);
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.ensureVisible(
        find.widgetWithText(FilledButton, 'Создать своё пространство'),
      );
      await tester.tap(
        find.widgetWithText(FilledButton, 'Создать своё пространство'),
      );
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(find.text('Пространство готово'), findsOneWidget);
      expect(
        find.text('https://203.0.113.1:8443/#invite=test&tls=fingerprint'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
