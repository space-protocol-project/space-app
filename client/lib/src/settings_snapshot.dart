import 'dart:convert';
import 'dart:math';

import 'directory_validation.dart';

const settingsDefaults = <String, dynamic>{
  'themeMode': 'dark',
  'effects': true,
  'palette': 'gruvbox',
  'language': 'ru',
  'sendShortcut': 'enter',
  'uiScale': 1.0,
  'notificationMode': 0,
};
const settingsFields =
    'effects,language,notificationMode,palette,sendShortcut,themeMode,uiScale';
typedef SettingsClock = Map<String, int>;

enum SettingsChoice { local, incoming }

Map<String, dynamic> checkedDirectorySettings(Object? value) {
  final data = directoryMap(value, settingsFields);
  directoryRequire(['system', 'light', 'dark'].contains(data['themeMode']));
  directoryRequire(data['effects'] is bool);
  directoryRequire(['gruvbox', 'ocean', 'iris'].contains(data['palette']));
  directoryRequire(['ru', 'en', 'zh-Hans'].contains(data['language']));
  directoryRequire(['enter', 'shiftEnter'].contains(data['sendShortcut']));
  directoryRequire([0.75, 0.9, 1.0, 1.1, 1.25, 1.5].contains(data['uiScale']));
  directoryInt(data['notificationMode'], max: 2);
  return Map.unmodifiable(data);
}

String newSettingsActor() {
  final random = Random.secure();
  return base64UrlEncode(List.generate(16, (_) => random.nextInt(256)))
      .replaceAll('=', '');
}

SettingsClock checkedSettingsClock(Object? value) {
  directoryRequire(value is Map<String, dynamic>);
  final data = value as Map<String, dynamic>;
  directoryRequire(data.length <= 32);
  final keys = data.keys.toList()..sort();
  return Map.unmodifiable({
    for (final key in keys)
      directoryBytes(key, 16): directoryInt(data[key], min: 1),
  });
}

SettingsClock joinSettingsClocks(SettingsClock a, SettingsClock b) =>
    checkedSettingsClock(<String, dynamic>{
      ...a,
      for (final MapEntry(:key, :value) in b.entries)
        key: max(a[key] ?? 0, value),
    });

bool settingsCovers(SettingsClock a, SettingsClock b) =>
    b.entries.every((entry) => (a[entry.key] ?? 0) >= entry.value);

SettingsClock advanceSettingsClock(SettingsClock clock, String actor) =>
    checkedSettingsClock(<String, dynamic>{
      ...clock,
      actor: (clock[actor] ?? 0) + 1,
    });

class SettingsSnapshot {
  SettingsSnapshot._(this.values, this.versions);
  final Map<String, dynamic> values;
  final Map<String, SettingsClock> versions;
  factory SettingsSnapshot.create(Object? values, Object? versions) {
    final valid = checkedDirectorySettings(values);
    final clocks = directoryMap(versions, settingsFields);
    return SettingsSnapshot._(
      Map.unmodifiable({
        for (final key in settingsDefaults.keys)
          key: key == 'uiScale' ? (valid[key] as num).toDouble() : valid[key],
      }),
      Map.unmodifiable({
        for (final key in settingsDefaults.keys)
          key: checkedSettingsClock(clocks[key]),
      }),
    );
  }
  factory SettingsSnapshot.parse(Object? value) {
    final data = directoryMap(value, 'values,versions');
    return SettingsSnapshot.create(data['values'], data['versions']);
  }
  factory SettingsSnapshot.initial(Map<String, dynamic> values) =>
      SettingsSnapshot.create(values, {
        for (final key in settingsDefaults.keys) key: <String, dynamic>{},
      });
  Map<String, dynamic> get data => {'values': values, 'versions': versions};
  bool same(SettingsSnapshot other) =>
      jsonEncode(data) == jsonEncode(other.data);

  SettingsSnapshot observe(Map<String, dynamic> next, String actor) {
    checkedDirectorySettings(next);
    return SettingsSnapshot.create(next, {
      for (final key in settingsDefaults.keys)
        key: values[key] == next[key]
            ? versions[key]!
            : advanceSettingsClock(versions[key]!, actor),
    });
  }
}

