import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/voice_room_management.dart';

void main() {
  testWidgets('Создание голосовой комнаты: пустое имя, отмена и отправка', (
    tester,
  ) async {
    final names = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: CreateVoiceRoomButton(
            onCreate: (name) async => names.add(name),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Создать комнату'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Создать'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(names, isEmpty);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(names, isEmpty);
    await tester.tap(find.text('Создать комнату'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  Разговор  ');
    await tester.tap(find.text('Создать'));
    await tester.pumpAndSettle();
    expect(names, ['Разговор']);
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
