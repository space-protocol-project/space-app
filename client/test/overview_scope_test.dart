import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Channel;
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/panels.dart';

import 'channels_test.dart' show chat;
import 'shell_test.dart' show TestController;
import 'member_profile_test.dart' show ProfileSession;

import 'package:space_client/src/core.dart' show MemberProfile;

class OverviewController extends TestController {
  OverviewController(this.name, this.channel) {
    profile.nickname = '$channel-ник';
  }
  final profile = ProfileSession();
  @override
  MemberProfile? get memberProfile => profile;
  final String name, channel;
  @override
  String get spaceTitle => name;
  @override
  String get knownOrigin => 'https://$channel.test';
  @override
  List<Channel> get channels => [
    chat(channel),
    chat('archived', archived: true),
  ];
  @override
  int unreadCount(String id) => id == channel ? 3 : 0;
}

void main() {
  for (final width in [390.0, 1680.0]) {
    testWidgets('Обзор содержит только выбранное пространство: $width', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final first = OverviewController('Первое пространство', 'first')
        ..connected = true;
      final second = OverviewController('Второе пространство', 'second')
        ..connected = true;
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      String? opened;
      Future<void> show(OverviewController controller) => tester.pumpWidget(
        MaterialApp(
          theme: AppPreferences().theme,
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: OverviewPanel(
              controller: controller,
              openChat: () {},
              openChannel: (id) => opened = id,
            ),
          ),
        ),
      );
      await show(first);
      await tester.pumpAndSettle();
      expect(find.text('Первое пространство'), findsOneWidget);
      expect(find.text('Свое имя в этом пространстве'), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('member-nickname')))
            .controller!
            .text,
        'first-ник',
      );
      expect(find.text('https://first.test'), findsOneWidget);
      expect(find.text('Мой домашний сервер'), findsNothing);
      expect(find.text('Выйти в эфир'), findsNothing);
      expect(find.text('Добавить пространство'), findsNothing);
      expect(
        find.byKey(const ValueKey('overview-channel-archived')),
        findsNothing,
      );
      await show(second);
      await tester.pumpAndSettle();
      expect(find.text('Первое пространство'), findsNothing);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('member-nickname')))
            .controller!
            .text,
        'second-ник',
      );
      expect(find.text('Чат first'), findsNothing);
      final channel = find.byKey(const ValueKey('overview-channel-second'));
      await tester.ensureVisible(channel);
      await tester.tap(channel);
      expect(opened, 'second');
      expect(tester.takeException(), isNull);
    });
  }
}
