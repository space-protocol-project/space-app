import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';

import 'core.dart';
import 'generated/space/v1/space.pbgrpc.dart';

ClientChannel _channel(Discovery server) => ClientChannel(
  server.origin.host,
  port: server.grpcPort,
  options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
);
final _deadline = CallOptions(timeout: const Duration(seconds: 10));
Future<Pairing> inspectPairing(Discovery server, String code) async {
  final channel = _channel(server);
  try {
    return (await AuthServiceClient(channel).inspectPairing(
      InspectPairingRequest(code: code.trim()),
      options: _deadline,
    )).pairing;
  } finally {
    await channel.shutdown();
  }
}

class PendingPairing {
  PendingPairing._(this.server, this.seed, this.request, this.channel);
  final Discovery server;
  final List<int> seed;
  final CreatePairingResponse request;
  final ClientChannel channel;
  bool claimed = false;
  List<int>? proposedRoot;
  static Future<PendingPairing> start(
    Discovery server, {
    bool administrative = false,
  }) async {
    final key = await Ed25519().newKeyPair(), channel = _channel(server);
    final public = (await key.extractPublicKey()).bytes;
    try {
      final result = await AuthServiceClient(channel).createPairing(
        CreatePairingRequest(
          publicKey: public,
          deviceName: 'Новое устройство Flutter',
          administrative: administrative,
        ),
        options: _deadline,
      );
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (!RegExp(r'^pr_[A-Za-z0-9_-]{43}$').hasMatch(result.pairing.id) ||
          !RegExp(r'^pc_[A-Za-z0-9_-]{43}$').hasMatch(result.code) ||
          !RegExp(r'^pt_[A-Za-z0-9_-]{43}$').hasMatch(result.pollToken) ||
          result.pairing.state != 'pending' ||
          result.pairing.administrative != administrative ||
          url64(result.pairing.publicKey) != url64(public) ||
          result.pairing.expiresAt.toInt() !=
              result.pairing.createdAt.toInt() + 300 ||
          result.pairing.createdAt.toInt() > now + 5 ||
          result.pairing.createdAt.toInt() < now - 15) {
        throw const FormatException(
          'Запрос сопряжения не соответствует устройству',
        );
      }
      return PendingPairing._(
        server,
        await key.extractPrivateKeyBytes(),
        result,
        channel,
      );
    } catch (_) {
      await channel.shutdown();
      rethrow;
    }
  }

  Future<PollPairingResponse> poll() async {
    final response = await AuthServiceClient(channel).pollPairing(
      PollPairingRequest(pollToken: request.pollToken),
      options: _deadline,
    );
    if (response.rootPublicKey.isNotEmpty) {
      if (response.rootPublicKey.length != 32 ||
          response.pairing.id != request.pairing.id ||
          url64(response.pairing.publicKey) !=
              url64(request.pairing.publicKey) ||
          response.pairing.administrative != request.pairing.administrative ||
          url64(response.rootPublicKey) !=
              url64(response.pairing.proposedRootPublicKey) ||
          (proposedRoot != null &&
              url64(proposedRoot!) != url64(response.rootPublicKey))) {
        throw const FormatException('Подтверждающая идентичность изменилась');
      }
      proposedRoot = List<int>.of(response.rootPublicKey);
    }
    return response;
  }

