import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/community_mentions.dart';
import 'package:space_client/src/community_mentions_api.dart';
import 'package:space_client/src/feed_controller.dart';
import 'package:space_client/src/generated/space/v1/community_mentions.pb.dart';
import 'package:space_client/src/generated/space/v1/community_search.pb.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/ui/community_mentions.dart';
import 'package:space_client/ui/forum_composer.dart';

import 'feed_test.dart' show FakeFeed, app;

class MentionApi implements CommunityMentionApi {
  @override
  String principalId = 'me';
  final requests = <String>[];
  final marked = <String>[];
  final waiting = <String, Completer<List<MentionCandidate>>>{};
  Completer<void>? pendingRead;
  bool failRead = false;
  bool longIds = false;
  @override
  Future<List<MentionCandidate>> candidates(
    String channel,
    String parent,
    String query,
  ) async {
    requests.add('$channel:$parent:$query');
    if (waiting[query] case final request?) return request.future;
    return [
      for (final id in ['one', 'two'])
        MentionCandidate(
          principalId: longIds ? 'u_${id.padRight(64, 'a')}' : id,
          displayName: 'Маша 🚀',
        ),
    ];
  }

  @override
  Future<void> markRead(
    String channel,
    List<CommunityContentReference> content,
  ) async {
    marked.add('$channel:${content.map((c) => c.id).join(',')}');
    if (failRead) throw const GrpcError.permissionDenied();
    await pendingRead?.future;
  }
}

class MentionSource implements CommunityMentionSource {
  @override
  CommunityMentionApi? communityMentions;
}

class MentionFeed extends FakeFeed implements CommunityMentionSource {
  @override
  final communityMentions = MentionApi();
  final published = <CreateFeedPostRequest>[];
  @override
  Future<CreateFeedPostResponse> publish(CreateFeedPostRequest request) {
    published.add(request.deepCopy());
    return super.publish(request);
  }
}

MentionCandidate candidate() =>
    MentionCandidate(principalId: 'one', displayName: 'Маша 🚀');

