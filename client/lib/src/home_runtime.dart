import 'local_failure.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/services.dart';

class HomeRelease {
  HomeRelease(
    this.version,
    this.platform,
    this.url,
    this.sha256,
    this.bytes, {
    this.unpackedBytes = 2 * 1024 * 1024 * 1024,
    this.releaseNotes = '',
  });
  final String version, platform, sha256;
  final Uri url;
  final int bytes;
  final int unpackedBytes;
  final String releaseNotes;

  bool isNewerThan(HomeRelease other) => isNewerVersion(version, other.version);

  static bool isNewerVersion(String version, String previousVersion) {
    final left = version
        .substring(1)
        .split('-')
        .first
        .split('.')
        .map(int.parse)
        .toList();
    final right = previousVersion
        .substring(1)
        .split('-')
        .first
        .split('.')
        .map(int.parse)
        .toList();
    for (var i = 0; i < 3; i++) {
      if (left[i] != right[i]) return left[i] > right[i];
    }
    final a = version.indexOf('-'), b = previousVersion.indexOf('-');
    if (a < 0) return b >= 0;
    if (b < 0) return false;
    final pre = version.substring(a + 1).split('.'),
        old = previousVersion.substring(b + 1).split('.');
    return _comparePrerelease(pre, old) > 0;
  }

  static int _comparePrerelease(List<String> left, List<String> right) {
    for (var i = 0; i < left.length && i < right.length; i++) {
      final comparison = _compareIdentifier(left[i], right[i]);
      if (comparison != 0) return comparison;
    }
    return left.length.compareTo(right.length);
  }

  static int _compareIdentifier(String left, String right) {
    if (left == right) return 0;
    final number = int.tryParse(left), previous = int.tryParse(right);
    if (number != null && previous != null) return number.compareTo(previous);
    if (number != null) return -1;
    if (previous != null) return 1;
    return left.compareTo(right);
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'platform': platform,
    'url': url.toString(),
    'sha256': sha256,
    'bytes': bytes,
    'unpackedBytes': unpackedBytes,
    'releaseNotes': releaseNotes,
  };

  factory HomeRelease.fromJson(Map<String, dynamic> data) {
    final release = HomeRelease(
      data['version'] as String,
      data['platform'] as String,
      Uri.parse(data['url'] as String),
      data['sha256'] as String,
      data['bytes'] as int,
      unpackedBytes: data['unpackedBytes'] as int? ?? 2 * 1024 * 1024 * 1024,
      releaseNotes: data['releaseNotes'] as String? ?? '',
    );
    if (!RegExp(r'^v[0-9]+\.[0-9]+\.[0-9]+(?:-[A-Za-z0-9.-]+)?$')
            .hasMatch(release.version) ||
        !RegExp(r'^(windows|macos|linux)-(x64|arm64)$')
            .hasMatch(release.platform) ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(release.sha256) ||
        release.bytes < 1 ||
        release.bytes > 512 * 1024 * 1024 ||
        release.unpackedBytes < 1 ||
        release.unpackedBytes > 2 * 1024 * 1024 * 1024 ||
        utf8.encode(release.releaseNotes).length > 8192 ||
        release.url.toString() !=
            'https://github.com/space-protocol-project/space-server/releases/download/${release.version}/Space-home-${release.platform}.zip') {
      throw const LocalFailure(
        LocalFailureCode.releaseInvalid,
        'Недопустимый выпуск домашнего сервера',
      );
    }
    return release;
  }
}

Future<HomeRelease> bundledHomeRelease() async {
  final platform = Platform.isWindows
      ? 'windows'
      : Platform.isMacOS
      ? 'macos'
      : Platform.isLinux
      ? 'linux'
      : '';
  // Архитектура относится к процессу приложения, а не к имени компьютера.
  final architecture = Abi.current().toString().toLowerCase().contains('arm64')
      ? 'arm64'
      : 'x64';
  final data = jsonDecode(
    await rootBundle.loadString('assets/home/runtime-manifest.json'),
  ) as Map<String, dynamic>;
  final entry = data['$platform-$architecture'];
  if (entry is! Map) {
    throw const LocalFailure(
      LocalFailureCode.platformUnsupported,
      'Для этой платформы ещё нет проверенного выпуска сервера',
    );
  }
  return HomeRelease.fromJson(Map<String, dynamic>.from(entry));
}

Future<List<HomeRelease>> legacyHomeReleases() async {
  final entries = jsonDecode(
    await rootBundle.loadString('assets/home/legacy-runtime-manifest.json'),
  ) as Map<String, dynamic>;
  return entries.values
      .map(
        (value) =>
            HomeRelease.fromJson(Map<String, dynamic>.from(value as Map)),
      )
      .toList();
}

