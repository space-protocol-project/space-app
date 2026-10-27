import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/ui/pairing_approval_panel.dart';
import 'package:space_client/ui/pairing_panel.dart';

import 'pairing_cubit_test.dart' show PairingVault;
import 'pairing_qr_test.dart' show testServer;

Widget host(Widget child, String language) => MaterialApp(
  locale: Locale(language), supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  for (final language in ['ru', 'en', 'zh']) {
    testWidgets('Сопряжение: узкий экран и крупный текст ($language)', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = ChatController(PairingVault())..preview = testServer();
      addTearDown(controller.close);
      final strings = lookupAdminLocalizations(Locale(language));
      await tester.pumpWidget(host(MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Column(children: [
          PairingStartPanel(controller: controller, onConnected: (_) async {}),
          PairingApprovalPanel(controller: controller, readAuthority: () async => null),
        ]),
      ), language));
      await tester.pumpAndSettle();
      expect(find.text(strings.pairingStart), findsOneWidget);
      expect(find.text(strings.pairingSign), findsNothing);
      final prepare = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, strings.pairingPrepare));
      expect(prepare.onPressed, isNull);
      await tester.enterText(find.byType(TextField).first, 'pc_123');
      await tester.pump();
      expect(find.text(strings.pairingSign), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}
