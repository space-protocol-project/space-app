import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/ui/voice_rooms.dart';

import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia;

void main() {
  testWidgets('Панель разговора на 390px: участники, микрофон, звук и выход', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final log = <String>[];
    final api = FakeVoiceApi(log), media = FakeVoiceMedia(log);
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
  });
}
