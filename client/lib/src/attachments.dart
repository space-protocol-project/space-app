import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:crypto/crypto.dart' as crypto;

import 'files.dart';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';

import 'core.dart';
import 'rpc_clients.dart';

part 'attachments.freezed.dart';

const maxAttachmentSize = 20 * 1024 * 1024;
const maxAttachments = 5;

class PendingAttachment {
  PendingAttachment(this.file, this.size, {String? requestKey})
    : key = requestKey ?? newRequestKey();
  final SpaceFile file;
  final int size;
  final String key;
  String get name => attachmentName(file);
  Asset? asset;
  String? hash;
}

@Freezed(equal: false)
abstract class AttachmentState with _$AttachmentState {
  const AttachmentState._();
  const factory AttachmentState({
    @Default([]) List<PendingAttachment> files,
    @Default(false) bool busy,
    @Default(0) double progress,
    @Default('') String error,
    Object? problem,
  }) = _AttachmentState;
}

sealed class AttachmentEvent {}

class AttachmentFilesAdded extends AttachmentEvent {
  AttachmentFilesAdded(this.files);
  final List<SpaceFile> files;
}

class AttachmentQueue extends Cubit<AttachmentState> {
  AttachmentQueue({List<PendingAttachment> files = const [], this.suspended})
    : super(AttachmentState(files: List.unmodifiable(files)));
  final bool Function()? suspended;
  Future<void> add(AttachmentFilesAdded event) async {
    if (state.busy || _adding) return;
    _adding = true;
    try {
      if (state.files.length + event.files.length > maxAttachments) {
        throw StateError('Можно прикрепить не более пяти файлов');
      }
      final additions = <PendingAttachment>[];
      for (final file in event.files) {
        additions.add(await _prepare(file));
      }
      if (isClosed) return;
      emit(
        AttachmentState(
          files: List.unmodifiable([...state.files, ...additions]),
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          AttachmentState(files: state.files, error: e.toString(), problem: e),
        );
      }
    } finally {
      _adding = false;
    }
  }

  Future<PendingAttachment> _prepare(SpaceFile file) async {
    final size = await file.declaredLength();
    if (size != null && size > maxAttachmentSize) {
      throw StateError('Размер каждого файла должен быть от 1 байта до 20 МиБ');
    }
    if (file.transient) return _retain(file, size);
    if (size == null || size < 1) throw StateError('Пустой файл');
    return PendingAttachment(file, size);
  }

  Future<PendingAttachment> _retain(SpaceFile file, int? declaredSize) async {
    final bytes = await readAttachmentBytes(file);
    if (declaredSize != null && bytes.length != declaredSize) {
      throw StateError('Размер файла изменился');
    }
    return PendingAttachment(
      SpaceFile.fromData(bytes, name: file.name),
      bytes.length,
    );
  }

  bool _adding = false;
  bool _cancelled = false;
  void cancel() {
    _cancelled = true;
  }

  Future<void> remove(
    PendingAttachment file, {
    AttachmentSession? session,
  }) async {
    if (state.busy) return;
    emit(
      AttachmentState(
        files: List.unmodifiable(state.files.where((f) => f != file)),
      ),
    );
    if (file.asset != null && session != null) {
      try {
        await session.cancelUpload(
          CancelUploadRequest(assetId: file.asset!.id),
        );
      } catch (_) {}
    }
  }

  void clear() {
    if (isClosed) return;
    emit(const AttachmentState());
  }

  void _checkCancelled() {
    if (_cancelled || isClosed) throw StateError('Загрузка отменена');
    if (suspended?.call() == true) {
      throw const GrpcError.cancelled('Загрузка приостановлена');
    }
  }

  void _progress(double value) {
    if (!isClosed) {
      emit(AttachmentState(files: state.files, busy: true, progress: value));
    }
  }

  Future<List<String>?> upload(
    AttachmentSession session,
    String channel,
  ) async {
    if (state.busy || _adding) return null;
    _cancelled = false;
    _progress(0);
    try {
      final ids = <String>[];
      final files = List.of(state.files);
      for (var index = 0; index < files.length; index++) {
        _checkCancelled();
        final file = files[index];
        final asset =
            file.asset ??
            await _uploadFile(
              session,
              channel,
              file,
              (fraction) => _progress((index + fraction) / files.length),
            );
        file.asset = asset;
        ids.add(asset.id);
      }
      if (!isClosed) emit(AttachmentState(files: state.files, progress: 1));
      return ids;
    } catch (e) {
      if (!isClosed) {
        emit(
          AttachmentState(files: state.files, error: e.toString(), problem: e),
        );
      }
      return null;
    }
  }

