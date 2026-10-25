import 'dart:convert';

import 'secure_vault.dart';
import 'mention_data.dart';
import 'generated/space/v1/community_mentions.pb.dart';

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
    final value = drafts[scope];
    return value is Map ? value['text'] as String : value as String? ?? '';
  }

  static Future<List<CommunityMention>> loadMentions(
    String scope,
    String text,
  ) async {
    await _tail;
    final value = (await _read())[scope];
    if (value is! Map || value['text'] != text) return [];
    return readMentions(value['mentions'], text);
  }

  static void save(
    String scope,
    String text, {
    List<CommunityMention> mentions = const [],
  }) {
    final encodedMentions = mentionJson(mentions);
    _tail = _tail.then((_) async {
      try {
        final drafts = await _read();
        if (text.isEmpty) {
          drafts.remove(scope);
        } else {
          drafts[scope] = mentions.isEmpty
              ? text
              : {'text': text, 'mentions': encodedMentions};
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
