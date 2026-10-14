import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/ui/shell.dart';

import 'shell_test.dart' show TestController;

void main() {
  for (final language in ['ru', 'zh', 'en']) {
    testWidgets('Уведомление и значок сохранённого сервера: $language', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var online = true;
      final presence = ServerPresence(probe: (_) async => online);
      final preferences = AppPreferences()
        ..origins.add('https://server.example');
      final controller = TestController();
      final strings = lookupAppLocalizations(Locale(language));
      await tester.pumpWidget(
        MaterialApp(
          theme: preferences.theme,
          locale: Locale(language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: SpaceShell(
            preferences: preferences,
            controller: controller,
            presence: presence,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      expect(
        find.byTooltip(
          'https://server.example\n${strings.serverNowOnline('server.example')}',
        ),
        findsOneWidget,
      );
      online = false;
      await presence.check();
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      await presence.check();
      await tester.pumpAndSettle();
      expect(
        find.text(strings.serverNowOffline('server.example')),
        findsOneWidget,
      );
      expect(
        find.byTooltip(
          'https://server.example\n${strings.serverNowOffline('server.example')}',
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 7));
      await tester.pumpAndSettle();
      online = true;
      await presence.check();
      await tester.pumpAndSettle();
      expect(
        find.text(strings.serverNowOnline('server.example')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      presence.dispose();
      preferences.dispose();
      controller.dispose();
    });
  }
}
