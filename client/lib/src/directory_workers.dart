import 'dart:typed_data';

import 'directory_archive.dart';
import 'directory_document.dart';

Future<Uint8List> sealDirectoryWorker((Map<String, dynamic>, String) input) =>
    DirectoryArchive.seal(DirectoryDocument.parse(input.$1), input.$2);

Future<Map<String, dynamic>> openDirectoryWorker(
  (Uint8List, String) input,
) async => (await DirectoryArchive.open(input.$1, input.$2)).data;
