import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';

import 'community_space_search_interoperability.dart'
    show SearchVault, require, requireCode, access, restart;

typedef SocialSeed = ({
  String original,
  String quote,
  String reply,
  String parent,
});

Future<SocialSeed> seedSocial(SpaceSession owner, SpaceSession member) async {
  final api = SessionFeedApi(owner), writer = SessionFeedApi(member);
  require(api.socialSupported, 'Нет capability социальной ленты');
  for (final channel in ['feed', 'other']) {
    final policy = await api.access(channel);
    await api.saveAccess(
      UpdateFeedAccessRequest(
        channelId: channel,
        expectedRevision: policy.revision,
        rules: [
          FeedAccessRule(
            role: 'member',
            permissions: FeedPermissions(publish: true, comment: true),
          ),
        ],
      ),
    );
  }
  final original = (await api.publish(
    CreateFeedPostRequest(
      channelId: 'feed',
      text: 'Оригинал без копирования',
      idempotencyKey: 'original',
    ),
  )).post;
  final req = CreateFeedPostRequest(
    channelId: 'feed',
    repostOf: original.id,
    idempotencyKey: 'repost',
  );
  final repost = await writer.publish(req);
  require(
    repost.post.text.isEmpty && repost.post.quotedPost.id == original.id,
    'Репост не сохранил ссылку',
  );
  require(
    (await writer.publish(req)).post.id == repost.post.id,
    'Повтор создал репост',
  );
  await requireCode(
    writer.publish(req.deepCopy()..repostOf = repost.post.id),
    StatusCode.alreadyExists,
  );
  await requireCode(
    writer.publish(
      req.deepCopy()
        ..idempotencyKey = 'nested'
        ..repostOf = repost.post.id,
    ),
    StatusCode.invalidArgument,
  );
  final quote = (await writer.publish(
    req.deepCopy()
      ..idempotencyKey = 'quote'
      ..text = 'Моё мнение',
  )).post;
  await requireCode(
    writer.publish(
      req.deepCopy()
        ..idempotencyKey = 'cross'
        ..channelId = 'other',
    ),
    StatusCode.notFound,
  );
  final first = (await api.comment(
    CommentFeedPostRequest(
      channelId: 'feed',
      postId: original.id,
      text: 'Начало разговора',
      idempotencyKey: 'first',
    ),
  )).comment;
  final replyReq = CommentFeedPostRequest(
    channelId: 'feed',
    postId: original.id,
    text: 'Ответ участнику',
    idempotencyKey: 'reply',
    replyToCommentId: first.id,
  );
  final reply = (await writer.comment(replyReq)).comment;
  require(reply.replyToSequence == first.sequence, 'Неверный адресат ответа');
  require(
    (await writer.comment(replyReq)).comment.id == reply.id,
    'Повтор создал ответ',
  );
  await requireCode(
    writer.comment(replyReq.deepCopy()..replyToCommentId = ''),
    StatusCode.alreadyExists,
  );
  await requireCode(
    writer.comment(
      replyReq.deepCopy()
        ..idempotencyKey = 'wrong-parent'
        ..postId = quote.id,
    ),
    StatusCode.notFound,
  );
  await api.moderateComment(
    ModerateFeedCommentRequest(
      channelId: 'feed',
      postId: original.id,
      commentId: first.id,
      hidden: true,
      reason: 'Проверка скрытия',
      expectedRevision: first.revision,
    ),
  );
  await requireCode(
    writer.comment(replyReq.deepCopy()..idempotencyKey = 'hidden-parent'),
    StatusCode.notFound,
  );
  return (
    original: original.id,
    quote: quote.id,
    reply: reply.id,
    parent: first.id,
  );
}

Future<void> hideOriginal(SessionFeedApi api, String id, bool hidden) async {
  final fresh = await api.post('feed', id, Int64.ZERO);
  await api.moderatePost(
    ModerateFeedPostRequest(
      channelId: 'feed',
      postId: id,
      hidden: hidden,
      reason: 'Проверка оригинала',
      expectedRevision: fresh.post.revision,
    ),
  );
}

