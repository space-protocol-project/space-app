import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'local_registry_codec.dart';
import 'local_registry_journal.dart';

class LocalExtensionRegistry {
  LocalExtensionRegistry._(this._journal, this._snapshot, this._scope);

  final RegistryJournal _journal;
  final String _scope;
  RegistrySnapshot _snapshot;
  bool _closed = false;
  bool _failed = false;

  static LocalExtensionRegistry open(
    String path, {
    required String device,
    required String profile,
  }) {
    validateRegistryName(device);
    validateRegistryName(profile);
    final scope = '$device/$profile';
    final journal = RegistryJournal.open(path);
    try {
      final previous = journal.read(scope);
      final registry = LocalExtensionRegistry._(journal, previous, scope);
      registry._recover();
      return registry;
    } catch (_) {
      journal.close();
      rethrow;
    }
  }

  RegistrySnapshot get snapshot {
    _checkOpen();
    return RegistrySnapshot.decode(_snapshot.encode(), _scope);
  }

  void _recover() {
    final entries = copyRegistryEntries(_snapshot.entries);
    for (final entry in entries.values) {
      if (entry['state'] == 'enabled') entry['state'] = 'disabled';
    }
    _write(entries, 'reopen', generation: _newGeneration());
  }

  void commit({
    required int expectedRevision,
    required String generation,
    required Map<String, Map<String, Object?>> entries,
    required String action,
    void Function(String phase)? checkpoint,
  }) {
    _checkOpen();
    if (generation != _snapshot.generation ||
        expectedRevision != _snapshot.revision) {
      throw StateError('registry_conflict');
    }
    validateRegistryName(action);
    final owned = copyRegistryEntries(entries);
    validateRegistryEntries(owned);
    _write(owned, action, checkpoint: checkpoint);
  }

  void _write(
    Map<String, Map<String, Object?>> entries,
    String action, {
    String? generation,
    void Function(String phase)? checkpoint,
  }) {
    if (_snapshot.revision >= 2147483646) {
      throw StateError('registry_revision_limit');
    }
    final next = RegistrySnapshot(
      scope: _scope,
      revision: _snapshot.revision + 1,
      generation: generation ?? _snapshot.generation,
      entries: entries,
      action: action,
      previous: sha256.convert(utf8.encode(_snapshot.encode())).toString(),
    );
    try {
      _journal.append(next, checkpoint);
      _snapshot = next;
    } catch (_) {
      _failed = true;
      rethrow;
    }
  }

  void _checkOpen() {
    if (_closed || _failed) throw StateError('registry_unavailable');
  }

  void close() {
    if (_closed) return;
    _closed = true;
    _journal.close();
  }
}

String _newGeneration() {
  final random = Random.secure();
  return List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
