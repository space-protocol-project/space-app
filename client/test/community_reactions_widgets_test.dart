import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/emoji_catalog.dart';

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/community_reactions_api.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/ui/community_reactions.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/forum.dart';

import 'feed_test.dart' show FakeFeed;
import 'forum_test.dart' show FakeForum;
import 'support/community_reactions.dart';

class ReactionForum extends FakeForum implements CommunityReactionSource {
  @override
  final FakeCommunityReactions communityReactions = FakeCommunityReactions();
}

class ReactionFeed extends FakeFeed implements CommunityReactionSource {
  @override
  final FakeCommunityReactions communityReactions = FakeCommunityReactions();
}

Widget localized(Widget child, {double scale = 1}) => MaterialApp(
  locale: const Locale('ru'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Builder(
    builder: (context) => Scaffold(
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child,
      ),
    ),
  ),
);

Future<void> chooseThumb(WidgetTester tester, Finder add) async {
  await tester.ensureVisible(add);
  await tester.runAsync(EmojiCatalog.load);
  await tester.tap(add);
  await tester.pump();
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 300)),
  );
  await tester.pumpAndSettle();
  await tester.enterText(
    find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)),
    '👍',
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find.descendant(of: find.byType(GridView), matching: find.text('👍')),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  for (final width in [360.0, 1280.0]) {
    testWidgets(
      'Форум: реакция темы и ответа, выбор emoji и удаление: $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 1200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final api = ReactionForum();
        api.topics.add(
          ForumThread(
            id: 'topic',
            channelId: 'forum',
            title: 'Тема',
            text: 'Текст темы',
            sequence: Int64.ONE,
            revision: Int64.ONE,
          ),
        );
        api.replies.add(
          ForumReply(
            id: 'reply',
            threadId: 'topic',
            text: 'Ответ',
            sequence: Int64.ONE,
            revision: Int64.ONE,
          ),
        );
        await tester.pumpWidget(
          localized(ForumArea(api: api, initialThread: 'topic')),
        );
        await tester.pumpAndSettle();
        final add = find.byKey(const ValueKey('reaction-add-1:topic'));
        await chooseThumb(tester, add);
        expect(api.communityReactions.requests.single.content.kind.value, 1);
        expect(find.text('👍 1'), findsOneWidget);
        final chip = find.byKey(const ValueKey('reaction-1:topic-👍'));
        expect(tester.widget<InputChip>(chip).selected, isTrue);
        await tester.ensureVisible(chip);
        await tester.tap(chip);
        await tester.pumpAndSettle();
        expect(api.communityReactions.requests.last.active, isFalse);
        expect(find.text('👍 1'), findsNothing);
        expect(
          find.byKey(const ValueKey('reaction-add-2:reply')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets(
    'Лента: публикация и комментарий, скрытый комментарий не запрашивается',
    (tester) async {
      final api = ReactionFeed();
      api.comments.add(
        FeedComment(
          id: 'hidden',
          postId: 'post',
          hidden: true,
          sequence: Int64(2),
        ),
      );
      await tester.pumpWidget(
        localized(FeedArea(api: api, initialPost: 'post')),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('reaction-add-3:post')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('reaction-add-4:comment')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('reaction-add-4:hidden')), findsNothing);
      expect(
        api.communityReactions.pages
            .expand((p) => p)
            .any((r) => r.id == 'hidden'),
        isFalse,
      );
      final add = find.byKey(const ValueKey('reaction-add-4:comment'));
      await chooseThumb(tester, add);
      expect(api.communityReactions.requests.single.content.kind.value, 4);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Только чтение и крупный шрифт: счётчики видны, изменить нельзя',
    (tester) async {
      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = FakeCommunityReactions();
      final ref = reactionRef('readonly');
      api.value(ref)
        ..canReact = false
        ..reactions.add(
          CommunityReaction(
            emoji: '👍',
            count: Int64.MAX_VALUE,
            selected: true,
          ),
        );
      await tester.pumpWidget(
        localized(
          CommunityReactionScope(
            api: api,
            channel: 'forum',
            contents: [ref],
            active: true,
            child: CommunityReactionBar(content: ref),
          ),
          scale: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('👍 9223372036854775807'), findsOneWidget);
      final chip = tester.widget<InputChip>(find.byType(InputChip));
      expect(chip.onSelected, isNull);
      expect(chip.selected, isTrue);
      expect(find.byTooltip('Добавить реакцию'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('Смена пространства и отзыв доступа убирают старые счётчики', (
    tester,
  ) async {
    final old = FakeCommunityReactions();
    final ref = reactionRef('same_id');
    final pending = Completer<ListCommunityReactionsResponse>();
    old.onList = (_) => pending.future;
    Widget scope(FakeCommunityReactions api, {bool active = true}) => localized(
      CommunityReactionScope(
        key: const ValueKey('scope'),
        api: api,
        channel: 'forum',
        contents: [ref],
        active: active,
        child: CommunityReactionBar(content: ref),
      ),
    );
    await tester.pumpWidget(scope(old));
    await tester.pumpAndSettle();
    final fresh = FakeCommunityReactions();
    fresh
        .value(ref)
        .reactions
        .add(CommunityReaction(emoji: '🔥', count: Int64(9)));
    await tester.pumpWidget(scope(fresh));
    await tester.pumpAndSettle();
    expect(find.text('🔥 9'), findsOneWidget);
    pending.complete(ListCommunityReactionsResponse(states: [old.value(ref)]));
    await tester.pumpAndSettle();
    expect(find.text('🔥 9'), findsOneWidget);
    fresh.scopeId = 'new-principal';
    fresh.values.clear();
    fresh
        .value(ref)
        .reactions
        .add(CommunityReaction(emoji: '🔥', count: Int64(2)));
    await tester.pumpWidget(scope(fresh));
    await tester.pumpAndSettle();
    expect(find.text('🔥 9'), findsNothing);
    expect(find.text('🔥 2'), findsOneWidget);
    fresh.onList = (_) async => throw const GrpcError.permissionDenied();
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(find.text('🔥 9'), findsNothing);
    expect(
      find.text('Реакции недоступны: доступ или состояние раздела изменились.'),
      findsOneWidget,
    );
    await tester.pumpWidget(scope(fresh, active: false));
    await tester.pumpAndSettle();
    expect(find.byType(InputChip), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
