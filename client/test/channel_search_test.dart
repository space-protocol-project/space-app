import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/channel_search.dart';
import 'package:space_client/src/message_search.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/ui/search.dart';

Content result(String channel, String text) =>
    Content(id: 'same-id', channelId: channel, text: text);

void main() {
  test('Каналы: страницы не теряют одинаковые ID и границы канала', () async {
    final calls = <(String, String)>[];
    Future<MessageSearchPage> fetch(
      String channel,
      String query,
      String after,
    ) async {
      calls.add((channel, after));
      return MessageSearchPage([
        result(channel, 'Найти $channel'),
      ], next: channel == 'a' && after.isEmpty ? 'older' : '');
    }

    var cursor = '';
    final found = <Content>[];
    do {
      final page = await searchChannelPages(
        channels: ['a', 'b'],
        query: 'Найти',
        cursor: cursor,
        fetch: fetch,
      );
      found.addAll(page.messages);
      cursor = page.next;
    } while (cursor.isNotEmpty);
    expect(calls, [('a', ''), ('a', 'older'), ('b', '')]);
    expect(found.map((m) => m.channelId), ['a', 'a', 'b']);
  });

  test('Каналы: бюджет пустой страницы и привязка курсора', () async {
    final calls = <String>[];
    Future<MessageSearchPage> fetch(
      String channel,
      String query,
      String after,
    ) async {
      calls.add(channel);
      return const MessageSearchPage([]);
    }

    final channels = List.generate(9, (i) => '$i');
    final first = await searchChannelPages(
      channels: channels,
      query: 'Найти',
      cursor: '',
      fetch: fetch,
    );
    expect(calls, ['0', '1', '2', '3']);
    expect(first.next, isNotEmpty);
    for (final changed in [false, true]) {
      await expectLater(
        searchChannelPages(
          channels: changed ? channels.reversed.toList() : channels,
          query: changed ? 'Найти' : 'Другой',
          cursor: first.next,
          fetch: fetch,
        ),
        throwsStateError,
      );
    }
    expect(calls, hasLength(4));
    final second = await searchChannelPages(
      channels: channels,
      query: 'Найти',
      cursor: first.next,
      fetch: fetch,
    );
    expect(calls.skip(4), ['4', '5', '6', '7']);
    final last = await searchChannelPages(
      channels: channels,
      query: 'Найти',
      cursor: second.next,
      fetch: fetch,
    );
    expect(last.next, isEmpty);
    expect(calls.last, '8');
  });

  test('Каналы: ошибка не сдвигает границу; чужой ответ отклоняется', () async {
    var fail = true;
    Future<MessageSearchPage> fetch(
      String channel,
      String query,
      String after,
    ) async {
      if (fail) throw StateError('Нет сети');
      return MessageSearchPage([result(channel, 'Найти')]);
    }

    await expectLater(
      searchChannelPages(
        channels: ['a'],
        query: 'Найти',
        cursor: '',
        fetch: fetch,
      ),
      throwsStateError,
    );
    fail = false;
    expect(
      (await searchChannelPages(
        channels: ['a'],
        query: 'Найти',
        cursor: '',
        fetch: fetch,
      )).messages.single.channelId,
      'a',
    );
    await expectLater(
      searchChannelPages(
        channels: ['a'],
        query: 'Найти',
        cursor: '',
        fetch: (_, _, _) async => MessageSearchPage([result('other', 'Найти')]),
      ),
      throwsStateError,
    );
    await expectLater(
      searchChannelPages(
        channels: ['a'],
        query: 'Найти',
        cursor: '',
        fetch: (_, _, _) async => const MessageSearchPage([], next: 'x'),
      ),
      throwsStateError,
    );
  });

  testWidgets('Все каналы: одинаковые ID видны, показаны названия каналов', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SpaceSearchPanel(
            sections: const {},
            messages: const [],
            channelNames: const {'a': 'Общий', 'b': 'Команда'},
            searchMessages: (_, _) async => const MessageSearchPage([]),
            searchAllChannels: (_, _) async => MessageSearchPage([
              result('a', 'Найти первое'),
              result('b', 'Найти второе'),
            ]),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('search-all-channels')));
    await tester.enterText(find.byType(TextField), 'Найти');
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pumpAndSettle();
    expect(find.text('Найти первое'), findsOneWidget);
    expect(find.text('Найти второе'), findsOneWidget);
    expect(find.text('Общий · '), findsOneWidget);
    expect(find.text('Команда · '), findsOneWidget);
    expect(
      find.text('Закрытые чаты — поиск только на этом устройстве'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
