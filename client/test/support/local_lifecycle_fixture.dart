import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_record.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_sessions.dart';

class FixtureAuthority implements LocalExtensionAuthority {
  bool consent = true;
  bool trusted = true;
  bool migrationOk = true;
  bool checkpointOk = true;
  Completer<void>? barrier;
  LocalRestoreSnapshot? saved;
  String root = '1' * 32;
  List<String> requested = ['device.catalog.read'];

  @override
  Future<LocalVerifiedPackage> verifyPackage(String digest) async {
    await barrier?.future;
    if (!trusted) throw StateError('UntrustedPackage');
    final schema = {'a': 1, 'b': 2, 'c': 1}[digest[0]]!;
    return LocalVerifiedPackage(digest, schema, requested);
  }

  @override
  Future<void> verifyCheckpoint(String digest, String data) async {
    if (!checkpointOk) throw StateError('InvalidCheckpoint');
  }

  @override
  Future<bool> confirm(String action, String instance, String package) async =>
      consent;
  @override
  Future<String> selectDirectory(String instance, String package) async => root;
  @override
  Future<String> migrate(
    Map<String, Object?> plan,
    int step,
    String data,
  ) async {
    if (!migrationOk) throw StateError('MigrationFailed');
    return jsonEncode({'step': step + 1});
  }

  @override
  Future<LocalRestoreSnapshot> restore(String checkpoint) async => saved!;
}

class LifecycleFixture {
  LifecycleFixture(this.path) {
    session = sessions.unlock('device', 'profile', 'owner');
    open();
  }
  final String path;
  final sessions = LocalExtensionSessions();
  final authority = FixtureAuthority();
  late LocalExtensionSession session;
  late LocalLifecycleHost host;
  void open() {
    host = LocalLifecycleHost.open(
      path,
      device: 'device',
      profile: 'profile',
      sessions: sessions,
      authority: authority,
    );
  }

  Map<String, Object?> get entry => host.snapshot(session).entries['games']!;
  Map<String, Object?> get record => lifecycleOf(entry);
  LocalLifecycleCommand command(
    LocalLifecycleAction action, {
    Map<String, Object?>? plan,
    String? root,
  }) {
    final snapshot = host.snapshot(session);
    final current = snapshot.entries['games'];
    final metadata = current == null ? null : lifecycleOf(current);
    return LocalLifecycleCommand(
      action: action,
      installation: 'games',
      instance: 'games',
      revision: metadata?['revision'] as int? ?? 0,
      generation: metadata?['generation'] as String? ?? snapshot.generation,
      package: action == LocalLifecycleAction.install ? 'a' * 64 : null,
      plan: plan,
      root: root,
      checkpoint: action == LocalLifecycleAction.restore ? 'e' * 64 : null,
    );
  }

  Future<void> act(
    LocalLifecycleAction action, {
    Map<String, Object?>? plan,
    String? root,
    void Function(String)? checkpoint,
  }) => host.execute(
    session,
    command(action, plan: plan, root: root),
    checkpoint: checkpoint,
  );
  Map<String, Object?> plan({bool codeOnly = false}) => {
    'plan_id': '2' * 32,
    'source': entry['package'],
    'target': (codeOnly ? 'c' : 'b') * 64,
    'schema_from': entry['schema'],
    'schema_to': codeOnly ? 1 : 2,
    'data_revision': record['data_revision'],
    'checkpoint': sha256
        .convert(utf8.encode(entry['data']! as String))
        .toString(),
    'steps': codeOnly ? 0 : 1,
  };
  void reopen() {
    host.close();
    open();
  }
}
