import 'dart:async';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:space_client/src/files.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/rpc_clients.dart';

class FilesSession implements AttachmentSession {
  final data = <int>[];
  Asset? asset;
  bool failOnce = false, cancelled = false, corruptDownload = false;
  Completer<void>? hold;
  final keys = <String>[];
  @override
  Future<BeginUploadResponse> beginUpload(BeginUploadRequest request) async {
    keys.add(request.idempotencyKey);
    asset ??= Asset(
      id: 'asset',
      name: request.name,
      channelId: request.channelId,
      sha256: request.sha256,
      byteSize: request.byteSize,
    );
    return BeginUploadResponse(
      asset: asset,
      receivedBytes: Int64(data.length),
      chunkSize: 256 * 1024,
    );
  }

  @override
  Future<UploadChunkResponse> uploadChunk(UploadChunkRequest request) async {
    if (hold != null) await hold!.future;
    if (failOnce) {
      failOnce = false;
      throw StateError('network');
    }
    expect(request.offset.toInt(), data.length);
    data.addAll(request.data);
    return UploadChunkResponse(receivedBytes: Int64(data.length));
  }

  @override
  Future<CompleteUploadResponse> completeUpload(
    CompleteUploadRequest request,
  ) async => CompleteUploadResponse(asset: asset);
  @override
  Future<CancelUploadResponse> cancelUpload(CancelUploadRequest request) async {
    cancelled = true;
    data.clear();
    return CancelUploadResponse();
  }

  @override
  Future<DownloadChunkResponse> downloadChunk(
    DownloadChunkRequest request,
  ) async {
    final start = request.offset.toInt(),
        end = (request.offset.toInt() + 256 * 1024).clamp(0, data.length);
    final chunk = data.sublist(start, end);
    if (corruptDownload) chunk[0] ^= 1;
    return DownloadChunkResponse(
      asset: asset,
      data: chunk,
      nextOffset: Int64(end),
    );
  }

  @override
  Future<ListMyAssetsResponse> listMyAssets(
    ListMyAssetsRequest request,
  ) async => ListMyAssetsResponse();

  @override
  Future<ListChannelAssetsResponse> listChannelAssets(
    ListChannelAssetsRequest request,
  ) async => ListChannelAssetsResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SpaceFile file(int length) => SpaceFile.fromData(
  Uint8List.fromList(List.generate(length, (i) => i % 256)),
  name: 'file.bin',
  path: 'file.bin',
);
void main() {
  test('Пять файлов, размер и пустые файлы проверяются до загрузки', () async {
    final queue = AttachmentQueue();
    addTearDown(queue.close);
    await queue.add(AttachmentFilesAdded(List.generate(5, (_) => file(1))));
    expect(queue.state.files.length, 5);
    await queue.add(AttachmentFilesAdded([file(1)]));
    expect(queue.state.files.length, 5);
    expect(queue.state.error, isNotEmpty);
    queue.clear();
    await queue.add(AttachmentFilesAdded([file(0)]));
    expect(queue.state.files, isEmpty);
  });
  test('Файл загружается частями и скачивается с проверкой SHA256', () async {
    final queue = AttachmentQueue();
    addTearDown(queue.close);
    final session = FilesSession();
    await queue.add(AttachmentFilesAdded([file(256 * 1024 + 7)]));
    expect(await queue.upload(session, 'channel'), ['asset']);
    expect(session.asset!.channelId, 'channel');
    final downloaded = await downloadAttachment(session, session.asset!);
    expect(crypto.sha256.convert(downloaded).bytes, session.asset!.sha256);
    session.corruptDownload = true;
    await expectLater(
      downloadAttachment(session, session.asset!),
      throwsStateError,
    );
  });
  test('Повтор после ошибки использует прежний ключ загрузки', () async {
    final queue = AttachmentQueue();
    addTearDown(queue.close);
    final session = FilesSession()..failOnce = true;
    await queue.add(AttachmentFilesAdded([file(12)]));
    expect(await queue.upload(session, 'channel'), isNull);
    expect(queue.state.files.length, 1);
    expect(await queue.upload(session, 'channel'), ['asset']);
    expect(session.keys[0], session.keys[1]);
    expect(session.data.length, 12);
  });
  test(
    'Отмена во время RPC останавливает загрузку и освобождает резерв',
    () async {
      final queue = AttachmentQueue();
      addTearDown(queue.close);
      final session = FilesSession()..hold = Completer<void>();
      await queue.add(AttachmentFilesAdded([file(256 * 1024 + 1)]));
      final upload = queue.upload(session, 'channel');
      while (session.asset == null) {
        await Future<void>.delayed(Duration.zero);
      }
      queue.cancel();
      session.hold!.complete();
      expect(await upload, isNull);
      expect(session.cancelled, isTrue);
      expect(queue.state.busy, isFalse);
    },
  );
}
