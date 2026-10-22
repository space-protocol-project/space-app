import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/forum.dart';

import 'chat_examples_screenshots_test.dart' show captureExample;
import 'redesign_golden_test.dart' show loadFonts;
import 'forum_test.dart' show FakeForum;

Future<FakeForum> exampleForum() async {
  final api = FakeForum();
  api.sections.single.title = 'Обсуждения сообщества';
  final topic = await api.create(
    'forum',
    'Идеи для следующего обновления',
    'Давайте соберём предложения для Space. Что поможет вам в повседневном общении?',
    'ideas',
  );
  topic.authorName = 'Алиса';
  topic.createdAtUnix = Int64(1792659600);
  api.topics.first = topic;
  final second = await api.create(
    'forum',
    'Знакомимся с участниками',
    'Расскажите о себе и своих интересах.',
    'welcome',
  );
  second.authorName = 'София';
  second.createdAtUnix = Int64(1792656000);
  api.topics[1] = second;
  final third = await api.create(
    'forum',
    'Правила нашего пространства',
    'Уважайте собеседников и оставайтесь в рамках темы.',
    'rules',
  );
  third.authorName = 'Максим';
  third.closed = true;
  third.createdAtUnix = Int64(1792652400);
  api.topics[2] = third;
  for (final entry in [
    'Как вы организуете свои проекты?',
    'Первые впечатления от голосовых комнат',
    'Предлагаю встречу в пятницу вечером',
    'Вопросы по настройке Space',
    'Что почитать на выходных?',
  ]) {
    final added = await api.create('forum', entry, 'Обсуждаем вместе', entry);
    added.authorName = 'Борис';
    added.createdAtUnix = Int64(1792656000);
    api.topics[api.topics.length - 1] = added;
  }
  api.replies.addAll([
    ForumReply(
      id: 'reply-1',
      threadId: topic.id,
      authorId: 'boris',
      authorName: 'Борис',
      text: 'Хотелось бы закреплять важные темы, чтобы новые участники быстрее находили нужное.',
      sequence: Int64.ONE,
      createdAtUnix: Int64(1792660200),
    ),
    ForumReply(
      id: 'reply-2',
      threadId: topic.id,
      authorId: 'sofia',
      authorName: 'София',
      text: 'Поддерживаю! А отдельные разделы уже помогают не терять обсуждения среди сообщений.',
      sequence: Int64(2),
      createdAtUnix: Int64(1792660800),
    ),
  ]);
  topic.replyCount = Int64(2);
  topic.revision = Int64(3);
  return api;
}

void main() {
  final output = Platform.environment['SPACE_FORUM_SCREENSHOTS'];
  for (final width in [1280.0, 390.0]) {
    testWidgets('Снимки форума: $width', (tester) async {
      SharedPreferences.setMockInitialValues({'space.ui.dark': true});
      tester.view.physicalSize = Size(width, width < 600 ? 1400 : 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(loadFonts);
      final preferences = AppPreferences();
      final api = await exampleForum();
      api.pageSize = 50;
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
            home: Scaffold(body: ForumArea(api: api)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final size = width < 600 ? 'mobile' : 'desktop';
      await captureExample(tester, boundary, '$output/forum-topics-$size.png');
      await tester.tap(find.text('Идеи для следующего обновления'));
      await tester.pumpAndSettle();
      await captureExample(
        tester,
        boundary,
        '$output/forum-discussion-$size.png',
      );
      await tester.tap(find.byKey(const ValueKey('forum-actions')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Закрыть тему'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Закрыть тему'));
      await tester.pumpAndSettle();
      expect(find.text('Тема закрыта'), findsWidgets);
      await captureExample(tester, boundary, '$output/forum-closed-$size.png');
      await tester.pumpWidget(const SizedBox.shrink());
      preferences.dispose();
    }, skip: output == null);
  }
}
