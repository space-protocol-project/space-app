import 'dart:convert';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart' as cross;
import 'package:file_selector/file_selector.dart' as picker;

export 'package:file_selector/file_selector.dart'
    hide XFile, openFile, openFiles;

/// Файл приложения с известным именем и независимым сроком хранения данных.
class SpaceFile {
  SpaceFile(String path)
    : this._(cross.XFile.fileSystem(path: path), null, path);

  SpaceFile.transient(cross.XFile source, {required String name})
    : this._(source, null, source.uri, name: name, transient: true);

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

  final cross.XFile? _source;
  final Uint8List? _bytes;
  final String path;
  final String name;
  final bool transient;

  static Future<SpaceFile> fromSource(cross.XFile source) async {
    final name = await source.name() ?? 'file';
    final location = source is cross.FileSystemXFile ? source.path : source.uri;
    return SpaceFile._(source, null, location, name: name);
  }

  Future<int?> declaredLength() async =>
      _bytes?.length ?? await _source!.length();

  Future<int> length() async => await declaredLength() ?? 0;

  Future<Uint8List> readAsBytes() async =>
      _bytes == null ? _source!.readAsBytes() : Uint8List.fromList(_bytes);

  Stream<Uint8List> openRead([int? start, int? end]) => _bytes == null
      ? _source!.openRead(start, end)
      : Stream.value(Uint8List.sublistView(_bytes, start ?? 0, end));

  Future<String> readAsString({Encoding encoding = utf8}) async =>
      encoding.decode(await readAsBytes());

  Future<void> saveTo(String destination) async {
    await cross.FileSystemXFile(destination).writeAsBytes(await readAsBytes());
  }
}

Future<SpaceFile?> openFile({
  List<picker.XTypeGroup> acceptedTypeGroups = const [],
}) async {
  final selected = await picker.openFile(
    acceptedTypeGroups: acceptedTypeGroups,
  );
  return selected == null ? null : SpaceFile.fromSource(selected);
}

Future<List<SpaceFile>> openFiles({
  List<picker.XTypeGroup> acceptedTypeGroups = const [],
}) async {
  final selected = await picker.openFiles(
    acceptedTypeGroups: acceptedTypeGroups,
  );
  return Future.wait(selected.map(SpaceFile.fromSource));
}
