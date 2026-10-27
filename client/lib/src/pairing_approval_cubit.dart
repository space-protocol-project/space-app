import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'core.dart';
import 'generated/space/v1/space.pb.dart';
import 'pairing.dart';
import 'pairing_qr.dart';

part 'pairing_approval_cubit.freezed.dart';

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
  PairingApprovalCubit({required this.server, required this.manager,
    this.inspect = inspectPairing}) : super(const PairingApprovalState());
  final Discovery? Function() server;
  final DeviceManagement? Function() manager;
  final Future<Pairing> Function(Discovery, String) inspect;
  int _generation = 0;
  Pairing? _pair;
  DeviceRecord? _authority;
  PairingQr? _qr;
  Timer? _expiry;

  bool _current(int generation) => !isClosed && generation == _generation;

  void reset() {
    ++_generation;
    _expiry?.cancel();
    _pair = null;
    _authority = null;
    _qr = null;
    if (!isClosed) emit(const PairingApprovalState());
  }

  void setCode(String code) {
    reset();
    emit(state.copyWith(code: code));
  }

  // Считывание не выполняет inspect, prepare или подпись.
  void readQr(String text) {
    reset();
    try {
      final qr = PairingQr.parse(text), selected = server();
      if (selected == null) throw const FormatException('QR');
      qr.checkServer(selected);
      _qr = qr;
      emit(state.copyWith(code: qr.code));
    } catch (error) {
      emit(state.copyWith(error: error));
    }
  }

  Future<void> scan(Future<String?> Function() read) async {
    if (isClosed || state.busy) return;
    reset();
    final generation = _generation;
    emit(state.copyWith(busy: true));
    try {
      final text = await read();
      if (!_current(generation)) return;
      if (text != null) readQr(text);
    } catch (error) {
      if (_current(generation)) emit(state.copyWith(error: error));
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  Future<void> prepare({
    required Future<bool> Function(Pairing) confirm,
    required Future<DeviceRecord?> Function() readAuthority,
  }) async {
    final selected = server(), control = manager();
    if (isClosed || state.busy || selected == null || control == null) return;
    final generation = ++_generation;
    _pair = null;
    _authority = null;
    _expiry?.cancel();
    emit(state.copyWith(busy: true, prepared: false, verification: '', error: null, messageKey: null));
    try {
      _qr?.checkServer(selected);
      final pair = await inspect(selected, state.code.trim());
      if (!_current(generation)) return;
      _qr?.checkPair(pair);
      _requirePending(pair);
      if (!await confirm(pair) || !_current(generation)) return;
      DeviceRecord? authority;
      if (!control.hasRootAuthority) authority = await readAuthority();
      if (!_current(generation)) return;
      if (!control.hasRootAuthority && authority == null) return;
      _requirePending(pair);
      final code = await control.preparePairing(pair, authority: authority);
      if (!_current(generation)) return;
      _requirePending(pair);
      _pair = pair;
      _authority = authority;
      _expiry = Timer(Duration(seconds: pair.expiresAt.toInt() - DateTime.now().millisecondsSinceEpoch ~/ 1000), expire);
      emit(state.copyWith(prepared: true, verification: code, messageKey: 'pairingReady'));
    } catch (error) {
      if (_current(generation)) emit(state.copyWith(error: error));
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  void expire() {
    reset();
    if (!isClosed) emit(const PairingApprovalState(messageKey: 'pairingExpired'));
  }

  void _requirePending(Pairing pair) {
    if (pair.state != 'pending' || pair.expiresAt.toInt() <= DateTime.now().millisecondsSinceEpoch ~/ 1000) {
      throw const FormatException('Сопряжение истекло или уже использовано');
    }
  }

  Future<void> approve(String entered, Future<bool> Function() confirm) async {
    final control = manager(), pair = _pair, generation = _generation;
    if (isClosed || state.busy || control == null || pair == null) return;
    emit(state.copyWith(busy: true, messageKey: null, error: null));
    try {
      _requirePending(pair);
      if (entered.replaceAll(RegExp(r'[\s-]'), '').toUpperCase() != state.verification.replaceAll('-', '')) {
        emit(state.copyWith(messageKey: 'pairingMismatch'));
        return;
      }
      if (!await confirm() || !_current(generation)) return;
      _requirePending(pair);
      await control.approvePairing(pair, authority: _authority);
      if (!_current(generation)) return;
      reset();
      emit(const PairingApprovalState(messageKey: 'pairingSigned'));
    } catch (error) {
      if (_current(generation)) emit(state.copyWith(error: error));
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  @override
  Future<void> close() async {
    reset();
    await super.close();
  }
}
