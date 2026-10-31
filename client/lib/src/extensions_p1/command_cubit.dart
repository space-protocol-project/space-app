import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../generated/space/v1/extensions_p1.pb.dart';
import 'command_snapshot.dart';
import 'command_transport.dart';
import 'retry.dart';

typedef ExtensionCommandState = ({String phase, bool unknown, int attempts});

// Прототип E02: один владелец журнала/транспорта, одна активная операция.
class ExtensionCommandCubit extends Cubit<ExtensionCommandState> {
  ExtensionCommandCubit(
    this.transport,
    this.journal,
    this.currentBinding, {
    this.elapsedMilliseconds,
  }) : super((phase: 'idle', unknown: false, attempts: 0));

  final ExtensionCommandTransport transport;
  final ExtensionCommandJournal journal;
  final ExtensionCommandBinding Function() currentBinding;
  // Доверенный монотонный источник для управляемого стенда; по умолчанию Stopwatch.
  final int Function()? elapsedMilliseconds;
  final Stopwatch _clock = Stopwatch();
  bool _busy = false;
  bool _cancelled = false;
  Completer<void>? _wake;

  bool get _sameBinding =>
      commandBindingKey(currentBinding()) == journal.bindingKey;
  int get _elapsed => elapsedMilliseconds?.call() ?? _clock.elapsedMilliseconds;

  Future<void> start(ExecuteExtensionCommandRequest input) async {
    if (_busy || state.phase != 'idle') {
      throw StateError('Команда уже начата');
    }
    validateNewExtensionCommand(input);
    if (input.historyId.isNotEmpty || input.retryLeaseId.isNotEmpty) {
      throw StateError('Старую команду нельзя перепривязать');
    }
    final request = ExecuteExtensionCommandRequest.fromBuffer(
      input.writeToBuffer(),
    );
    _busy = true;
    _clock.start();
    try {
      await _start(request);
    } finally {
      _busy = false;
    }
  }

  Future<void> _start(ExecuteExtensionCommandRequest request) async {
    if (!_sameBinding || _cancelled) {
      _stop(false);
      return;
    }
    if (await journal.read() != null) {
      throw StateError('Сначала сверить сохранённую команду');
    }
    if (!_sameBinding || _cancelled) {
      _stop(false);
      return;
    }
    final grant = await transport.context(request.instanceId);
    if (!_sameBinding || _cancelled) {
      _stop(false);
      return;
    }
    if (grant.retryWindowRemainingMs.toInt() != 30000) {
      throw const FormatException('Неизвестное окно повторов');
    }
    request.historyId = grant.historyId;
    request.retryLeaseId = grant.retryLeaseId;
    validateNewExtensionCommand(request, contextRequired: true);
    final snapshot = ExtensionCommandSnapshot(journal.bindingKey, request);
    await journal.save(snapshot);
    await _execute(snapshot);
  }

  Future<void> _execute(ExtensionCommandSnapshot snapshot) async {
    for (var attempt = 1; attempt <= 4; attempt++) {
      if (_cancelled || !_sameBinding || _elapsed < 0 || _elapsed > 25000) {
        _stop(state.unknown);
        return;
      }
      emit((phase: 'sending', unknown: true, attempts: attempt));
      final code = await _send(snapshot);
      final elapsed = _elapsed;
      final decision = decideExtensionRetry((
        code: code,
        attempt: attempt,
        elapsedMs: elapsed,
        remainingMs: (30000 - elapsed).clamp(0, 30000),
        windowKnown: true,
        sameRequest: _sameBinding,
        cancelled: _cancelled,
        previousUnknown: state.unknown,
      ));
      emit((
        phase: decision.action,
        unknown: decision.unknown,
        attempts: attempt,
      ));
      if (decision.action != 'retry_same_request') {
        return;
      }
      await _delay(decision.delayMs);
    }
  }

  Future<String> _send(ExtensionCommandSnapshot snapshot) async {
    try {
      final response = await transport.execute(snapshot.request);
      if (!_validReceipt(response, snapshot.request)) {
        return 'DataLoss';
      }
      return 'OK';
    } catch (error) {
      return extensionCommandErrorCode(error);
    }
  }

  // После restart/re-login только сверка. Монотонное окно не восстанавливается
  // из часов устройства, и новый контекст для прежней команды не запрашивается.
  Future<void> reconcile() async {
    if (_busy) {
      throw StateError('Команда выполняется');
    }
    _busy = true;
    try {
      if (!_sameBinding || _cancelled) {
        _stop(true);
        return;
      }
      final snapshot = await journal.read();
      if (snapshot == null) {
        throw StateError('Нет сохранённой команды');
      }
      if (!_sameBinding || _cancelled) {
        _stop(true);
        return;
      }
      emit((phase: 'reconciling', unknown: true, attempts: state.attempts));
      final result = await transport.reconcile(snapshot.request);
      final confirmed =
          _sameBinding &&
          result.outcome ==
              ExtensionCommandOutcome.EXTENSION_COMMAND_OUTCOME_CONFIRMED &&
          result.hasReceipt() &&
          _validReceipt(result.receipt, snapshot.request);
      emit((
        phase: confirmed ? 'confirmed' : 'stop',
        unknown: !confirmed,
        attempts: state.attempts,
      ));
    } catch (error) {
      _reconcileFailed(error);
    } finally {
      _busy = false;
    }
  }

  void _reconcileFailed(Object error) {
    final reauthenticate = !_cancelled && _sameBinding &&
        extensionCommandErrorCode(error) == 'Unauthenticated';
    emit((phase: reauthenticate ? 'reauthenticate' : 'stop',
      unknown: true, attempts: state.attempts));
  }

  Future<void> _delay(int ms) async {
    final wake = Completer<void>();
    _wake = wake;
    final timer = Timer(Duration(milliseconds: ms), () {
      if (!wake.isCompleted) wake.complete();
    });
    try {
      await wake.future;
    } finally {
      timer.cancel();
      _wake = null;
    }
  }

  void _stop(bool unknown) =>
      emit((phase: 'stop', unknown: unknown, attempts: state.attempts));

  bool _validReceipt(
    ExecuteExtensionCommandResponse response,
    ExecuteExtensionCommandRequest request,
  ) {
    if (response.effect != request.effect ||
        response.stateRevision != request.expectedStateRevision + 1 ||
        response.documentJson.length > 1024 * 1024) {
      return false;
    }
    try {
      return jsonDecode(utf8.decode(response.documentJson))
          is Map<String, dynamic>;
    } on FormatException {
      return false;
    }
  }

  // Вызывает владелец после обработки подтверждённого результата.
  // Неопределённую команду этот метод удалить не позволяет.
  Future<void> acknowledgeConfirmed() async {
    if (_busy || state.phase != 'confirmed' || !_sameBinding) {
      throw StateError('Нет подтверждённого результата');
    }
    _busy = true;
    try {
      await journal.storage.delete(key: journal.key);
      _clock.stop();
      _clock.reset();
      emit((phase: 'idle', unknown: false, attempts: 0));
    } finally {
      _busy = false;
    }
  }

  void cancel() {
    _cancelled = true;
    transport.cancel();
    final wake = _wake;
    if (wake != null && !wake.isCompleted) wake.complete();
  }

  @override
  Future<void> close() async {
    cancel();
    // Активный владелец завершает операцию до закрытия Cubit.
    while (_busy) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
    await super.close();
  }
}
