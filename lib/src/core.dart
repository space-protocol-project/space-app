import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'generated/space/v1/space.pbgrpc.dart';

String url64(List<int> value) => base64Url.encode(value).replaceAll('=', '');

class Discovery {
  Discovery(this.origin, this.serverId, this.publicKey, this.grpcPort);
  final Uri origin;
  final String serverId;
  final List<int> publicKey;
  final int grpcPort;
  Future<String> fingerprint() async =>
      (await Sha256().hash(publicKey)).bytes
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
}

Uri localOrigin(String input) {
  final uri = Uri.parse(input.trim());
  final address = InternetAddress.tryParse(uri.host);
  if (uri.scheme != 'http' ||
      address == null ||
      !address.isLoopback ||
      uri.userInfo.isNotEmpty ||
      uri.path.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment ||
      uri.port < 1) {
    throw const FormatException(
      'Сейчас поддерживается локальный адрес: http://127.0.0.1:8080',
    );
  }
  return uri;
}

Future<Discovery> discover(String input) async {
  final origin = localOrigin(input);
  final client = IOClient(
    HttpClient()..connectionTimeout = const Duration(seconds: 5),
  );
  try {
    final request = http.Request(
      'GET',
      origin.resolve('/.well-known/space-protocol'),
    )..followRedirects = false;
    final response = await client
        .send(request)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw const FormatException(
        'Сервер не предоставил discovery. Перенаправления не принимаются.',
      );
    }
    final bytes = <int>[];
    await for (final chunk in response.stream.timeout(
      const Duration(seconds: 10),
    )) {
      bytes.addAll(chunk);
      if (bytes.length > 16384) {
        throw const FormatException('Слишком большой discovery');
      }
    }
    final data = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    final id = data['server_id'] as String;
    final key = base64Url.decode(
      base64Url.normalize(data['signing_public_key'] as String),
    );
    final endpoint = Uri.parse('http://${data['grpc_endpoint']}');
    if (data['protocol_version'] != '0.1-experimental' ||
        data['signing_algorithm'] != 'Ed25519' ||
        data['manifest'] != '/api/v1/manifest' ||
        !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(id) ||
        key.length != 32 ||
        endpoint.host != origin.host ||
        endpoint.userInfo.isNotEmpty ||
        endpoint.path.isNotEmpty ||
        endpoint.hasQuery ||
        endpoint.hasFragment ||
        !endpoint.hasPort ||
        endpoint.port < 1) {
      throw const FormatException(
        'Discovery несовместим с локальным профилем Space',
      );
    }
    return Discovery(origin, id, key, endpoint.port);
  } finally {
    client.close();
  }
}

class DeviceRecord {
  DeviceRecord({
    required this.origin,
    required this.serverId,
    required this.serverKey,
    required this.rootSeed,
    required this.deviceSeed,
    this.grantId = '',
  });
  final String origin, serverId, serverKey;
  final List<int> rootSeed, deviceSeed;
  String grantId;
  Map<String, Object> toJson() => {
    'v': 1,
    'origin': origin,
    'serverId': serverId,
    'serverKey': serverKey,
    'rootSeed': url64(rootSeed),
    'deviceSeed': url64(deviceSeed),
    'grantId': grantId,
  };
  static DeviceRecord fromJson(Map<String, dynamic> data) {
    if (data['v'] != 1) {
      throw const FormatException('Неизвестная версия хранилища ключей');
    }
    final record = DeviceRecord(
      origin: data['origin'] as String,
      serverId: data['serverId'] as String,
      serverKey: data['serverKey'] as String,
      rootSeed: base64Url.decode(
        base64Url.normalize(data['rootSeed'] as String),
      ),
      deviceSeed: base64Url.decode(
        base64Url.normalize(data['deviceSeed'] as String),
      ),
      grantId: data['grantId'] as String,
    );
    if (record.rootSeed.length != 32 || record.deviceSeed.length != 32) {
      throw const FormatException('Повреждено хранилище ключей');
    }
    return record;
  }
}

abstract interface class IdentityVault {
  Future<DeviceRecord?> load(String origin);
  Future<void> save(DeviceRecord record);
}

