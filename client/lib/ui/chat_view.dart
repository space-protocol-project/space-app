import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import 'package:flutter/services.dart';

import '../l10n/strings.dart';

import 'package:flutter/material.dart';

import '../src/chat_controller.dart';
import 'message_bubble.dart';
import 'favorite_messages.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.controller,
    required this.openConnection,
    this.active = true,
    this.showHeader = true,
    this.sendWithShift = false,
  });
  final ChatController controller;
  final VoidCallback openConnection;
  final bool active, showHeader, sendWithShift;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  final draft = TextEditingController();
  final draftFocus = FocusNode();
  final scroll = ScrollController();
  final Map<String, String> drafts = {};
  final Map<String, double> offsets = {};
  bool restoreScroll = true;
  String scope = '';
  final viewport = GlobalKey();
  final messageKeys = <String, GlobalKey>{};
  String entryReadThrough = '';
  bool foreground = true, jumping = false;
  @override
  void initState() {
    super.initState();
    scope = widget.controller.draftScope;
    entryReadThrough = widget.controller.readThrough;
    foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    scroll.addListener(markRead);
  }

  @override
  void didUpdateWidget(covariant ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.controller.draftScope;
    if (next != scope) {
      drafts[scope] = draft.text;
      scope = next;
      entryReadThrough = widget.controller.readThrough;
      messageKeys.clear();
      draft.text = drafts[scope] ?? '';
      restoreScroll = true;
    }
  }

  void markRead() {
    final controller = widget.controller;
    if (scroll.hasClients) offsets[scope] = scroll.offset;
    if (jumping ||
        ModalRoute.of(context)?.isCurrent == false ||
        !widget.active ||
        !foreground ||
        !controller.canRead ||
        !scroll.hasClients ||
        controller.messages.isEmpty) {
      return;
    }
    if (scroll.position.extentAfter < 24) {
      controller.markRead(controller.messages.last.id);
      return;
    }
    final box = viewport.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy,
        bottom = box.localToGlobal(Offset(0, box.size.height)).dy;
    String? lastVisible;
    for (final message in controller.messages) {
      final row = messageKeys[message.id]?.currentContext?.findRenderObject();
      if (row is! RenderBox || !row.hasSize) continue;
      final start = row.localToGlobal(Offset.zero).dy;
      final end = row.localToGlobal(Offset(0, row.size.height)).dy;
      if (start >= top && end <= bottom) lastVisible = message.id;
    }
    if (lastVisible != null) controller.markRead(lastVisible);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      setState(() => foreground = state == AppLifecycleState.resumed);
    }
  }

  Future<void> jumpToNew() async {
    if (jumping || !scroll.hasClients) return;
    final controller = widget.controller;
    final list = controller.messages;
    final index = list.indexWhere((m) => m.id == controller.readThrough) + 1;
    if (index >= list.length) return;
    await jumpToMessage(list[index].id);
  }

  Future<void> jumpToMessage(String id) async {
    if (jumping || !scroll.hasClients) return;
    final list = widget.controller.messages;
    final startingScope = scope;
    final index = list.indexWhere((m) => m.id == id);
    if (index < 0) return;
    jumping = true;
    var low = 0.0, high = scroll.position.maxScrollExtent;
    try {
      for (
        var attempt = 0;
        attempt < 24 && mounted && scope == startingScope;
        attempt++
      ) {
        final target = messageKeys[id]?.currentContext;
        if (target != null && target.mounted) {
          await Scrollable.ensureVisible(
            target,
            duration: const Duration(milliseconds: 260),
            alignment: .1,
          );
          break;
        }
        final visible = _visibleMessageIndices([
          for (final message in list) message.id,
        ]);
        if (visible.isEmpty) break;
        if (index < visible.first) {
          high = scroll.offset;
        } else {
          low = scroll.offset;
        }
        final next = (low + high) / 2;
        if ((next - scroll.offset).abs() < 1) break;
        scroll.jumpTo(next);
        await WidgetsBinding.instance.endOfFrame;
      }
    } finally {
      _finishMessageJump(startingScope);
    }
  }

  List<int> _visibleMessageIndices(List<String> messageIds) {
    final viewportBox = viewport.currentContext?.findRenderObject();
    if (viewportBox is! RenderBox || !scroll.hasClients) return [];
    final top = viewportBox.localToGlobal(Offset.zero).dy;
    final bottom = top + viewportBox.size.height;
    final visible = <int>[];
    for (var index = 0; index < messageIds.length; index++) {
      final box = messageKeys[messageIds[index]]?.currentContext
          ?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;
      final y = box.localToGlobal(Offset.zero).dy;
      if (y < bottom && y + box.size.height > top) visible.add(index);
    }
    return visible;
  }

  void _finishMessageJump(String startingScope) {
    if (!mounted) {
      jumping = false;
      return;
    }
    setState(() => jumping = false);
    if (scope == startingScope) markRead();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    draft.dispose();
    draftFocus.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final text = draft.text;
    final restoreFocus = draftFocus.hasFocus;
    final target = widget.controller, startingScope = scope;
    final sent = await target.send(text);
    if (!mounted) return;
    if (sent) _clearSentDraft(text, startingScope, target);
    if (restoreFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            widget.active &&
            foreground &&
            scope == startingScope &&
            identical(widget.controller, target) &&
            target.connected &&
            target.canWrite &&
            !target.busy &&
            ModalRoute.of(context)?.isCurrent != false) {
          draftFocus.requestFocus();
        }
      });
    }
  }

  void _clearSentDraft(
    String text,
    String startingScope,
    ChatController target,
  ) {
    if (scope == startingScope && identical(widget.controller, target)) {
      if (draft.text == text) draft.clear();
    } else if (drafts[startingScope] == text) {
      drafts[startingScope] = '';
    }
  }

  void _insertDraftNewline() {
    final value = draft.value;
    final selection = value.selection;
    final start = selection.isValid ? selection.start : value.text.length;
    final end = selection.isValid ? selection.end : value.text.length;
    final updated = value.text.replaceRange(start, end, '\n');
    if (updated.characters.length <= 1024) {
      draft.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(offset: start + 1),
      );
    }
  }

  KeyEventResult _draftKeyEvent(FocusNode node, KeyEvent event) {
    final keyboard = HardwareKeyboard.instance;
    if (event is KeyUpEvent ||
        ![
          LogicalKeyboardKey.enter,
          LogicalKeyboardKey.numpadEnter,
        ].contains(event.logicalKey) ||
        keyboard.isControlPressed ||
        keyboard.isAltPressed ||
        keyboard.isMetaPressed ||
        (draft.value.composing.isValid && !draft.value.composing.isCollapsed)) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent) {
      if (keyboard.isShiftPressed == widget.sendWithShift) {
        unawaited(send());
      } else {
        _insertDraftNewline();
      }
    }
    return KeyEventResult.handled;
  }

  Widget _messageRow(BuildContext context, int index) {
    final controller = widget.controller;
    final view = widget.controller.state;
    final colors = Theme.of(context).colorScheme;
    final message = view.messages[index];
    final mine = message.authorId == view.principalId;
    final author = mine
        ? context.strings.you
        : message.authorId.length > 16
        ? '${message.authorId.substring(0, 16)}…'
        : message.authorId;
    final boundary =
        view.messages.indexWhere((m) => m.id == entryReadThrough) + 1;
    final grouped =
        index > 0 &&
        view.messages[index - 1].authorId == message.authorId &&
        index != boundary;
    return Padding(
      key: messageKeys.putIfAbsent(message.id, GlobalKey.new),
      padding: EdgeInsets.only(
        bottom:
            index + 1 < view.messages.length &&
                view.messages[index + 1].authorId == message.authorId
            ? 6
            : 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (index == boundary)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                context.strings.newMessages,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colors.primary),
              ),
            ),
          MessageBubble(
            text: message.text,
            author: author,
            mine: mine,
            grouped: grouped,
            sentAt:
                message.createdAtUnixMs > 0 &&
                    message.createdAtUnixMs.toInt() <= 8640000000000000
                ? DateTime.fromMillisecondsSinceEpoch(
                    message.createdAtUnixMs.toInt(),
                    isUtc: true,
                  ).toLocal()
                : null,
            accepted: mine,
            favorite: view.isFavorite(message),
            onToggleFavorite: () =>
                unawaited(controller.toggleFavorite(message)),
          ),
        ],
      ),
    );
  }

  Widget _channelPicker(BuildContext context) {
    final controller = widget.controller;
    final view = widget.controller.state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              key: ValueKey(
                'channels-${view.channelId}-${view.channels.map((v) => v.id).join(',')}',
              ),
              initialValue: view.channels.any((v) => v.id == view.channelId)
                  ? view.channelId
                  : null,
              isExpanded: true,
              decoration: InputDecoration(labelText: context.strings.channel),
              items: [
                for (final channel in view.channels)
                  DropdownMenuItem(
                    value: channel.id,
                    child: Text(
                      '${channel.title}${channel.archived ? ' · ${context.strings.archived}' : ''}${!channel.permissions.read ? ' · ${context.strings.noReading}' : ''}${view.unreadCount(channel.id) > 0 ? ' · ${context.strings.newChannelMessages(view.unreadCount(channel.id))}' : ''}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: view.busy
                  ? null
                  : (id) {
                      if (id != null) controller.selectChannel(id);
                    },
            ),
          ),
          IconButton(
            tooltip: context.strings.refreshChat,
            onPressed: view.busy
                ? null
                : () {
                    controller.selectChannel(view.channelId);
                  },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _emptyMessageArea(BuildContext context) {
    final view = widget.controller.state;
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.forum_outlined, size: 64, color: colors.primary),
                const SizedBox(height: 20),
                Text(
                  view.connected && !view.canRead
                      ? context.strings.noMessageAccess
                      : view.connected
                      ? context.strings.startConversation
                      : context.strings.conversationStarts,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  view.connected && !view.canRead
                      ? context.strings.contactOwner
                      : view.connected
                      ? context.strings.emptyChat
                      : context.strings.connectChatHelp,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.onSurfaceVariant, height: 1.6),
                ),
                if (!view.connected) ...[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: view.busy ? null : widget.openConnection,
                    icon: const Icon(Icons.add),
                    label: Text(context.strings.addSpace),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _messageArea(BuildContext context) {
    final controller = widget.controller;
    final view = widget.controller.state;
    final favorites = view.messages.where(view.isFavorite).toList();
    return Expanded(
      child: view.messages.isEmpty
          ? _emptyMessageArea(context)
          : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: favorites.isEmpty ? 0 : 36),
                  child: ListView.builder(
                    key: viewport,
                    controller: scroll,
                    padding: const EdgeInsets.all(24),
                    itemCount: view.messages.length,
                    itemBuilder: (context, index) {
                      return _messageRow(context, index);
                    },
                  ),
                ),
                if (favorites.isNotEmpty)
                  Positioned.fill(
                    child: FavoriteMessages(
                      messages: favorites,
                      principalId: view.principalId,
                      onJump: (message) => unawaited(jumpToMessage(message.id)),
                      onRemove: (message) =>
                          unawaited(controller.toggleFavorite(message)),
                    ),
                  ),
              ],
            ),
    );
  }

  void _restoreViewport(Duration elapsed) {
    final controller = widget.controller;

    if (!mounted) return;
    if (restoreScroll && scroll.hasClients) {
      restoreScroll = false;
      final saved = offsets[scope];
      final atEnd =
          controller.messages.isNotEmpty &&
          controller.readThrough == controller.messages.last.id;
      scroll.jumpTo(
        (saved ?? (atEnd ? scroll.position.maxScrollExtent : 0)).clamp(
          0,
          scroll.position.maxScrollExtent,
        ),
      );
    }
    markRead();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<ChatController, ChatState>(
    bloc: widget.controller,
    builder: (context, state) => _build(context),
  );

  Widget _build(BuildContext context) {
    final view = widget.controller.state;
    final colors = Theme.of(context).colorScheme;
    WidgetsBinding.instance.addPostFrameCallback(_restoreViewport);
    return Column(
      children: [
        if (widget.showHeader)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
            child: Row(
              children: [
                const Icon(Icons.tag),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        view.connected ? view.chatTitle : context.strings.chat,
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        context.strings.chatDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: context.strings.connectionInformation,
                  onPressed: widget.openConnection,
                  icon: const Icon(Icons.info_outline),
                ),
              ],
            ),
          ),
        if (widget.showHeader) const Divider(height: 1),
        if (view.channels.isNotEmpty &&
            (widget.showHeader || MediaQuery.sizeOf(context).width < 760))
          _channelPicker(context),
        _messageArea(context),
        if (view.canRead && view.unreadCount(view.channelId) > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: jumpToNew,
                icon: const Icon(Icons.arrow_downward, size: 18),
                label: Text(
                  context.strings.newMessagesCount(
                    view.unreadCount(view.channelId),
                  ),
                ),
              ),
            ),
          ),
        if (view.sendStatus != MessageSendStatus.idle)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
            child: Text(switch (view.sendStatus) {
              MessageSendStatus.sending => context.strings.sendingMessage,
              MessageSendStatus.unconfirmed =>
                context.strings.messageUnconfirmed,
              MessageSendStatus.accepted => context.strings.messageAccepted,
              MessageSendStatus.idle => '',
            }, style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant)),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Focus(
                      canRequestFocus: false,
                      onKeyEvent: _draftKeyEvent,
                      child: TextField(
                        key: const ValueKey('chat-draft'),
                        focusNode: draftFocus,
                        controller: draft,
                        enabled: view.connected && view.canWrite && !view.busy,
                        minLines: 1,
                        maxLines: 4,
                        maxLength: 1024,
                        decoration: InputDecoration(
                          hintText: view.connected && !view.canWrite
                              ? context.strings.cannotSend
                              : context.strings.messageHint,
                          counterText: '',
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: view.connected && view.canWrite && !view.busy
                        ? send
                        : null,
                    tooltip: context.strings.sendMessage,
                    style: IconButton.styleFrom(
                      foregroundColor: colors.onPrimary,
                    ),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
