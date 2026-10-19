import 'dart:convert';

import 'secure_vault.dart';

// Черновики сохраняются защищённо, а записи выполняются последовательно.
class SavedDrafts {
  static const key = 'space.drafts.v1';
  static Future<void> _tail = Future.value();
  static final SecureKeyStorage _storage = const PlatformKeyStorage();
  static Object? _failure;

  static Future<Map<String, dynamic>> _read() async {
    final raw = await _storage.read(key: key);
    if (raw == null) return {};
    if (raw.length > 4 * 1024 * 1024) {
      throw StateError('Слишком много черновиков');
    }
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  static Future<String> load(String scope) async {
    await _tail;
    final drafts = await _read();
    return drafts[scope] as String? ?? '';
  }

  static void save(String scope, String text) {
    _tail = _tail.then((_) async {
      try {
        final drafts = await _read();
        if (text.isEmpty) {
          drafts.remove(scope);
        } else {
          drafts[scope] = text;
        }
        final encoded = jsonEncode(drafts);
        if (encoded.length > 4 * 1024 * 1024) {
          throw StateError('Слишком много черновиков');
        }
        await _storage.write(key: key, value: encoded);
        if (await _storage.read(key: key) != encoded) {
          throw StateError('Не подтверждено сохранение черновиков');
        }
        _failure = null;
      } catch (error) {
        _failure = error;
      }
    });
  }

  static Future<void> flush() async {
    await _tail;
    if (_failure != null) {
      throw StateError('Не удалось сохранить черновики: $_failure');
    }
  }
}
