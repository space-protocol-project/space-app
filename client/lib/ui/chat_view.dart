import 'message_input_surface.dart';
import '../src/saved_drafts.dart';

import 'package:flutter/rendering.dart' show ScrollDirection;

import 'message_reply.dart';
import 'outbox_panel.dart';
import 'emoji_picker.dart';
import 'message_reactions.dart';
import 'message_context_menu.dart';

import 'package:desktop_drop/desktop_drop.dart';

import '../src/attachments.dart';
import 'attachment_widgets.dart';
import 'channel_files.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import '../src/generated/space/v1/space.pb.dart';
import '../l10n/failure_strings.dart';

import 'package:flutter/services.dart';

import '../l10n/strings.dart';

import 'package:flutter/material.dart';

import '../src/chat_controller.dart';
import 'message_bubble.dart';
import 'message_actions.dart';
import 'favorite_messages.dart';
import 'space_appearance.dart';
import 'measure_size.dart';

part 'chat_history_paging.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.controller,
    required this.openConnection,
    this.active = true,
    this.showHeader = true,
    this.sendWithShift = false,
    this.jumpRequest,
    this.topInset = 0,
    this.jumpGeneration = 0,
  });
  final ChatController controller;
  final VoidCallback openConnection;
  final bool active, showHeader, sendWithShift;
  final String? jumpRequest;
  final double topInset;
  final int jumpGeneration;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  final queues = <String, AttachmentQueue>{};
  AttachmentQueue get attachmentQueue =>
      queues.putIfAbsent(scope, AttachmentQueue.new);
  bool draggingFiles = false;
  bool loadingOlderViewport = false;
  _HistoryViewport? historyViewport;
  void beginHistoryViewport(_HistoryViewport request) {
    setState(() {
      historyViewport = request;
      loadingOlderViewport = true;
      jumping = true;
    });
  }

  void endHistoryViewport(_HistoryViewport request) {
    if (!mounted || !identical(historyViewport, request)) return;
    setState(() {
      historyViewport = null;
      loadingOlderViewport = false;
      jumping = false;
    });
    if (scope == request.scope) queueReadCheck();
  }

  final draft = TextEditingController();
  Content? editing;
  final replyDrafts = <String, String>{};
  String get replyTo => replyDrafts[scope] ?? '';
  Content? replyTarget(String id) => widget.controller.messages
      .where((m) => m.id == id && m.channelId == widget.controller.channelId)
      .firstOrNull;
  void startReply(Content message) {
    if (!widget.controller.canReplyTo(message)) return;
    setState(() {
      if (editing != null) finishEditing();
      replyDrafts[scope] = message.id;
    });
    draftFocus.requestFocus();
  }

  Widget replyPreview(String id, {bool composer = false}) {
    final target = replyTarget(id);
    return MessageReply(
      key: ValueKey(composer ? 'composer-reply' : 'reply-$id'),
      message: target,
      onJump: target == null || target.deleted
          ? null
          : () => unawaited(jumpToMessage(id)),
      onCancel: composer
          ? () => setState(() => replyDrafts.remove(scope))
          : null,
    );
  }

  TextEditingValue? savedDraft;
  String editError = '';
  final draftFocus = FocusNode();
  final scroll = ScrollController();
  final Map<String, String> drafts = {};
  bool changingDraft = false;
  int draftLoadGeneration = 0;
  final Map<String, double> offsets = {};
  bool restoreScroll = true;
  String scope = '';
  final viewport = GlobalKey();
  final composer = GlobalKey();
  double composerHeight = 110;
  final messageKeys = <String, GlobalKey>{};
  String entryReadThrough = '';
  bool foreground = true, jumping = false;
  bool previewVisible = false;
  bool readCheckPending = false;
  @override
  void initState() {
    super.initState();
    scope = widget.controller.draftScope;
    entryReadThrough = widget.controller.readThrough;
    foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    scroll.addListener(queueReadCheck);
    draft.addListener(saveDraft);
    unawaited(loadDraft(scope));
  }

  void saveDraft() {
    if (editing != null || changingDraft) return;
    draftLoadGeneration++;
    drafts[scope] = draft.text;
    SavedDrafts.save(scope, draft.text);
  }

  Future<void> loadDraft(String requestedScope) async {
    final generation = draftLoadGeneration;
    try {
      final text = await SavedDrafts.load(requestedScope);
      if (!mounted ||
          generation != draftLoadGeneration ||
          scope != requestedScope ||
          draft.text.isNotEmpty) {
        return;
      }
      draft.text = text;
    } catch (_) {
      // Ошибка хранилища не должна мешать набору нового сообщения.
    }
  }

  @override
  void didUpdateWidget(covariant ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.jumpRequest != null &&
        widget.jumpGeneration != oldWidget.jumpGeneration) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(jumpToMessage(widget.jumpRequest!));
      });
    }
    final next = widget.controller.draftScope;
    if (next != scope) {
      if (editing != null) finishEditing();
      previewVisible = false;
      historyViewport = null;
      loadingOlderViewport = false;
      jumping = false;
      drafts[scope] = draft.text;
      scope = next;
      entryReadThrough = widget.controller.readThrough;
      messageKeys.clear();
      changingDraft = true;
      draft.text = drafts[scope] ?? '';
      changingDraft = false;
      unawaited(loadDraft(scope));
      restoreScroll = true;
    }
  }

  void queueReadCheck() {
    if (scroll.hasClients) offsets[scope] = scroll.offset;
    if (readCheckPending) return;
    readCheckPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readCheckPending = false;
      if (mounted) markRead();
    });
  }

  void markRead() {
    final controller = widget.controller;
    final messages = controller.state.messages;
    if (scroll.hasClients) offsets[scope] = scroll.offset;
    if (jumping ||
        previewVisible ||
        ModalRoute.of(context)?.isCurrent == false ||
        !widget.active ||
        !foreground ||
        !controller.canRead ||
        !scroll.hasClients ||
        messages.isEmpty) {
      return;
    }
    final box = viewport.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy + widget.topInset;
    final bottom = visibleBottom(box);
    String? lastVisible;
    for (final message in messages) {
      final row = messageKeys[message.id]?.currentContext?.findRenderObject();
      if (row is! RenderBox || !row.hasSize) continue;
      final start = row.localToGlobal(Offset.zero).dy;
      final end = row.localToGlobal(Offset(0, row.size.height)).dy;
      if (start >= top && end <= bottom) lastVisible = message.id;
    }
    if (lastVisible != null && lastVisible != controller.state.readThrough) {
      controller.markRead(lastVisible);
    }
  }

  double visibleBottom(RenderBox history) {
    final bottom = history.localToGlobal(Offset(0, history.size.height)).dy;
    final field = composer.currentContext?.findRenderObject();
    if (field is! RenderBox || !field.hasSize) return bottom;
    return bottom.clamp(
      double.negativeInfinity,
      field.localToGlobal(Offset.zero).dy - 8,
    );
  }

  void composerResized(Size size) {
    if (mounted && (size.height - composerHeight).abs() > 1) {
      setState(() => composerHeight = size.height);
    }
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
    try {
      await _seekMessage(id, index, list, startingScope);
    } finally {
      _finishMessageJump(startingScope);
    }
  }

  Future<void> revealTarget(BuildContext target, String startingScope) async {
    await Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 260),
      alignment: 0,
    );
    if (!mounted || !scroll.hasClients || scope != startingScope) return;
    scroll.jumpTo(
      (scroll.offset - widget.topInset - 12).clamp(
        0,
        scroll.position.maxScrollExtent,
      ),
    );
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
    for (final queue in queues.values) {
      unawaited(queue.close());
    }
    draft.dispose();
    draftFocus.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> send() async {
    if (editing != null) {
      await saveEdit();
      return;
    }
    final text = draft.text;
    final restoreFocus = draftFocus.hasFocus;
    final target = widget.controller, startingScope = scope;
    final queue = attachmentQueue;
    if (queue.state.busy || target.busy) return;
    final selected = queue.state.files.map((entry) => entry.file).toList();
    final replying = replyTo;
    final sent = await target.send(text, files: selected, replyTo: replying);
    if (sent && replyDrafts[startingScope] == replying) {
      replyDrafts.remove(startingScope);
    }
    if (sent) queue.clear();
    if (!mounted) return;
    if (sent) _clearSentDraft(text, startingScope, target);
    if (restoreFocus) _restoreDraftFocus(startingScope, target);
  }

  void startEditing(Content message) {
    if (widget.controller.busy || attachmentQueue.state.busy) return;
    setState(() {
      savedDraft ??= draft.value;
      editing = message;
      editError = '';
      draft.value = TextEditingValue(
        text: message.text,
        selection: TextSelection.collapsed(offset: message.text.length),
      );
      draggingFiles = false;
    });
    draftFocus.requestFocus();
  }

  void finishEditing() {
    draft.value = savedDraft ?? TextEditingValue.empty;
    savedDraft = null;
    editing = null;
    editError = '';
  }

  Future<void> saveEdit() async {
    final message = editing;
    final controller = widget.controller;
    if (message == null || controller.busy) return;
    final text = draft.text;
    if ((text.trim().isEmpty && message.attachments.isEmpty) ||
        utf8.encode(text).length > 4096) {
      setState(() => editError = context.strings.messageTextInvalid);
      return;
    }
    final success = await controller.updateMessage(message, text);
    if (!mounted ||
        !identical(editing, message) ||
        !identical(controller, widget.controller)) {
      return;
    }
    setState(() {
      if (success) {
        finishEditing();
      } else {
        editError = chatFailureText(context, controller);
        if (editError.isEmpty) {
          editError = context.strings.failureOperationFailed;
        }
      }
    });
    _restoreDraftFocus(scope, controller);
  }

  void _restoreDraftFocus(String startingScope, ChatController target) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          widget.active &&
          foreground &&
          scope == startingScope &&
          identical(widget.controller, target) &&
          target.canQueue &&
          !target.busy &&
          ModalRoute.of(context)?.isCurrent != false) {
        draftFocus.requestFocus();
      }
    });
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
    if (editing != null &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape &&
        !widget.controller.busy) {
      setState(finishEditing);
      return KeyEventResult.handled;
    }
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

  String _authorName(BuildContext context, Content message, bool mine) {
    if (mine) return context.strings.you;
    final name = message.participantNames[message.authorId] ?? message.authorId;
    return name.length > 16 ? '${name.substring(0, 16)}…' : name;
  }

  Widget _messageRow(BuildContext context, int index, int boundary) {
    final controller = widget.controller;
    final view = widget.controller.state;
    final colors = Theme.of(context).colorScheme;
    final message = view.messages[index];
    final mine = message.authorId == view.principalId;
    final author = _authorName(context, message, mine);
    final grouped =
        index > 0 &&
        view.messages[index - 1].authorId == message.authorId &&
        index != boundary;
    return Padding(
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
          MessageContextMenu(
            text: message.deleted ? '' : message.text,
            onReact: controller.canReact && !message.deleted
                ? (emoji) => unawaited(
                    controller.setReaction(
                      message,
                      emoji,
                      !message.reactions.any(
                        (r) =>
                            r.emoji == emoji &&
                            r.principalIds.contains(view.principalId),
                      ),
                    ),
                  )
                : null,
            onReply: controller.canReplyTo(message)
                ? () => startReply(message)
                : null,
            onEdit: controller.canChangeMessage(message)
                ? () => startEditing(message)
                : null,
            onDelete: controller.canChangeMessage(message)
                ? () => confirmDeleteMessage(context, controller, message)
                : null,
            favorite: view.isFavorite(message),
            onFavorite: message.deleted
                ? null
                : () => unawaited(controller.toggleFavorite(message)),
            child: _bubble(context, message, author, mine, grouped),
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
                  _emptyTitle(context, view),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  _emptyDescription(context, view),
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
    final view = controller.state;
    final favorites = view.messages.where(view.isFavorite).toList();
    final boundary =
        view.messages.indexWhere((m) => m.id == entryReadThrough) + 1;
    if (view.messages.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          top: widget.topInset,
          bottom: composerHeight + 36,
        ),
        child: _emptyMessageArea(context),
      );
    }
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: favorites.isEmpty ? 0 : 44),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: SpaceAppearance.conversationWidth,
              child: historyMessageList(context, boundary),
            ),
          ),
        ),
        if (favorites.isNotEmpty)
          Positioned.fill(
            child: FavoriteMessages(
              messages: favorites,
              principalId: view.principalId,
              onPreviewChanged: (visible) => previewVisible = visible,
              onJump: (message) => unawaited(jumpToMessage(message.id)),
              onRemove: (message) =>
                  unawaited(controller.toggleFavorite(message)),
            ),
          ),
      ],
    );
  }

  Widget _chatStack(BuildContext context) => LayoutBuilder(
    builder: (context, box) => Stack(
      children: [
        Positioned.fill(child: _messageArea(context)),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: SpaceAppearance.conversationWidth,
                maxHeight: math.min(
                  box.maxHeight * .65,
                  MediaQuery.sizeOf(context).height / 3,
                ),
              ),
              child: MeasureSize(
                key: composer,
                onChange: composerResized,
                child: _composer(context),
              ),
            ),
          ),
        ),
      ],
    ),
  );

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
    builder: (context, state) => DropTarget(
      enable:
          editing == null &&
          state.canQueue &&
          !state.busy &&
          widget.controller.canAttachFiles,
      onDragEntered: (_) => setState(() => draggingFiles = true),
      onDragExited: (_) => setState(() => draggingFiles = false),
      onDragDone: (details) {
        setState(() => draggingFiles = false);
        attachmentQueue.add(
          AttachmentFilesAdded(
            details.files.whereType<DropItemFile>().toList(),
          ),
        );
      },
      child: Stack(
        children: [
          _withFiles(context),
          if (draggingFiles)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: .15),
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(context.strings.dropFilesHere),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );

  Widget _withFiles(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final session = widget.controller.attachmentSession;
      if (constraints.maxWidth < 1080 ||
          session == null ||
          !widget.controller.canRead) {
        return _build(context);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _build(context)),
          SizedBox(
            width: 320,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, widget.topInset + 16, 16, 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ChannelFilesPanel(
                    key: ValueKey((widget.controller.draftScope, session)),
                    revision: Object.hashAll(
                      widget.controller.state.messages.map(
                        (m) =>
                            Object.hash(m.id, m.deleted, m.attachments.length),
                      ),
                    ),
                    session: session,
                    channel: widget.controller.channelId,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
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
        if (view.channels.isNotEmpty && widget.showHeader)
          _channelPicker(context),
        Expanded(child: _chatStack(context)),
      ],
    );
  }

  bool _showSendStatus(ChatState view) =>
      view.sendStatus != MessageSendStatus.idle &&
      view.outboxError.isEmpty &&
      !view.pendingMessages.any((entry) => entry.channelId == view.channelId);

  Widget _composer(BuildContext context) {
    final view = widget.controller.state;
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        if (editing == null && widget.controller.canAttachFiles)
          AttachmentComposer(
            queue: attachmentQueue,
            session: widget.controller.attachmentSession,
          ),
        OutboxPanel(controller: widget.controller, state: view),
        if (_showSendStatus(view))
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
            child: Text(switch (view.sendStatus) {
              MessageSendStatus.sending => context.strings.sendingMessage,
              MessageSendStatus.unconfirmed =>
                context.strings.messageUnconfirmed,
              MessageSendStatus.accepted => context.strings.messageAccepted,
              MessageSendStatus.idle => '',
              MessageSendStatus.queued => context.strings.messageQueued,
            }, style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant)),
          ),
        Flexible(child: _inputSurface(context)),
      ],
    );
  }

  Widget _inputSurface(BuildContext context) => MessageInputSurface(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (editing == null && replyTo.isNotEmpty)
          replyPreview(replyTo, composer: true),
        if (editing != null)
          Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.edit_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(context.strings.editMessage)),
              IconButton(
                onPressed: widget.controller.busy
                    ? null
                    : () => setState(finishEditing),
                tooltip: context.strings.cancelMessageChange,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        if (editError.isNotEmpty)
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                editError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        Flexible(child: _draftField(context)),
        _composerButtons(context),
      ],
    ),
  );

  Widget _draftField(BuildContext context) {
    final view = widget.controller.state;
    return Focus(
      canRequestFocus: false,
      onKeyEvent: _draftKeyEvent,
      child: TextField(
        key: const ValueKey('chat-draft'),
        focusNode: draftFocus,
        controller: draft,
        enabled: editing == null
            ? view.canQueue
            : widget.controller.canChangeMessage(editing!),
        minLines: 3,
        maxLines: null,
        maxLength: editing == null ? 1024 : 4096,
        decoration: messageInputDecoration(
          view.connected && !view.canWrite
              ? context.strings.cannotSend
              : context.strings.messageHint,
        ),
      ),
    );
  }

  Widget _composerButtons(BuildContext context) {
    final view = widget.controller.state;
    final enabled = editing == null
        ? view.canQueue
        : widget.controller.canChangeMessage(editing!);
    return Row(
      key: const ValueKey('composer-actions'),
      children: [
        if (editing == null && widget.controller.canAttachFiles)
          AttachFileButton(queue: attachmentQueue, enabled: enabled),
        EmojiButton(controller: draft, enabled: enabled),
        const Spacer(),
        IconButton.filled(
          onPressed: enabled ? send : null,
          tooltip: editing == null
              ? context.strings.sendMessage
              : context.strings.saveMessage,
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          icon: Icon(editing == null ? Icons.arrow_upward : Icons.check),
        ),
      ],
    );
  }

  Widget _bubble(
    BuildContext context,
    Content message,
    String author,
    bool mine,
    bool grouped,
  ) {
    final controller = widget.controller;
    final view = controller.state;
    return MessageBubble(
      key: messageKeys.putIfAbsent(message.id, GlobalKey.new),
      text: message.text,
      reply: message.replyToId.isEmpty ? null : replyPreview(message.replyToId),
      attachments: message.deleted || !controller.attachmentsEnabled
          ? null
          : MessageAttachments(
              assets: message.attachments,
              session: controller.attachmentSession,
            ),
      reactions: MessageReactionBar(
        reactions: message.reactions,
        principalId: view.principalId,
        authorName: (id) => message.participantNames[id] ?? id,
        onSet: controller.canReact && !message.deleted
            ? (emoji, active) =>
                  unawaited(controller.setReaction(message, emoji, active))
            : null,
      ),
      edited: message.updatedAtUnixMs > 0,
      deleted: message.deleted,
      actions: controller.canChangeMessage(message)
          ? MessageActions(
              controller: controller,
              message: message,
              onEdit: () => startEditing(message),
            )
          : null,
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
      onToggleFavorite: message.deleted
          ? null
          : () => unawaited(controller.toggleFavorite(message)),
    );
  }

  String _emptyTitle(BuildContext context, ChatState view) =>
      view.connected && !view.canRead
      ? context.strings.noMessageAccess
      : view.connected
      ? context.strings.startConversation
      : context.strings.conversationStarts;

  String _emptyDescription(BuildContext context, ChatState view) =>
      view.connected && !view.canRead
      ? context.strings.contactOwner
      : view.connected
      ? context.strings.emptyChat
      : context.strings.connectChatHelp;

  Future<void> _seekMessage(
    String id,
    int index,
    List<Content> list,
    String startingScope,
  ) async {
    var low = 0.0, high = scroll.position.maxScrollExtent;
    for (
      var attempt = 0;
      attempt < 24 && mounted && scope == startingScope;
      attempt++
    ) {
      final target = messageKeys[id]?.currentContext;
      if (target != null && target.mounted) {
        await revealTarget(target, startingScope);
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
  }
}
