import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'contributions.dart';
import 'contributions_transport.dart';
import 'document.dart';

part 'contributions_cubit.freezed.dart';

enum ContributionsPhase { loading, list, opening, document, failed }

@freezed
abstract class ContributionsState with _$ContributionsState {
  const factory ContributionsState({
    @Default(ContributionsPhase.loading) ContributionsPhase phase,
    @Default(<ContributionEntry>[]) List<ContributionEntry> entries,
    ContributionEntry? selected,
    ExtensionDocument? document,
  }) = _ContributionsState;
}

class ContributionsCubit extends Cubit<ContributionsState> {
  ContributionsCubit(this.transport) : super(const ContributionsState());
  final ContributionsTransport transport;
  int _generation = 0;

  int _begin(ContributionsState next) {
    _generation++;
    transport.cancel();
    emit(next);
    return _generation;
  }

  bool _current(int generation) => !isClosed && generation == _generation;

  Future<void> load() async {
    if (isClosed) return;
    final generation = _begin(const ContributionsState());
    try {
      final registry = await transport.list();
      if (_current(generation)) {
        emit(
          ContributionsState(
            phase: ContributionsPhase.list,
            entries: registry.entries,
          ),
        );
      }
    } catch (_) {
      _fail(generation);
    }
  }

  Future<void> open(String id) async {
    if (isClosed) return;
    final entry = state.entries.where((e) => e.id == id).firstOrNull;
    if (entry == null) return;
    final generation = _begin(
      state.copyWith(
        phase: ContributionsPhase.opening,
        selected: entry,
        document: null,
      ),
    );
    try {
      final document = await transport.query(entry.query);
      if (_current(generation)) {
        emit(
          state.copyWith(
            phase: ContributionsPhase.document,
            document: document,
          ),
        );
      }
    } catch (_) {
      _fail(generation);
    }
  }

  Future<void> command(String name) async {
    if (isClosed || state.phase != ContributionsPhase.document) {
      throw StateError('Элемент недоступен');
    }
    final generation = _generation;
    try {
      await transport.command(name);
      if (!_current(generation)) throw StateError('Сессия изменилась');
    } catch (_) {
      _fail(generation);
      rethrow;
    }
  }

  void _fail(int generation) {
    if (_current(generation)) invalidate();
  }

  // Вызывается оболочкой при выходе/смене сессии; старые данные не кешируются.
  void invalidate() {
    if (isClosed) return;
    _begin(const ContributionsState(phase: ContributionsPhase.failed));
  }

  Future<void> back() => load();

  @override
  Future<void> close() {
    _generation++;
    transport.cancel();
    return super.close();
  }
}
