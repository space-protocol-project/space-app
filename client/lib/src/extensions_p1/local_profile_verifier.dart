import 'dart:convert';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';

import '../key_vault.dart';
import 'local_profile_record.dart';
import 'local_registry_journal.dart';
import 'local_session_cubit.dart';

class LocalProfileVerifier {
  LocalProfileVerifier(
    this._storage, {
    required this.lockPath,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;
  static const storageKey = 'space.extensions.local-profile.v1';
  final SecureKeyStorage _storage;
  final Future<String> Function() lockPath;
  final DateTime Function() _now;
  bool _busy = false;

  Future<T> _exclusive<T>(Future<T> Function() operation) async {
    if (_busy) throw StateError('profile_busy');
    _busy = true;
    RegistryJournal? lock;
    try {
      // Используется только владение файловой блокировкой; кадры не записываются.
      lock = RegistryJournal.open(await lockPath());
      return await operation();
    } finally {
      _busy = false;
      lock?.close();
    }
  }

  Future<LocalProfileRecord?> _read() async {
    final raw = await _storage.read(key: storageKey);
    return raw == null ? null : LocalProfileRecord.decode(raw);
  }

  Future<bool> hasProfile() => _exclusive(() async => await _read() != null);

  Future<void> _save(LocalProfileRecord record) async {
    final raw = record.encode();
    LocalProfileRecord.decode(raw);
    await _storage.write(key: storageKey, value: raw);
    if (await _storage.read(key: storageKey) != raw) {
      throw StateError('profile_write_unconfirmed');
    }
  }

  Future<LocalProfileIdentity> verify(
    String password, {
    required bool create,
    required bool Function() active,
  }) => _exclusive(() async {
    validateProfilePassword(password);
    _requireActive(active);
    final existing = await _read();
    if (create) return _create(password, existing, active);
    if (existing == null) throw StateError('profile_missing');
    _requireActive(active);
    existing.reserveAttempt(_now().millisecondsSinceEpoch);
    // Попытка сохраняется до KDF: завершение процесса не обнуляет счётчик.
    await _save(existing);
    final actual = await deriveProfileVerifier(password, existing.salt);
    _requireActive(active);
    if (!_equal(actual, existing.verifier)) {
      throw const LocalProfileException(LocalProfileFailure.denied);
    }
    existing.resetAttempts();
    await _save(existing);
    _requireActive(active);
    return existing.identity;
  });

  Future<LocalProfileIdentity> _create(
    String password,
    LocalProfileRecord? existing,
    bool Function() active,
  ) async {
    if (existing != null) throw StateError('profile_exists');
    final salt = profileRandom(16);
    final verifier = await deriveProfileVerifier(password, salt);
    _requireActive(active);
    final record = LocalProfileRecord.create(salt, verifier);
    await _save(record);
    _requireActive(active);
    return record.identity;
  }

  void _requireActive(bool Function() active) {
    if (!active()) {
      throw const LocalProfileException(LocalProfileFailure.cancelled);
    }
  }

  bool _equal(List<int> a, List<int> b) {
    if (a.length != 32 || b.length != 32) {
      throw StateError('profile_verifier_size');
    }
    var difference = 0;
    for (var i = 0; i < 32; i++) {
      difference |= a[i] ^ b[i];
    }
    return difference == 0;
  }
}

Future<List<int>> deriveProfileVerifier(String password, List<int> salt) =>
    Isolate.run(() async {
      final input = SecretKeyData(
        utf8.encode(password),
        overwriteWhenDestroyed: true,
      );
      SecretKey? key;
      try {
        key = await Pbkdf2(
          macAlgorithm: Hmac.sha256(),
          iterations: 600000,
          bits: 256,
        ).deriveKey(secretKey: input, nonce: salt);
        return List<int>.of(await key.extractBytes());
      } finally {
        input.destroy();
        key?.destroy();
      }
    });
