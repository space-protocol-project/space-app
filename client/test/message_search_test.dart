import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/message_search.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/ui/search.dart';

import 'mls_notifications_test.dart' show NotificationMlsClient;
import 'mls_view_test.dart' show entry;

Content hit(int sequence) => Content(
  id: 'id-$sequence',
  channelId: 'general',
  text: 'Найти запись $sequence',
  sequence: Int64(sequence),
);
Widget panel(Future<MessageSearchPage> Function(String, String) fetch) =>
    MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SpaceSearchPanel(
          sections: const {},
          messages: const [],
          searchMessages: fetch,
        ),
      ),
    );
void main() {
  test(
    'Серверная выдача проверяет канал, порядок, текст, повторы и курсор',
    () {
      final response = SearchContentResponse(
        contents: List.generate(50, (i) => hit(100 - i)),
        nextBeforeSequence: Int64(51),
      );
      expect(checkedSearchPage(response, 'general', 'найти', 0).next, '51');
      for (final bad in [
        SearchContentResponse(contents: [hit(3)..channelId = 'other']),
        SearchContentResponse(contents: [hit(3), hit(4)]),
        SearchContentResponse(contents: [hit(3), hit(3)]),
        SearchContentResponse(contents: [hit(3)..deleted = true]),
        SearchContentResponse(contents: [hit(3)..text = 'подмена']),
        SearchContentResponse(contents: [hit(3)], nextBeforeSequence: Int64(3)),
      ]) {
        expect(
          () => checkedSearchPage(bad, 'general', 'найти', 0),
          throwsStateError,
        );
      }
    },
  );
  test('Границы запроса не допускают пустые и чрезмерные строки', () {
    expect(checkedSearchQuery('  Найти  '), 'Найти');
    for (final value in ['', 'я', 'я' * 129]) {
      expect(() => checkedSearchQuery(value), throwsArgumentError);
    }
  });
  test('MLS: поиск локальный, включает архив, не показывает реакции, листает страницы', () async {
    final client = NotificationMlsClient();
    final messages = List.generate(52, (i) => entry(i + 1));
    messages.first['archived'] = true;
    client.local.channels['private'] = <String, dynamic>{
      'joined': true,
      'group_id': 'AQ==',
      'messages': messages,
    };
    final first = await searchMlsMessages(
      client,
      'private',
      [1],
      'Сообщение',
      '',
    );
    expect(first.messages, hasLength(50));
    final second = await searchMlsMessages(
      client,
      'private',
      [1],
      'Сообщение',
      first.next,
    );
    expect(second.messages, hasLength(2));
    expect(second.messages.last.text, 'Сообщение 1');
    expect(second.next, isEmpty);
    expect(client.calls, 0);
    await expectLater(
      searchMlsMessages(client, 'private', [2], 'Сообщение', ''),
      throwsStateError,
    );
    client.local.error = MlsRecoveryRequired();
    await expectLater(
      searchMlsMessages(client, 'private', [1], 'Сообщение', ''),
      throwsA(isA<MlsRecoveryRequired>()),
    );
  });
  testWidgets('Поиск: старый ответ не подменяет новый, страницы дополняются', (
    tester,
  ) async {
    final old = Completer<MessageSearchPage>();
    final requests = <(String, String)>[];
    await tester.pumpWidget(
      panel((query, cursor) async {
        requests.add((query, cursor));
        if (query == 'старое') return old.future;
        return MessageSearchPage([
          Content(
            id: cursor.isEmpty ? 'new' : 'more',
            text: cursor.isEmpty ? 'Новый результат' : 'Продолжение',
          ),
        ], next: cursor.isEmpty ? 'next' : '');
      }),
    );
    final input = find.byKey(const ValueKey('space-search-input'));
    await tester.enterText(input, 'старое');
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pump();
    await tester.enterText(input, 'новое');
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pumpAndSettle();
    old.complete(
      MessageSearchPage([Content(id: 'old', text: 'Устаревший результат')]),
    );
    await tester.pumpAndSettle();
    expect(find.text('Новый результат'), findsOneWidget);
    expect(find.text('Устаревший результат'), findsNothing);
    await tester.tap(find.text('Ещё сообщения'));
    await tester.pumpAndSettle();
    expect(find.text('Продолжение'), findsOneWidget);
    expect(requests.last, ('новое', 'next'));
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Закрытие панели отменяет отложенный запрос', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      panel((_, _) async {
        calls++;
        return const MessageSearchPage([]);
      }),
    );
    await tester.enterText(find.byType(TextField), 'поиск');
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(calls, 0);
  });
}