  Future<DeviceRecord> verifiedRecord(PollPairingResponse response) async {
    final p = response.pairing, expected = request.pairing;
    if (p.id != expected.id ||
        p.state != 'approved' ||
        p.expiresAt != expected.expiresAt ||
        p.createdAt != expected.createdAt ||
        p.administrative != expected.administrative ||
        url64(p.publicKey) != url64(expected.publicKey) ||
        p.expiresAt.toInt() <= DateTime.now().millisecondsSinceEpoch ~/ 1000 ||
        response.rootPublicKey.length != 32 ||
        proposedRoot == null ||
        url64(proposedRoot!) != url64(response.rootPublicKey) ||
        response.signature.length != 64) {
      throw const FormatException('Сопряжение изменено или истекло');
    }
    final transcript =
        jsonDecode(utf8.decode(response.transcript)) as Map<String, dynamic>;
    if (transcript['grant_id'] != response.grantId ||
        (transcript['issued_at'] as int) < p.createdAt.toInt() - 5 ||
        (transcript['issued_at'] as int) >= p.expiresAt.toInt()) {
      throw const FormatException('Подтверждение не относится к запросу');
    }
    final delegated = transcript['purpose'] == 'device.delegate';
    List<int> signer = response.rootPublicKey;
    if (delegated) {
      if (response.parentTranscript.isEmpty ||
          response.parentSignature.length != 64 ||
          response.parentGrantId != transcript['authorizer_grant_id']) {
        throw const FormatException('Нет доказательства recovery authority');
      }
      final parent = jsonDecode(
        utf8.decode(response.parentTranscript),
      ) as Map<String, dynamic>;
      signer = base64Url.decode(
        base64Url.normalize(parent['device_public_key'] as String),
      );
      final scopes = (parent['scopes'] as List).cast<String>();
      final managed = scopes.contains('space.manage');
      if (parent['grant_id'] != response.parentGrantId ||
          !scopes.contains('identity.recover') ||
          (p.administrative && !managed) ||
          (parent['issued_at'] as int) > (transcript['issued_at'] as int) + 5 ||
          (parent['grant_expires_at'] as int) <
              (transcript['grant_expires_at'] as int)) {
        throw const FormatException('Неподходящая цепочка recovery');
      }
      final parentSigning = await checkedSigningBytes(
        CreateChallengeResponse(
          challengeId: parent['challenge_id'] as String,
          transcript: response.parentTranscript,
        ),
        server,
        response.rootPublicKey,
        signer,
        'device.register',
        '',
        expectedScopes: [
          'chat.read',
          'chat.write',
          if (managed) 'space.manage',
          'identity.recover',
        ],
        allowHistorical: true,
        registrationDays: 3650,
      );
      if (!await Ed25519().verify(
        parentSigning,
        signature: Signature(
          response.parentSignature,
          publicKey: SimplePublicKey(
            response.rootPublicKey,
            type: KeyPairType.ed25519,
          ),
        ),
      )) {
        throw const FormatException('Root-подпись recovery не прошла проверку');
      }
    } else if (response.parentGrantId.isNotEmpty ||
        response.parentTranscript.isNotEmpty ||
        response.parentSignature.isNotEmpty) {
      throw const FormatException('Неожиданная цепочка подписи');
    }
    final signing = await checkedSigningBytes(
      CreateChallengeResponse(
        challengeId: transcript['challenge_id'] as String,
        transcript: response.transcript,
      ),
      server,
      response.rootPublicKey,
      p.publicKey,
      delegated ? 'device.delegate' : 'device.register',
      '',
      expectedScopes: [
        'chat.read',
        'chat.write',
        if (p.administrative) 'space.manage',
      ],
      pairingId: p.id,
      allowHistorical: true,
      authorizerGrantId: delegated ? response.parentGrantId : '',
    );
    final valid = await Ed25519().verify(
      signing,
      signature: Signature(
        response.signature,
        publicKey: SimplePublicKey(signer, type: KeyPairType.ed25519),
      ),
    );
    if (!valid) {
      throw const FormatException('Root-подпись сопряжения не прошла проверку');
    }
    return DeviceRecord(
      origin: server.origin.toString(),
      serverId: server.serverId,
      serverKey: url64(server.publicKey),
      rootSeed: [],
      rootPublicKey: response.rootPublicKey,
      deviceSeed: seed,
      grantId: response.grantId,
      administrative: p.administrative,
    );
  }

  Future<void> close() async {
    try {
      if (!claimed) {
        await AuthServiceClient(channel).cancelPairing(
          CancelPairingRequest(pollToken: request.pollToken),
          options: _deadline,
        );
      }
    } catch (_) {
    } finally {
      await channel.shutdown();
    }
  }
}
