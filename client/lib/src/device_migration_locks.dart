import 'dart:io';

import 'outbox_lock.dart';

Future<void> withDeviceQueuesLocked(
  Directory root,
  Set<String> keys,
  Future<void> Function() action,
) async {
  final scopes =
      keys
          .where((key) => key.startsWith('space.outbox.v1.'))
          .map((key) => key.split('.').last)
          .toSet()
          .toList()
        ..sort();
  final families =
      keys
          .where((key) => key.startsWith('space.outbox.sources.v1.'))
          .map((key) => key.split('.').last)
          .toSet()
          .toList()
        ..sort();
  // Перенос очередей использует порядок: файлы → документы → каталог.
  final paths = <String>[];
  for (final category in ['outbox-file-locks', 'outbox-locks']) {
    final folder = await Directory('${root.path}/$category')
        .create(recursive: true);
    paths.addAll(scopes.map((id) => '${folder.path}/$id.lock'));
  }
  final folder = await Directory('${root.path}/outbox-catalog-locks')
      .create(recursive: true);
  paths.addAll(families.map((id) => '${folder.path}/$id.lock'));
  await _locked(paths, 0, action);
}

Future<void> _locked(
  List<String> paths,
  int index,
  Future<void> Function() action,
) {
  if (index == paths.length) return action();
  return OutboxLock.run(paths[index], () => _locked(paths, index + 1, action));
}