void checkTrust(Discovery server, DeviceRecord record) {
  if (record.origin != server.origin.toString() ||
      record.serverId != server.serverId ||
      record.serverKey != url64(server.publicKey)) {
    throw const FormatException(
      'Идентичность сервера изменилась. Подключение заблокировано.',
    );
  }
}

abstract interface class LiveSession {
  String get principalId;
  Future<void> login();
  Future<List<Content>> messages();
  Future<Content> send(String text, String key);
  Stream<SubscribeResponse> subscribe(String after);
  Future<void> revoke();
  Future<void> close();
}

abstract interface class SpacePresentation {
  String get spaceTitle;
  String get chatTitle;
}

abstract interface class SpaceAccess {
  bool get canWrite;
}

class SpaceSession implements LiveSession, SpacePresentation, SpaceAccess {
  SpaceSession._(this.server, this.record, this.vault, this.channel);
  final Discovery server;
  final DeviceRecord record;
  final IdentityVault vault;
  final ClientChannel channel;
  String _token = '';
  @override
  String spaceTitle = '';
  @override
  String chatTitle = 'Общий чат';
  String role = '';
  @override
  bool get canWrite => ['owner', 'admin', 'member'].contains(role);
  int _expiresAt = 0;
  Future<void>? _loginTask;
  @override
  String principalId = '';
  CallOptions get _options => CallOptions(
    timeout: const Duration(seconds: 10),
    metadata: {'authorization': 'Bearer $_token'},
  );

  static Future<SpaceSession> connect(
    Discovery server,
    IdentityVault vault, {
    String invitationToken = '',
  }) async {
    var record = await vault.load(server.origin.toString());
    if (record != null) {
      checkTrust(server, record);
    } else {
      final algorithm = Ed25519();
      final root = await algorithm.newKeyPair();
      final device = await algorithm.newKeyPair();
      record = DeviceRecord(
        origin: server.origin.toString(),
        serverId: server.serverId,
        serverKey: url64(server.publicKey),
        rootSeed: await root.extractPrivateKeyBytes(),
        deviceSeed: await device.extractPrivateKeyBytes(),
      );
      await vault.save(record);
    }
    final channel = ClientChannel(
      server.origin.host,
      port: server.grpcPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final session = SpaceSession._(server, record, vault, channel);
    try {
      final manifest = await ChannelServiceClient(channel).getManifest(
        GetManifestRequest(),
        options: CallOptions(timeout: const Duration(seconds: 10)),
      );
      session.spaceTitle = manifest.title;
      session.chatTitle =
          manifest.channels
              .where((channel) => channel.id == 'general')
              .firstOrNull
              ?.title ??
          'Общий чат';
      if (manifest.serverId != server.serverId ||
          manifest.protocolVersion != '0.1-experimental' ||
          !manifest.channels.any(
            (c) => c.id == 'general' && c.views.any((v) => v.type == 'chat'),
          )) {
        throw const FormatException('gRPC manifest не соответствует discovery');
      }
      if (record.grantId.isEmpty) {
        final result = await session._authorize(
          'device.register',
          invitationToken: invitationToken,
        );
        record.grantId = result.grantId;
        await vault.save(record);
      }
      await session.login();
      if (invitationToken.isNotEmpty) {
        await MembershipServiceClient(channel).acceptInvite(
          AcceptInviteRequest(token: invitationToken),
          options: session._options,
        );
      }
      await session.refreshMembership();
      return session;
    } catch (_) {
      await channel.shutdown();
      rethrow;
    }
  }

  @override
  Future<void> login() =>
      _loginTask ??= _login().whenComplete(() => _loginTask = null);
  Future<void> _login() async {
    final result = await _authorize('auth.login');
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (!RegExp(r'^st_[A-Za-z0-9_-]{43}$').hasMatch(result.accessToken) ||
        result.expiresAt.toInt() <= now ||
        result.expiresAt.toInt() > now + 605) {
      throw const FormatException('Сервер не выдал сессию');
    }
    _token = result.accessToken;
    _expiresAt = result.expiresAt.toInt();
    principalId = result.principalId;
  }

  Future<void> _ensureSession() async {
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 >= _expiresAt - 15) {
      await login();
    }
  }

