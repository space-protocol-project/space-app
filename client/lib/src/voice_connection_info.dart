import 'package:flutter_webrtc/flutter_webrtc.dart';

enum VoiceRoute { unknown, direct, relay }

class VoiceConnectionInfo {
  const VoiceConnectionInfo({
    this.route = VoiceRoute.unknown,
    this.roundTripMs,
  });
  final VoiceRoute route;
  final int? roundTripMs;

  factory VoiceConnectionInfo.fromStats(List<StatsReport> reports) {
    final byId = {for (final report in reports) report.id: report};
    final pair = _selectedPair(reports, byId);
    if (pair == null) return const VoiceConnectionInfo();
    final local = byId[pair.values['localCandidateId']];
    final remote = byId[pair.values['remoteCandidateId']];
    return VoiceConnectionInfo(
      route: _route(local, remote),
      roundTripMs: _roundTrip(pair.values['currentRoundTripTime']),
    );
  }

  static StatsReport? _selectedPair(
    List<StatsReport> reports,
    Map<String, StatsReport> byId,
  ) {
    for (final report in reports.where((item) => item.type == 'transport')) {
      final pair = byId[report.values['selectedCandidatePairId']];
      if (pair?.type == 'candidate-pair') return pair;
    }
    // Старые реализации могут не возвращать transport. Не угадываем маршрут
    // среди нескольких пар и не принимаем просто nominated за выбранную.
    final selected = reports.where(
      (item) =>
          item.type == 'candidate-pair' && item.values['selected'] == true,
    );
    return selected.length == 1 ? selected.single : null;
  }

  static VoiceRoute _route(StatsReport? local, StatsReport? remote) {
    final types = [
      local?.values['candidateType'],
      remote?.values['candidateType'],
    ];
    if (types.contains('relay')) return VoiceRoute.relay;
    const direct = ['host', 'srflx', 'prflx'];
    return types.every(direct.contains)
        ? VoiceRoute.direct
        : VoiceRoute.unknown;
  }

  static int? _roundTrip(dynamic value) {
    if (value is! num || !value.isFinite || value < 0 || value > 60) {
      return null;
    }
    return (value * 1000).round();
  }
}

abstract interface class VoiceConnectionMedia {
  Future<VoiceConnectionInfo> connectionInfo();
}
