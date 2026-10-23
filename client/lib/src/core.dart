export 'endpoint_connection.dart';
export 'server_endpoints.dart';
import 'server_endpoints.dart';
import 'endpoint_connection.dart';
import 'mls/client.dart';
import 'mls/local_store.dart';
import 'mls/native.dart';
import 'mls/channel_pin.dart';
import 'mls/platform_stub.dart'
    if (dart.library.ui) 'mls/platform_flutter.dart'
    as mls_platform;
import 'local_failure.dart';
import 'queued_mutation.dart';

import 'package:fixnum/fixnum.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

import 'rpc_clients.dart';
import 'message_search.dart';
import 'history_pages.dart';
import 'root_history.dart';
import 'root_adoption.dart';
import 'root_device_proof.dart';
import 'origin_binding.dart';
import 'rpc_connection.dart';
import 'forum_api.dart';
import 'generated/space/v1/forum.pb.dart' as forum;
import 'generated/space/v1/forum.connect.spec.dart' as forum_specs;
import 'generated/space/v1/voice.pb.dart' as voice;
import 'generated/space/v1/voice.connect.spec.dart' as voice_specs;
import 'rpc_http.dart' show pinnedRpcClient;
import 'root_rotation.dart' as rotation;

part 'queued_mutation_rpc.dart';
part 'push_registration.dart';
part 'voice_rpc.dart';
part 'forum_rpc.dart';

String url64(List<int> value) => base64Url.encode(value).replaceAll('=', '');

class Discovery {
  Discovery(
    this.origin,
    this.serverId,
    this.publicKey, {
    this.dialHost,
    this.tlsFingerprint = '',
    this.voiceRoomsVersion = 0,
    this.announcement,
    Uri? connectOrigin,
    Uri? endpoint,
  }) : connectOrigin = connectOrigin ?? origin,
       endpoint = endpoint ?? origin;
  final Uri origin, connectOrigin, endpoint;
  final EndpointAnnouncement? announcement;
  final String serverId;
  final List<int> publicKey;
  final String? dialHost;
  final String tlsFingerprint;
  final int voiceRoomsVersion;
  RpcConnection openConnection({String setupCode = ''}) =>
      RpcConnection.connect(
        connectOrigin,
        tlsFingerprint,
        dialHost: dialHost,
        setupCode: setupCode,
      );
  Future<String> fingerprint() async =>
      (await Sha256().hash(publicKey)).bytes
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
}

class ConnectionInput {
  const ConnectionInput(
    this.origin,
    this.invitationToken, [
    this.tlsFingerprint = '',
    this.endpoints = const [],
    this.serverId = '',
    this.setupCode = '',
  ]);
  final String tlsFingerprint;
  final List<ServerEndpoint> endpoints;
  final String serverId;
  final Uri origin;
  final String invitationToken;
  final String setupCode;
}

ConnectionInput parseConnectionInput(
  String address, {
  String invitationToken = '',
}) {
  if (address.length > 16384) {
    throw const FormatException('Слишком длинная ссылка');
  }
  final uri = Uri.parse(address.trim());
  var token = invitationToken.trim();
  if (uri.hasFragment) {
    final fields = Uri.splitQueryString(uri.fragment);
    if (Uri(query: uri.fragment).queryParametersAll.values
        .any((v) => v.length != 1)) {
      throw const FormatException('Повторные поля приглашения');
    }
    _validateInvitationFields(fields);
    _validateSetupLink(uri, fields, token);
    if (fields.containsKey('invite') &&
        token.isNotEmpty &&
        token != fields['invite']) {
      throw const LocalFailure(
        LocalFailureCode.addressInvalid,
        'Код приглашения не совпадает со ссылкой',
      );
    }
    token = fields['invite'] ?? token;
    if (uri.path.isNotEmpty && uri.path != '/') {
      throw const LocalFailure(
        LocalFailureCode.addressInvalid,
        'Некорректный адрес приглашения',
      );
    }
    return ConnectionInput(
      localOrigin(uri.replace(path: '').removeFragment().toString()),
      token,
      fields['tls'] ?? '',
      _invitedEndpoints(fields['addresses']),
      fields['server'] ?? '',
      fields['setup'] ?? '',
    );
  }
  return ConnectionInput(localOrigin(address), token);
}

List<ServerEndpoint> _invitedEndpoints(String? encoded) => encoded == null
    ? const []
    : parseEndpoints(
        jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(encoded)))),
      );

void _validateInvitationFields(Map<String, String> fields) {
  if ((fields.containsKey('addresses') &&
          (!fields.containsKey('tls') || !fields.containsKey('server'))) ||
      (fields.containsKey('server') &&
          !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(fields['server']!)) ||
      fields.keys.any(
        (key) =>
            !['invite', 'tls', 'server', 'addresses', 'setup'].contains(key),
      ) ||
      (!fields.containsKey('invite') && !fields.containsKey('tls')) ||
      (fields.containsKey('tls') &&
          !RegExp(r'^[0-9a-f]{64}$').hasMatch(fields['tls']!)) ||
      (fields.containsKey('invite') &&
          !RegExp(r'^iv_[A-Za-z0-9_-]{43}$').hasMatch(fields['invite']!))) {
    throw const LocalFailure(
      LocalFailureCode.addressInvalid,
      'Некорректная ссылка приглашения',
    );
  }
}

void _validateSetupLink(Uri uri, Map<String, String> fields, String token) {
  if (!fields.containsKey('setup')) return;
  if (uri.scheme != 'https' ||
      !fields.containsKey('tls') ||
      !fields.containsKey('server') ||
      fields.containsKey('invite') ||
      token.isNotEmpty ||
      !RegExp(r'^setup_[A-Za-z0-9_-]{43}$').hasMatch(fields['setup']!)) {
    throw const FormatException('Некорректная ссылка первичной настройки');
  }
}

Uri localOrigin(String input) {
  final uri = Uri.parse(input.trim());
  final address = InternetAddress.tryParse(uri.host);
  if (!((uri.scheme == 'http' && address != null && address.isLoopback) ||
          (uri.scheme == 'https' && uri.host.isNotEmpty)) ||
      uri.userInfo.isNotEmpty ||
      uri.path.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment ||
      uri.port < 1 ||
      uri.port > 65535) {
    throw const LocalFailure(
      LocalFailureCode.addressInvalid,
      'Нужен HTTPS адрес сервера или локальный HTTP адрес',
    );
  }
  return uri;
}

String certificateFingerprint(X509Certificate certificate) =>
    crypto.sha256.convert(certificate.der).toString();

bool certificateIsCurrent(X509Certificate certificate) {
  final now = DateTime.now();
  return !certificate.startValidity.isAfter(now) &&
      certificate.endValidity.isAfter(now);
}

