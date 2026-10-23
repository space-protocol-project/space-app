import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/forum.dart';

import 'chat_examples_screenshots_test.dart' show captureExample;
import 'redesign_golden_test.dart' show loadFonts;
import 'forum_moderation_test.dart'
    show moderationExample, openModerationMenu, submitModeration;

void main() {
  final output = Platform.environment['SPACE_FORUM_MODERATION_SCREENSHOTS'];
  for (final width in [1280.0, 390.0]) {
    testWidgets('Снимки модерации форума: $width', (tester) async {
      SharedPreferences.setMockInitialValues({'space.ui.dark': true});
      tester.view.physicalSize = Size(width, width < 600 ? 1400 : 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(loadFonts);
      final preferences = AppPreferences();
      final api = await moderationExample();
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
      await tester.tap(find.text('Планы сообщества'));
      await tester.pumpAndSettle();
      final size = width < 600 ? 'mobile' : 'desktop';
      await openModerationMenu(tester, 'Открыть тему снова');
      await submitModeration(
        tester,
        'Встреча перенесена: продолжаем обсуждение.',
      );
      final scrollable = find
          .descendant(
            of: find.byType(ForumArea),
            matching: find.byType(Scrollable),
          )
          .first;
      tester.state<ScrollableState>(scrollable).position.jumpTo(0);
      await tester.pumpAndSettle();
      await captureExample(
        tester,
        boundary,
        '$output/forum-reopened-$size.png',
      );
      final replyActions = find.byKey(
        const ValueKey('forum-reply-actions-reply-1'),
      );
      await tester.ensureVisible(replyActions);
      await tester.tap(replyActions);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Скрыть ответ'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('forum-moderation-reason')),
        'В ответе опубликованы персональные данные.',
      );
      await tester.pumpAndSettle();
      await captureExample(
        tester,
        boundary,
        '$output/forum-moderation-reason-$size.png',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Подтвердить'));
      await tester.pumpAndSettle();
      await captureExample(
        tester,
        boundary,
        '$output/forum-hidden-reply-$size.png',
      );
      await tester.ensureVisible(find.byKey(const ValueKey('forum-actions')));
      await openModerationMenu(tester, 'Скрыть тему');
      await submitModeration(
        tester,
        'Проверяем соответствие правилам сообщества.',
      );
      await captureExample(
        tester,
        boundary,
        '$output/forum-hidden-topic-$size.png',
      );
      await openModerationMenu(tester, 'Восстановить тему');
      await submitModeration(tester, 'Проверка завершена, тема восстановлена.');
      await openModerationMenu(tester, 'Журнал модерации');
      await captureExample(
        tester,
        boundary,
        '$output/forum-moderation-log-$size.png',
      );
      await tester.pumpWidget(const SizedBox.shrink());
      preferences.dispose();
    }, skip: output == null);
  }
}
