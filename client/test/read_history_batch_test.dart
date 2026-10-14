import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/core.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'unread_test.dart' show SequencedSession;

class CountingHistory extends MemoryHistory {
  int writes = 0;
  int savedSequence = 0;

  @override
  Future<void> write(String origin, ChatHistory history) async {
    writes++;
    savedSequence = history.readSequences['general'] ?? 0;
    await super.write(origin, history);
  }
}

void main() {
  test(
    'Прокрутка объединяет запись отметок, закрытие сохраняет последнюю',
    () async {
      final history = CountingHistory();
      final session = SequencedSession();
      final controller =
          ChatController(
              ChannelVault(),
              positions: MemoryPositions(),
              historyStore: history,
              openSession: (_, _) async => session,
            )
            ..preview = Discovery(
              Uri.parse('http://127.0.0.1:8080'),
              'srv_test',
              List.filled(32, 1),
            );
      await controller.connect();
      await controller.flushHistory();
      history.writes = 0;
      await controller.markRead('m-1');
      await controller.markRead('m-2');
      await controller.markRead('m-3');
      expect(controller.state.readThrough, 'm-3');
      expect(history.writes, 0);
      await controller.close();
      expect(history.writes, 1);
      expect(history.savedSequence, 3);
    },
  );
}
