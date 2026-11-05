import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' show Ed25519;
import 'package:space_client/src/extensions_p1/github_transport.dart';
import 'package:space_client/src/extensions_p1/git_package.dart';
import 'package:space_client/src/secure_vault.dart';

const fixtureRepository = 'https://github.com/space-protocol-project/space-app';
const fixturePath = 'client/test/fixtures/git-extension';
const fixtureRef = 'refs/heads/main';

class GitMemoryKeys implements SecureKeyStorage {
  final values = <String, String>{};
  void Function(String key)? afterWrite;
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
    afterWrite?.call(key);
  }

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }
}

class FixtureGit implements GitObjectTransport {
  FixtureGit() {
    for (final name in [...gitPackageFiles, 'provenance.json']) {
      files[name] = File('test/fixtures/git-extension/$name').readAsBytesSync();
    }
  }
  final files = <String, Uint8List>{};
  final calls = <String>[];
  Future<void> Function(String)? before;
  String mode = '100644', type = 'blob';
  bool truncated = false, closed = false, corruptBlob = false;
  String repository = fixtureRepository;
  String get selectedCommit => 'b' * 40;
  Map<String, dynamic> get origin => jsonDecode(
    utf8.decode(
      base64Decode(
        (jsonDecode(utf8.decode(files['provenance.json']!)) as Map)['payload']
            as String,
      ),
    ),
  ) as Map<String, dynamic>;
  String get packageCommit => origin['commit'] as String;
  String object(List<int> bytes) => sha1.convert([
    ...utf8.encode('blob ${bytes.length}\u0000'),
    ...bytes,
  ]).toString();
  String treeId(String commit, int level) =>
      sha1.convert(utf8.encode('$commit/$level')).toString();

  @override
  Future<Map<String, dynamic>> get(String path) async {
    calls.add(path);
    await before?.call(path);
    final prefix = '/repos${Uri.parse(repository).path}';
    if (path.startsWith('$prefix/commits/')) {
      final ref = Uri.decodeComponent(
        path.substring('$prefix/commits/'.length),
      );
      final commit = ref == packageCommit ? packageCommit : selectedCommit;
      return {
        'sha': commit,
        'commit': {
          'tree': {'sha': treeId(commit, 0)},
        },
      };
    }
    if (path.startsWith('$prefix/git/trees/')) {
      return _tree(path.split('/').last);
    }
    final id = path.split('/').last;
    final bytes = files.values.firstWhere((bytes) => object(bytes) == id);
    return {
      'sha': id,
      'size': bytes.length,
      'encoding': 'base64',
      'content': base64Encode(corruptBlob ? [0] : bytes),
    };
  }

  Map<String, dynamic> _tree(String id) {
    final segments = fixturePath.split('/');
    for (final commit in [selectedCommit, packageCommit]) {
      for (var level = 0; level <= segments.length; level++) {
        if (id != treeId(commit, level)) continue;
        final entries = level < segments.length
            ? [
                {
                  'path': segments[level],
                  'type': 'tree',
                  'mode': '040000',
                  'sha': treeId(commit, level + 1),
                },
              ]
            : [
                for (final e in files.entries)
                  if (commit == selectedCommit || e.key != 'provenance.json')
                    {
                      'path': e.key,
                      'type': type,
                      'mode': mode,
                      'sha': object(e.value),
                      'size': e.value.length,
                    },
              ];
        return {'sha': id, 'truncated': truncated, 'tree': entries};
      }
    }
    throw StateError('missing tree');
  }

  Future<void> sign({
    String seedText = 'Space P1 public CI fixture publisher, never trust',
    Map<String, Object?>? originChanges,
  }) async {
    final algorithm = Ed25519();
    final key = await algorithm.newKeyPairFromSeed(
      sha256.convert(utf8.encode(seedText)).bytes,
    );
    final public = (await key.extractPublicKey()).bytes;
    Future<List<int>> signBytes(String domain, List<int> bytes) async =>
        (await algorithm.sign([
          ...utf8.encode('$domain\u0000'),
          ...bytes,
        ], keyPair: key)).bytes;
    final index = utf8.encode(
      jsonEncode({
        'format': 'space.package.index.p1',
        'files': {
          for (final name in gitPayloadFiles)
            name: sha256.convert(files[name]!).toString(),
        },
      }),
    );
    final signature = await signBytes('space.package.index.p1', index);
    files['index.json'] = Uint8List.fromList(index);
    files['index.sig'] = Uint8List.fromList(
      utf8.encode(base64Encode(signature)),
    );
    files['publisher.key'] = Uint8List.fromList(
      utf8.encode(base64Encode(public)),
    );
    final bundle = utf8.encode(
      jsonEncode({
        'format': 'space.client.bundle.p1',
        'index': base64Encode(index),
        'signature': base64Encode(signature),
        'publisher': base64Encode(public),
        'files': {
          for (final name in gitPayloadFiles) name: base64Encode(files[name]!),
        },
      }),
    );
    final value = origin..['digest'] = sha256.convert(bundle).toString();
    value.addAll(originChanges ?? {});
    final payload = utf8.encode(jsonEncode(value));
    files['provenance.json'] = Uint8List.fromList(
      utf8.encode(
        jsonEncode({
          'payload': base64Encode(payload),
          'signature': base64Encode(
            await signBytes('space.package.origin.p1', payload),
          ),
          'public_key': base64Encode(public),
        }),
      ),
    );
  }

  @override
  void close() {
    closed = true;
  }
}
