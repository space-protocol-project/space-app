import 'dart:convert';
import 'dart:io';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/space_search_api.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Content;

typedef SearchSeed = ({String identity, String topic, CreateFeedPostResponse post,
  CommentFeedPostResponse comment, Content history, String beforeForum, String beforeFeed});

class SearchVault implements IdentityVault {
  DeviceRecord? record;
  @override Future<DeviceRecord?> load(String origin) async => record;
  @override Future<void> save(DeviceRecord value) async {
    record = DeviceRecord.fromJson(value.toJson());
  }
}

void require(bool value, String message) { if (!value) throw StateError(message); }

Future<void> requireCode(Future<Object?> future, int code) async {
  try { await future; } on GrpcError catch (error) {
    if (error.code == code) return;
    rethrow;
  }
  throw StateError('Ожидалась ошибка $code');
}

Future<void> access(SpaceSession owner, String channel, bool allowed) async {
  final current = await owner.adminRequest('/api/v1/channels/$channel/access');
  await owner.adminRequest('/api/v1/channels/$channel/access',method:'PUT',body:{
    'expectedRevision':current['revision'],
    'rules':[if (allowed) {'role':'member','permissions':{'visible':true,'read':true,'write':true}}],
  });
}

Future<List<SpaceSearchResult>> searchAll(SpaceSearchApi api, String query) async {
  final result = <SpaceSearchResult>[];
  var token = '';
  var pages = 0;
  do {
    require(++pages <= 10,'Превышен лимит страниц');
    final page = await api.search(query,token);
    result.addAll(page.results);
    require(page.nextPageToken != token || token.isEmpty,'Страница зациклилась');
    token = page.nextPageToken;
  } while (token.isNotEmpty);
  return result;
}

Future<void> restart(List<String> args) async {
  await File('${args[1]}.ready').writeAsString('ready');
  final watch = Stopwatch()..start();
  while (!await File('${args[1]}.resume').exists()) {
    if (watch.elapsed > const Duration(seconds:90)) throw StateError('Нет перезапуска');
    await Future<void>.delayed(const Duration(milliseconds:100));
  }
}

Future<SearchSeed> seedSearch(SpaceSession owner) async {
    require(owner.spaceSearchSupported,'Нет capability общего поиска');
    final identity = owner.principalId;
    final settings = (await owner.adminRequest('/api/v1/space/settings'))['settings'] as Map;
    await owner.adminRequest('/api/v1/space/settings',method:'PATCH',body:{
      'title':'Проверка общего поиска','chatTitle':settings['chatTitle'],'chatEnabled':true,
      'registrationPolicy':'open','expectedRevision':settings['revision'],
    });
    final history = await owner.send('История до поиска','history');
    for (var i=0;i<25;i++) { await owner.send('Совет $i 中文 100%_','search-$i'); }
    for (final (id,view) in [('forum','forum'),('feed','feed'),('private','forum')]) {
      await owner.adminRequest('/api/v1/channels',method:'POST',body:{'channelId':id,'title':id,'viewType':view});
      await access(owner,id,id != 'private');
    }
    final forum = SessionForumApi(owner), feed = SessionFeedApi(owner);
    final topic = await forum.create('forum','Совет 中文 100%_','Тема','topic');
    await forum.reply('forum',topic.id,'Совет 中文 100%_','reply');
    await forum.create('private','Совет секрет','Скрытый раздел','private');
    final post = await feed.publish(CreateFeedPostRequest(channelId:'feed',text:'Совет 中文 100%_',idempotencyKey:'post'));
    final comment = await feed.comment(CommentFeedPostRequest(channelId:'feed',postId:post.post.id,text:'Совет 中文 100%_',idempotencyKey:'comment'));
    final beforeForum = jsonEncode((await forum.thread('forum',topic.id,Int64.ZERO)).toProto3Json());
    final beforeFeed = jsonEncode((await feed.post('feed',post.post.id,Int64.ZERO)).toProto3Json());
    return (identity:identity,topic:topic.id,post:post,comment:comment,history:history,
      beforeForum:beforeForum,beforeFeed:beforeFeed);
}

