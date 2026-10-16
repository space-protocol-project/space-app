import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/rpc_connection.dart';

import '../channels_test.dart' show MemoryHistory, MemoryPositions;
import '../chat_history_test.dart' show HistoryKeys;
import '../support/rpc_fault_proxy.dart';
import 'ordinary_sync.dart';
import 'persistent_files.dart';

import 'dart:io';
import 'dart:async';
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
      expect(await member.getNickname(), 'Участник v0.3');
      await expectLater(
        owner.setNickname('  УЧАСТНИК V0.3  '),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'code',
            StatusCode.alreadyExists,
          ),
        ),
      );
      await member.setNickname('Новое имя');
      expect(await member.getNickname(), 'Новое имя');
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

      final initialPolicy = Completer<void>(),
          disabledPolicy = Completer<void>(),
          enabledPolicy = Completer<void>();
      final policies = member.watchChannelChanges().listen((_) {
        if (!initialPolicy.isCompleted) initialPolicy.complete();
        if (!member.attachmentsEnabled && !disabledPolicy.isCompleted) {
          disabledPolicy.complete();
        }
        if (disabledPolicy.isCompleted &&
            member.attachmentsEnabled &&
            !enabledPolicy.isCompleted) {
          enabledPolicy.complete();
        }
      });
      addTearDown(policies.cancel);
      await initialPolicy.future.timeout(const Duration(seconds: 5));
      Future<void> setFiles(bool enabled) async {
        final response = await owner.adminRequest('/api/v1/space/settings');
        final settings = Map<String, dynamic>.from(response['settings'] as Map);
        await owner.adminRequest(
          '/api/v1/space/settings',
          method: 'PATCH',
          body: {
            'title': settings['title'],
            'chatTitle': settings['chatTitle'],
            'chatEnabled': settings['chatEnabled'],
            'registrationPolicy': settings['registrationPolicy'],
            'expectedRevision': settings['revision'],
            'attachmentsEnabled': enabled,
          },
        );
      }

      await setFiles(false);
      await disabledPolicy.future.timeout(const Duration(seconds: 5));
      expect(member.attachmentsEnabled, isFalse);
      await expectLater(
        member.listMyAssets(ListMyAssetsRequest(channelId: 'general')),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'code',
            StatusCode.permissionDenied,
          ),
        ),
      );
      await setFiles(true);
      await enabledPolicy.future.timeout(const Duration(seconds: 5));
      expect(member.attachmentsEnabled, isTrue);
      await policies.cancel();

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
      final reacting = await member.setReaction(sent, '❤️', true);
      expect(reacting.reactions.single.principalIds, [member.principalId]);
      final synchronized = await owner
          .subscribe(event.cursor)
          .firstWhere(
            (frame) =>
                frame.hasEvent() && frame.event.content.reactions.isNotEmpty,
          )
          .timeout(const Duration(seconds: 15));
      expect(synchronized.event.content.reactions.single.emoji, '❤️');
      final id = member.principalId;
      await member.close();
      final restored = await SpaceSession.connect(discovery, memberVault);
      addTearDown(restored.close);
      expect(restored.principalId, id);
      final saved = (await restored.messages()).singleWhere(
        (m) => m.id == sent.id,
      );
      expect(saved.attachments.single.id, ids.single);
      expect(saved.reactions.single.emoji, '❤️');
      expect(
        await downloadAttachment(restored, saved.attachments.single),
        bytes,
      );
      final withoutReaction = await restored.setReaction(saved, '❤️', false);
      expect(withoutReaction.reactions, isEmpty);
      await owner.deleteMessage(withoutReaction);
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
      await verifyOrdinaryOutbox(
        discovery,
        ownerVault,
        owner,
        restored,
        file,
        bytes,
      );
      await verifyOrdinarySync(discovery, ownerVault, owner);
      await verifyPersistentFiles(
        discovery,
        ownerVault,
        owner,
        restored,
        bytes,
      );
    },
    skip: origin == null
        ? 'Нужен отдельный сервер: tools/check_attachments.ps1'
        : false,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

class _LostCreateAck extends Discovery {
  _LostCreateAck(Discovery source)
    : super(
        source.origin,
        source.serverId,
        source.publicKey,
        connectOrigin: source.connectOrigin,
        endpoint: source.endpoint,
        tlsFingerprint: source.tlsFingerprint,
        dialHost: source.dialHost,
        announcement: source.announcement,
      );
  final keys = <String>[];
  bool lose = true;
  @override
  RpcConnection openConnection({String setupCode = ''}) {
    final proxy = RpcFaultProxy(super.openConnection(setupCode: setupCode));
    proxy.beforeRequest = (request) {
      if (request is CreateContentRequest) keys.add(request.idempotencyKey);
    };
    proxy.mutate = (method, response) {
      if (lose && method == 'CreateContentRequest') {
        throw const GrpcError.unavailable(
          'Сервер сохранил сообщение; ответ потерян',
        );
      }
      return response;
    };
    return proxy;
  }
}

Future<void> verifyOrdinaryOutbox(
  Discovery server,
  IdentityVault vault,
  SpaceSession uploader,
  SpaceSession observer,
  File file,
  List<int> bytes,
) async {
  final root = await Directory.systemTemp.createTemp('space-live-outbox-');
  final keys = HistoryKeys();
  final remote = _LostCreateAck(server);
  ChatController controller() => ChatController(
    vault,
    positions: MemoryPositions(),
    historyStore: MemoryHistory(),
    outboxStore: LocalChatOutbox(storage: keys, directory: () async => root),
    retryDelay: (_) => const Duration(hours: 1),
  );
  final queue = AttachmentQueue();
  ChatController? first, restarted;
  try {
    await queue.add(AttachmentFilesAdded([XFile(file.path)]));
    final ids = await queue.upload(uploader, 'general');
    expect(ids, hasLength(1));
    first = controller()..preview = remote;
    await first.connect();
    const text = 'Постоянная очередь: потерянный ответ';
    expect(await first.send(text, attachments: ids!), true);
    await waitOutbox(() => first!.sendStatus == MessageSendStatus.unconfirmed);
    expect(first.pendingMessages, hasLength(1));
    final key = first.pendingMessages.single.key;
    await first.close();
    first = null;
    remote.lose = false;
    restarted = controller()..preview = remote;
    await restarted.connect();
    await waitOutbox(() => restarted!.pendingMessages.isEmpty);
    expect(remote.keys, [key, key]);
    final received = (await observer.messages())
        .where((message) => message.text == text)
        .toList();
    expect(received, hasLength(1));
    expect(received.single.attachments.single.id, ids.single);
    expect(
      await downloadAttachment(observer, received.single.attachments.single),
      bytes,
    );
  } finally {
    await first?.close();
    await restarted?.close();
    await queue.close();
    await root.delete(recursive: true);
  }
}

Future<void> waitOutbox(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 15));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Очередь не восстановилась');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}
