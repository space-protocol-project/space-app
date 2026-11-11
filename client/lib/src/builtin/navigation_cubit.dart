import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../generated/space/v1/builtin.pb.dart';
import 'transport.dart';

part 'navigation_cubit.freezed.dart';

@freezed
abstract class BuiltinNavigationState with _$BuiltinNavigationState {
  const factory BuiltinNavigationState({
    @Default(true) bool busy,
    @Default(false) bool failed,
    @Default(<BuiltinSection>[]) List<BuiltinSection> sections,
    BuiltinSection? opened,
  }) = _BuiltinNavigationState;
}

class BuiltinNavigationCubit extends Cubit<BuiltinNavigationState> {
  BuiltinNavigationCubit(this.transport)
    : super(const BuiltinNavigationState());
  final BuiltinTransport transport;
  int _generation = 0;

  Future<void> load() async {
    if (isClosed) return;
    final generation = ++_generation;
    emit(const BuiltinNavigationState());
    try {
      final sections = await transport.list();
      if (_current(generation)) {
        emit(BuiltinNavigationState(busy: false, sections: sections));
      }
    } catch (_) {
      _fail(generation);
    }
  }

  Future<void> open(String instance) async {
    if (isClosed ||
        state.busy ||
        !state.sections.any((s) => s.instanceId == instance)) {
      return;
    }
    final generation = ++_generation;
    emit(state.copyWith(busy: true, opened: null));
    try {
      final opened = await transport.open(instance);
      if (_current(generation)) {
        emit(state.copyWith(busy: false, opened: opened));
      }
    } catch (_) {
      _fail(generation);
    }
  }

  bool _current(int generation) => !isClosed && generation == _generation;
  void _fail(int generation) {
    if (_current(generation)) {
      emit(const BuiltinNavigationState(busy: false, failed: true));
    }
  }

  void invalidate() {
    if (isClosed) return;
    _generation++;
    emit(const BuiltinNavigationState(busy: false, failed: true));
  }
}
