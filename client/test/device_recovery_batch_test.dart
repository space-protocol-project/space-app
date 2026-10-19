import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/device_panel.dart';
import 'package:space_client/ui/recovery_panel.dart';

import 'mls_native_test.dart' show MemoryMlsStorage;

void main() {
  testWidgets(
    'Пакет восстановления остаётся жив после добавления первого и второго пространств',
    (tester) async {
      final vault = KeyIdentityVault(MemoryMlsStorage());
      final fallback = ChatController(vault),
          first = ChatController(vault),
          second = ChatController(vault);
      final spaces = ServerWorkspaces(vault: vault);
      addTearDown(spaces.close);
      addTearDown(fallback.close);
      addTearDown(first.close);
      addTearDown(second.close);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AdminLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          home: Scaffold(
            body: DevicePanel(
              workspaces: spaces,
              fallback: fallback,
              restoreController: (_) => first,
              onRestored: (origin, target) =>
                  spaces.adopt(origin, target, owned: false),
            ),
          ),
        ),
      );
      final initialState = tester.state(find.byType(RecoveryPanel));
      tester
          .widget<RecoveryPanel>(find.byType(RecoveryPanel))
          .onPendingChanged!(true);
      await tester.pump();
      await tester
          .widget<RecoveryPanel>(find.byType(RecoveryPanel))
          .onRestored!('https://203.0.113.1:8443', first);
      await tester.pump();
      expect(tester.state(find.byType(RecoveryPanel)), same(initialState));
      expect(
        tester.widget<RecoveryPanel>(find.byType(RecoveryPanel)).controller,
        same(fallback),
      );
      await tester
          .widget<RecoveryPanel>(find.byType(RecoveryPanel))
          .onRestored!('https://203.0.113.2:8443', second);
      await tester.pump();
      expect(tester.state(find.byType(RecoveryPanel)), same(initialState));
      tester
          .widget<RecoveryPanel>(find.byType(RecoveryPanel))
          .onPendingChanged!(false);
      await tester.pumpAndSettle();
      expect(spaces.controllers.length, 2);
      expect(
        tester.widget<RecoveryPanel>(find.byType(RecoveryPanel)).controller,
        same(second),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
