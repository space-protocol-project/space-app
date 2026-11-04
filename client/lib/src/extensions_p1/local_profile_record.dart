import 'dart:convert';
import 'dart:math';

import 'local_session_cubit.dart';
import 'registry_validation.dart';

enum LocalProfileFailure { password, mismatch, denied, throttled, cancelled }

class LocalProfileException implements Exception {
  const LocalProfileException(this.failure);
  final LocalProfileFailure failure;
}

List<int> profileRandom(int size) {
  final random = Random.secure();
  return List.generate(size, (_) => random.nextInt(256));
}

void validateProfilePassword(String password) {
  if (password.runes.length < 12 ||
      password.runes.length > 256 ||
      password.trim().isEmpty ||
      utf8.encode(password).length > 1024) {
    throw const LocalProfileException(LocalProfileFailure.password);
  }
}

class LocalProfileRecord {
  LocalProfileRecord(this.value);
  final Map<String, Object?> value;
  LocalProfileIdentity get identity => (
    device: value['device']! as String,
    profile: value['profile']! as String,
    actor: 'local_owner',
  );
  List<int> get salt => base64Decode(value['salt']! as String);
  List<int> get verifier => base64Decode(value['verifier']! as String);
  int get failures => value['failures']! as int;
  int get blockedUntil => value['blocked_until']! as int;
  String encode() => jsonEncode(value);

  static LocalProfileRecord decode(String raw) {
    if (utf8.encode(raw).length > 4096)
      throw const FormatException('profile_size');
    final value = registryObject(jsonDecode(raw));
    registryKeys(value, [
      'version',
      'device',
      'profile',
      'salt',
      'verifier',
      'failures',
      'blocked_until',
    ]);
    if (value['version'] != 1) throw const FormatException('profile_version');
    validateRegistryName(value['device']! as String);
    validateRegistryName(value['profile']! as String);
    final record = LocalProfileRecord(value);
    if (record.salt.length != 16 || record.verifier.length != 32) {
      throw const FormatException('profile_digest');
    }
    if (record.failures < 0 ||
        record.failures > 5 ||
        record.blockedUntil < 0 ||
        record.blockedUntil > 9007199254740991) {
      throw const FormatException('profile_attempts');
    }
    return record;
  }

  static LocalProfileRecord create(List<int> salt, List<int> verifier) {
    String id() =>
        profileRandom(16)
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join();
    return LocalProfileRecord({
      'version': 1,
      'device': 'device_${id()}',
      'profile': 'profile_${id()}',
      'salt': base64Encode(salt),
      'verifier': base64Encode(verifier),
      'failures': 0,
      'blocked_until': 0,
    });
  }

  void reserveAttempt(int now) {
    if (blockedUntil > now)
      throw const LocalProfileException(LocalProfileFailure.throttled);
    final next = (failures == 5 ? 0 : failures) + 1;
    value['failures'] = next;
    value['blocked_until'] = next == 5 ? now + 30000 : 0;
  }

  void resetAttempts() {
    value['failures'] = 0;
    value['blocked_until'] = 0;
  }
}
