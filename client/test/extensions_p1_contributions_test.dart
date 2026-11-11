import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/actions.dart';
import 'package:space_client/src/extensions_p1/contributions.dart';
import 'package:space_client/src/extensions_p1/contributions_cubit.dart';
import 'package:space_client/src/extensions_p1/contributions_transport.dart';
import 'package:space_client/src/extensions_p1/document.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.pb.dart';
import 'package:space_client/ui/extension_contributions.dart';

ListExtensionContributionsResponse registryResponse() =>
    ListExtensionContributionsResponse(
      registrySha256: List.filled(32, 7),
      contributions: [
        ExtensionContribution(
          id: 'summary',
          query: 'summary',
          kind: ExtensionContributionKind.EXTENSION_CONTRIBUTION_KIND_OVERVIEW,
          title: {'en': 'Summary', 'ru': 'Сводка'}.entries,
        ),
        ExtensionContribution(
          id: 'details',
          query: 'details',
          kind: ExtensionContributionKind.EXTENSION_CONTRIBUTION_KIND_SECTION,
          title: {'en': 'Details'}.entries,
        ),
      ],
    );

ExtensionDocument document(String text) => ExtensionDocument.parse(
  utf8.encode(
    jsonEncode({
      'ui_api': 'space.ui.p1',
      'strings': {
        'en': {'text': text},
      },
      'body': [
        {'id': 'text', 'component': 'text.v1', 'label_key': 'text'},
      ],
    }),
  ),
  {},
);

class FakeContributions implements ContributionsTransport {
  final pending = <Completer<ExtensionDocument>>[];
  final queries = <String>[];
  var response = registryResponse();
  bool failList = false;
  int cancellations = 0;
  @override
  Future<ContributionRegistry> list() async {
    if (failList) throw StateError('Отказ');
    return ContributionRegistry.parse(response);
  }

  @override
  Future<ExtensionDocument> query(String name) {
    queries.add(name);
    final result = Completer<ExtensionDocument>();
    pending.add(result);
    return result.future;
  }

  @override
  Future<void> command(String name) async => throw StateError('Нет доступа');
  @override
  void cancel() => cancellations++;
}

void main() {
  test('Неизменяемые метаданные, сортировка и fallback', () {
    final response = registryResponse();
    final parsed = ContributionRegistry.parse(response);
    response.contributions.last.title['en'] = 'Changed';
    expect(parsed.entries.first.label('ru'), 'Details');
    expect(parsed.entries.last.label('ru-RU'), 'Сводка');
    expect(() => parsed.entries.clear(), throwsUnsupportedError);
    expect(
      () => parsed.entries.first.title['en'] = 'x',
      throwsUnsupportedError,
    );
  });
  final invalid = <String, void Function(ListExtensionContributionsResponse)>{
    'digest': (r) => r.registrySha256 = [],
    'duplicate': (r) => r.contributions.add(r.contributions.first.deepCopy()),
    'limit': (r) => r.contributions.addAll(
      List.generate(33, (_) => r.contributions.first.deepCopy()),
    ),
    'kind': (r) => r.contributions.first.kind =
        ExtensionContributionKind.EXTENSION_CONTRIBUTION_KIND_UNSPECIFIED,
    'query': (r) => r.contributions.first.query = '../path',
    'fallback': (r) => r.contributions.first.title.remove('en'),
    'blank': (r) => r.contributions.first.title['en'] = '  ',
    'control': (r) => r.contributions.first.title['en'] = 'a\nb',
    'long': (r) => r.contributions.first.title['en'] = '😀' * 121,
  };
  for (final entry in invalid.entries) {
    test('Отклоняется ${entry.key}', () {
      final response = registryResponse();
      entry.value(response);
      expect(() => ContributionRegistry.parse(response), throwsFormatException);
    });
  }
  test('Поздний ответ не заменяет новый выбранный элемент', () async {
    final transport = FakeContributions();
    final cubit = ContributionsCubit(transport);
    await cubit.load();
    final old = cubit.open('summary');
    final latest = cubit.open('details');
    transport.pending.last.complete(document('new'));
    await latest;
    transport.pending.first.complete(document('old'));
    await old;
    expect(cubit.state.document!.text('en', 'text'), 'new');
    expect(transport.queries, ['summary', 'details']);
    await cubit.close();
  });
  for (final mode in ['invalidate', 'close', 'back']) {
    test('Поздний ответ после $mode не возвращает документ', () async {
      final transport = FakeContributions();
      final cubit = ContributionsCubit(transport);
      await cubit.load();
      final pending = cubit.open('details');
      switch (mode) {
        case 'invalidate':
          cubit.invalidate();
        case 'close':
          await cubit.close();
        case 'back':
          await cubit.back();
      }
      transport.pending.single.complete(document('old'));
      await pending;
      expect(cubit.state.document, isNull);
      expect(transport.cancellations, greaterThan(1));
      await cubit.close();
    });
  }
  test(
    'Отказ query очищает список и документ; повтор требует новый список',
    () async {
      final transport = FakeContributions();
      final cubit = ContributionsCubit(transport);
      await cubit.load();
      await cubit.open('unknown');
      expect(transport.queries, isEmpty);
      final pending = cubit.open('details');
      transport.pending.single.completeError(StateError('Отозвано'));
      await pending;
      expect(cubit.state.phase, ContributionsPhase.failed);
      expect(cubit.state.entries, isEmpty);
      await cubit.load();
      expect(cubit.state.phase, ContributionsPhase.list);
      await cubit.close();
    },
  );
  testWidgets('Список, открытие, возврат, пустое состояние и повтор', (
    tester,
  ) async {
    final transport = FakeContributions();
    final cubit = ContributionsCubit(transport);
    final actions = ExtensionActions({});
    addTearDown(cubit.close);
    addTearDown(actions.close);
    await cubit.load();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExtensionContributionsView(cubit: cubit, actions: actions),
        ),
      ),
    );
    expect(find.text('Сводка'), findsOneWidget);
    expect(find.text('Раздел'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('contribution-details')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    transport.pending.single.complete(document('Содержимое раздела'));
    await tester.pumpAndSettle();
    expect(find.text('Содержимое раздела'), findsOneWidget);
    transport.failList = true;
    await tester.tap(find.text('К списку'));
    await tester.pumpAndSettle();
    expect(find.text('Содержимое раздела'), findsNothing);
    expect(find.text('Расширение недоступно'), findsOneWidget);
    transport.failList = false;
    transport.response.contributions.clear();
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.text('Нет элементов расширения'), findsOneWidget);
  });
}
