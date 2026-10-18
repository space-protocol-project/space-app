import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/rpc_clients.dart';

List<int> transferAttachmentBytes() => List.generate(1024, (i) => i % 251);

Future<String> seedTransferAttachment(SpaceSession member) async {
  final bytes = transferAttachmentBytes();
  final started = await member.beginUpload(
    BeginUploadRequest(
      channelId: 'general',
      name: 'проверка-переноса.bin',
      byteSize: Int64(bytes.length),
      sha256: sha256.convert(bytes).bytes,
      idempotencyKey: 'transfer-asset',
    ),
  );
  await member.uploadChunk(
    UploadChunkRequest(
      assetId: started.asset.id,
      offset: Int64.ZERO,
      data: bytes,
    ),
  );
  await member.completeUpload(CompleteUploadRequest(assetId: started.asset.id));
  final message = await member.sendAttachments(
    'general',
    'Вложение до переноса',
    'transfer-file-message',
    [started.asset.id],
  );
  await member.setReaction(message, '❤️', true);
  return message.id;
}

Future<void> verifyTransferAttachment(
  SpaceSession member,
  String messageId,
) async {
  final message = (await member.messages()).singleWhere(
    (m) => m.id == messageId,
  );
  final asset = message.attachments.single;
  final download = await member.downloadChunk(
    DownloadChunkRequest(assetId: asset.id),
  );
  if (asset.name != 'проверка-переноса.bin' ||
      sha256.convert(download.data).toString() !=
          sha256.convert(transferAttachmentBytes()).toString() ||
      download.nextOffset.toInt() != transferAttachmentBytes().length) {
    throw StateError('Вложение потеряно или изменено после восстановления');
  }
  final reaction = message.reactions.single;
  if (reaction.emoji != '❤️' ||
      reaction.principalIds.single != member.principalId) {
    throw StateError('Реакция потеряна после восстановления');
  }
}
