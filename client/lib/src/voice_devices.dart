import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'voice_device_preferences.dart';
import 'voice_audio_settings.dart';
import 'portable_voice_profile.dart';
import 'portable_voice_store.dart';
import 'portable_voice_merge.dart';
import 'voice_platform.dart';
import 'voice_audio_native.dart';

part 'voice_devices.freezed.dart';

class VoiceDevice {
  const VoiceDevice(this.id, this.label, {required this.input});
  final String id, label;
  final bool input;
}

abstract interface class VoiceDeviceBackend {
  Future<List<VoiceDevice>> devices();
  Future<void> select(VoiceDevice device);
}

class NativeVoiceDeviceBackend implements VoiceDeviceBackend {
  Future<List<VoiceDevice>>? _listing;

  @override
  Future<List<VoiceDevice>> devices() =>
      _listing ??= _enumerate().whenComplete(() => _listing = null);

  Future<List<VoiceDevice>> _enumerate() async {
    await VoiceAudioNative.initialize();
    var devices = await navigator.mediaDevices.enumerateDevices();
    if (!devices.any(
      (d) => d.kind == 'audioinput' || d.kind == 'audiooutput',
    )) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      devices = await navigator.mediaDevices.enumerateDevices();
    }
    return devices
        .where((device) => ['audioinput', 'audiooutput'].contains(device.kind))
        .map(
          (device) => VoiceDevice(
            device.deviceId,
            device.label,
            input: device.kind == 'audioinput',
          ),
        )
        .toList();
  }

  @override
  Future<void> select(VoiceDevice device) => device.input
      ? Helper.selectAudioInput(device.id)
      : Helper.selectAudioOutput(device.id);
}

@Freezed(equal: false)
abstract class VoiceDevicesState with _$VoiceDevicesState {
  const VoiceDevicesState._();
  const factory VoiceDevicesState({
    @Default([]) List<VoiceDevice> devices,
    @Default(false) bool busy,
    @Default('') String error,
    String? input,
    String? output,
    @Default(false) bool ready,
    @Default(VoiceAudioSettings()) VoiceAudioSettings audio,
  }) = _VoiceDevicesState;

  bool get inputUnavailable => _unavailable(input, true);
  bool get outputUnavailable => _unavailable(output, false);

  bool _unavailable(String? id, bool input) =>
      id != null &&
      !devices.any((device) => device.id == id && device.input == input);
}

class VoiceDevices extends Cubit<VoiceDevicesState> {
  VoiceDevices({
    VoiceDeviceBackend? backend,
    VoiceDevicePreferences? preferences,
  }) : backend = backend ?? NativeVoiceDeviceBackend(),
       preferences = preferences ?? SavedVoiceDevicePreferences(),
       super(const VoiceDevicesState());
  final VoiceDeviceBackend backend;
  final VoiceDevicePreferences preferences;
  VoiceDeviceChoice? _choice;
  final _applied = <bool, String>{};
  Future<void>? _refreshing;
  String _saveError = '';
  Future<void> Function(VoiceAudioSettings)? onAudioChanged;
  String Function()? portableActor;
  Future<void> Function()? beforeDeviceChanged;

  void _publish({
    List<VoiceDevice>? devices,
    bool busy = false,
    String? error,
    bool? ready,
  }) {
    if (isClosed) return;
    emit(
      VoiceDevicesState(
        devices: devices ?? state.devices,
        busy: busy,
        error: error ?? _saveError,
        ready: ready ?? state.ready,
        input: _choice?.input,
        output: _choice?.output,
        audio: _choice?.audio ?? voiceDefaultAudio,
      ),
    );
  }

  Future<void> refresh() {
    if (isClosed) return Future.value();
    if (_refreshing != null) return _refreshing!;
    if (state.busy) return Future.value();
    return _refreshing = _refresh().whenComplete(() => _refreshing = null);
  }

  Future<void> _refresh() async {
    _publish(busy: true);
    try {
      _choice ??= await preferences.load();
      if (isClosed) return;
      final devices = _unique(
        await backend.devices().timeout(const Duration(seconds: 2)),
      );
      if (isClosed) return;
      _publish(devices: devices, busy: true);
      await _restore(devices, _choice!.input, true);
      if (isClosed) return;
      await _restore(devices, _choice!.output, false);
      _publish(ready: true);
    } catch (error) {
      _publish(error: error.toString(), ready: false);
    }
  }

  List<VoiceDevice> _unique(List<VoiceDevice> devices) {
    final unique = <(bool, String), VoiceDevice>{};
    for (final device in devices) {
      if (device.id.isNotEmpty) unique[(device.input, device.id)] = device;
    }
    return List.unmodifiable(unique.values);
  }

