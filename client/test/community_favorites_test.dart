import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/community_favorites.dart';
import 'package:space_client/src/community_favorite_list.dart';

import 'support/community_favorites.dart';

void main() {
  test('Избранное: добавление, удаление и пачки по 50', () async {
    final api = FakeCommunityFavorites();
    final c = CommunityFavoritesController(api, 'forum');
    addTearDown(c.close);
    final refs = List.generate(121, (i) => favoriteRef('item-$i'));
    await c.select(refs, active: true);
    expect(api.pages.map((p) => p.length), [50, 50, 21]);
    await c.toggle(refs.first);
    expect(c.state.entries['1:item-0']!.saved, isTrue);
    await c.toggle(refs.first);
    expect(c.state.entries['1:item-0']!.saved, isFalse);
    expect(api.requests.map((r) => r.expectedRevision), [
      Int64.ZERO,
      Int64.ONE,
    ]);
  });
  test('Потерянный ответ и неуспешное чтение сохраняют ключ повтора', () async {
    final api = FakeCommunityFavorites();
    final ref = favoriteRef('one');
    final c = CommunityFavoritesController(api, 'forum');
    addTearDown(c.close);
    await c.select([ref], active: true);
    api.onSet = (r) async {
      api.apply(r);
      throw const GrpcError.unavailable();
    };
    await c.toggle(ref);
    api.onStates = (_) async => throw const GrpcError.unavailable();
    await c.refresh();
    api.onSet = null;
    await c.retry(ref);
    expect(api.requests.length, 2);
    expect(api.requests[0].idempotencyKey, api.requests[1].idempotencyKey);
    expect(c.state.entries['1:one']!.revision, Int64.ONE);
    expect(c.state.entries['1:one']!.saved, isTrue);
  });
  test(
    'Поздний ответ прежнего участника не восстанавливает избранное',
    () async {
      final api = FakeCommunityFavorites();
      final ref = favoriteRef('one');
      final c = CommunityFavoritesController(api, 'forum');
      addTearDown(c.close);
      await c.select([ref], active: true);
      final result = Completer<SetCommunityFavoriteResponse>();
      api.onSet = (_) => result.future;
      final write = c.toggle(ref);
      api.scopeId = 'other';
      await c.refresh();
      result.complete(api.apply(api.requests.single));
      await write;
      expect(c.state.entries, isEmpty);
      expect(c.state.busy, isEmpty);
    },
  );
  test('Скрытие объекта отменяет запоздалое сохранение', () async {
    final api = FakeCommunityFavorites();
    final ref = favoriteRef('one');
    final c = CommunityFavoritesController(api, 'forum');
    addTearDown(c.close);
    await c.select([ref], active: true);
    final result = Completer<SetCommunityFavoriteResponse>();
    api.onSet = (_) => result.future;
    final write = c.toggle(ref);
    api.onStates = (_) async => GetCommunityFavoriteStatesResponse();
    await c.refresh();
    result.complete(api.apply(api.requests.single));
    await write;
    expect(c.state.entries, isEmpty);
  });
  test(
    'Конфликт другого устройства не перезаписывается автоматически',
    () async {
      final api = FakeCommunityFavorites();
      final ref = favoriteRef('one');
      final c = CommunityFavoritesController(api, 'forum');
      addTearDown(c.close);
      await c.select([ref], active: true);
      api.value(ref)
        ..saved = true
        ..revision = Int64.ONE;
      await c.toggle(ref);
      await Future<void>.delayed(Duration.zero);
      expect(api.requests.length, 1);
      expect(c.state.entries['1:one']!.saved, isTrue);
      expect(c.state.retryable, isEmpty);
      expect(c.state.errors, isNotEmpty);
      await c.recover(ref);
      expect(c.state.errors, isEmpty);
      await c.toggle(ref);
      expect(c.state.entries['1:one']!.saved, isFalse);
    },
  );
  test('Чтение, начатое до сохранения, не откатывает ревизию', () async {
    final api = FakeCommunityFavorites();
    final ref = favoriteRef('one');
    final c = CommunityFavoritesController(api, 'forum');
    addTearDown(c.close);
    await c.select([ref], active: true);
    final stale = api.value(ref).deepCopy();
    final pending = Completer<GetCommunityFavoriteStatesResponse>();
    api.onStates = (_) => pending.future;
    final read = c.refresh();
    await c.toggle(ref);
    pending.complete(GetCommunityFavoriteStatesResponse(states: [stale]));
    await read;
    expect(c.state.entries['1:one']!.saved, isTrue);
  });
  test('Недоверенные и чужие состояния отклоняются', () async {
    final api = FakeCommunityFavorites();
    final c = CommunityFavoritesController(api, 'forum');
    addTearDown(c.close);
    api.onStates = (_) async => GetCommunityFavoriteStatesResponse(
      states: [CommunityFavoriteState(content: favoriteRef('foreign'))],
    );
    await c.select([favoriteRef('one')], active: true);
    expect(c.state.entries, isEmpty);
    expect(c.state.loadError, isNotNull);
    expect(
      () => checkedFavoriteState(
        CommunityFavoriteState(
          content: favoriteRef('one'),
          revision: Int64(-1),
        ),
        favoriteRef('one'),
      ),
      throwsFormatException,
    );
  });
  test(
    'Список: страницы и обновление сохраняют объём просмотренного',
    () async {
      final api = FakeCommunityFavorites();
      final tokens = <String>[];
      api.onList = (token) async {
        tokens.add(token);
        return ListCommunityFavoritesResponse(
          favorites: [favoriteItem(token.isEmpty ? 'one' : 'two')],
          nextPageToken: token.isEmpty ? 'next' : '',
        );
      };
      final c = CommunityFavoriteListController(api, 'forum');
      addTearDown(c.close);
      await c.refresh();
      await c.more();
      expect(c.state.entries.length, 2);
      await c.refresh();
      expect(c.state.entries.length, 2);
      expect(tokens, ['', 'next', '', 'next']);
    },
  );
  test('Список не принимает позднюю страницу после потери контекста', () async {
    final api = FakeCommunityFavorites();
    var active = true;
    final result = Completer<ListCommunityFavoritesResponse>();
    api.onList = (_) => result.future;
    final c = CommunityFavoriteListController(
      api,
      'forum',
      available: () => active,
    );
    addTearDown(c.close);
    final read = c.refresh();
    active = false;
    result.complete(
      ListCommunityFavoritesResponse(favorites: [favoriteItem('one')]),
    );
    await read;
    expect(c.state.revoked, isTrue);
    expect(c.state.entries, isEmpty);
  });
  test('Список: отказ сервера очищает ранее показанный текст', () async {
    final api = FakeCommunityFavorites();
    api.onList = (_) async =>
        ListCommunityFavoritesResponse(favorites: [favoriteItem('one')]);
    final c = CommunityFavoriteListController(api, 'forum');
    addTearDown(c.close);
    await c.refresh();
    api.onList = (_) async => throw const GrpcError.permissionDenied();
    await c.refresh();
    expect(c.state.entries, isEmpty);
    expect(c.state.error, isA<GrpcError>());
  });
  test('Список: повторы и циклические страницы отклоняются', () async {
    final api = FakeCommunityFavorites();
    api.onList = (_) async => ListCommunityFavoritesResponse(
      favorites: [favoriteItem('one')],
      nextPageToken: 'same',
    );
    final c = CommunityFavoriteListController(api, 'forum');
    addTearDown(c.close);
    await c.refresh();
    await c.more();
    expect(c.state.entries, isEmpty);
    expect(c.state.error, isA<FormatException>());
  });
}
