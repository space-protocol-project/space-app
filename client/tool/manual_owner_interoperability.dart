import 'dart:io';

import 'package:space_client/src/core.dart';

class ManualVault implements IdentityVault {
  Map<String, dynamic>? data;
  @override
  Future<DeviceRecord?> load(String origin) async =>
      data == null ? null : DeviceRecord.fromJson(data!);
  @override
  Future<void> save(DeviceRecord value) async {
    data = value.toJson();
  }
}

Future<void> main(List<String> args) async {
  final code = Platform.environment['SPACE_SETUP_CODE'];
  if (code == null || code.isEmpty) {
    throw StateError('Нужен тестовый setup-код');
  }
  final server = await discover(args.single), vault = ManualVault();
  var session = await SpaceSession.connect(server, vault);
  final principal = session.principalId;
  try {
    if (!session.needsOwnerSetup || session.role != 'member') {
      throw StateError('Ожидался ручной bootstrap');
    }
    await session.authorizeAdministration();
    await session.adminRequest(
      '/api/v1/space/setup/claim',
      body: {'setupCode': code},
    );
    if (session.needsOwnerSetup || session.role != 'owner') {
      throw StateError('Ручной bootstrap не назначил owner');
    }
    await session.adminRequest('/api/v1/space/settings');
  } finally {
    await session.close();
  }
  session = await SpaceSession.connect(server, vault);
  try {
    if (session.needsOwnerSetup ||
        session.role != 'owner' ||
        session.principalId != principal) {
      throw StateError('Перезапуск потерял владение');
    }
    await session.adminRequest('/api/v1/space/settings');
  } finally {
    await session.close();
  }
  stdout.writeln(
    'Native: setup-код, root-подпись, управление и перезапуск без браузерной панели.',
  );
}
