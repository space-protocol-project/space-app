import 'dart:io';

import 'package:space_client/src/core.dart';

class FirstOwnerVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = DeviceRecord.fromJson(value.toJson());
  }
}

Future<void> main(List<String> args) async {
  final server = await discover(args.single);
  final vault = FirstOwnerVault();
  var session = await SpaceSession.connect(server, vault);
  final principal = session.principalId, grant = session.currentGrantId;
  try {
    if (session.role != 'owner' || !vault.record!.administrative) {
      throw StateError('Первый вход не дал владельца и подписанное разрешение');
    }
    final result = await session.adminRequest('/api/v1/space/settings');
    final settings = result['settings'] as Map;
    await session.adminRequest(
      '/api/v1/space/settings',
      method: 'PATCH',
      body: {
        'title': 'Первый владелец из приложения',
        'chatTitle': settings['chatTitle'],
        'chatEnabled': true,
        'registrationPolicy': 'open',
        'expectedRevision': settings['revision'],
      },
    );
  } finally {
    await session.close();
  }
  session = await SpaceSession.connect(server, vault);
  try {
    if (session.role != 'owner' ||
        session.principalId != principal ||
        session.currentGrantId != grant) {
      throw StateError('Повторный вход изменил владение или grant');
    }
  } finally {
    await session.close();
  }
  stdout.writeln(
    'Dart/Go: первый вход стал владельцем без кода, управление доступно, повторный вход сохранил identity и grant.',
  );
}
