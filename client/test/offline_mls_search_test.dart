import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/message_search.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/saved_archive.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/shell.dart';

import 'channels_test.dart' show MemoryHistory, MemoryPositions, chat;
import 'chat_history_test.dart' show RecordVault;
import 'mls_native_test.dart' show MemoryMlsStorage;
import 'mls_notifications_test.dart' show NotificationMlsStore;
import 'mls_view_test.dart' show entry;
import 'support/chat_outbox.dart';
import 'support/temp_directory.dart';

const origin = 'http://127.0.0.1:18080';

Future<(DeviceRecord, ChatHistory)> archiveIdentity() async {
  final record = DeviceRecord(
    origin: origin,
    serverId: 'server',
    serverKey: 'key',
    rootSeed: List.filled(32, 1),
    deviceSeed: List.filled(32, 2),
    grantId: 'active-grant',
  );
  final principal = (await record.identity()).principalId;
  record.mlsIdentity = {
    'server_id': 'server',
    'principal_id': principal,
    'grant_id': 'original-mls-leaf',
    'public_key': List.filled(32, 3),
  };
  final history =
      ChatHistory(
          serverId: 'server',
          principalId: principal,
          grantId: record.grantId,
        )
        ..channels = [
          chat('general'),
          chat('private')..mlsGroupId = [1],
        ];
  return (record, history);
}

