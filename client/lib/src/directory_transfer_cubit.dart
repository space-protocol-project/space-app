import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:space_directory_noise/space_directory_noise.dart';

import 'chat_controller.dart';
import 'core.dart';
import 'directory_backup.dart';
import 'settings_snapshot.dart';
import 'directory_document.dart';
import 'directory_transfer.dart';
import 'directory_transfer_qr.dart';
import 'directory_transfer_rpc.dart';

part 'directory_transfer_cubit.freezed.dart';

enum DirectoryTransferStage {
  idle,
  waiting,
  compare,
  sending,
  preview,
  done,
  failed,
}

@freezed
abstract class DirectoryTransferState with _$DirectoryTransferState {
  const factory DirectoryTransferState({
    @Default(DirectoryTransferStage.idle) DirectoryTransferStage stage,
    @Default(false) bool receiving,
    @Default(false) bool replaceSettings,
    @Default({}) Map<String, SettingsChoice> settingsChoices,
    @Default('') String qr,
    @Default('') String sas,
    @Default([]) List<String> selected,
    DirectoryRestorePlan? plan,
  }) = _DirectoryTransferState;
}

class DirectoryTransferCubit extends Cubit<DirectoryTransferState> {
  DirectoryTransferCubit(
    this.service,
    this.controller, {
    DirectoryTransfer Function(Discovery)? create,
  }) : create =
           create ??
           ((server) => DirectoryTransfer(
             server,
             RpcDirectoryRelay(server),
             const NativeDirectoryNoise(),
           )),
       super(const DirectoryTransferState()) {
    _server = controller.preview;
    _subscription = controller.stream.listen((_) {
      if (!identical(_server, controller.preview)) {
        _server = controller.preview;
        unawaited(cancel());
      }
    });
  }
  final DirectoryBackupService service;
  final ChatController controller;
  final DirectoryTransfer Function(Discovery) create;
  Discovery? _server;
  DirectoryTransfer? _transfer;
  DirectoryDocument? _document;
  late final StreamSubscription<ChatState> _subscription;
  Timer? _expiry;
  int _generation = 0;
  bool _closing = false;
  bool _current(int generation) =>
      !isClosed && !_closing && generation == _generation;
  bool get active => _transfer != null;
  void select(String origin, bool value) {
    if (isClosed || active) return;
    final selected = state.selected.toSet();
    if (value) {
      selected.add(origin);
    } else {
      selected.remove(origin);
    }
    if (selected.length <= 12) {
      emit(state.copyWith(selected: selected.toList()));
    }
  }

  void chooseSetting(String key, SettingsChoice choice) {
    final plan = state.plan;
    if (isClosed || state.stage != DirectoryTransferStage.preview || plan == null || !plan.settingsMerge.conflicts.contains(key)) return;
    emit(state.copyWith(settingsChoices: {...state.settingsChoices, key: choice}));
  }
  void replaceSettings(bool value) {
    if (!isClosed && state.stage == DirectoryTransferStage.preview) {
      emit(state.copyWith(replaceSettings: value, settingsChoices: const {}));
    }
  }

  Future<void> _run(Future<void> Function(int) operation) async {
    final generation = _generation;
    try {
      await operation(generation);
    } catch (_) {
      if (_current(generation)) {
        await _dispose();
        if (_current(generation)) {
          emit(
            state.copyWith(
              stage: DirectoryTransferStage.failed,
              qr: '',
              sas: '',
              plan: null,
            ),
          );
        }
      }
    }
  }

  Future<void> start({String? qr}) async {
    if (isClosed || _closing || active || _server == null) return;
    if (state.stage != DirectoryTransferStage.idle) return;
    final receiving = qr == null;
    if (!receiving && state.selected.isEmpty) return;
    ++_generation;
    emit(
      state.copyWith(
        stage: DirectoryTransferStage.waiting,
        receiving: receiving,
        qr: '',
        sas: '',
        plan: null,
        replaceSettings: false, settingsChoices: const {},
      ),
    );
    await _run((generation) async {
      final transfer = create(_server!);
      _transfer = transfer;
      _expiry = Timer(
        const Duration(minutes: 5),
        () => unawaited(cancel(expired: true)),
      );
      if (qr == null) {
        await _startReceiving(transfer, generation);
      } else {
        await _startSending(transfer, qr, generation);
      }
      _comparison(transfer, generation);
    });
  }

  Future<void> _startReceiving(
    DirectoryTransfer transfer,
    int generation,
  ) async {
    final request = await transfer.receiveStart();
    if (!_current(generation)) return;
    emit(state.copyWith(qr: request.encode()));
    await transfer.receiveHandshake();
  }

  Future<void> _startSending(
    DirectoryTransfer transfer,
    String qr,
    int generation,
  ) async {
    final request = DirectoryTransferQr.parse(qr);
    request.checkServer(_server!);
    final selected = state.selected;
    final document = await service.repository.exclusive(
      () => service.capture(selectedOrigins: selected),
    );
    if (!_current(generation)) return;
    _document = document;
    await transfer.sendStart(request);
  }

  void _comparison(DirectoryTransfer transfer, int generation) {
    if (_current(generation)) {
      emit(
        state.copyWith(
          stage: DirectoryTransferStage.compare,
          sas: transfer.sas,
        ),
      );
    }
  }

  Future<void> confirm(String comparison) async {
    if (state.stage != DirectoryTransferStage.compare || _transfer == null) {
      return;
    }
    final transfer = _transfer!;
    emit(state.copyWith(stage: DirectoryTransferStage.sending));
    await _run(
      (generation) => state.receiving
          ? _receive(transfer, generation)
          : _send(transfer, comparison, generation),
    );
  }

  Future<void> _receive(DirectoryTransfer transfer, int generation) async {
    final plan = await transfer.receive(service);
    if (!_current(generation)) return;
    await _dispose();
    if (_current(generation)) {
      emit(
        state.copyWith(
          stage: DirectoryTransferStage.preview,
          plan: plan,
          qr: '',
          sas: '',
        ),
      );
    }
  }

  Future<void> _send(
    DirectoryTransfer transfer,
    String comparison,
    int generation,
  ) async {
    await transfer.send(comparison, _document!);
    if (!_current(generation)) return;
    await _dispose();
    if (_current(generation)) {
      emit(state.copyWith(stage: DirectoryTransferStage.done, qr: '', sas: ''));
    }
  }

  Future<void> apply() async {
    final plan = state.plan;
    if (state.stage != DirectoryTransferStage.preview ||
        plan == null ||
        plan.conflicts.isNotEmpty || !plan.settingsResolved(state.replaceSettings, state.settingsChoices)) {
      return;
    }
    final replace = state.replaceSettings;
    emit(state.copyWith(stage: DirectoryTransferStage.sending));
    await _run((generation) async {
      await service.apply(plan, replaceSettings: replace, settingsChoices: state.settingsChoices);
      if (_current(generation)) {
        emit(state.copyWith(stage: DirectoryTransferStage.done, plan: null));
      }
    });
  }

  Future<void> _dispose() async {
    _expiry?.cancel();
    _expiry = null;
    final transfer = _transfer;
    _transfer = null;
    _document = null;
    await transfer?.close();
  }

  Future<void> cancel({bool expired = false}) async {
    final generation = ++_generation;
    await _dispose();
    if (_current(generation)) {
      emit(
        DirectoryTransferState(
          selected: state.selected,
          stage: expired
              ? DirectoryTransferStage.failed
              : DirectoryTransferStage.idle,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _closing = true;
    ++_generation;
    await _subscription.cancel();
    await _dispose();
    return super.close();
  }
}
