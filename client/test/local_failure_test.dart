import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/local_failure.dart';
import 'package:space_client/src/recovery_card.dart';
import 'package:space_client/ui/home_panel.dart';

void main() {
  test(
    'Ошибочный JSON и неверный тип карточки передают код через isolate',
    () async {
      for (final packet in ['broken-json', '[]']) {
        await expectLater(
          compute(openCardInWorker, [packet, 'valid password words']),
          throwsA(
            isA<LocalFailure>().having(
              (error) => error.code,
              'code',
              LocalFailureCode.cardCorrupt,
            ),
          ),
        );
      }
    },
  );
  testWidgets(
    'Показанная ошибка меняет язык, сохраняя IP и не раскрывая диагностику',
    (tester) async {
      final locale = ValueNotifier(const Locale('ru'));
      addTearDown(locale.dispose);
      final home = HomeController()
        ..ip = '203.0.113.10'
        ..error = 'private-diagnostic'
        ..failureCode = LocalFailureCode.hashMismatch;
      addTearDown(home.dispose);
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, language, _) => MaterialApp(
            locale: language,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SingleChildScrollView(
                child: HomePanel(
                  home: home,
                  onStart: (_) async {},
                  onStop: () async {},
                  openAdministration: () {},
                ),
              ),
            ),
          ),
        ),
      );
      for (final language in ['ru', 'zh', 'en']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        expect(
          find.text(
            lookupAppLocalizations(Locale(language)).failureHashMismatch,
          ),
          findsOneWidget,
        );
        expect(find.text('private-diagnostic'), findsNothing);
        expect(home.ip, '203.0.113.10');
        expect(tester.takeException(), isNull);
      }
    },
  );
}
