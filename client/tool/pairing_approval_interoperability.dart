import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing.dart';

class ApprovalVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = DeviceRecord.fromJson(value.toJson());
  }
}

Future<void> main(List<String> args) async {
  if (args.length != 3) {
    throw ArgumentError('Нужны origin, код и тестовая папка');
  }
  final server = await discover(args[0]), vault = ApprovalVault();
  final session = await SpaceSession.connect(server, vault);
  try {
    final pair = await inspectPairing(server, args[1]);
    final code = await session.preparePairing(pair);
    await File('${args[2]}/source.json').writeAsString(
      jsonEncode({'verification': code, 'principalId': session.principalId}),
    );
    String? echoed;
    final deadline = DateTime.now().add(const Duration(seconds: 30));
    while (DateTime.now().isBefore(deadline)) {
      try {
        echoed =
            (jsonDecode(await File('${args[2]}/confirm.json').readAsString())
                    as Map<String, dynamic>)['verification']
                as String;
        break;
      } catch (_) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }
    if (echoed != code) throw StateError('Код со второго устройства не совпал');
    await session.approvePairing(pair);
    stdout.writeln(
      'Dart/Go: управляющее устройство сверило код и подписало новый ключ — успешно.',
    );
  } finally {
    await session.close();
  }
}
