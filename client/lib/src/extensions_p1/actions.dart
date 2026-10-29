import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ExtensionActionState { const ExtensionActionState(); }
class ExtensionReady extends ExtensionActionState { const ExtensionReady(); }
class ExtensionRunning extends ExtensionActionState {
  const ExtensionRunning(this.command);
  final String command;
}
class ExtensionFailed extends ExtensionActionState { const ExtensionFailed(); }

// Карта приходит из доверенной оболочки; она не является серверной авторизацией.
class ExtensionActions extends Cubit<ExtensionActionState> {
  ExtensionActions(Map<String, Future<void> Function()> commands)
      : commands = Map.unmodifiable(commands), super(const ExtensionReady());
  final Map<String, Future<void> Function()> commands;

  Future<void> invoke(String command) async {
    if (isClosed || state is ExtensionRunning) return;
    final action = commands[command];
    if (action == null) { emit(const ExtensionFailed()); return; }
    emit(ExtensionRunning(command));
    try {
      await action();
      if (!isClosed) emit(const ExtensionReady());
    } catch (_) {
      if (!isClosed) emit(const ExtensionFailed());
    }
  }
}
