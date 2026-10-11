import 'dart:async';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/io.dart' as connect_io;
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/generated/space/v1/space.connect.client.dart'
    as rpc;

import 'interoperability.dart' show TestVault;

void require(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Future<void> main(List<String> args) async {
  final origin = localOrigin(args.single);
  require(
    origin.scheme == 'http' && InternetAddress(origin.host).isLoopback,
    'Проверка использует только тестовый loopback-сервер',
  );
  final server = await discover(origin.toString());
  final owner = await SpaceSession.connect(server, TestVault());
  final http = HttpClient()..connectionTimeout = const Duration(seconds: 5);
  StreamIterator<SubscribeResponse>? iterator;
  try {
    for (final codec in [const ProtoCodec(), const JsonCodec()]) {
      final transport = protocol.Transport(
        baseUrl: origin.toString(),
        codec: codec,
        httpClient: connect_io.createHttpClient(http),
      );
      final channels = rpc.ChannelServiceClient(transport);
      final manifest = await channels
          .getManifest(GetManifestRequest())
          .timeout(const Duration(seconds: 10));
      require(manifest.serverId == server.serverId, 'Manifest изменил сервер');
      final auth = rpc.AuthServiceClient(transport);
      final record = owner.record;
      final identity = await record.identity();
      final algorithm = Ed25519();
      final device = await algorithm.newKeyPairFromSeed(record.deviceSeed);
      final publicKey = (await device.extractPublicKey()).bytes;
      final challenge = await auth
          .createChallenge(
            CreateChallengeRequest(
              purpose: 'auth.login',
              grantId: record.grantId,
            ),
          )
          .timeout(const Duration(seconds: 10));
      final signing = await checkedSigningBytes(
        challenge,
        server,
        identity.publicKey,
        publicKey,
        'auth.login',
        record.grantId,
        expectedPrincipal: identity.principalId,
        expectedEpoch: identity.epoch,
      );
      final signature = await algorithm.sign(signing, keyPair: device);
      final login = await auth
          .completeChallenge(
            CompleteChallengeRequest(
              challengeId: challenge.challengeId,
              signature: signature.bytes,
            ),
          )
          .timeout(const Duration(seconds: 10));
      require(
        login.principalId == owner.principalId &&
            login.grantId == record.grantId &&
            login.accessToken.isNotEmpty,
        'Connect-вход изменил идентичность',
      );
      final headers = connect.Headers()
        ..add('authorization', 'Bearer ${login.accessToken}');
      final sync = rpc.SyncServiceClient(transport);
      var denied = false;
      try {
        await sync
            .subscribe(SubscribeRequest(channelId: 'general'))
            .first
            .timeout(const Duration(seconds: 10));
      } on connect.ConnectException catch (error) {
        denied = error.code == connect.Code.unauthenticated;
      }
      require(denied, 'Поток без token не отклонён');
      final cursor = (await owner.events('')).nextCursor;
      iterator = StreamIterator(
        sync.subscribe(
          SubscribeRequest(channelId: 'general', after: cursor),
          headers: headers,
        ),
      );
      require(
        await iterator.moveNext().timeout(const Duration(seconds: 10)) &&
            iterator.current.heartbeat,
        'Нет Connect heartbeat',
      );
      final sent = await owner.send(
        'Событие Connect ${codec.runtimeType}',
        newRequestKey(),
      );
      require(
        await iterator.moveNext().timeout(const Duration(seconds: 10)) &&
            iterator.current.event.content.id == sent.id,
        'Connect потерял событие',
      );
      if (codec is JsonCodec) {
        await owner.revoke();
        var revoked = false;
        try {
          await iterator.moveNext().timeout(const Duration(seconds: 10));
        } on connect.ConnectException catch (error) {
          revoked = error.code == connect.Code.unauthenticated;
        }
        require(revoked, 'Connect-поток не закрылся после отзыва');
      }
      await iterator.cancel();
      iterator = null;
    }
    stdout.writeln(
      'Connect Dart/Go: protobuf/JSON, подписанный вход, heartbeat, событие, отмена и отзыв — успешно.',
    );
  } finally {
    await iterator?.cancel();
    http.close(force: true);
    await owner.close();
  }
}
