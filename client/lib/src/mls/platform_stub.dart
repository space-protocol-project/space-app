import 'dart:io';

import '../key_vault.dart';

SecureKeyStorage secureStorage() => throw UnsupportedError(
  'Для MLS вне Flutter передайте защищённое хранилище в MlsLocalStore',
);

Future<Directory> lockDirectory() async => throw UnsupportedError(
  'Платформенное хранилище MLS доступно в приложении Flutter',
);
