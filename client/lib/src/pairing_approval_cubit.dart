import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'core.dart';
import 'generated/space/v1/space.pb.dart';
import 'pairing.dart';
import 'pairing_qr.dart';

part 'pairing_approval_cubit.freezed.dart';

class PairingApprovalFailure implements Exception {
  const PairingApprovalFailure(this.messageKey);
  final String messageKey;
}

@freezed
abstract class PairingApprovalState with _$PairingApprovalState {
  const factory PairingApprovalState({
    @Default(false) bool busy,
    @Default(false) bool prepared,
    @Default('') String code,
    @Default('') String verification,
    String? messageKey,
    Object? error,
  }) = _PairingApprovalState;
}

class PairingApprovalCubit extends Cubit<PairingApprovalState> {
  PairingApprovalCubit({
    required this.server,
    required this.manager,
    this.inspect = inspectPairing,
    this.now = DateTime.now,
    Stream<Object?>? contextChanges,
  }) : super(const PairingApprovalState()) {
    _server = server();
    _manager = manager();
    _subscription = contextChanges?.listen((_) => _contextChanged());
  }
  final DateTime Function() now;
  final Discovery? Function() server;
  final DeviceManagement? Function() manager;
  final Future<Pairing> Function(Discovery, String) inspect;
  int _generation = 0;
  Pairing? _pair;
  DeviceRecord? _authority;
  PairingQr? _qr;
  Timer? _expiry;
  bool _closing = false;
  Discovery? _server;
  DeviceManagement? _manager;
  StreamSubscription<Object?>? _subscription;

  void _contextChanged() {
    final selected = server(), control = manager();
    if (identical(_server, selected) && identical(_manager, control)) return;
    _server = selected;
    _manager = control;
    reset();
  }

  bool _current(int generation) =>
      !isClosed && !_closing && generation == _generation;

  void reset() {
    ++_generation;
    _expiry?.cancel();
    _pair = null;
    _authority = null;
    _qr = null;
    if (!isClosed && !_closing) emit(const PairingApprovalState());
  }

  void setCode(String code) {
    if (isClosed || _closing) return;
    reset();
    emit(state.copyWith(code: code));
  }

  // Считывание не выполняет inspect, prepare или подпись.
  void readQr(String text) {
    if (isClosed || _closing) return;
    reset();
    try {
      final qr = PairingQr.parse(text), selected = server();
      if (selected == null) throw const FormatException('QR');
      qr.checkServer(selected);
      _qr = qr;
      emit(state.copyWith(code: qr.code));
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> scan(Future<String?> Function() read) async {
    if (isClosed || _closing || state.busy) return;
    reset();
    final generation = _generation;
    emit(state.copyWith(busy: true));
    try {
      final text = await read();
      if (!_current(generation)) return;
      if (text != null) readQr(text);
    } catch (error) {
      if (_current(generation)) _showError(error);
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  Future<void> prepare({
    required Future<bool> Function(Pairing) confirm,
    required Future<DeviceRecord?> Function() readAuthority,
  }) async {
    final selected = server(), control = manager();
    if (isClosed ||
        _closing ||
        state.busy ||
        selected == null ||
        control == null) {
      return;
    }
    final generation = ++_generation;
    _pair = null;
    _authority = null;
    _expiry?.cancel();
    emit(
      state.copyWith(
        busy: true,
        prepared: false,
        verification: '',
        error: null,
        messageKey: null,
      ),
    );
    try {
      _qr?.checkServer(selected);
      final pair = (await inspect(selected, state.code.trim())).deepCopy()
        ..freeze();
      if (!_current(generation)) return;
      _qr?.checkPair(pair);
      _requirePending(pair);
      final (allowed, authority) = await _selectAuthority(
        pair,
        control,
        generation,
        confirm,
        readAuthority,
      );
      if (!allowed) return;
      _requirePending(pair);
      final code = await control.preparePairing(pair, authority: authority);
      if (!_current(generation)) return;
      _requirePending(pair);
      _pair = pair;
      _authority = authority;
      _expiry = Timer(
        Duration(
          seconds:
              pair.expiresAt.toInt() - now().millisecondsSinceEpoch ~/ 1000,
        ),
        expire,
      );
      emit(
        state.copyWith(
          prepared: true,
          verification: code,
          messageKey: 'pairingReady',
        ),
      );
    } catch (error) {
      if (_current(generation)) _showError(error);
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  Future<(bool, DeviceRecord?)> _selectAuthority(
    Pairing pair,
    DeviceManagement control,
    int generation,
    Future<bool> Function(Pairing) confirm,
    Future<DeviceRecord?> Function() readAuthority,
  ) async {
    if (!await confirm(pair) || !_current(generation)) return (false, null);
    if (control.hasRootAuthority) return (true, null);
    final authority = await readAuthority();
    return (_current(generation) && authority != null, authority);
  }

  void expire() {
    reset();
    if (!isClosed && !_closing) {
      emit(const PairingApprovalState(messageKey: 'pairingExpired'));
    }
  }

  void _requirePending(Pairing pair) {
    if (pair.expiresAt.toInt() <= now().millisecondsSinceEpoch ~/ 1000) {
      throw const PairingApprovalFailure('pairingExpired');
    }
    if (pair.state != 'pending') {
      throw const PairingApprovalFailure('pairingAlreadyUsed');
    }
  }

  Future<void> approve(String entered, Future<bool> Function() confirm) async {
    final control = manager(), pair = _pair, generation = _generation;
    if (isClosed || _closing || state.busy || control == null || pair == null) {
      return;
    }
    emit(state.copyWith(busy: true, messageKey: null, error: null));
    try {
      _requirePending(pair);
      if (!await _confirmSignature(entered, confirm, generation)) return;
      _requirePending(pair);
      await control.approvePairing(pair, authority: _authority);
      if (!_current(generation)) return;
      reset();
      emit(const PairingApprovalState(messageKey: 'pairingSigned'));
    } catch (error) {
      if (_current(generation)) _showError(error);
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  Future<bool> _confirmSignature(
    String entered,
    Future<bool> Function() confirm,
    int generation,
  ) async {
    if (entered.replaceAll(RegExp(r'[\s-]'), '').toUpperCase() !=
        state.verification.replaceAll('-', '')) {
      emit(state.copyWith(messageKey: 'pairingMismatch'));
      return false;
    }
    return await confirm() && _current(generation);
  }

  void _showError(Object error) {
    if (error is PairingApprovalFailure) {
      reset();
      emit(state.copyWith(error: null, messageKey: error.messageKey));
    } else {
      emit(state.copyWith(error: error, messageKey: null));
    }
  }

  @override
  Future<void> close() async {
    _closing = true;
    reset();
    await _subscription?.cancel();
    await super.close();
  }
}