Uri discoveryConnectOrigin(Map<String, dynamic> data, Uri networkOrigin) {
  if (data['connect_endpoint'] != '/') {
    throw const LocalFailure(
      LocalFailureCode.connectRequired,
      'Сервер не поддерживает ConnectRPC. Обновите домашний runtime.',
    );
  }
  return networkOrigin;
}

bool _acceptDiscoveryCertificate(X509Certificate certificate, String pin) =>
    certificateIsCurrent(certificate) &&
    (pin.isEmpty || certificateFingerprint(certificate) == pin);

HttpClient _discoveryClient(
  Uri networkOrigin,
  String tlsFingerprint,
  Future<void>? cancelled,
  String? dialAddress,
) {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
  cancelled?.then((_) => client.close(force: true));
  client.findProxy = (_) => 'DIRECT';
  if (dialAddress != null) {
    client.connectionFactory = (uri, proxyHost, proxyPort) =>
        SecureSocket.startConnect(
          dialAddress,
          uri.port,
          onBadCertificate: (certificate) =>
              _acceptDiscoveryCertificate(certificate, tlsFingerprint),
        );
  }
  client.badCertificateCallback = (certificate, host, port) =>
      host == networkOrigin.host &&
      port == networkOrigin.port &&
      _acceptDiscoveryCertificate(certificate, tlsFingerprint);
  return client;
}

Future<Discovery> discover(
  String input, {
  String tlsFingerprint = '',
  String? homeOrigin,
  Future<void>? cancelled,
  String? dialAddress,
}) async {
  final networkOrigin = localOrigin(input);
  final origin = homeOrigin == null ? networkOrigin : localOrigin(homeOrigin);
  if (homeOrigin != null &&
      (networkOrigin.scheme != 'http' ||
          !InternetAddress(networkOrigin.host).isLoopback ||
          origin.scheme != 'https')) {
    throw const LocalFailure(
      LocalFailureCode.protocolInvalid,
      'Недопустимый локальный маршрут домашнего сервера',
    );
  }
  final client = _discoveryClient(
    networkOrigin,
    tlsFingerprint,
    cancelled,
    dialAddress,
  );
  try {
    final request = await client
        .getUrl(networkOrigin.resolve('/.well-known/space-protocol'))
        .timeout(const Duration(seconds: 10));
    request.followRedirects = false;
    final response = await request.close().timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw const LocalFailure(
        LocalFailureCode.protocolInvalid,
        'Сервер не предоставил discovery. Перенаправления не принимаются.',
      );
    }
    final certificate = response.certificate;
    final actualFingerprint = certificate == null
        ? ''
        : certificateFingerprint(certificate);
    if (tlsFingerprint.isNotEmpty &&
        homeOrigin == null &&
        actualFingerprint != tlsFingerprint) {
      throw const LocalFailure(
        LocalFailureCode.tlsRejected,
        'Сертификат не совпадает с отпечатком в ссылке',
      );
    }
    final bytes = <int>[];
    await for (final chunk in response.timeout(const Duration(seconds: 10))) {
      bytes.addAll(chunk);
      if (bytes.length > 16384) {
        throw const LocalFailure(
          LocalFailureCode.protocolInvalid,
          'Слишком большой discovery',
        );
      }
    }
    return await _discoveryFromBytes(
      bytes,
      origin,
      networkOrigin,
      homeOrigin,
      tlsFingerprint,
      actualFingerprint,
      dialAddress,
    );
  } finally {
    client.close(force: true);
  }
}

Future<Discovery> _discoveryFromBytes(
  List<int> bytes,
  Uri origin,
  Uri networkOrigin,
  String? homeOrigin,
  String tlsFingerprint,
  String actualFingerprint,
  String? dialAddress,
) async {
  final data = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  final id = data['server_id'] as String;
  final key = base64Url.decode(
    base64Url.normalize(data['signing_public_key'] as String),
  );
  if (data['protocol_version'] != '0.1-experimental' ||
      data['signing_algorithm'] != 'Ed25519' ||
      data['manifest'] != '/api/v1/manifest' ||
      !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(id) ||
      key.length != 32) {
    throw const LocalFailure(
      LocalFailureCode.protocolInvalid,
      'Discovery несовместим с профилем Space',
    );
  }
  final fingerprint = homeOrigin == null ? actualFingerprint : tlsFingerprint;
  final identityOrigin = await verifiedIdentityOrigin(
    data,
    origin,
    fingerprint,
    key,
  );
  return Discovery(
    identityOrigin,
    id,
    key,
    voiceRoomsVersion: data['voice_rooms_version'] == '3' ? 3 : 0,
    dialHost: dialAddress ?? networkOrigin.host,
    tlsFingerprint: fingerprint,
    connectOrigin: discoveryConnectOrigin(data, networkOrigin),
    endpoint: origin,
    announcement: data['endpoints'] == null
        ? null
        : await EndpointAnnouncement.verify(data, origin, fingerprint, key),
  );
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
    this.tlsFingerprint = '',
    this.endpoint = '',
    this.endpoints = const [],
    this.endpointRevision = 0,
    this.endpointDigest = '',
    Map<String, String>? mlsChannels,
    this.mlsIdentity,
  }) : mlsChannels = {...?mlsChannels};
  final String origin, serverId, serverKey;
  final String tlsFingerprint;
  String endpoint;
  List<ServerEndpoint> endpoints;
  int endpointRevision;
  String endpointDigest;
  String get connectionAddress => endpoint.isEmpty ? origin : endpoint;
  final List<int> rootSeed, deviceSeed;
  final List<int> rootPublicKey;
  List<int> recoverySeed;
  final String recoveryGrantId;
  final bool administrative;
  String grantId;
  final List<Map<String, dynamic>> rootHistory;
  final Map<String, String> mlsChannels;
  Map<String, dynamic>? mlsIdentity;
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
    'tlsFingerprint': tlsFingerprint,
    'endpoint': endpoint,
    'endpoints': endpoints.map((e) => e.toJson()).toList(),
    'endpointRevision': endpointRevision,
    'endpointDigest': endpointDigest,
    'rootSeed': url64(rootSeed),
    'deviceSeed': url64(deviceSeed),
    'grantId': grantId,
    'rootPublicKey': url64(rootPublicKey),
    'recoverySeed': url64(recoverySeed),
    'recoveryGrantId': recoveryGrantId,
    'administrative': administrative,
    'rootHistory': rootHistory,
    'mlsChannels': mlsChannels,
    'mlsIdentity': ?mlsIdentity,
  };
  static DeviceRecord fromJson(Map<String, dynamic> data) {
    if (data['v'] != 1 && data['v'] != 2 && data['v'] != 3) {
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Неизвестная версия хранилища ключей',
      );
    }
    final record = DeviceRecord(
      origin: data['origin'] as String,
      serverId: data['serverId'] as String,
      serverKey: data['serverKey'] as String,
      tlsFingerprint: data['tlsFingerprint'] as String? ?? '',
      endpoint: data['endpoint'] as String? ?? '',
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
      mlsChannels: Map<String, String>.from(data['mlsChannels'] as Map? ?? {}),
      mlsIdentity: data['mlsIdentity'] == null
          ? null
          : Map<String, dynamic>.from(data['mlsIdentity'] as Map),
    );
    _requireDeviceSecrets(record);
    if (record.endpoint.isNotEmpty) localOrigin(record.endpoint);
    _readEndpointState(record, data);
    return record;
  }
}

