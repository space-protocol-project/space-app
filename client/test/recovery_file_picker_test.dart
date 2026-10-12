import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/recovery_file_picker.dart';

void main() {
  testWidgets('Выбор карточки внутри Space не вызывает системный диалог', (
    tester,
  ) async {
    final root = Directory.systemTemp.createTempSync('space-card-picker-');
    final card = File('${root.path}/card.json')..writeAsStringSync('{}');
    File('${root.path}/ignored.txt').writeAsStringSync('fixture');
    addTearDown(() => root.deleteSync(recursive: true));
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                selected = await showDialog<String>(
                  context: context,
                  builder: (_) =>
                      RecoveryFilePicker(initialDirectory: root.path),
                );
              },
              child: const Text('fixture'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('fixture'));
      await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    expect(find.text('ignored.txt'), findsNothing);
      await tester.enterText(find.byType(TextField), card.path);
    await tester.pump();
    await tester.tap(find.text('Открыть файл'));
    await tester.pumpAndSettle();
    expect(selected, card.path);
    expect(tester.takeException(), isNull);
  });
}
