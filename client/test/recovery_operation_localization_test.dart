import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/l10n/strings.dart';

void main() {
  testWidgets(
    'Подтверждение восстановления меняет язык без изменения адреса и согласия',
    (tester) async {
      final locale = ValueNotifier(const Locale('ru'));
      addTearDown(locale.dispose);
      bool? confirmed;
      const origin = 'https://203.0.113.10:8443';
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, language, _) => MaterialApp(
            locale: language,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AdminLocalizations.delegate,
              ...AppLocalizations.localizationsDelegates,
            ],
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async =>
                      confirmed = await confirmRecoveryAction(
                        context,
                        '',
                        textBuilder: (context) =>
                            context.strings.recoveryRestoreConfirm(
                              origin,
                              context.strings.recoveryReplaceWarning,
                            ),
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
      for (final language in ['zh', 'en', 'ru']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        final strings = lookupAppLocalizations(Locale(language));
        expect(
          find.text(
            strings.recoveryRestoreConfirm(
              origin,
              strings.recoveryReplaceWarning,
            ),
          ),
          findsOneWidget,
        );
        expect(confirmed, isNull);
        expect(tester.takeException(), isNull);
      }
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(confirmed, false);
    },
  );

  test('Адрес, код и имя устройства в подтверждениях на трёх языках', () {
    for (final language in ['ru', 'zh', 'en']) {
      final strings = lookupAppLocalizations(Locale(language));
      expect(
        strings.pairingAcceptConfirm('ABCD-EFGH', 'https://203.0.113.10:8443'),
        allOf(contains('ABCD-EFGH'), contains('https://203.0.113.10:8443')),
      );
      expect(
        strings.pairingPrepareConfirm(
          '设备 Алексей',
          strings.pairingManageRequest,
        ),
        contains('设备 Алексей'),
      );
    }
  });
}
