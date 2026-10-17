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

  Future<Map<String, dynamic>> _read({bool discardExpired = true}) async {
    final value = await storage.read(key: key);
    if (value == null) return {};
    if (value.length > 200000) throw StateError('Слишком много уведомлений');
    final data = Map<String, dynamic>.from(jsonDecode(value) as Map);
    final cutoff = discardExpired
        ? now().subtract(const Duration(days: 7)).millisecondsSinceEpoch
        : 0;
    data.removeWhere((token, entry) => !_valid(token, entry, cutoff));
    return data;
  }

  bool _valid(String token, dynamic entry, int cutoff) =>
      tokenPattern.hasMatch(token) &&
      entry is Map &&
      entry['id'] is int &&
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

  Future<List<int>> clear() => _serial(() async {
    var data = <String, dynamic>{};
    try {
      data = await _read(discardExpired: false);
    } catch (_) {
      // Повреждение целей не должно мешать их удалению.
    }
    await storage.delete(key: key);
    return data.values.map((entry) => entry['id'] as int).take(64).toList();
  });
}
