import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../secure_vault.dart';

SecureKeyStorage secureStorage() => const PlatformKeyStorage();

Future<Directory> lockDirectory() async => Directory.fromUri(
  (await getApplicationSupportDirectory()).uri.resolve('mls-locks/'),
);
