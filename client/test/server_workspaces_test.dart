import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/server_workspaces.dart';

class EmptyWorkspaceVault implements IdentityVault {
  int writes = 0;
  @override
  Future<DeviceRecord?> load(String origin) async => null;
  @override
  Future<void> save(DeviceRecord record) async {
    writes++;
  }
}

class InspectCounter extends ChatController {
  InspectCounter(super.vault);
  int inspections = 0;
  @override
  Future<void> inspect(
    String address, {
    String invitationToken = '',
    String? homeOrigin,
    String tlsFingerprint = '',
  }) async {
    inspections++;
  }
}

void main() {
  test('Нет профиля — фон не проверяет сервер и не создаёт аккаунт', () async {
    final vault = EmptyWorkspaceVault();
    final directory = ServerWorkspaces(
      vault: vault,
      create: (_) => InspectCounter(vault),
    );
    addTearDown(directory.dispose);
    directory.synchronize(['https://server.example']);
    await Future<void>.delayed(Duration.zero);
    final controller = directory['https://server.example']! as InspectCounter;
    expect(controller.inspections, 0);
    expect(controller.connected, false);
    expect(vault.writes, 0);
  });

  test(
    'Добавление сервера во время загрузки не запускает второй пакет соединений',
    () async {
      final gate = Completer<void>();
      var active = 0, maximum = 0, calls = 0;
      final directory = ServerWorkspaces(
        vault: EmptyWorkspaceVault(),
        resume: (_, controller) async {
          active++;
          calls++;
          if (active > maximum) maximum = active;
          await gate.future;
          active--;
          controller.connected = true;
        },
      );
      addTearDown(directory.dispose);
      directory.synchronize(
        List.generate(4, (index) => 'https://$index.example'),
      );
      await Future<void>.delayed(Duration.zero);
      expect(calls, 4);
      directory.synchronize(['https://next.example']);
      await Future<void>.delayed(Duration.zero);
      expect(calls, 4);
      gate.complete();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(calls, 5);
      expect(maximum, 4);
      expect(
        directory.controllers.values.every(
          (controller) => controller.connected,
        ),
        true,
      );
    },
  );
}
