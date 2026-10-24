part of 'queued_file_store.dart';

extension QueuedFileTransfer on QueuedFileStore {
  /// Вызывается только после отдельного подтверждения доверия текущему grant.
  /// Сначала сохраняем назначение; неоднозначная запись не стирает источник.
  Future<List<PendingMessage>> transfer(
    OutboxScope source,
    OutboxScope target,
    ChatOutboxStore outbox, {
    required bool Function() active,
    String? expectedSource,
  }) {
    _checkTransferScopes(source, target);
    final ordered = [source, target]..sort((a, b) => a.id.compareTo(b.id));
    return _locked(
      ordered.first,
      (first) => _locked(
        ordered.last,
        (last) => _transfer(
          source,
          target,
          outbox,
          active,
          source.id == ordered.first.id ? first : last,
          target.id == ordered.first.id ? first : last,
          expectedSource,
        ),
      ),
    );
  }

  void _checkTransferScopes(OutboxScope source, OutboxScope target) {
    if (source.origin != target.origin ||
        source.serverId != target.serverId ||
        source.principalId != target.principalId ||
        source.grantId.isEmpty ||
        target.grantId.isEmpty ||
        source.grantId == target.grantId) {
      throw const FormatException(
        'Перенос между разными пространствами запрещён',
      );
    }
  }

  void _checkTransferActive(bool Function() active) {
    if (!active()) throw StateError('Подтверждённое устройство изменилось');
  }

  // Проверяем исходный запрос, а не временный статус или прогресс загрузки.
  String _request(PendingMessage entry) => jsonEncode({
    'key': entry.key,
    'channel': entry.channelId,
    'text': entry.text,
    'created': entry.createdAt,
    'attachments': entry.attachments,
    'files': entry.localFiles.map((file) => file.toJson()).toList(),
    'mutation': entry.mutation?.toJson(),
    'replyTo': entry.replyTo,
  });

  List<PendingMessage> _mergeTransfer(
    List<PendingMessage> saved,
    List<PendingMessage> incoming,
  ) {
    final merged = {for (final entry in saved) entry.key: entry};
    for (final entry in incoming) {
      final previous = merged[entry.key];
      if (previous != null && _request(previous) != _request(entry)) {
        throw const FormatException('Ключ запроса занят другим сообщением');
      }
      if (previous != null &&
          previous.uploadedFiles.isNotEmpty &&
          entry.uploadedFiles.isNotEmpty &&
          jsonEncode(previous.uploadedFiles) !=
              jsonEncode(entry.uploadedFiles)) {
        throw const FormatException('Противоречивые ID вложений');
      }
      merged.putIfAbsent(entry.key, () => entry.withBlocked(false));
    }
    if (merged.length > maxPendingMessages) throw const OutboxFull();
    return merged.values.map((entry) {
      final after = entry.mutation?.after ?? '';
      return after.isNotEmpty && !merged.containsKey(after)
          ? entry.withBlocked(true)
          : entry;
    }).toList();
  }

  Future<List<PendingMessage>> _transfer(
    OutboxScope source,
    OutboxScope target,
    ChatOutboxStore outbox,
    bool Function() active,
    Directory from,
    Directory to,
    String? expectedSource,
  ) async {
    _checkTransferActive(active);
    final incoming = await outbox.read(source);
    if (expectedSource != null && outboxSnapshot(incoming) != expectedSource) {
      throw const FormatException('Очередь изменилась после просмотра');
    }
    final saved = await outbox.read(target);
    _mergeTransfer(saved, incoming);
    await _prune(
      to,
      saved.expand((entry) => entry.localFiles).map((file) => file.id).toSet(),
    );
    await _copyTransferFiles(source, target, incoming, from, to);
    _checkTransferActive(active);
    final result = await outbox.change(target, (latest) {
      _checkTransferActive(active);
      return _mergeTransfer(latest, incoming);
    });
    _checkTransferActive(active);
    final originals = {
      for (final entry in incoming) entry.key: jsonEncode(entry.toJson()),
    };
    // Проверяем повторно: другой процесс мог дополнить исходную очередь.
    final remaining = await outbox.change(source, (latest) {
      _checkTransferActive(active);
      return latest
          .where((entry) => originals[entry.key] != jsonEncode(entry.toJson()))
          .toList();
    });
    try {
      await _prune(
        from,
        remaining
            .expand((entry) => entry.localFiles)
            .map((file) => file.id)
            .toSet(),
      );
    } catch (_) {
      // Перенос уже зафиксирован. Ошибка очистки не отменяет назначение.
    }
    return result;
  }

  Future<void> _copyTransferFiles(
    OutboxScope source,
    OutboxScope target,
    List<PendingMessage> entries,
    Directory from,
    Directory to,
  ) async {
    for (final entry in entries) {
      if (entry.localFiles.isEmpty) continue;
      // Обе файловые блокировки уже удерживаются. Повторное их получение
      // через read/stage привело бы к взаимной блокировке.
      final key = await _key(source, from);
      final files = <SpaceFile>[];
      for (final file in entry.localFiles) {
        final bytes = await _read(source, from, key, file);
        files.add(SpaceFile.fromData(bytes, name: file.name, path: file.name));
      }
      final copied = await _stage(target, to, entry.key, files);
      if (jsonEncode(copied.map((file) => file.toJson()).toList()) !=
          jsonEncode(entry.localFiles.map((file) => file.toJson()).toList())) {
        throw const FormatException('Копия вложений не совпадает с источником');
      }
    }
  }
}
