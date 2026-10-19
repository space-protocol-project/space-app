import 'package:shared_preferences/shared_preferences.dart';

// Переносим пользовательское состояние, но не пути установщиков и команду
// автоматического запуска сервера после обновления на прежней ОС.
bool portablePreference(String key) =>
    key.startsWith('space.') && !key.startsWith('space.update.');

Map<String, dynamic> readDeviceSettings(SharedPreferences preferences) => {
  for (final key in preferences.getKeys())
    if (portablePreference(key)) key: preferences.get(key),
};

void validateDeviceSettings(Map<String, dynamic> settings) {
  for (final entry in settings.entries) {
    if (!portablePreference(entry.key) || !_validValue(entry.value)) {
      throw const FormatException('Некорректные настройки устройства');
    }
  }
}

bool _validValue(Object? value) => switch (value) {
  String() || bool() || int() => true,
  double() => value.isFinite,
  List() => value.every((item) => item is String),
  _ => false,
};

Future<void> writeDeviceSettings(
  SharedPreferences preferences,
  Map<String, dynamic> settings,
) async {
  validateDeviceSettings(settings);
  for (final entry in settings.entries) {
    final saved = await _write(preferences, entry.key, entry.value);
    if (!saved) throw StateError('Не удалось сохранить настройки устройства');
  }
}

Future<bool> _write(SharedPreferences preferences, String key, Object value) =>
    switch (value) {
      String() => preferences.setString(key, value),
      bool() => preferences.setBool(key, value),
      int() => preferences.setInt(key, value),
      double() => preferences.setDouble(key, value),
      List() => preferences.setStringList(key, value.cast<String>()),
      _ => throw const FormatException('Неизвестный тип настройки'),
    };
