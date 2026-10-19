import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

// Каждый блок аутентифицирует общий заголовок и свой номер. Размер сервера
// проверяется до выделения памяти; база обрабатывается блоками по 1 МиБ.
class MigrationArchive {
  static const magic = 'SPACE-MIGRATION-1\n';
  static const _committed = 'SPACE-MIGRATION-COMMITTED\n';
  static const chunkBytes = 1024 * 1024;
  static const maxDeviceBytes = 48 * chunkBytes;
  static const maxServerBytes = 2 * 1024 * chunkBytes + chunkBytes;
  static final _cipher = AesGcm.with256bits();

  static Future<bool> recognizes(String path) async {
    final file = await File(path).open();
    try {
      return utf8.decode(await file.read(magic.length), allowMalformed: true) ==
          magic;
    } finally {
      await file.close();
    }
  }

  static Future<void> write({
    required File server,
    required Map<String, dynamic> device,
    required String password,
    required File destination,
  }) async {
    if (password.length < 12) {
      throw StateError('Для переноса нужен пароль от 12 символов');
    }
    final plain = utf8.encode(jsonEncode(device));
    final length = await server.length();
    if (plain.length > maxDeviceBytes ||
        length < 1 ||
        length > maxServerBytes) {
      throw const FormatException('Превышен размер архива переноса');
    }
    final salt = _cipher.newNonce();
    final prefix = _cipher.newNonce().sublist(0, 8);
    final header = utf8.encode(
      jsonEncode({
        'v': 1,
        'salt': base64Encode(salt),
        'nonce': base64Encode(prefix),
        'server_bytes': length,
        'device_bytes': plain.length,
      }),
    );
    final key = await _derive(password, salt);
    await destination.create(exclusive: true);
    final output = await destination.open(mode: FileMode.writeOnly);
    try {
      await output.writeFrom(utf8.encode(magic));
      await output.writeFrom(_integer(header.length));
      await output.writeFrom(header);
      await _writeBlock(output, plain, key, prefix, header, 0);
      await _writeServer(output, server, key, prefix, header, length);
      await output.flush();
    } finally {
      plain.fillRange(0, plain.length, 0);
      await output.close();
    }
  }

  static Future<void> _writeServer(
    RandomAccessFile output,
    File server,
    SecretKey key,
    List<int> prefix,
    List<int> header,
    int length,
  ) async {
    final input = await server.open();
    try {
      var remaining = length;
      var index = 1;
      while (remaining > 0) {
        final size = remaining > chunkBytes ? chunkBytes : remaining;
        final block = await _readExact(input, size);
        await _writeBlock(output, block, key, prefix, header, index++);
        remaining -= size;
      }
      if (await input.position() != await input.length()) {
        throw const FormatException('Серверный архив изменился');
      }
    } finally {
      await input.close();
    }
  }

  static Future<Map<String, dynamic>> read({
    required File source,
    required String password,
    File? server,
    bool allowUncommitted = false,
  }) async {
    if (await FileSystemEntity.type(source.path, followLinks: false) !=
        FileSystemEntityType.file) {
      throw const FormatException('Недопустимый файл переноса');
    }
    final input = await source.open();
    try {
      if (await input.length() > maxServerBytes + maxDeviceBytes + chunkBytes ||
          utf8.decode(await _readExact(input, magic.length)) != magic) {
        throw const FormatException('Неизвестный архив переноса');
      }
      final size = _number(await _readExact(input, 4));
      if (size < 1 || size > 1024) {
        throw const FormatException('Повреждён заголовок');
      }
      final header = await _readExact(input, size);
      final metadata = jsonDecode(utf8.decode(header)) as Map;
      final lengths = _lengths(metadata);
      final salt = base64Decode(metadata['salt'] as String);
      final prefix = base64Decode(metadata['nonce'] as String);
      if (salt.length != 12 || prefix.length != 8) {
        throw const FormatException('Повреждены параметры шифрования');
      }
      final key = await _derive(password, salt);
      final device = await _readBlock(
        input,
        lengths.$1,
        key,
        prefix,
        header,
        0,
      );
      final payload = jsonDecode(utf8.decode(device)) as Map<String, dynamic>;
      device.fillRange(0, device.length, 0);
      await _readServer(input, server, lengths.$2, key, prefix, header);
      final remaining = await input.length() - await input.position();
      if (remaining == 0 && allowUncommitted) return payload;
      if (remaining != _committed.length ||
          utf8.decode(await _readExact(input, _committed.length)) !=
              _committed) {
        throw const FormatException(
          'Перенос не завершён на исходном устройстве',
        );
      }
      if (await input.position() != await input.length()) {
        throw const FormatException('Лишние данные в архиве');
      }
      return payload;
    } finally {
      await input.close();
    }
  }

