import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/ui/home_panel.dart';

void main() {
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
                  home.state = null;
                  home.phase = HomePhase.stopped;
                  home.notifyListeners();
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
        home.notifyListeners();
        await tester.pumpAndSettle();
        expect(find.text(strings.homeDownloading), findsOneWidget);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator),
              )
              .value,
          .37,
        );
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          ip,
        );
        home.ip = ip;
        home.busy = false;
        home.running = true;
        home.phase = HomePhase.running;
        home.state = state;
        home.notifyListeners();
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
