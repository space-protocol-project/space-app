import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/voice_activity.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/ui/voice_room_details.dart';
import 'package:space_client/ui/voice_roster.dart';

import 'channels_test.dart' show chat;
import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia;

class ActivityMedia extends FakeVoiceMedia implements VoiceActivityMedia {
  ActivityMedia(super.log);
  VoiceAudioActivity value = const VoiceAudioActivity();
  @override
  Future<VoiceAudioActivity> activity() async => value;
}

class DelayedAnswerMedia extends ActivityMedia {
  DelayedAnswerMedia(super.log);
  final answered = Completer<void>();
  int reads = 0;
  @override
  Future<void> answer(String sdp) async {
    await super.answer(sdp);
    await answered.future;
  }

  @override
  Future<VoiceAudioActivity> activity() async {
    reads++;
    return value;
  }
}

class SlottedApi extends FakeVoiceApi {
  SlottedApi(super.log);
  @override
  VoiceRoomState get roster => super.roster
    ..participants[0].audioSlot = 3
    ..participants[1].audioSlot = 1
    ..participants.add(
      VoiceParticipant(sessionId: 'higher', nickname: 'Третий', audioSlot: 5),
    );
}

void main() {
  testWidgets('Диагностика и микрофон не запускаются до применения SDP', (
    tester,
  ) async {
    final log = <String>[];
    final api = SlottedApi(log), media = DelayedAnswerMedia(log);
    final controller = VoiceController(mediaFactory: () => media);
    final joining = controller.join(api, 'room', 'Комната');
    await tester.pump();
    expect(controller.state.phase, VoicePhase.joining);
    expect(media.reads, 0);
    await controller.toggleMicrophone();
    expect(log, isNot(contains('microphone:true')));
    media.answered.complete();
    await joining;
    await tester.pump();
    expect(controller.state.phase, VoicePhase.connected);
    expect(media.reads, greaterThan(0));
    await controller.close();
  });

  testWidgets(
    'Просмотр комнаты показывает участников без входа и захвата микрофона',
    (tester) async {
      final log = <String>[];
      final api = SlottedApi(log);
      final controller = VoiceController(
        mediaFactory: () => ActivityMedia(log),
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: VoiceRoomDetails(
              room: chat('room'),
              controller: controller,
              api: api,
              load: () async => api.roster,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(CircleAvatar), findsNWidgets(3));
      expect(controller.state.phase, VoicePhase.idle);
      expect(log, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
      await controller.close();
    },
  );

  testWidgets(
    'Рамки сопоставляются участникам по аудиоместам и исчезают при тишине',
    (tester) async {
      final log = <String>[];
      final api = SlottedApi(log), media = ActivityMedia(log);
      final controller = VoiceController(mediaFactory: () => media);
      await controller.join(api, 'room', 'Комната');
      await tester.pump();
      media.value = const VoiceAudioActivity(remoteSlots: {1, 4});
      await tester.pump(const Duration(milliseconds: 250));
      expect(controller.state.speaking, {'other', 'higher'});
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: VoiceRoster(
              people: controller.state.roster!.participants,
              speaking: controller.state.speaking,
            ),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('voice-avatar-other-true')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('voice-avatar-local-false')),
        findsOneWidget,
      );
      media.value = const VoiceAudioActivity();
      await tester.pump(const Duration(milliseconds: 250));
      expect(controller.state.speaking, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
      await controller.close();
      await tester.pump(const Duration(seconds: 1));
      expect(controller.state.speaking, isEmpty);
    },
  );
}