Future<void> downloadHomeRelease(
  HomeRelease release,
  File output,
  void Function(double) progress,
) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
  IOSink? sink;
  try {
    var url = release.url;
    HttpClientResponse? response;
    for (var redirects = 0; redirects < 5; redirects++) {
      if (url.scheme != 'https' ||
          ![
            'github.com',
            'release-assets.githubusercontent.com',
            'objects.githubusercontent.com',
          ].contains(url.host)) {
        throw const LocalFailure(
          LocalFailureCode.downloadAddress,
          'Недопустимый адрес загрузки выпуска',
        );
      }
      final request = await client.getUrl(url);
      request.followRedirects = false;
      response = await request.close().timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) break;
      if (![301, 302, 303, 307, 308].contains(response.statusCode) ||
          response.headers.value('location') == null) {
        throw const LocalFailure(
          LocalFailureCode.downloadFailed,
          'Не удалось скачать выпуск сервера',
        );
      }
      url = url.resolve(response.headers.value('location')!);
      await response.drain<void>();
    }
    if (response == null || response.statusCode != 200) {
      throw const LocalFailure(
        LocalFailureCode.redirectLimit,
        'Слишком много перенаправлений',
      );
    }
    sink = output.openWrite();
    var received = 0;
    await for (final chunk in response.timeout(const Duration(seconds: 30))) {
      received += chunk.length;
      if (received > release.bytes) {
        throw const LocalFailure(
          LocalFailureCode.releaseSize,
          'Размер выпуска не совпадает',
        );
      }
      sink.add(chunk);
      progress(received / release.bytes);
    }
    await sink.close();
    sink = null;
    if (received != release.bytes) {
      throw const LocalFailure(
        LocalFailureCode.releaseSize,
        'Неполная загрузка сервера',
      );
    }
  } finally {
    await sink?.close();
    client.close(force: true);
  }
}

// Проверка выполняется до записи любого файла из архива.
Future<void> extractHomeRelease(
  File archiveFile,
  Directory destination,
  String expectedHash, {
  int maximumBytes = 2 * 1024 * 1024 * 1024,
}) async {
  final hash = await crypto.sha256.bind(archiveFile.openRead()).first;
  if (hash.toString() != expectedHash) {
    throw const LocalFailure(
      LocalFailureCode.hashMismatch,
      'SHA-256 выпуска не совпадает; запуск запрещён',
    );
  }
  await Isolate.run(
    () => extractVerifiedHomeArchive(
      archiveFile.path,
      destination.path,
      maximumBytes: maximumBytes,
    ),
  );
}

void extractVerifiedHomeArchive(
  String archivePath,
  String destination, {
  int maximumBytes = 2 * 1024 * 1024 * 1024,
}) {
  final input = InputFileStream(archivePath);
  try {
    final archive = ZipDecoder().decodeStream(input);
    if (archive.length > 50000) {
      throw const LocalFailure(
        LocalFailureCode.archiveInvalid,
        'Слишком много файлов в выпуске',
      );
    }
    _verifyArchiveEntries(archive, maximumBytes);
    for (final entry in archive) {
      final path = '$destination/${entry.name}';
      if (!entry.isFile) {
        Directory(path).createSync(recursive: true);
        continue;
      }
      File(path).parent.createSync(recursive: true);
      final output = OutputFileStream(path);
      try {
        entry.writeContent(output);
      } finally {
        output.closeSync();
      }
      if (!Platform.isWindows && (entry.mode & 0x49) != 0) {
        final result = Process.runSync('/bin/chmod', ['755', path]);
        if (result.exitCode != 0) {
          throw const LocalFailure(
            LocalFailureCode.executePermission,
            'Не удалось выдать право запуска',
          );
        }
      }
    }
  } finally {
    input.closeSync();
  }
}

void _verifyArchiveEntries(Archive archive, int maximumBytes) {
  var total = 0;
  for (final entry in archive) {
    final parts = entry.name.replaceAll('\\', '/').split('/');
    total += entry.size;
    if (entry.isSymbolicLink ||
        parts.any(
          (part) =>
              part == '..' ||
              part == '.' ||
              part.contains(':') ||
              part.trim() != part ||
              part.endsWith('.'),
        ) ||
        entry.name.startsWith('/') ||
        entry.name.startsWith('\\') ||
        total > maximumBytes ||
        total > 2 * 1024 * 1024 * 1024) {
      throw const LocalFailure(
        LocalFailureCode.archiveInvalid,
        'Недопустимый путь или размер в выпуске',
      );
    }
  }
}
