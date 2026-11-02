import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/local_registry.dart';

Map<String, Map<String, Object?>> sample() => {
  'games': {
    'installation': 'games',
    'package': 'a' * 64,
    'schema': 1,
    'state': 'disabled',
    'data': '{"games":[]}',
    'staged': null,
  },
};

void main() {
  late Directory directory;
  late String path;
  setUp(() {
    directory = Directory.systemTemp.createTempSync('space-registry-');
    path = '${directory.path}/registry';
  });
  tearDown(() => directory.deleteSync(recursive: true));

  test('снимок, ревизия, блокировка и поколение', () {
    var registry = LocalExtensionRegistry.open(
      path,
      device: 'device',
      profile: 'profile',
    );
    final before = registry.snapshot;
    registry.commit(
      expectedRevision: before.revision,
      generation: before.generation,
      entries: sample(),
      action: 'install',
    );
    expect(
      () => registry.commit(
        expectedRevision: before.revision,
        generation: before.generation,
        entries: {},
        action: 'stale',
      ),
      throwsStateError,
    );
    expect(
      () => LocalExtensionRegistry.open(
        path,
        device: 'device',
        profile: 'profile',
      ),
      throwsStateError,
    );
    registry.snapshot.entries.clear();
    expect(registry.snapshot.entries, isNotEmpty);
    registry.close();
    registry = LocalExtensionRegistry.open(
      path,
      device: 'device',
      profile: 'profile',
    );
    expect(registry.snapshot.generation, isNot(before.generation));
    expect(registry.snapshot.entries, sample());
    registry.close();
    expect(
      () => LocalExtensionRegistry.open(
        path,
        device: 'other',
        profile: 'profile',
      ),
      throwsFormatException,
    );
  });

  test('повреждение полного кадра не принимается', () {
    final registry = LocalExtensionRegistry.open(
      path,
      device: 'device',
      profile: 'profile',
    );
    registry.close();
    final bytes = File(path).readAsBytesSync();
    bytes[0] = bytes[0] == 48 ? 49 : 48;
    File(path).writeAsBytesSync(bytes, flush: true);
    expect(
      () => LocalExtensionRegistry.open(
        path,
        device: 'device',
        profile: 'profile',
      ),
      throwsFormatException,
    );
  });

  test('ошибка после COMMIT закрывает оболочку до повторного открытия', () {
    final registry = LocalExtensionRegistry.open(
      path,
      device: 'device',
      profile: 'profile',
    );
    final before = registry.snapshot;
    expect(
      () => registry.commit(
        expectedRevision: before.revision,
        generation: before.generation,
        entries: sample(),
        action: 'install',
        checkpoint: (phase) {
          if (phase == 'after') throw StateError('lost_ack');
        },
      ),
      throwsStateError,
    );
    expect(() => registry.snapshot, throwsStateError);
    registry.close();
    final next = LocalExtensionRegistry.open(
      path,
      device: 'device',
      profile: 'profile',
    );
    expect(next.snapshot.entries, sample());
    next.close();
  });
}
