// Меняется только каталог профиля; DPAPI и файловые операции остаются настоящими.
import 'dart:io';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_windows/shared_preferences_windows.dart';

class CrashWindowsPaths extends PathProviderWindows {
  CrashWindowsPaths(this.root);
  final String root;
  @override
  Future<String> getApplicationSupportPath() async => root;
}

Future<void> initializeCrashWindows() async {
  if (!Platform.isWindows) return;
  final profile = Platform.environment['DIRECTORY_CRASH_PROFILE']!;
  final directory = Directory('$profile/system-storage');
  await directory.create(recursive: true);
  final paths = CrashWindowsPaths(directory.path);
  PathProviderPlatform.instance = paths;
  SharedPreferencesStorePlatform.instance = SharedPreferencesWindows()
    ..pathProvider = paths;
}

Future<void> verifyCrashWindowsStorage() async {
  if (!Platform.isWindows) return;
  final profile = Platform.environment['DIRECTORY_CRASH_PROFILE']!;
  final file = File('$profile/system-storage/space_space.directory.v1.dat');
  final bytes = await file.readAsBytes();
  // Заголовок DPAPI; чтение записей и сверка содержимого выполняются отдельно.
  if (bytes.length < 20 ||
      bytes[0] != 1 ||
      bytes[1] != 0 ||
      bytes[2] != 0 ||
      bytes[3] != 0 ||
      await Directory('$profile/vault').exists()) {
    throw StateError(
      'Стенд не подтвердил настоящий DPAPI без файловой фикстуры',
    );
  }
  final control = Platform.environment['DIRECTORY_CRASH_CONTROL']!;
  await File('$control/storage-proof.json').writeAsString(
    '{"backend":"PlatformKeyStorage/Windows DPAPI","file_fixture":false}',
    flush: true,
  );
}
