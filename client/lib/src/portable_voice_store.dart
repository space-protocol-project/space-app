import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'portable_voice_merge.dart';
import 'portable_voice_profile.dart';

/// Одна очередь для локальных изменений и продолжения восстановления.
class PortableVoiceStore {
  static const key = 'space.voice.portable.v1';
  static Future<void> _tail = Future.value();

  Future<T> exclusive<T>(Future<T> Function() action) async {
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    await previous;
    try {
      return await action();
    } finally {
      done.complete();
    }
  }

  Future<PortableVoiceSnapshot> read(PortableVoiceProfile initial) async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.get(key);
    if (raw == null) return PortableVoiceSnapshot(initial, {});
    if (raw is! String || utf8.encode(raw).length > 32768) {
      throw const FormatException('Повреждена история голосовых настроек');
    }
    return PortableVoiceSnapshot.parse(jsonDecode(raw));
  }

  Future<void> write(PortableVoiceSnapshot snapshot) async {
    final preferences = await SharedPreferences.getInstance();
    final raw = jsonEncode(snapshot.data);
    if (utf8.encode(raw).length > 32768 ||
        !await preferences.setString(key, raw) ||
        preferences.getString(key) != raw) {
      throw StateError('Не удалось сохранить историю голосовых настроек');
    }
  }

  Future<PortableVoiceSnapshot> observe(
    PortableVoiceProfile value,
    String actor,
  ) => exclusive(() async {
    final previous = await read(value);
    final next = previous.observe(value, actor);
    await write(next);
    return next;
  });
}
