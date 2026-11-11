import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ExtensionActionState {
  const ExtensionActionState();
}

class ExtensionReady extends ExtensionActionState {
  const ExtensionReady();
}

class ExtensionRunning extends ExtensionActionState {
  const ExtensionRunning(this.command);
  final String command;
}

class ExtensionFailed extends ExtensionActionState {
  const ExtensionFailed({this.handledByForm = false});
  final bool handledByForm;
}

// Карта приходит из доверенной оболочки; она не является серверной авторизацией.
class ExtensionActions extends Cubit<ExtensionActionState> {
  ExtensionActions(
    Map<String, Future<void> Function()> commands, {
    Map<String, Future<void> Function(Map<String, Object>)> forms = const {},
  }) : commands = Map.unmodifiable(commands),
       forms = Map.unmodifiable(forms),
       super(const ExtensionReady());
  final Map<String, Future<void> Function()> commands;
  final Map<String, Future<void> Function(Map<String, Object>)> forms;

  Future<void> invoke(String command) async {
    await _run(command, commands[command]);
  }

  Future<bool> submit(String command, Map<String, Object> payload) {
    final action = forms[command];
    return _run(
      command,
      action == null ? null : () => action(Map.unmodifiable(payload)),
      handledByForm: true,
    );
  }

  Future<bool> _run(
    String command,
    Future<void> Function()? action, {
    bool handledByForm = false,
  }) async {
    if (isClosed || state is ExtensionRunning) return false;
    if (action == null) {
      emit(ExtensionFailed(handledByForm: handledByForm));
      return false;
    }
    emit(ExtensionRunning(command));
    try {
      await action();
      if (!isClosed) emit(const ExtensionReady());
      return true;
    } catch (_) {
      if (!isClosed) emit(ExtensionFailed(handledByForm: handledByForm));
      return false;
    }
  }
}