class SettingsReplica {
  SettingsReplica()
    : actor = newSettingsActor(),
      snapshot = SettingsSnapshot.initial(settingsDefaults);
  SettingsReplica._(this.actor, this.snapshot);
  final String actor;
  SettingsSnapshot snapshot;
  factory SettingsReplica.parse(String raw) {
    directoryRequire(utf8.encode(raw).length <= 32768);
    final data = directoryMap(jsonDecode(raw), 'actor,settings,v');
    directoryInt(data['v'], min: 1, max: 1);
    return SettingsReplica._(
      directoryBytes(data['actor'], 16),
      SettingsSnapshot.parse(data['settings']),
    );
  }
  String encode() =>
      jsonEncode({'v': 1, 'actor': actor, 'settings': snapshot.data});
  void seed(Map<String, dynamic> values) {
    snapshot = SettingsSnapshot.create(values, {
      for (final key in settingsDefaults.keys) key: {actor: 1},
    });
  }
}

class SettingsMerge {
  SettingsMerge(this.local, this.incoming, {this.unknown = false});
  final SettingsSnapshot local, incoming;
  final bool unknown;
  bool conflict(String key) {
    if (local.values[key] == incoming.values[key]) return false;
    if (unknown) return true;
    final a = local.versions[key]!, b = incoming.versions[key]!;
    return settingsCovers(a, b) == settingsCovers(b, a);
  }

  List<String> get conflicts => settingsDefaults.keys.where(conflict).toList();
  bool resolved(Map<String, SettingsChoice> choices) =>
      conflicts.every(choices.containsKey);

  ({Object value, SettingsClock clock}) _field(
    String key,
    String actor,
    SettingsChoice? choice,
  ) {
    final a = local.versions[key]!, b = incoming.versions[key]!;
    if (local.values[key] == incoming.values[key]) {
      return (
        value: local.values[key] as Object,
        clock: joinSettingsClocks(a, b),
      );
    }
    if (conflict(key)) {
      directoryRequire(choice != null);
      return (
        value:
            (choice == SettingsChoice.local
                    ? local.values[key]
                    : incoming.values[key])
                as Object,
        clock: advanceSettingsClock(joinSettingsClocks(a, b), actor),
      );
    }
    return settingsCovers(a, b)
        ? (value: local.values[key] as Object, clock: a)
        : (value: incoming.values[key] as Object, clock: b);
  }

  SettingsSnapshot resolve(String actor, Map<String, SettingsChoice> choices) {
    directoryRequire(
      choices.keys.every(conflicts.contains) && resolved(choices),
    );
    final values = <String, dynamic>{}, versions = <String, dynamic>{};
    for (final key in settingsDefaults.keys) {
      final (:value, :clock) = _field(key, actor, choices[key]);
      values[key] = value;
      versions[key] = clock;
    }
    return SettingsSnapshot.create(values, versions);
  }
}

SettingsSnapshot resumeSettingsSnapshot(
  SettingsSnapshot before,
  SettingsSnapshot target,
  SettingsSnapshot current,
  String actor,
) {
  final values = <String, dynamic>{}, versions = <String, dynamic>{};
  for (final key in settingsDefaults.keys) {
    final now = current.versions[key]!, after = target.versions[key]!;
    final changedLater =
        (now[actor] ?? 0) > (before.versions[key]![actor] ?? 0);
    final keep = settingsCovers(now, after) || changedLater;
    values[key] = keep ? current.values[key] : target.values[key];
    versions[key] = _resumeClock(now, after, actor, changedLater);
  }
  return SettingsSnapshot.create(values, versions);
}

SettingsClock _resumeClock(
  SettingsClock current,
  SettingsClock target,
  String actor,
  bool changedLater,
) {
  if (settingsCovers(current, target)) return current;
  if (changedLater) {
    return advanceSettingsClock(joinSettingsClocks(current, target), actor);
  }
  return target;
}

(SettingsSnapshot, SettingsSnapshot) checkedSettingsPending(Object? value) {
  final data = directoryMap(value, 'after,before,v');
  directoryInt(data['v'], min: 2, max: 2);
  final before = SettingsSnapshot.parse(data['before']),
      after = SettingsSnapshot.parse(data['after']);
  for (final key in settingsDefaults.keys) {
    directoryRequire(
      settingsCovers(after.versions[key]!, before.versions[key]!),
    );
    if (before.values[key] != after.values[key]) {
      directoryRequire(
        !settingsCovers(before.versions[key]!, after.versions[key]!),
      );
    }
  }
  return (before, after);
}
