import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/feed_api.dart';
import 'package:space_client/src/feed_controller.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/ui/feed.dart';

import 'feed_test.dart' show FakeFeed, app;

class ReadingFeed extends FakeFeed implements FeedReadApi {
  ReadingFeed() {
    entries.first.readStateSupported = true;
    entries.first.unreadCount = Int64(2);
  }
  @override
  bool readSupported = true;
  final marks = <int>[];
  Object? readFailure;
  Completer<FeedPost>? pendingRead;

  @override
  Future<FeedPost> markRead(String channel, String post, Int64 through) async {
    marks.add(through.toInt());
    if (pendingRead != null) return pendingRead!.future;
    if (readFailure != null) throw readFailure!;
    final index = entries.indexWhere((entry) => entry.id == post);
    final value = entries[index].deepCopy();
    value.seen = true;
    if (through > value.readSequence) value.readSequence = through;
    value.unreadCount = Int64(
      comments
          .where((c) => !c.hidden && c.sequence > value.readSequence)
          .length,
    );
    entries[index] = value;
    return value.deepCopy();
  }

  void addComment({bool hidden = false}) {
    comments.add(
      FeedComment(
        id: 'second',
        postId: 'post',
        text: 'Второй комментарий',
        sequence: Int64(2),
        hidden: hidden,
      ),
    );
    if (!hidden) entries.first.unreadCount += Int64.ONE;
  }
}

void main() {
  test(
    'страницы не подтверждают чтение, отметка ограничена загруженным',
    () async {
      final api = ReadingFeed()..addComment();
      final controller = FeedController(api);
      addTearDown(controller.close);
      await controller.refresh();
      await controller.open('post');
      expect(api.marks, isEmpty);
      await controller.markVisible(0);
      expect(controller.state.post!.seen, true);
      expect(controller.state.post!.unreadCount, Int64(2));
      await controller.markRead();
      expect(api.marks, [0, 1]);
      expect(controller.state.post!.unreadCount, Int64.ONE);
      await controller.more();
      await controller.markRead();
      await controller.markVisible(0);
      expect(api.marks, [0, 1, 2]);
      expect(controller.state.posts.single.unreadCount, Int64.ZERO);
    },
  );

  test('поиск не подтверждает пропущенные комментарии', () async {
    final api = ReadingFeed()..addComment();
    final controller = FeedController(api);
    addTearDown(controller.close);
    await controller.refresh();
    await controller.open('post', afterSequence: 1);
    expect(controller.state.comments.single.sequence, Int64(2));
    expect(controller.readHasGap, true);
    await controller.markVisible(2);
    await controller.markRead();
    expect(api.marks, [0]);
    expect(controller.state.post!.unreadCount, Int64(2));
    await controller.openUnread();
    expect(controller.readHasGap, false);
    expect(controller.state.comments.single.sequence, Int64.ONE);
    await controller.markRead();
    expect(api.marks, [0, 1]);
    expect(controller.state.post!.unreadCount, Int64.ONE);
  });

  test('скрытый комментарий и старый сервер не получают отметки', () async {
    final api = ReadingFeed()
      ..addComment(hidden: true)
      ..pageSize = 5;
    final controller = FeedController(api);
    addTearDown(controller.close);
    await controller.refresh();
    await controller.open('post');
    await controller.markRead();
    expect(api.marks, [1]);
    api.readSupported = false;
    await controller.markVisible(2);
    expect(api.marks, [1]);
    final old = FeedController(FakeFeed());
    addTearDown(old.close);
    await old.refresh();
    await old.open('post');
    expect(old.readingSupported, false);
    await old.markRead();
  });

  test('поздний ответ после смены раздела не возвращает публикацию', () async {
    final api = ReadingFeed()..pendingRead = Completer<FeedPost>();
    final controller = FeedController(api);
    addTearDown(controller.close);
    await controller.refresh();
    await controller.open('post');
    final pending = controller.markVisible(1);
    await controller.select(api.sections.last);
    api.pendingRead!.complete(api.entries.first.deepCopy()..seen = true);
    await pending;
    expect(controller.state.section!.id, 'second');
    expect(controller.state.post, isNull);
    expect(controller.state.posts, isEmpty);
  });

  test('сбой не создаёт цикл запросов, отзыв прав очищает данные', () async {
    final api = ReadingFeed()..readFailure = const GrpcError.unavailable();
    final controller = FeedController(api);
    addTearDown(controller.close);
    await controller.refresh();
    await controller.open('post');
    await controller.markVisible(1);
    await controller.markVisible(1);
    expect(api.marks, [1]);
    expect(controller.state.post!.seen, false);
    api.readFailure = const GrpcError.permissionDenied();
    await controller.markRead();
    expect(controller.state.post, isNull);
    expect(controller.state.posts, isEmpty);
    expect(controller.state.error, isA<GrpcError>());
  });

  testWidgets('смена источника закрывает прежнее чтение и убирает его данные', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final first = ReadingFeed()..pendingRead = Completer<FeedPost>();
    await tester.pumpWidget(app(FeedArea(api: first)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Комментарии · 0'));
    await tester.pumpAndSettle();
    expect(first.marks, isNotEmpty);
    final second = ReadingFeed();
    second.entries.first.text = 'Другая лента';
    await tester.pumpWidget(app(FeedArea(api: second)));
    await tester.pumpAndSettle();
    first.pendingRead!.complete(first.entries.first.deepCopy()..seen = true);
    await tester.pumpAndSettle();
    expect(find.text('Другая лента'), findsOneWidget);
    expect(find.text('Первая запись'), findsNothing);
    expect(second.marks, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'чтение только после конца видимой записи, фон и вкладка не читают',
    (tester) async {
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      final api = ReadingFeed();
      api.comments.first.text = List.filled(
        100,
        'Длинный комментарий',
      ).join('\n');
      await tester.pumpWidget(app(FeedArea(api: api, active: false)));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('feed-unread-post')), findsOneWidget);
      expect(api.marks, isEmpty);
      await tester.tap(find.text('Комментарии · 0'));
      await tester.pumpAndSettle();
      expect(api.marks, isEmpty);
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pumpWidget(app(FeedArea(api: api)));
      await tester.pumpAndSettle();
      expect(api.marks, isEmpty);
      for (final state in [
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pumpAndSettle();
      expect(api.marks, [0]);
      final comment = find.byKey(const ValueKey('feed-comment-comment'));
      await Scrollable.ensureVisible(tester.element(comment), alignment: 1);
      await tester.pumpAndSettle();
      expect(api.marks, [0, 1]);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
