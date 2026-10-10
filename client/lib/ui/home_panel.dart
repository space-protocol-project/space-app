import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/home_controller.dart';
import 'components.dart';

class HomePanel extends StatefulWidget {
  const HomePanel({
    super.key,
    required this.home,
    required this.onStart,
    required this.onStop,
    required this.openAdministration,
  });
  final HomeController home;
  final Future<void> Function(String) onStart;
  final Future<void> Function() onStop;
  final VoidCallback openAdministration;
  @override
  State<HomePanel> createState() => _HomePanelState();
}

class _HomePanelState extends State<HomePanel> {
  late final address = TextEditingController(text: widget.home.ip);
  bool detecting = false;
  String detectionError = '';
  @override
  void dispose() {
    address.dispose();
    super.dispose();
  }

  Future<void> detect() async {
    setState(() {
      detecting = true;
      detectionError = '';
    });
    try {
      final ip = await widget.home.detectIP();
      if (mounted) address.text = ip;
    } catch (_) {
      if (mounted) {
        detectionError =
            'Не удалось определить адрес. Введите свой статический IP.';
      }
    } finally {
      if (mounted) setState(() => detecting = false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.home,
    builder: (context, _) {
      final home = widget.home;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.sensors),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Домашний сервер',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Закрыть',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              home.ip.isEmpty
                  ? 'Space скачает сервер и PostgreSQL, создаст базу и сертификат. Данные останутся на этом компьютере.'
                  : 'Повторный запуск использует ваш прежний сервер, базу, ключи, сертификат и участников.',
            ),
            const SizedBox(height: 20),
            TextField(
              controller: address,
              enabled: home.ip.isEmpty && !home.busy && !detecting,
              decoration: const InputDecoration(
                labelText: 'Статический публичный IPv4',
                hintText: 'Адрес, выданный провайдером',
              ),
            ),
            if (home.ip.isEmpty) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: home.busy || detecting ? null : detect,
                icon: const Icon(Icons.public),
                label: Text(
                  detecting ? 'Определяем IP…' : 'Определить IP автоматически',
                ),
              ),
              const Text(
                'Определение адреса обращается к ipify. При VPN будет показан адрес VPN.',
                style: TextStyle(fontSize: 12),
              ),
            ],
            if (detectionError.isNotEmpty) Text(detectionError),
            const SizedBox(height: 20),
            const Text(
              'Для доступа друзей направьте TCP-порт 8443 роутера на порт 8443 этого компьютера и разрешите его в брандмауэре. PostgreSQL и локальные порты наружу открывать не нужно.',
            ),
            const SizedBox(height: 20),
            if (home.busy) ...[
              LinearProgressIndicator(
                value: home.progress > 0 && home.progress < 1
                    ? home.progress
                    : null,
              ),
              const SizedBox(height: 10),
              Text(home.phase),
              const SizedBox(height: 16),
            ],
            if (home.error.isNotEmpty) ...[
              Text(
                home.error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
            ],
            SpaceActionButton(
              onPressed: home.busy || detecting
                  ? null
                  : () async {
                      if (home.running) {
                        await widget.onStop();
                      } else {
                        await widget.onStart(address.text);
                      }
                    },
              icon: home.running ? Icons.power_settings_new : Icons.sensors,
              label: home.running ? 'Отключиться' : 'Выйти в эфир',
            ),
            if (home.state != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Ссылка на ваш сервер (открывается через подключение в Space)',
              ),
              const SizedBox(height: 8),
              SelectableText(home.state!.link),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Clipboard.setData(
                      ClipboardData(text: home.state!.link),
                    ),
                    icon: const Icon(Icons.copy),
                    label: const Text('Копировать ссылку'),
                  ),
                  FilledButton.icon(
                    onPressed: widget.openAdministration,
                    icon: const Icon(Icons.tune),
                    label: const Text('Управлять сервером'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Сама ссылка не выдаёт права администратора. Друзей приглашайте через «Управление пространством → Приглашения». Остановка сервера завершит их подключения.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      );
    },
  );
}
