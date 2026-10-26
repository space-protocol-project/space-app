import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/participant_follows.dart';
import 'support/participant_follows.dart';
import 'package:space_client/ui/participant_follows.dart';
import 'package:space_client/ui/personal_feed.dart';
import 'feed_test.dart' show app,FakeFeed;

FollowTimelineController timeline(FakeFollows api,{bool Function()? available,FollowPageKind kind=FollowPageKind.posts})=>
 FollowTimelineController(api,kind,channels:{'first','second'},available:available??()=>true);

void main() {
  test('Подписка ждёт сервер и передаёт общую ревизию',() async {
    final api=FakeFollows();final controller=FollowAuthorsController(api,'first',['author'],available:()=>true);addTearDown(controller.close);
    await controller.refresh();expect(controller.state.entries,{'author':false});
    await controller.toggle('author');expect(controller.state.entries,{'author':true});expect(api.requests.single.expectedRevision,Int64.ZERO);
    await controller.toggle('author');expect(api.requests.last.expectedRevision,Int64.ONE);expect(controller.state.entries,{'author':false});
    api.error=StateError('Нет сети');await controller.toggle('author');expect(controller.state.entries,isEmpty);expect(controller.state.error,isNotNull);
  });
  test('Имена авторов запрашиваются порциями по 50',() async {
    final api=FakeFollows();final controller=FollowAuthorsController(api,'first',[for(var i=0;i<120;i++) 'author-$i'],available:()=>true);addTearDown(controller.close);
    await controller.refresh();expect(api.batches.map((v)=>v.length),[50,50,20]);expect(controller.state.entries.length,120);
  });
  test('Поздний ответ другого пространства отбрасывается',() async {
    final api=FakeFollows();final pending=Completer<ListPersonalFeedResponse>();api.load=(_)=>pending.future;
    final controller=timeline(api);addTearDown(controller.close);final request=controller.refresh();
    api.scopeId='another';pending.complete(ListPersonalFeedResponse(entries:[entry('a',1)]));await request;
    expect(controller.state.revoked,isTrue);expect(controller.state.entries,isEmpty);
  });
  test('Отзыв прав очищает уже загруженную ленту',() async {
    final api=FakeFollows();var available=true;final controller=timeline(api,available:()=>available);addTearDown(controller.close);
    await controller.refresh();expect(controller.state.entries.length,2);available=false;await controller.refresh();
    expect(controller.state.revoked,isTrue);expect(controller.state.entries,isEmpty);
  });
  test('Страницы объединяются, обновление сохраняет загруженный диапазон',() async {
    final api=FakeFollows();api.load=(token) async=>ListPersonalFeedResponse(entries:[entry(token.isEmpty?'b':'a',token.isEmpty?2:1)],nextPageToken:token.isEmpty?'next':'');
    final controller=timeline(api);addTearDown(controller.close);await controller.refresh();await controller.more();
    expect(controller.state.entries.map((v)=>v.post.id),['b','a']);await controller.refresh();expect(controller.state.entries.length,2);
    expect(()=>controller.state.entries.first.post.text='подмена',throwsUnsupportedError);
  });
  test('Ошибка следующей страницы и изменение ревизии очищают старые записи',() async {
    final api=FakeFollows();api.load=(token) async=>ListPersonalFeedResponse(entries:[entry(token.isEmpty?'b':'a',token.isEmpty?2:1)],nextPageToken:token.isEmpty?'next':'',revision:Int64(token.isEmpty?1:2));
    final controller=timeline(api);addTearDown(controller.close);await controller.refresh();await controller.more();
    expect(controller.state.error,isNotNull);expect(controller.state.entries,isEmpty);
    api.load=(token) async=>ListPersonalFeedResponse(entries:[entry('b',2)],nextPageToken:'next');
    await controller.refresh();api.error=StateError('Сеть');await controller.more();expect(controller.state.entries,isEmpty);
  });
  test('Скрытые, чужие разделы, повторы и нарушение порядка отклоняются',() async {
    for(final values in [
      [entry('b',2)..post.hidden=true],
      [entry('b',2,channel:'private')],
      [entry('b',2),entry('b',2)],
      [entry('a',1),entry('b',2)],
      [entry('b',2)..post.authorId='me'],
    ]) {
      final api=FakeFollows()..load=(_) async=>ListPersonalFeedResponse(entries:values);
      final controller=timeline(api);await controller.refresh();expect(controller.state.error,isNotNull);expect(controller.state.entries,isEmpty);await controller.close();
    }
  });
  test('Недоступный автор остаётся в своём списке и допускает отписку',() async {
    final api=FakeFollows()..selected.add('author');final controller=timeline(api,kind:FollowPageKind.authors);addTearDown(controller.close);
    await controller.refresh();await controller.unfollow('author');expect(controller.state.participants,isEmpty);expect(api.requests.single.channelId,isEmpty);expect(api.requests.single.following,isFalse);
  });
  testWidgets('Кнопка подписки меняет состояние через сервер',(tester) async {
    final api=FakeFollows();await tester.pumpWidget(app(ParticipantFollowScope(api:api,channel:'first',ids:['author'],active:true,available:()=>true,child:const ParticipantFollowButton(principal:'author'))));
    await tester.pumpAndSettle();expect(find.byTooltip('Подписаться'),findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('follow-author')));await tester.pumpAndSettle();expect(find.byTooltip('Отписаться'),findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Личная лента открывает исходную публикацию и список подписок',(tester) async {
    final api=FakeFollows()..selected.add('author');
    await tester.pumpWidget(app(PersonalFeedDialog(api:api,feed:FakeFeed(),profiles:null,channels:{'first','second'},available:()=>true,changes:const Stream.empty(),kind:FollowPageKind.posts)));
    await tester.pumpAndSettle();expect(find.text('Публикация b'),findsOneWidget);expect(find.byKey(const ValueKey('personal-open-b')),findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('following-tab')));await tester.pumpAndSettle();expect(find.byKey(const ValueKey('unfollow-author')),findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('unfollow-author')));await tester.pumpAndSettle();expect(api.selected,isEmpty);
    await tester.pumpWidget(const SizedBox());
  });
}
