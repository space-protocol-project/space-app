import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'voice_device_preferences.dart';
import 'voice_audio_settings.dart';

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
  @override
  Future<List<VoiceDevice>> devices() async {
    await WebRTC.initialize(options: {'logSeverity': 'error'});
    final devices = await navigator.mediaDevices.enumerateDevices();
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

class VoiceDevicesState {
  const VoiceDevicesState({
    this.devices = const [],
    this.busy = false,
    this.error = '',
    this.input,
    this.output,
    this.ready = false,
    this.audio = const VoiceAudioSettings(),
  });
  final List<VoiceDevice> devices;
  final bool busy;
  final bool ready;
  final String error;
  final String? input, output;
  final VoiceAudioSettings audio;

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
        audio: _choice?.audio ?? const VoiceAudioSettings(),
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
      final devices = _unique(await backend.devices());
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
    final available = devices.where((d) => d.id == id && d.input == input);
    if (available.isEmpty) {
      _applied.remove(input);
      return;
    }
    if (_applied[input] == id) return;
    await backend.select(available.first);
    _applied[input] = id!;
  }

  Future<void> select(VoiceDevice device) async {
    final refreshing = _refreshing;
    if (refreshing != null) await refreshing;
    if (isClosed || state.busy || !_available(device)) return;
    _publish(busy: true);
    try {
      await beforeDeviceChanged?.call();
      await backend.select(device);
      if (isClosed) return;
      _applied[device.input] = device.id;
      _choice = (_choice ?? const VoiceDeviceChoice()).change(
        device.id,
        input: device.input,
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

  Future<void> updateAudio(VoiceAudioSettings settings) async {
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
