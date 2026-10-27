import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'archive_documents.dart';

part 'archive_transfer_cubit.freezed.dart';

typedef ArchiveTransferAction = Future<void> Function(
  String path, String password, void Function(String) progress,
  Future<void> Function() beforeCommit,
);

@freezed
abstract class ArchiveTransferState with _$ArchiveTransferState {
  const factory ArchiveTransferState({
    @Default(false) bool busy,
    @Default(false) bool cancellable,
    @Default(false) bool cancelling,
    @Default(false) bool finished,
    @Default(false) bool saved,
    @Default(0) int bytes,
    @Default('') String status,
    ArchiveWorkspace? pending,
    Object? error,
  }) = _ArchiveTransferState;
}

class ArchiveTransferCubit extends Cubit<ArchiveTransferState> {
  ArchiveTransferCubit(this.documents, {required this.export, required this.restore})
    : super(const ArchiveTransferState()) {
    documents.progress = (bytes) {
      if (!isClosed && state.busy && state.cancellable) {
        emit(state.copyWith(bytes: bytes));
      }
    };
  }
  final ArchiveDocuments documents;
  final ArchiveTransferAction export, restore;
  // Не допускает второго изменения ключей при повторном открытии экрана.
  static bool _operating = false;

  void _publish(ArchiveTransferState next) { if (!isClosed) emit(next); }
  void _status(String value) => _publish(state.copyWith(status: value));

  Future<void> _run(Future<void> Function() action, {bool cancellable = false}) async {
    if (state.busy || isClosed) return;
    if (_operating) {
      _publish(state.copyWith(error: StateError('Дождитесь завершения текущего переноса')));
      return;
    }
    _operating = true;
    _publish(state.copyWith(busy: true, cancellable: cancellable, cancelling: false,
      error: null, bytes: 0, status: ''));
    try {
      await action();
    } on PlatformException catch (error) {
      if (error.code != 'cancelled') _publish(state.copyWith(error: error));
    } catch (error) {
      _publish(state.copyWith(error: error));
    } finally {
      _operating = false;
      _publish(state.copyWith(busy: false, cancellable: false, cancelling: false));
      if (isClosed) documents.dispose();
    }
  }

  Future<void> load() => _run(() async {
    _publish(state.copyWith(pending: await documents.status()));
  });

  Future<void> pick() => _run(() async {
    if (state.pending != null) throw StateError('Сначала завершите прежний перенос');
    _publish(state.copyWith(pending: await documents.pick()));
  }, cancellable: true);

  Future<void> prepare(String password) => _run(() async {
    final pending = state.pending ?? await documents.prepare();
    _publish(state.copyWith(pending: pending));
    if (pending.mode != ArchiveMode.exporting) throw StateError('Начато восстановление');
    if (!pending.complete) await export(pending.path, password, _status, () async {});
    await documents.ready();
    _publish(state.copyWith(pending: await documents.status()));
  });

  Future<void> save() => _run(() async {
    if (state.pending?.mode != ArchiveMode.exporting) throw StateError('Нет готового экспорта');
    await documents.ready();
    if (state.cancelling || isClosed) throw PlatformException(code: 'cancelled');
    final saved = await documents.save();
    _publish(state.copyWith(saved: saved, finished: saved));
  }, cancellable: true);

  Future<void> apply(String password) => _run(() async {
    final pending = state.pending;
    if (pending == null || pending.mode != ArchiveMode.importing) {
      throw StateError('Нет архива восстановления');
    }
    await restore(pending.path, password, _status, () async {
      await documents.applying();
      _publish(state.copyWith(pending: await documents.status()));
    });
    await documents.complete();
    _publish(state.copyWith(pending: null, finished: true));
  });

  Future<void> discard() => _run(() async {
    await documents.discard();
    _publish(const ArchiveTransferState(busy: true));
  });

  Future<void> acknowledgeCleanup() => _run(() async {
    await documents.acknowledgeCleanup();
    _publish(state.copyWith(pending: await documents.status()));
  });

  Future<void> cancel() async {
    if (!state.busy || !state.cancellable || state.cancelling) return;
    _publish(state.copyWith(cancelling: true));
    try { await documents.cancel(); }
    catch (error) { _publish(state.copyWith(error: error)); }
  }

  @override
  Future<void> close() async {
    if (state.busy && state.cancellable) await documents.cancel();
    documents.progress = null;
    // Канал может оставаться нужен незавершённому критическому действию.
    if (!state.busy) documents.dispose();
    await super.close();
  }
}
