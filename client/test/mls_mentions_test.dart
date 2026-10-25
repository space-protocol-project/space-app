import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/generated/space/v1/community_mentions.pb.dart';
import 'package:space_client/src/mls/controller.dart';
import 'package:space_client/src/mls/drafts.dart';
import 'package:space_client/src/mls/mentions.dart';
import 'package:space_client/src/mls/replies.dart';

CommunityMention selected({int start = 3, String id = 'u_bob'}) =>
    CommunityMention(
      principalId: id,
      displayName: 'Боб🚀',
      start: start,
      length: 6,
    );

Map<String, dynamic> annotated() => {
  'version': 2,
  'id': List.filled(16, 1),
  'text': '🚀 @Боб🚀',
  'files': [],
  'mentions': mlsMentionJson('🚀 @Боб🚀', [selected()]),
};

void main() {
  test('Закрытие сохраняет последний ввод, но не стирает ещё не загруженный черновик', () async {
    final saved = <String>[];
    final gate = Completer<String>();
    final unopened = MlsMentionDraftCubit(
      'scope',
      loadText: (_) => gate.future,
      loadMentions: (_, _) async => [],
      save: (_, text, {mentions = const []}) => saved.add(text),
    );
    final loading = unopened.load();
    await unopened.close();
    gate.complete('Сохранённый текст');
    await loading;
    expect(saved, isEmpty);
    final edited = MlsMentionDraftCubit(
      'scope',
      save: (_, text, {mentions = const []}) => saved.add(text),
    );
    edited.change('Первый ввод');
    edited.change('Последний ввод');
    await edited.close();
    expect(saved.last, 'Последний ввод');
  });

  test('UTF-16, повторные обращения и стабильный ID сохраняются в ответе', () {
    final message = annotated();
    expect(checkedMlsMentions(message).single, selected());
    final preview = mlsReplyContent({
      'message': message,
      'author_id': 'alice',
      'grant_id': 'grant',
      'sequence': 1,
      'time': 1,
    });
    expect(preview!.mentions.single.principalId, 'u_bob');
    requireMlsMentions('🚀 @Боб🚀 @Боб🚀', [selected(), selected(start: 10)]);
    final zero = mlsMentionJson('@Боб🚀', [selected(start: 0)]);
    expect(zero.single['start'], 0);
    expect(checkedMlsMentions({'version': 1, 'text': '@Боб🚀'}), isEmpty);
  });

  test('Повреждённые версии, ID и диапазоны отвергаются', () {
    final raw = (annotated()['mentions'] as List).single as Map;
    for (final change in <Map<String, dynamic>>[
      {'version': 1},
      {'version': 3},
      {'version': 2.0},
      {'mentions': null},
      {'mentions': []},
      {'reaction': {}},
      {'manager': 'grant'},
      {
        'mentions': [
          {...raw, 'start': 1},
        ],
      },
      {
        'mentions': [
          {...raw, 'start': 4294967299},
        ],
      },
      {
        'mentions': [
          {...raw, 'length': -1},
        ],
      },
      {
        'mentions': [
          {...raw, 'principal_id': 'русский-ID'},
        ],
      },
      {
        'mentions': [
          {...raw, 'extra': true},
        ],
      },
      {
        'mentions': [raw, raw],
      },
      {'mentions': List.filled(11, raw)},
      {'text': '\ud800 @Боб🚀'},
    ]) {
      expect(
        () => checkedMlsMentions({...annotated(), ...change}),
        throwsFormatException,
        reason: '$change',
      );
    }
    expect(
      () => checkedMlsMentions({'version': 2, 'text': '@Боб🚀'}),
      throwsFormatException,
    );
  });

  test('Снимки и исходящая очередь проверяют упоминания до импорта', () {
    for (final field in [
      'messages',
      'archived_messages',
      'outbox',
      'retry_messages',
    ]) {
      final row = {'message': annotated()};
      checkMlsChannelMentions({
        field: [row],
      });
      (row['message'] as Map)['mentions'] = null;
      expect(
        () => checkMlsChannelMentions({
          field: [row],
        }),
        throwsFormatException,
      );
    }
  });

  test('Событие отправки копирует и замораживает выбранные ID', () {
    final mention = selected();
    final list = [mention];
    final event = MlsSend('🚀 @Боб🚀', [], mentions: list);
    mention.principalId = 'different';
    list.clear();
    expect(event.mentions.single.principalId, 'u_bob');
    expect(
      () => event.mentions.single.principalId = 'other',
      throwsUnsupportedError,
    );
  });

  test('Возможности принимаются только в точном формате', () {
    expect(
      MlsMessageFeatures.read({
        'format': 2,
        'own_mentions': true,
        'all_mentions': false,
      }).allMentions,
      isFalse,
    );
    for (final value in [
      {'format': 2, 'own_mentions': false, 'all_mentions': true},
      {'format': 1, 'own_mentions': true, 'all_mentions': true},
      {'format': 2, 'own_mentions': true, 'all_mentions': true, 'extra': 1},
    ]) {
      expect(() => MlsMessageFeatures.read(value), throwsFormatException);
    }
  });

  test(
    'Поздний черновик не заменяет новый ввод и не переходит между профилями',
    () async {
      final gate = Completer<String>();
      final saved = <String>[];
      final first = MlsMentionDraftCubit(
        'profile-A/group',
        loadText: (_) => gate.future,
        loadMentions: (_, _) async => [selected()],
        save: (scope, text, {mentions = const []}) => saved.add('$scope:$text'),
      );
      final loading = first.load();
      first.change('Новый текст');
      gate.complete('🚀 @Боб🚀');
      await loading;
      expect(first.state.text, 'Новый текст');
      await first.close();
      final second = MlsMentionDraftCubit(
        'profile-B/group',
        loadText: (_) async => '🚀 @Боб🚀',
        loadMentions: (scope, _) async {
          expect(scope, 'profile-B/group');
          return [selected()];
        },
        save: (scope, text, {mentions = const []}) => saved.add('$scope:$text'),
      );
      await second.load();
      expect(second.state.mentions.single.principalId, 'u_bob');
      second.change('🚀 @Другой');
      expect(second.state.mentions, isEmpty);
      await second.close();
      expect(saved, contains('profile-A/group:Новый текст'));
    },
  );
}
