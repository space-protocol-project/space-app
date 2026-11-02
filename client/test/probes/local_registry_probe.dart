import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/extensions_p1/local_registry.dart';

void main(List<String> args) {
  final registry = LocalExtensionRegistry.open(
    args[0],
    device: 'device',
    profile: 'profile',
  );
  try {
    if (args[1] == 'read') {
      stdout.writeln(registry.snapshot.encode());
      return;
    }
    final before = registry.snapshot;
    final next =
        jsonDecode(File(args[2]).readAsStringSync()) as Map<String, dynamic>;
    registry.commit(
      expectedRevision: before.revision,
      generation: before.generation,
      entries: next.map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).cast<String, Object?>(),
        ),
      ),
      action: 'test_transaction',
      checkpoint: (phase) {
        if (phase != args[3]) return;
        stdout.writeln('checkpoint:$phase');
        // Родитель завершает процесс принудительно, без close/finally.
        stdin.readLineSync();
      },
    );
    stdout.writeln('committed');
  } finally {
    registry.close();
  }
}