void _readEndpointState(DeviceRecord record, Map<String, dynamic> data) {
  record.endpoints = (data['endpoints'] as List? ?? []).isEmpty
      ? const []
      : parseEndpoints(data['endpoints']);
  record.endpointRevision = data['endpointRevision'] as int? ?? 0;
  record.endpointDigest = data['endpointDigest'] as String? ?? '';
  if (record.endpointRevision < 0 ||
      record.endpointRevision > maxEndpointRevision ||
      (record.endpointRevision > 0 &&
          (record.endpoints.isEmpty ||
              !RegExp(r'^[0-9a-f]{64}$').hasMatch(record.endpointDigest)))) {
    throw const FormatException('Повреждена сохранённая версия адресов');
  }
}

void _requireDeviceSecrets(DeviceRecord record) {
  if ((record.rootSeed.length != 32 &&
          !(record.rootSeed.isEmpty &&
              record.rootPublicKey.length == 32 &&
              (record.recoverySeed.isEmpty ||
                  (record.recoverySeed.length == 32 &&
                      RegExp(r'^dg_[A-Za-z0-9_-]{43}$')
                          .hasMatch(record.recoveryGrantId))))) ||
      record.deviceSeed.length != 32) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Повреждено хранилище ключей',
    );
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
  final announcement = server.announcement;
  if (record.endpointRevision > 0 &&
      (announcement == null ||
          announcement.revision < record.endpointRevision ||
          (announcement.revision == record.endpointRevision &&
              announcement.digest != record.endpointDigest))) {
    throw const FormatException('Откат или подмена списка адресов');
  }
  if (record.origin != server.origin.toString() ||
      record.serverId != server.serverId ||
      record.serverKey != url64(server.publicKey) ||
      (record.tlsFingerprint.isNotEmpty &&
          record.tlsFingerprint != server.tlsFingerprint)) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
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

abstract interface class ReplyMessageSession {
  bool get repliesSupported;
  Future<Content> sendReplyQueued(
    String channelId,
    String text,
    String key,
    List<String> attachments,
    String replyTo,
  );
}

abstract interface class QueuedMessageSession {
  Future<Content> sendQueued(
    String channelId,
    String text,
    String key,
    List<String> attachments,
  );
}

abstract interface class MessageReactions {
  Future<Content> setReaction(Content message, String emoji, bool active);
}

abstract interface class MessageChanges {
  Future<Content> updateMessage(Content message, String text);
  Future<Content> deleteMessage(Content message);
}

abstract interface class SpacePresentation {
  String get spaceTitle;
  String get chatTitle;
}

abstract interface class ChannelUpdates {
  Stream<void> watchChannelChanges();
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
  Future<List<DeviceGrant>> previewRotationDevices();
  Future<void> prepareRotation({
    bool renew = false,
    List<DeviceGrant>? retainedDevices,
  });
}

abstract interface class ServerIconPresentation {
  ServerIcon? get serverIcon;
}

abstract interface class MemberProfile {
  Future<String> getNickname();
  Future<void> setNickname(String nickname);
}

abstract interface class AttachmentPolicy {
  bool get attachmentsEnabled;
}

abstract interface class AttachmentSession {
  Future<BeginUploadResponse> beginUpload(BeginUploadRequest request);
  Future<UploadChunkResponse> uploadChunk(UploadChunkRequest request);
  Future<CompleteUploadResponse> completeUpload(CompleteUploadRequest request);
  Future<CancelUploadResponse> cancelUpload(CancelUploadRequest request);
  Future<DownloadChunkResponse> downloadChunk(DownloadChunkRequest request);
  Future<ListMyAssetsResponse> listMyAssets(ListMyAssetsRequest request);
  Future<ListChannelAssetsResponse> listChannelAssets(
    ListChannelAssetsRequest request,
  );
  Future<Content> sendAttachments(
    String channelId,
    String text,
    String key,
    List<String> ids,
  );
}