  // Вызывается только после остановки исходных ключей. Данные к этому моменту
  // полностью записаны, синхронизированы и проверены повторным чтением.
  static Future<void> commit(File pending) async {
    final file = await pending.open(mode: FileMode.append);
    try {
      await file.writeFrom(utf8.encode(_committed));
      await file.flush();
    } finally {
      await file.close();
    }
  }

  static (int, int) _lengths(Map metadata) {
    final device = metadata['device_bytes'], server = metadata['server_bytes'];
    if (metadata['v'] != 1 ||
        device is! int ||
        server is! int ||
        device < 1 ||
        device > maxDeviceBytes ||
        server < 1 ||
        server > maxServerBytes) {
      throw const FormatException('Некорректные размеры архива');
    }
    return (device, server);
  }

  static Future<void> _readServer(
    RandomAccessFile input,
    File? server,
    int length,
    SecretKey key,
    List<int> prefix,
    List<int> header,
  ) async {
    await server?.create(exclusive: true);
    final output = await server?.open(mode: FileMode.writeOnly);
    try {
      var remaining = length;
      var index = 1;
      while (remaining > 0) {
        final size = remaining > chunkBytes ? chunkBytes : remaining;
        final bytes = await _readBlock(
          input,
          size,
          key,
          prefix,
          header,
          index++,
        );
        await output?.writeFrom(bytes);
        bytes.fillRange(0, bytes.length, 0);
        remaining -= size;
      }
      await output?.flush();
    } finally {
      await output?.close();
    }
  }

  static Future<SecretKey> _derive(String password, List<int> salt) => Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 600000,
    bits: 256,
  ).deriveKey(secretKey: SecretKey(utf8.encode(password)), nonce: salt);

  static List<int> _nonce(List<int> prefix, int index) => [
    ...prefix,
    ..._integer(index),
  ];
  static List<int> _aad(List<int> header, int index) => [
    ...utf8.encode(magic),
    ...header,
    ..._integer(index),
  ];

  static Future<void> _writeBlock(
    RandomAccessFile output,
    List<int> plain,
    SecretKey key,
    List<int> prefix,
    List<int> header,
    int index,
  ) async {
    final box = await _cipher.encrypt(
      plain,
      secretKey: key,
      nonce: _nonce(prefix, index),
      aad: _aad(header, index),
    );
    await output.writeFrom(box.cipherText);
    await output.writeFrom(box.mac.bytes);
  }

  static Future<List<int>> _readBlock(
    RandomAccessFile input,
    int size,
    SecretKey key,
    List<int> prefix,
    List<int> header,
    int index,
  ) async => _cipher.decrypt(
    SecretBox(
      await _readExact(input, size),
      nonce: _nonce(prefix, index),
      mac: Mac(await _readExact(input, 16)),
    ),
    secretKey: key,
    aad: _aad(header, index),
  );

  static Uint8List _integer(int value) =>
      (ByteData(4)..setUint32(0, value)).buffer.asUint8List();
  static int _number(Uint8List value) =>
      ByteData.sublistView(value).getUint32(0);

  static Future<Uint8List> _readExact(
    RandomAccessFile input,
    int length,
  ) async {
    final bytes = Uint8List(length);
    var offset = 0;
    while (offset < length) {
      final read = await input.readInto(bytes, offset, length);
      if (read == 0) throw const FormatException('Архив обрезан');
      offset += read;
    }
    return bytes;
  }
}

Future<void> preserveMigrationInWorker(Map<String, dynamic> input) async {
  final destination = File(input['destination'] as String);
  final password = input['password'] as String;
  final device = input['device'] as Map<String, dynamic>;
  await MigrationArchive.write(
    server: File(input['server'] as String),
    device: device,
    password: password,
    destination: destination,
  );
  final verified = await MigrationArchive.read(
    source: destination,
    password: password,
    allowUncommitted: true,
  );
  if (verified['id'] != device['id'] ||
      verified['server_digest'] != device['server_digest']) {
    throw StateError('Не подтверждено сохранение полного архива');
  }
}

Future<Map<String, dynamic>> openMigrationInWorker(
  Map<String, dynamic> input,
) => MigrationArchive.read(
  source: File(input['source'] as String),
  password: input['password'] as String,
  server: input['server'] == null ? null : File(input['server'] as String),
  allowUncommitted: input['allow_uncommitted'] == true,
);
