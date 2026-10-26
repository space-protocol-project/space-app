import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/space_search.dart';

import 'support/space_search.dart';

void main() {
  SpaceSearchController create(
    FakeSpaceSearch api, {
    bool Function()? available,
  }) => SpaceSearchController(
    api,
    channels: searchChannels,
    available: available ?? () => true,
  );

  test('Пять типов и неизменяемые копии результатов', () async {
    final api = FakeSpaceSearch();
    final c = create(api);
    addTearDown(c.close);
    await c.submit(' совет ');
    expect(c.state.results.length, 5);
    expect(api.calls, [('совет', '')]);
    api.items.first.snippet = 'Изменённый источник';
    expect(c.state.results.first.snippet, 'Совет item-5');
    expect(
      () => c.state.results.first.snippet = 'Подмена',
      throwsUnsupportedError,
    );
  });

  test(
    'Пустой, слишком длинный и нулевой запросы не уходят на сервер',
    () async {
      final api = FakeSpaceSearch();
      final controller = create(api);
      addTearDown(controller.close);
      for (final query in ['', '  ', 'я' * 129, 'bad\u0000text']) {
        await controller.submit(query);
        expect(controller.state.invalid, isTrue);
      }
      expect(api.calls, isEmpty);
      await controller.submit('中');
      expect(controller.state.invalid, isFalse);
    },
  );

  test('Поздний ответ прошлого запроса не меняет новую выдачу', () async {
    final api = FakeSpaceSearch(), pending = Completer<SearchSpaceResponse>();
    api.onSearch = (q, t) async {
      if (q == 'старый') return pending.future;
      return SearchSpaceResponse(results: [searchHit('new')]);
    };
    final c = create(api);
    addTearDown(c.close);
    final old = c.submit('старый');
    await c.submit('новый');
    pending.complete(SearchSpaceResponse(results: [searchHit('old')]));
    await old;
    expect(c.state.query, 'новый');
    expect(c.state.results.single.id, 'new');
  });

  test('Отзыв доступа во время запроса очищает выдачу', () async {
    var available = true;
    final api = FakeSpaceSearch(), pending = Completer<SearchSpaceResponse>();
    final c = create(api, available: () => available);
    addTearDown(c.close);
    await c.submit('совет');
    api.onSearch = (q, t) => pending.future;
    final loading = c.submit('новый');
    available = false;
    pending.complete(SearchSpaceResponse(results: [searchHit('late')]));
    await loading;
    expect(c.state.revoked, isTrue);
    expect(c.state.results, isEmpty);
  });

  test('Смена личности или grant не принимает прежний ответ', () async {
    final api = FakeSpaceSearch(), pending = Completer<SearchSpaceResponse>();
    api.onSearch = (q, t) => pending.future;
    final c = create(api);
    addTearDown(c.close);
    final loading = c.submit('совет');
    api.scopeId = 'other';
    pending.complete(SearchSpaceResponse(results: [searchHit('late')]));
    await loading;
    expect(c.state.revoked, isTrue);
    expect(c.state.results, isEmpty);
  });

  test('Ошибка следующей страницы убирает прежнее содержимое', () async {
    final api = FakeSpaceSearch();
    api.onSearch = (q, t) async {
      if (t.isNotEmpty) throw StateError('Доступ отозван');
      return SearchSpaceResponse(
        results: [searchHit('first')],
        nextPageToken: 'next',
      );
    };
    final c = create(api);
    addTearDown(c.close);
    await c.submit('совет');
    await c.more();
    expect(c.state.error, isNotNull);
    expect(c.state.results, isEmpty);
  });

  test(
    'Страницы сохраняют порядок, сбрасывают курсор при обновлении',
    () async {
      final api = FakeSpaceSearch();
      api.onSearch = (q, t) async => t.isEmpty
          ? SearchSpaceResponse(
              results: [searchHit('first', time: 2000)],
              nextPageToken: 'next',
            )
          : SearchSpaceResponse(results: [searchHit('second')]);
      final c = create(api);
      addTearDown(c.close);
      await c.submit('совет');
      await c.more();
      expect(c.state.results.map((e) => e.id), ['first', 'second']);
      await c.refresh();
      expect(c.state.results.single.id, 'first');
      expect(api.calls, [('совет', ''), ('совет', 'next'), ('совет', '')]);
    },
  );

  for (final corrupt in <String, void Function(SpaceSearchResult)>{
    'чужой раздел': (r) => r.channelId = 'private',
    'неверный тип': (r) =>
        r.kind = SpaceSearchKind.SPACE_SEARCH_KIND_UNSPECIFIED,
    'чужой тип раздела': (r) => r.channelId = 'chat',
    'пустой ID': (r) => r.id = '',
    'родитель корня': (r) => r.parentId = 'other',
    'позиция корня': (r) => r.sequence = Int64.ONE,
    'пустой автор': (r) => r.authorId = '',
    'слишком длинный фрагмент': (r) => r.snippet = 'я' * 241,
    'нулевой символ': (r) => r.snippet = '\u0000',
    'отрицательное время': (r) => r.createdAtUnixMs = Int64(-1),
  }.entries) {
    test('Недоверенный ответ: ${corrupt.key}', () async {
      final api = FakeSpaceSearch();
      final item = searchHit('bad');
      corrupt.value(item);
      api.items = [item];
      final c = create(api);
      addTearDown(c.close);
      await c.submit('совет');
      expect(c.state.results, isEmpty);
      expect(c.state.error, isNotNull);
    });
  }

  test('Повтор, обратный порядок и пустое продолжение отклоняются', () async {
    for (final page in [
      SearchSpaceResponse(results: [searchHit('same'), searchHit('same')]),
      SearchSpaceResponse(
        results: [searchHit('old'), searchHit('new', time: 2000)],
      ),
      SearchSpaceResponse(nextPageToken: 'next'),
      SearchSpaceResponse(
        results: [searchHit('one')],
        nextPageToken: 'x' * 1025,
      ),
      SearchSpaceResponse(results: [searchHit('one')], nextPageToken: '中' * 400),
      SearchSpaceResponse(results: [searchHit('one')], nextPageToken: '\u0000next'),
    ]) {
      final api = FakeSpaceSearch()..onSearch = ((q, t) async => page);
      final c = create(api);
      await c.submit('совет');
      expect(c.state.results, isEmpty);
      expect(c.state.error, isNotNull);
      await c.close();
    }
  });

  test('Зацикленное продолжение не сохраняет прежние результаты', () async {
    final api = FakeSpaceSearch();
    var index = 0;
    api.onSearch = (q, t) async => SearchSpaceResponse(
      results: [searchHit('result-${index++}', time: 2000 - index)],
      nextPageToken: index == 2 ? 'second' : 'first',
    );
    final c = create(api);
    addTearDown(c.close);
    await c.submit('совет');
    await c.more();
    await c.more();
    expect(c.state.error, isNotNull);
    expect(c.state.results, isEmpty);
  });

  test(
    'Объём выдачи ограничен, продолжение после лимита не запрашивается',
    () async {
      final api = FakeSpaceSearch();
      var page = 0;
      api.onSearch = (q, t) async {
        final base = page++ * 50;
        return SearchSpaceResponse(
          results: [
            for (var i = 0; i < 50; i++)
              searchHit('hit-${base + i}', time: 10000 - base - i),
          ],
          nextPageToken: 'page-$page',
        );
      };
      final c = create(api);
      addTearDown(c.close);
      await c.submit('совет');
      for (var i = 0; i < 12; i++) {
        await c.more();
      }
      expect(c.state.results.length, 500);
      expect(c.state.capped, isTrue);
      expect(api.calls.length, 10);
      expect(c.state.next, isEmpty);
    },
  );
}
