import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_backup_policy.dart';
import 'package:space_client/ui/home_backup_editor.dart';

void main() {
  testWidgets(
    'Расписание и автоочистка включаются отдельно, минимум три копии',
    (tester) async {
      HomeBackupPolicy? saved;
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async => saved = await editHomeBackupPolicy(
                  context,
                  const HomeBackupSettings(
                    HomeBackupPolicy(),
                    HomeBackupStatus(),
                    true,
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('backup-enabled')));
      await tester.tap(find.byKey(const ValueKey('backup-enabled')));
      await tester.pumpAndSettle();
      final count = find.byKey(const ValueKey('backup-count'));
      await tester.ensureVisible(count);
      await tester.enterText(count, '2');
      await tester.tap(find.byKey(const ValueKey('backup-save')));
      await tester.pumpAndSettle();
      expect(saved, isNull);
      expect(find.text('3–100'), findsOneWidget);
      await tester.enterText(count, '5');
      await tester.tap(find.byKey(const ValueKey('backup-save')));
      await tester.pumpAndSettle();
      expect(saved!.enabled, true);
      expect(saved!.prune, false);
      expect(saved!.keepCount, 5);
      expect(tester.takeException(), isNull);
    },
  );
}
