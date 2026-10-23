part of 'chat_controller.dart';

extension _ChatHistoryPages on ChatController {
  void _resetHistoryPaging() {
    _historyEpoch++;
    _historyChanges.clear();
    _historyChangesOverflow = false;
    _historyFloor = 0;
    _historyNextBefore = 0;
    _pagedHistory = false;
    historyLoading = false;
    historyError = '';
  }

  Future<List<Content>> _initialHistory(LiveSession session) async {
    cursor = _cursors[channelId] ?? '';
    if (session is! HistoryPageSession || encryptedChannel || !canRead) {
      return session.messages();
    }
    final id = channelId, epoch = _historyEpoch;
    final page = await (session as HistoryPageSession).historyPage(id);
    if (_disposed ||
        epoch != _historyEpoch ||
        !identical(session, _session) ||
        channelId != id) {
      return [];
    }
    _pagedHistory = true;
    _historyNextBefore = page.nextBefore;
    _historyFloor = page.messages.firstOrNull?.sequence.toInt() ?? 0;
    cursor = _historyCursor(id, page.eventCursor);
    _cursors[id] = cursor;
    _queuePositions();
    return page.messages;
  }

  String _historyCursor(String id, String eventCursor) {
    final cached =
        _history?.entries.values.any(
          (entry) => entry.content.channelId == id,
        ) ??
        false;
    if (cached) {
      final lastCached = _history!.entries.values
          .where((entry) => entry.content.channelId == id)
          .map((entry) => entry.content.sequence.toInt())
          .fold<int>(
            0,
            (latest, sequence) => sequence > latest ? sequence : latest,
          );
      if (lastCached + 1 < _historyFloor) _historyFloor = lastCached + 1;
    }
    return cached ? _history!.eventCursors[id] ?? '' : eventCursor;
  }

  Future<void> _loadOlderHistory() async {
    final session = _session;
    if (session == null ||
        !hasOlderHistory ||
        historyLoading ||
        session is! HistoryPageSession) {
      return;
    }
    final epoch = _historyEpoch, id = channelId, principal = principalId;
    _historyChanges.clear();
    _historyChangesOverflow = false;
    historyLoading = true;
    historyError = '';
    _update();
    try {
      final page = await (session as HistoryPageSession).historyPage(
        id,
        before: _historyNextBefore,
      );
      if (!_historyRequestCurrent(session, epoch, id, principal)) return;
      final reconciled = _reconciledHistoryPage(page);
      for (final message in reconciled) {
        _mergeMessage(message);
      }
      _historyNextBefore = page.nextBefore;
      if (page.messages.isNotEmpty) {
        _historyFloor = page.messages.first.sequence.toInt();
      }
    } catch (problem) {
      if (!_historyRequestCurrent(session, epoch, id, principal)) return;
      if (!await _channelDenied(problem)) historyError = _explain(problem);
    } finally {
      if (epoch == _historyEpoch && !_disposed) {
        _historyChanges.clear();
        historyLoading = false;
        _update();
      }
    }
  }

  bool _historyRequestCurrent(
    LiveSession session,
    int epoch,
    String id,
    String principal,
  ) =>
      !_disposed &&
      epoch == _historyEpoch &&
      identical(session, _session) &&
      connected &&
      canRead &&
      !accessRemoved &&
      channelId == id &&
      principalId == principal &&
      !encryptedChannel;

  List<Content> _reconciledHistoryPage(HistoryPage page) {
    if (_historyChangesOverflow) {
      throw StateError('История изменилась, повторите загрузку');
    }
    return page.messages.map((message) {
      final changed = _historyChanges[message.id];
      if (changed == null || changed.revision < message.revision) {
        return message;
      }
      if (changed.sequence != message.sequence) {
        throw StateError('Изменён номер сообщения');
      }
      return changed;
    }).toList();
  }

  void _rememberHistoryChange(Content message) {
    final previous = _historyChanges[message.id];
    if (previous != null && previous.revision > message.revision) return;
    if (previous == null && _historyChanges.length >= 200) {
      _historyChangesOverflow = true;
      return;
    }
    _historyChanges[message.id] = message;
  }

  void _mergeHistoryFrame(Content message) {
    if (!_pagedHistory ||
        _historyFloor == 0 ||
        message.sequence.toInt() >= _historyFloor ||
        _messages.containsKey(message.id)) {
      _mergeMessage(message);
      return;
    }
    if (historyLoading) _rememberHistoryChange(message);
    final cached = _history;
    if (cached?.entries.containsKey('${message.channelId}/${message.id}') ==
        true) {
      cached!.merge([message], now());
    }
  }
}
