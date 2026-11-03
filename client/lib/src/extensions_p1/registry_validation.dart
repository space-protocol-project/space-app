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
