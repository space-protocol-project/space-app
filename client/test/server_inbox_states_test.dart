import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/server_inbox.dart';

import 'shell_test.dart' show TestController;

class TestPresence extends ServerPresence {
  TestPresence() : super(probe: (_) async => null);
  @override
  bool? online(String origin) {
    if (origin.contains('online')) return true;
    if (origin.contains('offline')) return false;
    return null;
  }
}

void main() {
  for (final language in ['ru', 'en', 'zh']) {
    testWidgets(
      'Много пространств, крупный текст и фильтр доступности: $language',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = TestController();
        final presence = TestPresence();
        final preferences = AppPreferences()..dark = false;
        final strings = lookupAppLocalizations(Locale(language));
        await tester.pumpWidget(
          MaterialApp(
            theme: preferences.theme,
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(390, 844),
                textScaler: TextScaler.linear(2),
              ),
              child: Scaffold(
                body: ServerInbox(
                  controllers: {
                    'https://online.example': controller,
                    'https://offline.example': controller,
                    for (var index = 0; index < 30; index++)
                      'https://long-name-$index.example': controller,
                  },
                  presence: presence,
                  icons: const {},
                  open: (_) {},
                  remove: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(ChoiceChip, strings.dashboardOnline),
        );
        await tester.pumpAndSettle();
        expect(find.text('online.example'), findsOneWidget);
        expect(find.text('offline.example'), findsNothing);
        expect(find.text(strings.dashboardAvailable), findsOneWidget);
        await tester.tap(
          find.widgetWithText(ChoiceChip, strings.serverFilterAll),
        );
        await tester.enterText(find.byType(TextField), 'long-name-29');
        await tester.pumpAndSettle();
        expect(find.text('long-name-29.example'), findsOneWidget);
        expect(find.text(strings.serverAvailabilityUnknown), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
        presence.dispose();
        preferences.dispose();
      },
    );
  }

  testWidgets('Неизвестная доступность, фильтр и действия пространства', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final presence = ServerPresence(probe: (_) async => true);
    final controller = TestController();
    const origin = 'https://space.example';
    String? opened, removed;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ServerInbox(
            controllers: {origin: controller},
            presence: presence,
            icons: const {},
            open: (value) => opened = value,
            remove: (value) => removed = value,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final strings = lookupAppLocalizations(const Locale('ru'));
    expect(find.text(strings.serverAvailabilityUnknown), findsOneWidget);
    expect(find.text(strings.dashboardUnavailable), findsNothing);
    await tester.tap(find.byKey(const ValueKey('server-inbox-$origin')));
    expect(opened, origin);
    await tester.enterText(find.byType(TextField), 'не существует');
    await tester.pumpAndSettle();
    expect(find.text(strings.nothingFound), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'space.example');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.removeServer));
    await tester.pumpAndSettle();
    expect(removed, origin);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    presence.dispose();
    controller.dispose();
  });
}
