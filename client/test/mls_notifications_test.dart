import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/chat_notifications.dart';
import 'package:space_client/src/mls/client.dart';
import 'package:space_client/src/mls/local_store.dart';
import 'package:space_client/src/mls/notifications.dart';
import 'package:space_client/src/rpc_clients.dart' show Channel, MlsDevice;

import 'mls_view_test.dart' show entry;
import 'chat_notifications_test.dart' show state;

class NotificationMlsStore implements MlsLocalStore {
  final channels = <String, dynamic>{};
  Object? error;
  String principal = 'me';
  @override
  Map<String, dynamic> get scope => {'principal_id': principal};
  @override
  Future<Map<String, dynamic>> read() async {
    if (error != null) throw error!;
    return {'channels': channels};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class NotificationMlsClient implements MlsClient {
  @override
  final NotificationMlsStore local = NotificationMlsStore();
  Completer<void>? gate;
  int calls = 0;
  Object? failure;
  bool untrusted = false;
  List<Map<String, dynamic>> incoming = [];

  @override
  Future<MlsChannelData> refresh(String channel, List<int> group) async {
    calls++;
    if (failure != null) throw failure!;
    await gate?.future;
    final saved = local.channels[channel] as Map<String, dynamic>;
    saved['messages'] = [...saved['messages'] as List, ...incoming];
    if (incoming.isNotEmpty) saved['cursor'] = incoming.last['sequence'];
    incoming = [];
    return MlsChannelData(
      saved,
      untrusted: untrusted ? [MlsDevice(grantId: "unknown")] : [],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

MlsNotificationSource _source(
  NotificationMlsClient client, {
  String id = 'private',
  bool Function()? valid,
}) {
  client.local.channels.putIfAbsent(
    id,
    () => <String, dynamic>{
      'joined': true,
      'cursor': 3,
      'group_id': base64Encode([1]),
      'messages': [entry(3)],
    },
  );
  return MlsNotificationSource(
    origin: 'https://saved.example',
    principal: 'me',
    channel: Channel(id: id, mlsGroupId: [1]),
    open: () async => client,
    valid: valid ?? () => true,
  );
}

void main() {
  test('MLS: история, повторы и собственная личность не уведомляют', () async {
    final client = NotificationMlsClient();
    final input = _source(client);
    final watcher = MlsNotificationWatcher();
    final notices = <ChatNotice>[];
    await watcher.poll([input], notices.add);
    expect(notices, isEmpty);
    client.incoming = [entry(4)];
    await watcher.poll([input], notices.add);
    expect(notices.single.message!.text, 'Сообщение 4');
    await watcher.poll([input], notices.add);
    client.incoming = [entry(5)..['author_id'] = 'me'];
    await watcher.poll([input], notices.add);
    expect(notices, hasLength(1));
    expect(
      (await watcher.message(input, notices.single.message!.id))!.text,
      'Сообщение 4',
    );
  });
  test(
    'MLS: ошибка проверки и неизвестный отправитель не уведомляют',
    () async {
      final client = NotificationMlsClient();
      final input = _source(client);
      final watcher = MlsNotificationWatcher();
      final notices = <ChatNotice>[];
      await watcher.poll([input], notices.add);
      client.incoming = [entry(4)];
      client.failure = StateError('Подпись');
      await watcher.poll([input], notices.add);
      expect(notices, isEmpty);
      client.failure = null;
      client.untrusted = true;
      await watcher.poll([input], notices.add);
      expect(notices, isEmpty);
      client.untrusted = false;
      await watcher.poll([input], notices.add);
      expect(notices, hasLength(1));
    },
  );
  test('MLS: реакция не создаёт уведомления', () async {
    final client = NotificationMlsClient();
    final input = _source(client);
    final watcher = MlsNotificationWatcher();
    final notices = <ChatNotice>[];
    await watcher.poll([input], notices.add);
    final reaction = entry(4);
    (reaction['message'] as Map)['reaction'] = {
      'message_id': List.filled(16, 3),
      'grant_id': 'other-grant',
      'emoji': '❤️',
      'active': true,
    };
    client.incoming = [reaction];
    await watcher.poll([input], notices.add);
    expect(notices, isEmpty);
  });
  test('MLS: архив и служебные события не создают уведомления', () async {
    final client = NotificationMlsClient();
    final input = _source(client);
    final watcher = MlsNotificationWatcher();
    final notices = <ChatNotice>[];
    await watcher.poll([input], notices.add);
    client.incoming = [entry(4)..['archived'] = true];
    await watcher.poll([input], notices.add);
    client.local.channels['private']['cursor'] = 6;
    await watcher.poll([input], notices.add);
    expect(notices, isEmpty);
  });
  for (final reason in ['revoked', 'group', 'rollback', 'unjoined']) {
    test(
      'MLS: $reason блокирует получение и повторное чтение текста',
      () async {
        final client = NotificationMlsClient();
        final input = _source(client);
        final watcher = MlsNotificationWatcher();
        final notices = <ChatNotice>[];
        await watcher.poll([input], notices.add);
        client.incoming = [entry(4)];
        final channel = client.local.channels['private'];
        switch (reason) {
          case 'revoked':
            channel['revocation_pending'] = true;
          case 'group':
            channel['group_id'] = base64Encode([2]);
          case 'rollback':
            client.local.error = MlsRecoveryRequired();
          case 'unjoined':
            channel['joined'] = false;
        }
        await watcher.poll([input], notices.add);
        expect(notices, isEmpty);
        if (reason == 'rollback') {
          await expectLater(
            watcher.message(input, 'key'),
            throwsA(isA<MlsRecoveryRequired>()),
          );
        } else {
          expect(await watcher.message(input, 'key'), isNull);
        }
      },
    );
  }
  for (final cancel in ['reset', 'rights', 'dispose']) {
    test('MLS: $cancel во время запроса отменяет уведомление', () async {
      final client = NotificationMlsClient();
      var allowed = true;
      final input = _source(client, valid: () => allowed);
      final watcher = MlsNotificationWatcher();
      final notices = <ChatNotice>[];
      await watcher.poll([input], notices.add);
      client.incoming = [entry(4)];
      client.gate = Completer<void>();
      final pending = watcher.poll([input], notices.add);
      await Future<void>.delayed(Duration.zero);
      if (cancel == 'reset') watcher.reset();
      if (cancel == 'rights') allowed = false;
      if (cancel == 'dispose') watcher.dispose();
      client.gate!.complete();
      await pending;
      expect(notices, isEmpty);
    });
  }
  test('MLS: бюджет четыре канала, без перекрывающихся опросов', () async {
    final client = NotificationMlsClient();
    final inputs = List.generate(7, (i) => _source(client, id: 'c$i'));
    final watcher = MlsNotificationWatcher();
    client.gate = Completer<void>();
    final pending = watcher.poll(inputs, (_) {});
    await Future<void>.delayed(Duration.zero);
    await watcher.poll(inputs, (_) {});
    expect(client.calls, 1);
    client.gate!.complete();
    await pending;
    expect(client.calls, 4);
    await watcher.poll(inputs, (_) {});
    expect(client.calls, 8);
  });
  test('MLS: ссылка уведомления привязана к группе, личности и правам', () {
    const payload = '["https://saved.example","me","general",7,"key","AQ=="]';
    final target = ChatNotificationTarget.decode(payload)!;
    expect(target.accessible(state(7, encrypted: true)), isTrue);
    expect(target.accessible(state(7)), isFalse);
    expect(target.accessible(state(7, encrypted: true, read: false)), isFalse);
    expect(
      target.accessible(state(7, encrypted: true, principal: 'other')),
      isFalse,
    );
    expect(ChatNotificationTarget.decode('["o","p","c",1,"",""]'), isNull);
  });
}
