import 'dart:convert';

import 'package:fixnum/fixnum.dart';

import '../chat_notifications.dart';
import '../rpc_clients.dart' show Channel, Content;
import 'client.dart';
import 'replies.dart';

class MlsNotificationSource {
  MlsNotificationSource({
    required this.origin,
    required this.principal,
    required this.channel,
    required this.open,
    required this.valid,
  });
  final String origin, principal;
  final Channel channel;
  final Future<MlsClient> Function() open;
  final bool Function() valid;
  String get key => jsonEncode([
    origin,
    principal,
    channel.id,
    base64Encode(channel.mlsGroupId),
  ]);
}

class MlsNotificationWatcher {
  final _cursors = <String, int>{};
  int _offset = 0;
  int _generation = 0;
  bool _running = false;
  bool _disposed = false;

  Future<void> poll(
    List<MlsNotificationSource> sources,
    void Function(ChatNotice) notify,
  ) async {
    if (_running || _disposed) return;
    _running = true;
    try {
      _cursors.removeWhere(
        (key, _) => !sources.any((source) => source.key == key),
      );
      if (sources.isEmpty) return;
      final count = sources.length.clamp(0, 4);
      final start = _offset % sources.length;
      _offset = (start + count) % sources.length;
      for (var index = 0; index < count && !_disposed; index++) {
        final source = sources[(start + index) % sources.length];
        try {
          await _pollSource(source, notify);
        } catch (_) {
          /* Ошибка или откат не дают уведомлений. */
        }
      }
    } finally {
      _running = false;
    }
  }

  Future<void> _pollSource(
    MlsNotificationSource source,
    void Function(ChatNotice) notify,
  ) async {
    if (!source.valid()) return;
    final generation = _generation;
    final client = await source.open();
    final channel = await _readChannel(source, client);
    if (channel == null) return;
    final before = _cursors.putIfAbsent(
      source.key,
      () => channel['cursor'] as int,
    );
    final data = await client.refresh(
      source.channel.id,
      source.channel.mlsGroupId,
    );
    if (_disposed ||
        generation != _generation ||
        !source.valid() ||
        !data.joined ||
        data.untrusted.isNotEmpty ||
        data.channel['revocation_pending'] == true) {
      return;
    }
    final cursor = data.channel['cursor'] as int;
    if (cursor <= before) return;
    _cursors[source.key] = cursor;
    final messages =
        data.messages
            .where((item) => _incoming(item, before, source.principal))
            .toList()
          ..sort(
            (a, b) => (a['sequence'] as int).compareTo(b['sequence'] as int),
          );
    if (messages.isEmpty) return;
    final item = messages.last;
    notify(
      ChatNotice(
        source.origin,
        source.principal,
        source.channel,
        item['sequence'] as int,
        _content(source, item),
      ),
    );
  }

  bool _incoming(Map item, int after, String principal) =>
      item['archived'] != true &&
      item['deleted'] != true &&
      item['author_id'] != principal &&
      (item['sequence'] as int) > after;

  Future<Map<String, dynamic>?> _readChannel(
    MlsNotificationSource source,
    MlsClient client,
  ) async {
    if (_disposed ||
        !source.valid() ||
        client.local.scope['principal_id'] != source.principal) {
      return null;
    }
    final document = await client.local.read();
    if (_disposed || !source.valid()) return null;
    final channel =
        (document['channels'] as Map)[source.channel.id]
            as Map<String, dynamic>?;
    if (channel == null ||
        channel['joined'] != true ||
        channel['revocation_pending'] == true ||
        channel['group_id'] != base64Encode(source.channel.mlsGroupId)) {
      return null;
    }
    return channel;
  }

  Future<Content?> message(MlsNotificationSource source, String key) async {
    final client = await source.open();
    if (await _readChannel(source, client) == null) return null;
    final pushedSequence = key.startsWith('@push:')
        ? int.tryParse(key.substring(6))
        : null;
    if (pushedSequence != null) {
      if (!await _refreshPush(source, client, pushedSequence)) return null;
    }
    final channel = await _readChannel(source, client);
    if (channel == null) return null;
    final item = MlsChannelData(channel).messages
        .where(
          (item) =>
              (pushedSequence == null
                  ? mlsMessageKey(item) == key
                  : item['sequence'] == pushedSequence) &&
              item['archived'] != true &&
              item['deleted'] != true,
        )
        .firstOrNull;
    return item == null ? null : _content(source, item);
  }

  Future<bool> _refreshPush(
    MlsNotificationSource source,
    MlsClient client,
    int sequence,
  ) async {
    final deadline = DateTime.now().add(const Duration(seconds: 30));
    var cursor = 0;
    while (source.valid() && DateTime.now().isBefore(deadline)) {
      final data = await client.refresh(
        source.channel.id,
        source.channel.mlsGroupId,
      );
      if (!source.valid() || data.untrusted.isNotEmpty) return false;
      final next = data.channel['cursor'] as int;
      if (next >= sequence) return true;
      if (next <= cursor) return false;
      cursor = next;
    }
    return false;
  }

  Content _content(MlsNotificationSource source, Map item) => Content(
    id: mlsMessageKey(item),
    channelId: source.channel.id,
    authorId: item['author_id'] as String,
    text: (item['message'] as Map)['text'] as String,
    sequence: Int64(item['sequence'] as int),
  );

  void dispose() {
    _disposed = true;
    _cursors.clear();
  }

  void reset() {
    _generation++;
    _cursors.clear();
  }
}
