import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'git_source.dart';
import 'github_transport.dart';

class GithubObjects {
  GithubObjects(this.transport, String repository)
    : prefix = '/repos${Uri.parse(repository).path}';
  final GitObjectTransport transport;
  final String prefix;

  Future<({String commit, Map<String, String> files})> tree(
    String ref,
    String path,
  ) async {
    gitRef(ref);
    gitPath(path);
    final commit = await transport.get(
      '$prefix/commits/${Uri.encodeComponent(ref)}',
    );
    final id = commit['sha'];
    gitObjectId(id);
    if (RegExp(r'^[0-9a-f]{40}$').hasMatch(ref) && id != ref) {
      throw StateError('GitBinding');
    }
    var treeId = commit['commit']['tree']['sha'] as String;
    gitObjectId(treeId);
    for (final segment in path.split('/')) {
      final entries = await _tree(treeId);
      final selected = entries
          .where((e) => (e as Map)['path'] == segment)
          .toList();
      if (selected.length != 1 ||
          selected.single['type'] != 'tree' ||
          selected.single['mode'] != '040000') {
        throw StateError('GitPath');
      }
      treeId = selected.single['sha'] as String;
      gitObjectId(treeId);
    }
    return (commit: id as String, files: _files(await _tree(treeId)));
  }

  Future<List> _tree(String id) async {
    final tree = await transport.get('$prefix/git/trees/$id');
    if (tree['sha'] != id ||
        tree['truncated'] != false ||
        (tree['tree'] as List).length > 2048) {
      throw StateError('GitLimit');
    }
    return tree['tree'] as List;
  }

  Map<String, String> _files(List entries) {
    if (entries.length > 2048) throw StateError('GitLimit');
    final result = <String, String>{};
    final names = <String>{};
    for (final entry in entries) {
      _entry(entry as Map, names, result);
    }
    return Map.unmodifiable(result);
  }

  void _entry(Map entry, Set<String> names, Map<String, String> result) {
    final path = entry['path'] as String;
    _path(path, names);
    gitObjectId(entry['sha']);
    if (entry['type'] != 'blob' ||
        !['100644', '100755'].contains(entry['mode']) ||
        entry['size'] is! int ||
        (entry['size'] as int) > 4 * 1024 * 1024 ||
        (entry['size'] as int) < 0) {
      throw StateError('GitUnsupported');
    }
    result[path] = entry['sha'] as String;
  }

  void _path(String path, Set<String> names) {
    if (path.length > 512 ||
        path.startsWith('/') ||
        path.contains('\\') ||
        path.split('/').any((p) => p.isEmpty || p == '.' || p == '..') ||
        !names.add(path.toLowerCase())) {
      throw StateError('GitPath');
    }
    final name = path.split('/').last.toLowerCase();
    if (name == '.gitmodules' || name == '.gitattributes') {
      throw StateError('GitUnsupported');
    }
  }

  Future<Uint8List> blob(Map<String, String> files, String path) async {
    final id = files[path];
    if (id == null) throw StateError('GitPackageMissing');
    final data = await transport.get('$prefix/git/blobs/$id');
    if (data['sha'] != id || data['encoding'] != 'base64') {
      throw StateError('GitBinding');
    }
    final bytes = base64Decode(
      (data['content'] as String).replaceAll('\n', ''),
    );
    if (bytes.length > 4 * 1024 * 1024 ||
        data['size'] != bytes.length ||
        sha1.convert([
              ...utf8.encode('blob ${bytes.length}\u0000'),
              ...bytes,
            ]).toString() !=
            id) {
      throw StateError('GitBinding');
    }
    if (utf8
        .decode(bytes.take(100).toList(), allowMalformed: true)
        .startsWith('version https://git-lfs.github.com/spec/')) {
      throw StateError('GitUnsupported');
    }
    return bytes;
  }
}
