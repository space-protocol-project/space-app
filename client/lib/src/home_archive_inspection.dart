import 'dart:io';

import 'package:crypto/crypto.dart';

class HomeArchiveInspection {
  const HomeArchiveInspection({
    required this.path,
    required this.digest,
    required this.serverId,
    required this.schemaVersion,
    required this.files,
    required this.unpackedBytes,
  });
  final String path, digest, serverId;
  final int schemaVersion, files, unpackedBytes;

  factory HomeArchiveInspection.fromJson(
    Map<String, dynamic> data,
    String path,
    String digest,
  ) {
    final id = data['serverId'];
    if (data['format'] != 1 || id is! String || id.isEmpty || id.length > 256) {
      throw const FormatException('Некорректный отчёт проверки архива');
    }
    final schema = data['schemaVersion'],
        files = data['files'],
        bytes = data['unpackedBytes'];
    if (schema is! int ||
        schema < 1 ||
        files is! int ||
        files != 5 ||
        bytes is! int ||
        bytes <= 0 ||
        bytes > 2 * 1024 * 1024 * 1024) {
      throw const FormatException('Некорректные размеры или схема архива');
    }
    return HomeArchiveInspection(
      path: File(path).absolute.path,
      digest: digest,
      serverId: id,
      schemaVersion: schema,
      files: 5,
      unpackedBytes: bytes,
    );
  }

  Future<void> requireCurrentSource(String source) async {
    if (File(source).absolute.path != path ||
        await homeArchiveDigest(source) != digest) {
      throw const FormatException(
        'Архив изменился после проверки. Проверьте его заново',
      );
    }
  }
}

class HomeArchiveInspectionUnsupported extends FormatException {
  const HomeArchiveInspectionUnsupported()
    : super('Обновите runtime для проверки архива');
}

Future<String> homeArchiveDigest(String path) async {
  final file = File(path);
  if (await FileSystemEntity.type(path, followLinks: false) !=
          FileSystemEntityType.file ||
      await file.length() > 2 * 1024 * 1024 * 1024 + 1024 * 1024) {
    throw const FormatException('Недопустимый архив пространства');
  }
  return (await sha256.bind(file.openRead()).first).toString();
}
