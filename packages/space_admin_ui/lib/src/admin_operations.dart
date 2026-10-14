import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AdminOperationEvent {}

final class AdminOperationStarted extends AdminOperationEvent {
  final accepted = Completer<bool>();
}

final class AdminOperationFinished extends AdminOperationEvent {
  AdminOperationFinished({this.error});
  final Object? error;
}

final class AdminOperationState {
  const AdminOperationState({this.busy = false, this.error});
  final bool busy;
  final Object? error;
}

/// Не допускает повторной операции, пока выполняется предыдущая.
final class AdminOperations
    extends Bloc<AdminOperationEvent, AdminOperationState> {
  AdminOperations() : super(const AdminOperationState()) {
    on<AdminOperationStarted>((event, emit) {
      if (state.busy) {
        event.accepted.complete(false);
        return;
      }
      emit(const AdminOperationState(busy: true));
      event.accepted.complete(true);
    });
    on<AdminOperationFinished>(
      (event, emit) => emit(AdminOperationState(error: event.error)),
    );
  }

  Future<bool> begin() {
    if (isClosed) return Future.value(false);
    final event = AdminOperationStarted();
    add(event);
    return event.accepted.future;
  }

  void finish({Object? error}) {
    if (!isClosed) add(AdminOperationFinished(error: error));
  }
}
