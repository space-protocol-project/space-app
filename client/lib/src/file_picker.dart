import 'dart:typed_data';

import 'package:cross_file/cross_file.dart' as cross;
import 'package:file_selector/file_selector.dart' as picker;

import 'files.dart';

export 'files.dart';

export 'package:file_selector/file_selector.dart'
    hide XFile, openFile, openFiles;

class _CrossFileSource implements SpaceFileSource {
  _CrossFileSource(this.file);
  final cross.XFile file;
  @override
  Future<int?> length() => file.length();
  @override
  Future<Uint8List> readAsBytes() => file.readAsBytes();
  @override
  Stream<List<int>> openRead([int? start, int? end]) =>
      file.openRead(start, end);
}

SpaceFile droppedFile(cross.XFile source, {required String name}) =>
    SpaceFile.source(
      _CrossFileSource(source),
      path: source.uri,
      name: name,
      transient: true,
    );

Future<SpaceFile> _selectedFile(cross.XFile source) async => SpaceFile.source(
  _CrossFileSource(source),
  path: source is cross.FileSystemXFile ? source.path : source.uri,
  name: await source.name() ?? 'file',
);

Future<SpaceFile?> openFile({
  List<picker.XTypeGroup> acceptedTypeGroups = const [],
}) async {
  final selected = await picker.openFile(
    acceptedTypeGroups: acceptedTypeGroups,
  );
  return selected == null ? null : _selectedFile(selected);
}

Future<List<SpaceFile>> openFiles({
  List<picker.XTypeGroup> acceptedTypeGroups = const [],
}) async {
  final selected = await picker.openFiles(
    acceptedTypeGroups: acceptedTypeGroups,
  );
  return Future.wait(selected.map(_selectedFile));
}
