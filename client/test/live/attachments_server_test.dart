import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/rpc_clients.dart';

class _MemoryVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = value;
  }
}

void main() {
  final origin = Platform.environment['SPACE_ATTACHMENTS_TEST_ORIGIN'];
  test(
    'v0.3: два настоящих клиента, файл, подписка, повторный вход и ник',
    () async {
      final uri = Uri.parse(origin!);
      expect(uri.scheme, 'http');
      expect(
        InternetAddress.tryParse(uri.host)?.isLoopback,
        isTrue,
        reason: 'Только отдельный локальный тестовый сервер',
      );
      final discovery = await discover(origin);
      final ownerVault = _MemoryVault(), memberVault = _MemoryVault();
      final owner = await SpaceSession.connect(discovery, ownerVault);
      addTearDown(owner.close);
      expect(owner.role, 'owner', reason: 'Нужна новая изолированная база');
      final member = await SpaceSession.connect(discovery, memberVault);
      addTearDown(member.close);
      await member.setNickname('Участник v0.3');
      final members = await owner.adminRequest('/api/v1/space/members');
      expect(
        (members['members'] as List).any(
          (m) =>
              m['principalId'] == member.principalId &&
              m['nickname'] == 'Участник v0.3',
        ),
        isTrue,
      );

      final queue = AttachmentQueue();
      addTearDown(queue.close);
      final bytes = Uint8List.fromList(
        List.generate(256 * 1024 + 31, (i) => i % 251),
      );
      final folder = await Directory.systemTemp.createTemp(
        'space-v03-attachments-',
      );
      final file = File(
        '${folder.path}${Platform.pathSeparator}проверка-v03.bin',
      );
      await file.writeAsBytes(bytes);
      addTearDown(() async {
        await file.delete();
        await folder.delete();
      });
      await queue.add(AttachmentFilesAdded([XFile(file.path)]));
      final ids = await queue.upload(owner, 'general');
      expect(ids, hasLength(1), reason: queue.state.error);
      final received = member
          .subscribe('')
          .firstWhere(
            (frame) =>
                frame.hasEvent() &&
                frame.event.content.attachments.any((a) => a.id == ids!.single),
          );
      final key = newRequestKey();
      final sent = await owner.sendAttachments('general', '', key, ids!);
      final event = await received.timeout(const Duration(seconds: 15));
      expect(event.event.content.id, sent.id);
      expect(event.event.content.attachments.single.name, 'проверка-v03.bin');
      final replay = await owner.sendAttachments('general', '', key, ids);
      expect(replay.id, sent.id);
      expect(
        (await owner.listMyAssets(ListMyAssetsRequest(channelId: 'general')))
            .assets
            .single
            .id,
        ids.single,
      );
      expect(await downloadAttachment(member, sent.attachments.single), bytes);

      final channelFiles = await member.listChannelAssets(
        ListChannelAssetsRequest(channelId: 'general'),
      );
      expect(channelFiles.assets.single.id, ids.single);
      expect(channelFiles.authors.containsKey(owner.principalId), isTrue);
      final ownFiles = await member.listChannelAssets(
        ListChannelAssetsRequest(
          channelId: 'general',
          authorId: member.principalId,
        ),
      );
      expect(ownFiles.assets, isEmpty);
      final id = member.principalId;
      await member.close();
      final restored = await SpaceSession.connect(discovery, memberVault);
      addTearDown(restored.close);
      expect(restored.principalId, id);
      final saved = (await restored.messages()).singleWhere(
        (m) => m.id == sent.id,
      );
      expect(saved.attachments.single.id, ids.single);
      expect(
        await downloadAttachment(restored, saved.attachments.single),
        bytes,
      );
      await owner.deleteMessage(sent);
      await expectLater(
        restored.downloadChunk(DownloadChunkRequest(assetId: ids.single)),
        throwsA(
          isA<GrpcError>().having((e) => e.code, 'code', StatusCode.notFound),
        ),
      );
      expect(
        (await owner.listMyAssets(ListMyAssetsRequest(channelId: 'general')))
            .assets,
        isEmpty,
      );
    },
    skip: origin == null
        ? 'Нужен отдельный сервер: tools/check_attachments.ps1'
        : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
