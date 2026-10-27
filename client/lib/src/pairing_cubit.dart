import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_controller.dart';
import 'core.dart';
import 'pairing.dart';
import 'pairing_qr.dart';
import 'local_failure.dart';
import 'generated/space/v1/space.pb.dart';

part 'pairing_cubit.freezed.dart';

enum PairingIssue { start, expired, cancelled, verification, network, connection }

@freezed
abstract class PairingState with _$PairingState {
  const factory PairingState({
    @Default(false) bool busy,
    @Default(false) bool verified,
    @Default('') String code,
    @Default('') String verification,
    Uint8List? qr,
    PairingIssue? issue,
  }) = _PairingState;
}

class PairingCubit extends Cubit<PairingState> {
  PairingCubit(this.controller, {this.create = PendingPairing.start})
      : super(const PairingState()) {
    _server = controller.preview;
    _subscription = controller.stream.listen((_) {
      if (!identical(_server, controller.preview)) {
        _server = controller.preview;
        unawaited(cancel());
      }
    });
  }
  final ChatController controller;
  final Future<PendingPairing> Function(Discovery) create;
  late final StreamSubscription<ChatState> _subscription;
  Discovery? _server;
  PendingPairing? _pending;
  DeviceRecord? _candidate;
  Timer? _timer;
  Timer? _expiry;
  int _generation = 0;
  bool _polling = false;
  bool _closing = false;
  String? get candidateOrigin => _candidate?.origin;
  int get revision => _generation;

  bool _current(int generation) => !isClosed && !_closing && generation == _generation;

  Future<void> start() async {
    final server = controller.preview;
    if (isClosed || _closing || state.busy || _pending != null || server == null) return;
    final generation = ++_generation;
    emit(const PairingState(busy: true));
    PendingPairing? result;
    try {
      result = await create(server);
      if (!_current(generation)) { await result.close(); return; }
      _pending = result;
      final qr = await compute(pairingPng, PairingQr.request(server, result.request).encode());
      if (!_current(generation)) return;
      emit(PairingState(code: result.request.code, qr: qr));
      final expires = DateTime.fromMillisecondsSinceEpoch(result.request.pairing.expiresAt.toInt() * 1000);
      final remaining = expires.difference(DateTime.now());
      _expiry = Timer(remaining > const Duration(minutes: 5) ? const Duration(minutes: 5) : remaining,
          () => unawaited(_fail(PairingIssue.expired)));
      _timer = Timer.periodic(const Duration(seconds: 2), (_) => unawaited(poll()));
    } catch (_) {
      await result?.close();
      if (!_current(generation)) return;
      _pending = null;
      emit(const PairingState(issue: PairingIssue.start));
    }
  }

  bool get _expired => _pending!.request.pairing.expiresAt.toInt() <=
      DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Future<void> poll() async {
    final current = _pending, generation = _generation;
    if (isClosed || current == null) return;
    if (_expired) { await _fail(PairingIssue.expired); return; }
    if (_polling || _candidate != null || state.busy) return;
    _polling = true;
    try {
      final response = await current.poll();
      if (!_current(generation)) return;
      await _handleResponse(current, response, generation);
    } catch (error) {
      if (!_current(generation)) return;
      if (error is LocalFailure || error is FormatException) {
        await _fail(PairingIssue.verification);
      } else {
        emit(state.copyWith(issue: PairingIssue.network));
      }
    } finally {
      _polling = false;
    }
  }

  Future<void> _handleResponse(PendingPairing current, PollPairingResponse response, int generation) async {
    switch (response.pairing.state) {
        case 'cancelled': await _fail(PairingIssue.cancelled);
        case 'approved': await _verify(current, response, generation);
        case 'pending': await _showCode(current, generation);
        default: await _fail(PairingIssue.verification);
      }
  }

  Future<String> _code(PendingPairing current, List<int> root) => pairVerificationCode(
    current.server.serverId, current.request.pairing.id, root,
    current.request.pairing.publicKey,
    administrative: current.request.pairing.administrative,
  );

  Future<void> _verify(PendingPairing current, PollPairingResponse response, int generation) async {
    final record = await current.verifiedRecord(response);
    final code = await _code(current, record.rootPublicKey);
    if (!_current(generation)) { _erase(record); return; }
    _candidate = record;
    emit(state.copyWith(verified: true, verification: code, issue: null));
  }

  Future<void> _showCode(PendingPairing current, int generation) async {
    var code = '';
    if (current.proposedRoot != null) code = await _code(current, current.proposedRoot!);
    if (_current(generation)) emit(state.copyWith(verification: code, issue: null));
  }

  Future<bool> accept(int revision) async {
    final current = _pending, record = _candidate, generation = _generation;
    if (!_current(revision) || current == null || record == null || state.busy) return false;
    if (_expired) { await _fail(PairingIssue.expired); return false; }
    emit(state.copyWith(busy: true, issue: null));
    _timer?.cancel();
    _expiry?.cancel();
    try {
      // После передачи запись принадлежит контроллеру, её нельзя стирать при отмене.
      _candidate = null;
      await controller.connect(restoredRecord: record, pairingId: current.request.pairing.id);
      if (!_current(generation)) return false;
      if (!controller.connected) {
        await _fail(PairingIssue.connection);
        return false;
      }
      current.claimed = true;
      await cancel();
      return true;
    } catch (_) {
      if (_current(generation)) await _fail(PairingIssue.connection);
      return false;
    }
  }

  void _erase(DeviceRecord? record) {
    if (record != null) record.deviceSeed.fillRange(0, record.deviceSeed.length, 0);
  }

  Future<void> _fail(PairingIssue issue) async {
    await cancel(issue: issue);
  }

  Future<void> cancel({PairingIssue? issue}) async {
    ++_generation;
    _timer?.cancel();
    _timer = null;
    _expiry?.cancel();
    _expiry = null;
    final current = _pending;
    _pending = null;
    _erase(_candidate);
    _candidate = null;
    if (!isClosed && !_closing) emit(PairingState(issue: issue));
    await current?.close();
  }

  @override
  Future<void> close() async {
    _closing = true;
    await cancel();
    await _subscription.cancel();
    await super.close();
  }
}
