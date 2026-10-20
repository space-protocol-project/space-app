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
  Map<String, int> _midSlots = const {};

  void configure(String sdp) {
    _previous.clear();
    final entries = sdp
        .split(RegExp(r'(?=^m=)', multiLine: true))
        .map(_mediaSlot)
        .whereType<(String, int)>()
        .toList();
    _midSlots = {
      for (final entry in entries)
        if (_uniqueEntry(entry, entries)) entry.$1: entry.$2,
    };
  }

  bool _uniqueEntry((String, int) entry, List<(String, int)> entries) =>
      entries
          .where((other) => other.$1 == entry.$1 || other.$2 == entry.$2)
          .length ==
      1;

  (String, int)? _mediaSlot(String section) {
    if (!section.startsWith('m=audio ')) return null;
    final mid = RegExp(
      r'^a=mid:([^\r\n ]+)',
      multiLine: true,
    ).firstMatch(section);
    final tracks = RegExp(
      r'^a=msid:[^\r\n ]+ speaker-([0-6])\r?$',
      multiLine: true,
    ).allMatches(section).map((match) => int.parse(match[1]!)).toSet();
    if (mid == null || tracks.length != 1) return null;
    return (mid[1]!, tracks.single);
  }

  int? outputSlot(StatsReport report) =>
      _slot(report.values['trackIdentifier']) ??
      _midSlots[report.values['mid']];

  Set<int> read(List<StatsReport> reports) {
    final active = <int>{};
    final present = <String>{};
    for (final report in reports.where((r) => r.type == 'inbound-rtp')) {
      final slot = outputSlot(report);
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