  Future<Asset> _uploadFile(
    AttachmentSession session,
    String channel,
    PendingAttachment file,
    void Function(double) progress,
  ) async {
    final bytes = await _readPending(file);
    if (bytes.length != file.size || bytes.length > maxAttachmentSize) {
      throw StateError('Размер выбранного файла изменился');
    }
    final hash = crypto.sha256.convert(bytes);
    if (file.hash != null && file.hash != hash.toString()) {
      throw StateError('Файл изменился. Уберите его и выберите заново');
    }
    file.hash = hash.toString();
    _checkCancelled();
    final started = await session.beginUpload(
      BeginUploadRequest(
        channelId: channel,
        name: file.name,
        byteSize: Int64(bytes.length),
        sha256: hash.bytes,
        idempotencyKey: file.key,
      ),
    );
    _verifyAsset(started.asset, channel, file, hash);
    if (started.chunkSize < 1 || started.chunkSize > 256 * 1024) {
      throw StateError('Некорректный размер части файла');
    }
    var offset = started.receivedBytes.toInt();
    if (offset < 0 || offset > bytes.length) {
      throw StateError('Некорректный ответ загрузки');
    }
    try {
      await _uploadChunks(session, started, bytes, offset, progress);
      _checkCancelled();
      return await _completeFile(
        session,
        started.asset.id,
        channel,
        file,
        hash,
      );
    } catch (_) {
      await _cancelUploadIfRequested(session, started.asset.id);
      rethrow;
    }
  }

  Future<void> _uploadChunks(
    AttachmentSession session,
    BeginUploadResponse started,
    Uint8List bytes,
    int offset,
    void Function(double) progress,
  ) async {
    while (offset < bytes.length) {
      _checkCancelled();
      final end = (offset + started.chunkSize).clamp(0, bytes.length);
      final reply = await session.uploadChunk(
        UploadChunkRequest(
          assetId: started.asset.id,
          offset: Int64(offset),
          data: Uint8List.sublistView(bytes, offset, end),
        ),
      );
      if (reply.receivedBytes.toInt() != end) {
        throw StateError('Нарушен порядок частей файла');
      }
      offset = end;
      progress(offset / bytes.length);
    }
  }

  Future<void> _cancelUploadIfRequested(
    AttachmentSession session,
    String id,
  ) async {
    if (!_cancelled) return;
    try {
      await session.cancelUpload(CancelUploadRequest(assetId: id));
    } catch (_) {}
  }

  @override
  Future<void> close() {
    cancel();
    return super.close();
  }

  Future<Uint8List> _readPending(PendingAttachment file) =>
      readAttachmentBytes(file.file, cancelled: () => _cancelled || isClosed);

  Future<Asset> _completeFile(
    AttachmentSession session,
    String id,
    String channel,
    PendingAttachment file,
    crypto.Digest hash,
  ) async {
    final completed = await session.completeUpload(
      CompleteUploadRequest(assetId: id),
    );
    _checkCancelled();
    _verifyAsset(completed.asset, channel, file, hash);
    if (completed.asset.id != id) throw StateError('Подтверждён другой файл');
    return completed.asset;
  }

  void _verifyAsset(
    Asset asset,
    String channel,
    PendingAttachment file,
    crypto.Digest hash,
  ) {
    if (asset.id.isEmpty ||
        asset.channelId != channel ||
        asset.name != file.name ||
        asset.byteSize.toInt() != file.size ||
        asset.sha256.length != 32 ||
        crypto.Digest(asset.sha256).toString() != hash.toString()) {
      throw const FormatException('Ответ загрузки относится к другому файлу');
    }
  }
}

String attachmentName(SpaceFile file) =>
    file.name.replaceAll('\\', '/').split('/').last;

Future<Uint8List> readAttachmentBytes(
  SpaceFile file, {
  bool Function()? cancelled,
}) async {
  final result = BytesBuilder(copy: false);
  await for (final chunk in file.openRead()) {
    if (cancelled?.call() == true) throw StateError('Загрузка отменена');
    if (result.length + chunk.length > maxAttachmentSize) {
      throw StateError('Файл превышает 20 МиБ');
    }
    result.add(chunk);
  }
  if (result.isEmpty) throw StateError('Пустой файл');
  return result.takeBytes();
}

Future<Uint8List> downloadAttachment(
  AttachmentSession session,
  Asset asset, {
  bool Function()? cancelled,
}) async {
  final size = asset.byteSize.toInt();
  if (size < 1 || size > maxAttachmentSize) {
    throw StateError('Недопустимый размер файла');
  }
  final bytes = BytesBuilder(copy: false);
  var offset = 0;
  while (offset < size) {
    if (cancelled?.call() == true) throw StateError('Загрузка отменена');
    final reply = await session.downloadChunk(
      DownloadChunkRequest(assetId: asset.id, offset: Int64(offset)),
    );
    final end = offset + reply.data.length;
    if (reply.asset.id != asset.id ||
        reply.data.isEmpty ||
        reply.data.length > 256 * 1024 ||
        end > size ||
        reply.nextOffset.toInt() != end) {
      throw StateError('Некорректная часть файла');
    }
    bytes.add(reply.data);
    offset = end;
  }
  if (cancelled?.call() == true) throw StateError('Загрузка отменена');
  final result = bytes.takeBytes();
  final digest = crypto.sha256.convert(result).bytes;
  if (digest.length != asset.sha256.length ||
      !List.generate(
        digest.length,
        (i) => digest[i] == asset.sha256[i],
      ).every((same) => same)) {
    throw StateError('Контрольная сумма файла не совпадает');
  }
  return result;
}

String attachmentSize(int bytes) => bytes < 1024
    ? '$bytes Б'
    : bytes < 1024 * 1024
    ? '${(bytes / 1024).toStringAsFixed(1)} КиБ'
    : '${(bytes / 1024 / 1024).toStringAsFixed(1)} МиБ';
