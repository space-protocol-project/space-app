import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/voice_room_management.dart';

import 'admin_channels_panel_test.dart'
    show ChannelServer, defaults, press, toggle;

class _VoiceSession implements SpaceSession {
  @override
  bool get participantProfilesSupported => false;
  @override
  final server = Discovery(
    localOrigin('http://127.0.0.1:8080'),
    'srv_rooms',
    List.filled(32, 1),
    voiceRoomsVersion: 3,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final language in ['ru', 'en', 'zh']) {
    testWidgets(
      'Комнаты: список, настройки, права, создание и удаление ($language)',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final server = ChannelServer();
        server.channels['voice_lounge'] = {
          'id': 'voice_lounge',
          'title': 'Разговор',
          'revision': '1',
          'position': 100,
          'views': [
            {'type': 'voice_room'},
          ],
        };
        server.access['voice_lounge'] = defaults();
        final strings = lookupAdminLocalizations(Locale(language));
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            supportedLocales: AdminLocalizations.supportedLocales,
            localizationsDelegates: AdminLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SingleChildScrollView(
                child: VoiceRoomManagement(
                  session: _VoiceSession(),
                  call: server.call,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Разговор'), findsOneWidget);
        expect(find.text('Общий чат'), findsNothing);
        await press(tester, 'Разговор');
        expect(find.text(strings.voiceRoomListen), findsWidgets);
        expect(find.text(strings.voiceRoomSpeak), findsWidgets);
        expect(find.text(strings.channelPublicPreview), findsNothing);
        await tester.enterText(
          find.byKey(const ValueKey('channel-title')),
          'Новая комната',
        );
        final limit = find.widgetWithText(TextField, strings.voiceRoomCapacity);
        await tester.enterText(limit, '33');
        await press(tester, strings.voiceRoomSave);
        expect(find.text(strings.voiceRoomCapacityInvalid), findsOneWidget);
        await tester.enterText(limit, '32');
        await press(tester, strings.voiceRoomSave);
        expect(server.channels['voice_lounge']!['voiceCapacity'], 32);
        expect(server.channels['voice_lounge']!['title'], 'Новая комната');
        await toggle(tester, 'rule-0-write');
        await press(tester, strings.channelSaveAccess);
        expect(
          server.access['voice_lounge']!.first['permissions']['write'],
          false,
        );
        await tester.ensureVisible(find.text(strings.voiceRoomArchive));
        await tester.tap(find.text(strings.voiceRoomArchive));
        await tester.pumpAndSettle();
        await press(tester, strings.voiceRoomSave);
        expect(server.channels['voice_lounge']!['archived'], true);
        await press(tester, strings.voiceRoomDelete);
        await tester.tap(find.widgetWithText(TextButton, strings.cancel));
        await tester.pumpAndSettle();
        expect(server.channels.containsKey('voice_lounge'), true);
        await press(tester, strings.voiceRoomDelete);
        await tester.tap(
          find.widgetWithText(FilledButton, strings.voiceRoomDelete),
        );
        await tester.pumpAndSettle();
        expect(server.channels.containsKey('voice_lounge'), false);
        expect(find.text(strings.voiceRoomsEmpty), findsOneWidget);
        await press(tester, strings.voiceRoomCreate);
        await tester.enterText(
          find.byKey(const ValueKey('new-channel-title')),
          'Новая голосовая',
        );
        final create = find.widgetWithText(
          FilledButton,
          strings.voiceRoomCreate,
        );
        await tester.ensureVisible(create);
        await tester.tap(create);
        await tester.pumpAndSettle();
        final created = server.channels.values.singleWhere(
          (c) => c['id'] != 'general',
        );
        expect(created['views'], [
          {'type': 'voice_room'},
        ]);
        expect(created['id'], startsWith('voice_'));
        expect(created['voiceCapacity'], 8);
        expect(
          find.widgetWithText(ListTile, 'Новая голосовая'),
          findsOneWidget,
        );
        expect(find.text('Общий чат'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets('Панель чатов не смешивает голосовые комнаты с чатами', (
    tester,
  ) async {
    final server = ChannelServer();
    server.channels['voice_room'] = {
      'id': 'voice_room',
      'title': 'Голос',
      'revision': '1',
      'views': [
        {'type': 'voice_room'},
      ],
    };
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AdminLocalizations.supportedLocales,
        localizationsDelegates: AdminLocalizations.localizationsDelegates,
        home: Scaffold(
          body: SingleChildScrollView(child: ChannelsPanel(call: server.call)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Общий чат'), findsOneWidget);
    expect(find.text('Голос'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
