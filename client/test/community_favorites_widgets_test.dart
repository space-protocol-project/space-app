import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/community_favorites_api.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/community_favorites.dart';
import 'package:space_client/ui/community_favorite_list.dart';

import 'community_reactions_widgets_test.dart' show localized;
import 'forum_test.dart' show FakeForum;
import 'feed_test.dart' show FakeFeed;
import 'support/community_favorites.dart';

class FavoriteForum extends FakeForum implements CommunityFavoriteSource {
  @override
  final FakeCommunityFavorites communityFavorites = FakeCommunityFavorites();
}

class FavoriteFeed extends FakeFeed implements CommunityFavoriteSource {
  @override
  final FakeCommunityFavorites communityFavorites = FakeCommunityFavorites();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('Снятая закладка сразу исчезает из списка', (tester) async {
    final api = FakeCommunityFavorites();
    api.value(favoriteRef('one')).saved = true;
    final changes = StreamController<Object?>.broadcast();
    addTearDown(changes.close);
    await tester.pumpWidget(
      localized(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showCommunityFavorites(
              context,
              api: api,
              channel: 'forum',
              changes: changes.stream,
              available: () => true,
            ),
            child: const Text('Открыть'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();
    expect(find.text('Тема one'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('favorite-1:one')));
    await tester.pumpAndSettle();
    expect(find.text('Тема one'), findsNothing);
    expect(find.text('В этом разделе пока нет избранного.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  for (final width in [360.0, 1280.0]) {
    testWidgets(
      'Форум: сохранение закрытой темы и ответа без права записи: $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 1200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final api = FavoriteForum();
        api.sections.first.permissions.write = false;
        api.topics.add(
          ForumThread(
            id: 'topic',
            channelId: 'forum',
            title: 'Тема',
            text: 'Текст',
            closed: true,
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
          ),
        );
        await tester.pumpWidget(
          localized(ForumArea(api: api, initialThread: 'topic')),
        );
        await tester.pumpAndSettle();
        final button = find.byKey(const ValueKey('favorite-1:topic'));
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(api.communityFavorites.requests.single.saved, isTrue);
        expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(api.communityFavorites.requests.last.saved, isFalse);
        final reply = find.byKey(const ValueKey('favorite-2:reply'));
        await tester.ensureVisible(reply);
        await tester.tap(reply);
        await tester.pumpAndSettle();
        expect(api.communityFavorites.requests.last.content.kind.value, 2);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
  testWidgets('Лента: публикация, комментарий и скрытое содержимое', (
    tester,
  ) async {
    final api = FavoriteFeed();
    api.comments.add(
      FeedComment(
        id: 'hidden',
        postId: 'post',
        hidden: true,
        sequence: Int64(2),
      ),
    );
    await tester.pumpWidget(localized(FeedArea(api: api, initialPost: 'post')));
    await tester.pumpAndSettle();
    for (final key in ['favorite-3:post', 'favorite-4:comment']) {
      final button = find.byKey(ValueKey(key));
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
    }
    expect(api.communityFavorites.requests.map((r) => r.content.kind.value), [
      3,
      4,
    ]);
    expect(find.byKey(const ValueKey('favorite-4:hidden')), findsNothing);
    expect(
      api.communityFavorites.pages
          .expand((p) => p)
          .any((r) => r.id == 'hidden'),
      isFalse,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Избранное: список выбранного раздела возвращает точный ответ', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final api = FakeCommunityFavorites();
    api.onList = (_) async => ListCommunityFavoritesResponse(
      favorites: [favoriteItem('reply', kind: 2)],
    );
    final changes = StreamController<Object?>.broadcast();
    addTearDown(changes.close);
    CommunitySearchResult? selected;
    await tester.pumpWidget(
      localized(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              selected = await showCommunityFavorites(
                context,
                api: api,
                channel: 'forum',
                changes: changes.stream,
                available: () => true,
              );
            },
            child: const Text('Открыть'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();
    expect(find.text('Тема reply'), findsOneWidget);
    await tester.tap(find.text('Тема reply'));
    await tester.pumpAndSettle();
    expect(selected!.id, 'reply');
    expect(selected!.parentId, 'parent');
    expect(selected!.sequence, Int64(3));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'Поздний ответ прежнего контекста не возвращает кнопку закладки',
    (tester) async {
      final old = FakeCommunityFavorites();
      final next = FakeCommunityFavorites();
      final ref = favoriteRef('one');
      final pending = Completer<GetCommunityFavoriteStatesResponse>();
      old.onStates = (_) => pending.future;
      Widget scope(FakeCommunityFavorites api, {bool active = true}) =>
          localized(
            CommunityFavoriteScope(
              key: const ValueKey('scope'),
              api: api,
              channel: 'forum',
              contents: [ref],
              active: active,
              child: CommunityFavoriteButton(content: ref),
            ),
          );
      await tester.pumpWidget(scope(old));
      await tester.pump();
      await tester.pumpWidget(scope(next, active: false));
      pending.complete(
        GetCommunityFavoriteStatesResponse(
          states: [CommunityFavoriteState(content: ref, saved: true)],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('Убрать из избранного'), findsNothing);
      expect(find.byKey(const ValueKey('favorite-1:one')), findsNothing);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
