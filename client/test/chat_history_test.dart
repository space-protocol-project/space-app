import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/secure_vault.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

import 'channels_test.dart'
    show ChannelSession, ChannelVault, MemoryPositions, chat;

class HistoryKeys implements SecureKeyStorage {
  final values = <String, String>{};
  Completer<void>? pause;
  @override
  Future<String?> read({required String key}) async {
    await pause?.future;
    return values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async =>
      values[key] = value;
  @override
  Future<void> delete({required String key}) async => values.remove(key);
}

class RefusedSession extends ChannelSession {
  RefusedSession(this.failure);
  final GrpcError failure;
  @override
  Future<void> login() async => throw failure;
  @override
  Future<List<Content>> messages() async => throw failure;
}

class RecordVault extends ChannelVault {
  RecordVault(this.record);
  final DeviceRecord record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
}

ChatHistory snapshot(DateTime now) =>
    ChatHistory(serverId: 'server', principalId: 'principal', grantId: 'grant')
      ..channels = [chat('general'), chat('team')]
      ..merge([
        Content(
          id: '1',
          channelId: 'general',
          text: 'Секретная история',
          createdAtUnixMs: Int64(now.millisecondsSinceEpoch),
        ),
      ], now);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.utc(2026, 10, 13);
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'История зашифрована, восстанавливается и истекает через 14 дней',
    () async {
      final keys = HistoryKeys();
      final store = LocalChatHistory(storage: keys, now: () => now);
      await store.write('https://one.test', snapshot(now));
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getKeys().map(prefs.get).join(),
        isNot(contains('Секретная история')),
      );
      final restored = await LocalChatHistory(
        storage: keys,
        now: () => now,
      ).read('https://one.test');
      expect(
        restored!.messages('general', now).single.text,
        'Секретная история',
      );
      expect(restored.grantId, 'grant');
      expect(await store.read('https://two.test'), isNull);
      restored.prune(now.add(const Duration(days: 15)));
      expect(restored.entries, isEmpty);
    },
  );
  test(
    'Потеря права чтения удаляет только историю соответствующего канала',
    () {
      final history = snapshot(now)
        ..merge([Content(id: '2', channelId: 'team', text: 'Команда')], now);
      history.channels = [chat('general', read: false), chat('team')];
      history.merge([], now);
      expect(history.messages('general', now), isEmpty);
      expect(history.messages('team', now).single.text, 'Команда');
    },
  );
  test('Поздняя запись не возвращает историю после удаления', () async {
    final keys = HistoryKeys();
    final store = LocalChatHistory(storage: keys, now: () => now);
    await store.write('https://race.test', snapshot(now));
    keys.pause = Completer<void>();
    final writing = store.write('https://race.test', snapshot(now));
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final deleting = store.delete('https://race.test');
    keys.pause!.complete();
    await Future.wait([writing, deleting]);
    expect(await store.read('https://race.test'), isNull);
    expect(keys.values, isEmpty);
  });
  test(
    'История после перезапуска привязана к устройству и его grant',
    () async {
      const origin = 'https://identity.test';
      DeviceRecord record(String grant) => DeviceRecord(
        origin: origin,
        serverId: 'server',
        serverKey: 'key',
        rootSeed: List.filled(32, 1),
        deviceSeed: List.filled(32, 2),
        grantId: grant,
      );
      final savedRecord = record('grant');
      final history =
          ChatHistory(
              serverId: 'server',
              principalId: (await savedRecord.identity()).principalId,
              grantId: 'grant',
            )
            ..channels = [chat('general')]
            ..merge([
              Content(id: '1', channelId: 'general', text: 'После перезапуска'),
            ], now);
      final store = LocalChatHistory(storage: HistoryKeys(), now: () => now);
      await store.write(origin, history);
      final restored = ChatController(
        RecordVault(savedRecord),
        historyStore: store,
        now: () => now,
      );
      await restored.restoreHistory(origin);
      expect(restored.messages.single.text, 'После перезапуска');
      restored.dispose();
      final other = ChatController(
        RecordVault(record('other-grant')),
        historyStore: store,
        now: () => now,
      );
      await other.restoreHistory(origin);
      expect(other.messages, isEmpty);
      expect(await store.read(origin), isNull);
      other.dispose();
    },
  );
  test(
    'Отключение сохраняет каналы для чтения, удаление очищает память и диск',
    () async {
      final keys = HistoryKeys();
      final store = LocalChatHistory(storage: keys, now: () => now);
      final session = ChannelSession();
      final controller = ChatController(
        ChannelVault(),
        openSession: (_, _) async => session,
        positions: MemoryPositions(),
        historyStore: store,
        now: () => now,
      );
      controller.preview = Discovery(
        Uri.parse('http://127.0.0.1:8080'),
        'srv_test',
        List.filled(32, 1),
      );
      await controller.connect();
      await controller.selectChannel('team');
      await controller.disconnect();
      expect(controller.messages.single.text, 'История team');
      expect(controller.canWrite, false);
      await controller.selectChannel('general');
      expect(controller.messages.single.text, 'История general');
      await controller.clearOfflineData();
      expect(controller.messages, isEmpty);
      expect(controller.channels, isEmpty);
      expect(await store.read('http://127.0.0.1:8080'), isNull);
      controller.dispose();
    },
  );
  test(
    'Сбой сети сохраняет историю, подтверждённый отказ доступа удаляет её',
    () async {
      final store = LocalChatHistory(storage: HistoryKeys(), now: () => now);
      ChannelSession session = ChannelSession();
      final controller = ChatController(
        ChannelVault(),
        openSession: (_, _) async => session,
        positions: MemoryPositions(),
        historyStore: store,
        now: () => now,
      );
      final discovery = Discovery(
        Uri.parse('http://127.0.0.1:8080'),
        'srv_test',
        List.filled(32, 1),
      );
      controller.preview = discovery;
      await controller.connect();
      await controller.disconnect();
      session = RefusedSession(const GrpcError.unavailable());
      controller.preview = discovery;
      await controller.connect();
      expect(controller.hasOfflineHistory, true);
      expect(controller.accessRemoved, false);
      session = RefusedSession(const GrpcError.permissionDenied());
      await controller.connect();
      expect(controller.accessRemoved, true);
      expect(controller.messages, isEmpty);
      expect(await store.read(discovery.origin.toString()), isNull);
      controller.dispose();
    },
  );
}
