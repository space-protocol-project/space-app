import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/core.dart';

class ChannelInteropVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = value;
  }
}

Future<void> main(List<String> args) async {
  if (Platform.environment['CI'] != 'true') {
    throw StateError('Только изолированный CI');
  }
  final session = await SpaceSession.connect(
    await discover(args.single),
    ChannelInteropVault(),
  );
  try {
    stdout.writeln(jsonEncode({'principal': session.principalId}));
    await stdin.transform(utf8.decoder).transform(const LineSplitter()).first;
    await session.refreshChannels();
    session.selectChannel('interop-private');
    final created = await session.send(
      'Сообщение в закрытом канале из Flutter',
      newRequestKey(),
    );
    if (created.channelId != 'interop-private' ||
        !(await session.messages()).any((m) => m.id == created.id)) {
      throw StateError('Нарушена изоляция канала');
    }
    session.selectChannel('general');
    if ((await session.messages()).any((m) => m.text == created.text)) {
      throw StateError('Сообщение попало в другой канал');
    }
    stdout.writeln(jsonEncode({'ok': true}));
  } finally {
    await session.close();
  }
}
