import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cross_file/cross_file.dart';
import 'package:fixnum/fixnum.dart';

import '../rpc_clients.dart';
import 'client.dart';

class MlsFiles {
  MlsFiles(this.client);
  final MlsClient client;
  AssetServiceClient get rpc => AssetServiceClient(client.connection);

  Future<void> send(
    String channel,
    List<int> group,
    String text,
    List<XFile> files,
  ) async {
    if (files.length > 5) throw StateError('Не более пяти файлов');
    final messageId = mlsId();
    final descriptors = <Map<String, dynamic>>[];
    final ids = <String>[];
    for (final file in files) {
      final size = await file.length();
      if (size < 1 || size > 20 * 1024 * 1024) {
        throw StateError('Размер файла должен быть от 1 байта до 20 МиБ');
      }
      final sealed = await client.local.update('seal_file', {
        'group_id': base64Encode(group),
        'message_id': messageId,
        'name': file.name,
        'plaintext': base64Encode(await file.readAsBytes()),
      });
      final ciphertext = base64Decode(sealed['ciphertext'] as String);
      final asset = await _upload(channel, ciphertext);
      final descriptor = Map<String, dynamic>.from(sealed['descriptor'] as Map);
      descriptor['asset_id'] = asset.id;
      descriptors.add(descriptor);
      ids.add(asset.id);
    }
    await client.send(
      channel,
      text,
      files: descriptors,
      assetIds: ids,
      messageId: messageId,
    );
  }

  Future<Asset> _upload(String channel, Uint8List bytes) async {
    final upload = await rpc.beginUpload(
      BeginUploadRequest(
        channelId: channel,
        name: 'encrypted-file',
        encrypted: true,
        byteSize: Int64(bytes.length),
        sha256: sha256.convert(bytes).bytes,
        idempotencyKey: base64UrlEncode(mlsId()),
      ),
      options: await client.options(),
    );
    var offset = upload.receivedBytes.toInt();
    while (offset < bytes.length) {
      final end = (offset + 256 * 1024).clamp(0, bytes.length);
      final part = await rpc.uploadChunk(
        UploadChunkRequest(
          assetId: upload.asset.id,
          offset: Int64(offset),
          data: bytes.sublist(offset, end),
        ),
        options: await client.options(),
      );
      if (part.receivedBytes.toInt() != end) {
        throw StateError('Неверное подтверждение части файла');
      }
      offset = end;
    }
    return (await rpc.completeUpload(
      CompleteUploadRequest(assetId: upload.asset.id),
      options: await client.options(),
    )).asset;
  }

  Future<Uint8List> download(
    List<int> group,
    List<int> messageId,
    Map<String, dynamic> descriptor,
  ) async {
    final assetId = descriptor['asset_id'] as String;
    final expectedSize = (descriptor['size'] as int) + 16;
    if (expectedSize < 17 || expectedSize > 20 * 1024 * 1024 + 16) {
      throw StateError('Некорректный размер вложения');
    }
    final data = BytesBuilder(copy: false);
    var offset = 0;
    while (offset < expectedSize) {
      final chunk = await rpc.downloadChunk(
        DownloadChunkRequest(assetId: assetId, offset: Int64(offset)),
        options: await client.options(),
      );
      if (chunk.asset.byteSize.toInt() != expectedSize ||
          chunk.nextOffset.toInt() <= offset ||
          chunk.nextOffset.toInt() != offset + chunk.data.length ||
          chunk.nextOffset.toInt() > expectedSize) {
        throw StateError('Нарушена передача зашифрованного файла');
      }
      data.add(chunk.data);
      offset = chunk.nextOffset.toInt();
    }
    final opened = await client.local.update('open_file', {
      'group_id': base64Encode(group),
      'message_id': messageId,
      'descriptor': descriptor,
      'ciphertext': base64Encode(data.takeBytes()),
    });
    return base64Decode(opened['plaintext'] as String);
  }
}
