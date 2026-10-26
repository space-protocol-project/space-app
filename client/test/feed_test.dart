import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart' hide View;
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart' show AttachmentSession;
import 'package:space_client/src/feed_api.dart';
import 'package:space_client/src/feed_controller.dart';
import 'package:space_client/src/feed_management.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart'
    show Channel, ChannelPermissions, View;
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/feed_management.dart';

class FakeFeed implements FeedApi {
  @override
  bool socialSupported = true;
  @override
  bool supported = true;
  @override
  bool attachmentsEnabled = false;
  @override
  AttachmentSession? get attachmentSession => null;
  @override
  List<Channel> sections = [
    for (final id in ['first', 'second'])
      Channel(
        id: id,
        title: id,
        views: [View(type: 'feed')],
        permissions: ChannelPermissions(visible: true, read: true),
      ),
  ];
  FeedPermissions permissions = FeedPermissions(publish: true, comment: true);
  final entries = <FeedPost>[
    FeedPost(
      id: 'post',
      channelId: 'first',
      text: 'Первая запись',
      sequence: Int64.ONE,
      revision: Int64.ONE,
    ),
  ];
  final comments = <FeedComment>[
    FeedComment(
      id: 'comment',
      postId: 'post',
      text: 'Первый комментарий',
      sequence: Int64.ONE,
      revision: Int64.ONE,
    ),
  ];
  final keys = <String>[];
  final accepted = <String, FeedPost>{};
  Completer<ListFeedPostsResponse>? pending;
  Object? refreshFailure;
  bool loseResponse = false, hideOnMore = false, reportsDenied = false;
  int pageSize = 1, next = 2;
  @override
  Future<void> refresh() async {
    if (refreshFailure != null) throw refreshFailure!;
  }

  @override
  Future<ListFeedPostsResponse> posts(String channel, Int64 before) async {
    if (channel == 'first' && pending != null) return pending!.future;
    final all =
        entries
            .where(
              (p) =>
                  p.channelId == channel &&
                  (before == Int64.ZERO || p.sequence < before),
            )
            .toList()
          ..sort((a, b) => b.sequence.compareTo(a.sequence));
    final page = all.take(pageSize).map((p) => p.deepCopy()).toList();
    return ListFeedPostsResponse(
      posts: page,
      nextBeforeSequence: all.length > pageSize
          ? page.last.sequence
          : Int64.ZERO,
      permissions: permissions.deepCopy(),
    );
  }

  @override
  Future<GetFeedPostResponse> post(
    String channel,
    String id,
    Int64 after,
  ) async {
    final item = entries.firstWhere((p) => p.id == id).deepCopy();
    if (hideOnMore && after > Int64.ZERO) {
      item
        ..hidden = true
        ..text = '';
    }
    final all = comments
        .where((c) => c.postId == id && c.sequence > after)
        .toList();
    final page = item.hidden
        ? <FeedComment>[]
        : all.take(pageSize).map((c) => c.deepCopy()).toList();
    return GetFeedPostResponse(
      post: item,
      comments: page,
      nextSequence: !item.hidden && all.length > pageSize
          ? page.last.sequence
          : Int64.ZERO,
      permissions: permissions.deepCopy(),
    );
  }

  @override
  Future<CreateFeedPostResponse> publish(CreateFeedPostRequest request) async {
    keys.add(request.idempotencyKey);
    final post = accepted.putIfAbsent(request.idempotencyKey, () {
      final post = FeedPost(
        id: 'created-${next++}',
        channelId: request.channelId,
        text: request.text,
        sequence: Int64(next),
        revision: Int64.ONE,
      );
      entries.add(post);
      return post;
    });
    if (loseResponse) {
      loseResponse = false;
      throw const GrpcError.unavailable();
    }
    return CreateFeedPostResponse(post: post.deepCopy());
  }

  @override
  Future<CommentFeedPostResponse> comment(
    CommentFeedPostRequest request,
  ) async {
    keys.add(request.idempotencyKey);
    return CommentFeedPostResponse(
      comment: FeedComment(id: 'new-comment', text: request.text),
      post: entries.first.deepCopy(),
    );
  }