  Future<CompleteChallengeResponse> _authorize(
    String purpose, {
    String invitationToken = '',
  }) async {
    final algorithm = Ed25519();
    final root = await algorithm.newKeyPairFromSeed(record.rootSeed);
    final device = await algorithm.newKeyPairFromSeed(record.deviceSeed);
    final rootPublic = (await root.extractPublicKey()).bytes;
    final devicePublic = (await device.extractPublicKey()).bytes;
    final request = CreateChallengeRequest(purpose: purpose);
    if (purpose == 'device.register') {
      request.rootPublicKey = rootPublic;
      request.devicePublicKey = devicePublic;
    } else {
      request.grantId = record.grantId;
    }
    if (purpose == 'device.revoke') request.rootPublicKey = rootPublic;
    final auth = AuthServiceClient(channel);
    final options = CallOptions(timeout: const Duration(seconds: 10));
    final challenge = await auth.createChallenge(request, options: options);
    final signing = await checkedSigningBytes(
      challenge,
      server,
      rootPublic,
      devicePublic,
      purpose,
      record.grantId,
    );
    final key = purpose == 'auth.login' ? device : root;
    final signature = await algorithm.sign(signing, keyPair: key);
    final result = await auth.completeChallenge(
      CompleteChallengeRequest(
        challengeId: challenge.challengeId,
        signature: signature.bytes,
        invitationToken: invitationToken,
      ),
      options: options,
    );
    final principal =
        'u_${(await Sha256().hash(rootPublic)).bytes.map((v) => v.toRadixString(16).padLeft(2, '0')).join()}';
    if (result.principalId != principal ||
        !RegExp(r'^dg_[A-Za-z0-9_-]{43}$').hasMatch(result.grantId) ||
        (purpose != 'device.register' && result.grantId != record.grantId)) {
      throw const FormatException('Ответ входа не соответствует ключам');
    }
    return result;
  }

  @override
  Future<List<Content>> messages() async {
    await _ensureSession();
    final result = <Content>[];
    var cursor = '';
    for (var page = 0; page < 11; page++) {
      final response = await ContentServiceClient(channel).listContent(
        ListContentRequest(channelId: 'general', after: cursor),
        options: _options,
      );
      result.addAll(response.contents);
      if (response.contents.length < 100) return result;
      if (response.nextCursor.isEmpty || response.nextCursor == cursor) {
        throw const FormatException('Сервер повторил курсор');
      }
      cursor = response.nextCursor;
    }
    throw const FormatException('Слишком много страниц');
  }

  @override
  Future<Content> send(String text, String key) async {
    await _ensureSession();
    final result = await ContentServiceClient(channel).createContent(
      CreateContentRequest(
        channelId: 'general',
        text: text,
        idempotencyKey: key,
      ),
      options: _options,
    );
    return result.content;
  }

  Future<ListEventsResponse> events(String after) async {
    await _ensureSession();
    return SyncServiceClient(channel).listEvents(
      ListEventsRequest(channelId: 'general', after: after),
      options: _options,
    );
  }

  @override
  Stream<SubscribeResponse> subscribe(String after) async* {
    await _ensureSession();
    final stream = SyncServiceClient(channel).subscribe(
      SubscribeRequest(channelId: 'general', after: after),
      options: CallOptions(
        timeout: const Duration(minutes: 11),
        metadata: {'authorization': 'Bearer $_token'},
      ),
    );
    try {
      final frames = stream.timeout(
        const Duration(seconds: 35),
        onTimeout: (sink) {
          sink.addError(TimeoutException('Поток не отвечает'));
          sink.close();
        },
      );
      await for (final frame in frames) {
        if (frame.heartbeat) await refreshMembership();
        yield frame;
      }
    } finally {
      await stream.cancel();
    }
  }

