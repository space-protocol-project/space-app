import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' as sp;

class _Vault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = value;
  }
}

Future<void> _configure(SpaceSession owner) async {
  final response = await owner.adminRequest('/api/v1/space/settings');
  final settings = Map<String, dynamic>.from(response['settings'] as Map);
  await owner.adminRequest(
    '/api/v1/space/settings',
    method: 'PATCH',
    body: {
      ...settings,
      'registrationPolicy': 'open',
      'attachmentsEnabled': true,
      'expectedRevision': settings['revision'],
    }..remove('revision'),
  );
  await owner.adminRequest(
    '/api/v1/channels',
    method: 'POST',
    body: {'channelId': 'feed', 'title': 'Лента CI', 'viewType': 'feed'},
  );
}

Future<void> _policy(SpaceSession owner, bool publish) async {
  final api = SessionFeedApi(owner);
  final previous = await api.access('feed');
  await api.saveAccess(
    UpdateFeedAccessRequest(
      channelId: 'feed',
      expectedRevision: previous.revision,
      rules: [
        FeedAccessRule(
          role: 'member',
          permissions: FeedPermissions(publish: publish, comment: true),
        ),
      ],
    ),
  );
}

Future<void> _grantModeration(
  SpaceSession owner,
  SpaceSession moderator,
) async {
  await moderator.authorizeAdministration();
  final access = await owner.adminRequest('/api/v1/channels/feed/access');
  await owner.adminRequest(
    '/api/v1/channels/feed/access',
    method: 'PUT',
    body: {
      'expectedRevision': access['revision'],
      'rules': [
        ...List<dynamic>.from(access['rules'] as List? ?? []),
        {
          'principalId': moderator.principalId,
          'permissions': {
            'visible': true,
            'read': true,
            'write': true,
            'manage': true,
          },
        },
      ],
    },
  );
}

Future<String> _upload(SpaceSession member, Uint8List bytes) async {
  final upload = await member.beginUpload(
    sp.BeginUploadRequest(
      channelId: 'feed',
      name: 'feed-ci.bin',
      byteSize: Int64(bytes.length),
      sha256: sha256.convert(bytes).bytes,
      idempotencyKey: 'feed-ci-file',
    ),
  );
  for (var offset = 0; offset < bytes.length; offset += upload.chunkSize) {
    final end = (offset + upload.chunkSize).clamp(0, bytes.length);
    await member.uploadChunk(
      sp.UploadChunkRequest(
        assetId: upload.asset.id,
        offset: Int64(offset),
        data: bytes.sublist(offset, end),
      ),
    );
  }
  await member.completeUpload(
    sp.CompleteUploadRequest(assetId: upload.asset.id),
  );
  return upload.asset.id;
}

Future<void> _verifyHidden(SpaceSession session, String post) async {
  final result = await SessionFeedApi(session).post('feed', post, Int64.ZERO);
  expect(result.post.hidden, true);
  expect(result.post.text, isEmpty);
  expect(result.comments, isEmpty);
}

Future<Uint8List> _remaining(
  SpaceSession session,
  String asset,
  sp.DownloadChunkResponse first,
) async {
  final bytes = BytesBuilder()..add(first.data);
  var offset = first.nextOffset;
  while (offset < first.asset.byteSize) {
    final chunk = await session.downloadChunk(
      sp.DownloadChunkRequest(assetId: asset, offset: offset),
    );
    expect(chunk.nextOffset, greaterThan(offset));
    bytes.add(chunk.data);
    offset = chunk.nextOffset;
  }
  return bytes.takeBytes();
}

void main() {
  final origin = Platform.environment['SPACE_FEED_TEST_ORIGIN'];
  test(
    'лента: настоящие клиент/сервер, права, файл, повтор и модерация',
    () async {
      final uri = Uri.parse(origin!);
      expect(uri.scheme, 'http');
      expect(InternetAddress.tryParse(uri.host)?.isLoopback, true);
      final server = await discover(origin);
      final owner = await SpaceSession.connect(server, _Vault());
      addTearDown(owner.close);
      expect(owner.role, 'owner', reason: 'Нужна новая отдельная PostgreSQL');
      await _configure(owner);
      final member = await SpaceSession.connect(server, _Vault());
      final moderator = await SpaceSession.connect(server, _Vault());
      addTearDown(member.close);
      addTearDown(moderator.close);
      expect(member.feedSupported && moderator.feedSupported, true);
      expect(member.role, 'member');
      expect(moderator.role, 'member');
      await _grantModeration(owner, moderator);
      final api = SessionFeedApi(member);
      await _policy(owner, false);
      await expectLater(
        api.publish(
          CreateFeedPostRequest(
            channelId: 'feed',
            text: 'Запрещено',
            idempotencyKey: 'denied',
          ),
        ),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'code',
            StatusCode.permissionDenied,
          ),
        ),
      );
      await _policy(owner, true);
      final data = Uint8List.fromList(
        List.generate(512 * 1024, (i) => i % 251),
      );
      final asset = await _upload(member, data);
      final request = CreateFeedPostRequest(
        channelId: 'feed',
        text: 'Публикация CI',
        idempotencyKey: 'feed-ci-post',
        attachmentIds: [asset],
      );
      final created = await api.publish(request);
      expect((await api.publish(request)).post.id, created.post.id);
      expect((await api.posts('feed', Int64.ZERO)).posts, hasLength(1));
      await SessionFeedApi(owner).comment(
        CommentFeedPostRequest(
          channelId: 'feed',
          postId: created.post.id,
          text: 'Комментарий',
          idempotencyKey: 'feed-ci-comment',
        ),
      );
      final discussion = await api.post('feed', created.post.id, Int64.ZERO);
      expect(discussion.comments, hasLength(1));
      final first = await member.downloadChunk(
        sp.DownloadChunkRequest(assetId: asset),
      );
      expect(first.nextOffset, lessThan(Int64(data.length)));
      final modApi = SessionFeedApi(moderator);
      final hidden = await modApi.moderatePost(
        ModerateFeedPostRequest(
          channelId: 'feed',
          postId: created.post.id,
          hidden: true,
          expectedRevision: discussion.post.revision,
          reason: 'Проверка CI',
        ),
      );
      await _verifyHidden(owner, created.post.id);
      await _verifyHidden(member, created.post.id);
      await expectLater(
        member.downloadChunk(
          sp.DownloadChunkRequest(assetId: asset, offset: first.nextOffset),
        ),
        throwsA(
          isA<GrpcError>().having((e) => e.code, 'code', StatusCode.notFound),
        ),
      );
      await modApi.moderatePost(
        ModerateFeedPostRequest(
          channelId: 'feed',
          postId: created.post.id,
          hidden: false,
          expectedRevision: hidden.post.revision,
          reason: 'Восстановление CI',
        ),
      );
      final restored = await _remaining(member, asset, first);
      expect(restored.length, data.length);
      expect(sha256.convert(restored), sha256.convert(data));
    },
    skip: origin == null,
  );
}
