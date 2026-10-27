import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'core.dart' show url64, parseConnectionInput;

const directoryMaxPlain = 4 * 1024 * 1024;
const directoryMaxInteger = 9007199254740991;

void directoryRequire(bool condition) {
  if (!condition) throw const FormatException('Повреждена копия каталога');
}

Map<String, dynamic> directoryMap(Object? value, String fields) {
  directoryRequire(value is Map<String, dynamic>);
  final map = value as Map<String, dynamic>;
  final keys = map.keys.toList()..sort();
  directoryRequire(keys.join(',') == fields);
  return map;
}

String directoryText(Object? value, {int max = 1024}) {
  directoryRequire(value is String);
  final text = value as String;
  directoryRequire(utf8.encode(text).length <= max && !text.contains('\u0000'));
  return text;
}

int directoryInt(Object? value, {int min = 0, int max = directoryMaxInteger}) {
  directoryRequire(value is int);
  final number = value as int;
  directoryRequire(number >= min && number <= max);
  return number;
}

String directoryBytes(Object? value, int length) {
  final text = directoryText(value, max: 128);
  final bytes = base64Url.decode(base64Url.normalize(text));
  directoryRequire(bytes.length == length && url64(bytes) == text);
  return text;
}

String directoryAddress(Object? value) {
  final text = directoryText(value);
  final uri = Uri.parse(text);
  directoryRequire(
    ['http', 'https'].contains(uri.scheme) && uri.host.isNotEmpty,
  );
  directoryRequire(uri.userInfo.isEmpty && !uri.hasQuery && !uri.hasFragment);
  return text;
}

Map<String, dynamic> checkedDirectorySettings(Object? value) {
  final data = directoryMap(
    value,
    'effects,language,notificationMode,palette,sendShortcut,themeMode,uiScale',
  );
  directoryRequire(['system', 'light', 'dark'].contains(data['themeMode']));
  directoryRequire(data['effects'] is bool);
  directoryRequire(['gruvbox', 'ocean', 'iris'].contains(data['palette']));
  directoryRequire(['ru', 'en', 'zh-Hans'].contains(data['language']));
  directoryRequire(['enter', 'shiftEnter'].contains(data['sendShortcut']));
  directoryRequire([0.75, 0.9, 1.0, 1.1, 1.25, 1.5].contains(data['uiScale']));
  directoryInt(data['notificationMode'], max: 2);
  return Map.unmodifiable(data);
}

Map<String, dynamic> checkedDirectorySpace(Object? value) {
  final data = directoryMap(
    value,
    'endpoint,endpoint_digest,endpoint_revision,following,following_revision,following_status,origin,principal_id,server_id,server_key,tls_fingerprint',
  );
  final origin = directoryAddress(data['origin']);
  directoryRequire(Uri.parse(origin).path.isEmpty && parseConnectionInput(origin).origin.toString() == origin);
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
  List<Map<String, dynamic>> get spaces =>
      data['spaces'] as List<Map<String, dynamic>>;
  List<int> encode() => utf8.encode(jsonEncode(data));
  Future<String> digest() async => url64((await Sha256().hash(encode())).bytes);

  factory DirectoryDocument.parse(Object? value) {
    final data = directoryMap(
      value,
      'created,id,kind,parent,revision,settings,spaces,v',
    );
    directoryRequire(data['kind'] == 'space.directory');
    directoryInt(data['v'], min: 1, max: 1);
    directoryBytes(data['id'], 16);
    directoryInt(data['revision'], min: 1);
    final parent = directoryText(data['parent'], max: 43);
    if (parent.isNotEmpty) directoryBytes(parent, 32);
    directoryRequire((data['revision'] == 1) == parent.isEmpty);
    directoryInt(data['created'], min: 1);
    final settings = checkedDirectorySettings(data['settings']);
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
        'settings': settings,
        'spaces': List<Map<String, dynamic>>.unmodifiable(spaces),
      }),
    );
    directoryRequire(result.encode().length <= directoryMaxPlain);
    return result;
  }
}
