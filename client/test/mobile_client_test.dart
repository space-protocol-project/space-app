import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/app_updates.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/shell.dart';

void main() {
  testWidgets(
    'Мобильный клиент подключается, но не предлагает создание и перенос сервера',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final preferences = AppPreferences();
      await preferences.load();
      final updates = AppUpdates(
        client: MockClient((_) async => http.Response('{}', 404)),
        readVersion: () async => 'v0.2.4',
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: [
            AdminLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SpaceShell(
            preferences: preferences,
            updates: updates,
            hostingEnabled: false,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Добавить пространство'), findsWidgets);
      expect(
        find.byKey(const ValueKey('home-server-details-tab')),
        findsNothing,
      );
      expect(find.byKey(const ValueKey('import-space-entry')), findsNothing);
      expect(find.text('Создать пространство'), findsNothing);
      await tester.tap(find.text('Добавить пространство').first);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('space-qr-camera')), findsOneWidget);
      expect(find.byKey(const ValueKey('space-qr-image')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      preferences.dispose();
    },
  );
}
