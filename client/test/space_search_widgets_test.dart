import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/space_search.dart';
import 'package:space_client/ui/space_search.dart';

import 'support/space_search.dart';

Future<void> openSearch(
  WidgetTester tester,
  FakeSpaceSearch api, {
  double width = 1280,
  double scale = 1,
  bool Function()? available,
  Stream<Object?> changes = const Stream.empty(),
  void Function(SpaceSearchResult?)? selected,
  VoidCallback? chatSearch,
}) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
  });
  Widget entry(BuildContext context) => Scaffold(
    body: TextButton(
      key: const ValueKey('open'),
      child: const Text('Открыть'),
      onPressed: () async {
        final hit = await showSpaceSearch(
          context,
          api: api,
          channels: searchChannels,
          changes: changes,
          available: available ?? () => true,
          chatSearch: chatSearch,
        );
        selected?.call(hit);
      },
    ),
  );
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Builder(builder: entry),
    ),
  );
  await tester.tap(find.byKey(const ValueKey('open')));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const ValueKey('space-search-input')),
    'совет',
  );
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

void main() {
  for (final size in [(360.0, 1.0), (1280.0, 1.0), (360.0, 2.0)]) {
    testWidgets('Общий поиск: ширина ${size.$1}, масштаб ${size.$2}', (
      tester,
    ) async {
      final api = FakeSpaceSearch();
      SpaceSearchResult? selected;
      await openSearch(
        tester,
        api,
        width: size.$1,
        scale: size.$2,
        selected: (r) => selected = r,
      );
      expect(find.text('Поиск в пространстве'), findsOneWidget);
      final item = api.items.first;
      final finder = find.byKey(
        ValueKey('space-search-${spaceSearchKey(item)}'),
      );
      expect(finder, findsOneWidget);
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(selected?.id, item.id);
      expect(selected?.parentId, 'parent');
      expect(selected?.sequence.toInt(), 3);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Следующая страница и точная цель обычного чата', (tester) async {
    final api = FakeSpaceSearch();
    api.onSearch = (q, t) async => t.isEmpty
        ? SearchSpaceResponse(
            results: [searchHit('topic', time: 2000)],
            nextPageToken: 'next',
          )
        : SearchSpaceResponse(results: [searchHit('message', kind: 1)]);
    SpaceSearchResult? result;
    await openSearch(tester, api, selected: (r) => result = r);
    await tester.tap(find.byKey(const ValueKey('space-search-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('space-search-1:chat:message')));
    await tester.pumpAndSettle();
    expect(result?.channelId, 'chat');
    expect(result?.id, 'message');
    expect(result?.sequence.toInt(), 3);
    expect(api.calls, [('совет', ''), ('совет', 'next')]);
  });

  testWidgets('Смена контекста немедленно очищает видимую выдачу', (
    tester,
  ) async {
    var available = true;
    final changes = StreamController<Object?>.broadcast();
    addTearDown(changes.close);
    await openSearch(
      tester,
      FakeSpaceSearch(),
      available: () => available,
      changes: changes.stream,
    );
    expect(find.byType(ListTile), findsWidgets);
    available = false;
    changes.add(null);
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('Локальный режим чата остаётся отдельным действием', (
    tester,
  ) async {
    var opened = false;
    await openSearch(
      tester,
      FakeSpaceSearch(),
      chatSearch: () => opened = true,
    );
    await tester.tap(find.byTooltip('Поиск в выбранном чате и локальном MLS'));
    await tester.pumpAndSettle();
    expect(opened, isTrue);
    expect(find.byType(SpaceSearchDialog), findsNothing);
  });
}
