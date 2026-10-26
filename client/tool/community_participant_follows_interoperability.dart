import 'dart:io';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/participant_follows_api.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'community_space_search_interoperability.dart' show SearchVault,require,requireCode,access,restart;

Future<void> prepare(SpaceSession owner) async {
  final settings=(await owner.adminRequest('/api/v1/space/settings'))['settings'] as Map;
  await owner.adminRequest('/api/v1/space/settings',method:'PATCH',body:{
    'title':'Подписки','chatTitle':settings['chatTitle'],'chatEnabled':true,'registrationPolicy':'open','expectedRevision':settings['revision'],
  });
  for(final id in ['feed','other']) {
    await owner.adminRequest('/api/v1/channels',method:'POST',body:{'channelId':id,'title':id,'viewType':'feed'});
    await access(owner,id,true);
    await SessionFeedApi(owner).publish(CreateFeedPostRequest(channelId:id,text:'Публикация $id',idempotencyKey:id));
  }
}

Future<void> checkRights(SpaceSession owner,SpaceSession member) async {
  final follows=SessionParticipantFollowApi(member);
  require(SessionFeedApi(member).follows!=null,'Нет capability подписок');
  final req=SetParticipantFollowRequest(channelId:'feed',principalId:owner.principalId,following:true);
  final made=await follows.set(req);require(made.revision==Int64.ONE&&made.state.following,'Подписка не создана');
  require((await follows.set(req)).revision==Int64.ONE,'Повтор изменил ревизию');
  require((await SessionParticipantFollowApi(owner).following('')).participants.isEmpty,'Чужие подписки раскрылись');
  require((await follows.feed('')).entries.length==2,'Нет публикаций двух разделов');
  await access(owner,'other',false);
  final page=await follows.feed('');require(page.entries.length==1&&page.entries.single.post.channelId=='feed','ACL применён после выдачи');
  await access(owner,'feed',false);
  require((await follows.feed('')).entries.isEmpty,'Закрытый раздел раскрылся');
  final people=await follows.following('');require(people.participants.length==1&&!people.participants.single.available&&people.participants.single.displayName.isEmpty,'Раскрыт недоступный профиль');
  await requireCode(follows.set(req),StatusCode.notFound);
  await follows.set(SetParticipantFollowRequest(principalId:owner.principalId,expectedRevision:Int64.ONE));
  require((await follows.following('')).participants.isEmpty,'Не удалось отписаться от недоступного автора');
  await access(owner,'feed',true);
  await follows.set(req.deepCopy()..expectedRevision=Int64(2));
  await requireCode(follows.set(SetParticipantFollowRequest(principalId:owner.principalId,expectedRevision:Int64.ONE)),StatusCode.aborted);
}

Future<void> main(List<String> args) async {
  final ownerVault=SearchVault(),memberVault=SearchVault();
  var owner=await SpaceSession.connect(await discover(args.first),ownerVault);
  SpaceSession? member;
  try {
    await prepare(owner);
    member=await SpaceSession.connect(await discover(args.first),memberVault);
    await checkRights(owner,member);
    final identity=member.principalId;
    final before=await SessionParticipantFollowApi(member).feed('');
    await restart(args);await member.close();await owner.close();
    owner=await SpaceSession.connect(await discover(args.first),ownerVault);
    member=await SpaceSession.connect(await discover(args.first),memberVault);
    require(member.principalId==identity,'Идентичность не восстановилась');
    final follows=SessionParticipantFollowApi(member),after=await SessionParticipantFollowApi(member).feed('');
    require(after.revision==before.revision&&after.entries.single.post.id==before.entries.single.post.id,'Перезапуск потерял подписку или выдал закрытый раздел');
    require((await follows.following('')).participants.single.principalId==owner.principalId,'Подписка потеряна');
    stdout.writeln('COMMUNITY_PARTICIPANT_FOLLOWS_INTEROP_OK: Connect, личные подписки, ACL, отписка, ревизии и перезапуск');
  } finally {await member?.close();await owner.close();}
}
