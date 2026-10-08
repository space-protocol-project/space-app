import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

const cardIterations = 600000;
const cardDomain = 'space/recovery-card/v1';
String _encode(List<int> value) => base64Url.encode(value).replaceAll('=', '');
List<int> _decode(dynamic value, int? size) {
  if (value is! String || !RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value)) {
    throw const FormatException('Повреждена карточка');
  }
  final bytes = base64Url.decode(base64Url.normalize(value));
  if (_encode(bytes) != value || (size != null && bytes.length != size)) {
    throw const FormatException('Повреждена карточка');
  }
  return bytes;
}

Future<SecretKey> _key(String password, List<int> salt) {
  if (password.length < 12 || utf8.encode(password).length > 512) {
    throw const FormatException('Пароль должен содержать от 12 символов');
  }
  return Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: cardIterations,
    bits: 256,
  ).deriveKey(secretKey: SecretKey(utf8.encode(password)), nonce: salt);
}

Future<String> sealRecoveryCard(
  Map<String, dynamic> payload,
  String password,
) async {
  final plain = utf8.encode(jsonEncode(payload));
  if (plain.length > 8176) {
    throw const FormatException('Карточка превышает безопасный размер формата');
  }
  final random = Random.secure();
  final salt = List<int>.generate(16, (_) => random.nextInt(256));
  final nonce = List<int>.generate(12, (_) => random.nextInt(256));
  final box = await AesGcm.with256bits().encrypt(
    plain,
    secretKey: await _key(password, salt),
    nonce: nonce,
    aad: utf8.encode(cardDomain),
  );
  return jsonEncode({
    'v': 1,
    'kind': 'space-recovery-card',
    'kdf': 'PBKDF2-SHA256',
    'iterations': cardIterations,
    'salt': _encode(salt),
    'nonce': _encode(nonce),
    'ciphertext': _encode([...box.cipherText, ...box.mac.bytes]),
  });
}

Future<Map<String, dynamic>> openRecoveryCard(
  String text,
  String password,
) async {
  if (utf8.encode(text).length > 16384) {
    throw const FormatException('Карточка слишком большая');
  }
  final packet = jsonDecode(text) as Map<String, dynamic>;
  final keys = packet.keys.toList()..sort();
  if (packet['v'] != 1 ||
      packet['kind'] != 'space-recovery-card' ||
      packet['kdf'] != 'PBKDF2-SHA256' ||
      packet['iterations'] != cardIterations ||
      keys.join(',') != 'ciphertext,iterations,kdf,kind,nonce,salt,v') {
    throw const FormatException('Неподдерживаемая карточка');
  }
  final salt = _decode(packet['salt'], 16),
      nonce = _decode(packet['nonce'], 12),
      ciphertext = _decode(packet['ciphertext'], null);
  if (ciphertext.length < 16 || ciphertext.length > 8192) {
    throw const FormatException('Повреждена карточка');
  }
  try {
    final box = SecretBox(
      ciphertext.sublist(0, ciphertext.length - 16),
      nonce: nonce,
      mac: Mac(ciphertext.sublist(ciphertext.length - 16)),
    );
    final plain = await AesGcm.with256bits().decrypt(
      box,
      secretKey: await _key(password, salt),
      aad: utf8.encode(cardDomain),
    );
    return jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
  } on SecretBoxAuthenticationError {
    throw const FormatException('Неверный пароль или повреждённая карточка');
  }
}

Future<String> sealCardInWorker(List<Object> input) =>
    sealRecoveryCard(input[0] as Map<String, dynamic>, input[1] as String);
Future<Map<String, dynamic>> openCardInWorker(List<String> input) =>
    openRecoveryCard(input[0], input[1]);
