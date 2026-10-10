import 'package:flutter/material.dart';

Future<bool> confirmRecoveryAction(BuildContext context, String text) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтвердите действие'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    ) ??
    false;

Future<String?> askRecoveryPassword(
  BuildContext context, {
  required bool creating,
}) async {
  var first = '', second = '';
  String? error;
  try {
    return await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(creating ? 'Защитите карточку' : 'Открыть карточку'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Пароль шифрует файл только на этом устройстве. Сервер его не получает. Используйте несколько случайных слов и храните пароль отдельно.',
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (v) => first = v,
                  decoration: const InputDecoration(
                    labelText: 'Пароль (от 12 символов)',
                  ),
                ),
                if (creating) ...[
                  const SizedBox(height: 12),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (v) => second = v,
                    decoration: const InputDecoration(
                      labelText: 'Повторите пароль',
                    ),
                  ),
                ],
                if (error != null) Text(error!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                if (first.length < 12 || (creating && first != second)) {
                  update(
                    () => error =
                        'Пароль слишком короткий или значения не совпадают.',
                  );
                  return;
                }
                Navigator.pop(context, first);
              },
              child: Text(creating ? 'Зашифровать' : 'Открыть'),
            ),
          ],
        ),
      ),
    );
  } finally {
    first = '';
    second = '';
  }
}
