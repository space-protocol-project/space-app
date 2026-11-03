import 'dart:convert';

import 'local_lifecycle_record.dart';
import 'local_lifecycle_transition.dart';
import 'local_lifecycle_types.dart';
import 'local_registry.dart';
import 'local_registry_codec.dart';
import 'local_sessions.dart';

part 'local_lifecycle_access.dart';

class LocalLifecycleHost {
  LocalLifecycleHost._(this._registry, this._sessions, this._authority) {
    _sessions.addListener(_locked);
  }

  static LocalLifecycleHost open(
    String path, {
    required String device,
    required String profile,
    required LocalExtensionSessions sessions,
    required LocalExtensionAuthority authority,
  }) => LocalLifecycleHost._(
    LocalExtensionRegistry.open(path, device: device, profile: profile),
    sessions,
    authority,
  );

  final LocalExtensionRegistry _registry;
  final LocalExtensionSessions _sessions;
  final LocalExtensionAuthority _authority;
  final _calls = <LocalReadLease>{};
  bool _failed = false;
  bool _closed = false;

  RegistrySnapshot snapshot(LocalExtensionSession session) {
    final current = _registry.snapshot;
    _require(session, current.scope);
    return current;
  }

  void _require(LocalExtensionSession session, String scope) {
    if (_failed || _closed) throw StateError('registry_unavailable');
    _sessions.require(session, scope);
  }

  Future<void> execute(
    LocalExtensionSession session,
    LocalLifecycleCommand input, {
    void Function(String phase)? checkpoint,
  }) async {
    final before = snapshot(session);
    final command = _freeze(input);
    final entry = before.entries[command.instance];
    _guard(command, entry, before.generation);
    _requireIdle(command);
    final next = await _prepare(session, command, entry, before.scope);
    // Согласие, проверка пакета и миграция могут пережить блокировку профиля.
    _require(session, before.scope);
    _requireIdle(command);
    before.entries[command.instance] = next;
    _commit(before, command.action.name, checkpoint);
    _cancel(command.instance);
  }

  void _commit(
    RegistrySnapshot before,
    String action,
    void Function(String)? checkpoint,
  ) {
    // Ошибки валидации/CAS не закрывают хост. Ошибка записи закрывает допуск.
    validateRegistryEntries(before.entries);
    final current = _registry.snapshot;
    if (current.revision != before.revision ||
        current.generation != before.generation) {
      throw StateError('Conflict');
    }
    try {
      _registry.commit(
        expectedRevision: before.revision,
        generation: before.generation,
        entries: before.entries,
        action: action,
        checkpoint: checkpoint,
      );
    } catch (_) {
      _failed = true;
      _cancel(null);
      rethrow;
    }
  }

  LocalLifecycleCommand _freeze(LocalLifecycleCommand command) {
    validateRegistryName(command.instance);
    validateRegistryName(command.installation);
    lifecycleToken(command.generation);
    lifecycleInteger(command.revision);
    _checkArguments(command);
    return LocalLifecycleCommand(
      action: command.action,
      installation: command.installation,
      instance: command.instance,
      revision: command.revision,
      generation: command.generation,
      package: command.package,
      checkpoint: command.checkpoint,
      root: command.root,
      plan: command.plan == null
          ? null
          : registryObject(jsonDecode(jsonEncode(command.plan))),
    );
  }

  void _checkArguments(LocalLifecycleCommand command) {
    if (command.package != null &&
            command.action != LocalLifecycleAction.install ||
        command.plan != null &&
            command.action != LocalLifecycleAction.prepare ||
        command.checkpoint != null &&
            command.action != LocalLifecycleAction.restore ||
        command.root != null && command.action != LocalLifecycleAction.revoke) {
      throw const FormatException('unexpected_arguments');
    }
  }

  void _guard(
    LocalLifecycleCommand command,
    Map<String, Object?>? entry,
    String generation,
  ) {
    if (command.action == LocalLifecycleAction.install) {
      if (entry != null ||
          command.revision != 0 ||
          command.generation != generation) {
        throw StateError('Conflict');
      }
      return;
    }
    if (entry == null || entry['installation'] != command.installation) {
      {
        throw StateError('StaleBinding');
      }
    }
    final record = lifecycleOf(entry);
    if (command.generation != record['generation']) {
      throw StateError('StaleBinding');
    }
    if (command.revision != record['revision']) throw StateError('Conflict');
    final allowed = localTransitionStates[command.action];
    if (allowed != null && !allowed.contains(entry['state'])) {
      {
        throw StateError('FailedPrecondition');
      }
    }
  }

