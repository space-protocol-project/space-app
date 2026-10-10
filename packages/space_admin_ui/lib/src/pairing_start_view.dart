import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PairingStartView extends StatelessWidget {
  const PairingStartView({
    super.key,
    required this.busy,
    required this.connectionBusy,
    required this.connected,
    required this.code,
    required this.signatureVerified,
    required this.verification,
    required this.error,
    required this.onStart,
    required this.onAccept,
    required this.onCancel,
  });
  final bool busy, connectionBusy, connected, signatureVerified;
  final String code, verification, error;
  final VoidCallback onStart, onAccept, onCancel;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 18),
      const Divider(),
      const SizedBox(height: 12),
      Text(
        'У вас уже есть идентичность?',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      const Text(
        'Подключите этот компьютер через подтверждение на исходном устройстве. Корневой ключ и карточка не копируются. Для сопряжения приглашение не нужно.',
      ),
      const SizedBox(height: 12),
      if (code.isEmpty)
        OutlinedButton.icon(
          onPressed: busy || connectionBusy || connected ? null : onStart,
          icon: const Icon(Icons.devices),
          label: const Text('Доверять серверу и начать сопряжение'),
        ),
      if (code.isNotEmpty) ...[
        const Text(
          'На исходном устройстве откройте «Идентичность» → «Подтвердить устройство» в приложении Space. Код действует пять минут.',
        ),
        const SizedBox(height: 10),
        SelectableText(
          code,
          style: const TextStyle(fontFamily: 'JetBrains Mono'),
        ),
        TextButton.icon(
          onPressed: () => Clipboard.setData(ClipboardData(text: code)),
          icon: const Icon(Icons.copy),
          label: const Text('Скопировать код'),
        ),
        if (!signatureVerified && error.isEmpty)
          const Text('Ожидаем подпись исходного устройства…'),
        if (!signatureVerified && verification.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Введите этот код проверки на управляющем устройстве до выдачи подписи:',
          ),
          SelectableText(
            verification,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontFamily: 'JetBrains Mono'),
          ),
        ],
        if (signatureVerified) ...[
          const SizedBox(height: 12),
          const Text('Root-подпись проверена. Сверьте код на обоих экранах:'),
          SelectableText(
            verification,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontFamily: 'JetBrains Mono'),
          ),
          FilledButton(
            onPressed: busy ? null : onAccept,
            child: const Text('Код совпадает — подключиться'),
          ),
        ],
        TextButton(
          onPressed: busy ? null : onCancel,
          child: const Text('Отменить сопряжение'),
        ),
      ],
      if (busy) const LinearProgressIndicator(),
      if (error.isNotEmpty)
        Text(
          error,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
    ],
  );
}
