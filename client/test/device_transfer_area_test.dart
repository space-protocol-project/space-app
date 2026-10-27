import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/device_transfer_area.dart';

void main() {
  for (final width in [390.0, 1000.0]) {
    testWidgets('Две области и импорт перетаскиванием, ширина $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      String? imported;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: DeviceTransferArea(
                export: (_, _, _, _) async {},
                restore: (path, password, progress, beforeCommit) async {
                  expect(password, 'пароль переноса');
                  imported = path;
                  throw StateError('Проверяемая ошибка');
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Полный перенос'), findsOneWidget);
      expect(find.text('Полное восстановление'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final drop = tester.widget<DropTarget>(find.byType(DropTarget));
      drop.onDrop(
        DropDetails(
          operation: DropOperation.copy,
          items: [DropFileItem.fromPath('device.spacedevice')],
          localPosition: Offset.zero,
          globalPosition: Offset.zero,
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'пароль переноса');
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(imported, 'device.spacedevice');
      expect(find.textContaining('Проверяемая ошибка'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
