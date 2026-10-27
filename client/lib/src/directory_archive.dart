import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'directory_document.dart';

class DirectoryArchive {
  static const magic = 'SPACE-DIRECTORY-1\n';
  static const chunkSize = 65536, maxFile = 5 * 1024 * 1024;
  static final cipher = AesGcm.with256bits();
  static final kdf = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 600000, bits: 256);
  static Uint8List random(int length) {
    final source = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => source.nextInt(256)));
  }
  static Uint8List integer(int number) => (ByteData(4)..setUint32(0, number)).buffer.asUint8List();
  static void password(String value) {
    directoryRequire(value.runes.length >= 12 && value.trim().isNotEmpty && utf8.encode(value).length <= 1024);
  }
  static List<int> aad(String domain, List<int> header) => [...utf8.encode('space/directory/$domain/v1\u0000'), ...header];

  static Future<Uint8List> readStream(Stream<List<int>> stream) async {
    final builder = BytesBuilder(copy: false);
    await for (final bytes in stream) {
      directoryRequire(builder.length + bytes.length <= maxFile);
      builder.add(bytes);
    }
    return builder.takeBytes();
  }

  static Future<SecretKey> _derive(String passphrase, List<int> salt) async {
    final passwordKey = SecretKeyData(utf8.encode(passphrase));
    try { return await kdf.deriveKey(secretKey: passwordKey, nonce: salt); }
    finally { passwordKey.destroy(); }
  }

  static Future<Uint8List> seal(DirectoryDocument document, String passphrase) async {
    password(passphrase);
    final plain = Uint8List.fromList(document.encode());
    final salt = random(16), wrapNonce = random(12), prefix = random(8);
    final header = utf8.encode(jsonEncode({'v': 1, 'kdf': 'pbkdf2-sha256', 'iterations': 600000,
      'salt': base64Encode(salt), 'wrap_nonce': base64Encode(wrapNonce),
      'prefix': base64Encode(prefix), 'bytes': plain.length}));
    final dek = SecretKeyData(random(32));
    SecretKey? kek;
    try {
      kek = await _derive(passphrase, salt);
      final wrapped = await cipher.encrypt(dek.bytes, secretKey: kek, nonce: wrapNonce, aad: aad('wrap', header));
      final wrap = [...wrapped.cipherText, ...wrapped.mac.bytes];
      final output = BytesBuilder(copy: false)..add(utf8.encode(magic))..add(integer(header.length))..add(header)..add(wrap);
      await _sealChunks(output, plain, dek, prefix, header, wrap);
      return output.takeBytes();
    } finally {
      plain.fillRange(0, plain.length, 0);
      dek.destroy(); kek?.destroy();
    }
  }

  static Future<void> _sealChunks(BytesBuilder output, Uint8List plain, SecretKey key,
      List<int> prefix, List<int> header, List<int> wrapped) async {
    for (var offset = 0, index = 0; offset < plain.length; offset += chunkSize, index++) {
      final end = min(offset + chunkSize, plain.length);
      final part = await cipher.encrypt(Uint8List.sublistView(plain, offset, end), secretKey: key,
        nonce: [...prefix, ...integer(index)], aad: [...aad('chunk', header), ...wrapped, ...integer(index)]);
      output..add(part.cipherText)..add(part.mac.bytes);
    }
  }

  static Future<DirectoryDocument> open(Uint8List file, String passphrase) async {
    password(passphrase);
    directoryRequire(file.length > magic.length + 4 && file.length <= maxFile);
    directoryRequire(utf8.decode(file.sublist(0, magic.length)) == magic);
    final length = ByteData.sublistView(file, magic.length, magic.length + 4).getUint32(0);
    directoryRequire(length > 0 && length <= 4096 && file.length >= magic.length + 4 + length + 48);
    final start = magic.length + 4;
    final header = Uint8List.sublistView(file, start, start + length);
    final data = directoryMap(jsonDecode(utf8.decode(header)), 'bytes,iterations,kdf,prefix,salt,v,wrap_nonce');
    directoryRequire(jsonEncode(data) == utf8.decode(header));
    directoryRequire(data['v'] == 1 && data['kdf'] == 'pbkdf2-sha256' && data['iterations'] == 600000);
    final plainLength = directoryInt(data['bytes'], min: 1, max: directoryMaxPlain);
    final count = (plainLength + chunkSize - 1) ~/ chunkSize;
    directoryRequire(file.length == start + length + 48 + plainLength + count * 16);
    final salt = _base64(data['salt'], 16), nonce = _base64(data['wrap_nonce'], 12), prefix = _base64(data['prefix'], 8);
    final wrapped = Uint8List.sublistView(file, start + length, start + length + 48);
    final kek = await _derive(passphrase, salt);
    SecretKeyData? dek;
    try {
      dek = SecretKeyData(await cipher.decrypt(SecretBox(wrapped.sublist(0, 32), nonce: nonce, mac: Mac(wrapped.sublist(32))),
          secretKey: kek, aad: aad('wrap', header)));
      return await _openChunks(file, start + length + 48, plainLength, dek, prefix, header, wrapped);
    } finally { dek?.destroy(); kek.destroy(); }
  }

  static List<int> _base64(Object? value, int length) {
    final text = directoryText(value, max: 64), bytes = base64Decode(value as String);
    directoryRequire(bytes.length == length && base64Encode(bytes) == text);
    return bytes;
  }

  static Future<DirectoryDocument> _openChunks(Uint8List file, int offset, int length,
      SecretKey key, List<int> prefix, List<int> header, List<int> wrapped) async {
    final plain = Uint8List(length);
    try {
      for (var index = 0, position = 0; position < length; index++) {
        final size = min(chunkSize, length - position);
        final block = await cipher.decrypt(SecretBox(Uint8List.sublistView(file, offset, offset + size),
          nonce: [...prefix, ...integer(index)], mac: Mac(file.sublist(offset + size, offset + size + 16))),
          secretKey: key, aad: [...aad('chunk', header), ...wrapped, ...integer(index)]);
        plain.setRange(position, position + size, block);
        block.fillRange(0, block.length, 0);
        position += size; offset += size + 16;
      }
      final text = utf8.decode(plain), data = jsonDecode(text);
      directoryRequire(jsonEncode(data) == text);
      return DirectoryDocument.parse(data);
    } finally { plain.fillRange(0, plain.length, 0); }
  }
}
