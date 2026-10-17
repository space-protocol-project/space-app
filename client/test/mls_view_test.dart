import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/rpc_clients.dart' show MlsDevice;
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/replies.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/native.dart';
import 'package:space_client/ui/mls_channel.dart';
import 'package:space_client/ui/mls_files.dart';
import 'package:space_client/ui/message_footer.dart';
import 'package:space_client/ui/message_markdown.dart';
import 'package:space_client/ui/message_reactions.dart';

import 'mls_native_test.dart' show MemoryMlsStorage;

Map<String, dynamic> entry(int index) => {
  'author_id': 'participant',
  'grant_id': 'other-grant',
  'sequence': index,
  'time': DateTime(2026, 10, 15).millisecondsSinceEpoch,
  'message': {
    'id': List.filled(16, index),
    'text': 'Сообщение $index',
    'files': [
      {'name': 'Файл-$index.txt', 'size': 8, 'asset_id': 'asset-$index'},
    ],
  },
};

class _Client implements MlsClient {
  _Client(int count)
    : data = MlsChannelData({
        'joined': true,
        'managers': <String>[],
        'roster': <dynamic>[],
        'messages': List.generate(count, entry),
      });
  final MlsChannelData data;
  @override
  final local = MlsLocalStore(
    storage: MemoryMlsStorage(),
    engine: NativeMlsEngine(),
    scope: {
      'server_id': 'server',
      'principal_id': 'own',
      'grant_id': 'own-grant',
    },
    deviceSeed: List.filled(32, 1),
  );
  List<MlsDevice> listed = [];
  @override
  Future<List<MlsDevice>> devices(String channel) async => listed;
  Completer<void>? delayed;
  @override
  Future<MlsChannelData> refresh(String channel, List<int> group) async {
    await delayed?.future;
    return data;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Session implements SpaceSession {
  _Session(this.client);
  final MlsClient client;
  @override
  Future<MlsClient> mlsClient() async => client;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget app(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  for (final width in [390.0, 1500.0]) {
    testWidgets('MLS: Markdown и время справа от реакций на ширине $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final client = _Client(1);
      final message = client.data.messages.single['message'] as Map;
      message['text'] = '**Жирный текст**\n\n![Иллюстрация](https://example.invalid/private.png)';
      message['files'] = <Map<String, dynamic>>[];
      await tester.pumpWidget(
        app(
          MlsChannelView(
            session: _Session(client),
            channelId: 'private',
            groupId: List.filled(32, 1),
            attachmentsEnabled: true,
            canWrite: true,
            active: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MessageMarkdown), findsOneWidget);
      expect(find.text('Жирный текст', findRichText: true), findsOneWidget);
      expect(find.textContaining('**Жирный текст**'), findsNothing);
      expect(find.byType(Image), findsNothing);
      final footer = find.byType(MessageFooter);
      final metadata = find
          .descendant(of: footer, matching: find.byType(Text))
          .last;
      final reactions = find.byType(MessageReactionBar);
      expect(
        tester.getRect(metadata).right,
        closeTo(tester.getRect(footer).right, .1),
      );
      expect(
        tester.getRect(metadata).left,
        greaterThanOrEqualTo(tester.getRect(reactions).right),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('MLS: уведомление прокручивает список к сообщению вне экрана', (
    tester,
  ) async {
    final client = _Client(100);
    client.data.channel['messages'] = (client.data.channel['messages'] as List)
        .reversed
        .toList();
    await tester.pumpWidget(
      app(
        MlsChannelView(
          session: _Session(client),
          channelId: 'private',
          groupId: List.filled(32, 1),
          attachmentsEnabled: false,
          canWrite: true,
          active: false,
          jumpRequest: mlsMessageKey(entry(70)),
          jumpGeneration: 1,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Сообщение 70').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'MLS: ответ через меню, предпросмотр и отмена сохраняют черновик',
    (tester) async {
      final client = _Client(1);
      await tester.pumpWidget(
        app(
          MlsChannelView(
            session: _Session(client),
            channelId: 'private',
            groupId: List.filled(32, 1),
            attachmentsEnabled: true,
            canWrite: true,
            active: false,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Черновик ответа');
      await tester.longPress(find.text('Сообщение 0'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ответить'));
      await tester.pumpAndSettle();
      expect(find.text('Сообщение 0\nФайл-0.txt'), findsOneWidget);
      await tester.tap(find.byTooltip('Отменить ответ'));
      await tester.pumpAndSettle();
      expect(find.text('Сообщение 0\nФайл-0.txt'), findsNothing);
      expect(find.text('Черновик ответа'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'Передача управления требует подтверждения и сохраняет роль при отмене',
    (tester) async {
      final client = _Client(0);
      final peer = MlsDevice(
        grantId: 'other-grant',
        principalId: 'participant',
      );
      final binding = {
        'device': {'grant_id': peer.grantId, 'principal_id': peer.principalId},
      };
      peer.binding = utf8.encode(jsonEncode(binding));
      client.listed = [peer];
      client.data.channel['managers'] = ['own-grant'];
      client.data.channel['roster'] = [binding];
      await tester.pumpWidget(
        app(
          MlsChannelView(
            session: _Session(client),
            channelId: 'private',
            groupId: List.filled(32, 1),
            attachmentsEnabled: true,
            canWrite: true,
            active: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> openConfirmation() async {
        await tester.tap(find.byTooltip('Устройства канала'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(PopupMenuButton<String>),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Передать управление'));
        await tester.pumpAndSettle();
        expect(find.text('Передать управление каналом?'), findsOneWidget);
      }

      await openConfirmation();
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(client.data.channel['managers'], ['own-grant']);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  for (final width in [390.0, 1500.0]) {
    testWidgets('MLS: текст, файлы и запрет вложений на ширине $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final session = _Session(_Client(1));
      Widget view(bool files) => app(
        MlsChannelView(
          key: const ValueKey('mls'),
          session: session,
          channelId: 'private',
          groupId: List.filled(32, 1),
          attachmentsEnabled: files,
          canWrite: true,
          active: true,
        ),
      );
      await tester.pumpWidget(view(true));
      await tester.pumpAndSettle();
      expect(find.text('Сообщение 0'), findsOneWidget);
      expect(find.text('Файл-0.txt'), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Файлы канала'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(view(false));
      await tester.pumpAndSettle();
      expect(find.text('Файл-0.txt'), findsNothing);
      expect(find.byTooltip('Прикрепить файл'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('Синхронизация MLS не отключает поле во время набора', (
    tester,
  ) async {
    final client = _Client(0);
    await tester.pumpWidget(
      app(
        MlsChannelView(
          session: _Session(client),
          channelId: 'private',
          groupId: List.filled(32, 1),
          attachmentsEnabled: true,
          canWrite: true,
          active: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Черновик');
    client.delayed = Completer<void>();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
    expect(find.text('Черновик'), findsOneWidget);
    client.delayed!.complete();
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Файловая панель MLS компактная и прокручивает длинный список', (
    tester,
  ) async {
    Widget panel(int count) => app(
      Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          width: 320,
          height: 600,
          child: Align(
            alignment: Alignment.topCenter,
            child: MlsFilesPanel(
              messages: List.generate(count, entry),
              ownId: 'own',
              download: (_, _) async {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(panel(1));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MlsFilesPanel)).height, lessThan(400));
    await tester.pumpWidget(panel(40));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(ListView), const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
