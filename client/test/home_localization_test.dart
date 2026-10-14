import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/ui/home_panel.dart';
import 'package:space_client/src/local_failure.dart';

void main() {
  testWidgets(
    'Причина блокировки восстановления переведена, запуск отключён, сведения не содержат ошибку или секрет',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      String copied = '';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String;
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      final home = HomeController()
        ..pendingUpdate = true
        ..error = 'PRIVATE_PASSWORD_SHOULD_NOT_BE_SHOWN'
        ..recoverySummary = 'directory: fixture\noperation: update-test';
      addTearDown(home.dispose);
      for (final locale in [
        const Locale('ru'),
        const Locale('en'),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      ]) {
        for (final code in [
          LocalFailureCode.homeJournalInvalid,
          LocalFailureCode.homeBackupMissing,
          LocalFailureCode.homeBackupInvalid,
          LocalFailureCode.homeRecoveryInvalid,
        ]) {
          home.failureCode = code;
          home.publishState();
          await tester.pumpWidget(
            MaterialApp(
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: Scaffold(
                body: HomePanel(
                  home: home,
                  onStart: (_) async {
                    fail('Запуск заблокирован');
                  },
                  onStop: () async {},
                  openAdministration: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final strings = lookupAppLocalizations(locale);
          expect(
            tester
                .widget<OutlinedButton>(
                  find.widgetWithText(OutlinedButton, strings.goLive),
                )
                .onPressed,
            isNull,
          );
          expect(
            tester
                .widget<OutlinedButton>(
                  find.widgetWithText(OutlinedButton, strings.homeResumeUpdate),
                )
                .onPressed,
            isNull,
          );
          expect(find.text(strings.homeRecoveryGuide), findsOneWidget);
          expect(find.text(home.error), findsNothing);
          await tester.ensureVisible(
            find.byKey(const ValueKey('home-recovery-diagnostics')),
          );
          await tester.tap(
            find.byKey(const ValueKey('home-recovery-diagnostics')),
          );
          await tester.pumpAndSettle();
          expect(copied, contains(code.name));
          expect(copied, isNot(contains('PRIVATE_PASSWORD')));
        }
      }
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'Язык домашнего сервера меняется без потери IP, прогресса и ссылки',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(430, 900);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final home = HomeController();
      addTearDown(home.dispose);
      var stops = 0;
      const ip = '203.0.113.10';
      final state = HomeServerState(
        'http://127.0.0.1:18080',
        'https://$ip:8443',
        '',
        'a' * 64,
      );
      for (final locale in [
        const Locale('ru'),
        const Locale('en'),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: HomePanel(
                home: home,
                onStart: (_) async {},
                onStop: () async {
                  stops++;
                  home.running = false;
                  home.server = null;
                  home.phase = HomePhase.stopped;
                  home.publishState();
                },
                openAdministration: () {},
              ),
            ),
          ),
        );
        if (locale.languageCode == 'ru') {
          await tester.enterText(find.byType(TextField), ip);
        }
        final strings = lookupAppLocalizations(locale);
        home.busy = true;
        home.phase = HomePhase.downloading;
        home.progress = .37;
        home.publishState();
        await tester.pumpAndSettle();
        expect(find.text(strings.homeDownloading), findsOneWidget);
        expect(
          tester
              .widget<CircularProgressIndicator>(
                find.byType(CircularProgressIndicator),
              )
              .value,
          closeTo(.05 + .55 * .37, .00001),
        );
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          ip,
        );
        home.ip = ip;
        home.busy = false;
        home.running = true;
        home.phase = HomePhase.running;
        home.server = state;
        home.publishState();
        await tester.pumpAndSettle();
        expect(find.text(state.link), findsOneWidget);
        await tester.ensureVisible(find.text(strings.stopHome));
        await tester.tap(find.text(strings.stopHome));
        await tester.pumpAndSettle();
        expect(find.text(strings.goLive), findsOneWidget);
        expect(find.text(strings.homeStopped), findsOneWidget);
        expect(home.ip, ip);
        expect(tester.takeException(), isNull);
      }
      expect(stops, 3);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
