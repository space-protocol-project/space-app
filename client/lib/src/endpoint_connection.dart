import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'core.dart';

typedef EndpointProbe = Future<Discovery> Function(
  Uri endpoint,
  Future<void> cancelled,
  bool explicit,
);

void rememberServerRoute(DeviceRecord record, Discovery server) {
  checkTrust(server, record);
  record.endpoint = server.endpoint.toString();
  final announcement = server.announcement;
  if (announcement == null) return;
  record.endpoints = announcement.endpoints;
  record.endpointRevision = announcement.revision;
  record.endpointDigest = announcement.digest;
}

Future<Discovery> discoverConnection(
  ConnectionInput input, {
  DeviceRecord? record,
  String? homeOrigin,
  String tlsFingerprint = '',
}) async {
  if (record != null &&
      input.tlsFingerprint.isNotEmpty &&
      record.tlsFingerprint.isNotEmpty &&
      input.tlsFingerprint != record.tlsFingerprint) {
    throw const FormatException(
      'TLS-отпечаток приглашения не совпадает с сохранённым',
    );
  }
  final fingerprint =
      record?.tlsFingerprint ??
      (input.tlsFingerprint.isEmpty ? tlsFingerprint : input.tlsFingerprint);
  if (homeOrigin != null || input.origin.scheme == 'http') {
    final server = await discover(
      input.origin.toString(),
      homeOrigin: homeOrigin,
      tlsFingerprint: fingerprint,
    );
    _requireConnectionIdentity(server, input, record);
    return server;
  }
  final connector = _EndpointConnector(input, record, fingerprint);
  return selectEndpoint(_endpointTargets(input, record), connector.probe);
}

List<Uri> _endpointTargets(ConnectionInput input, DeviceRecord? record) {
  final targets = <Uri>[input.origin];
  final invited = [...input.endpoints]
    ..sort((a, b) => a.priority.compareTo(b.priority));
  final saved = [...?record?.endpoints]
    ..sort((a, b) => a.priority.compareTo(b.priority));
  final alternatives = [...invited, ...saved];
  for (final endpoint in alternatives) {
    if (!targets.contains(endpoint.origin) && targets.length < 8) {
      targets.add(endpoint.origin);
    }
  }
  return targets;
}

class _EndpointConnector {
  _EndpointConnector(this.input, this.record, this.fingerprint);
  final ConnectionInput input;
  final DeviceRecord? record;
  final String fingerprint;

  Future<String?> _dialAddress(Uri endpoint, bool explicit) async {
    if (explicit || endpoint.host == input.origin.host) return null;
    final addresses = await InternetAddress.lookup(endpoint.host)
        .timeout(const Duration(seconds: 3));
    final allowed = addresses.take(8).where(publicEndpointAddress);
    if (allowed.isEmpty) {
      throw const SocketException('Запасной адрес не является публичным');
    }
    return allowed.first.address;
  }

  Future<Discovery> probe(
    Uri endpoint,
    Future<void> cancelled,
    bool explicit,
  ) async {
    final dialAddress = await _dialAddress(endpoint, explicit);
    final server = await discover(
      endpoint.toString(),
      tlsFingerprint: fingerprint,
      cancelled: cancelled,
      dialAddress: dialAddress,
    );
    _requireConnectionIdentity(server, input, record);
    return server;
  }
}

void _requireConnectionIdentity(
  Discovery server,
  ConnectionInput input,
  DeviceRecord? record,
) {
  if (input.serverId.isNotEmpty && server.serverId != input.serverId) {
    throw const FormatException('Другой server ID в приглашении');
  }
  if (record != null) checkTrust(server, record);
}

/// Гонка только discovery. Проигравшие HTTP-соединения закрываются; RPC не повторяются.
Future<Discovery> selectEndpoint(
  List<Uri> targets,
  EndpointProbe probe, {
  Duration stagger = const Duration(milliseconds: 250),
  Duration timeout = const Duration(seconds: 12),
}) async {
  if (targets.isEmpty || targets.length > 8) {
    throw const FormatException('Нужно от 1 до 8 адресов');
  }
  return _EndpointRace(targets, probe).run(stagger, timeout);
}

class _EndpointRace {
  _EndpointRace(this.targets, this.probe);
  final List<Uri> targets;
  final EndpointProbe probe;
  final result = Completer<Discovery>();
  final cancelled = Completer<void>();
  int next = 0;
  int workers = 2;
  bool stopped = false;
  Object lastError = const SocketException('Нет доступных адресов');
  bool get accepting => !stopped && !result.isCompleted;

  Future<Discovery> run(Duration stagger, Duration timeout) async {
    unawaited(_worker(Duration.zero));
    unawaited(_worker(stagger));
    try {
      return await result.future.timeout(timeout);
    } finally {
      stopped = true;
      cancelled.complete();
    }
  }

  Future<void> _worker(Duration delay) async {
    await Future<void>.delayed(delay);
    while (accepting && next < targets.length) {
      final index = next++;
      try {
        final server = await probe(
          targets[index],
          cancelled.future,
          index == 0,
        );
        if (accepting) result.complete(server);
      } catch (error) {
        lastError = error;
      }
    }
    workers--;
    if (workers == 0 && accepting) result.completeError(lastError);
  }
}

String spaceEndpointLink(
  Uri primary,
  String fingerprint,
  String serverId,
  List<ServerEndpoint> endpoints, {
  String invitationToken = '',
}) {
  final fields = <String, String>{
    if (invitationToken.isNotEmpty) 'invite': invitationToken,
    if (fingerprint.isNotEmpty) 'tls': fingerprint,
    if (serverId.isNotEmpty) 'server': serverId,
    if (serverId.isNotEmpty && endpoints.isNotEmpty)
      'addresses': url64(
        utf8.encode(jsonEncode(endpoints.map((e) => e.toJson()).toList())),
      ),
  };
  return primary
      .replace(fragment: Uri(queryParameters: fields).query)
      .toString();
}
