import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/directory_transfer.dart';

import 'fixtures/directory.dart';
import 'pairing_panels_test.dart' show host;
import 'pairing_qr_test.dart' show testServer;

void main() {
  for (final language in ['ru', 'en', 'zh']) {
    testWidgets(
      'Каталог: узкий экран, крупный текст и явные действия ($language)',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final preferences = AppPreferences();
        addTearDown(preferences.close);
        final controller = ChatController(DirectoryVault())
          ..preview = testServer();
        addTearDown(controller.close);
        final service = DirectoryBackupService(
          DirectoryRepository(DirectoryStorage()),
          DirectoryVault(),
          preferences,
          () => {},
        );
        await tester.pumpWidget(
          host(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: DirectoryTransferPanel(
                service: service,
                controller: controller,
              ),
            ),
            language,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(FilledButton), findsNWidgets(2));
        expect(
          tester.widget<FilledButton>(find.byType(FilledButton).last).onPressed,
          isNull,
        );
        expect(find.byType(Image), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      },
    );
  }
}
