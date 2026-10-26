import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/community_reactions.dart';

import 'support/community_reactions.dart';

void main() {
  test('Пачки по 50, отсутствие чужих и повторных состояний', () async {
    final api = FakeCommunityReactions();
    final c = CommunityReactionsController(api, 'forum');
    addTearDown(c.close);
    final refs = List.generate(121, (i) => reactionRef('item_$i'));
    await c.select(refs, active: true);
    expect(api.pages.map((p) => p.length), [50, 50, 21]);
    expect(c.state.entries.length, 121);
    api.onList = (_) async => ListCommunityReactionsResponse(
      states: [CommunityReactionState(content: reactionRef('unsolicited'))],
    );
    await c.refresh();
    expect(c.state.entries, isEmpty);
    expect(c.state.loadError, isA<FormatException>());
    api.onList = (refs) async => ListCommunityReactionsResponse(
      states: [api.value(refs.first), api.value(refs.first)],
    );
    await c.refresh();
    expect(c.state.entries, isEmpty);
    expect(c.state.loadError, isA<FormatException>());
  });

  test(
    'Потерянный ответ повторяется с тем же ключом, без двойного переключения',
    () async {
      final api = FakeCommunityReactions();
      final ref = reactionRef('thread');
      final c = CommunityReactionsController(api, 'forum');
      addTearDown(c.close);
      await c.select([ref], active: true);
      api.onSet = (request) async {
        api.apply(request);
        throw const GrpcError.unavailable();
      };
      await c.toggle(ref, '👍');
      expect(c.state.retryable, contains('1:thread'));
      expect(c.state.entries, isEmpty);
      await c.refresh();
      expect(c.state.entries['1:thread']!.reactions.single.selected, isTrue);
      await c.toggle(ref, '🔥');
      expect(
        api.requests.length,
        1,
        reason: 'Сначала нужно разрешить незавершённый запрос',
      );
      api.onSet = null;
      await c.retry(ref);
      expect(api.requests.length, 2);
      expect(api.requests[0].idempotencyKey, api.requests[1].idempotencyKey);
      expect(c.state.entries['1:thread']!.reactions.single.count, Int64.ONE);
      expect(c.state.retryable, isEmpty);
      await c.toggle(ref, '👍');
      expect(c.state.entries['1:thread']!.reactions, isEmpty);
      expect(
        api.requests.last.idempotencyKey,
        isNot(api.requests.first.idempotencyKey),
      );
    },
  );

  test('Позднее чтение не откатывает подтверждённую реакцию', () async {
    final api = FakeCommunityReactions();
    final ref = reactionRef('thread');
    final c = CommunityReactionsController(api, 'forum');
    addTearDown(c.close);
    await c.select([ref], active: true);
    final old = api.value(ref).deepCopy();
    final waiting = Completer<ListCommunityReactionsResponse>();
    api.onList = (_) => waiting.future;
    final refresh = c.refresh();
    await c.toggle(ref, '👍');
    waiting.complete(ListCommunityReactionsResponse(states: [old]));
    await refresh;
    expect(c.state.entries['1:thread']!.revision, Int64.ONE);
    expect(c.state.entries['1:thread']!.reactions.single.selected, isTrue);
  });

  test(
    'Скрытый объект и отзыв доступа отменяют поздний ответ записи',
    () async {
      for (final denied in [false, true]) {
        final api = FakeCommunityReactions();
        final ref = reactionRef('thread');
        final c = CommunityReactionsController(api, 'forum');
        await c.select([ref], active: true);
        final waiting = Completer<SetCommunityReactionResponse>();
        api.onSet = (_) => waiting.future;
        final write = c.toggle(ref, '👍');
        api.onList = (_) async {
          if (denied) throw const GrpcError.permissionDenied();
          return ListCommunityReactionsResponse();
        };
        await c.refresh();
        waiting.complete(api.apply(api.requests.single));
        await write;
        expect(c.state.entries, isEmpty);
        expect(c.state.busy, isEmpty);
        await c.retry(ref);
        expect(api.requests.length, 1);
        await c.close();
      }
    },
  );

  test(
    'Неактивный раздел прекращает пачки и отбрасывает старый ответ',
    () async {
      final api = FakeCommunityReactions();
      final pending = Completer<ListCommunityReactionsResponse>();
      api.onList = (_) => pending.future;
      final c = CommunityReactionsController(api, 'forum');
      addTearDown(c.close);
      final refs = List.generate(80, (i) => reactionRef('item_$i'));
      final read = c.select(refs, active: true);
      await c.select(refs, active: false);
      pending.complete(
        ListCommunityReactionsResponse(states: [api.value(refs.first)]),
      );
      await read;
      expect(api.pages.length, 1);
      expect(c.state.entries, isEmpty);
      await c.toggle(refs.first, '👍');
      expect(api.requests, isEmpty);
    },
  );

  test('Двойное нажатие не создаёт второй запрос; смена контекста сбрасывает ответ', () async {
    final api = FakeCommunityReactions();
    final ref = reactionRef('thread');
    final c = CommunityReactionsController(api, 'forum');
    addTearDown(c.close);
    await c.select([ref], active: true);
    final pending = Completer<SetCommunityReactionResponse>();
    api.onSet = (_) => pending.future;
    final write = c.toggle(ref, '👍');
    await c.toggle(ref, '👍');
    expect(api.requests.length, 1);
    await c.select([reactionRef('another')], active: true);
    pending.complete(api.apply(api.requests.single));
    await write;
    expect(c.state.entries.keys, ['1:another']);
  });

  test('Конфликт требует свежей ревизии, не повторяет устаревшую запись автоматически', () async {
    final api = FakeCommunityReactions();
    final ref = reactionRef('thread');
    final c = CommunityReactionsController(api, 'forum');
    addTearDown(c.close);
    await c.select([ref], active: true);
    api.value(ref).revision = Int64.ONE;
    await c.toggle(ref, '👍');
    await Future<void>.delayed(Duration.zero);
    expect(api.requests.length, 1);
    expect(c.state.entries['1:thread']!.revision, Int64.ONE);
    expect(c.state.retryable, isEmpty);
    await c.toggle(ref, '👍');
    expect(api.requests.length, 2);
    expect(api.requests.last.expectedRevision, Int64.ONE);
  });

  test(
    'Смена личности или grant в том же API сбрасывает запись и кеш',
    () async {
      final api = FakeCommunityReactions();
      final ref = reactionRef('thread');
      final c = CommunityReactionsController(api, 'forum');
      addTearDown(c.close);
      await c.select([ref], active: true);
      final pending = Completer<SetCommunityReactionResponse>();
      api.onSet = (_) => pending.future;
      final write = c.toggle(ref, '👍');
      api.scopeId = 'another-principal-or-grant';
      pending.complete(api.apply(api.requests.single));
      await write;
      expect(c.state.entries, isEmpty);
      expect(c.state.busy, isEmpty);
      await c.refresh();
      await c.retry(ref);
      expect(api.requests.length, 1);
      expect(api.pages.length, 1);
    },
  );

  test('Ошибка чтения не теряет ключ незавершённой записи', () async {
    final api = FakeCommunityReactions();
    final ref = reactionRef('thread');
    final c = CommunityReactionsController(api, 'forum');
    addTearDown(c.close);
    await c.select([ref], active: true);
    api.onSet = (request) async {
      api.apply(request);
      throw const GrpcError.unavailable();
    };
    await c.toggle(ref, '👍');
    api.onList = (_) async => throw const GrpcError.unavailable();
    await c.refresh();
    expect(c.state.retryable, contains('1:thread'));
    api.onSet = null;
    await c.retry(ref);
    expect(api.requests[0].idempotencyKey, api.requests[1].idempotencyKey);
    expect(c.state.entries['1:thread']!.reactions.single.count, Int64.ONE);
  });

  test(
    'Проверка недоверенных счётчиков, emoji, ревизий и неизменяемая копия',
    () {
      final ref = reactionRef('thread');
      final value = CommunityReactionState(
        content: ref,
        reactions: [
          CommunityReaction(emoji: '👍', count: Int64.ONE, selected: true),
        ],
      );
      final checked = checkedReactionState(value, ref);
      value.reactions.single.count = Int64(7);
      expect(checked.reactions.single.count, Int64.ONE);
      for (final broken in [
        value.deepCopy()..revision = Int64(-1),
        value.deepCopy()..reactions.single.count = Int64.ZERO,
        value.deepCopy()..reactions.single.emoji = '\n',
        value.deepCopy()..content = reactionRef('other'),
        value.deepCopy()..reactions.add(value.reactions.single.deepCopy()),
      ]) {
        expect(() => checkedReactionState(broken, ref), throwsFormatException);
      }
    },
  );
}