Future<void> checkSearchPages(SpaceSession owner, SpaceSearchApi api,
    SpaceSearchApi stranger, SearchSeed data) async {
    final first = await api.search('совет','');
    require(first.results.length == 20 && first.nextPageToken.isNotEmpty,'Нет постраничной выдачи');
    final all = await searchAll(api,'совет');
    require(all.length == 29 && all.map((r) => r.id).toSet().length == 29,'Потеряны результаты или есть дубли');
    require(all.map((r) => r.kind.value).toSet().length == 5,'Не все пять типов');
    require(all.every((r) => r.channelId != 'private' && r.parentId.isNotEmpty),'Раскрыт приватный раздел');
    for (final query in ['中','100%_']) {
      require((await searchAll(api,query)).length == 29,'Нарушена буквальная Unicode-подстрока');
    }
    require((await api.search("' OR true --",'')).results.isEmpty,'SQL стал шаблоном');
    require((await api.search('секрет','')).results.isEmpty,'Раскрыт приватный текст');
    await requireCode(stranger.search('совет',first.nextPageToken),StatusCode.invalidArgument);
    require(data.beforeForum == jsonEncode((await SessionForumApi(owner).thread('forum',data.topic,Int64.ZERO)).toProto3Json()),'Поиск изменил тему или чтение');
    require(data.beforeFeed == jsonEncode((await SessionFeedApi(owner).post('feed',data.post.post.id,Int64.ZERO)).toProto3Json()),'Поиск изменил ленту или чтение');
}

Future<Set<String>> checkSearchAccess(SpaceSession owner, SpaceSearchApi api, SearchSeed data) async {
    final first = await api.search('совет','');
    await access(owner,'forum',false);
    final afterCursor = await api.search('совет',first.nextPageToken);
    require(afterCursor.results.every((r) => r.channelId != 'forum'),'Курсор сохранил отозванный доступ');
    require((await searchAll(api,'совет')).length == 27,'ACL не применён к новой выдаче');
    await access(owner,'forum',true);
    await SessionFeedApi(owner).moderatePost(ModerateFeedPostRequest(channelId:'feed',postId:data.post.post.id,
      hidden:true,reason:'Проверка скрытого родителя',expectedRevision:data.comment.post.revision));
    for (final observer in [api,SessionSpaceSearchApi(owner)]) {
      final page = await searchAll(observer,'совет');
      require(page.every((r) => r.id != data.post.post.id && r.id != data.comment.comment.id),'Раскрыт скрытый родитель');
    }
    return (await searchAll(api,'совет')).map((r) => r.id).toSet();
}

Future<void> checkSearchRestored(SpaceSession owner, SpaceSearchApi api, SearchSeed data, Set<String> before) async {
    require(owner.principalId == data.identity,'Изменилась идентичность');
    owner.selectChannel('general');
    require((await owner.messages()).any((m) => m.id == data.history.id && m.text == data.history.text),'Потеряна история');
    final after = (await searchAll(api,'совет')).map((r) => r.id).toSet();
    require(before.length == after.length && before.containsAll(after),'Поиск изменился после перезапуска');
}

Future<void> main(List<String> args) async {
  final vault = SearchVault();
  var owner = await SpaceSession.connect(await discover(args.first),vault);
  SpaceSession? member, stranger;
  try {
    final data = await seedSearch(owner);
    member = await SpaceSession.connect(await discover(args.first),SearchVault());
    stranger = await SpaceSession.connect(await discover(args.first),SearchVault());
    final api = SessionSpaceSearchApi(member);
    await checkSearchPages(owner,api,SessionSpaceSearchApi(stranger),data);
    final before = await checkSearchAccess(owner,api,data);
    await restart(args);
    await owner.close(); owner = await SpaceSession.connect(await discover(args.first),vault);
    await checkSearchRestored(owner,api,data,before);
    stdout.writeln('COMMUNITY_SPACE_SEARCH_INTEROP_OK: пять типов, страницы, приватность, Unicode, история, чтение, отзыв ACL, скрытый родитель и перезапуск');
  } finally {
    await stranger?.close(); await member?.close(); await owner.close();
  }
}
