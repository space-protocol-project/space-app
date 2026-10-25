import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/member_profile.dart';

import 'support/participant_profiles.dart';

import 'shell_test.dart' show TestController;

class ProfileSession extends FakeParticipantProfiles {}

class ProfileChat extends TestController {
  ProfileChat(this.profile);
  final ParticipantProfiles profile;
  @override
  ParticipantProfiles? get memberProfile => profile;
}

void main() {
  testWidgets('Смена имени, занятое имя, сохранение ввода и очистка', (
    tester,
  ) async {
    final session = ProfileSession();
    final chat = ProfileChat(session);
    addTearDown(chat.close);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: MemberProfileCard(controller: chat)),
      ),
    );
    await tester.pumpAndSettle();
    final field = find.byKey(const ValueKey('member-nickname'));
    expect(tester.widget<TextField>(field).controller!.text, 'Алиса');
    await tester.enterText(field, 'Боб');
    session.failure = const GrpcError.alreadyExists('taken');
    await tester.tap(find.text('Сохранить профиль'));
    await tester.pumpAndSettle();
    expect(find.text('Это имя уже занято. Выберите другое.'), findsOneWidget);
    expect(tester.widget<TextField>(field).controller!.text, 'Боб');
    expect(session.value.displayName, 'Алиса');
    session.failure = null;
    await tester.tap(find.text('Сохранить профиль'));
    await tester.pumpAndSettle();
    expect(session.value.displayName, 'Боб');
    expect(find.text('Профиль сохранён'), findsOneWidget);
    await tester.enterText(field, '');
    await tester.tap(find.text('Сохранить профиль'));
    await tester.pumpAndSettle();
    expect(session.value.displayName, '');
    expect(tester.takeException(), isNull);
  });

  test('Профили разных пространств независимы', () async {
    final first = ProfileSession(), second = ProfileSession();
    final profile = MemberProfileController(first);
    addTearDown(profile.close);
    await profile.load();
    await profile.save('Новое имя');
    expect(first.value.displayName, 'Новое имя');
    expect(second.value.displayName, 'Алиса');
  });
}
