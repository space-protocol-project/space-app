import 'dart:convert';

import '../rpc_clients.dart';

void requirePinnedMlsChannel(Map<String, String> pins, Channel channel) {
  final expected = pins[channel.id];
  if (expected != null && expected != base64Encode(channel.mlsGroupId)) {
    throw StateError('Сервер изменил режим защиты закрытого канала');
  }
}
