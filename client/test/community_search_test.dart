import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/community_search.dart';
import 'package:space_client/src/feed_controller.dart';
import 'package:space_client/src/forum_controller.dart';
import 'package:space_client/src/generated/space/v1/community_search.pb.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/ui/community_search.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/forum.dart';

import 'feed_test.dart' show FakeFeed;
import 'forum_test.dart' show FakeForum;

class SearchApi implements CommunitySearchApi {
  final calls = <({String channel, String query, String token})>[];
  final pending = <Completer<SearchCommunityContentResponse>>[];
  @override
  Future<SearchCommunityContentResponse> search(
    String channel,
    String query,
    String token,
  ) {
    calls.add((channel: channel, query: query, token: token));
    final response = Completer<SearchCommunityContentResponse>();
    pending.add(response);
    return response.future;
  }

  void complete(int index, String id, {String next = ''}) =>
      pending[index].complete(
        SearchCommunityContentResponse(
          results: [
            CommunitySearchResult(
              id: id,
              parentId: 'parent',
              snippet: 'Найденный текст',
            ),
          ],
          nextPageToken: next,
        ),
      );
}

Widget localized(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  test(
    'новый запрос, отзыв доступа и закрытие отбрасывают поздние ответы',
    () async {
      final api = SearchApi();
      final controller = CommunitySearchController(api, 'chosen');
      final old = controller.submit(' старый ');
      final current = controller.submit('новый');
      api.complete(1, 'new');
      await current;
      api.complete(0, 'old');
      await old;
      expect(controller.state.results.single.id, 'new');
      expect(api.calls.first.channel, 'chosen');
      expect(api.calls.first.query, 'старый');
      final late = controller.submit('третий');
      controller.invalidate();
      api.complete(2, 'forbidden');
      await late;
      expect(controller.state.revoked, isTrue);
      expect(controller.state.results, isEmpty);
      await controller.close();
    },
  );

  test('пагинация не дублирует запрос и очищает выдачу при запрете', () async {
    final api = SearchApi();
    final controller = CommunitySearchController(api, 'chosen');
    final first = controller.submit('слово');
    api.complete(0, 'one', next: 'cursor');
    await first;
    final more = controller.more();
    await controller.more();
    expect(api.calls.length, 2);
    expect(api.calls.last.token, 'cursor');
    api.complete(1, 'two', next: 'next');
    await more;
    expect(controller.state.results.map((r) => r.id), ['one', 'two']);
    final denied = controller.more();
    api.pending[2].completeError(const GrpcError.permissionDenied());
    await denied;
    expect(controller.state.results, isEmpty);
    expect(controller.state.next, isEmpty);
    expect(controller.state.error, isA<GrpcError>());
    await controller.submit(' ');
    await controller.submit(List.filled(129, 'я').join());
    expect(controller.state.invalid, isTrue);
    expect(api.calls.length, 3);
    await controller.close();
  });

  test('ответ после закрытия не меняет состояние', () async {
    final api = SearchApi();
    final controller = CommunitySearchController(api, 'chosen');
    final request = controller.submit('слово');
    await controller.close();
    api.complete(0, 'late');
    await request;
  });

  testWidgets('узкое окно, Enter, потеря раздела и поздний ответ', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final api = SearchApi();
    final changes = StreamController<Object?>.broadcast();
    var available = true;
    await tester.pumpWidget(
      localized(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showCommunitySearch(
              context,
              api: api,
              channel: 'chosen',
              title: 'Раздел',
              changes: changes.stream,
              available: () => available,
            ),
            child: const Text('Открыть'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'слово');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    api.complete(0, 'first');
    await tester.pumpAndSettle();
    expect(find.text('Найденный текст'), findsOneWidget);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.view.resetViewInsets();
    available = false;
    changes.add(null);
    await tester.pumpAndSettle();
    expect(find.text('Найденный текст'), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await changes.close();
  });

  testWidgets('старый сервер скрывает поиск в ленте и форуме', (tester) async {
    await tester.pumpWidget(localized(FeedArea(api: FakeFeed())));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Поиск в разделе'), findsNothing);
    await tester.pumpWidget(localized(ForumArea(api: FakeForum())));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('forum-actions')).first);
    await tester.pumpAndSettle();
    expect(find.text('Поиск в разделе'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  test('переход к комментарию начинает страницу с его позиции', () async {
    final api = FakeFeed();
    api.comments.add(
      FeedComment(
        id: 'target',
        postId: 'post',
        sequence: Int64(70),
        text: 'Найденный',
      ),
    );
    final controller = FeedController(api);
    await controller.refresh();
    await controller.open('post', afterSequence: 69);
    expect(controller.state.error, isNull);
    expect(controller.state.comments.single.id, 'target');
    await controller.close();
    final source = FakeForum();
    source.topics.add(
      ForumThread(id: 'topic', channelId: 'forum', title: 'Тема'),
    );
    source.replies.addAll([
      ForumReply(id: 'old', threadId: 'topic', sequence: Int64.ONE),
      ForumReply(id: 'target', threadId: 'topic', sequence: Int64(70)),
    ]);
    final forum = ForumController(source);
    await forum.refresh();
    expect(await forum.openSearchResult('topic', 70), isTrue);
    expect(forum.state.replies.single.id, 'target');
    await forum.close();
  });
}
