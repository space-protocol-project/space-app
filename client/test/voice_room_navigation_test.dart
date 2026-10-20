import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/voice_room_navigation.dart';

import 'channels_test.dart' show chat;

void main() {
  testWidgets(
    'Один клик открывает, двойной входит; заголовок пропускает закрытую комнату',
    (tester) async {
      final selected = <String?>[], joined = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ru'),
          home: Scaffold(
            body: VoiceRoomNavigation(
              rooms: [
                chat('locked')..permissions.read = false,
                chat('first')..title = 'Первая',
                chat('second')..title = 'Вторая',
              ],
              onSelect: selected.add,
              onJoin: (room) => joined.add(room.id),
              onRefresh: null,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Комнаты'));
      expect(selected, ['first']);
      await tester.tap(find.text('Вторая'));
      await tester.pump(const Duration(milliseconds: 350));
      expect(selected, ['first', 'second']);
      expect(joined, isEmpty);
      await tester.tap(find.text('Первая'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Первая'));
      await tester.pump(const Duration(milliseconds: 350));
      expect(joined, ['first']);
      expect(selected, ['first', 'second']);
    },
  );

  for (final width in [390.0, 1280.0]) {
    testWidgets('Комнаты внутри общей области, выбор и обновление: $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final selections = <String?>[];
      var refreshed = 0;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SizedBox(
              width: 260,
              child: VoiceRoomNavigation(
                rooms: [
                  chat('lounge')..title = 'Разговор',
                  chat('games')..title = 'Игры',
                ],
                active: true,
                selectedRoomId: 'lounge',
                onSelect: selections.add,
                onRefresh: () => refreshed++,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final group = find.byKey(const ValueKey('server-voice-rooms'));
      expect(
        find.descendant(of: group, matching: find.text('Разговор')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: group, matching: find.text('Игры')),
        findsOneWidget,
      );
      expect(
        tester
            .widget<ListTile>(
              find.byKey(const ValueKey('sidebar-voice-room-lounge')),
            )
            .selected,
        true,
      );
      await tester.tap(find.text('Игры'));
      expect(selections, ['games']);
      await tester.tap(find.text('Комнаты'));
      expect(selections, ['games', 'lounge']);
      await tester.tap(find.byTooltip('Обновить список комнат'));
      expect(refreshed, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
