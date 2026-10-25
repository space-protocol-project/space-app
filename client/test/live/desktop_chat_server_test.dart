import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/replies.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/mls_channel.dart';
import 'package:space_client/ui/message_context_menu.dart';

import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import '../mls_native_test.dart' show MemoryMlsStorage;
import '../support/chat_outbox.dart';
import 'mls_server_test.dart' show client;

class _ClosedSession implements SpaceSession {
  _ClosedSession(this.client);
  final MlsClient client;
  @override
  bool get chatMentionsSupported => false;
  @override
  Future<MlsClient> mlsClient() async => client;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: child),
);

Future<void> _networkFrames(
  WidgetTester tester, {
  required bool Function() ready,
}) async {
  final timer = Stopwatch()..start();
  while (timer.elapsed < const Duration(seconds: 15)) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(milliseconds: 50));
    if (ready()) return;
  }
  fail('Интерфейс не получил результат настоящего RPC за 15 секунд');
}

Future<void> _send(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField).last, text);
  await tester.tap(find.byTooltip('Отправить'));
  await _networkFrames(tester, ready: () => _messageReady(tester, text));
  expect(
    tester.widget<TextField>(find.byType(TextField).last).controller!.text,
    '',
  );
  expect(tester.takeException(), isNull);
}

bool _messageReady(WidgetTester tester, String text) => tester
    .widgetList<MessageContextMenu>(find.byType(MessageContextMenu))
    .any(
      (menu) =>
          menu.text == text && menu.onReply != null && menu.onReact != null,
    );

Future<void> _reply(WidgetTester tester, String text) async {
  await _menu(tester, text);
  await tester.tap(find.text('Ответить'));
  await _networkFrames(
    tester,
    ready: () =>
        find.byTooltip('Отменить ответ').hitTestable().evaluate().isNotEmpty,
  );
}

Future<void> _react(WidgetTester tester, String text) async {
  await _menu(tester, text);
  await tester.tap(find.text('❤️').last);
  await _networkFrames(
    tester,
    ready: () => find.byType(InputChip).hitTestable().evaluate().isNotEmpty,
  );
}

Future<void> _menu(WidgetTester tester, String text) async {
  final gesture = await tester.startGesture(
    tester.getCenter(find.text(text, findRichText: true).first),
    kind: PointerDeviceKind.mouse,
    buttons: kSecondaryMouseButton,
  );
  await gesture.up();
  await _networkFrames(
    tester,
    ready: () => find.text('Ответить').hitTestable().evaluate().isNotEmpty,
  );
}

