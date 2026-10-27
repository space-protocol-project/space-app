import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'directory_archive.dart';
import 'directory_backup.dart';
import 'directory_document.dart';

part 'directory_backup_cubit.freezed.dart';

Future<Uint8List> sealDirectoryWorker((Map<String, dynamic>, String) input) =>
    DirectoryArchive.seal(DirectoryDocument.parse(input.$1), input.$2);
Future<Map<String, dynamic>> openDirectoryWorker(
  (Uint8List, String) input,
) async => (await DirectoryArchive.open(input.$1, input.$2)).data;

@freezed
abstract class DirectoryBackupState with _$DirectoryBackupState {
  const factory DirectoryBackupState({
    @Default(false) bool busy,
    @Default(false) bool replaceSettings,
    @Default('') String message,
    @Default([]) List<String> results,
    DirectoryRestorePlan? plan,
    Object? error,
  }) = _DirectoryBackupState;
}

class DirectoryBackupCubit extends Cubit<DirectoryBackupState> {
  DirectoryBackupCubit(this.service) : super(const DirectoryBackupState());
  final DirectoryBackupService service;
  int _generation = 0;
  bool _current(int value) => !isClosed && value == _generation;
  void replaceSettings(bool value) {
    if (!isClosed && !state.busy) emit(state.copyWith(replaceSettings: value));
  }

  void reset() {
    if (isClosed || state.busy) return;
    ++_generation;
    emit(const DirectoryBackupState());
  }

  Future<void> _run(Future<void> Function(int) operation) async {
    if (isClosed || state.busy) return;
    final generation = ++_generation;
    emit(
      state.copyWith(busy: true, error: null, message: '', results: const []),
    );
    try {
      await operation(generation);
    } catch (error) {
      if (_current(generation)) emit(state.copyWith(error: error));
    } finally {
      if (_current(generation)) emit(state.copyWith(busy: false));
    }
  }

  Future<void> export(String password, Future<bool> Function(Uint8List) save) =>
      _run(
        (generation) => service.repository.exclusive(() async {
          final document = await service.capture();
          final file = await compute(sealDirectoryWorker, (
            document.data,
            password,
          ));
          final checked = DirectoryDocument.parse(
            await compute(openDirectoryWorker, (file, password)),
          );
          directoryRequire(await checked.digest() == await document.digest());
          if (!_current(generation)) return;
          if (!await save(file)) return;
          await service.recordExport(document);
          if (_current(generation)) {
            emit(
              state.copyWith(
                message: 'saved',
                plan: null,
                results: document.spaces
                    .where((s) => s['following_status'] != 'complete')
                    .map((s) => s['origin'] as String)
                    .toList(),
              ),
            );
          }
        }),
      );

  Future<void> preview(Uint8List file, String password) =>
      _run((generation) async {
        emit(state.copyWith(plan: null));
        final document = DirectoryDocument.parse(
          await compute(openDirectoryWorker, (file, password)),
        );
        final plan = await service.preview(document);
        if (_current(generation)) {
          emit(state.copyWith(plan: plan, message: 'preview'));
        }
      });
  Future<void> apply() => _run((generation) async {
    final plan = state.plan;
    if (plan == null || plan.conflicts.isNotEmpty) return;
    await service.apply(plan, replaceSettings: state.replaceSettings);
    if (_current(generation)) {
      emit(state.copyWith(plan: null, message: 'restored'));
    }
  });
  Future<void> resume() => _run((generation) async {
    await service.resume();
    if (_current(generation)) {
      emit(state.copyWith(message: 'restored', plan: null));
    }
  });
  Future<void> restoreFollowing() => _run((generation) async {
    final result = await service.restoreFollowing(active: () => _current(generation));
    if (_current(generation)) {
      emit(state.copyWith(message: 'following', results: result));
    }
  });
  @override
  Future<void> close() {
    ++_generation;
    return super.close();
  }
}
