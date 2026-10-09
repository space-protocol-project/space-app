import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'generated/space/v1/space.pbgrpc.dart';
import 'root_history.dart';
import 'root_rotation.dart' as rotation;

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

class ConnectionInput {
  const ConnectionInput(this.origin, this.invitationToken);
  final Uri origin;
  final String invitationToken;
}

ConnectionInput parseConnectionInput(
  String address, {
  String invitationToken = '',
}) {
  final uri = Uri.parse(address.trim());
  var token = invitationToken.trim();
  if (uri.hasFragment) {
    final fields = Uri.splitQueryString(uri.fragment);
    if (fields.length != 1 ||
        !fields.containsKey('invite') ||
        !RegExp(r'^iv_[A-Za-z0-9_-]{43}$').hasMatch(fields['invite']!)) {
      throw const FormatException('Некорректная ссылка приглашения');
    }
    if (token.isNotEmpty && token != fields['invite']) {
      throw const FormatException('Код приглашения не совпадает со ссылкой');
    }
    token = fields['invite']!;
    if (uri.path.isNotEmpty && uri.path != '/') {
      throw const FormatException('Некорректный адрес приглашения');
    }
    return ConnectionInput(
      localOrigin(uri.replace(path: '').removeFragment().toString()),
      token,
    );
  }
  return ConnectionInput(localOrigin(address), token);
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
    this.rootPublicKey = const [],
    this.recoverySeed = const [],
    this.recoveryGrantId = '',
    this.administrative = false,
    this.rootHistory = const [],
  });
  final String origin, serverId, serverKey;
  final List<int> rootSeed, deviceSeed;
  final List<int> rootPublicKey;
  List<int> recoverySeed;
  final String recoveryGrantId;
  final bool administrative;
  String grantId;
  final List<Map<String, dynamic>> rootHistory;
  Future<RootIdentity> identity() async {
    final public = rootSeed.isEmpty
        ? rootPublicKey
        : (await (await Ed25519().newKeyPairFromSeed(
            rootSeed,
          )).extractPublicKey()).bytes;
    return verifyRootHistory(rootHistory, public, origin, serverId);
  }

  Map<String, Object> toJson() => {
    'v': 3,
    'origin': origin,
    'serverId': serverId,
    'serverKey': serverKey,
    'rootSeed': url64(rootSeed),
    'deviceSeed': url64(deviceSeed),
    'grantId': grantId,
    'rootPublicKey': url64(rootPublicKey),
    'recoverySeed': url64(recoverySeed),
    'recoveryGrantId': recoveryGrantId,
    'administrative': administrative,
    'rootHistory': rootHistory,
  };
  static DeviceRecord fromJson(Map<String, dynamic> data) {
    if (data['v'] != 1 && data['v'] != 2 && data['v'] != 3) {
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
      rootPublicKey: base64Url.decode(
        base64Url.normalize(data['rootPublicKey'] as String? ?? ''),
      ),
      recoverySeed: base64Url.decode(
        base64Url.normalize(data['recoverySeed'] as String? ?? ''),
      ),
      recoveryGrantId: data['recoveryGrantId'] as String? ?? '',
      administrative: data['administrative'] as bool? ?? false,
      rootHistory: (data['rootHistory'] as List? ?? [])
          .map((v) => Map<String, dynamic>.from(v as Map))
          .toList(),
    );
    if ((record.rootSeed.length != 32 &&
            !(record.rootSeed.isEmpty &&
                record.rootPublicKey.length == 32 &&
                (record.recoverySeed.isEmpty ||
                    (record.recoverySeed.length == 32 &&
                        RegExp(r'^dg_[A-Za-z0-9_-]{43}$')
                            .hasMatch(record.recoveryGrantId))))) ||
        record.deviceSeed.length != 32) {
      throw const FormatException('Повреждено хранилище ключей');
    }
    return record;
  }
}

abstract interface class IdentityVault {
  Future<DeviceRecord?> load(String origin);
  Future<void> save(DeviceRecord record);
}

