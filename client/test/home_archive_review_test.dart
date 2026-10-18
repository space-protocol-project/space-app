import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_archive_inspection.dart';
import 'package:space_client/ui/home_archive_review.dart';

void main() {
  for (final confirm in [false, true]) {
    testWidgets('Подтверждение восстановления: $confirm', (tester) async {
      bool? result;
      const report = HomeArchiveInspection(
        path: '/archive.zip',
        digest: 'digest',
        serverId: 'space-review',
        schemaVersion: 22,
        files: 5,
        unpackedBytes: 1048576,
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await confirmHomeArchive(context, report);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.textContaining('space-review'), findsOneWidget);
      expect(find.textContaining('22'), findsOneWidget);
      expect(result, isNull);
      await tester.tap(
        find.text(confirm ? 'Начать восстановление' : 'Закрыть'),
      );
      await tester.pumpAndSettle();
      expect(result, confirm);
    });
  }
}
