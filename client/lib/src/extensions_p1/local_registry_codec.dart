import 'dart:convert';

const registryFrameLimit = 131072;
const registryJournalLimit = 8388608;

void validateRegistryName(String value) {
  if (!RegExp(r'^[a-z][a-z0-9_-]{0,63}$').hasMatch(value)) {
    throw const FormatException('registry_name');
  }
}

void registryKeys(Map<String, Object?> value, List<String> keys) {
  if (value.length != keys.length || !keys.every(value.containsKey)) {
    throw const FormatException('registry_fields');
  }
}

Map<String, Object?> registryObject(Object? value) {
  if (value is! Map<String, dynamic>) {
    throw const FormatException('registry_object');
  }
  return value.cast<String, Object?>();
}

void registryDigest(Object? value) {
  if (value is! String || !RegExp(r'^[0-9a-f]{64}$').hasMatch(value)) {
    throw const FormatException('registry_digest');
  }
}

void registrySchema(Object? value) {
  if (value is! int || value < 1 || value > 65535) {
    throw const FormatException('registry_schema');
  }
}

void validateRegistryEntries(Map<String, Map<String, Object?>> entries) {
  if (entries.length > 32) throw const FormatException('registry_entry_limit');
  for (final item in entries.entries) {
    validateRegistryName(item.key);
    _validateEntry(item.value);
  }
}

void _validateEntry(Map<String, Object?> entry) {
  registryKeys(entry, [
    'installation',
    'package',
    'schema',
    'state',
    'data',
    'staged',
  ]);
  final installation = entry['installation'];
  if (installation is! String) throw const FormatException('installation');
  validateRegistryName(installation);
  registryDigest(entry['package']);
  registrySchema(entry['schema']);
  if (![
    'disabled',
    'enabled',
    'removed',
    'updating',
    'ready',
    'quarantined',
  ].contains(entry['state'])) {
    throw const FormatException('registry_state');
  }
  _validateData(entry['data']);
  final staged = entry['staged'];
  if (staged != null) _validateStaged(registryObject(staged));
  final pending = ['updating', 'ready'].contains(entry['state']);
  if (pending && staged == null) throw const FormatException('missing_stage');
}

void _validateData(Object? data) {
  if (data is! String || utf8.encode(data).length > 16384) {
    throw const FormatException('registry_data_limit');
  }
  jsonDecode(data);
}

void _validateStaged(Map<String, Object?> staged) {
  registryKeys(staged, ['package', 'schema', 'data', 'cursor']);
  registryDigest(staged['package']);
  registrySchema(staged['schema']);
  _validateData(staged['data']);
  final cursor = staged['cursor'];
  if (cursor is! int || cursor < 0 || cursor > 32) {
    throw const FormatException('registry_cursor');
  }
}

Map<String, Map<String, Object?>> copyRegistryEntries(
  Map<String, Map<String, Object?>> entries,
) => decodeRegistryEntries(jsonDecode(jsonEncode(entries)));

Map<String, Map<String, Object?>> decodeRegistryEntries(Object? value) {
  final result = <String, Map<String, Object?>>{};
  for (final item in registryObject(value).entries) {
    result[item.key] = registryObject(item.value);
  }
  validateRegistryEntries(result);
  return result;
}

class RegistrySnapshot {
  const RegistrySnapshot({
    required this.scope,
    required this.revision,
    required this.generation,
    required this.entries,
    required this.action,
    required this.previous,
  });

  final String scope;
  final int revision;
  final String generation;
  final Map<String, Map<String, Object?>> entries;
  final String action;
  final String previous;

  String encode() => jsonEncode({
    'version': 1,
    'scope': scope,
    'revision': revision,
    'generation': generation,
    'entries': entries,
    'action': action,
    'previous': previous,
  });

  static RegistrySnapshot initial(String scope) => RegistrySnapshot(
    scope: scope,
    revision: 0,
    generation: '0' * 32,
    entries: const {},
    action: 'initial',
    previous: '0' * 64,
  );

  static RegistrySnapshot decode(String raw, String scope) {
    final value = registryObject(jsonDecode(raw));
    registryKeys(value, [
      'version',
      'scope',
      'revision',
      'generation',
      'entries',
      'action',
      'previous',
    ]);
    final revision = value['revision'];
    final generation = value['generation'];
    if (value['version'] != 1 ||
        value['scope'] != scope ||
        revision is! int ||
        revision < 1 ||
        revision > 2147483646) {
      throw const FormatException('registry_header');
    }
    if (generation is! String ||
        !RegExp(r'^[0-9a-f]{32}$').hasMatch(generation)) {
      throw const FormatException('registry_generation');
    }
    final action = value['action'];
    if (action is! String) throw const FormatException('registry_action');
    validateRegistryName(action);
    registryDigest(value['previous']);
    return RegistrySnapshot(
      scope: scope,
      revision: revision,
      generation: generation,
      entries: decodeRegistryEntries(value['entries']),
      action: action,
      previous: value['previous']! as String,
    );
  }
}
