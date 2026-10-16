import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/queued_file_store.dart';

class EmptyQueuedFiles extends QueuedFileStore {
  @override
  Future<void> clear(OutboxScope scope) async {}
}

class MemoryChatOutbox implements ChatOutboxStore {
  final data = <String, List<PendingMessage>>{};
  @override
  Future<List<PendingMessage>> read(OutboxScope scope) async =>
      List.of(data[scope.binding] ?? []);
  @override
  Future<List<PendingMessage>> change(
    OutboxScope scope,
    List<PendingMessage> Function(List<PendingMessage>) update,
  ) async {
    final entries = update(List.of(data[scope.binding] ?? []));
    if (entries.length > maxPendingMessages) {
      throw StateError('Очередь заполнена');
    }
    data[scope.binding] = List.of(entries);
    return List.of(entries);
  }
}
