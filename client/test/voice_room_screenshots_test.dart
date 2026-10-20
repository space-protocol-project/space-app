import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/ui/voice_room_details.dart';
import 'package:space_client/ui/voice_room_navigation.dart';
import 'package:space_client/ui/voice_rooms.dart';

import 'channels_test.dart' show chat;
import 'redesign_golden_test.dart' show loadFonts;
import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia;

class ScreenshotController extends VoiceController {
  ScreenshotController() : super(mediaFactory: () => FakeVoiceMedia([]));
  void show(VoiceRoomState roster) => emit(
    VoiceState(
      phase: VoicePhase.connected,
      title: 'Поговорение',
      room: 'room',
      muted: false,
      canPublish: true,
      roster: roster,
      speaking: {'local', 'other'},
    ),
  );
}

void main() {
  for (final width in [1280.0, 430.0]) {
    testWidgets('Снимок комнаты с демонстрационным разговором: $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(loadFonts);
      final controller = ScreenshotController();
      final api = FakeVoiceApi([]);
      await controller.join(api, 'room', 'Поговорение');
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
      controller.show(roster);
      final preferences = AppPreferences();
      final room = chat('room')..title = 'Поговорение';
      const key = ValueKey('room-screenshot');
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: preferences.theme,
            home: Scaffold(
              appBar: AppBar(title: const Text('Голосовая комната')),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (width > 700)
                    SizedBox(
                      width: 260,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: VoiceRoomNavigation(
                          rooms: [room],
                          active: true,
                          selectedRoomId: 'room',
                          onSelect: (_) {},
                          onRefresh: () {},
                        ),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: VoiceRoomDetails(
                          room: room,
                          controller: controller,
                          api: api,
                          load: () async => roster,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: VoiceCallBar(controller: controller),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(CircleAvatar), findsNWidgets(4));
      expect(
        find.byKey(const ValueKey('voice-avatar-local-true')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File(
          '../.local/voice-room-screenshots/voice-room-speaking-${width.toInt()}.png',
        );
        await file.parent.create(recursive: true);
        await file.writeAsBytes(data!.buffer.asUint8List());
        image.dispose();
      });
      await tester.pumpWidget(const SizedBox.shrink());
      await controller.close();
      preferences.dispose();
    });
  }
}
