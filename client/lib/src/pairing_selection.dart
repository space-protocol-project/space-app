import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_controller.dart';
import 'directory_repository.dart';

part 'pairing_selection.freezed.dart';

@freezed
abstract class PairingSelectionState with _$PairingSelectionState {
  const factory PairingSelectionState({
    @Default(<String>{}) Set<String> origins,
    @Default(false) bool fullManagement,
    @Default(false) bool busy,
    @Default(false) bool prepared,
    @Default('') String error,
    @Default(0) int revision,
  }) = _PairingSelectionState;
}

class PairingSelectionCubit extends Cubit<PairingSelectionState> {
  PairingSelectionCubit(this.controllers, {this.repository})
      : super(const PairingSelectionState());
  final Map<String, ChatController> Function() controllers;
  final DirectoryRepository? repository;
  int _generation = 0;
  bool _current(int generation) => !isClosed && generation == _generation;

  void select(String origin, bool selected) {
    if (isClosed || state.busy || state.prepared) return;
    if (!controllers().containsKey(origin)) return;
    final next = {...state.origins};
    if (selected) { next.add(origin); } else { next.remove(origin); }
    if (next.length > 12) return;
    emit(state.copyWith(origins: next, error: ''));
  }

  void mode(bool full) {
    if (!isClosed && !state.busy && !state.prepared) {
      emit(state.copyWith(fullManagement: full, error: ''));
    }
  }

  Future<void> prepare() async {
    if (isClosed || state.busy || state.prepared || state.origins.isEmpty) return;
    final generation = ++_generation;
    final selected = {for (final origin in state.origins) origin: controllers()[origin]};
    emit(state.copyWith(busy: true, error: ''));
    try {
      // Сначала проверяем весь выбор: существующие личности не заменяются.
      for (final entry in selected.entries) {
        final controller = entry.value;
        if (controller == null || controller.connected || controller.busy ||
            await controller.vault.load(entry.key) != null) {
          throw StateError('identity');
        }
        if (!_current(generation)) return;
      }
      final catalog = (await repository?.read())?['catalog'] as Map? ?? const {};
      for (final entry in selected.entries) {
        if (!_current(generation)) return;
        final controller = entry.value!;
        final saved = catalog[entry.key] as Map?;
        await controller.inspect(saved?['endpoint'] as String? ?? entry.key,
            tlsFingerprint: saved?['tls_fingerprint'] as String? ?? '');
        if (!_current(generation)) return;
        if (controller.preview?.origin.toString() != entry.key ||
            !identical(controllers()[entry.key], controller)) {
          throw StateError('discovery');
        }
      }
      emit(state.copyWith(prepared: true, revision: state.revision + 1));
    } catch (_) {
      if (_current(generation)) emit(state.copyWith(error: 'pairingSelectionFailed'));
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  void reset() {
    ++_generation;
    if (!isClosed) emit(PairingSelectionState(revision: state.revision + 1));
  }

  @override
  Future<void> close() { ++_generation; return super.close(); }
}
