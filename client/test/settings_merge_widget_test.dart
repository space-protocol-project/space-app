import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/settings_snapshot.dart';
import 'package:space_client/ui/directory_settings_merge.dart';

import 'fixtures/directory.dart';

void main() {
  for(final locale in [const Locale('ru'), const Locale('en'), const Locale('zh')]) {
    testWidgets('Явный выбор конфликта, крупный шрифт и узкий экран $locale', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = AppPreferences();
      addTearDown(prefs.close);
      await prefs.change(palette:'ocean');
      final service = DirectoryBackupService(DirectoryRepository(DirectoryStorage()),
          DirectoryVault(), prefs, () => {});
      final plan = await service.preview(directoryDocument());
      tester.view.physicalSize = const Size(320,1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var enabled = false;
      final choices = <String, SettingsChoice>{};
      await tester.pumpWidget(MaterialApp(locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(body: SingleChildScrollView(child: StatefulBuilder(builder: (context, update) =>
            Column(children: [
              DirectorySettingsMergePanel(plan:plan, enabled:enabled, busy:false, choices:choices,
                onEnabled:(value) => update(() => enabled=value),
                onChoice:(key,value) => update(() => choices[key]=value)),
              FilledButton(key:const ValueKey('apply'),
                onPressed:plan.settingsResolved(enabled,choices) ? () {} : null,
                child:const Text('Apply')),
            ])))))));
      await tester.pumpAndSettle();
      expect(find.byType(RadioListTile<SettingsChoice>), findsNothing);
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(find.byKey(const ValueKey('apply'))).onPressed, isNull);
      final local = find.byType(RadioListTile<SettingsChoice>).first;
      await tester.ensureVisible(local);
      await tester.tap(local);
      await tester.pumpAndSettle();
      expect(choices['palette'], SettingsChoice.local);
      expect(tester.widget<FilledButton>(find.byKey(const ValueKey('apply'))).onPressed, isNotNull);
      expect(tester.takeException(), isNull);
    });
  }
}
