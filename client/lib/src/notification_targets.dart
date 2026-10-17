import 'dart:convert';
import 'dart:math';

import 'chat_notifications.dart';
import 'secure_vault.dart';

/// ОС получает только случайный одноразовый ключ, без адреса и текста чата.
class NotificationTargets {
  NotificationTargets({SecureKeyStorage? storage, DateTime Function()? now})
    : storage = storage ?? const PlatformKeyStorage(),
      now = now ?? DateTime.now;
  final SecureKeyStorage storage;
  final DateTime Function() now;
  static const key = 'space.notification-targets.v1';
  static final tokenPattern = RegExp(r'^[a-f0-9]{32}$');
  Future<void> _tail = Future.value();

  Future<T> _serial<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  Future<Map<String, dynamic>> _read() async {
    final value = await storage.read(key: key);
    if (value == null) return {};
    if (value.length > 200000) throw StateError('Слишком много уведомлений');
    final data = Map<String, dynamic>.from(jsonDecode(value) as Map);
    final cutoff = now()
        .subtract(const Duration(days: 7))
        .millisecondsSinceEpoch;
    data.removeWhere((token, entry) => !_valid(token, entry, cutoff));
    return data;
  }

  bool _valid(String token, dynamic entry, int cutoff) =>
      tokenPattern.hasMatch(token) &&
      entry is Map &&
      entry['time'] is int &&
      entry['time'] >= cutoff &&
      entry['time'] <= now().millisecondsSinceEpoch &&
      entry['payload'] is String &&
      ChatNotificationTarget.decode(entry['payload']) != null;

  Future<String> save(int id, String payload) => _serial(() async {
    if (ChatNotificationTarget.decode(payload) == null) {
      throw ArgumentError('Некорректная цель уведомления');
    }
    final data = await _read();
    data.removeWhere((_, entry) => entry['id'] == id);
    while (data.length >= 64) {
      data.remove(data.keys.first);
    }
    final random = Random.secure();
    final token = List.generate(
      16,
      (_) => random.nextInt(256),
    ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    data[token] = {
      'id': id,
      'time': now().millisecondsSinceEpoch,
      'payload': payload,
    };
    await storage.write(key: key, value: jsonEncode(data));
    return token;
  });

  Future<String?> take(String token) => _serial(() async {
    if (!tokenPattern.hasMatch(token)) return null;
    final data = await _read();
    final entry = data.remove(token);
    await storage.write(key: key, value: jsonEncode(data));
    return entry?['payload'] as String?;
  });

  Future<void> clear() => _serial(() => storage.delete(key: key));
}
