import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/ui/home_disk_panel.dart';

class DiskHome extends HomeController {
  int cleanCalls = 0;
  @override
  Future<HomeDiskReport?> inspectDisk() async => HomeDiskReport(
    root: '/fixture',
    dataBytes: 1048576,
    runtimeBytes: 2097152,
    backupBytes: 3145728,
    recoveryBytes: 0,
    availableBytes: 1073741824,
    candidates: [const HomeDiskItem('backups', 'old-copy', 1048576, 'digest')],
    context: 'fixture',
  );
  @override
  Future<bool> cleanDisk(HomeDiskReport report, Set<String> selected) async {
    cleanCalls++;
    expect(selected, {'backups/old-copy'});
    return true;
  }
}

void main() {
  for (final running in [false, true]) {
    testWidgets('Размеры и подтверждение очистки; сервер работает: $running', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final home = DiskHome();
      addTearDown(home.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: HomeDiskPanel(
                home: home,
                view: HomeState(running: running),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('home-disk-scan')));
      await tester.pumpAndSettle();
      expect(find.text('Данные пространства: 1.0 MiB'), findsOneWidget);
      expect(home.cleanCalls, 0);
      final checkbox = find.byType(CheckboxListTile);
      await tester.ensureVisible(checkbox);
      if (running) {
        expect(tester.widget<CheckboxListTile>(checkbox).onChanged, isNull);
        expect(
          find.text('Для очистки сначала остановите сервер.'),
          findsOneWidget,
        );
      } else {
        await tester.tap(checkbox);
        await tester.pumpAndSettle();
        final button = find.byKey(const ValueKey('home-disk-clean'));
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(home.cleanCalls, 0);
        await tester.tap(find.text('Отмена'));
        await tester.pumpAndSettle();
        expect(home.cleanCalls, 0);
        await tester.tap(button);
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(FilledButton, 'Удалить выбранное').last,
        );
        await tester.pumpAndSettle();
        expect(home.cleanCalls, 1);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
