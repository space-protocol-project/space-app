import 'dart:typed_data';

import 'local_lifecycle_record.dart';

typedef CatalogEntry = ({String name, String handle});
typedef CatalogPage = ({List<CatalogEntry> entries, String? next});
typedef CatalogChunk = ({Uint8List bytes, bool eof});

abstract interface class LocalCatalogPicker {
  Future<LocalCatalogRoot> select(
    String instance,
    String package,
    void Function() guard,
  );
}

abstract class LocalCatalogRoot {
  final id = localGeneration();
  Future<CatalogPage> list(int limit, String? cursor);
  Future<CatalogChunk> read(String handle, int offset, int limit);
  void close();
}
