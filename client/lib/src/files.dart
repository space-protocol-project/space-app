import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Файл приложения с известным именем и независимым сроком хранения данных.
class SpaceFile {
  SpaceFile(String path) : this._(_LocalFileSource(File(path)), null, path);

  SpaceFile.source(
    SpaceFileSource source, {
    required String path,
    required String name,
    bool transient = false,
  }) : this._(source, null, path, name: name, transient: transient);

  SpaceFile.fromData(
    Uint8List data, {
    String? name,
    String? path,
    String? mimeType,
  }) : this._(null, Uint8List.fromList(data), path ?? name ?? '', name: name);

  SpaceFile._(
    this._source,
    this._bytes,
    this.path, {
    String? name,
    this.transient = false,
  }) : name = name ?? path.split(RegExp(r'[/\\]')).last;

  final SpaceFileSource? _source;
  final Uint8List? _bytes;
  final String path;
  final String name;
  final bool transient;

  Future<int?> declaredLength() async =>
      _bytes?.length ?? await _source!.length();

  Future<int> length() async => await declaredLength() ?? 0;

  Future<Uint8List> readAsBytes() async =>
      _bytes == null ? _source!.readAsBytes() : Uint8List.fromList(_bytes);

  Stream<List<int>> openRead([int? start, int? end]) => _bytes == null
      ? _source!.openRead(start, end)
      : Stream.value(Uint8List.sublistView(_bytes, start ?? 0, end));

  Future<String> readAsString({Encoding encoding = utf8}) async =>
      encoding.decode(await readAsBytes());

  Future<void> saveTo(String destination) async {
    await File(destination).writeAsBytes(await readAsBytes(), flush: true);
  }
}

abstract interface class SpaceFileSource {
  Future<int?> length();
  Future<Uint8List> readAsBytes();
  Stream<List<int>> openRead([int? start, int? end]);
}

class _LocalFileSource implements SpaceFileSource {
  _LocalFileSource(this.file);
  final File file;
  @override
  Future<int> length() => file.length();
  @override
  Future<Uint8List> readAsBytes() => file.readAsBytes();
  @override
  Stream<List<int>> openRead([int? start, int? end]) =>
      file.openRead(start, end);
}
