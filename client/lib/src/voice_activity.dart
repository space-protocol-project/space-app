import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceAudioActivity {
  const VoiceAudioActivity({this.local = false, this.remoteSlots = const {}});
  final bool local;
  final Set<int> remoteSlots;
}

abstract interface class VoiceActivityMedia {
  Future<VoiceAudioActivity> activity();
}

class VoiceAudioLevels {
  final _previous = <String, (double, double, double)>{};

  Set<int> read(List<StatsReport> reports) {
    final active = <int>{};
    final present = <String>{};
    for (final report in reports.where((r) => r.type == 'inbound-rtp')) {
      final slot = _slot(report.values['trackIdentifier']);
      if (slot == null) continue;
      present.add(report.id);
      if (_level(report) > .008) active.add(slot);
    }
    _previous.removeWhere((id, _) => !present.contains(id));
    return Set.unmodifiable(active);
  }

  int? _slot(Object? value) {
    final match = RegExp(r'^speaker-([0-6])$').firstMatch('$value');
    return match == null ? null : int.parse(match[1]!);
  }

  double _level(StatsReport report) {
    final values = report.values;
    final energy = _number(values['totalAudioEnergy']);
    final duration = _number(values['totalSamplesDuration']);
    final packets = _number(values['packetsReceived']) ?? 0;
    final previous = _previous[report.id];
    _previous[report.id] = (energy ?? 0, duration ?? 0, packets);
    if (previous == null || packets <= previous.$3) return 0;
    if (energy != null && duration != null) {
      final seconds = duration - previous.$2;
      final delta = energy - previous.$1;
      if (seconds <= 0 || delta < 0) return 0;
      return math.sqrt(delta / seconds).clamp(0, 1);
    }
    return (_number(values['audioLevel']) ?? 0).clamp(0, 1);
  }

  double? _number(Object? value) =>
      value is num && value.isFinite && value >= 0 ? value.toDouble() : null;
}

class VoiceActivityMonitor {
  VoiceActivityMonitor({required this.read, required this.publish}) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => unawaited(_poll()),
    );
    unawaited(_poll());
  }
  final Future<VoiceAudioActivity> Function() read;
  final void Function(VoiceAudioActivity) publish;
  Timer? _timer;
  bool _closed = false, _reading = false;

  Future<void> _poll() async {
    if (_closed || _reading) return;
    _reading = true;
    final pending = Future<VoiceAudioActivity>.sync(read);
    unawaited(
      pending.then(
        (_) => _reading = false,
        onError: (Object _, StackTrace stack) {
          _reading = false;
        },
      ),
    );
    try {
      final value = await pending.timeout(const Duration(seconds: 1));
      if (!_closed) publish(value);
    } catch (_) {
      if (!_closed) publish(const VoiceAudioActivity());
    }
  }

  void close() {
    _closed = true;
    _timer?.cancel();
  }
}
