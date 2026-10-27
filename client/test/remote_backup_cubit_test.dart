import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/remote_backup.dart';
import 'package:space_client/src/remote_backup_cubit.dart';
import 'package:space_client/src/remote_backup_models.dart';

import 'fixtures/directory.dart';
import 'fixtures/remote_backup.dart';

class WaitingRemoteBackup extends RemoteBackupService {
  WaitingRemoteBackup(super.directory);
  final completer = Completer<RemoteRestore>();
  @override
  Future<RemoteRestore> preview(RemoteBackupKit kit, String password) =>
      completer.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Импорт комплекта сбрасывает старое подтверждение и не требует авторизации',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = AppPreferences();
      addTearDown(prefs.close);
      final directory = DirectoryBackupService(
        DirectoryRepository(DirectoryStorage()),
        DirectoryVault(),
        prefs,
        () => {},
      );
      final service = RemoteBackupService(directory),
          cubit = RemoteBackupCubit(service);
      addTearDown(cubit.close);
      final (kit, _) = await memoryBackupNetwork();
      await cubit.importKit(kit.encode());
      cubit.mergeSettings(true);
      await cubit.importKit(kit.encode());
      expect(cubit.state.mergeSettings, isFalse);
      expect(cubit.state.restore, isNull);
      expect((await service.savedKit())!.id, kit.id);
      expect(prefs.origins, isEmpty);
    },
  );
  test('Закрытый Cubit не публикует поздний preview; повтор не запускает вторую операцию', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferences();
    addTearDown(prefs.close);
    final directory = DirectoryBackupService(
      DirectoryRepository(DirectoryStorage()),
      DirectoryVault(),
      prefs,
      () => {},
    );
    final service = WaitingRemoteBackup(directory);
    final controller = RemoteBackupCubit(service);
    final (kit, _) = await memoryBackupNetwork();
    await controller.importKit(kit.encode());
    final work = controller.preview('пароль');
    await controller.preview('вторая операция');
    expect(controller.state.busy, isTrue);
    await controller.close();
    service.completer.completeError(StateError('Поздний ответ после закрытия'));
    await expectLater(work, completes);
  });
}
