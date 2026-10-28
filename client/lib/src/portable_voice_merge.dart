import 'directory_validation.dart';
import 'portable_voice_profile.dart';
import 'settings_snapshot.dart';

/// Проверенный снимок профиля и его причинной истории.
class PortableVoiceSnapshot {
  PortableVoiceSnapshot(this.profile, SettingsClock clock)
    : clock = checkedSettingsClock(clock);

  final PortableVoiceProfile profile;
  final SettingsClock clock;

  factory PortableVoiceSnapshot.parse(Object? value) {
    final data = directoryMap(value, 'clock,profile');
    return PortableVoiceSnapshot(
      PortableVoiceProfile.parse(data['profile']),
      checkedSettingsClock(data['clock']),
    );
  }

  Map<String, Object> get data => {'profile': profile.data, 'clock': clock};

  PortableVoiceSnapshot observe(PortableVoiceProfile next, String actor) =>
      next == profile
      ? this
      : PortableVoiceSnapshot(next, advanceSettingsClock(clock, actor));
}

/// Отсутствующий снимок в старой копии не меняет локальный профиль.
class PortableVoiceMerge {
  const PortableVoiceMerge(this.local, this.incoming);
  final PortableVoiceSnapshot local;
  final PortableVoiceSnapshot? incoming;

  bool get conflict {
    final other = incoming;
    if (other == null || local.profile == other.profile) return false;
    return settingsCovers(local.clock, other.clock) ==
        settingsCovers(other.clock, local.clock);
  }

  PortableVoiceSnapshot resolve(String actor, SettingsChoice? choice) {
    final other = incoming;
    if (other == null) return local;
    if (local.profile == other.profile) {
      return PortableVoiceSnapshot(
        local.profile,
        joinSettingsClocks(local.clock, other.clock),
      );
    }
    if (conflict) {
      directoryRequire(choice != null);
      return PortableVoiceSnapshot(
        choice == SettingsChoice.local ? local.profile : other.profile,
        advanceSettingsClock(
          joinSettingsClocks(local.clock, other.clock),
          actor,
        ),
      );
    }
    return settingsCovers(local.clock, other.clock) ? local : other;
  }
}

PortableVoiceSnapshot resumePortableVoice(
  PortableVoiceSnapshot before,
  PortableVoiceSnapshot target,
  PortableVoiceSnapshot current,
  String actor,
) {
  final changedLater = (current.clock[actor] ?? 0) > (before.clock[actor] ?? 0);
  if (settingsCovers(current.clock, target.clock)) return current;
  if (!changedLater) return target;
  return PortableVoiceSnapshot(
    current.profile,
    advanceSettingsClock(
      joinSettingsClocks(current.clock, target.clock),
      actor,
    ),
  );
}

/// Проверяет подготовленный результат перед продолжением восстановления.
({PortableVoiceSnapshot before, PortableVoiceSnapshot after})
checkedPortableVoicePending(Object? value) {
  final data = directoryMap(value, 'after,before,v');
  directoryInt(data['v'], min: 1, max: 1);
  final before = PortableVoiceSnapshot.parse(data['before']);
  final after = PortableVoiceSnapshot.parse(data['after']);
  directoryRequire(settingsCovers(after.clock, before.clock));
  if (before.profile != after.profile) {
    directoryRequire(!settingsCovers(before.clock, after.clock));
  }
  return (before: before, after: after);
}
