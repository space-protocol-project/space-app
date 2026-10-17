import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:space_client/src/notification_targets.dart';
import 'package:space_client/src/secure_vault.dart';
import 'package:space_client/src/system_notifications.dart';

// Только искусственные цели в отдельном каталоге CI, без системного vault.
class _ProbeStorage implements SecureKeyStorage {
  _ProbeStorage(this.file);
  final File file;
  @override
  Future<String?> read({required String key}) async =>
      file.existsSync() ? file.readAsString() : null;
  @override
  Future<void> write({required String key, required String value}) async {
    await file.writeAsString(value, flush: true);
  }

  @override
  Future<void> delete({required String key}) async {
    if (file.existsSync()) await file.delete();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final root = Platform.environment['SPACE_NOTIFICATION_PROBE_DIR'];
  if (root == null || !Directory(root).existsSync()) {
    throw StateError('Нужен изолированный каталог проверки');
  }
  final store = NotificationTargets(
    storage: _ProbeStorage(File('$root/store')),
  );
  final service = SystemNotifications(savedTargets: store);
  service.targets.stream.listen((payload) async {
    await File('$root/events').writeAsString(
      '${jsonEncode({'pid': pid, 'payload': jsonDecode(payload)})}\n',
      mode: FileMode.append,
      flush: true,
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));
    exit(0);
  });
  final seed = File('$root/seed');
  if (seed.existsSync()) {
    await seed.delete();
    for (final id in [1, 2]) {
      await service.show(
        id: id,
        title: 'Space',
        body: 'Новое сообщение',
        target: ['https://fixture.invalid', 'test-user', 'general', id],
      );
    }
    final data = jsonDecode(await File('$root/store').readAsString()) as Map;
    final tokens = [
      for (final id in [1, 2])
        data.keys.singleWhere((token) => data[token]['id'] == id),
    ];
    await File('$root/tokens').writeAsString(jsonEncode(tokens), flush: true);
  }
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('Notification probe'))),
    ),
  );
  await service.listenForActivation(enabled: true);
  await File('$root/boots')
      .writeAsString('$pid\n', mode: FileMode.append, flush: true);
}
