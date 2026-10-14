import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/ui/server_inbox.dart';

import 'shell_test.dart' show TestController;

void main() {
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