  @override
  Future<ListFeedReportsResponse> reports(
    String channel,
    Int64 after,
    bool resolved,
  ) async {
    if (reportsDenied) throw const GrpcError.permissionDenied();
    return ListFeedReportsResponse(
      reports: [FeedReport(id: Int64.ONE, postId: 'post', reason: 'Проверка')],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget app(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: child),
);

void main() {
  test('ответ прежнего раздела не заменяет выбранную ленту', () async {
    final api = FakeFeed()..pending = Completer<ListFeedPostsResponse>();
    final controller = FeedController(api);
    final old = controller.refresh();
    await Future<void>.delayed(Duration.zero);
    await controller.select(api.sections.last);
    api.pending!.complete(
      ListFeedPostsResponse(
        posts: [FeedPost(id: 'stale', text: 'Старый ответ')],
      ),
    );
    await old;
    expect(controller.state.section!.id, 'second');
    expect(controller.state.posts, isEmpty);
    await controller.close();
  });
  test('поздняя ошибка прежнего запроса не очищает новую ленту', () async {
    final api = FakeFeed()..pending = Completer<ListFeedPostsResponse>();
    final controller = FeedController(api);
    final old = controller.refresh();
    await Future<void>.delayed(Duration.zero);
    await controller.select(api.sections.last);
    api.pending!.completeError(const GrpcError.permissionDenied());
    await old;
    expect(controller.state.section!.id, 'second');
    expect(controller.state.error, isNull);
    await controller.close();
  });
  test('отзыв доступа очищает записи, комментарии и права', () async {
    final api = FakeFeed();
    final controller = FeedController(api);
    await controller.refresh();
    await controller.open('post');
    api.refreshFailure = const GrpcError.notFound();
    await controller.refresh();
    expect(controller.state.posts, isEmpty);
    expect(controller.state.comments, isEmpty);
    expect(controller.state.post, isNull);
    expect(controller.state.permissions, isNull);
    await controller.close();
  });
  test(
    'скрытие родителя во время следующей страницы удаляет старые комментарии',
    () async {
      final api = FakeFeed()..hideOnMore = true;
      api.comments.add(
        FeedComment(
          id: 'later',
          postId: 'post',
          sequence: Int64(2),
          text: 'Ещё',
        ),
      );
      final controller = FeedController(api);
      await controller.refresh();
      await controller.open('post');
      expect(controller.state.comments, hasLength(1));
      await controller.more();
      expect(controller.state.post!.hidden, true);
      expect(controller.state.comments, isEmpty);
      controller.back();
      expect(controller.state.posts.single.hidden, true);
      expect(controller.state.posts.single.text, isEmpty);
      await controller.close();
    },
  );
  test(
    'потерянный ответ сохраняет текст и ключ, повтор не дублирует запись',
    () async {
      final api = FakeFeed()..loseResponse = true;
      final draft = FeedDraftCubit(
        api: api,
        channel: 'first',
        post: '',
        sent: () async {},
      );
      draft.change('Сохранённый текст');
      expect(await draft.send(), false);
      final key = draft.state.key;
      expect(draft.state.text, 'Сохранённый текст');
      expect(await draft.send(), true);
      expect(api.keys, [key, key]);
      expect(api.accepted, hasLength(1));
      expect(draft.state.text, isEmpty);
      await draft.close();
    },
  );
  test('смена текста после ошибки создаёт новый ключ запроса', () async {
    final api = FakeFeed()..loseResponse = true;
    final draft = FeedDraftCubit(
      api: api,
      channel: 'first',
      post: '',
      sent: () async {},
    );
    draft.change('Первый');
    await draft.send();
    draft.change('Другой');
    await draft.send();
    expect(api.keys[0], isNot(api.keys[1]));
    await draft.close();
  });
  test('очередь жалоб очищается после отзыва прав', () async {
    final api = FakeFeed();
    final manager = FeedManagement(api, 'first');
    expect(await manager.loadReports(), true);
    api.reportsDenied = true;
    expect(await manager.loadReports(), false);
    expect(manager.state.reports, isEmpty);
    expect(manager.state.error, isA<GrpcError>());
    await manager.close();
  });
  testWidgets('читатель видит публикации и отсутствие права публикации', (
    tester,
  ) async {
    final api = FakeFeed()..permissions = FeedPermissions();
    await tester.pumpWidget(app(FeedArea(api: api)));
    await tester.pumpAndSettle();
    expect(find.text('Первая запись'), findsOneWidget);
    expect(find.byType(FeedComposer), findsNothing);
    expect(
      find.text('У вас нет права публиковать в этом разделе.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('старый runtime не показывает форму отправки', (tester) async {
    final api = FakeFeed()..supported = false;
    await tester.pumpWidget(app(FeedArea(api: api)));
    await tester.pumpAndSettle();
    expect(find.byType(FeedComposer), findsNothing);
    expect(
      find.textContaining('Сервер ещё не поддерживает ленту'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('очередь жалоб открывает исходную публикацию', (tester) async {
    final opened = <String>[];
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showFeedManagement(
              context,
              FakeFeed(),
              'first',
              action: 'reports',
              open: opened.add,
            ),
            child: const Text('Очередь'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Очередь'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Открыть публикацию'));
    await tester.pumpAndSettle();
    expect(opened, ['post']);
    expect(find.byType(FeedManagementDialog), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('черновики публикации и комментария сохраняются при переходах', (
    tester,
  ) async {
    final api = FakeFeed();
    await tester.pumpWidget(app(FeedArea(api: api)));
    await tester.pumpAndSettle();
    final dynamic area = tester.state(find.byType(FeedArea));
    await tester.enterText(
      find.byKey(const ValueKey('feed-text')),
      'Черновик записи',
    );
    await area.controller.open('post');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('feed-text')),
      'Черновик комментария',
    );
    area.controller.back();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('feed-text')))
          .controller!
          .text,
      'Черновик записи',
    );
    await area.controller.open('post');
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('feed-text')))
          .controller!
          .text,
      'Черновик комментария',
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('лента помещается на ширине 320 и при увеличенном тексте', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      app(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: FeedArea(api: FakeFeed()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
