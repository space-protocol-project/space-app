import 'dart:convert';

import 'package:cryptography/cryptography.dart';

// Архив не содержит snapshot, ratchet, KeyPackage или исходящую очередь.
class MlsHistoryArchive {
  static const maxBytes = 48 * 1024 * 1024;
  static final _cipher = AesGcm.with256bits();
  static final _kdf = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 210000,
    bits: 256,
  );
  static final _aad = utf8.encode('space/mls/history-archive/v1');

  static Future<List<int>> seal(
    Map<String, dynamic> history,
    String password,
  ) async {
    if (password.length < 12) {
      throw StateError('Для архива нужен пароль от 12 символов');
    }
    final salt = _cipher.newNonce();
    final key = await _kdf.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    final box = await _cipher.encrypt(
      utf8.encode(jsonEncode(history)),
      secretKey: key,
      aad: _aad,
    );
    final bytes = utf8.encode(
      jsonEncode({
        'v': 1,
        'salt': base64Encode(salt),
        'nonce': base64Encode(box.nonce),
        'ciphertext': base64Encode(box.cipherText),
        'mac': base64Encode(box.mac.bytes),
      }),
    );
    if (bytes.length > maxBytes) throw StateError('Архив слишком большой');
    return bytes;
  }

  static Future<Map<String, dynamic>> open(
    List<int> bytes,
    String password,
  ) async {
    if (bytes.length > maxBytes) throw StateError('Архив слишком большой');
    final encoded = jsonDecode(utf8.decode(bytes)) as Map;
    if (encoded['v'] != 1) throw StateError('Неизвестная версия архива');
    final salt = base64Decode(encoded['salt'] as String);
    final nonce = base64Decode(encoded['nonce'] as String);
    final mac = base64Decode(encoded['mac'] as String);
    if (salt.length != 12 || nonce.length != 12 || mac.length != 16) {
      throw StateError('Повреждён архив');
    }
    final key = await _kdf.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    final plain = await _cipher.decrypt(
      SecretBox(
        base64Decode(encoded['ciphertext'] as String),
        nonce: nonce,
        mac: Mac(mac),
      ),
      secretKey: key,
      aad: _aad,
    );
    return jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
  }
}
