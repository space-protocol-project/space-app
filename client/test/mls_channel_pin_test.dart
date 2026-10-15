import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/mls/channel_pin.dart';
import 'package:space_client/src/rpc_clients.dart';

void main() {
  test('Сервер не может понизить известный MLS-канал до открытого', () {
    final group = List.filled(32, 42);
    final pins = {'private': base64Encode(group)};
    requirePinnedMlsChannel(pins, Channel(id: 'private', mlsGroupId: group));
    expect(
      () => requirePinnedMlsChannel(pins, Channel(id: 'private')),
      throwsStateError,
    );
    expect(
      () => requirePinnedMlsChannel(
        pins,
        Channel(id: 'private', mlsGroupId: List.filled(32, 43)),
      ),
      throwsStateError,
    );
    requirePinnedMlsChannel(pins, Channel(id: 'general'));
  });
}
