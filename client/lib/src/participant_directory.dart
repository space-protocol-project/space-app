import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'generated/space/v1/space.pb.dart';
import 'participant_profiles.dart';

part 'participant_directory.freezed.dart';

@freezed
abstract class ParticipantDirectoryState with _$ParticipantDirectoryState {
  const factory ParticipantDirectoryState({
    @Default({}) Map<String, ParticipantProfile> profiles,
  }) = _ParticipantDirectoryState;
}

class ParticipantDirectory extends Cubit<ParticipantDirectoryState> {
  ParticipantDirectory(this.api, this.channel)
    : super(const ParticipantDirectoryState()) {
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => unawaited(refresh()),
    );
  }
  final ParticipantProfiles? api;
  final String channel;
  List<String> _ids = const [];
  Timer? _timer;
  int _generation = 0;
  bool _running = false;

  void select(Iterable<String> ids, {bool active = true}) {
    final next = active
        ? (ids.where((id) => id.isNotEmpty).toSet().toList()..sort())
              .take(256)
              .toList()
        : <String>[];
    if (_sameIds(next)) return;
    _generation++;
    _ids = next;
    emit(const ParticipantDirectoryState());
    unawaited(refresh());
  }

  bool _sameIds(List<String> other) =>
      other.length == _ids.length &&
      Iterable<int>.generate(other.length).every((i) => other[i] == _ids[i]);

  Future<void> refresh() async {
    final source = api;
    if (source == null || _ids.isEmpty || _running || isClosed) return;
    _running = true;
    final generation = _generation, ids = List<String>.of(_ids);
    try {
      final found = await _fetch(source, ids, generation);
      _publish(generation, found);
    } catch (_) {
      _publish(generation, const {});
    } finally {
      _running = false;
      if (!isClosed && generation != _generation) unawaited(refresh());
    }
  }

  void _publish(int generation, Map<String, ParticipantProfile> profiles) {
    if (!isClosed && generation == _generation) {
      emit(ParticipantDirectoryState(profiles: profiles));
    }
  }

  Future<Map<String, ParticipantProfile>> _fetch(
    ParticipantProfiles source,
    List<String> ids,
    int generation,
  ) async {
    final found = <String, ParticipantProfile>{};
    for (var offset = 0; offset < ids.length; offset += 50) {
      if (isClosed || generation != _generation) return const {};
      final batch = ids.skip(offset).take(50).toList();
      final values = await source
          .listParticipantProfiles(channel, batch)
          .timeout(const Duration(seconds: 5));
      if (values.length > batch.length) {
        throw const FormatException('Слишком много профилей');
      }
      _include(found, batch, values);
    }
    return found;
  }

  void _include(
    Map<String, ParticipantProfile> found,
    List<String> batch,
    List<ParticipantProfile> values,
  ) {
    for (final value in values) {
      if (!batch.contains(value.principalId) ||
          found.containsKey(value.principalId)) {
        throw const FormatException(
          'Профиль не относится к запрошенному составу',
        );
      }
      found[value.principalId] = checkedParticipantProfile(value);
    }
  }

  @override
  Future<void> close() {
    _generation++;
    _timer?.cancel();
    return super.close();
  }
}
