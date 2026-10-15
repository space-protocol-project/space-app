import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/member_profile.dart';

import 'shell_test.dart' show TestController;

class ProfileSession implements MemberProfile {
  String nickname = 'Алиса';
  bool taken = false;
  @override
  Future<String> getNickname() async => nickname;
  @override
  Future<void> setNickname(String value) async {
    if (taken) throw const GrpcError.alreadyExists('taken');
    nickname = value;
  }
}

class ProfileChat extends TestController {
  ProfileChat(this.profile);
  final MemberProfile profile;
  @override
  MemberProfile? get memberProfile => profile;
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
    session.taken = true;
    await tester.tap(find.text('Сохранить имя'));
    await tester.pumpAndSettle();
    expect(find.text('Это имя уже занято. Выберите другое.'), findsOneWidget);
    expect(tester.widget<TextField>(field).controller!.text, 'Боб');
    expect(session.nickname, 'Алиса');
    session.taken = false;
    await tester.tap(find.text('Сохранить имя'));
    await tester.pumpAndSettle();
    expect(session.nickname, 'Боб');
    expect(find.text('Имя сохранено'), findsOneWidget);
    await tester.enterText(field, '');
    await tester.tap(find.text('Сохранить имя'));
    await tester.pumpAndSettle();
    expect(session.nickname, '');
    expect(tester.takeException(), isNull);
  });

  test('Профили разных пространств независимы', () async {
    final first = ProfileSession(), second = ProfileSession();
    final profile = MemberProfileController(first);
    addTearDown(profile.close);
    await profile.load();
    await profile.save('Новое имя');
    expect(first.nickname, 'Новое имя');
    expect(second.nickname, 'Алиса');
  });
}
