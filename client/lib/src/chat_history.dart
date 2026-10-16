import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/space/v1/space.pb.dart';
import 'secure_vault.dart';

const historyRetention = Duration(days: 14);
const _maxHistoryBytes = 4 * 1024 * 1024;

class CachedMessage {
  CachedMessage(this.content, this.receivedAt);
  final Content content;
  final int receivedAt;
  int get retentionTime {
    final created = content.createdAtUnixMs.toInt();
    return created > 0 && created < receivedAt ? created : receivedAt;
  }
}

class ChatHistory {
  ChatHistory({
    required this.serverId,
    required this.principalId,
    required this.grantId,
  });
  final String serverId, principalId, grantId;
  String title = '', selected = 'general';
  bool attachmentsEnabled = false;
  List<Channel> channels = [];
  Map<String, int> readSequences = {};
  final Map<String, CachedMessage> entries = {};
  final Set<String> favorites = {};
  void prune(DateTime now) {
    final cutoff = now.subtract(historyRetention).millisecondsSinceEpoch;
    entries.removeWhere(
      (key, value) => value.retentionTime < cutoff && !favorites.contains(key),
    );
    if (entries.length > 10000) trimHalf();
    favorites.removeWhere((key) => !entries.containsKey(key));
  }

  void trimHalf() {
    final sorted = entries.entries.toList()
      ..sort((a, b) => a.value.retentionTime.compareTo(b.value.retentionTime));
    for (final entry in sorted.take((sorted.length + 1) ~/ 2)) {
      entries.remove(entry.key);
      favorites.remove(entry.key);
    }
  }

  void merge(Iterable<Content> messages, DateTime now) {
    final allowed = channels
        .where((c) => c.permissions.read)
        .map((c) => c.id)
        .toSet();
    entries.removeWhere(
      (_, value) => !allowed.contains(value.content.channelId),
    );
    for (final message in messages) {
      if (!allowed.contains(message.channelId)) continue;
      final key = '${message.channelId}/${message.id}';
      if (message.deleted) favorites.remove(key);
      final previous = entries[key]?.content;
      if (previous != null && previous.revision > message.revision) continue;
      entries[key] = CachedMessage(
        Content()..mergeFromProto3Json(message.toProto3Json()),
        entries[key]?.receivedAt ?? now.millisecondsSinceEpoch,
      );
    }
    prune(now);
  }

  List<Content> messages(String channel, DateTime now) {
    prune(now);
    return entries.values
        .where((entry) => entry.content.channelId == channel)
        .map((entry) => entry.content)
        .toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
  }

  Content? get latest =>
      (entries.values.toList()
            ..sort((a, b) => b.retentionTime.compareTo(a.retentionTime)))
          .firstOrNull
          ?.content;
  Map<String, dynamic> toJson() => {
    'v': 1,
    'serverId': serverId,
    'principalId': principalId,
    'grantId': grantId,
    'title': title,
    'selected': selected,
    'attachmentsEnabled': attachmentsEnabled,
    'channels': channels.map((c) => c.toProto3Json()).toList(),
    'reads': readSequences,
    'favorites': favorites.toList(),
    'messages': [
      for (final entry in entries.values)
        {'content': entry.content.toProto3Json(), 'received': entry.receivedAt},
    ],
  };
  static ChatHistory fromJson(Map<String, dynamic> data, DateTime now) {
    if (data['v'] != 1 ||
        (data['channels'] as List).length > 500 ||
        (data['messages'] as List).length > 10000) {
      throw const FormatException('Неверная история');
    }
    final result =
        ChatHistory(
            serverId: data['serverId'] as String,
            principalId: data['principalId'] as String,
            grantId: data['grantId'] as String,
          )
          ..title = data['title'] as String
          ..selected = data['selected'] as String
          ..channels = [
            for (final channel in data['channels'] as List)
              Channel()..mergeFromProto3Json(channel),
          ]
          ..readSequences = Map<String, int>.from(data['reads'] as Map);
    result.attachmentsEnabled = data['attachmentsEnabled'] == true;
    for (final entry in data['messages'] as List) {
      final content = Content()..mergeFromProto3Json(entry['content']);
      final received = entry['received'] as int;
      if (received < 0 || received > now.millisecondsSinceEpoch) continue;
      result.entries['${content.channelId}/${content.id}'] = CachedMessage(
        content,
        received,
      );
    }
    result.favorites.addAll(List<String>.from(data['favorites'] ?? const []));
    result.merge(const [], now);
    return result;
  }
}

abstract interface class ChatHistoryStore {
  Future<ChatHistory?> read(String origin);
  Future<void> write(String origin, ChatHistory history);
  Future<void> delete(String origin);
}

