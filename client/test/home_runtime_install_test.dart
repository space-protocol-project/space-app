// Сетевой сценарий запускается только на одноразовых runner, не локально.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_runtime.dart';

import 'support/temp_directory.dart';

class _RuntimeBinding extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

class _Vault implements IdentityVault {
  Map<String, dynamic>? data;
  @override
  Future<DeviceRecord?> load(String origin) async =>
      data == null ? null : DeviceRecord.fromJson(data!);
  @override
  Future<void> save(DeviceRecord record) async {
    data = record.toJson();
  }
}

void main() {
  final enabled = Platform.environment['SPACE_HOME_INSTALL_CHECK'] == '1';
  if (enabled) {
    _RuntimeBinding();
  } else {
    TestWidgetsFlutterBinding.ensureInitialized();
  }
  test(
    'Публичный архив: загрузка, установка, владелец и повторный запуск без скачивания',
    () async {
      final root = await Directory.systemTemp.createTemp('space home install ');
      final vault = _Vault();
      var downloads = 0;
      final home = HomeController(
        directory: () async => root,
        download: (release, file, progress) async {
          downloads++;
          await downloadHomeRelease(release, file, progress);
        },
      );
      HomeController? restored;
      SpaceSession? session;
      try {
        final first = await home.start('203.0.113.10');
        expect(first, isNotNull, reason: home.error);
        final discovered = await discover(
          first!.localOrigin,
          homeOrigin: first.publicOrigin,
          tlsFingerprint: first.tlsFingerprint,
        );
        session = await SpaceSession.connect(
          discovered,
          vault,
          setupCode: first.setupCode,
        );
        expect(session.role, 'owner');
        await session.close();
        session = null;
        await home.stop();
        expect(home.running, false, reason: home.error);
        expect(home.error, isEmpty);
        expect(downloads, 1);
        restored = HomeController(
          directory: () async => root,
          download: (_, _, _) async {
            throw StateError('Повторная загрузка запрещена');
          },
        );
        final second = await restored.start('203.0.113.11');
        expect(second, isNotNull, reason: restored.error);
        expect(second!.link, first.link);
        expect(second.publicOrigin, first.publicOrigin);
        expect(second.setupCode, isEmpty);
        final next = await discover(
          second.localOrigin,
          homeOrigin: second.publicOrigin,
          tlsFingerprint: second.tlsFingerprint,
        );
        expect(next.serverId, discovered.serverId);
        session = await SpaceSession.connect(next, vault);
        expect(session.role, 'owner');
      } finally {
        await session?.close();
        await restored?.stop();
        await home.stop();
        restored?.dispose();
        home.dispose();
        await deleteTestDirectory(root, prefix: 'space home install ');
      }
    },
    skip: !enabled,
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
