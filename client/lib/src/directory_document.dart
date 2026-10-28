import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'core.dart' show url64, parseConnectionInput;
import 'directory_ancestry.dart';
import 'directory_validation.dart';
import 'portable_voice_merge.dart';
import 'settings_snapshot.dart';
export 'directory_validation.dart';
export 'settings_snapshot.dart' show checkedDirectorySettings;

DirectoryDocument decodeDirectoryDocument(List<int> bytes) {
  directoryRequire(bytes.length <= directoryMaxPlain);
  final text = utf8.decode(bytes), data = jsonDecode(text);
  directoryRequire(jsonEncode(data) == text);
  return DirectoryDocument.parse(data);
}

Map<String, dynamic> checkedDirectorySpace(Object? value) {
  final data = directoryMap(
    value,
    'endpoint,endpoint_digest,endpoint_revision,following,following_revision,following_status,origin,principal_id,server_id,server_key,tls_fingerprint',
  );
  final origin = directoryAddress(data['origin']);
  directoryRequire(
    Uri.parse(origin).path.isEmpty &&
        parseConnectionInput(origin).origin.toString() == origin,
  );
  directoryAddress(data['endpoint']);
  directoryRequire(directoryText(data['server_id'], max: 128).isNotEmpty);
  directoryBytes(data['server_key'], 32);
  final tls = directoryText(data['tls_fingerprint'], max: 128);
  directoryRequire(tls.isEmpty || RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(tls));
  directoryInt(data['endpoint_revision']);
  final digest = directoryText(data['endpoint_digest'], max: 128);
  directoryRequire(
    digest.isEmpty || RegExp(r'^[a-f0-9]{64}$').hasMatch(digest),
  );
  directoryRequire(
    RegExp(r'^u_[a-f0-9]{64}$').hasMatch(directoryText(data['principal_id'])),
  );
  directoryInt(data['following_revision']);
  directoryRequire(
    ['complete', 'unavailable'].contains(data['following_status']),
  );
  final following = data['following'];
  directoryRequire(following is List && following.length <= 4096);
  final ids = (following as List)
      .map((id) => directoryText(id, max: 128))
      .toList();
  directoryRequire(ids.toSet().length == ids.length);
  directoryRequire(
    ids.every(
      (id) =>
          RegExp(r'^u_[a-f0-9]{64}$').hasMatch(id) &&
          id != data['principal_id'],
    ),
  );
  return Map.unmodifiable({
    ...data,
    'following': List<String>.unmodifiable(ids),
  });
}

class DirectoryDocument {
  DirectoryDocument._(this.data);
  final Map<String, dynamic> data;
  String get id => data['id'] as String;
  int get revision => data['revision'] as int;
  String get parent => data['parent'] as String;
  Map<String, dynamic> get settings => data['settings'] as Map<String, dynamic>;
  bool get hasSettingsVersions => (data['v'] as int) >= 2;
  DirectoryAncestry? get ancestry => data['v'] == 3 || data['v'] == 5
      ? DirectoryAncestry.parse(data['ancestry'], revision, parent)
      : null;
  PortableVoiceSnapshot? get voiceSettings => (data['v'] as int) >= 4
      ? PortableVoiceSnapshot.parse(data['voice_settings'])
      : null;
  SettingsSnapshot get settingsSnapshot => hasSettingsVersions
      ? SettingsSnapshot.create(settings, data['settings_versions'])
      : SettingsSnapshot.initial(settings);
  List<Map<String, dynamic>> get spaces =>
      data['spaces'] as List<Map<String, dynamic>>;
  List<int> encode() => utf8.encode(jsonEncode(data));
  Future<String> digest() async => url64((await Sha256().hash(encode())).bytes);

  factory DirectoryDocument.parse(Object? value) {
    directoryRequire(value is Map<String, dynamic>);
    final version = directoryInt(
      (value as Map<String, dynamic>)['v'],
      min: 1,
      max: 5,
    );
    final fields = switch (version) {
      1 => 'created,id,kind,parent,revision,settings,spaces,v',
      2 =>
        'created,id,kind,parent,revision,settings,settings_versions,spaces,v',
      3 => 'ancestry,created,id,kind,parent,revision,settings,settings_versions,spaces,v',
      4 => 'created,id,kind,parent,revision,settings,settings_versions,spaces,v,voice_settings',
      _ => 'ancestry,created,id,kind,parent,revision,settings,settings_versions,spaces,v,voice_settings',
    };
    final data = directoryMap(value, fields);
    directoryRequire(data['kind'] == 'space.directory');
    directoryBytes(data['id'], 16);
    directoryInt(data['revision'], min: 1);
    final parent = directoryText(data['parent'], max: 43);
    if (parent.isNotEmpty) directoryBytes(parent, 32);
    directoryRequire((data['revision'] == 1) == parent.isEmpty);
    final ancestry = version == 3 || version == 5
        ? DirectoryAncestry.parse(
            data['ancestry'],
            data['revision'] as int,
            parent,
          )
        : null;
    final voice = version >= 4
        ? PortableVoiceSnapshot.parse(data['voice_settings'])
        : null;
    directoryInt(data['created'], min: 1);
    final settings = checkedDirectorySettings(data['settings']);
    final versioned = version >= 2
        ? SettingsSnapshot.create(settings, data['settings_versions'])
        : null;
    final raw = data['spaces'];
    directoryRequire(raw is List && raw.length <= 100);
    final spaces = (raw as List).map(checkedDirectorySpace).toList();
    directoryRequire(
      spaces.map((s) => s['origin']).toSet().length == spaces.length,
    );
    directoryRequire(
      spaces.map((s) => s['server_id']).toSet().length == spaces.length,
    );
    final result = DirectoryDocument._(
      Map.unmodifiable({
        ...data,
        if (voice != null)
          'voice_settings': Map<String, dynamic>.unmodifiable({
            'profile': Map<String, Object>.unmodifiable(voice.profile.data),
            'clock': voice.clock,
          }),
        if (ancestry != null)
          'ancestry': Map<String, dynamic>.unmodifiable({
            'first_revision': ancestry.firstRevision,
            'digests': ancestry.digests,
          }),
        'settings': settings,
        if (versioned != null) 'settings_versions': versioned.versions,
        'spaces': List<Map<String, dynamic>>.unmodifiable(spaces),
      }),
    );
    directoryRequire(result.encode().length <= directoryMaxPlain);
    if (version >= 2) {
      directoryRequire(utf8.decode(result.encode()) == jsonEncode(data));
    }
    return result;
  }
}
