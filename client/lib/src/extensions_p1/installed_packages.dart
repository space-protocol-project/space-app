import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as paths;

import '../secure_vault.dart';
import 'local_lifecycle_types.dart';
import 'registry_validation.dart';
import 'git_source.dart';
import 'git_manifest.dart';

Future<Uint8List> boundedFile(String path, int limit) async {
  if (await FileSystemEntity.type(path, followLinks: false) !=
      FileSystemEntityType.file) {
    throw StateError('Unavailable');
  }
  final file = await File(path).open();
  try {
    final bytes = await file.read(limit + 1);
    if (bytes.length > limit) throw StateError('ResourceLimit');
    return bytes;
  } finally {
    await file.close();
  }
}

class InstalledPackages {
  InstalledPackages(this.directory, this.scope, this.storage);
  final String directory, scope;
  final SecureKeyStorage storage;
  static const byteLimit = 16 * 1024 * 1024;

  String _key(String digest) =>
      'space.extensions.accepted.${sha256.convert(utf8.encode(jsonEncode([scope, digest])))}';
  String _path(String digest) => paths.join(directory, '$digest.package');

  // Вызывает только доверенный установщик после проверки источника и согласия.
  // Наличие файла само по себе никогда не означает принятие пакета.
  Future<void> admit(
    LocalVerifiedPackage package,
    List<int> bytes,
    void Function() guard,
  ) async {
    guard();
    if (bytes.length > byteLimit ||
        sha256.convert(bytes).toString() != package.digest) {
      throw StateError('UntrustedPackage');
    }
    final owned = Uint8List.fromList(bytes);
    final receipt = jsonEncode({
      'v': 1,
      'scope': scope,
      'digest': package.digest,
      'schema': package.schema,
      'requested': package.requested,
      if (package.source case final source?) 'source': source.json,
    });
    final previous = await storage.read(key: _key(package.digest));
    guard();
    if (previous != null && previous != receipt) {
      throw StateError('UntrustedPackage');
    }
    await Directory(directory).create(recursive: true);
    guard();
    final pending = File('${_path(package.digest)}.pending');
    await pending.writeAsBytes(owned, flush: true);
    guard();
    await pending.rename(_path(package.digest));
    guard();
    await storage.write(key: _key(package.digest), value: receipt);
    guard();
    if (await storage.read(key: _key(package.digest)) != receipt) {
      throw StateError('Unavailable');
    }
    guard();
  }

  Future<LocalVerifiedPackage> verify(String digest) async {
    registryDigest(digest);
    final raw = await storage.read(key: _key(digest));
    if (raw == null || raw.length > 8192) throw StateError('UntrustedPackage');
    final data = registryObject(jsonDecode(raw));
    registryKeys(data, [
      'v',
      'scope',
      'digest',
      'schema',
      'requested',
      if (data.containsKey('source')) 'source',
    ]);
    if (data['v'] != 1 || data['scope'] != scope || data['digest'] != digest) {
      throw StateError('UntrustedPackage');
    }
    final package = LocalVerifiedPackage(
      digest,
      data['schema'] as int,
      (data['requested'] as List).cast<String>(),
      source: data.containsKey('source')
          ? GitPackageSource(registryObject(data['source']))
          : null,
    );
    final bytes = await boundedFile(_path(digest), byteLimit);
    if (sha256.convert(bytes).toString() != digest) {
      throw StateError('UntrustedPackage');
    }
    return package;
  }

  Future<Uint8List> clientModule(String digest) async {
    final accepted = await verify(digest);
    final bytes = await boundedFile(_path(digest), byteLimit);
    if (sha256.convert(bytes).toString() != digest) {
      throw StateError('UntrustedPackage');
    }
    final bundle = registryObject(jsonDecode(utf8.decode(bytes)));
    registryKeys(bundle, [
      'format',
      'index',
      'signature',
      'publisher',
      'files',
    ]);
    if (bundle['format'] != 'space.client.bundle.p1') {
      throw StateError('ClientAbi');
    }
    final files = registryObject(bundle['files']);
    registryKeys(files, ['manifest.json', 'client.wasm', 'LICENSE']);
    final manifest = gitManifest(
      base64Decode(files['manifest.json'] as String),
    );
    if (manifest.schema != accepted.schema ||
        jsonEncode(manifest.permissions) != jsonEncode(accepted.requested)) {
      throw StateError('UntrustedPackage');
    }
    final module = base64Decode(files['client.wasm'] as String);
    if (module.length > 65536) throw StateError('ResourceLimit');
    gitWasmShape(module);
    return module;
  }
}

class InstalledPackageAuthority
    implements LocalExtensionAuthority, CatalogConsentProvider {
  InstalledPackageAuthority(this.packages, {this.consent});
  final InstalledPackages packages;
  final ({String instance, String package, String root})? consent;

  @override
  LocalExtensionAuthority catalogConsent(
    String instance,
    String package,
    String root,
  ) => InstalledPackageAuthority(
    packages,
    consent: (instance: instance, package: package, root: root),
  );
  @override
  Future<LocalVerifiedPackage> verifyPackage(String digest) =>
      packages.verify(digest);
  @override
  Future<bool> confirm(
    String action,
    String instance,
    String package, {
    String? root,
  }) async {
    final approved = consent;
    if (approved == null ||
        approved.instance != instance ||
        approved.package != package) {
      return false;
    }
    return switch (action) {
      'enable' => root == null,
      'grant' => root == approved.root,
      _ => false,
    };
  }

  @override
  Future<String> selectDirectory(String instance, String package) async =>
      throw StateError('PermissionDenied');
  @override
  Future<void> verifyCheckpoint(String digest, String data) async =>
      throw UnsupportedError('checkpoint');
  @override
  Future<String> migrate(
    Map<String, Object?> plan,
    int step,
    String data,
  ) async => throw UnsupportedError('migration');
  @override
  Future<LocalRestoreSnapshot> restore(String checkpoint) async =>
      throw UnsupportedError('restore');
}
