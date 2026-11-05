import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../secure_vault.dart';
import 'git_package.dart';
import 'registry_validation.dart';
import 'strict_json.dart';

class GitTrust {
  GitTrust(this.storage, this.scope);
  final SecureKeyStorage storage;
  final String scope;
  String _key(GitCandidate candidate) =>
      'space.git.trust.${sha256.convert(utf8.encode(jsonEncode([scope, candidate.source.json['repository'], candidate.manifest.plugin])))}';

  String _record(GitCandidate candidate) => jsonEncode({
    'v': 1,
    'scope': scope,
    'repository': candidate.source.json['repository'],
    'plugin': candidate.manifest.plugin,
    'publisher': candidate.publisher,
  });

  Future<bool> inspect(GitCandidate candidate, void Function() guard) async {
    guard();
    final raw = await storage.read(key: _key(candidate));
    guard();
    if (raw == null) return false;
    final record = registryObject(extensionJson(utf8.encode(raw)));
    registryKeys(record, ['v', 'scope', 'repository', 'plugin', 'publisher']);
    if (raw != _record(candidate)) throw StateError('PublisherChanged');
    return true;
  }

  Future<void> accept(
    GitCandidate candidate,
    bool known,
    void Function() guard,
  ) async {
    if (await inspect(candidate, guard) != known) {
      throw StateError('TrustChanged');
    }
    if (known) return;
    guard();
    await storage.write(key: _key(candidate), value: _record(candidate));
    guard();
    if (!await inspect(candidate, guard)) throw StateError('TrustUnavailable');
  }
}
