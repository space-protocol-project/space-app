import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/voice_activity.dart';
import 'package:space_client/ui/voice_roster.dart';

StatsReport audio(double energy, double seconds, int packets) =>
    StatsReport('remote', 'inbound-rtp', 0, {
      'trackIdentifier': 'speaker-2',
      'totalAudioEnergy': energy,
      'totalSamplesDuration': seconds,
      'packetsReceived': packets,
    });

void main() {
  test('Речь определяется свежей энергией, тишина и старые пакеты не подсвечиваются', () {
    final levels = VoiceAudioLevels();
    expect(levels.read([audio(0, 1, 10)]), isEmpty);
    expect(levels.read([audio(.01, 2, 20)]), {2});
    expect(levels.read([audio(.01, 3, 30)]), isEmpty);
    expect(levels.read([audio(.02, 4, 30)]), isEmpty);
    expect(levels.read([audio(0, 0, 1)]), isEmpty);
    expect(levels.read([]), isEmpty);
  });

  testWidgets('У каждого участника аватар, рамка только при речи', (
    tester,
  ) async {
    final people = [
      VoiceParticipant(sessionId: 'one', nickname: 'Первый'),
      VoiceParticipant(sessionId: 'two', nickname: 'Второй', muted: true),
    ];
    Future<void> show(Set<String> speaking) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: Scaffold(
          body: VoiceRoster(people: people, speaking: speaking),
        ),
      ),
    );
    await show({});
    expect(find.byType(CircleAvatar), findsNWidgets(2));
    expect(
      find.byKey(const ValueKey('voice-avatar-one-false')),
      findsOneWidget,
    );
    await show({'one', 'two'});
    await tester.pumpAndSettle();
    final avatar = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('voice-avatar-one-true')),
    );
    final border = (avatar.decoration! as BoxDecoration).border! as Border;
    expect(border.top.color, isNot(Colors.transparent));
    expect(
      find.byKey(const ValueKey('voice-avatar-two-false')),
      findsOneWidget,
    );
    await show({});
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('voice-avatar-one-false')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
