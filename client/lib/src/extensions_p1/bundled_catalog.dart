import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as paths;

import 'desktop_catalog.dart';
import 'installed_packages.dart';
import 'registry_validation.dart';

class BundledCatalog {
  BundledCatalog._(this.executable, this.digest);
  final String executable, digest;
  static bool get supported =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  static Future<BundledCatalog> resolve({String? application}) async {
    final directory = await Directory(
      paths.dirname(application ?? Platform.resolvedExecutable),
    ).resolveSymbolicLinks();
    final binary = paths.join(
      directory,
      Platform.isWindows ? 'space-catalog.exe' : 'space-catalog',
    );
    final checksum = Platform.isMacOS
        ? paths.join(
            paths.dirname(directory),
            'Resources',
            'space-catalog.sha256',
          )
        : '$binary.sha256';
    final digest = utf8.decode(await boundedFile(checksum, 128)).trim();
    registryDigest(digest);
    final result = BundledCatalog._(binary, digest);
    await result.verify();
    return result;
  }

  Future<void> verify() async {
    final bytes = await boundedFile(executable, 32 * 1024 * 1024);
    if (sha256.convert(bytes).toString() != digest) {
      throw StateError('Unavailable');
    }
  }

  DesktopCatalogPicker picker({Future<String?> Function()? choose}) =>
      DesktopCatalogPicker(executable, choose: choose, verify: verify);
}
