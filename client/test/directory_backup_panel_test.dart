import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_backup_cubit.dart';
import 'package:space_client/src/directory_archive.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/directory_backup.dart';

import 'fixtures/directory.dart';

void main() {
  for (final language in ['ru', 'en', 'zh']) {
    testWidgets('Копии: узкий экран и крупный шрифт ($language)', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final preferences = AppPreferences();
      addTearDown(preferences.close);
      final storage = DirectoryStorage();
      final strings = lookupAppLocalizations(Locale(language));
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            AdminLocalizations.delegate,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: MediaQuery(
                data: const MediaQueryData(textScaler: TextScaler.linear(2)),
                child: DirectoryBackupPanel(
                  service: DirectoryBackupService(
                    DirectoryRepository(storage),
                    DirectoryVault(),
                    preferences,
                    () => {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(strings.directoryBackupTitle), findsOneWidget);
      expect(find.text(strings.directoryBackupApply), findsNothing);
      expect(storage.values, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
  testWidgets(
    'Повторный выбор файла не оставляет прежний просмотр и выбор замены настроек',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = AppPreferences();
      addTearDown(preferences.close);
      final service = DirectoryBackupService(
        DirectoryRepository(DirectoryStorage()),
        DirectoryVault(),
        preferences,
        () => {},
      );
      final cubit = DirectoryBackupCubit(service);
      addTearDown(cubit.close);
      await tester.runAsync(() async {
        final bytes = await DirectoryArchive.seal(
          directoryDocument(),
          'A secure backup password',
        );
        await cubit.preview(bytes, 'A secure backup password');
      });
      cubit.replaceSettings(true);
      expect(cubit.state.plan, isNotNull);
      final strings = lookupAppLocalizations(const Locale('ru'));
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            AdminLocalizations.delegate,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: DirectoryBackupPanel(service: service, controller: cubit),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings.directoryBackupRead));
      await tester.pumpAndSettle();
      expect(cubit.state.plan, isNull);
      expect(cubit.state.replaceSettings, isFalse);
      expect(find.text(strings.directoryBackupApply), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}
