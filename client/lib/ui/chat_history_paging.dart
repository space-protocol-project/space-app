part of 'chat_view.dart';

class _HistoryViewport {
  _HistoryViewport(
    this.scope,
    this.generation,
    this.offset,
    this.extent,
    this.anchor,
  );
  final String scope;
  final int generation;
  double offset, extent;
  (String, double)? anchor;
}

extension _ChatHistoryPaging on _ChatViewState {
  bool get historyHeader =>
      widget.controller.state.hasOlderHistory ||
      widget.controller.state.historyLoading ||
      widget.controller.state.historyError.isNotEmpty;

  Widget historyMessageList(BuildContext context, int boundary) {
    final messages = widget.controller.state.messages;
    final offset = historyHeader ? 1 : 0;
    return NotificationListener<ScrollNotification>(
      onNotification: historyUserScroll,
      child: ListView.builder(
        key: viewport,
        controller: scroll,
        padding: EdgeInsets.fromLTRB(
          24,
          24 + widget.topInset,
          24,
          composerHeight + 36,
        ),
        itemCount: messages.length + offset,
        findChildIndexCallback: (key) =>
            historyChildIndex(key, messages, offset),
        itemBuilder: (context, index) {
          if (offset == 1 && index == 0) return historyLoadButton(context);
          final position = index - offset;
          return KeyedSubtree(
            key: ValueKey(('history-message', messages[position].id)),
            child: _messageRow(context, position, boundary),
          );
        },
      ),
    );
  }

  int? historyChildIndex(Key key, List<Content> messages, int offset) {
    if (key == const ValueKey('history-load')) return offset == 1 ? 0 : null;
    if (key is! ValueKey<(String, String)>) return null;
    final index = messages.indexWhere((message) => message.id == key.value.$2);
    return index < 0 ? null : index + offset;
  }

  Widget historyLoadButton(BuildContext context) {
    final state = widget.controller.state;
    return Padding(
      key: const ValueKey('history-load'),
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          TextButton.icon(
            onPressed: state.historyLoading || loadingOlderViewport
                ? null
                : loadOlderPreservingViewport,
            icon: state.historyLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.history),
            label: Text(context.strings.loadOlderMessages),
          ),
          if (state.historyError.isNotEmpty)
            Text(context.strings.historyPageFailed),
        ],
      ),
    );
  }

  bool historyUserScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    final request = historyViewport;
    if (request != null &&
        widget.controller.historyLoading &&
        scroll.hasClients) {
      request.anchor = historyAnchor(widget.controller.state.messages);
      request.offset = scroll.offset;
      request.extent = scroll.position.maxScrollExtent;
    }
    if (notification is UserScrollNotification &&
        notification.direction == ScrollDirection.forward &&
        notification.metrics.extentBefore < 160) {
      unawaited(loadOlderPreservingViewport());
    }
    return false;
  }

  (String, double)? historyAnchor(List<Content> messages) {
    final visible = _visibleMessageIndices(
      messages.map((message) => message.id).toList(),
    );
    if (visible.isEmpty) return null;
    final id = messages[visible.first].id;
    final y = historyRowY(id);
    return y == null ? null : (id, y);
  }

  double? historyRowY(String id) {
    final box = messageKeys[id]?.currentContext?.findRenderObject();
    return box is RenderBox && box.hasSize
        ? box.localToGlobal(Offset.zero).dy
        : null;
  }

  Future<void> loadOlderPreservingViewport() async {
    if (loadingOlderViewport ||
        jumping ||
        !scroll.hasClients ||
        !widget.controller.hasOlderHistory) {
      return;
    }
    final request = _HistoryViewport(
      scope,
      widget.controller.historyGeneration,
      scroll.offset,
      scroll.position.maxScrollExtent,
      historyAnchor(widget.controller.state.messages),
    );
    beginHistoryViewport(request);
    try {
      await widget.controller.loadOlderHistory();
      await WidgetsBinding.instance.endOfFrame;
      await positionAfterHistoryLoad(request);
    } finally {
      endHistoryViewport(request);
    }
  }

  Future<void> positionAfterHistoryLoad(_HistoryViewport request) async {
    if (!historyViewportCurrent(request)) return;
    scroll.jumpTo(
      (request.offset + scroll.position.maxScrollExtent - request.extent).clamp(
        0,
        scroll.position.maxScrollExtent,
      ),
    );
    final anchor = request.anchor;
    if (anchor != null) await restoreHistoryAnchor(anchor, request);
  }

  bool historyViewportCurrent(_HistoryViewport request) =>
      mounted &&
      scope == request.scope &&
      scroll.hasClients &&
      widget.controller.historyGeneration == request.generation &&
      identical(historyViewport, request);
  Future<void> restoreHistoryAnchor(
    (String, double) anchor,
    _HistoryViewport request,
  ) async {
    var low = 0.0, high = scroll.position.maxScrollExtent;
    for (
      var attempt = 0;
      attempt < 24 && historyViewportCurrent(request);
      attempt++
    ) {
      await WidgetsBinding.instance.endOfFrame;
      final y = historyRowY(anchor.$1);
      if (y != null) {
        final delta = y - anchor.$2;
        if (delta.abs() < 1) return;
        scroll.jumpTo(
          (scroll.offset + delta).clamp(0, scroll.position.maxScrollExtent),
        );
        continue;
      }
      final messages = widget.controller.state.messages;
      final index = messages.indexWhere((message) => message.id == anchor.$1);
      final visible = _visibleMessageIndices(
        messages.map((message) => message.id).toList(),
      );
      if (index < 0 || visible.isEmpty) return;
      if (index < visible.first) {
        high = scroll.offset;
      } else {
        low = scroll.offset;
      }
      scroll.jumpTo((low + high) / 2);
    }
  }
}
