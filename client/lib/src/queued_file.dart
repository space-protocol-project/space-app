import 'dart:convert';

import 'package:crypto/crypto.dart';

class QueuedFile {
  const QueuedFile({
    required this.id,
    required this.key,
    required this.name,
    required this.size,
    required this.digest,
  });
  final String id, key, name, digest;
  final int size;

  static String slot(String message, int index) =>
      sha256.convert(utf8.encode('$message/$index')).toString();

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'name': name,
    'size': size,
    'sha256': digest,
  };

  factory QueuedFile.fromJson(Map<String, dynamic> value) {
    final file = QueuedFile(
      id: value['id'] as String,
      key: value['key'] as String,
      name: value['name'] as String,
      size: value['size'] as int,
      digest: value['sha256'] as String,
    );
    file.validate();
    return file;
  }

  void validate() {
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(id) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(digest) ||
        key.isEmpty ||
        key.length > 128) {
      throw const FormatException('Некорректная запись файла');
    }
    if (name.trim().isEmpty ||
        utf8.encode(name).length > 255 ||
        name == '.' ||
        name == '..' ||
        RegExp(r'[\x00-\x1f\x7f-\x9f\\/:]').hasMatch(name) ||
        size < 1 ||
        size > 20 * 1024 * 1024) {
      throw const FormatException('Некорректное имя или размер файла');
    }
  }
}