Future<void> checkSocialAccess(
  SpaceSession owner,
  SpaceSession member,
  SocialSeed data,
) async {
  final api = SessionFeedApi(owner), reader = SessionFeedApi(member);
  await hideOriginal(api, data.original, true);
  final hidden = await reader.post('feed', data.quote, Int64.ZERO);
  require(
    !hidden.post.hasQuotedPost() && hidden.post.text == 'Моё мнение',
    'Скрытый оригинал раскрылся',
  );
  require(
    (await reader.posts(
      'feed',
      Int64.ZERO,
    )).posts.every((p) => !p.hasQuotedPost()),
    'Список раскрыл оригинал',
  );
  await requireCode(
    reader.publish(
      CreateFeedPostRequest(
        channelId: 'feed',
        repostOf: data.original,
        idempotencyKey: 'hidden',
      ),
    ),
    StatusCode.notFound,
  );
  await hideOriginal(api, data.original, false);
  await access(owner, 'feed', false);
  await requireCode(
    reader.post('feed', data.quote, Int64.ZERO),
    StatusCode.notFound,
  );
  await requireCode(
    reader.publish(
      CreateFeedPostRequest(
        channelId: 'feed',
        repostOf: data.original,
        idempotencyKey: 'denied',
      ),
    ),
    StatusCode.notFound,
  );
  await access(owner, 'feed', true);
}

Future<void> checkRestoredSocial(SpaceSession owner, SocialSeed data) async {
  final api = SessionFeedApi(owner);
  final quote = await api.post('feed', data.quote, Int64.ZERO);
  require(
    quote.post.quotedPost.id == data.original &&
        quote.post.quotedPost.text == 'Оригинал без копирования',
    'Репост потерян после перезапуска',
  );
  final discussion = await api.post('feed', data.original, Int64.ZERO);
  final reply = discussion.comments.singleWhere((c) => c.id == data.reply);
  require(
    reply.replyToCommentId == data.parent && reply.replyToSequence == Int64.ONE,
    'Потеряна связь ответа',
  );
  require(
    discussion.comments.first.hidden && discussion.comments.first.text.isEmpty,
    'Скрытие потеряно',
  );
}

Future<void> main(List<String> args) async {
  final vault = SearchVault();
  var owner = await SpaceSession.connect(await discover(args.first), vault);
  SpaceSession? member;
  try {
    final settings =
        (await owner.adminRequest('/api/v1/space/settings'))['settings'] as Map;
    await owner.adminRequest(
      '/api/v1/space/settings',
      method: 'PATCH',
      body: {
        'title': 'Социальная лента',
        'chatTitle': settings['chatTitle'],
        'chatEnabled': true,
        'registrationPolicy': 'open',
        'expectedRevision': settings['revision'],
      },
    );
    for (final id in ['feed', 'other']) {
      await owner.adminRequest(
        '/api/v1/channels',
        method: 'POST',
        body: {'channelId': id, 'title': id, 'viewType': 'feed'},
      );
      await access(owner, id, true);
    }
    member = await SpaceSession.connect(
      await discover(args.first),
      SearchVault(),
    );
    final identity = owner.principalId;
    final data = await seedSocial(owner, member);
    await checkSocialAccess(owner, member, data);
    await restart(args);
    await owner.close();
    owner = await SpaceSession.connect(await discover(args.first), vault);
    require(owner.principalId == identity, 'Изменилась идентичность');
    await checkRestoredSocial(owner, data);
    stdout.writeln(
      'COMMUNITY_FEED_SOCIAL_INTEROP_OK: ответы, репосты, цитаты, повторы, права, скрытие и перезапуск',
    );
  } finally {
    await member?.close();
    await owner.close();
  }
}