abstract interface class RotationJournalVault implements IdentityVault {
  Future<Map<String, dynamic>?> loadRotation(String origin);
  Future<void> saveRotation(String origin, Map<String, dynamic> pending);
  Future<void> clearRotation(String origin);
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

abstract interface class ChannelNavigation {
  List<Channel> get availableChannels;
  String get selectedChannelId;
  String get positionScope;
  bool get canRead;
  Future<void> refreshChannels();
  void selectChannel(String id);
}

abstract interface class SpaceAccess {
  bool get canWrite;
}

abstract interface class DeviceManagement {
  String get currentGrantId;
  bool get hasRootAuthority;
  Future<List<DeviceGrant>> listDevices();
  Future<void> revokeDevice(DeviceGrant grant, {DeviceRecord? authority});
  Future<Map<String, dynamic>> recoveryPayload();
  Future<String> approvePairing(Pairing pairing, {DeviceRecord? authority});
  Future<String> preparePairing(Pairing pairing, {DeviceRecord? authority});
}

abstract interface class SpaceAdministration {
  bool get canManageSpace;
  bool get needsOwnerSetup;
  Future<Map<String, dynamic>> adminIdentity();
  Future<Map<String, dynamic>> adminRequest(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  });
}

abstract interface class AdministrativeDeviceControl {
  Future<void> authorizeAdministration({DeviceRecord? authority});
}

abstract interface class RootRotationControl {
  Future<void> prepareRotation({bool renew = false});
}