  Future<void> _restore(
    List<VoiceDevice> devices,
    String? id,
    bool input,
  ) async {
    var available = devices.where((d) => d.id == id && d.input == input);
    final label = input ? _choice?.inputLabel : _choice?.outputLabel;
    if (available.isEmpty && label != null && label.isNotEmpty) {
      final matching = devices.where(
        (d) => d.label == label && d.input == input,
      );
      if (matching.length == 1) available = matching;
    }
    if (available.isEmpty) {
      _applied.remove(input);
      return;
    }
    final device = available.first;
    if (_applied[input] == device.id) return;
    await beforeDeviceChanged?.call();
    await backend.select(device).timeout(const Duration(seconds: 2));
    _applied[input] = device.id;
    _choice = _choice!.change(device.id, input: input, label: device.label);
    await _saveChoice();
  }

  Future<void> select(VoiceDevice device) async {
    final refreshing = _refreshing;
    if (refreshing != null) await refreshing;
    if (isClosed || state.busy || !_available(device)) return;
    _publish(busy: true);
    try {
      await beforeDeviceChanged?.call();
      await backend.select(device).timeout(const Duration(seconds: 2));
      if (isClosed) return;
      _applied[device.input] = device.id;
      _choice = (_choice ?? const VoiceDeviceChoice()).change(
        device.id,
        input: device.input,
        label: device.label,
      );
      // Выбор уже применён. Ошибка записи не должна скрывать активное устройство.
      await _saveChoice();
      _publish();
    } catch (error) {
      _applied.remove(device.input);
      _publish(error: error.toString(), ready: false);
    }
  }

  bool _available(VoiceDevice device) => state.devices.any(
    (current) => current.id == device.id && current.input == device.input,
  );

  /// Применяет обработку к выбранному устройству, сохраняя локальные параметры.
  Future<void> applyPortableProfile(PortableVoiceProfile profile) async {
    await PortableVoiceStore().exclusive(() => _applyPortableProfile(profile));
  }

  Future<void> _applyPortableProfile(PortableVoiceProfile profile) async {
    final refreshing = _refreshing;
    if (refreshing != null) await refreshing;
    if (_choice == null && !isClosed) await refresh();
    if (isClosed || state.busy || _choice == null || !state.ready) {
      throw StateError('Аудиоустройство не готово к восстановлению');
    }
    await _updateAudio(profile.apply(_choice!.audio));
    if (state.error.isNotEmpty) throw StateError(state.error);
  }

  Future<void> resumePortableVoice(Object pending, String actor) =>
      PortableVoiceStore().resume(
        pending: pending,
        actor: actor,
        currentProfile: () async {
          if (_choice == null) await refresh();
          if (isClosed || state.busy || _choice == null || !state.ready) {
            throw StateError('Аудиоустройство не готово к восстановлению');
          }
          return PortableVoiceProfile.fromAudio(_choice!.audio);
        },
        apply: _applyPortableProfile,
      );

  Future<PortableVoiceSnapshot> exportPortableVoice(String actor) =>
      PortableVoiceStore().exclusive(() async {
        if (isClosed || state.busy) {
          throw StateError('Аудиоустройство не готово к копированию');
        }
        final choice = _choice ?? await preferences.load();
        if (isClosed || state.busy) {
          throw StateError('Аудиоустройство не готово к копированию');
        }
        final store = PortableVoiceStore();
        final profile = PortableVoiceProfile.fromAudio(choice.audio);
        final previous = await store.read(profile);
        return previous.observe(profile, actor);
      });

  Future<void> updateAudio(VoiceAudioSettings settings) =>
      PortableVoiceStore().exclusive(() async {
        try {
          await _savePortableAudio(settings);
        } catch (error) {
          _publish(error: error.toString());
        }
      });

  Future<void> _savePortableAudio(VoiceAudioSettings settings) async {
    final actor = portableActor?.call();
    final refreshing = _refreshing;
    if (refreshing != null) await refreshing;
    if (_choice == null && !isClosed) await refresh();
    if (isClosed || state.busy || _choice == null) return;
    final store = PortableVoiceStore();
    final previous = actor == null
        ? null
        : await store.read(PortableVoiceProfile.fromAudio(_choice!.audio));
    await _updateAudio(settings);
    if (actor != null && previous != null && state.error.isEmpty) {
      await store.write(
        previous.observe(PortableVoiceProfile.fromAudio(_choice!.audio), actor),
      );
    }
  }

  Future<void> _updateAudio(VoiceAudioSettings settings) async {
    final refreshing = _refreshing;
    if (refreshing != null) await refreshing;
    if (_choice == null && !isClosed) await refresh();
    if (isClosed || state.busy) return;
    _publish(busy: true);
    try {
      final valid = settings.copyWith();
      await onAudioChanged?.call(valid);
      if (isClosed) return;
      _choice = (_choice ?? const VoiceDeviceChoice()).changeAudio(valid);
      await _saveChoice();
      _publish();
    } catch (error) {
      _publish(error: error.toString());
    }
  }

  Future<void> _saveChoice() async {
    try {
      await preferences.save(_choice!);
      _saveError = '';
    } catch (error) {
      _saveError = error.toString();
    }
  }
}
