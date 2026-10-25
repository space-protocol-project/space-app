import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/member_avatar.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/member_profile.dart';
import 'package:space_client/ui/participant_profile.dart';
import 'package:space_client/ui/message_bubble.dart';

import 'member_profile_test.dart' show ProfileChat;
import 'support/participant_profiles.dart';

Widget localized(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: child),
);

void main() {
  for (final width in [360.0, 1280.0]) {
    testWidgets('редактор аватара и имени, смена пространства: $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = FakeParticipantProfiles()..value.avatarPng = sampleAvatar();
      final chat = ProfileChat(api);
      addTearDown(chat.close);
      await tester.pumpWidget(
        localized(
          SingleChildScrollView(child: MemberProfileCard(controller: chat)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Аватар в пространстве'), findsOneWidget);
      expect(
        tester.widgetList<MemberAvatar>(find.byType(MemberAvatar)).single.data,
        isNotEmpty,
      );
      await tester.tap(find.byKey(const ValueKey('profile-remove-avatar')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('member-nickname')),
        'Борис',
      );
      await tester.tap(find.text('Сохранить профиль'));
      await tester.pumpAndSettle();
      expect(api.value.avatarPng, isEmpty);
      expect(api.value.displayName, 'Борис');
      expect(find.text('Профиль сохранён'), findsOneWidget);
      final second = FakeParticipantProfiles()
        ..value.displayName = 'Другой участник';
      final other = ProfileChat(second);
      addTearDown(other.close);
      await tester.pumpWidget(localized(MemberProfileCard(controller: other)));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('member-nickname')))
            .controller!
            .text,
        'Другой участник',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets(
    'текущий профиль автора меняется, текст сообщения и упоминание сохраняются',
    (tester) async {
      final api = FakeParticipantProfiles()..value.avatarPng = sampleAvatar();
      Widget scope({bool active = true}) => localized(
        ParticipantProfileScope(
          api: api,
          channel: 'chat',
          ids: const ['u_alice'],
          active: active,
          child: const MessageBubble(
            text: '@Алиса привет',
            author: 'Снимок имени',
            authorId: 'u_alice',
            mine: false,
          ),
        ),
      );
      await tester.pumpWidget(scope());
      await tester.pumpAndSettle();
      expect(find.text('Алиса'), findsOneWidget);
      expect(find.textContaining('@Алиса'), findsWidgets);
      api.value.displayName = 'Новое имя';
      await tester.pump(const Duration(seconds: 31));
      await tester.pumpAndSettle();
      expect(find.text('Новое имя'), findsOneWidget);
      expect(find.textContaining('@Алиса'), findsWidgets);
      expect(
        api.queries.every((q) => q.$1 == 'chat' && q.$2.single == 'u_alice'),
        isTrue,
      );
      await tester.pumpWidget(scope(active: false));
      await tester.pumpAndSettle();
      expect(find.text('Новое имя'), findsNothing);
      expect(find.text('Снимок имени'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('поздний профиль старого пространства не появляется в новом', (
    tester,
  ) async {
    final first = FakeParticipantProfiles()
      ..listing = Completer<List<ParticipantProfile>>();
    final second = FakeParticipantProfiles()
      ..value.displayName = 'Второе пространство';
    Widget scope(FakeParticipantProfiles api, String channel) => localized(
      ParticipantProfileScope(
        api: api,
        channel: channel,
        ids: const ['u_alice'],
        child: const ParticipantName(principal: 'u_alice', fallback: 'ID'),
      ),
    );
    await tester.pumpWidget(scope(first, 'one'));
    await tester.pumpWidget(scope(second, 'two'));
    await tester.pumpAndSettle();
    first.listing!.complete([
      ParticipantProfile(
        principalId: 'u_alice',
        displayName: 'Старое пространство',
      ),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Второе пространство'), findsOneWidget);
    expect(find.text('Старое пространство'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
