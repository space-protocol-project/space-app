import 'dart:io';

import 'registry_validation.dart';
import 'strict_json.dart';
import 'local_lifecycle_record.dart';

typedef GitManifest = ({
  String plugin,
  String version,
  int schema,
  List<String> permissions,
});

GitManifest gitManifest(List<int> bytes, {String? platform}) {
  final data = registryObject(extensionJson(bytes));
  registryKeys(data, [
    'format',
    'plugin_id',
    'version',
    'profile',
    'modules',
    'contributions',
  ]);
  if (data['format'] != 'space.package-profile.p1' ||
      data['profile'] != 'client' ||
      data['contributions'] is! List ||
      (data['contributions'] as List).isNotEmpty) {
    throw const FormatException('ClientProfileUnsupported');
  }
  final plugin = data['plugin_id'] as String,
      version = data['version'] as String;
  if (plugin.length > 128 ||
      !RegExp(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9_-]*)+$').hasMatch(plugin) ||
      version.length > 32 ||
      !RegExp(r'^[0-9]+\.[0-9]+\.[0-9]+$').hasMatch(version)) {
    throw const FormatException('ClientIdentity');
  }
  final modules = registryObject(data['modules']);
  registryKeys(modules, ['client']);
  final module = registryObject(modules['client']);
  _module(module, platform ?? Platform.operatingSystem);
  return (
    plugin: plugin,
    version: version,
    schema: module['data_schema'] as int,
    permissions: List<String>.unmodifiable(
      (module['permissions'] as List).cast<String>(),
    ),
  );
}

void _module(Map<String, Object?> module, String platform) {
  registryKeys(module, [
    'entrypoint',
    'host_api',
    'wasm_abi',
    'data_schema',
    'permissions',
    'platforms',
  ]);
  if (module['entrypoint'] != 'client.wasm' ||
      module['host_api'] != 'space.client.p1' ||
      module['wasm_abi'] != 'space_client_p1') {
    throw const FormatException('ClientAbiUnsupported');
  }
  registrySchema(module['data_schema']);
  validateRequested(module['permissions']);
  final platforms = (module['platforms'] as List).cast<String>();
  if (platforms.isEmpty ||
      platforms.length > 3 ||
      platforms.toSet().length != platforms.length ||
      !platforms.every(['windows', 'linux', 'macos'].contains) ||
      !platforms.contains(platform)) {
    throw const FormatException('ClientPlatformUnsupported');
  }
}

// Структурный допуск хранения. Полная валидация инструкций и запуск принадлежат
// будущему изолированному WASM-хосту; установка остаётся отключённой.
void gitWasmShape(List<int> bytes) {
  if (bytes.length < 8 ||
      bytes.length > 4 * 1024 * 1024 ||
      bytes.take(8).join(',') != '0,97,115,109,1,0,0,0') {
    throw const FormatException('WasmHeader');
  }
  final reader = _Wasm(bytes)..offset = 8;
  var order = 0;
  while (reader.offset < bytes.length) {
    order = reader.section(order);
  }
}

class _Wasm {
  _Wasm(this.bytes);
  final List<int> bytes;
  int offset = 0;
  int section(int order) {
    final id = bytes[offset++];
    final length = number();
    final end = offset + length;
    if (id > 12 || end > bytes.length || id == 8) {
      throw const FormatException('WasmSection');
    }
    if (id == 2 && (length != 1 || bytes[offset] != 0)) {
      throw const FormatException('WasmImportsUnsupported');
    }
    offset = end;
    if (id == 0) return order;
    final rank = id == 12 ? 19 : id * 2;
    if (rank <= order) throw const FormatException('WasmOrder');
    return rank;
  }

  int number() {
    var value = 0;
    for (var shift = 0; shift < 35; shift += 7) {
      if (offset >= bytes.length) throw const FormatException('WasmLength');
      final byte = bytes[offset++];
      value |= (byte & 127) << shift;
      if (byte < 128) return value;
    }
    throw const FormatException('WasmLength');
  }
}
