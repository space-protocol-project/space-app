import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/community_favorites_api.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';

class FavoriteVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = DeviceRecord.fromJson(value.toJson());
  }
}

void require(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Future<void> requireCode(Future<Object?> operation, int expected) async {
  try {
    await operation;
  } on GrpcError catch (error) {
    if (error.code == expected) return;
    rethrow;
  }
  throw StateError('Ожидалась ошибка $expected');
}

Future<void> access(SpaceSession owner, String channel, bool allowed) async {
  final current = await owner.adminRequest('/api/v1/channels/$channel/access');
  await owner.adminRequest(
    '/api/v1/channels/$channel/access',
    method: 'PUT',
    body: {
      'expectedRevision': current['revision'],
      'rules': [
        if (allowed)
          {
            'role': 'member',
            'permissions': {'visible': true, 'read': true, 'write': true},
          },
      ],
    },
  );
}

SetCommunityFavoriteRequest favorite(
  String channel,
  CommunityContentReference target,
  String key,
  int revision,
  bool saved,
) => SetCommunityFavoriteRequest(
  channelId: channel,
  content: target,
  idempotencyKey: key,
  expectedRevision: Int64(revision),
  saved: saved,
);

Future<void> waitRestart(List<String> args) async {
  if (args.length < 2) return;
  await File('${args[1]}.ready').writeAsString('ready');
  final timeout = Stopwatch()..start();
  while (!await File('${args[1]}.resume').exists()) {
    if (timeout.elapsed > const Duration(seconds: 90)) {
      throw StateError('Сервер не перезапущен');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<void> main(List<String> args) async {
  final ownerVault = FavoriteVault();
  var owner = await SpaceSession.connect(
    await discover(args.first),
    ownerVault,
  );
  SpaceSession? member, device;
  try {
    require(owner.communityFavoritesSupported, 'Нет capability избранного');
    final ownerId = owner.principalId;
    final settings =
        (await owner.adminRequest('/api/v1/space/settings'))['settings'] as Map;
    await owner.adminRequest(
      '/api/v1/space/settings',
      method: 'PATCH',
      body: {
        'title': 'Стенд избранного',
        'chatTitle': settings['chatTitle'],
        'chatEnabled': true,
        'registrationPolicy': 'open',
        'expectedRevision': settings['revision'],
      },
    );
    final history = await owner.send(
      'История до избранного',
      'favorite-history',
    );
    for (final kind in ['forum', 'feed']) {
      await owner.adminRequest(
        '/api/v1/channels',
        method: 'POST',
        body: {'channelId': kind, 'title': kind, 'viewType': kind},
      );
      await access(owner, kind, true);
    }
    final forum = SessionForumApi(owner);
    var feed = SessionFeedApi(owner);
    final policy = await feed.access('feed');
    await feed.saveAccess(
      UpdateFeedAccessRequest(
        channelId: 'feed',
        expectedRevision: policy.revision,
        rules: [
          FeedAccessRule(
            role: 'member',
            permissions: FeedPermissions(comment: true),
          ),
        ],
      ),
    );
    final topic = await forum.create('forum', 'Тема', 'Текст темы', 'topic');
    final reply = await forum.reply('forum', topic.id, 'Ответ', 'reply');
    final post = await feed.publish(
      CreateFeedPostRequest(
        channelId: 'feed',
        text: 'Публикация',
        idempotencyKey: 'post',
      ),
    );
    final comment = await feed.comment(
      CommentFeedPostRequest(
        channelId: 'feed',
        postId: post.post.id,
        text: 'Комментарий',
        idempotencyKey: 'comment',
      ),
    );
    final beforeForum = jsonEncode(
      (await forum.thread('forum', topic.id, Int64.ZERO)).toProto3Json(),
    );
    final beforeFeed = jsonEncode(
      (await feed.post('feed', post.post.id, Int64.ZERO)).toProto3Json(),
    );
    final memberVault = FavoriteVault();
    member = await SpaceSession.connect(
      await discover(args.first),
      memberVault,
    );
    final deviceVault = FavoriteVault()
      ..record = DeviceRecord.fromJson({
        ...memberVault.record!.toJson(),
        'deviceSeed': url64(List.filled(32, 44)),
        'grantId': '',
        'administrative': false,
      });
    device = await SpaceSession.connect(
      await discover(args.first),
      deviceVault,
    );
    require(
      device.principalId == member.principalId &&
          device.currentGrantId != member.currentGrantId,
      'Нужны два разных разрешения устройства одной личности',
    );
    final api = SessionCommunityFavoriteApi(member);
    final otherDevice = SessionCommunityFavoriteApi(device);
    final targets = [
      (
        'forum',
        CommunityContentReference(
          kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FORUM_THREAD,
          id: topic.id,
        ),
      ),
      (
        'forum',
        CommunityContentReference(
          kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FORUM_REPLY,
          id: reply.reply.id,
        ),
      ),
      (
        'feed',
        CommunityContentReference(
          kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_POST,
          id: post.post.id,
        ),
      ),
      (
        'feed',
        CommunityContentReference(
          kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_COMMENT,
          id: comment.comment.id,
        ),
      ),
    ];
    for (final (channel, target) in targets) {
      final add = favorite(channel, target, 'add-${target.id}', 0, true);
      await api.set(add);
      final fromDevice = (await otherDevice.states(channel, [
        target,
      ])).states.single;
      require(
        fromDevice.saved && fromDevice.revision == Int64.ONE,
        'Избранное не синхронизировано',
      );
      require(
        (await SessionCommunityFavoriteApi(
          owner,
        ).list(channel, '')).favorites.isEmpty,
        'Раскрыт чужой список',
      );
      await otherDevice.set(
        favorite(channel, target, 'remove-${target.id}', 1, false),
      );
      final repeated = await api.set(add);
      require(
        repeated.appliedRevision == Int64.ONE &&
            repeated.state.revision == Int64(2) &&
            !repeated.state.saved,
        'Повтор отменил более новое решение',
      );
      await api.set(favorite(channel, target, 'again-${target.id}', 2, true));
      await requireCode(
        otherDevice.set(
          favorite(channel, target, 'stale-${target.id}', 0, true),
        ),
        StatusCode.aborted,
      );
    }
    for (final channel in ['forum', 'feed']) {
      final page = await otherDevice.list(channel, '');
      require(page.favorites.length == 2, 'Потеряны сохранённые записи');
      require(
        page.favorites.any((f) => f.result.sequence > Int64.ZERO),
        'Нет ссылки на дочерний объект',
      );
    }
    require(
      beforeForum ==
          jsonEncode(
            (await forum.thread('forum', topic.id, Int64.ZERO)).toProto3Json(),
          ),
      'Изменена тема или её отметки чтения',
    );
    require(
      beforeFeed ==
          jsonEncode(
            (await feed.post('feed', post.post.id, Int64.ZERO)).toProto3Json(),
          ),
      'Изменена публикация или её отметки чтения',
    );
    await waitRestart(args);
    await owner.close();
    owner = await SpaceSession.connect(await discover(args.first), ownerVault);
    owner.selectChannel('general');
    require(
      owner.principalId == ownerId &&
          (await owner.messages()).any(
            (m) => m.id == history.id && m.text == history.text,
          ),
      'Потеряна идентичность или история',
    );
    for (final (channel, target) in targets) {
      final state = (await otherDevice.states(channel, [target])).states.single;
      require(
        state.revision == Int64(3) && state.saved,
        'Избранное потеряно после перезапуска',
      );
    }
    await access(owner, 'forum', false);
    await requireCode(api.list('forum', ''), StatusCode.notFound);
    await requireCode(
      api.states('forum', [targets.first.$2]),
      StatusCode.notFound,
    );
    await requireCode(
      api.set(
        favorite('forum', targets.first.$2, 'again-${topic.id}', 2, true),
      ),
      StatusCode.notFound,
    );
    feed = SessionFeedApi(owner);
    final currentPolicy = await feed.access('feed');
    await feed.saveAccess(
      UpdateFeedAccessRequest(
        channelId: 'feed',
        expectedRevision: currentPolicy.revision,
        rules: [FeedAccessRule(role: 'member', permissions: FeedPermissions())],
      ),
    );
    final ref = targets.last.$2;
    await api.set(favorite('feed', ref, 'read-only-remove', 3, false));
    await otherDevice.set(favorite('feed', ref, 'read-only-save', 4, true));
    require(
      (await api.states('feed', [ref])).states.single.saved,
      'Чтения недостаточно для личной отметки',
    );
    await feed.moderatePost(
      ModerateFeedPostRequest(
        channelId: 'feed',
        postId: post.post.id,
        hidden: true,
        reason: 'Проверка скрытого родителя',
        expectedRevision: comment.post.revision,
      ),
    );
    final hidden = await SessionCommunityFavoriteApi(owner)
        .states('feed', [targets[2].$2, targets[3].$2]);
    require(hidden.states.isEmpty, 'Скрытый родитель раскрыл отметки');
    require(
      (await api.list('feed', '')).favorites.isEmpty,
      'Скрытый родитель раскрыл список',
    );
    await api.set(favorite('feed', ref, 'remove-hidden', 5, false));
    stdout.writeln(
      'COMMUNITY_FAVORITES_INTEROP_OK: четыре типа, приватность, два устройства, повторы, ревизии, перезапуск, история, ACL, чтение без comment и скрытый родитель',
    );
  } finally {
    await device?.close();
    await member?.close();
    await owner.close();
  }
}
