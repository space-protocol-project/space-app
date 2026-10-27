import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/directory_archive.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_backup_cubit.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';

import 'fixtures/directory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppPreferences preferences;
  late DirectoryStorage storage;
  late DirectoryBackupCubit cubit;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    preferences = AppPreferences(); storage = DirectoryStorage();
    cubit = DirectoryBackupCubit(DirectoryBackupService(DirectoryRepository(storage), DirectoryVault(), preferences, () => {}));
  });
  tearDown(() async { await cubit.close(); await preferences.close(); });
  test('Отмена сохранения не фиксирует голову; успешный экспорт проверен до передачи в файл', () async {
    await cubit.export('A secure backup password', (_) async => false);
    expect(storage.values, isEmpty);
    await cubit.export('A secure backup password', (file) async {
      expect((await DirectoryArchive.open(file, 'A secure backup password')).spaces, isEmpty);
      return true;
    });
    expect(cubit.state.message, 'saved');
    expect(storage.values, isNotEmpty);
  });
  test('Preview не применяет, apply требует отдельного действия', () async {
    final file = await DirectoryArchive.seal(directoryDocument(), 'A secure backup password');
    await cubit.preview(file, 'A secure backup password');
    expect(cubit.state.plan, isNotNull);
    expect(preferences.origins, isEmpty);
    await cubit.apply();
    expect(cubit.state.message, 'restored');
    expect(preferences.origins.length, 1);
  });
}
