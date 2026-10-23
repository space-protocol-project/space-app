import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/message_search.dart';
import 'package:space_client/src/message_search_controller.dart';
import 'package:space_client/src/rpc_clients.dart';

void main() {
  test('Задержка объединяет ввод и не отправляет короткий запрос', () {
    fakeAsync((clock) {
      final requests = <String>[];
      final search = MessageSearchController(
        searchMessages: (query, _) async {
          requests.add(query);
          return const MessageSearchPage([]);
        },
      );
      search.changeQuery('я');
      clock.elapse(const Duration(seconds: 1));
      expect(requests, isEmpty);
      search.changeQuery('по');
      clock.elapse(const Duration(milliseconds: 200));
      search.changeQuery('поиск');
      clock.elapse(const Duration(milliseconds: 299));
      expect(requests, isEmpty);
      clock.elapse(const Duration(milliseconds: 1));
      expect(requests, ['поиск']);
      search.close();
      clock.flushMicrotasks();
    });
  });

  test('Ошибка старого запроса не завершает загрузку нового', () {
    fakeAsync((clock) {
      final old = Completer<MessageSearchPage>();
      final current = Completer<MessageSearchPage>();
      final search = MessageSearchController(
        delay: Duration.zero,
        searchMessages: (query, _) =>
            query == 'старое' ? old.future : current.future,
      );
      search.changeQuery('старое');
      clock.elapse(Duration.zero);
      search.changeQuery('новое');
      clock.elapse(Duration.zero);
      old.completeError(StateError('Старый отказ'));
      clock.flushMicrotasks();
      expect(search.state.loading, isTrue);
      expect(search.state.failed, isFalse);
      current.complete(MessageSearchPage([Content(id: 'new')]));
      clock.flushMicrotasks();
      expect(search.state.messages.single.id, 'new');
      expect(search.state.loading, isFalse);
      search.close();
      clock.flushMicrotasks();
    });
  });

  test('Смена области поиска отбрасывает прежнюю страницу', () {
    fakeAsync((clock) {
      final old = Completer<MessageSearchPage>();
      final search = MessageSearchController(
        delay: Duration.zero,
        searchMessages: (_, _) => old.future,
        searchAllChannels: (_, _) async => MessageSearchPage([
          Content(id: 'same', channelId: 'first'),
          Content(id: 'same', channelId: 'second'),
        ]),
      );
      search.changeQuery('поиск');
      clock.elapse(Duration.zero);
      search.selectAllChannels(true);
      clock.elapse(Duration.zero);
      old.complete(MessageSearchPage([Content(id: 'old')]));
      clock.flushMicrotasks();
      expect(search.state.allChannels, isTrue);
      expect(search.state.messages.map((message) => message.channelId), [
        'first',
        'second',
      ]);
      search.close();
      clock.flushMicrotasks();
    });
  });

  test('Повтор страницы обновляет сообщение и сохраняет прежний снимок', () {
    fakeAsync((clock) {
      final cursors = <String>[];
      final search = MessageSearchController(
        delay: Duration.zero,
        searchMessages: (_, cursor) async {
          cursors.add(cursor);
          return MessageSearchPage([
            Content(id: 'same', text: cursor.isEmpty ? 'до' : 'после'),
          ], next: cursor.isEmpty ? 'next' : '');
        },
      );
      search.changeQuery('поиск');
      clock.elapse(Duration.zero);
      final before = search.state;
      search.load(more: true);
      clock.flushMicrotasks();
      expect(search.state.messages.single.text, 'после');
      expect(before.messages.single.text, 'до');
      expect(() => before.messages.clear(), throwsUnsupportedError);
      search.load(more: true);
      clock.flushMicrotasks();
      expect(cursors, ['', 'next']);
      search.close();
      clock.flushMicrotasks();
    });
  });

  test('Закрытие отменяет таймер и не публикует поздний ответ', () {
    fakeAsync((clock) {
      final pending = Completer<MessageSearchPage>();
      var calls = 0;
      final search = MessageSearchController(
        searchMessages: (_, _) {
          calls++;
          return pending.future;
        },
      );
      search.changeQuery('поиск');
      clock.elapse(const Duration(milliseconds: 300));
      final before = search.state;
      search.changeQuery('другой');
      search.close();
      final closed = search.state;
      pending.complete(MessageSearchPage([Content(id: 'late')]));
      clock.elapse(const Duration(seconds: 1));
      clock.flushMicrotasks();
      expect(calls, 1);
      expect(before.loading, isTrue);
      expect(identical(search.state, closed), isTrue);
    });
  });

  test('Лимит выдачи останавливает дальнейшие запросы страниц', () {
    fakeAsync((clock) {
      var calls = 0;
      final search = MessageSearchController(
        delay: Duration.zero,
        searchMessages: (_, _) async {
          calls++;
          return MessageSearchPage(
            List.generate(210, (index) => Content(id: '$index')),
            next: 'more',
          );
        },
      );
      search.changeQuery('поиск');
      clock.elapse(Duration.zero);
      expect(search.state.messages, hasLength(200));
      search.load(more: true);
      clock.flushMicrotasks();
      expect(calls, 1);
      search.close();
      clock.flushMicrotasks();
    });
  });
}
