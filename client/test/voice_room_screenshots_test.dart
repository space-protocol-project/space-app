import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Channel;
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/ui/shell.dart';
import 'package:space_client/ui/voice_room_details.dart';

import 'channels_test.dart' show chat;
import 'chat_examples_screenshots_test.dart' show captureExample;

import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/src/voice_signaling.dart';

import 'voice_controller_test.dart' show FakeVoiceMedia;
import 'redesign_golden_test.dart' show loadFonts;
import 'support/chat_examples.dart' show ExampleController, ExampleFiles;

final room = chat('room')
  ..title = 'Поговорение'
  ..views.first.type = 'voice_room';
final roster = VoiceRoomState(
  capacity: 8,
  canPublish: true,
  participants: [
    VoiceParticipant(sessionId: 'local', nickname: 'Алиса', audioSlot: 0),
    VoiceParticipant(sessionId: 'other', nickname: 'Борис', audioSlot: 1),
    VoiceParticipant(sessionId: 'third', nickname: 'София', audioSlot: 2),
    VoiceParticipant(
      sessionId: 'fourth',
      nickname: 'Максим',
      audioSlot: 3,
      muted: true,
    ),
  ],
);

class ScreenshotSession implements SpaceSession {
  @override
  final server = Discovery(
    localOrigin('http://127.0.0.1:8080'),
    'srv_voice_demo',
    List.filled(32, 1),
    voiceRoomsVersion: 3,
  );
  @override
  List<Channel> get availableChannels => [chat('general'), room];
  @override
  bool get mlsSupported => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ScreenshotController extends ExampleController {
  ScreenshotController() : super('reactions', ExampleFiles());
  final session = ScreenshotSession();
  @override
  List<Channel> get voiceRooms => [room];
  @override
  SpaceSession get mlsSession => session;
}

class ScreenshotVoice extends VoiceController {
  ScreenshotVoice() : super(mediaFactory: () => FakeVoiceMedia([]));
  @override
  bool matches(VoiceSignaling api, String id) => id == room.id && state.active;
  void show() => emit(
    VoiceState(
      phase: VoicePhase.connected,
      title: room.title,
      room: room.id,
      muted: false,
      canPublish: true,
      roster: roster,
      speaking: {'local', 'other'},
    ),
  );
}

void main() {
  for (final width in [1440.0, 1100.0]) {
    testWidgets('Полный интерфейс приложения с голосовой комнатой: $width', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'space.ui.dark': true});
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(loadFonts);
      final preferences = AppPreferences();
      final controller = ScreenshotController()..connected = true;
      controller.server(controller.session.server);
      final voice = ScreenshotVoice()..show();
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: preferences.theme,
            locale: const Locale('ru'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AdminLocalizations.delegate,
              ...AppLocalizations.localizationsDelegates,
            ],
            home: SpaceShell(
              preferences: preferences,
              controller: controller,
              voiceController: voice,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Комнаты').first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(VoiceRoomDetails), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNWidgets(4));
      expect(
        find.byKey(const ValueKey('voice-avatar-local-true')),
        findsOneWidget,
      );
      expect(find.text('Управление пространством'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await captureExample(
        tester,
        boundary,
        '../.local/voice-room-screenshots/voice-room-speaking-${width.toInt()}.png',
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(controller.close);
      await voice.close();
      preferences.dispose();
    });
  }
}
