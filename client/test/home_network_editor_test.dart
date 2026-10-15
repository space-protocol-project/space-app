import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/ui/home_network_editor.dart';

class _Home extends HomeController {
  List<ServerEndpoint>? saved;
  int? port;
  @override
  Future<bool> configureNetwork(
    List<ServerEndpoint> endpoints, {
    String listenHost = '::',
    int listenPort = 8443,
  }) async {
    saved = endpoints;
    port = listenPort;
    return true;
  }
}

void main() {
  for (final width in [390.0, 1100.0]) {
    testWidgets(
      'Адреса и разные порты сохраняются, смена языка не теряет ввод: $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 1100);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final home = _Home();
        final address = TextEditingController(text: 'space.example.org');
        addTearDown(home.dispose);
        addTearDown(address.dispose);
        final editor = GlobalKey<HomeNetworkEditorState>();
        Future<void> show(Locale locale) => tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    HomeNetworkEditor(
                      key: editor,
                      home: home,
                      address: address,
                      enabled: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await show(const Locale('ru'));
        await tester.tap(find.text('Добавить адрес'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(1), '443');
        await tester.enterText(find.byType(TextField).at(2), '2001:db8::9');
        await tester.enterText(find.byType(TextField).at(3), '9443');
        await tester.tap(find.text('На этом компьютере'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(4), '18443');
        for (final locale in [
          const Locale('en'),
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
          const Locale('ru'),
        ]) {
          await show(locale);
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<TextField>(find.byType(TextField).at(2))
                .controller!
                .text,
            '2001:db8::9',
          );
          expect(tester.takeException(), isNull);
        }
        await tester.tap(find.text('Сохранить настройки'));
        await tester.pumpAndSettle();
        expect(home.saved!.map((e) => e.origin.toString()), [
          'https://space.example.org',
          'https://[2001:db8::9]:9443',
        ]);
        expect(home.port, 18443);
        await tester.enterText(find.byType(TextField).at(1), '65536');
        expect(await editor.currentState!.save(), false);
        await tester.pumpAndSettle();
        expect(
          find.text(
            'Проверьте адреса и порты (1–65535). Адреса не должны повторяться.',
          ),
          findsOneWidget,
        );
        expect(home.saved!.first.port, 443);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
