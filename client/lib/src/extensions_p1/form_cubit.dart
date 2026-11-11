import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'document.dart';

part 'form_cubit.freezed.dart';

enum ExtensionFormStatus { ready, invalid, running, failed, succeeded }

@freezed
abstract class ExtensionFormState with _$ExtensionFormState {
  const factory ExtensionFormState({
    required Map<String, Object> values,
    @Default(<String>{}) Set<String> errors,
    @Default(ExtensionFormStatus.ready) ExtensionFormStatus status,
  }) = _ExtensionFormState;
}

class ExtensionFormCubit extends Cubit<ExtensionFormState> {
  ExtensionFormCubit(this.nodes, this.send)
    : super(
        ExtensionFormState(
          values: {for (final node in nodes) node.id: node.field!.initial},
        ),
      );
  final List<ExtensionNode> nodes;
  final Future<bool> Function(Map<String, Object>) send;

  void change(String id, Object value) {
    if (isClosed || state.status == ExtensionFormStatus.running) return;
    if (!state.values.containsKey(id)) return;
    emit(
      state.copyWith(
        values: {...state.values, id: value},
        errors: {...state.errors}..remove(id),
        status: ExtensionFormStatus.ready,
      ),
    );
  }

  Future<void> submit() async {
    if (isClosed || state.status == ExtensionFormStatus.running) return;
    final invalid = {
      for (final node in nodes)
        if (!node.field!.valid(state.values[node.id])) node.id,
    };
    if (invalid.isNotEmpty) {
      emit(
        state.copyWith(errors: invalid, status: ExtensionFormStatus.invalid),
      );
      return;
    }
    emit(state.copyWith(errors: {}, status: ExtensionFormStatus.running));
    var accepted = false;
    try {
      accepted = await send(Map.unmodifiable(state.values));
    } catch (_) {
      accepted = false;
    }
    if (!isClosed) {
      emit(
        state.copyWith(
          status: accepted
              ? ExtensionFormStatus.succeeded
              : ExtensionFormStatus.failed,
        ),
      );
    }
  }
}