void main() {
  test(
    'отметки становятся доступны после обновления capabilities источника',
    () async {
      final source = MentionSource();
      final reader = MentionReadCubit.fromSource(source);
      addTearDown(reader.close);
      final ref = CommunityContentReference(
        id: 'reply',
        kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FORUM_REPLY,
      );
      await reader.visible('section', [ref]);
      final api = MentionApi();
      source.communityMentions = api;
      await reader.visible('section', [ref]);
      expect(api.marked, ['section:reply']);
    },
  );

  testWidgets('подбор помещается на узком экране с клавиатурой и длинными ID', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 600);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    final api = MentionApi()..longIds = true;
    await tester.pumpWidget(
      app(
        SingleChildScrollView(
          child: ForumComposer(
            mentionApi: api,
            channelId: 'section',
            submit: (_, _, _, _) async => true,
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('community-mention')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  test('обычный @текст не становится упоминанием; UTF-16 и trim сохраняют диапазон', () async {
    final draft = MentionDraftCubit();
    addTearDown(draft.close);
    draft.change('  😀 @текст');
    expect(draft.state.mentions, isEmpty);
    draft.insert(candidate(), 5, draft.state.text.length);
    expect(draft.state.text, '  😀 @Маша 🚀 ');
    expect(draft.state.mentions.single.start, 5);
    expect(draft.trimmed.single.start, 3);
    expect(draft.trimmed.single.length, 8);
    draft.change('Префикс ${draft.state.text}');
    expect(draft.state.mentions.single.start, 13);
    draft.change('${draft.state.text}!');
    expect(draft.state.mentions, hasLength(1));
    draft.change(draft.state.text.replaceFirst('Маша', 'Даша'));
    expect(draft.state.mentions, isEmpty);
  });

  test(
    'вставки на границах и удаление фрагмента не создают неверных ссылок',
    () async {
      final draft = MentionDraftCubit();
      addTearDown(draft.close);
      draft.insert(candidate(), 0, 0);
      draft.change('x${draft.state.text}');
      expect(draft.state.mentions.single.start, 1);
      draft.change(draft.state.text.replaceRange(9, 9, '!'));
      expect(draft.state.mentions.single.start, 1);
      draft.change(draft.state.text.replaceRange(2, 3, ''));
      expect(draft.state.mentions, isEmpty);
      expect(
        validMentions('a', [
          CommunityMention(start: -1, length: 2, principalId: 'x'),
          CommunityMention(start: 100, length: 2, principalId: 'x'),
        ]),
        isEmpty,
      );
    },
  );

  test(
    'поздний ответ поиска и ответ после закрытия не возвращают кандидатов',
    () async {
      final api = MentionApi();
      api.waiting['old'] = Completer();
      api.waiting['new'] = Completer();
      final picker = MentionPickerCubit(api, 'section', 'parent');
      final old = picker.search('old');
      final fresh = picker.search('new');
      api.waiting['new']!.complete([candidate()]);
      await fresh;
      api.waiting['old']!.completeError(const GrpcError.permissionDenied());
      await old;
      expect(picker.state.candidates.single.principalId, 'one');
      api.waiting['late'] = Completer();
      final late = picker.search('late');
      await picker.close();
      api.waiting['late']!.complete([candidate()]);
      await late;
    },
  );

  test(
    'отметки адресованы точным объектам, ошибки не подтверждаются оптимистично',
    () async {
      final api = MentionApi()..pendingRead = Completer();
      final reader = MentionReadCubit(api);
      addTearDown(reader.close);
      CommunityContentReference ref(String id) => CommunityContentReference(
        id: id,
        kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_COMMENT,
      );
      final first = reader.visible('one', [ref('visible')]);
      await reader.visible('two', [ref('other')]);
      expect(reader.state, isEmpty);
      api.pendingRead!.complete();
      await first;
      expect(api.marked, ['one:visible', 'two:other']);
      await reader.visible('one', [ref('visible')]);
      expect(api.marked, hasLength(2));
      api.failRead = true;
      await reader.visible('one', [ref('denied')]);
      expect(reader.state.any((k) => k.endsWith('denied')), isFalse);
      await reader.visible('one', [ref('denied')]);
      expect(api.marked, hasLength(3));
      api.failRead = false;
      reader.retry();
      await reader.visible('one', [ref('denied')]);
      expect(api.marked, hasLength(4));
    },
  );

  test(
    'потерянный ответ сохраняет упоминания и ключ; снятие ссылки меняет ключ',
    () async {
      final api = MentionFeed()..loseResponse = true;
      final draft = FeedDraftCubit(
        api: api,
        channel: 'first',
        post: '',
        sent: () async {},
      );
      addTearDown(draft.close);
      draft.mentions.insert(candidate(), 0, 0);
      draft.change(draft.mentions.state.text);
      expect(await draft.send(), isFalse);
      expect(draft.mentions.state.mentions, hasLength(1));
      final key = draft.state.key;
      expect(await draft.send(), isTrue);
      expect(api.published.map((r) => r.idempotencyKey), [key, key]);
      expect(api.published.first.mentions.single.principalId, 'one');
      expect(draft.mentions.state.mentions, isEmpty);
      draft.change('@Маша 🚀');
      await draft.send();
      expect(api.published.last.mentions, isEmpty);
      expect(api.published.last.idempotencyKey, isNot(key));
    },
  );

  testWidgets(
    'выбор через @ различает одинаковые имена по ID и отправляет аннотацию',
    (tester) async {
      final api = MentionApi();
      List<CommunityMention>? sent;
      await tester.pumpWidget(
        app(
          ForumComposer(
            mentionApi: api,
            channelId: 'section',
            submit: (_, text, key, files) async => true,
            submitMentioned: (_, text, key, files, mentions) async {
              sent = mentions;
              return true;
            },
          ),
        ),
      );
      await tester.enterText(find.byKey(const ValueKey('forum-text')), '@');
      await tester.pumpAndSettle();
      expect(find.text('one'), findsOneWidget);
      expect(find.text('two'), findsOneWidget);
      await tester.tap(find.text('two'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('forum-send')));
      await tester.pumpAndSettle();
      expect(sent!.single.principalId, 'two');
      expect(sent!.single.start, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'старый сервер не показывает выбор; повреждённый диапазон отображается текстом',
    (tester) async {
      await tester.pumpWidget(
        app(ForumComposer(submit: (_, text, key, files) async => true)),
      );
      expect(find.byKey(const ValueKey('community-mention')), findsNothing);
      await tester.pumpWidget(
        app(
          CommunityMentionText(
            'plain',
            mentions: [
              CommunityMention(start: -1, length: 3, principalId: 'x'),
            ],
          ),
        ),
      );
      expect(find.text('plain'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
