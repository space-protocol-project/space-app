import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_document.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';

import 'fixtures/directory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DirectoryStorage storage;
  late DirectoryRepository repository;
  late DirectoryVault vault;
  late AppPreferences preferences;
  late DirectoryBackupService service;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = DirectoryStorage(); repository = DirectoryRepository(storage);
    vault = DirectoryVault(); preferences = AppPreferences();
    service = DirectoryBackupService(repository, vault, preferences, () => {});
  });
  tearDown(() => preferences.close());
  test('Предварительная проверка не меняет хранилище; настройки по умолчанию сохраняются', () async {
    final plan = await service.preview(directoryDocument());
    expect(plan.unknown, isTrue); expect(storage.values, isEmpty);
    await service.apply(plan, replaceSettings: false);
    expect(preferences.palette, 'gruvbox');
    expect(preferences.origins, ['https://space.example']);
    expect(vault.records, isEmpty);
    expect((await repository.read())['pending'], isNull);
  });
  test('Настройки заменяются только явно; повтор той же копии идемпотентен', () async {
    await service.apply(await service.preview(directoryDocument()), replaceSettings: true);
    expect(preferences.palette, 'iris');
    await service.apply(await service.preview(directoryDocument()), replaceSettings: true);
    expect(preferences.origins.length, 1);
  });
  test('Известный откат и ветвление блокируются', () async {
    final first = directoryDocument();
    await service.apply(await service.preview(first), replaceSettings: false);
    final next = directoryDocument(revision: 2, parent: await first.digest());
    await service.apply(await service.preview(next), replaceSettings: false);
    expect((await service.preview(first)).conflicts, isNotEmpty);
    final fork = directoryDocument(revision: 3, parent: await first.digest());
    expect((await service.preview(fork)).conflicts, isNotEmpty);
  });
  test('Конфликт существующего закрепления и смена настроек после preview блокируют применение', () async {
    final plan = await service.preview(directoryDocument());
    await preferences.change(palette: 'ocean');
    await expectLater(service.apply(plan, replaceSettings: false), throwsFormatException);
    await service.apply(await service.preview(directoryDocument()), replaceSettings: false);
    final state = await repository.read(), data = state['catalog'] as Map;
    data['https://space.example']['server_key'] = url64(List.filled(32, 9));
    await repository.write(state);
    expect((await service.preview(directoryDocument())).conflicts, isNotEmpty);
  });
  test('Сбой защищённой записи не изменяет настройки и не сообщает успех', () async {
    final plan = await service.preview(directoryDocument());
    storage.fail = true;
    await expectLater(service.apply(plan, replaceSettings: true), throwsStateError);
    expect(preferences.palette, 'gruvbox'); expect(preferences.origins, isEmpty);
  });
  test('Незавершённый журнал применяется повторно и очищается', () async {
    final state = await repository.read();
    (state['catalog'] as Map)['https://space.example'] = directorySpace();
    state['pending'] = {'origins': ['https://space.example'], 'settings': directorySettings()};
    await repository.write(state);
    await service.resume();
    expect(preferences.palette, 'iris'); expect(preferences.origins.length, 1);
    expect((await repository.read())['pending'], isNull);
  });
  test('Закрепление из восстановленного каталога не даёт принять другой сервер', () async {
    await service.apply(await service.preview(directoryDocument()), replaceSettings: false);
    await expectLater(repository.checkTrust(Discovery(Uri.parse('https://space.example'), 'other', List.filled(32, 2))), throwsFormatException);
  });
}