void main() {
  final origin = Platform.environment['SPACE_DESKTOP_CHAT_TEST_ORIGIN'];
  if (origin == null) {
    if (Platform.environment['SPACE_REQUIRE_DESKTOP_CHAT_TEST'] == '1') {
      throw StateError('В обязательной проверке CI не задан адрес runtime');
    }
    test(
      'Десктопный интерфейс с настоящим runtime',
      () {},
      skip:
          'Нужна отдельная база: tools/check_attachments.ps1 -Scenario desktop',
    );
    return;
  }
  final uri = Uri.parse(origin);
  if (uri.scheme != 'http' ||
      InternetAddress.tryParse(uri.host)?.isLoopback != true) {
    throw StateError('Разрешён только отдельный локальный тестовый runtime');
  }

  late SpaceSession owner, peer;
  late Discovery discovery;
  late MlsClient ownMls, peerMls;
  late List<int> group;
  late ChatController chat;
  final vault = KeyIdentityVault(MemoryMlsStorage());
  final mlsStore = MemoryMlsStorage();
  final previousHttp = HttpOverrides.current;
  setUpAll(() async {
    // Flutter блокирует HTTP в widget-тестах. Здесь адрес ограничен loopback выше.
    HttpOverrides.global = null;
    SharedPreferences.setMockInitialValues({});
    discovery = await discover(origin);
    owner = await SpaceSession.connect(discovery, vault);
    peer = await SpaceSession.connect(
      discovery,
      KeyIdentityVault(MemoryMlsStorage()),
    );
    expect(owner.role, 'owner', reason: 'Нужна новая отдельная тестовая схема');
    ownMls = await client(owner, mlsStore);
    peerMls = await client(peer, MemoryMlsStorage());
    await ownMls.initialize();
    await peerMls.initialize();
    await ownMls.createChannel('private-ui', 'Закрытый UI-чат');
    final devices = await ownMls.devices('private-ui');
    final ownDevice = devices.firstWhere(
      (d) => d.grantId == owner.record.grantId,
    );
    final peerDevice = devices.firstWhere(
      (d) => d.grantId == peer.record.grantId,
    );
    await ownMls.trust(peerDevice);
    await peerMls.trust(ownDevice);
    await ownMls.invite('private-ui', peerDevice);
    await owner.refreshChannels();
    group = owner.availableChannels
        .firstWhere((c) => c.id == 'private-ui')
        .mlsGroupId;
    await peerMls.refresh('private-ui', group);
    chat = ChatController(
      vault,
      positions: MemoryPositions(),
      historyStore: MemoryHistory(),
      outboxStore: MemoryChatOutbox(),
      fileStore: EmptyQueuedFiles(),
      openSession: (_, _) async => owner,
    )..preview = discovery;
    await chat.connect();
  });
  var closed = false;
  Future<void> closeClients() async {
    if (closed) return;
    closed = true;
    chat.dispose();
    await owner.close();
    await peer.close();
  }

  tearDownAll(() async {
    await closeClients();
    HttpOverrides.global = previousHttp;
  });

  testWidgets('Поле ввода → RPC/PostgreSQL → второй клиент: обычный и MLS', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _app(ChatView(controller: chat, openConnection: () {})),
    );
    await _networkFrames(
      tester,
      ready: () => find.byType(TextField).evaluate().isNotEmpty,
    );
    await _send(tester, 'Обычный UI-исходник');
    await _reply(tester, 'Обычный UI-исходник');
    await _send(tester, 'Обычный UI-ответ');
    await _react(tester, 'Обычный UI-исходник');
    await tester.runAsync(() async {
      final messages = await peer.messages();
      final parent = messages.singleWhere(
        (m) => m.text == 'Обычный UI-исходник',
      );
      final answer = messages.singleWhere((m) => m.text == 'Обычный UI-ответ');
      expect(answer.replyToId, parent.id);
      expect(parent.reactions.single.emoji, '❤️');
      expect(parent.reactions.single.principalIds, contains(owner.principalId));
    });

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _app(
        MlsChannelView(
          session: _ClosedSession(ownMls),
          channelId: 'private-ui',
          groupId: group,
          attachmentsEnabled: true,
          canWrite: true,
          active: true,
        ),
      ),
    );
    await _networkFrames(
      tester,
      ready: () => tester
          .widgetList<TextField>(find.byType(TextField))
          .any((field) => field.enabled == true),
    );
    await _send(tester, 'Закрытый UI-исходник');
    await _reply(tester, 'Закрытый UI-исходник');
    await _send(tester, 'Закрытый UI-ответ');
    await _react(tester, 'Закрытый UI-исходник');
    await tester.runAsync(() async {
      final messages = (await peerMls.refresh('private-ui', group)).messages;
      final parent = messages.singleWhere(
        (m) => m['message']['text'] == 'Закрытый UI-исходник',
      );
      final answer = messages.singleWhere(
        (m) => m['message']['text'] == 'Закрытый UI-ответ',
      );
      expect(answer['message']['reply'], mlsReplyReference(parent));
      expect((parent['reactions'] as List).single.emoji, '❤️');
      // Новый сеанс/MLS-клиент читает прежнее состояние, не создавая новый ratchet.
      final restored = await SpaceSession.connect(discovery, vault);
      try {
        final reopened = await client(restored, mlsStore);
        expect(
          (await reopened.refresh('private-ui', group)).messages.length,
          2,
        );
      } finally {
        await restored.close();
      }
    });
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(closeClients);
    await tester.pump();
  }, timeout: const Timeout(Duration(minutes: 2)));
}
