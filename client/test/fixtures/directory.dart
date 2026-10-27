import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_document.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/settings_snapshot.dart';

class DirectoryStorage implements SecureKeyStorage {
  final values = <String, String>{};
  bool fail = false;
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    if (fail) throw StateError('storage failure');
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }
}

class DirectoryVault implements IdentityVault {
  final records = <String, DeviceRecord>{};
  @override
  Future<DeviceRecord?> load(String origin) async => records[origin];
  @override
  Future<void> save(DeviceRecord record) async {
    records[record.origin] = record;
  }
}

Map<String, dynamic> directorySettings() => {
  'themeMode': 'system',
  'effects': true,
  'palette': 'iris',
  'language': 'ru',
  'sendShortcut': 'enter',
  'uiScale': 1.0,
  'notificationMode': 1,
};
Map<String, dynamic> directorySpace({int count = 1}) => {
  'origin': 'https://space.example',
  'endpoint': 'https://space.example',
  'server_id': 'srv_example',
  'server_key': url64(List.filled(32, 2)),
  'tls_fingerprint': 'a' * 64,
  'endpoint_revision': 0,
  'endpoint_digest': '',
  'principal_id': 'u_${'b' * 64}',
  'following_status': 'complete',
  'following_revision': 2,
  'following': List.generate(
    count,
    (i) => 'u_${i.toRadixString(16).padLeft(64, '0')}',
  ),
};
DirectoryDocument directoryDocument({
  int version = 2,
  int revision = 1,
  String parent = '',
  int count = 1,
}) => DirectoryDocument.parse({
  'v': version,
  'kind': 'space.directory',
  'id': url64(List.filled(16, 1)),
  'revision': revision,
  'parent': parent,
  'created': 1793000000,
  'settings': directorySettings(),
  if (version == 2)
    'settings_versions': {
      for (final key in settingsDefaults.keys)
        key: {url64(List.filled(16, 12)): 1},
    },
  'spaces': [directorySpace(count: count)],
});
