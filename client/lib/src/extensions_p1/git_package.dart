import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart'
    show Ed25519, Signature, SimplePublicKey, KeyPairType;

import 'github_objects.dart';
import 'github_transport.dart';
import 'git_manifest.dart';
import 'git_source.dart';
import 'local_lifecycle_types.dart';
import 'registry_validation.dart';
import 'strict_json.dart';

const gitPayloadFiles = ['manifest.json', 'client.wasm', 'LICENSE'];
const gitPackageFiles = [
  ...gitPayloadFiles,
  'index.json',
  'index.sig',
  'publisher.key',
];

class GitCandidate {
  GitCandidate._(this.package, this.manifest, List<int> bytes)
    : bytes = Uint8List.fromList(bytes).asUnmodifiableView();
  final LocalVerifiedPackage package;
  final GitManifest manifest;
  final Uint8List bytes;
  GitPackageSource get source => package.source!;
  String get publisher => source.json['publisher'] as String;
}

Future<void> verifyGitSignature(
  String domain,
  List<int> bytes,
  List<int> signature,
  List<int> key,
) async {
  if (key.length != 32 ||
      signature.length != 64 ||
      !await Ed25519().verify(
        [...utf8.encode('$domain\u0000'), ...bytes],
        signature: Signature(
          signature,
          publicKey: SimplePublicKey(key, type: KeyPairType.ed25519),
        ),
      )) {
    throw StateError('PackageSignature');
  }
}

class GitPackageLoader {
  GitPackageLoader(this.transport);
  final GitObjectTransport transport;

  Future<GitCandidate> load(
    String url,
    String ref,
    String path,
    void Function() guard,
  ) async {
    final repository = gitRepository(url);
    gitRef(ref);
    gitPath(path);
    guard();
    final git = GithubObjects(transport, repository);
    final selected = await git.tree(ref, path);
    guard();
    final origin = await _origin(
      await git.blob(selected.files, 'provenance.json'),
    );
    guard();
    final data = origin.data;
    if (data['repository'] != repository || data['path'] != path) {
      throw StateError('GitProvenance');
    }
    final source = await git.tree(data['commit'] as String, path);
    guard();
    final files = await _package(git, source.files, guard);
    final candidate = await _candidate(
      files,
      origin.key,
      GitPackageSource({
        'kind': 'git',
        'repository': repository,
        'ref': ref,
        'ref_commit': selected.commit,
        'commit': source.commit,
        'object_format': 'sha1',
        'path': path,
        'method': 'prebuilt-directory',
        'publisher': sha256.convert(origin.key).toString(),
        'plugin': gitManifest(files['manifest.json']!).plugin,
      }),
    );
    guard();
    if (candidate.package.digest != data['digest']) {
      throw StateError('GitProvenance');
    }
    return candidate;
  }

  Future<({Map<String, Object?> data, Uint8List key})> _origin(
    List<int> bytes,
  ) async {
    final envelope = registryObject(extensionJson(bytes));
    registryKeys(envelope, ['payload', 'signature', 'public_key']);
    final payload = base64Decode(envelope['payload'] as String);
    final key = base64Decode(envelope['public_key'] as String);
    await verifyGitSignature(
      'space.package.origin.p1',
      payload,
      base64Decode(envelope['signature'] as String),
      key,
    );
    final data = registryObject(extensionJson(payload));
    registryKeys(data, [
      'format',
      'repository',
      'commit',
      'path',
      'digest',
      'build_profile',
    ]);
    if (data['format'] != 'space.package.origin.p1' ||
        data['build_profile'] != 'prebuilt-client-p1') {
      throw StateError('GitProvenance');
    }
    gitObjectId(data['commit']);
    registryDigest(data['digest']);
    return (data: data, key: key);
  }

  Future<Map<String, Uint8List>> _package(
    GithubObjects git,
    Map<String, String> entries,
    void Function() guard,
  ) async {
    if (entries.length != gitPackageFiles.length ||
        !gitPackageFiles.every(entries.containsKey)) {
      throw StateError('PackageFiles');
    }
    final files = <String, Uint8List>{};
    for (final name in gitPackageFiles) {
      files[name] = await git.blob(entries, name);
      guard();
    }
    return files;
  }

  Future<GitCandidate> _candidate(
    Map<String, Uint8List> files,
    List<int> publisher,
    GitPackageSource source,
  ) async {
    final key = base64Decode(utf8.decode(files['publisher.key']!).trim());
    final signature = base64Decode(utf8.decode(files['index.sig']!).trim());
    if (base64Encode(key) != base64Encode(publisher)) {
      throw StateError('PackagePublisher');
    }
    final indexBytes = files['index.json']!;
    await verifyGitSignature(
      'space.package.index.p1',
      indexBytes,
      signature,
      key,
    );
    final index = registryObject(extensionJson(indexBytes));
    registryKeys(index, ['format', 'files']);
    if (index['format'] != 'space.package.index.p1') {
      throw StateError('PackageIndex');
    }
    final hashes = registryObject(index['files']);
    registryKeys(hashes, gitPayloadFiles);
    for (final name in gitPayloadFiles) {
      if (hashes[name] != sha256.convert(files[name]!).toString()) {
        throw StateError('PackageHash');
      }
    }
    final manifest = gitManifest(files['manifest.json']!);
    gitWasmShape(files['client.wasm']!);
    final bytes = utf8.encode(
      jsonEncode({
        'format': 'space.client.bundle.p1',
        'index': base64Encode(indexBytes),
        'signature': base64Encode(signature),
        'publisher': base64Encode(key),
        'files': {
          for (final name in gitPayloadFiles) name: base64Encode(files[name]!),
        },
      }),
    );
    return GitCandidate._(
      LocalVerifiedPackage(
        sha256.convert(bytes).toString(),
        manifest.schema,
        manifest.permissions,
        source: source,
      ),
      manifest,
      bytes,
    );
  }
}
