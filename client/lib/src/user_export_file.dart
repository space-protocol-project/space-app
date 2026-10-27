import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'file_picker.dart';

/// Android выдаёт доступ ровно к документу, выбранному в системном диалоге.
class UserExportFileService {
  UserExportFileService({bool? android})
    : android = android ?? Platform.isAndroid;
  final bool android;
  static const channel = MethodChannel('space/user-export');
  Future<String?> choose(
    String name, {
    bool binary = false,
    String? extension,
  }) async {
    if (android) {
      return channel.invokeMethod<String>('choose', {
        'name': name,
        'binary': binary,
      });
    }
    return (await getSaveLocation(
      suggestedName: name,
      acceptedTypeGroups: [
        XTypeGroup(
          label: binary ? 'Space backup' : 'JSON',
          extensions: [extension ?? (binary ? 'spacebackup' : 'json')],
        ),
      ],
    ))?.path;
  }

  Future<void> write(String path, Uint8List bytes) async {
    if (bytes.isEmpty || bytes.length > 16 * 1024 * 1024) {
      throw const FormatException('Некорректный размер экспорта');
    }
    if (android) {
      await channel.invokeMethod<void>('write', {'uri': path, 'bytes': bytes});
      return;
    }
    final temporary = await Directory(p.dirname(path))
        .createTemp('.space-export-');
    try {
      final file = File(p.join(temporary.path, 'content.json'));
      await file.writeAsBytes(bytes, flush: true);
      await file.rename(path);
    } finally {
      await temporary.delete(recursive: true);
    }
  }

  Future<void> discard(String path) async {
    if (android) await channel.invokeMethod<void>('discard', {'uri': path});
  }
}
