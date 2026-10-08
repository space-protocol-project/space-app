import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing.dart';

class PairTestVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = DeviceRecord.fromJson(value.toJson());
  }
}

void check(bool v, String text) {
  if (!v) throw StateError(text);
}

Future<void> main(List<String> args) async {
  if (args.length < 3 || args.length > 4) {
    throw ArgumentError('Нужны тестовая папка, origin и principal');
  }
  final directory = Directory(args[0]);
  final server = await discover(args[1]);
  final pending = await PendingPairing.start(server);
  try {
    await File('${directory.path}/request.json').writeAsString(
      jsonEncode({
        'code': pending.request.code,
        'pairingId': pending.request.pairing.id,
      }),
    );
    DeviceRecord? record;
    final deadline = DateTime.now().add(const Duration(seconds: 60));
    while (DateTime.now().isBefore(deadline)) {
      final response = await pending.poll();
      if (pending.proposedRoot != null) {
        final code = await pairVerificationCode(
          server.serverId,
          pending.request.pairing.id,
          pending.proposedRoot!,
          pending.request.pairing.publicKey,
        );
        await File('${directory.path}/check.json')
            .writeAsString(jsonEncode({'verification': code}));
      }
      if (response.pairing.state == 'approved') {
        record = await pending.verifiedRecord(response);
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    check(record != null, 'Сопряжение не подтверждено вовремя');
    final vault = PairTestVault();
    final session = await SpaceSession.connect(
      server,
      vault,
      restoredRecord: record!,
      pairingId: pending.request.pairing.id,
    );
    try {
      pending.claimed = true;
      check(
        session.principalId == args[2] && session.role == (args.length>3?args[3]:'owner'),
        'Pairing изменило owner/identity',
      );
      check(
        vault.record!.rootSeed.isEmpty && vault.record!.recoverySeed.isEmpty,
        'Рабочее устройство сохранило управляющий секрет',
      );
      await session.messages();
      await session.revoke();
    } finally {
      await session.close();
    }
    stdout.writeln(
      'Dart/WebCrypto/Go: предварительная сверка, root-подпись, прежний owner, новый рабочий ключ и self revoke — успешно.',
    );
  } finally {
    await pending.close();
  }
}
