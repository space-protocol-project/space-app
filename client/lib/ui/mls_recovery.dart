import 'dart:typed_data';

import '../src/files.dart';
import 'package:flutter/material.dart';

import '../src/mls/client.dart';
import '../src/mls/history_archive.dart';

Future<String?> _password(BuildContext context, bool exporting) async {
  final field = TextEditingController();
  try {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exporting ? 'Сохранить историю' : 'Восстановить историю'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Архив содержит сообщения и ключи файлов, но не рабочие ключи MLS. '
              'Восстановление возможно только на новом устройстве. '
              'Сохраните пароль отдельно от архива.',
            ),
            TextField(
              controller: field,
              obscureText: true,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Пароль архива (от 12 символов)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (field.text.length >= 12) Navigator.pop(context, field.text);
            },
            child: const Text('Продолжить'),
          ),
        ],
      ),
    );
  } finally {
    field.dispose();
  }
}

Future<void> manageMlsArchive(
  BuildContext context,
  MlsClient client, {
  required bool exporting,
}) async {
  final password = await _password(context, exporting);
  if (password == null) return;
  if (exporting) {
    final history = await client.local.historyArchive();
    final bytes = await MlsHistoryArchive.seal(history, password);
    final destination = await getSaveLocation(
      suggestedName: 'space-history.mlsarchive',
    );
    if (destination == null) return;
    await SpaceFile.fromData(Uint8List.fromList(bytes)).saveTo(destination.path);
  } else {
    final file = await openFile();
    if (file == null) return;
    if (await file.length() > MlsHistoryArchive.maxBytes) {
      throw StateError('Архив слишком большой');
    }
    final history = await MlsHistoryArchive.open(
      await file.readAsBytes(),
      password,
    );
    await client.importHistory(history);
  }
}

Future<void> showMlsGroupCode(
  BuildContext context,
  MlsClient client,
  String channelId,
) async {
  final code = await client.groupCode(channelId);
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Код группы'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Эпоха ${code['epoch']}'),
          SelectableText(code['authenticator'] as String),
          const SizedBox(height: 16),
          const Text(
            'Сверьте код и эпоху с участниками вне этого чата. '
            'После изменения эпохи нужна новая сверка. Код не подтверждает полноту истории.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть'),
        ),
      ],
    ),
  );
}
