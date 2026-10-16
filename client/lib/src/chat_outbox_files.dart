part of 'chat_controller.dart';

extension _ChatOutboxFiles on ChatController {
  Future<List<PendingMessage>> _saveMessageFiles(
    OutboxScope scope,
    int epoch,
    PendingMessage entry,
    List<XFile> files,
  ) async {
    if (files.isNotEmpty) {
      return fileStore.enqueue(
        scope,
        entry,
        files,
        outboxStore,
        active: () => _outboxCurrent(scope, epoch),
      );
    }
    entry.validate();
    return outboxStore.change(scope, (saved) {
      if (!_outboxCurrent(scope, epoch)) return saved;
      if (saved.any((message) => message.key == entry.key)) return saved;
      return _appendMutation(saved, entry);
    });
  }

  void _checkFileDelivery(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    String key,
  ) {
    if (!_checkOutboxDevice(scope, epoch) ||
        !identical(session, _session) ||
        !_pendingMessages.any((entry) => entry.key == key)) {
      throw const GrpcError.cancelled('Отправка больше не активна');
    }
  }

  Future<PendingMessage> _prepareMessageFiles(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    PendingMessage entry,
  ) async {
    if (entry.localFiles.isEmpty) return entry;
    final current = (await outboxStore.read(scope))
        .where((m) => m.key == entry.key)
        .firstOrNull;
    _checkFileDelivery(scope, epoch, session, entry.key);
    if (current == null) {
      _pendingMessages = _pendingMessages
          .where((message) => message.key != entry.key)
          .toList();
      _update();
      throw const GrpcError.cancelled('Сообщение убрано из очереди');
    }
    if (current.uploadedFiles.isNotEmpty) return current;
    if (session is! AttachmentSession ||
        session is AttachmentPolicy &&
            !(session as AttachmentPolicy).attachmentsEnabled) {
      throw const GrpcError.permissionDenied('Вложения недоступны');
    }
    final ids = <String>[];
    for (final file in current.localFiles) {
      ids.add(
        await _uploadQueuedFile(scope, epoch, session, current.key, file),
      );
    }
    _checkFileDelivery(scope, epoch, session, entry.key);
    return _savePreparedFiles(scope, epoch, current.withUploaded(ids));
  }

  Future<PendingMessage> _savePreparedFiles(
    OutboxScope scope,
    int epoch,
    PendingMessage updated,
  ) async {
    final entries = await outboxStore.change(scope, (saved) {
      if (!_outboxCurrent(scope, epoch)) return saved;
      return saved
          .map((entry) => entry.key == updated.key ? updated : entry)
          .toList();
    });
    final current = entries
        .where((entry) => entry.key == updated.key)
        .firstOrNull;
    if (!_outboxCurrent(scope, epoch) || current == null) {
      throw const GrpcError.cancelled('Сообщение убрано из очереди');
    }
    _pendingMessages = entries;
    _update();
    return current;
  }

  Future<String> _uploadQueuedFile(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    String message,
    QueuedFile file,
  ) async {
    final bytes = await fileStore.read(scope, file);
    _checkFileDelivery(scope, epoch, session, message);
    final queue = AttachmentQueue(
      files: [
        PendingAttachment(
          XFile.fromData(bytes, name: file.name, path: file.name),
          file.size,
          requestKey: file.key,
        ),
      ],
      suspended: () =>
          !_outboxCurrent(scope, epoch) ||
          !_outboxGrantMatches(scope) ||
          !_pendingMessages.any((entry) => entry.key == message),
    );
    _activeFileUploads[message] = queue;
    try {
      final entry = _pendingMessages.singleWhere(
        (entry) => entry.key == message,
      );
      final ids = await queue.upload(
        session as AttachmentSession,
        entry.channelId,
      );
      if (ids == null) {
        throw queue.state.problem ?? StateError('Загрузка не завершена');
      }
      _checkFileDelivery(scope, epoch, session, message);
      return ids.single;
    } finally {
      if (identical(_activeFileUploads[message], queue)) {
        _activeFileUploads.remove(message);
      }
      await queue.close();
    }
  }

  Future<(PendingMessage, Content)> _sendFilesAndMessage(
    OutboxScope scope,
    int epoch,
    LiveSession session,
    PendingMessage entry,
  ) async {
    final prepared = await _prepareMessageFiles(scope, epoch, session, entry);
    try {
      return (prepared, await _sendPending(session, prepared));
    } on GrpcError catch (problem) {
      if (problem.code != StatusCode.notFound ||
          prepared.localFiles.isEmpty ||
          prepared.attachments.isNotEmpty) {
        rethrow;
      }
      // Неиспользованные файлы могли истечь на сервере. CreateContent сначала
      // проверяет прежний ключ запроса, поэтому принятый запрос сюда не попадает.
      await _savePreparedFiles(scope, epoch, prepared.withUploaded([]));
      throw const GrpcError.unavailable('Вложения будут загружены заново');
    }
  }

  Future<void> _removeQueuedFiles(
    OutboxScope scope,
    Iterable<QueuedFile> files,
  ) async {
    if (files.isEmpty) return;
    try {
      await fileStore.remove(scope, files);
    } catch (_) {
      // Подтверждённое сообщение уже удалено из очереди. Копии можно убрать
      // явной очисткой локальных данных; ошибка очистки не повторяет отправку.
    }
  }
}
