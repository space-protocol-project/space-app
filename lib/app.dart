import 'package:flutter/material.dart';

import 'src/chat_controller.dart';
import 'src/secure_vault.dart';

class SpaceApp extends StatelessWidget {
  const SpaceApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Space',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFABD2F),
        brightness: Brightness.dark,
        primary: const Color(0xFFFABD2F),
        onPrimary: const Color(0xFF282828),
        secondary: const Color(0xFFB8BB26),
        onSecondary: const Color(0xFF282828),
        surface: const Color(0xFF32302F),
        onSurface: const Color(0xFFEBDBB2),
        onSurfaceVariant: const Color(0xFFBDAE93),
        outline: const Color(0xFF928374),
        error: const Color(0xFFFB4934),
      ),
      scaffoldBackgroundColor: const Color(0xFF282828),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
      ),
      fontFamily: 'Segoe UI',
    ),
    home: const ChatPage(),
  );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController controller = ChatController(SecureIdentityVault());
  final address = TextEditingController(text: 'http://127.0.0.1:8080');
  final draft = TextEditingController();
  final scroll = ScrollController();
  @override
  void dispose() {
    controller.dispose();
    address.dispose();
    draft.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final text = draft.text;
    if (await controller.send(text) && mounted && draft.text == text) {
      draft.clear();
    }
  }

  Widget sidebar() => Container(
    width: 300,
    padding: const EdgeInsets.all(24),
    color: const Color(0xFF1D2021),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFFABD2F)),
              SizedBox(width: 12),
              Text(
                'Space',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Ваши пространства',
            style: TextStyle(color: Color(0xFFBDAE93)),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: address,
            enabled: !controller.busy && !controller.connected,
            decoration: const InputDecoration(
              labelText: 'Адрес сервера',
              hintText: 'http://127.0.0.1:8080',
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: controller.busy || controller.connected
                ? null
                : () => controller.inspect(address.text),
            icon: const Icon(Icons.travel_explore),
            label: const Text('Проверить сервер'),
          ),
          if (controller.preview != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Проверка доверия',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SelectableText(controller.preview!.origin.toString()),
            const SizedBox(height: 8),
            const Text(
              'Отпечаток ключа',
              style: TextStyle(fontSize: 12, color: Color(0xFFBDAE93)),
            ),
            SelectableText(
              controller.fingerprint,
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.busy || controller.connected
                  ? null
                  : controller.connect,
              child: Text(
                controller.messages.isEmpty
                    ? 'Доверять и подключиться'
                    : 'Подключиться снова',
              ),
            ),
          ],
          const SizedBox(height: 28),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.tag),
            title: const Text('Общий чат'),
            subtitle: Text(
              controller.connected ? 'Подключён' : 'Ожидает подключения',
            ),
            selected: controller.connected,
          ),
          const SizedBox(height: 24),
          const Text(
            'Локальный прототип · Windows',
            style: TextStyle(fontSize: 12, color: Color(0xFFBDAE93)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Первый вход создаёт ключи для этого сервера. Recovery пока недоступно.',
            style: TextStyle(fontSize: 12, color: Color(0xFFBDAE93)),
          ),
        ],
      ),
    ),
  );
  Widget chat() => Expanded(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Row(
            children: [
              const Icon(Icons.tag),
              const SizedBox(width: 12),
              const Text(
                'Общий чат',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Icon(
                controller.connected
                    ? Icons.lock_outline
                    : Icons.cloud_off_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              if (MediaQuery.sizeOf(context).width > 950)
                Text(
                  controller.connected
                      ? 'Вход по ключу устройства'
                      : 'Не подключён',
                  style: const TextStyle(color: Color(0xFFBDAE93)),
                ),
              if (controller.connected)
                IconButton(
                  tooltip: 'Отозвать доступ устройства',
                  onPressed: controller.busy ? null : confirmRevoke,
                  icon: const Icon(Icons.no_accounts_outlined),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        if (controller.busy) const LinearProgressIndicator(minHeight: 2),
        if (controller.error.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF442F2B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(controller.error),
          ),
        Expanded(
          child: controller.messages.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 64,
                        color: Color(0xFFFABD2F),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Здесь начинается разговор',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Подключите своё пространство по адресу сервера.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFBDAE93)),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: scroll,
                  padding: const EdgeInsets.all(28),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final mine = message.authorId == controller.principalId;
                    final author = mine
                        ? 'Вы'
                        : (message.authorId.length > 16
                              ? '${message.authorId.substring(0, 16)}…'
                              : message.authorId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: mine
                                ? const Color(0xFF504945)
                                : const Color(0xFF3C3836),
                            child: Icon(
                              mine ? Icons.person_outline : Icons.person,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  author,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFB8BB26),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SelectableText(
                                  message.text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
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
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: draft,
                  enabled: controller.connected && !controller.busy,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 1024,
                  decoration: const InputDecoration(
                    hintText: 'Написать сообщение…',
                    counterText: '',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: controller.connected && !controller.busy
                    ? send
                    : null,
                tooltip: 'Отправить',
                icon: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Future<void> confirmRevoke() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отозвать доступ устройства?'),
        content: const Text(
          'Текущая сессия перестанет работать. Ключи останутся на устройстве; автоматического повторного разрешения нет.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Отозвать'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) await controller.revoke();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return Column(
                children: [
                  ExpansionTile(
                    title: const Text('Space · подключение'),
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.35,
                        child: sidebar(),
                      ),
                    ],
                  ),
                  chat(),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [sidebar(), chat()],
            );
          },
        ),
      ),
    ),
  );
}
