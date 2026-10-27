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
    if (selected) {
      next.add(origin);
    } else {
      next.remove(origin);
    }
    if (next.length > 12) return;
    emit(state.copyWith(origins: next, error: ''));
  }

  void mode(bool full) {
    if (!isClosed && !state.busy && !state.prepared) {
      emit(state.copyWith(fullManagement: full, error: ''));
    }
  }

  Future<void> prepare() async {
    if (isClosed || state.busy || state.prepared || state.origins.isEmpty) {
      return;
    }
    final generation = ++_generation;
    final selected = {
      for (final origin in state.origins) origin: controllers()[origin],
    };
    emit(state.copyWith(busy: true, error: ''));
    try {
      // Сначала проверяем весь выбор: существующие личности не заменяются.
      if (!await _checkSelection(selected, generation)) return;
      final catalog =
          (await repository?.read())?['catalog'] as Map? ?? const {};
      if (!await _discoverSelection(selected, catalog, generation)) return;
      emit(state.copyWith(prepared: true, revision: state.revision + 1));
    } catch (_) {
      if (_current(generation)) {
        emit(state.copyWith(error: 'pairingSelectionFailed'));
      }
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  Future<bool> _checkSelection(
    Map<String, ChatController?> selected,
    int generation,
  ) async {
    for (final MapEntry(:key, :value) in selected.entries) {
      await _requireNewIdentity(key, value);
      if (!_current(generation)) return false;
    }
    return true;
  }

  Future<bool> _discoverSelection(
    Map<String, ChatController?> selected,
    Map catalog,
    int generation,
  ) async {
    for (final MapEntry(:key, :value) in selected.entries) {
      if (!_current(generation)) return false;
      await _inspect(key, value!, catalog[key] as Map?);
      if (!_current(generation)) return false;
    }
    return true;
  }

  Future<void> _requireNewIdentity(
    String origin,
    ChatController? controller,
  ) async {
    if (controller == null ||
        controller.connected ||
        controller.busy ||
        await controller.vault
                .load(origin)
                .timeout(const Duration(seconds: 10)) !=
            null) {
      throw StateError('identity');
    }
  }

  Future<void> _inspect(
    String origin,
    ChatController controller,
    Map? saved,
  ) async {
    await controller.inspect(
      saved?['endpoint'] as String? ?? origin,
      tlsFingerprint: saved?['tls_fingerprint'] as String? ?? '',
    );
    if (controller.preview?.origin.toString() != origin ||
        !identical(controllers()[origin], controller)) {
      throw StateError('discovery');
    }
  }

  void reset() {
    ++_generation;
    if (!isClosed) emit(PairingSelectionState(revision: state.revision + 1));
  }

  @override
  Future<void> close() {
    ++_generation;
    return super.close();
  }
}
