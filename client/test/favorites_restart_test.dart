import 'support/chat_outbox.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/core.dart';

import 'channels_test.dart' show ChannelSession, MemoryPositions;
import 'chat_history_test.dart' show HistoryKeys, RecordVault;

class SavedDeviceSession extends ChannelSession implements DeviceManagement {
  SavedDeviceSession(this.record, this.identity);
  final DeviceRecord record;
  final String identity;
  @override
  String get principalId => identity;
  @override
  String get currentGrantId => record.grantId;
  @override
  bool get hasRootAuthority => true;
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('${invocation.memberName}');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Избранное переживает перезапуски сервера и приложения без отдельной загрузки истории', () async {
    SharedPreferences.setMockInitialValues({});
    const origin = 'http://127.0.0.1:8080';
    final record = DeviceRecord(
      origin: origin,
      serverId: 'srv_test',
      serverKey: 'key',
      rootSeed: List.filled(32, 1),
      deviceSeed: List.filled(32, 2),
      grantId: 'grant',
    );
    final identity = (await record.identity()).principalId;
    final keys = HistoryKeys();
    final positions = MemoryPositions();
    ChatController create() => ChatController(
      RecordVault(record),
      historyStore: LocalChatHistory(storage: keys),
      outboxStore: MemoryChatOutbox(),
      positions: positions,
      openSession: (_, _) async => SavedDeviceSession(record, identity),
    );
    final discovery = Discovery(
      Uri.parse(origin),
      'srv_test',
      List.filled(32, 1),
    );
    final first = create()..preview = discovery;
    await first.connect();
    await first.toggleFavorite(first.state.messages.single);
    expect(first.state.favorites, {'general/message-1'});
    // Остановка сервера закрывает соединение; следующий запуск открывает новую сессию.
    await first.disconnect();
    first.preview = discovery;
    await first.connect();
    expect(first.state.favorites, {'general/message-1'});
    await first.close();
    // Новый экземпляр хранилища и контроллера, как при перезапуске приложения.
    final second = create()..preview = discovery;
    addTearDown(second.close);
    await second.connect();
    expect(second.state.favorites, {'general/message-1'});
    expect(second.isFavorite(second.state.messages.single), isTrue);
    await second.disconnect();
    expect(second.isFavorite(second.state.messages.single), isTrue);
  });
}
