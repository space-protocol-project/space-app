import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ChannelPositionStore {
  Future<Map<String, dynamic>> load(String scope);
  Future<void> save(String scope, Map<String, dynamic> data);
}

// Здесь только позиции, без текста сообщений, токенов и секретных ключей.
class LocalChannelPositions implements ChannelPositionStore {
  Future<void> _writes = Future.value();
  Future<String> _key(String scope) async =>
      'space.channels.v1.${base64Url.encode((await Sha256().hash(utf8.encode(scope))).bytes)}';
  @override
  Future<Map<String, dynamic>> load(String scope) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(await _key(scope));
    if (value == null) return {};
    if (value.length > 32768) {
      throw const FormatException('Слишком большой список позиций');
    }
    return jsonDecode(value) as Map<String, dynamic>;
  }

  @override
  Future<void> save(String scope, Map<String, dynamic> data) {
    final snapshot = jsonEncode(data);
    // Ошибка одной записи не блокирует последующие попытки сохранения.
    final task = _writes.catchError((Object _) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(await _key(scope), snapshot)) {
        throw StateError('Позиции не сохранены');
      }
    });
    _writes = task;
    return task;
  }
}
