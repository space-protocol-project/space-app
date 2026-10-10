import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/services.dart';

class HomeRelease {
  HomeRelease(this.version, this.platform, this.url, this.sha256, this.bytes);
  final String version, platform, sha256;
  final Uri url;
  final int bytes;

  factory HomeRelease.fromJson(Map<String, dynamic> data) {
    final release = HomeRelease(
      data['version'] as String,
      data['platform'] as String,
      Uri.parse(data['url'] as String),
      data['sha256'] as String,
      data['bytes'] as int,
    );
    if (!RegExp(r'^home-v[0-9.]+$').hasMatch(release.version) ||
        !RegExp(r'^(windows|macos|linux)-(x64|arm64)$')
            .hasMatch(release.platform) ||
        !RegExp(r'^[0-9a-f]{64}$').hasMatch(release.sha256) ||
        release.bytes < 1 ||
        release.bytes > 512 * 1024 * 1024 ||
        release.url.toString() !=
            'https://github.com/space-protocol-project/space-protocol/releases/download/${release.version}/Space-home-${release.platform}.zip') {
      throw const FormatException('Недопустимый выпуск домашнего сервера');
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
    throw const FormatException(
      'Для этой платформы ещё нет проверенного выпуска сервера',
    );
  }
  return HomeRelease.fromJson(Map<String, dynamic>.from(entry));
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
        throw const FormatException('Недопустимый адрес загрузки выпуска');
      }
      final request = await client.getUrl(url);
      request.followRedirects = false;
      response = await request.close().timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) break;
      if (![301, 302, 303, 307, 308].contains(response.statusCode) ||
          response.headers.value('location') == null) {
        throw const FormatException('Не удалось скачать выпуск сервера');
      }
      url = url.resolve(response.headers.value('location')!);
      await response.drain<void>();
    }
    if (response == null || response.statusCode != 200) {
      throw const FormatException('Слишком много перенаправлений');
    }
    sink = output.openWrite();
    var received = 0;
    await for (final chunk in response.timeout(const Duration(seconds: 30))) {
      received += chunk.length;
      if (received > release.bytes) {
        throw const FormatException('Размер выпуска не совпадает');
      }
      sink.add(chunk);
      progress(received / release.bytes);
    }
    await sink.close();
    sink = null;
    if (received != release.bytes) {
      throw const FormatException('Неполная загрузка сервера');
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
  String expectedHash,
) async {
  final hash = await crypto.sha256.bind(archiveFile.openRead()).first;
  if (hash.toString() != expectedHash) {
    throw const FormatException(
      'SHA-256 выпуска не совпадает; запуск запрещён',
    );
  }
  await Isolate.run(
    () => extractVerifiedHomeArchive(archiveFile.path, destination.path),
  );
}

void extractVerifiedHomeArchive(String archivePath, String destination) {
  final input = InputFileStream(archivePath);
  try {
    final archive = ZipDecoder().decodeStream(input);
    var total = 0;
    if (archive.length > 50000) {
      throw const FormatException('Слишком много файлов в выпуске');
    }
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
          total > 2 * 1024 * 1024 * 1024) {
        throw const FormatException('Недопустимый путь или размер в выпуске');
      }
    }
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
          throw const FileSystemException('Не удалось выдать право запуска');
        }
      }
    }
  } finally {
    input.closeSync();
  }
}
