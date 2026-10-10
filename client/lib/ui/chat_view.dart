import 'package:flutter/material.dart';

import '../src/chat_controller.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.controller,
    required this.openConnection,
    this.active = true,
  });
  final ChatController controller;
  final VoidCallback openConnection;
  final bool active;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  final draft = TextEditingController();
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
    final c = widget.controller;
    if (scroll.hasClients) offsets[scope] = scroll.offset;
    if (jumping ||
        ModalRoute.of(context)?.isCurrent == false ||
        !widget.active ||
        !foreground ||
        !c.canRead ||
        !scroll.hasClients ||
        c.messages.isEmpty) {
      return;
    }
    if (scroll.position.extentAfter < 24) {
      c.markRead(c.messages.last.id);
      return;
    }
    final box = viewport.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy,
        bottom = box.localToGlobal(Offset(0, box.size.height)).dy;
    String? lastVisible;
    for (final message in c.messages) {
      final row = messageKeys[message.id]?.currentContext?.findRenderObject();
      if (row is! RenderBox || !row.hasSize) continue;
      final start = row.localToGlobal(Offset.zero).dy;
      final end = row.localToGlobal(Offset(0, row.size.height)).dy;
      if (start >= top && end <= bottom) lastVisible = message.id;
    }
    if (lastVisible != null) c.markRead(lastVisible);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      setState(() => foreground = state == AppLifecycleState.resumed);
    }
  }

  Future<void> jumpToNew() async {
    if (jumping || !scroll.hasClients) return;
    final c = widget.controller, startingScope = scope;
    final list = c.messages;
    final index = list.indexWhere((m) => m.id == c.readThrough) + 1;
    if (index >= list.length) return;
    final id = list[index].id;
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
        final viewportBox = viewport.currentContext?.findRenderObject();
        if (viewportBox is! RenderBox || !scroll.hasClients) break;
        final top = viewportBox.localToGlobal(Offset.zero).dy;
        final bottom = top + viewportBox.size.height;
        final visible = <int>[];
        for (var i = 0; i < list.length; i++) {
          final box = messageKeys[list[i].id]?.currentContext
              ?.findRenderObject();
          if (box is! RenderBox || !box.hasSize) continue;
          final y = box.localToGlobal(Offset.zero).dy;
          if (y < bottom && y + box.size.height > top) visible.add(i);
        }
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
      if (mounted) {
        setState(() => jumping = false);
        if (scope == startingScope) markRead();
      } else {
        jumping = false;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    draft.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final text = draft.text;
    if (await widget.controller.send(text) && mounted && draft.text == text) {
      draft.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final colors = Theme.of(context).colorScheme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (restoreScroll && scroll.hasClients) {
        restoreScroll = false;
        final saved = offsets[scope];
        final atEnd =
            c.messages.isNotEmpty && c.readThrough == c.messages.last.id;
        scroll.jumpTo(
          (saved ?? (atEnd ? scroll.position.maxScrollExtent : 0)).clamp(
            0,
            scroll.position.maxScrollExtent,
          ),
        );
      }
      markRead();
    });
    return Column(
      children: [
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
                      c.chatTitle,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Разговоры и маленькие открытия.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Информация о подключении',
                onPressed: widget.openConnection,
                icon: const Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        if (c.channels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    key: ValueKey(
                      'channels-${c.channelId}-${c.channels.map((v) => v.id).join(',')}',
                    ),
                    initialValue: c.channels.any((v) => v.id == c.channelId)
                        ? c.channelId
                        : null,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Канал'),
                    items: [
                      for (final channel in c.channels)
                        DropdownMenuItem(
                          value: channel.id,
                          child: Text(
                            '${channel.title}${channel.archived ? ' · Архив' : ''}${!channel.permissions.read ? ' · Нет чтения' : ''}${c.unreadCount(channel.id) > 0 ? ' · ${c.unreadCount(channel.id)} новых' : ''}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: c.busy
                        ? null
                        : (id) {
                            if (id != null) c.selectChannel(id);
                          },
                  ),
                ),
                IconButton(
                  tooltip: 'Обновить каналы и чат',
                  onPressed: c.busy
                      ? null
                      : () {
                          c.selectChannel(c.channelId);
                        },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        Expanded(
          child: c.messages.isEmpty
              ? LayoutBuilder(
                  builder: (context, box) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: box.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.forum_outlined,
                              size: 64,
                              color: colors.primary,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              c.connected && !c.canRead
                                  ? 'Нет доступа к сообщениям'
                                  : c.connected
                                  ? 'Начните разговор'
                                  : 'Здесь начинается разговор',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              c.connected && !c.canRead
                                  ? 'Выберите другой канал или обратитесь к владельцу пространства.'
                                  : c.connected
                                  ? 'В этом чате пока нет сообщений.'
                                  : 'Подключите своё пространство. Ваши ключи останутся на этом устройстве.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                            if (!c.connected) ...[
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: c.busy
                                    ? null
                                    : widget.openConnection,
                                icon: const Icon(Icons.add),
                                label: const Text('Добавить пространство'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  key: viewport,
                  controller: scroll,
                  padding: const EdgeInsets.all(24),
                  itemCount: c.messages.length,
                  itemBuilder: (context, index) {
                    final message = c.messages[index];
                    final mine = message.authorId == c.principalId;
                    final author = mine
                        ? 'Вы'
                        : message.authorId.length > 16
                        ? '${message.authorId.substring(0, 16)}…'
                        : message.authorId;
                    final boundary =
                        c.messages.indexWhere((m) => m.id == entryReadThrough) +
                        1;
                    return Padding(
                      key: messageKeys.putIfAbsent(message.id, GlobalKey.new),
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: colors.surfaceContainerHighest,
                            child: Icon(
                              mine ? Icons.person_outline : Icons.person,
                              size: 20,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == boundary)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'Новые сообщения',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colors.primary,
                                      ),
                                    ),
                                  ),
                                Text(
                                  author,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: colors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                SelectableText(
                                  message.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.65,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (c.canRead && c.unreadCount(c.channelId) > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: jumpToNew,
                icon: const Icon(Icons.arrow_downward, size: 18),
                label: Text('Новые сообщения: ${c.unreadCount(c.channelId)}'),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('chat-draft'),
                  controller: draft,
                  enabled: c.connected && c.canWrite && !c.busy,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 1024,
                  decoration: InputDecoration(
                    hintText: c.connected && !c.canWrite
                        ? 'В этом канале нельзя отправлять сообщения'
                        : 'Что у вас нового?',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: c.connected && c.canWrite && !c.busy ? send : null,
                tooltip: 'Отправить',
                icon: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