  Future<void> refreshMembership() async {
    await _ensureSession();
    final result = await MembershipServiceClient(channel)
        .getMembership(GetMembershipRequest(), options: _options);
    if (result.member.blocked) {
      throw const GrpcError.permissionDenied('Доступ заблокирован');
    }
    role = result.member.role;
    if (!['owner', 'admin', 'member', 'reader'].contains(role)) {
      throw const FormatException('Неизвестная роль');
    }
  }

  static Future<PreviewInviteResponse> previewInvitation(
    Discovery server,
    String token,
  ) async {
    final channel = ClientChannel(
      server.origin.host,
      port: server.grpcPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    try {
      final result = await MembershipServiceClient(channel).previewInvite(
        PreviewInviteRequest(token: token),
        options: CallOptions(timeout: const Duration(seconds: 10)),
      );
      if (result.serverId != server.serverId ||
          !['reader', 'member'].contains(result.role)) {
        throw const FormatException('Приглашение не соответствует серверу');
      }
      return result;
    } finally {
      await channel.shutdown();
    }
  }

  @override
  Future<void> revoke() async {
    await _authorize('device.revoke');
    _token = '';
    _expiresAt = 0;
  }

  @override
  Future<void> close() => channel.shutdown();
}

String newRequestKey() =>
    url64(List<int>.generate(24, (_) => Random.secure().nextInt(256)));

Future<List<int>> checkedSigningBytes(
  CreateChallengeResponse response,
  Discovery server,
  List<int> root,
  List<int> device,
  String purpose,
  String grantId,
) async {
  final transcript =
      jsonDecode(utf8.decode(response.transcript)) as Map<String, dynamic>;
  final keys = transcript.keys.toList()..sort();
  final canonical = jsonEncode({for (final key in keys) key: transcript[key]});
  final expectedKeys = [
    'auth_epoch',
    'challenge_id',
    'device_public_key',
    'expires_at',
    'grant_expires_at',
    'grant_id',
    'issued_at',
    'nonce',
    'origin',
    'principal_id',
    'purpose',
    'root_public_key',
    'scopes',
    'server_id',
    'v',
  ];
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final principal =
      'u_${(await Sha256().hash(root)).bytes.map((v) => v.toRadixString(16).padLeft(2, '0')).join()}';
  final nonce = base64Url.decode(
    base64Url.normalize(transcript['nonce'] as String),
  );
  final issued = transcript['issued_at'] as int;
  final expiry = transcript['expires_at'] as int;
  final grantExpiry = transcript['grant_expires_at'] as int;
  final valid =
      utf8.decode(response.transcript) == canonical &&
      jsonEncode(keys) == jsonEncode(expectedKeys) &&
      transcript['v'] == 1 &&
      transcript['auth_epoch'] == 1 &&
      transcript['purpose'] == purpose &&
      transcript['origin'] == server.origin.toString() &&
      transcript['server_id'] == server.serverId &&
      transcript['principal_id'] == principal &&
      transcript['root_public_key'] == url64(root) &&
      transcript['device_public_key'] == url64(device) &&
      transcript['challenge_id'] == response.challengeId &&
      RegExp(r'^ac_[A-Za-z0-9_-]{43}$').hasMatch(response.challengeId) &&
      RegExp(r'^dg_[A-Za-z0-9_-]{43}$')
          .hasMatch(transcript['grant_id'] as String) &&
      nonce.length == 32 &&
      jsonEncode(transcript['scopes']) == '["chat.read","chat.write"]' &&
      expiry == issued + 60 &&
      expiry > now &&
      issued <= now + 5 &&
      grantExpiry > expiry &&
      (purpose == 'device.register'
          ? grantExpiry == issued + 30 * 86400
          : transcript['grant_id'] == grantId);
  if (!valid) {
    throw const FormatException(
      'Подпись отклонена: challenge не соответствует серверу, ключам или операции',
    );
  }
  final prefix = {
    'device.register': 'space/device-register/v1',
    'auth.login': 'space/auth-login/v1',
    'device.revoke': 'space/device-revoke/v1',
  }[purpose];
  if (prefix == null) {
    throw const FormatException('Неизвестное назначение подписи');
  }
  return utf8.encode('$prefix\u0000$canonical');
}
