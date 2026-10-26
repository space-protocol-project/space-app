import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart' show SpaceSession, SessionFeedApi;
import 'package:space_client/src/feed_controller.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/feed_social.dart';

import 'feed_test.dart' show FakeFeed, app;

class RecordingFeed extends FakeFeed {
  final published = <CreateFeedPostRequest>[];
  final replied = <CommentFeedPostRequest>[];
  @override
  Future<CreateFeedPostResponse> publish(CreateFeedPostRequest request) {
    published.add(request.deepCopy());
    return super.publish(request);
  }

  @override
  Future<CommentFeedPostResponse> comment(CommentFeedPostRequest request) {
    replied.add(request.deepCopy());
    return super.comment(request);
  }
}

FeedDraftCubit draft(RecordingFeed api, {String post = ''}) =>
    FeedDraftCubit(api: api, channel: 'first', post: post, sent: () async {});

class UnsupportedSocialSession implements SpaceSession {
  @override
  bool get feedSupported => true;
  @override
  bool get feedSocialSupported => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => throw StateError('Сетевой вызов недопустим');
}

void main() {
  test('RPC не теряет ссылки на сервере без capability', () async {
    final api = SessionFeedApi(UnsupportedSocialSession());
    final unsupported = throwsA(isA<GrpcError>().having((e) => e.code, 'code', StatusCode.unimplemented));
    await expectLater(api.publish(CreateFeedPostRequest(repostOf: 'post')), unsupported);
    await expectLater(api.comment(CommentFeedPostRequest(replyToCommentId: 'comment')), unsupported);
  });
  test(
    'репост без текста и цитата передают ссылку, не копию оригинала',
    () async {
      final api = RecordingFeed();
      final cubit = draft(api)..repost(api.entries.first);
      expect(await cubit.send(), isTrue);
      expect(api.published.single.text, isEmpty);
      expect(api.published.single.repostOf, 'post');
      cubit.repost(api.entries.first);
      cubit.change('Моё мнение');
      expect(await cubit.send(), isTrue);
      expect(api.published.last.text, 'Моё мнение');
      expect(api.published.last.repostOf, 'post');
      expect(cubit.state.repostOf, isEmpty);
      await cubit.close();
    },
  );
  test(
    'потеря ответа сохраняет ключ; другая цель создаёт новый ключ',
    () async {
      final api = RecordingFeed()..loseResponse = true;
      final cubit = draft(api)..repost(api.entries.first);
      expect(await cubit.send(), isFalse);
      expect(await cubit.send(), isTrue);
      expect(api.published[0].idempotencyKey, api.published[1].idempotencyKey);
      cubit.repost(FeedPost(id: 'other', channelId: 'first'));
      expect(await cubit.send(), isTrue);
      expect(
        api.published.last.idempotencyKey,
        isNot(api.published.first.idempotencyKey),
      );
      await cubit.close();
    },
  );
  test('повторный репост указывает на первоначальную публикацию', () async {
    final api = RecordingFeed();
    final cubit = draft(api)
      ..repost(FeedPost(id: 'repost', channelId: 'first', repostOf: 'post'));
    expect(cubit.state.repostOf, 'post');
    cubit.clearReference();
    expect(await cubit.send(), isFalse);
    await cubit.close();
  });
  test(
    'ответ привязан к комментарию своей публикации и может быть отменён',
    () async {
      final api = RecordingFeed();
      final cubit = draft(api, post: 'post')
        ..reply(api.comments.first)
        ..change('Ответ');
      expect(cubit.state.replySequence, 1);
      expect(await cubit.send(), isTrue);
      expect(api.replied.single.replyToCommentId, 'comment');
      cubit.reply(api.comments.first);
      cubit.clearReference();
      cubit.change('Обычный комментарий');
      expect(await cubit.send(), isTrue);
      expect(api.replied.last.replyToCommentId, isEmpty);
      await cubit.close();
    },
  );
  test('скрытые и чужие цели не выбираются', () async {
    final api = RecordingFeed();
    final post = draft(api);
    post.repost(FeedPost(id: 'secret', channelId: 'second'));
    post.repost(FeedPost(id: 'secret', channelId: 'first', hidden: true));
    expect(post.state.repostOf, isEmpty);
    final reply = draft(api, post: 'post');
    reply.reply(FeedComment(id: 'wrong', postId: 'other', sequence: Int64.ONE));
    reply.reply(
      FeedComment(
        id: 'hidden',
        postId: 'post',
        hidden: true,
        sequence: Int64.ONE,
      ),
    );
    expect(reply.state.replyTo, isEmpty);
    await post.close();
    await reply.close();
  });
  test(
    'утрата capability блокирует отправку структурированной ссылки',
    () async {
      final api = RecordingFeed();
      final cubit = draft(api)..repost(api.entries.first);
      api.socialSupported = false;
      expect(await cubit.send(), isFalse);
      expect(api.published, isEmpty);
      await cubit.close();
    },
  );
  testWidgets('недоступный оригинал не показывает прежний текст', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        FeedQuote(
          post: FeedPost(hidden: true, text: 'секрет', authorName: 'Автор'),
          open: () {},
        ),
      ),
    );
    expect(find.text('секрет'), findsNothing);
    expect(find.text('Автор'), findsNothing);
    expect(find.text('Исходная публикация недоступна'), findsOneWidget);
    expect(find.text('Открыть оригинал'), findsNothing);
  });
  testWidgets('ответ выбирается из комментария и отменяется в форме', (
    tester,
  ) async {
    await tester.pumpWidget(app(FeedArea(api: RecordingFeed())));
    await tester.pumpAndSettle();
    final dynamic area = tester.state(find.byType(FeedArea));
    await area.controller.open('post');
    await tester.pumpAndSettle();
    final action = find.byKey(const ValueKey('feed-reply-comment'));
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pumpAndSettle();
    expect(find.text('Ответ на комментарий №1'), findsOneWidget);
    final cancel = find.byKey(const ValueKey('feed-clear-reference'));
    await tester.ensureVisible(cancel);
    await tester.tap(cancel);
    await tester.pumpAndSettle();
    expect(find.text('Ответ на комментарий №1'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('форма репоста отправляет пустой текст и выбранный оригинал', (
    tester,
  ) async {
    final api = RecordingFeed();
    await tester.pumpWidget(app(FeedArea(api: api)));
    await tester.pumpAndSettle();
    final share = find.byKey(const ValueKey('feed-share-post'));
    await tester.ensureVisible(share);
    await tester.tap(share);
    await tester.pumpAndSettle();
    final send = find.descendant(
      of: find.byType(Dialog),
      matching: find.byKey(const ValueKey('feed-send')),
    );
    await tester.ensureVisible(send);
    await tester.tap(send);
    await tester.pumpAndSettle();
    expect(api.published.single.repostOf, 'post');
    expect(api.published.single.text, isEmpty);
    expect(find.byType(Dialog), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('переход к адресату загружает его страницу обсуждения', (tester) async {
    final api = RecordingFeed();
    api.comments.add(FeedComment(id: 'reply', postId: 'post', text: 'Ответ на другой странице',
      sequence: Int64(2), replyToCommentId: 'comment', replyToSequence: Int64.ONE));
    await tester.pumpWidget(app(FeedArea(api: api)));
    await tester.pumpAndSettle();
    final dynamic area = tester.state(find.byType(FeedArea));
    await area.controller.open('post', afterSequence: 1);
    await tester.pumpAndSettle();
    final parent = find.byKey(const ValueKey('feed-reply-parent-reply'));
    await tester.ensureVisible(parent);
    await tester.tap(parent);
    await tester.pumpAndSettle();
    expect(area.controller.state.comments.first.id, 'comment');
    expect(area.controller.state.commentStart, 0);
    expect(find.text('Первый комментарий'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('цитата помещается на телефоне с увеличенным шрифтом', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      app(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: SingleChildScrollView(
            child: FeedQuote(
              post: FeedPost(
                text: 'Текст публикации',
                authorName: 'Имя автора',
              ),
              open: () {},
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