class SpaceSession
    implements
        MessageSearchSession,
        HistoryPageSession,
        LiveSession,
        QueuedMessageSession,
        ReplyMessageSession,
        QueuedMutationSession,
        MessageChanges,
        MessageReactions,
        MemberProfile,
        AttachmentSession,
        AttachmentPolicy,
        SpacePresentation,
        ServerIconPresentation,
        SpaceAccess,
        DeviceManagement,
        AdministrativeDeviceControl,
        RootRotationControl,
        ChannelNavigation,
        ChannelUpdates,
        SpaceAdministration {
  final _closing = StreamController<void>.broadcast();
  Stream<void> get closing => _closing.stream;
  SpaceSession._(this.server, this.record, this.vault, this.channel);
  Future<MlsClient>? _mlsClient;
  String _mlsGrant = '';
  Future<MlsClient> mlsClient() {
    if (_mlsGrant != record.grantId) {
      _mlsClient = null;
      _mlsGrant = record.grantId;
    }
    return _mlsClient ??= _openMlsClient();
  }

  Future<MlsClient> _openMlsClient() async {
    final engine = NativeMlsEngine();
    if (!engine.available) {
      throw StateError('В сборке нет нативного модуля MLS');
    }
    final public = await (await Ed25519().newKeyPairFromSeed(record.deviceSeed))
        .extractPublicKey();
    final identity = await record.identity();
    final lockDirectory = await mls_platform.lockDirectory();
    final authenticationGrant = record.grantId;
    final scope =
        record.mlsIdentity ??
        {
          'server_id': server.serverId,
          'principal_id': identity.principalId,
          'grant_id': record.grantId,
          'public_key': public.bytes,
        };
    if (scope['server_id'] != server.serverId ||
        scope['principal_id'] != identity.principalId) {
      throw StateError(
        'Идентичность MLS принадлежит другому пространству или участнику',
      );
    }
    final requireExisting = record.mlsIdentity != null;
    final local = MlsLocalStore(
      storage: mls_platform.secureStorage(),
      engine: engine,
      scope: scope,
      deviceSeed: record.deviceSeed,
      requireExisting:
          requireExisting || scope['grant_id'] != authenticationGrant,
      lockDirectory: lockDirectory,
    );
    // Не создаём новый ratchet, если запись ранее существовавшего устройства пропала.
    if (!requireExisting) await local.read();
    record.mlsIdentity = scope;
    await vault.save(record);
    return MlsClient(
      local: local,
      connection: channel,
      options: () => mlsOptions(expectedGrant: authenticationGrant),
      pinChannel: (id, group) => _pinMlsChannel(id, group),
      attachmentsEnabled: () => attachmentsEnabled,
    );
  }

  Future<RpcOptions> mlsOptions({required String expectedGrant}) async {
    await _ensureSession();
    if (record.grantId != expectedGrant) {
      throw StateError(
        'Ключ устройства изменился. Переподключитесь к закрытому каналу.',
      );
    }
    return _options;
  }

  Future<void> _pinMlsChannel(String id, List<int> group) async {
    final pin = base64Encode(group);
    final existing = record.mlsChannels[id];
    if (existing != null && existing != pin) {
      throw StateError('Режим защиты канала изменился');
    }
    if (existing == pin) return;
    record.mlsChannels[id] = pin;
    try {
      await vault.save(record);
    } catch (_) {
      record.mlsChannels.remove(id);
      rethrow;
    }
  }

  Future<void> _pinMlsCatalog(List<Channel> channels) async {
    for (final channel in channels) {
      requirePinnedMlsChannel(record.mlsChannels, channel);
      if (channel.mlsGroupId.isNotEmpty) {
        await _pinMlsChannel(channel.id, channel.mlsGroupId);
      }
    }
  }

  Discovery server;
  DeviceRecord record;
  final IdentityVault vault;
  final RpcConnection channel;
  String _token = '';
  @override
  String spaceTitle = '';
  @override
  bool attachmentsEnabled = false;
  bool mlsSupported = false;
  bool forumSupported = false;
  bool forumNavigationSupported = false;
  bool forumModerationSupported = false;
  bool forumReportsSupported = false;
  bool forumAttachmentsSupported = false;
  @override
  bool repliesSupported = false;
  @override
  ServerIcon? serverIcon;
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
    if (chosen == null) {
      throw const LocalFailure(
        LocalFailureCode.protocolInvalid,
        'Канал больше не доступен',
      );
    }
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
      throw const LocalFailure(
        LocalFailureCode.protocolInvalid,
        'Manifest не соответствует серверу',
      );
    }
    final result = await ChannelServiceClient(channel).listChannels(
      ListChannelsRequest(includeArchived: true),
      options: _options,
    );
    await _pinMlsCatalog(result.channels);
    mlsSupported = manifest.mlsSupported;
    repliesSupported = manifest.ordinaryRepliesSupported;
    forumSupported = manifest.capabilities.contains('core.forum.v1');
    forumModerationSupported = manifest.capabilities.contains(
      'core.forum.moderation.v1',
    );
    forumReportsSupported = manifest.capabilities.contains(
      'core.forum.reports.v1',
    );
    forumNavigationSupported = manifest.capabilities.contains(
      'core.forum.navigation.v1',
    );
    forumAttachmentsSupported = manifest.capabilities.contains(
      'core.forum.attachments.v1',
    );
    _applyCatalog(
      result.channels,
      manifest.title,
      manifest.hasIcon() ? manifest.icon : null,
      manifest.attachmentsEnabled,
    );
  }

  void _applyCatalog(
    List<Channel> channels,
    String title, [
    ServerIcon? icon,
    bool? attachmentsEnabled,
  ]) {
    if (icon != null) serverIcon = icon;
    if (attachmentsEnabled != null) {
      this.attachmentsEnabled = attachmentsEnabled;
    }
    final seen = <String>{};
    for (final c in channels) {
      if (!RegExp(r'^[a-z][a-z0-9_-]{0,63}$').hasMatch(c.id) ||
          !seen.add(c.id) ||
          c.title.isEmpty ||
          c.latestMessageSequence.isNegative ||
          !c.views.any(
            (v) => ['chat', 'voice_room', 'forum'].contains(v.type),
          ) ||
          !c.hasPermissions()) {
        throw const LocalFailure(
          LocalFailureCode.protocolInvalid,
          'Некорректный список каналов',
        );
      }
    }
    spaceTitle = title;
    availableChannels = List.unmodifiable(channels);
    if (selectedChannelId.isNotEmpty) {
      final current = selectedChannel;
      chatTitle = current?.title ?? 'Канал недоступен';
      return;
    }
    final textChannels = availableChannels
        .where((c) => c.views.any((v) => v.type == 'chat'))
        .toList();
    final initial =
        textChannels
            .where((c) => c.permissions.read && !c.archived)
            .firstOrNull ??
        textChannels.where((c) => c.permissions.read).firstOrNull ??
        textChannels.firstOrNull;
    if (initial != null) {
      selectChannel(initial.id);
    } else {
      chatTitle = 'Нет доступных каналов';
    }
  }

  @override
  Stream<void> watchChannelChanges() async* {
    await _ensureSession();
    final stream = ChannelServiceClient(channel).watchChannels(
      WatchChannelsRequest(includeArchived: true),
      options: RpcOptions(
        timeout: const Duration(minutes: 11),
        metadata: {'authorization': 'Bearer $_token'},
        onUnauthenticated: () {
          _expiresAt = 0;
        },
      ),
    );
    try {
      await for (final frame in stream.timeout(const Duration(seconds: 35))) {
        if (frame.serverId != server.serverId) {
          throw const LocalFailure(
            LocalFailureCode.protocolInvalid,
            'Каталог относится к другому серверу',
          );
        }
        if (frame.heartbeat) {
          if (frame.channels.isNotEmpty ||
              frame.spaceTitle.isNotEmpty ||
              frame.hasIcon() ||
              frame.attachmentsEnabled ||
              frame.role.isNotEmpty) {
            throw const LocalFailure(
              LocalFailureCode.protocolInvalid,
              'Heartbeat каталога содержит данные',
            );
          }
          await _pollNetworkRoute();
          continue;
        }
        if (!['owner', 'admin', 'member', 'reader'].contains(frame.role) ||
            frame.spaceTitle.isEmpty) {
          throw const LocalFailure(
            LocalFailureCode.protocolInvalid,
            'Некорректный снимок каталога',
          );
        }
        await _pinMlsCatalog(frame.channels);
        _applyCatalog(
          frame.channels,
          frame.spaceTitle,
          frame.hasIcon() ? frame.icon : null,
          frame.attachmentsEnabled,
        );
        role = frame.role;
        yield null;
      }
    } finally {
      await stream.cancel();
    }
  }

  int _expiresAt = 0;
  Future<void>? _loginTask;
  Future<void>? _networkRouteTask;
  DateTime? _networkRouteChecked;
  @override
  String principalId = '';
  RpcOptions get _options => RpcOptions(
    timeout: const Duration(seconds: 10),
    metadata: {'authorization': 'Bearer $_token'},
    onUnauthenticated: () {
      _expiresAt = 0;
    },
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
    if (uri.path == '/api/v1/channels' ||
        RegExp(r'^/api/v1/channels/([a-z][a-z0-9_-]{0,63})(/access)?$')
            .hasMatch(uri.path)) {
      return _channelAdminRequest(uri, body, method);
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
    return _spaceAdminRequest(path, body, method);
  }

  Future<Map<String, dynamic>> _spaceAdminRequest(
    String path,
    Map<String, dynamic>? body,
    String? method,
  ) async {
    Map<String, dynamic> json(GeneratedMessage value) =>
        Map<String, dynamic>.from(value.toProto3Json() as Map);
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
          final response = await client.updateSettings(
            request,
            options: _options,
          );
          await refreshChannels();
          return json(response);
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

  Future<Map<String, dynamic>> _channelAdminRequest(
    Uri uri,
    Map<String, dynamic>? body,
    String? method,
  ) async {
    Map<String, dynamic> json(GeneratedMessage value) =>
        Map<String, dynamic>.from(value.toProto3Json() as Map);
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
      if (method == 'DELETE') {
        return json(
          await channelClient.deleteChannel(
            DeleteChannelRequest()..mergeFromProto3Json({
              'channelId': id,
              'expectedRevision': uri.queryParameters['expectedRevision'] ?? '',
            }),
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
    throw const GrpcError.unimplemented('Неподдерживаемая операция канала');
  }

  static Future<SpaceSession> connect(
    Discovery server,
    IdentityVault vault, {
    String invitationToken = '',
    DeviceRecord? restoredRecord,
    String pairingId = '',
    String setupCode = '',
  }) async {
    if (restoredRecord != null &&
        vault is RotationJournalVault &&
        await vault.loadRotation(server.origin.toString()) != null) {
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Сначала завершите сохранённую смену ключа для этого сервера',
      );
    }
    final remoteCode = server.connectOrigin.scheme == 'https' ? setupCode : '';
    final setupChannel = server.openConnection(setupCode: remoteCode);
    bool automatic = false;
    try {
      automatic = (await AdminServiceClient(setupChannel).getSetupStatus(
        GetSetupStatusRequest(),
        options: RpcOptions(timeout: const Duration(seconds: 10)),
      )).firstLoginOwner;
    } finally {
      await setupChannel.shutdown();
    }
    final record = await _connectionRecord(
      server,
      vault,
      restoredRecord,
      automatic,
      setupCode,
    );
    final channel = server.openConnection(setupCode: remoteCode);
    final session = SpaceSession._(server, record, vault, channel);
    channel.recoverRouteWith(session._refreshNetworkRoute);
    try {
      final manifest = await ChannelServiceClient(channel).getManifest(
        GetManifestRequest(),
        options: RpcOptions(timeout: const Duration(seconds: 10)),
      );
      session.repliesSupported = manifest.ordinaryRepliesSupported;
      session.forumSupported = manifest.capabilities.contains('core.forum.v1');
      session.forumModerationSupported = manifest.capabilities.contains(
        'core.forum.moderation.v1',
      );
      session.forumReportsSupported = manifest.capabilities.contains(
        'core.forum.reports.v1',
      );
      session.forumNavigationSupported = manifest.capabilities.contains(
        'core.forum.navigation.v1',
      );
      session.forumAttachmentsSupported = manifest.capabilities.contains(
        'core.forum.attachments.v1',
      );
      session.spaceTitle = manifest.title;
      session.serverIcon = manifest.hasIcon() ? manifest.icon : null;
      session.chatTitle =
          manifest.channels
              .where((channel) => channel.id == 'general')
              .firstOrNull
              ?.title ??
          'Общий чат';
      if (manifest.serverId != server.serverId ||
          manifest.protocolVersion != '0.1-experimental') {
        throw const LocalFailure(
          LocalFailureCode.protocolInvalid,
          'RPC manifest не соответствует discovery',
        );
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
      if (setupCode.isNotEmpty) {
        await AdminServiceClient(channel).claimOwner(
          ClaimOwnerRequest(setupCode: setupCode),
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
      channel.clearSetupCode();
      return session;
    } catch (_) {
      await channel.shutdown();
      rethrow;
    }
  }

  static Future<DeviceRecord> _connectionRecord(
    Discovery server,
    IdentityVault vault,
    DeviceRecord? restoredRecord,
    bool automatic,
    String setupCode,
  ) async {
    var record = restoredRecord ?? await vault.load(server.origin.toString());
    if (record != null) {
      checkTrust(server, record);
      await record.identity();
      if ((automatic || setupCode.isNotEmpty) &&
          !record.administrative &&
          record.rootSeed.isNotEmpty) {
        record = DeviceRecord(
          origin: record.origin,
          endpoint: record.endpoint,
          endpoints: record.endpoints,
          endpointRevision: record.endpointRevision,
          endpointDigest: record.endpointDigest,
          serverId: record.serverId,
          serverKey: record.serverKey,
          tlsFingerprint: record.tlsFingerprint,
          rootSeed: record.rootSeed,
          deviceSeed: record.deviceSeed,
          rootPublicKey: record.rootPublicKey,
          rootHistory: record.rootHistory,
          mlsChannels: record.mlsChannels,
          mlsIdentity: record.mlsIdentity,
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
        tlsFingerprint: server.tlsFingerprint,
        rootSeed: await root.extractPrivateKeyBytes(),
        deviceSeed: await device.extractPrivateKeyBytes(),
        administrative: automatic || setupCode.isNotEmpty,
      );
      await vault.save(record);
    }
    rememberServerRoute(record, server);
    await vault.save(record);
    return record;
  }

  @override
  Future<void> login() =>
      _loginTask ??= _login().whenComplete(() => _loginTask = null);
  Future<void> _refreshNetworkRoute() => _networkRouteTask ??=
      _readNetworkRoute().whenComplete(() => _networkRouteTask = null);

  Future<void> _pollNetworkRoute() async {
    final now = DateTime.now();
    if (_networkRouteChecked != null &&
        now.difference(_networkRouteChecked!) < const Duration(seconds: 45)) {
      return;
    }
    _networkRouteChecked = now;
    try {
      await _refreshNetworkRoute();
    } on SocketException {
      /* Сохраняем рабочее подключение до следующей проверки. */
    } on TimeoutException {
      /* Сохраняем рабочее подключение до следующей проверки. */
    }
  }

  Future<void> _readNetworkRoute() async {
    if (record.endpointRevision > 0 && server.connectOrigin.scheme == 'https') {
      final next = await discoverConnection(
        parseConnectionInput(record.connectionAddress),
        record: record,
      );
      checkTrust(next, record);
      rememberServerRoute(record, next);
      await vault.save(record);
      if (next.endpoint != server.endpoint ||
          next.dialHost != server.dialHost) {
        channel.replaceRoute(
          next.connectOrigin,
          next.tlsFingerprint,
          dialHost: next.dialHost,
        );
      }
      server = next;
    }
  }

  Future<void> _login() async {
    final result = await _authorize('auth.login');
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (!RegExp(r'^st_[A-Za-z0-9_-]{43}$').hasMatch(result.accessToken) ||
        result.expiresAt.toInt() <= now ||
        result.expiresAt.toInt() > now + 605) {
      throw const LocalFailure(
        LocalFailureCode.protocolInvalid,
        'Сервер не выдал сессию',
      );
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
    var credentials = authority ?? record;
    final algorithm = Ed25519();
    final root = credentials.rootSeed.isEmpty
        ? null
        : await algorithm.newKeyPairFromSeed(credentials.rootSeed);
    final device = await algorithm.newKeyPairFromSeed(credentials.deviceSeed);
    var rootPublic = root == null
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
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        "Откройте карточку для управления устройствами",
      );
    }
    final delegated =
        purpose == 'device.delegate' || purpose == 'recovery.device.revoke';
    final grantId = target?.id ?? credentials.grantId;
    final request = _authorizationRequest(
      purpose,
      credentials,
      rootPublic,
      devicePublic,
      grantId,
      pairing,
      delegated,
    );
    final auth = AuthServiceClient(channel);
    final options = RpcOptions(timeout: const Duration(seconds: 10));
    final challenge = await auth.createChallenge(request, options: options);
    credentials = await _adoptLoginCredentials(purpose, credentials, challenge);
    rootPublic = (await credentials.identity()).publicKey;
    final checkedIdentity = await credentials.identity();
    final signing = await checkedSigningBytes(
      challenge,
      server,
      rootPublic,
      devicePublic,
      purpose,
      grantId,
      expectedScopes: _authorizationScopes(credentials, target, pairing),
      authorizerGrantId: delegated ? credentials.recoveryGrantId : '',
      pairingId: pairing?.id ?? '',
      expectedPrincipal: checkedIdentity.principalId,
      expectedEpoch: checkedIdentity.epoch,
    );
    final key = await _authorizationKey(
      purpose,
      delegated,
      device,
      root,
      credentials,
      algorithm,
    );
    final signature = await algorithm.sign(signing, keyPair: key);
    final result = await auth.completeChallenge(
      CompleteChallengeRequest(
        challengeId: challenge.challengeId,
        signature: signature.bytes,
        invitationToken: invitationToken,
      ),
      options: options,
    );
    _validateAuthorizationResult(
      result,
      checkedIdentity.principalId,
      purpose,
      grantId,
    );
    return result;
  }

  Future<DeviceRecord> _adoptLoginCredentials(
    String purpose,
    DeviceRecord credentials,
    CreateChallengeResponse challenge,
  ) async {
    if (purpose != 'auth.login') return credentials;
    final updated = await adoptRetainedRoot(credentials, challenge);
    if (identical(updated, credentials)) return credentials;
    await vault.save(updated);
    record = updated;
    return updated;
  }

  Future<KeyPair> _authorizationKey(
    String purpose,
    bool delegated,
    KeyPair device,
    KeyPair? root,
    DeviceRecord credentials,
    Ed25519 algorithm,
  ) async => purpose == 'auth.login'
      ? device
      : delegated
      ? await algorithm.newKeyPairFromSeed(credentials.recoverySeed)
      : root!;

  List<String> _authorizationScopes(
    DeviceRecord credentials,
    DeviceGrant? target,
    Pairing? pairing,
  ) =>
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
      ];

  void _validateAuthorizationResult(
    CompleteChallengeResponse result,
    String principal,
    String purpose,
    String grantId,
  ) {
    if (result.principalId != principal ||
        !RegExp(r'^dg_[A-Za-z0-9_-]{43}$').hasMatch(result.grantId) ||
        (purpose != 'device.register' &&
            purpose != 'device.delegate' &&
            result.grantId != grantId)) {
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Ответ входа не соответствует ключам',
      );
    }
  }

  CreateChallengeRequest _authorizationRequest(
    String purpose,
    DeviceRecord credentials,
    List<int> rootPublic,
    List<int> devicePublic,
    String grantId,
    Pairing? pairing,
    bool delegated,
  ) {
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
    return request;
  }

  @override
  Future<MessageSearchPage> searchMessages(
    String id,
    String query,
    String cursor,
  ) async {
    final term = checkedSearchQuery(query);
    final before = cursor.isEmpty ? 0 : int.parse(cursor);
    if (before < 0) throw ArgumentError('Некорректный курсор');
    await _ensureSession();
    final principal = principalId;
    _requireOrdinaryRead(id);
    final response = await ContentServiceClient(channel).searchContent(
      SearchContentRequest(
        channelId: id,
        query: term,
        beforeSequence: Int64(before),
      ),
      options: _options,
    );
    if (principalId != principal) throw StateError('Личность изменилась');
    _requireOrdinaryRead(id);
    return checkedSearchPage(response, id, term, before);
  }

  void _requireOrdinaryRead(String id) {
    final target = availableChannels.where((c) => c.id == id).firstOrNull;
    if (target == null ||
        !target.permissions.visible ||
        !target.permissions.read ||
        target.mlsGroupId.isNotEmpty) {
      throw const GrpcError.permissionDenied('Канал недоступен для чтения');
    }
  }

  @override
  Future<HistoryPage> historyPage(String id, {int before = 0}) async {
    if (before < 0) throw ArgumentError('Некорректная граница истории');
    await _ensureSession();
    final principal = principalId;
    _requireOrdinaryRead(id);
    final response = await ContentServiceClient(channel).getHistoryPage(
      GetHistoryPageRequest(channelId: id, beforeSequence: Int64(before)),
      options: _options,
    );
    if (principalId != principal) throw StateError('Личность изменилась');
    _requireOrdinaryRead(id);
    return checkedHistoryPage(response, id, before);
  }

  @override
  Future<List<Content>> messages() async {
    if (!canRead || selectedChannel?.mlsGroupId.isNotEmpty == true) return [];
    return (await historyPage(selectedChannelId)).messages;
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

  @override
  Future<Content> sendReplyQueued(
    String channelId,
    String text,
    String key,
    List<String> attachments,
    String replyTo,
  ) async {
    if (!repliesSupported || replyTo.isEmpty) {
      throw const GrpcError.failedPrecondition('Сервер не поддерживает ответы');
    }
    final target = availableChannels
        .where((c) => c.id == channelId)
        .firstOrNull;
    if (target == null ||
        !target.permissions.read ||
        !target.permissions.write ||
        target.archived ||
        target.mlsGroupId.isNotEmpty) {
      throw const GrpcError.permissionDenied('Ответ в канал недоступен');
    }
    await _ensureSession();
    return (await ContentServiceClient(channel).createContent(
      CreateContentRequest(
        channelId: channelId,
        text: text,
        idempotencyKey: key,
        attachmentIds: attachments,
        replyToId: replyTo,
      ),
      options: _options,
    )).content;
  }

  @override
  Future<Content> sendQueued(
    String channelId,
    String text,
    String key,
    List<String> attachments,
  ) async {
    final target = availableChannels
        .where((entry) => entry.id == channelId)
        .firstOrNull;
    if (target == null ||
        !target.permissions.write ||
        target.archived ||
        target.mlsGroupId.isNotEmpty) {
      throw const GrpcError.permissionDenied('Отправка в канал недоступна');
    }
    return sendAttachments(channelId, text, key, attachments);
  }

  @override
  Future<String> getNickname() async {
    await _ensureSession();
    final result = await MembershipServiceClient(channel)
        .getMembership(GetMembershipRequest(), options: _options);
    return result.member.nickname;
  }

  @override
  Future<void> setNickname(String nickname) async {
    await _ensureSession();
    await MembershipServiceClient(channel).updateProfile(
      UpdateProfileRequest(nickname: nickname),
      options: _options,
    );
  }

  @override
  Future<BeginUploadResponse> beginUpload(BeginUploadRequest request) async {
    await _ensureSession();
    return AssetServiceClient(channel).beginUpload(request, options: _options);
  }

  @override
  Future<UploadChunkResponse> uploadChunk(UploadChunkRequest request) async {
    await _ensureSession();
    return AssetServiceClient(channel).uploadChunk(request, options: _options);
  }

  @override
  Future<CompleteUploadResponse> completeUpload(
    CompleteUploadRequest request,
  ) async {
    await _ensureSession();
    return AssetServiceClient(channel)
        .completeUpload(request, options: _options);
  }

  @override
  Future<CancelUploadResponse> cancelUpload(CancelUploadRequest request) async {
    await _ensureSession();
    return AssetServiceClient(channel).cancelUpload(request, options: _options);
  }

  @override
  Future<DownloadChunkResponse> downloadChunk(
    DownloadChunkRequest request,
  ) async {
    await _ensureSession();
    return AssetServiceClient(channel)
        .downloadChunk(request, options: _options);
  }

  @override
  Future<ListChannelAssetsResponse> listChannelAssets(
    ListChannelAssetsRequest request,
  ) async {
    await _ensureSession();
    return AssetServiceClient(channel)
        .listChannelAssets(request, options: _options);
  }

  @override
  Future<ListMyAssetsResponse> listMyAssets(ListMyAssetsRequest request) async {
    await _ensureSession();
    return AssetServiceClient(channel).listMyAssets(request, options: _options);
  }

  @override
  Future<Content> sendAttachments(
    String channelId,
    String text,
    String key,
    List<String> ids,
  ) async {
    await _ensureSession();
    final result = await ContentServiceClient(channel).createContent(
      CreateContentRequest(
        channelId: channelId,
        text: text,
        idempotencyKey: key,
        attachmentIds: ids,
      ),
      options: _options,
    );
    return result.content;
  }

  @override
  Future<Content> setReaction(
    Content message,
    String emoji,
    bool active,
  ) async {
    await _ensureSession();
    return (await ContentServiceClient(channel).setReaction(
      SetReactionRequest(
        channelId: message.channelId,
        id: message.id,
        emoji: emoji,
        active: active,
        expectedRevision: message.revision,
      ),
      options: _options,
    )).content;
  }

  @override
  Future<MutationReceipt> mutateQueued(
    String channelId,
    String key,
    String text,
    QueuedMutation mutation,
  ) async {
    await _ensureSession();
    return _mutateQueued(channelId, key, text, mutation);
  }

  @override
  Future<Content> updateMessage(Content message, String text) async {
    await _ensureSession();
    final result = await ContentServiceClient(channel).updateContent(
      UpdateContentRequest(
        channelId: message.channelId,
        id: message.id,
        text: text,
        expectedRevision: message.revision,
      ),
      options: _options,
    );
    return result.content;
  }

  @override
  Future<Content> deleteMessage(Content message) async {
    await _ensureSession();
    final result = await ContentServiceClient(channel).deleteContent(
      DeleteContentRequest(
        channelId: message.channelId,
        id: message.id,
        expectedRevision: message.revision,
      ),
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
      options: RpcOptions(
        timeout: const Duration(minutes: 11),
        metadata: {'authorization': 'Bearer $_token'},
        onUnauthenticated: () {
          _expiresAt = 0;
        },
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
          await _pollNetworkRoute();
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
      throw const LocalFailure(
        LocalFailureCode.permissionDenied,
        'Неизвестная роль',
      );
    }
  }

  static Future<PreviewInviteResponse> previewInvitation(
    Discovery server,
    String token,
  ) async {
    final channel = server.openConnection();
    try {
      final result = await MembershipServiceClient(channel).previewInvite(
        PreviewInviteRequest(token: token),
        options: RpcOptions(timeout: const Duration(seconds: 10)),
      );
      if (result.serverId != server.serverId ||
          !['reader', 'member'].contains(result.role)) {
        throw const LocalFailure(
          LocalFailureCode.protocolInvalid,
          'Приглашение не соответствует серверу',
        );
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
  Future<void> close() async {
    if (!_closing.isClosed) {
      _closing.add(null);
      unawaited(_closing.close());
    }
    try {
      await channel.terminate().timeout(const Duration(seconds: 5));
    } catch (_) {
      /* Транспорт уже завершается; закрытие не блокирует повторное подключение. */
    }
  }

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
    // Scope разрешает устройству использовать уже выданные ACL, а не выдаёт роль.
    // Регистрация по-прежнему требует подписи корневым ключом этой личности.
    final grants = await listDevices();
    final current = grants.where((g) => g.id == record.grantId).firstOrNull;
    if (current == null || current.revoked) {
      throw const LocalFailure(
        LocalFailureCode.protocolInvalid,
        'Текущее разрешение недействительно',
      );
    }
    if (current.scopes.contains('space.manage')) return;
    final credentials = authority ?? record;
    checkTrust(server, credentials);
    if ((await credentials.identity()).principalId != principalId) {
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Карточка относится к другой идентичности',
      );
    }
    if (credentials.rootSeed.isEmpty) {
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Для выдачи разрешения нужна корневая карточка. Recovery-карточка не расширяет свои права',
      );
    }
    final signer = DeviceRecord(
      origin: record.origin,
      endpoint: record.endpoint,
      endpoints: record.endpoints,
      endpointRevision: record.endpointRevision,
      endpointDigest: record.endpointDigest,
      tlsFingerprint: record.tlsFingerprint,
      serverId: record.serverId,
      serverKey: record.serverKey,
      rootSeed: credentials.rootSeed,
      deviceSeed: record.deviceSeed,
      rootHistory: credentials.rootHistory,
      mlsChannels: credentials.mlsChannels,
      mlsIdentity: credentials.mlsIdentity,
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
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Не удалось проверить сохранение разрешения. Повторите подключение',
      );
    }
    record = next;
    _expiresAt = 0;
    await login();
    await _authorize('device.revoke', target: current, authority: credentials);
  }

  @override
  Future<List<DeviceGrant>> previewRotationDevices() async {
    await _ensureSession();
    return verifiedRetainedDevices(
      server,
      record,
      AuthServiceClient(channel),
      _options,
    );
  }

  @override
  Future<void> prepareRotation({
    bool renew = false,
    List<DeviceGrant>? retainedDevices,
  }) async {
    await _ensureSession();
    if (vault is! RotationJournalVault) {
      throw const LocalFailure(
        LocalFailureCode.protocolInvalid,
        'Нет защищённого журнала ротации',
      );
    }
    await rotation.prepareRootRotation(
      server,
      record,
      vault as RotationJournalVault,
      AuthServiceClient(channel),
      _options,
      renew: renew,
      retainedDevices: retainedDevices,
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
        throw const LocalFailure(
          LocalFailureCode.identityInvalid,
          'Карточка относится к другой идентичности',
        );
      }
    }
    await _authorize('device.revoke', target: grant, authority: authority);
    if (record.mlsIdentity != null) {
      try {
        await (await mlsClient()).maintainChannels(force: true);
      } catch (_) {
        throw StateError(
          'Устройство отозвано. Исключение из закрытых каналов '
          'ожидает подключения управляющего устройства и доставки Commit.',
        );
      }
    }
  }

  @override
  Future<Map<String, dynamic>> recoveryPayload() async {
    if (!hasRootAuthority && record.recoverySeed.isEmpty) {
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
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
      'endpoint': record.connectionAddress,
      'endpoints': record.endpoints.map((e) => e.toJson()).toList(),
      'endpoint_revision': record.endpointRevision,
      'endpoint_digest': record.endpointDigest,
      'server_id': record.serverId,
      'server_key': record.serverKey,
      if (record.tlsFingerprint.isNotEmpty)
        'tls_fingerprint': record.tlsFingerprint,
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
        throw const LocalFailure(
          LocalFailureCode.identityInvalid,
          'Ключ восстановления недействителен',
        );
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
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
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
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
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
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Нужен root или recovery-карточка',
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
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'Карточка относится к другой идентичности',
      );
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
    throw const LocalFailure(
      LocalFailureCode.protocolInvalid,
      'Неподдерживаемая карточка',
    );
  }
  final origin = localOrigin(payload['origin'] as String).toString();
  final endpoint = localOrigin(payload['endpoint'] as String? ?? origin)
      .toString();
  final rootPublic = base64Url.decode(
    base64Url.normalize(payload['root_public_key'] as String),
  );
  final secret = base64Url.decode(
    base64Url.normalize(payload['secret'] as String),
  );
  final serverKey = payload['server_key'] as String,
      serverId = payload['server_id'] as String;
  final tlsFingerprint = payload['tls_fingerprint'] as String? ?? '';
  _validateRecoveryKeys(
    rootPublic,
    secret,
    serverId,
    serverKey,
    tlsFingerprint,
  );
  final pair = await Ed25519().newKeyPairFromSeed(secret);
  final actual = url64((await pair.extractPublicKey()).bytes);
  final isRoot = payload['credential'] == 'root';
  if (actual !=
      (isRoot ? url64(rootPublic) : payload['credential_public_key'])) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Ключ карточки не соответствует публичному ключу',
    );
  }
  _validateRecoveryGrant(payload, isRoot);
  final device = await Ed25519().newKeyPair();
  final history = _recoveryHistory(payload);
  final record = DeviceRecord(
    origin: origin,
    endpoint: endpoint,
    endpoints: (payload['endpoints'] as List? ?? []).isEmpty
        ? const []
        : parseEndpoints(payload['endpoints']),
    endpointRevision: payload['endpoint_revision'] as int? ?? 0,
    endpointDigest: payload['endpoint_digest'] as String? ?? '',
    serverId: serverId,
    serverKey: serverKey,
    tlsFingerprint: tlsFingerprint,
    rootSeed: isRoot ? secret : [],
    deviceSeed: await device.extractPrivateKeyBytes(),
    rootPublicKey: rootPublic,
    recoverySeed: isRoot ? [] : secret,
    recoveryGrantId: isRoot ? '' : payload['recovery_grant_id'] as String,
    administrative: !isRoot,
    rootHistory: history,
  );
  await record.identity();
  return DeviceRecord.fromJson(record.toJson());
}

List<Map<String, dynamic>> _recoveryHistory(Map<String, dynamic> payload) {
  final history = (payload['root_history'] as List? ?? [])
      .map((value) => Map<String, dynamic>.from(value as Map))
      .toList();
  if (payload['v'] == 1 && history.isNotEmpty ||
      payload['v'] == 2 && history.isEmpty) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Версия карточки не соответствует истории ключей',
    );
  }
  return history;
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
      _validChallengeGrant(
        purpose,
        transcript['grant_id'],
        grantId,
        grantExpiry,
        issued,
        registrationDays,
      );
  if (!valid) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
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
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Неизвестное назначение подписи',
    );
  }
  return utf8.encode('$prefix\u0000$canonical');
}

