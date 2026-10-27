import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/remote_backup.dart';

import 'fixtures/directory.dart';

void main() {
  for (final language in ['ru','en','zh']) {
    testWidgets('Удалённые копии: узкий экран, крупный шрифт и локализация $language',(tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize=const Size(320,800); tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize); addTearDown(tester.view.resetDevicePixelRatio);
      final prefs=AppPreferences(); addTearDown(prefs.close);
      final service=DirectoryBackupService(DirectoryRepository(DirectoryStorage()),DirectoryVault(),prefs,() => {});
      await tester.pumpWidget(MaterialApp(
        locale:Locale(language),supportedLocales:AppLocalizations.supportedLocales,
        localizationsDelegates:[...AppLocalizations.localizationsDelegates,AdminLocalizations.delegate],
        home:Scaffold(body:SingleChildScrollView(child:MediaQuery(data:const MediaQueryData(textScaler:TextScaler.linear(2)),child:RemoteBackupPanel(service:service)))),
      ));
      await tester.pumpAndSettle();
      final strings=lookupAppLocalizations(Locale(language));
      expect(find.text(strings.remoteBackupTitle),findsOneWidget);
      expect(find.byType(TextField),findsNWidgets(2));
      expect(tester.takeException(),isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      expect(tester.takeException(),isNull);
    });
  }
}
