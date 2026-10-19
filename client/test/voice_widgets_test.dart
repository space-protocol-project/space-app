import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/src/voice_media.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/ui/voice_rooms.dart';

import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia;

class GroupVoiceApi extends FakeVoiceApi {
  GroupVoiceApi(super.log);
  @override
  VoiceRoomState get roster => super.roster
    ..participants.addAll(
      List.generate(
        6,
        (index) => VoiceParticipant(
          sessionId: 'participant-$index',
          nickname: 'Участник ${index + 3}',
          muted: true,
        ),
      ),
    );
}

void main() {
  testWidgets(
    'Повторное подключение видно, микрофон заблокирован, выход доступен',
    (tester) async {
      final log = <String>[];
      final api = FakeVoiceApi(log), media = FakeVoiceMedia(log);
      final controller = VoiceController(mediaFactory: () => media);
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await controller.close();
      });
      await controller.join(api, 'room', 'Комната');
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: VoiceCallBar(controller: controller),
          ),
        ),
      );
      media.stream.add(VoiceMediaStatus.failed);
      await tester.pump();
      expect(
        find.text('Восстанавливаем соединение. Микрофон выключен.'),
        findsOneWidget,
      );
      final microphone = tester.widget<IconButton>(
        find.byKey(const ValueKey('voice-microphone')),
      );
      final deafen = tester.widget<IconButton>(
        find.byKey(const ValueKey('voice-deafen')),
      );
      expect(microphone.onPressed, isNull);
      expect(deafen.onPressed, isNull);
      await tester.tap(find.byKey(const ValueKey('voice-leave')));
      await tester.pump(const Duration(seconds: 2));
      expect(controller.state.phase, VoicePhase.idle);
      expect(log.where((event) => event == 'configure').length, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Восемь участников на 390×600: прокрутка, микрофон, звук и выход',
    (tester) async {
      tester.view.physicalSize = const Size(390, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final log = <String>[];
      final api = GroupVoiceApi(log), media = FakeVoiceMedia(log);
      final controller = VoiceController(
        mediaFactory: () => media,
        heartbeat: const Duration(days: 1),
      );
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await controller.close();
      });
      await controller.join(api, 'room', 'Голосовая комната');
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Column(
              children: [
                Expanded(child: VoiceParticipants(controller: controller)),
                VoiceCallBar(controller: controller),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Алиса'), findsOneWidget);
      expect(find.text('Борис'), findsOneWidget);
      await tester.ensureVisible(find.text('Участник 8'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const ValueKey('voice-microphone')));
      await tester.pumpAndSettle();
      expect(controller.state.muted, false);
      await tester.tap(find.byKey(const ValueKey('voice-deafen')));
      await tester.pumpAndSettle();
      expect(controller.state.deafened, true);
      expect(controller.state.muted, true);
      await tester.tap(find.byKey(const ValueKey('voice-leave')));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(
        controller.state.phase,
        VoicePhase.idle,
        reason: "busy=${controller.state.busy}, ${log.join(",")}",
      );
      expect(find.byKey(const ValueKey('voice-microphone')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