bool _validChallengeGrant(
  String purpose,
  dynamic actualGrant,
  String grantId,
  int expiry,
  int issued,
  int registrationDays,
) {
  switch (purpose) {
    case 'device.register':
      return expiry == issued + registrationDays * 86400;
    case 'device.delegate':
      return expiry <= issued + 30 * 86400;
    default:
      return actualGrant == grantId;
  }
}

void _validateRecoveryKeys(
  List<int> rootPublic,
  List<int> secret,
  String serverId,
  String serverKey,
  String tlsFingerprint,
) {
  if (rootPublic.length != 32 ||
      secret.length != 32 ||
      !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(serverId) ||
      !RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(serverKey) ||
      (tlsFingerprint.isNotEmpty &&
          !RegExp(r'^[0-9a-f]{64}$').hasMatch(tlsFingerprint))) {
    throw const LocalFailure(
      LocalFailureCode.identityInvalid,
      'Повреждены сведения о сервере или ключах',
    );
  }
}

void _validateRecoveryGrant(Map<String, dynamic> payload, bool isRoot) {
  if (!isRoot &&
      (payload['expires_at'] is! int ||
          (payload['expires_at'] as int) <=
              DateTime.now().millisecondsSinceEpoch ~/ 1000 ||
          !RegExp(r'^dg_[A-Za-z0-9_-]{43}$')
              .hasMatch(payload['recovery_grant_id'] as String))) {
    throw const LocalFailure(
      LocalFailureCode.protocolInvalid,
      'Разрешение восстановления недействительно',
    );
  }
}
