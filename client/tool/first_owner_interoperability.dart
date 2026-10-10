import 'dart:io';

import 'native_management_scenarios.dart';

import 'package:space_client/src/core.dart';

class FirstOwnerVault implements IdentityVault {
  DeviceRecord? record;
  bool failSave = false;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    if (failSave) throw StateError('Тестовый отказ vault');
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
  // Проверяем владельца с обычным рабочим grant без space.manage.
  vault.record = DeviceRecord.fromJson({
    ...vault.record!.toJson(),
    'grantId': '',
    'administrative': false,
  });
  session = await SpaceSession.connect(server, vault);
  var limitedGrant = session.currentGrantId;
  try {
    if (session.role != 'owner' ||
        (await session.adminIdentity())['administrative'] != false) {
      throw StateError('Обычный grant владельца получил лишние права');
    }
    vault.failSave = true;
    try {
      await session.authorizeAdministration();
      throw StateError('Ожидался отказ vault');
    } catch (e) {
      if (!e.toString().contains('Тестовый отказ vault')) rethrow;
    } finally {
      vault.failSave = false;
    }
    if (session.currentGrantId != limitedGrant ||
        (await session.listDevices())
            .where((g) => g.id == limitedGrant)
            .single
            .revoked) {
      throw StateError('Ошибка vault отозвала прежний доступ');
    }
    await session.authorizeAdministration();
    if (session.currentGrantId == limitedGrant ||
        session.principalId != principal ||
        !(await session.listDevices())
            .where((g) => g.id == limitedGrant)
            .single
            .revoked) {
      throw StateError(
        'Выдача управления изменила identity или не отозвала прежний grant',
      );
    }
    await session.adminRequest('/api/v1/space/settings');
    final approvedGrant = session.currentGrantId;
    await session.authorizeAdministration();
    if (session.currentGrantId != approvedGrant) {
      throw StateError('Повторная выдача создала лишний grant');
    }
  } finally {
    await session.close();
  }
  session = await SpaceSession.connect(server, vault);
  try {
    await session.adminRequest('/api/v1/space/settings');
    if (session.principalId != principal) {
      throw StateError('Перезапуск изменил identity');
    }
    await nativeManagementScenarios(session);
  } finally {
    await session.close();
  }
  stdout.writeln(
    'Dart/Go: первый вход стал владельцем без кода, управление доступно, повторный вход сохранил identity и grant.',
  );
}
