import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_controller.dart';
import 'community_overview.dart';
import 'server_presence.dart';
import 'server_workspaces.dart';
import 'generated/space/v1/space.pb.dart' show Channel;

part 'dashboard_controller.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default([]) List<DashboardCommunitySection> communities,
    @Default(false) bool loading,
    @Default(false) bool failed,
    @Default(false) bool unsupported,
  }) = _DashboardState;
}

class DashboardController extends Cubit<DashboardState> {
  DashboardController(this.workspaces, this.presence)
    : super(const DashboardState()) {
    _subscriptions.add(workspaces.stream.listen((_) => _catalogChanged()));
    _subscriptions.add(presence.stream.listen((_) => _catalogChanged()));
  }
  final ServerWorkspaces workspaces;
  final ServerPresence presence;
  final _subscriptions = <StreamSubscription<Object?>>[];
  final _sections = <String, DashboardCommunitySection>{};
  final _failures = <String>{};
  Timer? _timer;
  String _signature = '';
  bool _active = false, _running = false, _requested = false;
  int _generation = 0;

  Iterable<MapEntry<String, ChatController>> get _online =>
      workspaces.controllers.entries.where(
        (entry) =>
            entry.value.connected &&
            !entry.value.reconnecting &&
            !entry.value.accessRemoved &&
            presence.online(entry.key) != false,
      );

  void setActive(bool value) {
    if (isClosed || value == _active) return;
    _active = value;
    _timer?.cancel();
    ++_generation;
    _sections.clear();
    _failures.clear();
    emit(const DashboardState());
    if (!value) return;
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => unawaited(refresh()),
    );
    _signature = _catalogSignature();
    unawaited(refresh());
  }

  String _catalogSignature() => _online
      .map((entry) {
        final api = entry.value.communityOverview;
        final channels =
            api?.sections
                .map((c) => '${c.id}:${c.revision}:${c.permissions}')
                .join('|') ??
            '';
        return '${entry.key}:${identityHashCode(api)}:${api?.supported}:$channels';
      })
      .join('\n');

  void _catalogChanged() {
    if (!_active || isClosed) return;
    final signature = _catalogSignature();
    if (_signature == signature) return;
    _signature = signature;
    ++_generation;
    _sections.clear();
    _failures.clear();
    emit(const DashboardState());
    unawaited(refresh());
  }

  bool _current(int generation) =>
      !isClosed && _active && generation == _generation;

  Future<void> refresh() async {
    if (!_active || isClosed) return;
    _requested = true;
    if (_running) return;
    _running = true;
    try {
      do {
        _requested = false;
        await _refreshRound(_generation);
      } while (_requested && _active && !isClosed);
    } finally {
      _running = false;
    }
  }

  Future<void> _refreshRound(int generation) async {
    emit(state.copyWith(loading: true, unsupported: false));
    for (final entry in _online.toList()) {
      await _server(entry.key, entry.value, generation);
      if (!_current(generation)) return;
    }
    if (!_current(generation)) return;
    _signature = _catalogSignature();
    _publish(loading: false);
  }

  void _unsupportedServer(String origin, int generation) {
    if (!_current(generation)) return;
    _removeServer(origin);
    emit(state.copyWith(unsupported: true));
    _publish(loading: true);
  }

  void _retainServer(String origin, List<Channel> channels) {
    _sections.removeWhere(
      (_, section) =>
          section.origin == origin &&
          !channels.any(
            (channel) =>
                channel.id == section.channel.id &&
                channel.permissions == section.channel.permissions,
          ),
    );
  }

  Future<void> _server(
    String origin,
    ChatController controller,
    int generation,
  ) async {
    final api = controller.communityOverview;
    _failures.removeWhere(
      (key) => key == origin || key.startsWith('$origin\x00'),
    );
    if (api == null) {
      _unsupportedServer(origin, generation);
      return;
    }
    try {
      await api.refresh().timeout(const Duration(seconds: 5));
      if (!_current(generation)) return;
      if (!api.supported) {
        _unsupportedServer(origin, generation);
        return;
      }
      final channels = api.sections.where(readableCommunity).toList();
      _retainServer(origin, channels);
      _publish(loading: true);
      for (var start = 0; start < channels.length; start += 4) {
        await Future.wait(
          channels
              .skip(start)
              .take(4)
              .map(
                (channel) => _section(
                  origin,
                  controller,
                  api,
                  channel.deepCopy(),
                  generation,
                ),
              ),
        );
        if (!_current(generation)) return;
        _publish(loading: true);
      }
    } catch (_) {
      if (!_current(generation)) return;
      _removeServer(origin);
      _failures.add(origin);
      _publish(loading: true);
    }
  }

  Future<void> _section(
    String origin,
    ChatController controller,
    CommunityOverviewApi api,
    Channel channel,
    int generation,
  ) async {
    try {
      final page = await api
          .overview(channel.id)
          .timeout(const Duration(seconds: 5));
      if (!_current(generation)) return;
      if (!_sectionReadable(api, channel)) {
        _sections.remove('$origin\x00${channel.id}');
        _publish(loading: true);
        return;
      }
      _sections['$origin\x00${channel.id}'] = DashboardCommunitySection(
        origin: origin,
        spaceTitle: controller.spaceTitle,
        channel: channel.deepCopy(),
        overview: page,
      );
      _publish(loading: true);
    } catch (_) {
      if (!_current(generation)) return;
      _sections.remove('$origin\x00${channel.id}');
      _failures.add('$origin\x00${channel.id}');
      _publish(loading: true);
    }
  }

  bool _sectionReadable(CommunityOverviewApi api, Channel snapshot) =>
      api.supported &&
      api.sections.any(
        (current) =>
            current.id == snapshot.id &&
            readableCommunity(current) &&
            current.permissions == snapshot.permissions,
      );

  void _removeServer(String origin) {
    _sections.removeWhere((key, _) => key.startsWith('$origin\x00'));
    _failures.removeWhere(
      (key) => key == origin || key.startsWith('$origin\x00'),
    );
  }

  void _publish({required bool loading}) => emit(
    state.copyWith(
      communities: _sections.values.toList(growable: false),
      loading: loading,
      failed: _failures.isNotEmpty,
    ),
  );

  @override
  Future<void> close() async {
    ++_generation;
    _active = false;
    _timer?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
