import 'dart:convert';

import 'core.dart' show url64;
import 'directory_archive.dart';
import 'directory_document.dart';

class RemoteBackupEndpoint {
  RemoteBackupEndpoint(this.data);
  final Map<String, dynamic> data;
  String get origin => data['origin'] as String;
  String get fingerprint => data['tls'] as String;
  String get publicKey => data['key'] as String;
  String get readToken => data['read'] as String;
  String get writeToken => data['write'] as String;

  factory RemoteBackupEndpoint.parse(Object? value) {
    final data = directoryMap(value, 'key,origin,read,tls,write');
    final origin = directoryAddress(data['origin']);
    final uri = Uri.parse(origin);
    directoryRequire(
      uri.scheme == 'https' && uri.path.isEmpty && uri.toString() == origin,
    );
    directoryRequire(
      RegExp(r'^[a-f0-9]{64}$').hasMatch(directoryText(data['tls'])),
    );
    directoryBytes(data['key'], 32);
    directoryBytes(data['read'], 32);
    directoryBytes(data['write'], 32);
    directoryRequire(data['read'] != data['write']);
    return RemoteBackupEndpoint(Map.unmodifiable(data));
  }
  factory RemoteBackupEndpoint.create(String origin, String tls, String key) =>
      RemoteBackupEndpoint.parse({
        'origin': origin,
        'tls': tls.toLowerCase(),
        'key': key,
        'read': url64(DirectoryArchive.random(32)),
        'write': url64(DirectoryArchive.random(32)),
      });
}

class RemoteBackupKit {
  RemoteBackupKit(this.id, this.space);
  final String id;
  final RemoteBackupEndpoint space;
  Map<String, dynamic> get data => {
    'v': 1, 'kind': 'space.remote-backup', 'id': id, 'space': space.data,
  };
  String encode() => jsonEncode(data);
  factory RemoteBackupKit.parse(String raw) {
    directoryRequire(utf8.encode(raw).length <= 8192);
    final data = directoryMap(jsonDecode(raw), 'id,kind,space,v');
    directoryInt(data['v'], min: 1, max: 1);
    directoryRequire(data['kind'] == 'space.remote-backup');
    return RemoteBackupKit(directoryBytes(data['id'], 16), RemoteBackupEndpoint.parse(data['space']));
  }
}