class SpaceSession
    implements
        LiveSession,
        SpacePresentation,
        SpaceAccess,
        DeviceManagement,
        AdministrativeDeviceControl,
        RootRotationControl,
        ChannelNavigation,
        SpaceAdministration {
  SpaceSession._(this.server, this.record, this.vault, this.channel);
  final Discovery server;
  DeviceRecord record;
  final IdentityVault vault;
  final ClientChannel channel;
  String _token = '';
  @override
  String spaceTitle = '';
  @override
  String chatTitle = 'Общий чат';
  String role = '';
  @override
  bool get canWrite =>
      selectedChannel?.permissions.write == true &&
      selectedChannel?.archived != true;
  @override
  bool get canRead => selectedChannel?.permissions.read == true;
  @override
  List<Channel> availableChannels = [];
  @override
  String selectedChannelId = '';
  Channel? get selectedChannel =>
      availableChannels.where((c) => c.id == selectedChannelId).firstOrNull;
  @override
  String get positionScope =>
      '${server.origin}|${server.serverId}|$principalId';
  @override
  void selectChannel(String id) {
    final chosen = availableChannels.where((c) => c.id == id).firstOrNull;
    if (chosen == null) throw const FormatException('Канал больше не доступен');
    selectedChannelId = id;
    chatTitle = chosen.title;
  }

  @override
  Future<void> refreshChannels() async {
    await _ensureSession();
    final manifest = await ChannelServiceClient(channel)
        .getManifest(GetManifestRequest(), options: _options);
    if (manifest.serverId != server.serverId ||
        manifest.protocolVersion != '0.1-experimental') {
      throw const FormatException('Manifest не соответствует серверу');
    }
    final result = await ChannelServiceClient(channel).listChannels(
      ListChannelsRequest(includeArchived: true),
      options: _options,
    );
    final seen = <String>{};
    for (final c in result.channels) {
      if (!RegExp(r'^[a-z][a-z0-9_-]{0,63}$').hasMatch(c.id) ||
          !seen.add(c.id) ||
          c.title.isEmpty ||
          !c.views.any((v) => v.type == 'chat') ||
          !c.hasPermissions()) {
        throw const FormatException('Некорректный список каналов');
      }
    }
    spaceTitle = manifest.title;
    availableChannels = List.unmodifiable(result.channels);
    if (selectedChannelId.isNotEmpty) {
      final current = selectedChannel;
      chatTitle = current?.title ?? 'Канал недоступен';
      return;
    }
    final initial =
        availableChannels
            .where((c) => c.permissions.read && !c.archived)
            .firstOrNull ??
        availableChannels.where((c) => c.permissions.read).firstOrNull ??
        availableChannels.firstOrNull;
    if (initial != null) {
      selectChannel(initial.id);
    } else {
      chatTitle = 'Нет доступных каналов';
    }
  }

  int _expiresAt = 0;
  Future<void>? _loginTask;
  @override
  String principalId = '';
  CallOptions get _options => CallOptions(
    timeout: const Duration(seconds: 10),
    metadata: {'authorization': 'Bearer $_token'},
  );

  bool _needsOwnerSetup = false;
  @override
  bool get needsOwnerSetup => _needsOwnerSetup;
  @override
  bool get canManageSpace => ['owner', 'admin'].contains(role);
  @override
  Future<Map<String, dynamic>> adminIdentity() async {
    await refreshMembership();
    return {
      'origin': server.origin.toString(),
      'serverId': server.serverId,
      'principalId': principalId,
      'role': role,
      'token': '',
      'grantId': record.grantId,
      'hasRootAuthority': hasRootAuthority,
      'administrative': (await listDevices()).any(
        (g) => g.id == record.grantId && g.scopes.contains('space.manage'),
      ),
      'expires': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600,
    };
  }

  @override
  Future<Map<String, dynamic>> adminRequest(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  }) async {
    await _ensureSession();
    Map<String, dynamic> json(GeneratedMessage value) =>
        Map<String, dynamic>.from(value.toProto3Json() as Map);
    final uri = Uri.parse(path);
    if (uri.path == '/api/v1/auth/devices') {
      return json(
        await AuthServiceClient(channel)
            .listDevices(ListDevicesRequest(), options: _options),
      );
    }
    final channelClient = ChannelServiceClient(channel);
    if (uri.path == '/api/v1/channels') {
      if (method == 'POST') {
        return json(
          await channelClient.createChannel(
            CreateChannelRequest()..mergeFromProto3Json(body!),
            options: _options,
          ),
        );
      }
      return json(
        await channelClient.listChannels(
          ListChannelsRequest(
            includeArchived: uri.queryParameters['includeArchived'] == 'true',
          ),
          options: _options,
        ),
      );
    }
    final target = RegExp(
      r'^/api/v1/channels/([a-z][a-z0-9_-]{0,63})(/access)?$',
    ).firstMatch(uri.path);
    if (target != null) {
      final id = target.group(1)!;
      if (target.group(2) != null) {
        if (method == 'PUT') {
          return json(
            await channelClient.updateChannelAccess(
              UpdateChannelAccessRequest()
                ..mergeFromProto3Json({...body!, 'channelId': id}),
              options: _options,
            ),
          );
        }
        return json(
          await channelClient.getChannelAccess(
            GetChannelAccessRequest(channelId: id),
            options: _options,
          ),
        );
      }
      if (method != 'PATCH') {
        throw const GrpcError.unimplemented('Неподдерживаемая операция канала');
      }
      return json(
        await channelClient.updateChannel(
          UpdateChannelRequest()
            ..mergeFromProto3Json({...body!, 'channelId': id}),
          options: _options,
        ),
      );
    }
    if (uri.path == '/api/v1/space/members') {
      return json(
        await AdminServiceClient(channel).listMembers(
          ListMembersRequest(after: uri.queryParameters['after'] ?? ''),
          options: _options,
        ),
      );
    }
    final memberTarget = RegExp(r'^/api/v1/space/members/(u_[0-9a-f]{64})$')
        .firstMatch(uri.path);
    if (memberTarget != null && method == 'PATCH') {
      return json(
        await AdminServiceClient(channel).updateMember(
          UpdateMemberRequest()..mergeFromProto3Json({
            ...body!,
            'principalId': memberTarget.group(1)!,
          }),
          options: _options,
        ),
      );
    }
    if (uri.path == '/api/v1/space/invites') {
      if (method == 'POST') {
        return json(
          await AdminServiceClient(channel).createInvite(
            CreateInviteRequest()..mergeFromProto3Json(body!),
            options: _options,
          ),
        );
      }
      return json(
        await AdminServiceClient(channel).listInvites(
          ListInvitesRequest(after: uri.queryParameters['after'] ?? ''),
          options: _options,
        ),
      );
    }
    final inviteTarget = RegExp(
      r'^/api/v1/space/invites/(in_[A-Za-z0-9_-]+)/revoke$',
    ).firstMatch(uri.path);
    if (inviteTarget != null && method == 'POST') {
      return json(
        await AdminServiceClient(channel).revokeInvite(
          RevokeInviteRequest(inviteId: inviteTarget.group(1)!),
          options: _options,
        ),
      );
    }
    final client = AdminServiceClient(channel);
    switch (path) {
      case '/api/v1/space/setup':
        return Map<String, dynamic>.from(
          (await client.getSetupStatus(
                GetSetupStatusRequest(),
                options: _options,
              )).toProto3Json()
              as Map,
        );
      case '/api/v1/space/setup/claim':
        final response = await client.claimOwner(
          ClaimOwnerRequest()..mergeFromProto3Json(body!),
          options: _options,
        );
        _needsOwnerSetup = false;
        await refreshMembership();
        return json(response);
      case '/api/v1/space/settings':
        if (method == 'PATCH') {
          final request = UpdateSettingsRequest()..mergeFromProto3Json(body!);
          return Map<String, dynamic>.from(
            (await client.updateSettings(
                  request,
                  options: _options,
                )).toProto3Json()
                as Map,
          );
        }
        return Map<String, dynamic>.from(
          (await client.getSettings(
                GetSettingsRequest(),
                options: _options,
              )).toProto3Json()
              as Map,
        );
      default:
        throw const GrpcError.unimplemented('Операция ещё не перенесена');
    }
  }

  static Future<SpaceSession> connect(
    Discovery server,
    IdentityVault vault, {
    String invitationToken = '',
    DeviceRecord? restoredRecord,
    String pairingId = '',
  }) async {
    if (restoredRecord != null &&
        vault is RotationJournalVault &&
        await vault.loadRotation(server.origin.toString()) != null) {
      throw const FormatException(
        'Сначала завершите сохранённую смену ключа для этого сервера',
      );
    }
    final setupChannel = ClientChannel(
      server.origin.host,
      port: server.grpcPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    bool automatic = false;
    try {
      automatic = (await AdminServiceClient(setupChannel).getSetupStatus(
        GetSetupStatusRequest(),
        options: CallOptions(timeout: const Duration(seconds: 10)),
      )).firstLoginOwner;
    } finally {
      await setupChannel.shutdown();
    }
    var record = restoredRecord ?? await vault.load(server.origin.toString());
    if (record != null) {
      checkTrust(server, record);
      await record.identity();
      if (automatic && !record.administrative && record.rootSeed.isNotEmpty) {
        record = DeviceRecord(
          origin: record.origin,
          serverId: record.serverId,
          serverKey: record.serverKey,
          rootSeed: record.rootSeed,
          deviceSeed: record.deviceSeed,
          rootPublicKey: record.rootPublicKey,
          rootHistory: record.rootHistory,
          administrative: true,
        );
      }
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
        administrative: automatic,
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
          manifest.protocolVersion != '0.1-experimental') {
        throw const FormatException('gRPC manifest не соответствует discovery');
      }
      if (record.grantId.isEmpty) {
        final result = await session._authorize(
          'device.register',
          invitationToken: invitationToken,
        );
        record.grantId = result.grantId;
        if (record.rootSeed.isEmpty) record.recoverySeed = [];
        await vault.save(record);
      }
      await session.login();
      if (pairingId.isNotEmpty) {
        await AuthServiceClient(channel).claimPairing(
          ClaimPairingRequest(pairingId: pairingId),
          options: session._options,
        );
        await vault.save(record);
      }
      if (invitationToken.isNotEmpty) {
        await MembershipServiceClient(channel).acceptInvite(
          AcceptInviteRequest(token: invitationToken),
          options: session._options,
        );
      }
      await session.refreshMembership();
      session._needsOwnerSetup =
          !(await AdminServiceClient(channel).getSetupStatus(
            GetSetupStatusRequest(),
            options: session._options,
          )).initialized;
      await session.refreshChannels();
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
    DeviceGrant? target,
    DeviceRecord? authority,
    Pairing? pairing,
  }) async {
    final credentials = authority ?? record;
    final algorithm = Ed25519();
    final root = credentials.rootSeed.isEmpty
        ? null
        : await algorithm.newKeyPairFromSeed(credentials.rootSeed);
    final device = await algorithm.newKeyPairFromSeed(credentials.deviceSeed);
    final rootPublic = root == null
        ? credentials.rootPublicKey
        : (await root.extractPublicKey()).bytes;
    final devicePublic =
        pairing?.publicKey ??
        target?.publicKey ??
        (await device.extractPublicKey()).bytes;
    if (root == null && purpose == 'device.register') {
      purpose = 'device.delegate';
    }
    if (root == null && purpose == 'device.revoke') {
      purpose = 'recovery.device.revoke';
    }
    if (root == null &&
        credentials.recoverySeed.isEmpty &&
        purpose != "auth.login") {
      throw const FormatException(
        "Откройте карточку для управления устройствами",
      );
    }
    final delegated =
        purpose == 'device.delegate' || purpose == 'recovery.device.revoke';
    final grantId = target?.id ?? credentials.grantId;
    final request = CreateChallengeRequest(purpose: purpose);
    if (purpose == 'device.register') {
      request.rootPublicKey = rootPublic;
      request.devicePublicKey = devicePublic;
      request.administrative = credentials.administrative;
      if (pairing != null) {
        request.administrative = pairing.administrative;
        request.pairingId = pairing.id;
      }
    } else if (purpose == 'device.delegate') {
      request.devicePublicKey = devicePublic;
      request.administrative = credentials.administrative;
    } else {
      request.grantId = grantId;
    }
    if (purpose == 'device.revoke') request.rootPublicKey = rootPublic;
    if (delegated) request.recoveryGrantId = credentials.recoveryGrantId;
    if (pairing != null) {
      request.pairingId = pairing.id;
      request.administrative = pairing.administrative;
    }
    final auth = AuthServiceClient(channel);
    final options = CallOptions(timeout: const Duration(seconds: 10));
    final challenge = await auth.createChallenge(request, options: options);
    final checkedIdentity = await credentials.identity();
    final signing = await checkedSigningBytes(
      challenge,
      server,
      rootPublic,
      devicePublic,
      purpose,
      grantId,
      expectedScopes:
          (pairing == null
              ? target?.scopes
              : [
                  'chat.read',
                  'chat.write',
                  if (pairing.administrative) 'space.manage',
                ]) ??
          [
            'chat.read',
            'chat.write',
            if (credentials.administrative) 'space.manage',
          ],
      authorizerGrantId: delegated ? credentials.recoveryGrantId : '',
      pairingId: pairing?.id ?? '',
      expectedPrincipal: checkedIdentity.principalId,
      expectedEpoch: checkedIdentity.epoch,
    );
    final key = purpose == 'auth.login'
        ? device
        : delegated
        ? await algorithm.newKeyPairFromSeed(credentials.recoverySeed)
        : root!;
    final signature = await algorithm.sign(signing, keyPair: key);
    final result = await auth.completeChallenge(
      CompleteChallengeRequest(
        challengeId: challenge.challengeId,
        signature: signature.bytes,
        invitationToken: invitationToken,
      ),
      options: options,
    );
    final principal = checkedIdentity.principalId;
    if (result.principalId != principal ||
        !RegExp(r'^dg_[A-Za-z0-9_-]{43}$').hasMatch(result.grantId) ||
        (purpose != 'device.register' &&
            purpose != 'device.delegate' &&
            result.grantId != grantId)) {
      throw const FormatException('Ответ входа не соответствует ключам');
    }
    return result;
  }

  @override
  Future<List<Content>> messages() async {
    await _ensureSession();
    final id = selectedChannelId;
    if (!canRead) return [];
    final result = <Content>[];
    var cursor = '';
    for (var page = 0; page < 11; page++) {
      final response = await ContentServiceClient(channel).listContent(
        ListContentRequest(channelId: id, after: cursor),
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
    final id = selectedChannelId;
    if (!canWrite) {
      throw const GrpcError.permissionDenied('В этом канале нельзя писать');
    }
    await _ensureSession();
    final result = await ContentServiceClient(channel).createContent(
      CreateContentRequest(channelId: id, text: text, idempotencyKey: key),
      options: _options,
    );
    return result.content;
  }

  Future<ListEventsResponse> events(String after) async {
    await _ensureSession();
    return SyncServiceClient(channel).listEvents(
      ListEventsRequest(channelId: selectedChannelId, after: after),
      options: _options,
    );
  }

  @override
  Stream<SubscribeResponse> subscribe(String after) async* {
    final id = selectedChannelId;
    if (!canRead) return;
    await _ensureSession();
    final stream = SyncServiceClient(channel).subscribe(
      SubscribeRequest(channelId: id, after: after),
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
        if (frame.heartbeat) {
          await refreshMembership();
          await refreshChannels();
        }
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
    await _ensureSession();
    await AuthServiceClient(channel)
        .revokeCurrentDevice(RevokeCurrentDeviceRequest(), options: _options);
    _token = '';
    _expiresAt = 0;
  }

  @override
  Future<void> close() => channel.shutdown();
  @override
  Future<List<DeviceGrant>> listDevices() async {
    await _ensureSession();
    return (await AuthServiceClient(
      channel,
    ).listDevices(ListDevicesRequest(), options: _options)).devices;
  }

  @override
  String get currentGrantId => record.grantId;
  @override
  bool get hasRootAuthority => record.rootSeed.isNotEmpty;
  @override
  Future<void> authorizeAdministration({DeviceRecord? authority}) async {
    await refreshMembership();
    _needsOwnerSetup = !(await AdminServiceClient(
      channel,
    ).getSetupStatus(GetSetupStatusRequest(), options: _options)).initialized;
    if (!canManageSpace && !needsOwnerSetup) {
      throw const FormatException('Нужна роль владельца или администратора');
    }
    final grants = await listDevices();
    final current = grants.where((g) => g.id == record.grantId).firstOrNull;
    if (current == null || current.revoked) {
      throw const FormatException('Текущее разрешение недействительно');
    }
    if (current.scopes.contains('space.manage')) return;
    final credentials = authority ?? record;
    checkTrust(server, credentials);
    if ((await credentials.identity()).principalId != principalId) {
      throw const FormatException('Карточка относится к другой идентичности');
    }
    if (credentials.rootSeed.isEmpty) {
      throw const FormatException(
        'Для выдачи разрешения нужна корневая карточка. Recovery-карточка не расширяет свои права',
      );
    }
    final signer = DeviceRecord(
      origin: record.origin,
      serverId: record.serverId,
      serverKey: record.serverKey,
      rootSeed: credentials.rootSeed,
      deviceSeed: record.deviceSeed,
      rootHistory: credentials.rootHistory,
      administrative: true,
    );
    final result = await _authorize('device.register', authority: signer);
    final next = DeviceRecord.fromJson({
      ...record.toJson(),
      'grantId': result.grantId,
      'administrative': true,
    });
    // Старое разрешение сохраняется до проверенной записи нового в vault.
    await vault.save(next);
    final saved = await vault.load(next.origin);
    if (saved?.grantId != next.grantId || saved?.administrative != true) {
      throw const FormatException(
        'Не удалось проверить сохранение разрешения. Повторите подключение',
      );
    }
    record = next;
    _expiresAt = 0;
    await login();
    await _authorize('device.revoke', target: current, authority: credentials);
  }

  @override
  Future<void> prepareRotation({bool renew = false}) async {
    await _ensureSession();
    if (vault is! RotationJournalVault) {
      throw const FormatException('Нет защищённого журнала ротации');
    }
    await rotation.prepareRootRotation(
      server,
      record,
      vault as RotationJournalVault,
      AuthServiceClient(channel),
      _options,
      renew: renew,
    );
  }

  @override
  Future<void> revokeDevice(
    DeviceGrant grant, {
    DeviceRecord? authority,
  }) async {
    if (grant.id == record.grantId) {
      await revoke();
      return;
    }
    if (authority != null) {
      checkTrust(server, authority);
      final id = (await authority.identity()).principalId;
      if (id != principalId) {
        throw const FormatException('Карточка относится к другой идентичности');
      }
    }
    await _authorize('device.revoke', target: grant, authority: authority);
  }

  @override
  Future<Map<String, dynamic>> recoveryPayload() async {
    if (!hasRootAuthority && record.recoverySeed.isEmpty) {
      throw const FormatException(
        'Для этой операции нужна исходная карточка. Ключ восстановления не сохраняется в рабочем устройстве.',
      );
    }
    final rootPublic = record.rootSeed.isEmpty
        ? record.rootPublicKey
        : (await (await Ed25519().newKeyPairFromSeed(
            record.rootSeed,
          )).extractPublicKey()).bytes;
    final payload = <String, dynamic>{
      'v': record.rootHistory.isEmpty ? 1 : 2,
      'origin': record.origin,
      'server_id': record.serverId,
      'server_key': record.serverKey,
      'root_public_key': url64(rootPublic),
      'credential': record.rootSeed.isEmpty ? 'recovery' : 'root',
      'secret': url64(
        record.rootSeed.isEmpty ? record.recoverySeed : record.rootSeed,
      ),
      if (record.rootHistory.isNotEmpty) 'root_history': record.rootHistory,
    };
    if (record.rootSeed.isEmpty) {
      final parent = (await listDevices())
          .where((g) => g.id == record.recoveryGrantId)
          .firstOrNull;
      if (parent == null ||
          parent.revoked ||
          parent.expiresAt.toInt() <=
              DateTime.now().millisecondsSinceEpoch ~/ 1000) {
        throw const FormatException('Ключ восстановления недействителен');
      }
      payload.addAll({
        'recovery_grant_id': parent.id,
        'expires_at': parent.expiresAt.toInt(),
        'credential_public_key': url64(parent.publicKey),
      });
    }
    return payload;
  }

  @override
  Future<String> approvePairing(
    Pairing pairing, {
    DeviceRecord? authority,
  }) async {
    final credentials = authority ?? record;

    if (credentials.rootSeed.isEmpty && credentials.recoverySeed.length != 32) {
      throw const FormatException(
        'Откройте корневую или recovery-карточку для подтверждения',
      );
    }
    checkTrust(server, credentials);
    final root = credentials.rootSeed.isEmpty
        ? credentials.rootPublicKey
        : (await (await Ed25519().newKeyPairFromSeed(
            credentials.rootSeed,
          )).extractPublicKey()).bytes;
    final id = (await credentials.identity()).principalId;
    if (id != principalId) {
      throw const FormatException(
        'Корневая карточка относится к другой идентичности',
      );
    }
    await _authorize(
      'device.register',
      authority: credentials,
      pairing: pairing,
    );
    return pairVerificationCode(
      server.serverId,
      pairing.id,
      root,
      pairing.publicKey,
      administrative: pairing.administrative,
    );
  }

  @override
  Future<String> preparePairing(
    Pairing pairing, {
    DeviceRecord? authority,
  }) async {
    final credentials = authority ?? record;

    if (credentials.rootSeed.isEmpty && credentials.recoverySeed.length != 32) {
      throw const FormatException('Нужен root или recovery-карточка');
    }
    checkTrust(server, credentials);
    final root = credentials.rootSeed.isEmpty
        ? credentials.rootPublicKey
        : (await (await Ed25519().newKeyPairFromSeed(
            credentials.rootSeed,
          )).extractPublicKey()).bytes;
    final id = (await credentials.identity()).principalId;
    if (id != principalId) {
      throw const FormatException('Карточка относится к другой идентичности');
    }
    await _ensureSession();
    await AuthServiceClient(channel).proposePairing(
      ProposePairingRequest(pairingId: pairing.id),
      options: _options,
    );
    return pairVerificationCode(
      server.serverId,
      pairing.id,
      root,
      pairing.publicKey,
      administrative: pairing.administrative,
    );
  }
}

Future<String> pairVerificationCode(
  String serverId,
  String pairId,
  List<int> root,
  List<int> device, {
  bool administrative = false,
}) async {
  final bytes = (await Sha256().hash([
    ...utf8.encode(
      'space/pair-check/v1\u0000$serverId\u0000$pairId\u0000${administrative ? 'manage' : 'chat'}\u0000',
    ),
    ...root,
    ...device,
  ])).bytes;
  final hex = bytes
      .take(8)
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join()
      .toUpperCase();
  return List.generate(4, (i) => hex.substring(i * 4, i * 4 + 4)).join('-');
}

Future<DeviceRecord> recordFromRecovery(Map<String, dynamic> payload) async {
  if ((payload['v'] != 1 && payload['v'] != 2) ||
      !['root', 'recovery'].contains(payload['credential'])) {
    throw const FormatException('Неподдерживаемая карточка');
  }
  final origin = localOrigin(payload['origin'] as String).toString();
  final rootPublic = base64Url.decode(
    base64Url.normalize(payload['root_public_key'] as String),
  );
  final secret = base64Url.decode(
    base64Url.normalize(payload['secret'] as String),
  );
  final serverKey = payload['server_key'] as String,
      serverId = payload['server_id'] as String;
  if (rootPublic.length != 32 ||
      secret.length != 32 ||
      !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(serverId) ||
      !RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(serverKey)) {
    throw const FormatException('Повреждены сведения о сервере или ключах');
  }
  final pair = await Ed25519().newKeyPairFromSeed(secret);
  final actual = url64((await pair.extractPublicKey()).bytes);
  final isRoot = payload['credential'] == 'root';
  if (actual !=
      (isRoot ? url64(rootPublic) : payload['credential_public_key'])) {
    throw const FormatException(
      'Ключ карточки не соответствует публичному ключу',
    );
  }
  if (!isRoot &&
      (payload['expires_at'] is! int ||
          (payload['expires_at'] as int) <=
              DateTime.now().millisecondsSinceEpoch ~/ 1000 ||
          !RegExp(r'^dg_[A-Za-z0-9_-]{43}$')
              .hasMatch(payload['recovery_grant_id'] as String))) {
    throw const FormatException('Разрешение восстановления недействительно');
  }
  final device = await Ed25519().newKeyPair();
  final history = (payload['root_history'] as List? ?? [])
      .map((v) => Map<String, dynamic>.from(v as Map))
      .toList();
  if (payload['v'] == 1 && history.isNotEmpty ||
      payload['v'] == 2 && history.isEmpty) {
    throw const FormatException(
      'Версия карточки не соответствует истории ключей',
    );
  }
  final record = DeviceRecord(
    origin: origin,
    serverId: serverId,
    serverKey: serverKey,
    rootSeed: isRoot ? secret : [],
    deviceSeed: await device.extractPrivateKeyBytes(),
    rootPublicKey: rootPublic,
    recoverySeed: isRoot ? [] : secret,
    recoveryGrantId: isRoot ? '' : payload['recovery_grant_id'] as String,
    administrative: !isRoot,
    rootHistory: history,
  );
  await record.identity();
  return record;
}

String newRequestKey() =>
    url64(List<int>.generate(24, (_) => Random.secure().nextInt(256)));

Future<List<int>> checkedSigningBytes(
  CreateChallengeResponse response,
  Discovery server,
  List<int> root,
  List<int> device,
  String purpose,
  String grantId, {
  List<String> expectedScopes = const ['chat.read', 'chat.write'],
  String authorizerGrantId = '',
  String pairingId = '',
  bool allowHistorical = false,
  int registrationDays = 30,
  String expectedPrincipal = '',
  int expectedEpoch = 1,
}) async {
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
  if (authorizerGrantId.isNotEmpty) {
    expectedKeys.insert(1, 'authorizer_grant_id');
  }
  if (pairingId.isNotEmpty) {
    expectedKeys.add('pairing_id');
    expectedKeys.sort();
  }
  final principal = expectedPrincipal.isEmpty
      ? await rootPrincipal(root)
      : expectedPrincipal;
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
      transcript['auth_epoch'] == expectedEpoch &&
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
      jsonEncode(transcript['scopes']) == jsonEncode(expectedScopes) &&
      (authorizerGrantId.isEmpty ||
          transcript['authorizer_grant_id'] == authorizerGrantId) &&
      expiry == issued + 60 &&
      (allowHistorical || expiry > now) &&
      issued <= now + 5 &&
      grantExpiry > expiry &&
      grantExpiry > now &&
      (pairingId.isEmpty || transcript['pairing_id'] == pairingId) &&
      (purpose == 'device.register' || purpose == 'device.delegate'
          ? (purpose == 'device.register'
                ? grantExpiry == issued + registrationDays * 86400
                : grantExpiry <= issued + 30 * 86400)
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
    'device.delegate': 'space/device-delegate/v1',
    'recovery.device.revoke': 'space/recovery-device-revoke/v1',
  }[purpose];
  if (prefix == null) {
    throw const FormatException('Неизвестное назначение подписи');
  }
  return utf8.encode('$prefix\u0000$canonical');
}