void main() {
  test(
    'Сохранённый MLS: только чтение, привязка устройства, потеря и откат',
    () async {
      final (record, history) = await archiveIdentity();
      final root = await Directory.systemTemp.createTemp(
        'space-search-archive-',
      );
      addTearDown(
        () => deleteTestDirectory(root, prefix: 'space-search-archive-'),
      );
      final keys = MemoryMlsStorage();
      final archive = await openSavedMlsArchive(
        RecordVault(record),
        origin,
        history,
        storage: keys,
        directory: root,
      );
      await expectLater(archive.read(), throwsA(isA<MlsRecoveryRequired>()));
      expect(keys.values, isEmpty);
      keys.values[archive.storageKey] = jsonEncode({
        'v': 1,
        'scope': record.mlsIdentity,
        'channels': {
          'private': {
            'joined': true,
            'group_id': 'AQ==',
            'messages': [entry(1)],
          },
        },
      });
      final before = Map.of(keys.values);
      expect(
        (await searchSavedMlsMessages(
          archive,
          'private',
          [1],
          'Сообщение',
          '',
        )).messages,
        hasLength(1),
      );
      expect(keys.values, before);
      await expectLater(
        archive.storage.write(key: 'x', value: 'secret'),
        throwsStateError,
      );
      await expectLater(
        archive.engine.execute({'op': 'new'}),
        throwsStateError,
      );
      await File.fromUri(root.uri.resolve('${archive.storageKey}.witness'))
          .writeAsString('wrong');
      await expectLater(archive.read(), throwsA(isA<MlsRecoveryRequired>()));
      expect(keys.values, before);
      final otherGrant = ChatHistory(
        serverId: history.serverId,
        principalId: history.principalId,
        grantId: 'different',
      );
      await expectLater(
        openSavedMlsArchive(
          RecordVault(record),
          origin,
          otherGrant,
          storage: keys,
          directory: root,
        ),
        throwsStateError,
      );
      await expectLater(
        openSavedMlsArchive(
          RecordVault(record),
          '$origin/other',
          history,
          storage: keys,
          directory: root,
        ),
        throwsStateError,
      );
    },
  );

  test(
    'Большой MLS-архив: страницы после удаления границы, правки и реакции',
    () async {
      final items = List.generate(10000, (i) {
        final item = entry(i + 1);
        (item['message'] as Map)['id'] = List.generate(
          16,
          (byte) => byte < 4 ? ((i + 1) >> (byte * 8)) & 255 : 0,
        );
        return item;
      });
      final saved = <String, dynamic>{
        'joined': true,
        'group_id': 'AQ==',
        'messages': items,
      };
      final document = <String, dynamic>{
        'channels': {'private': saved},
      };
      final clock = Stopwatch()..start();
      final first = await searchMlsDocument(
        document,
        'private',
        [1],
        'Сообщение',
        '',
      );
      debugPrint(
        'MLS: 10000 записей, первая страница ${clock.elapsedMilliseconds} мс',
      );
      expect(first.messages, hasLength(50));
      expect(first.messages.first.sequence.toInt(), 10000);
      expect(first.messages.last.sequence.toInt(), 9951);
      items[9950]['deleted'] = true;
      final second = await searchMlsDocument(
        document,
        'private',
        [1],
        'Сообщение',
        first.next,
      );
      expect(second.messages.first.sequence.toInt(), 9950);
      expect(second.messages.last.sequence.toInt(), 9901);
      await expectLater(
        searchMlsDocument(document, 'private', [1], 'Другой', first.next),
        throwsStateError,
      );
      final changed = Map<String, dynamic>.from(items.last);
      changed['message'] = {
        ...items.last['message'] as Map,
        'text': 'Изменено',
      };
      saved['archived_messages'] = [items.last];
      saved['messages'] = [
        changed,
        entry(2)
          ..['message'] = {
            'id': List.filled(16, 2),
            'reaction': {'emoji': '❤'},
          },
      ];
      expect(
        (await searchMlsDocument(
          document,
          'private',
          [1],
          'Сообщение',
          '',
        )).messages,
        isEmpty,
      );
      expect(
        (await searchMlsDocument(
          document,
          'private',
          [1],
          'Изменено',
          '',
        )).messages,
        hasLength(1),
      );
      saved['revocation_pending'] = true;
      await expectLater(
        searchMlsDocument(document, 'private', [1], 'Изменено', ''),
        throwsStateError,
      );
    },
  );

  testWidgets('Офлайн-каталог MLS: поиск и чтение без сессии и сети', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    late DeviceRecord record;
    late ChatHistory history;
    late ServerWorkspaces workspaces;
    final local = NotificationMlsStore();
    local.channels['private'] = <String, dynamic>{
      'joined': true,
      'group_id': 'AQ==',
      'messages': [entry(1)],
    };
    var network = 0;
    await tester.runAsync(() async {
      (record, history) = await archiveIdentity();
      final vault = RecordVault(record);
      final store = MemoryHistory()..data[origin] = history;
      workspaces = ServerWorkspaces(
        vault: vault,
        create: (_) => ChatController(
          vault,
          historyStore: store,
          positions: MemoryPositions(),
          outboxStore: MemoryChatOutbox(),
          fileStore: EmptyQueuedFiles(),
          openMlsArchive: (_, _, _) async => local,
          openSession: (_, _) async {
            network++;
            throw StateError('Нет сети');
          },
        ),
        resume: (origin, controller) => controller.restoreHistory(origin),
      );
      await workspaces.synchronize([origin]);
      await workspaces.refresh();
    });
    final preferences = AppPreferences()..origins.add(origin);
    final presence = ServerPresence(probe: (_) async => false);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AdminLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        home: SpaceShell(
          controller: workspaces[origin],
          workspaces: workspaces,
          preferences: preferences,
          presence: presence,
          hostingEnabled: false,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Поиск'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Сохранённые закрытые каналы'));
    await tester.enterText(find.byType(TextField), 'Сообщение');
    await tester.pump(const Duration(milliseconds: 310));
    await tester.runAsync(
      () async => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Сообщение 1'), findsOneWidget);
    await tester.tap(find.text('Сообщение 1'));
    await tester.pumpAndSettle();
    expect(
      find.text('Сохранённое сообщение · без подключения к серверу'),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SelectableText && widget.data == 'Сообщение 1',
      ),
      findsOneWidget,
    );
    expect(network, 0);
    expect(workspaces[origin]!.connected, isFalse);
    await tester.runAsync(() => workspaces[origin]!.clearOfflineData());
    await tester.pumpAndSettle();
    expect(
      find.text('Сохранённое сообщение · без подключения к серверу'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    workspaces.dispose();
    preferences.dispose();
    presence.dispose();
  });
}
