import 'package:flutter/material.dart';

import '../src/chat_controller.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.controller,
    required this.openConnection,
  });
  final ChatController controller;
  final VoidCallback openConnection;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final draft = TextEditingController();
  final scroll = ScrollController();
  final Map<String, String> drafts = {};
  String scope = '';
  @override
  void initState() {
    super.initState();
    scope = widget.controller.preview?.origin.toString() ?? '';
  }

  @override
  void didUpdateWidget(covariant ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.controller.preview?.origin.toString() ?? '';
    if (next != scope) {
      drafts[scope] = draft.text;
      scope = next;
      draft.text = drafts[scope] ?? '';
    }
  }

  @override
  void dispose() {
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
                              c.connected
                                  ? 'Начните разговор'
                                  : 'Здесь начинается разговор',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              c.connected ? 'В этом чате пока нет сообщений.' : 'Подключите своё пространство. Ваши ключи останутся на этом устройстве.',
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
                    return Padding(
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                        ? 'Ваша роль разрешает только чтение'
                        : 'Что у вас нового?',
                    counterText: '',
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