  Future<Map<String, Object?>> _prepare(
    LocalExtensionSession session,
    LocalLifecycleCommand command,
    Map<String, Object?>? previous,
    String scope,
  ) async {
    if (command.action == LocalLifecycleAction.install) {
      return _install(session, command);
    }
    var entry = previous!;
    if (command.action == LocalLifecycleAction.restore) {
      entry = await _restore(command, entry, scope);
    }
    final root = await _permission(command, entry);
    await LocalLifecycleTransition(_authority, command, entry).apply();
    advanceLifecycleRecord(entry, command.action.name, session.actor);
    if (root != null) {
      final grants = registryObject(lifecycleOf(entry)['grants']);
      final previousGrant = grants[root];
      final revision = previousGrant == null
          ? 1
          : registryObject(previousGrant)['revision'];
      grants[root] = {'revision': revision, 'active': true};
    }
    return entry;
  }

  Future<Map<String, Object?>> _install(
    LocalExtensionSession session,
    LocalLifecycleCommand command,
  ) async {
    registryDigest(command.package);
    final package = await _authority.verifyPackage(command.package!);
    if (package.digest != command.package) throw StateError('UntrustedPackage');
    return {
      'installation': command.installation,
      'package': package.digest,
      'schema': package.schema,
      'state': 'disabled',
      'data': '{}',
      'staged': null,
      'lifecycle': newLifecycleRecord(package.requested, session.actor),
    };
  }

  Future<String?> _permission(
    LocalLifecycleCommand command,
    Map<String, Object?> entry,
  ) async {
    final record = lifecycleOf(entry);
    if (command.action == LocalLifecycleAction.revoke) {
      lifecycleToken(command.root);
      if (!registryObject(record['grants']).containsKey(command.root)) {
        {
          throw StateError('StaleBinding');
        }
      }
    }
    if (command.action != LocalLifecycleAction.grant) return null;
    if (!(record['requested']! as List).contains('device.catalog.read')) {
      {
        throw StateError('PermissionDenied');
      }
    }
    final digest = entry['package']! as String;
    final root = await _authority.selectDirectory(command.instance, digest);
    lifecycleToken(root);
    if (!await _authority.confirm('grant', command.instance, digest)) {
      {
        throw StateError('PermissionDenied');
      }
    }
    return root;
  }

  Future<Map<String, Object?>> _restore(
    LocalLifecycleCommand command,
    Map<String, Object?> previous,
    String scope,
  ) async {
    registryDigest(command.checkpoint);
    final restored = await _authority.restore(command.checkpoint!);
    final entry = registryObject(jsonDecode(jsonEncode(restored.entry)));
    validateRegistryEntries({command.instance: entry});
    if (restored.scope != scope ||
        restored.instance != command.instance ||
        entry['installation'] != command.installation) {
      throw StateError('StaleBinding');
    }
    if (previous['state'] == 'removed' && entry['state'] != 'removed') {
      {
        throw StateError('FailedPrecondition');
      }
    }
    final transition = LocalLifecycleTransition(_authority, command, entry);
    final package = await transition.verified(
      entry['package']! as String,
      entry['schema']! as int,
    );
    if (jsonEncode(package.requested) !=
        jsonEncode(lifecycleOf(entry)['requested'])) {
      throw StateError('UntrustedPackage');
    }
    await transition.consent(package.digest);
    final old = lifecycleOf(previous);
    final record = lifecycleOf(entry);
    for (final key in ['revision', 'epoch', 'audit']) {
      record[key] = old[key];
    }
    record['history'] = {
      ...old['history']! as List,
      ...record['history']! as List,
    }.toList();
    if (['enabled', 'draining'].contains(entry['state'])) {
      entry['state'] = 'disabled';
    }
    return entry;
  }

  void _locked() {
    _cancel(null);
    if (_closed || _failed) return;
    try {
      final before = _registry.snapshot;
      for (final entry in before.entries.values) {
        if (!entry.containsKey('lifecycle')) continue;
        advanceLifecycleRecord(entry, 'lock', 'kernel');
        if (['enabled', 'draining'].contains(entry['state'])) {
          entry['state'] = 'disabled';
        }
      }
      _commit(before, 'lock', null);
    } catch (_) {
      _failed = true;
    }
  }

  void close() {
    if (_closed) return;
    _closed = true;
    _sessions.removeListener(_locked);
    _cancel(null);
    _registry.close();
  }
}