class LocalChatHistory implements ChatHistoryStore {
  LocalChatHistory({SecureKeyStorage? storage, DateTime Function()? now})
    : storage = storage ?? const PlatformKeyStorage(),
      now = now ?? DateTime.now;
  final SecureKeyStorage storage;
  final DateTime Function() now;
  static final Map<String, Future<void>> _writes = {};
  static final Map<String, int> _epochs = {};
  Future<String> _id(String origin) async =>
      base64Url.encode((await Sha256().hash(utf8.encode(origin))).bytes);
  Future<void> _queue(String origin, Future<void> Function() action) {
    final next = (_writes[origin] ?? Future<void>.value())
        .catchError((Object _) {})
        .then((_) => action());
    _writes[origin] = next;
    return next;
  }

  @override
  Future<ChatHistory?> read(String origin) async {
    await (_writes[origin] ?? Future<void>.value()).catchError((Object _) {});
    final id = await _id(origin);
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('space.history.denied.$id') == true) return null;
    final value = prefs.getString('space.history.data.$id');
    if (value == null) return null;
    try {
      if (value.length > 6 * 1024 * 1024) {
        throw const FormatException('Большая история');
      }
      final key = await storage.read(key: 'space.history.key.$id');
      if (key == null) throw const FormatException('Нет ключа истории');
      final envelope = jsonDecode(value) as Map;
      if (envelope['v'] != 1) throw const FormatException('Неверная версия');
      final plain = await AesGcm.with256bits().decrypt(
        SecretBox(
          base64Decode(envelope['data'] as String),
          nonce: base64Decode(envelope['nonce'] as String),
          mac: Mac(base64Decode(envelope['mac'] as String)),
        ),
        secretKey: SecretKey(base64Decode(key)),
        aad: utf8.encode(origin),
      );
      if (plain.length > _maxHistoryBytes) {
        throw const FormatException('Большая история');
      }
      return ChatHistory.fromJson(
        jsonDecode(utf8.decode(plain)) as Map<String, dynamic>,
        now(),
      );
    } catch (_) {
      await delete(origin);
      return null;
    }
  }

  @override
  Future<void> write(String origin, ChatHistory history) {
    history.prune(now());
    var encoded = utf8.encode(jsonEncode(history.toJson()));
    while (encoded.length > _maxHistoryBytes && history.entries.isNotEmpty) {
      history.trimHalf();
      encoded = utf8.encode(jsonEncode(history.toJson()));
    }
    final bytes = encoded;
    if (bytes.length > _maxHistoryBytes) {
      throw const FormatException('Большая история');
    }
    final epoch = _epochs[origin] ?? 0;
    return _queue(origin, () => _writeSnapshot(origin, bytes, epoch));
  }

  Future<void> _writeSnapshot(String origin, List<int> bytes, int epoch) async {
    if ((_epochs[origin] ?? 0) != epoch) return;
    final id = await _id(origin);
    final keyName = 'space.history.key.$id';
    var key = await storage.read(key: keyName);
    if ((_epochs[origin] ?? 0) != epoch) return;
    if (key == null) {
      key = base64Encode(
        await (await AesGcm.with256bits().newSecretKey()).extractBytes(),
      );
      await storage.write(key: keyName, value: key);
    }
    final box = await AesGcm.with256bits().encrypt(
      bytes,
      secretKey: SecretKey(base64Decode(key)),
      aad: utf8.encode(origin),
    );
    final prefs = await SharedPreferences.getInstance();
    if ((_epochs[origin] ?? 0) != epoch) return;
    if (!await prefs.setString(
      'space.history.data.$id',
      jsonEncode({
        'v': 1,
        'data': base64Encode(box.cipherText),
        'nonce': base64Encode(box.nonce),
        'mac': base64Encode(box.mac.bytes),
      }),
    )) {
      throw StateError('История не сохранена');
    }
    if ((_epochs[origin] ?? 0) != epoch) return;
    if (!await prefs.setBool('space.history.denied.$id', false)) {
      throw StateError('История не сохранена');
    }
  }

  @override
  Future<void> delete(String origin) async {
    _epochs[origin] = (_epochs[origin] ?? 0) + 1;
    final id = await _id(origin);
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setBool('space.history.denied.$id', true)) {
      throw StateError('История не удалена');
    }
    await _queue(origin, () async {
      final id = await _id(origin);
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setBool('space.history.denied.$id', true)) {
        throw StateError('История не удалена');
      }
      await storage.delete(key: 'space.history.key.$id');
      if (!await prefs.remove('space.history.data.$id')) {
        throw StateError('История не удалена');
      }
    });
  }
}
