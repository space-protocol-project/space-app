import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

const maxEndpointRevision = 9007199254740991;

class ServerEndpoint {
  const ServerEndpoint(this.host, this.port, {this.priority = 0});
  final String host;
  final int port, priority;
  Uri get origin => Uri(scheme: 'https', host: host, port: port);
  List<Object> get row => [host, port, 'https', priority];
  Map<String, Object> toJson() => {
    'host': host,
    'port': port,
    'type': 'https',
    'priority': priority,
  };

  factory ServerEndpoint.fromJson(Map<String, dynamic> value) {
    if (value['type'] != 'https') throw const FormatException('Нужен HTTPS');
    return ServerEndpoint.parse(
      value['host'] as String,
      value['port'] as int,
      priority: value['priority'] as int,
    );
  }

  factory ServerEndpoint.parse(String input, int port, {int priority = 0}) {
    final host = input.trim().toLowerCase();
    if (!validEndpointHost(host) ||
        port < 1 ||
        port > 65535 ||
        priority < 0 ||
        priority > 255) {
      throw const FormatException(
        'Нужны IPv4, IPv6 или домен и порт от 1 до 65535',
      );
    }
    return ServerEndpoint(host, port, priority: priority);
  }
}

bool validEndpointHost(String host) {
  if (host.isEmpty || host.length > 253 || RegExp(r'[%\[\]]').hasMatch(host)) {
    return false;
  }
  if (InternetAddress.tryParse(host) != null) return true;
  final label = RegExp(r'^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$');
  return host.split('.').every(label.hasMatch);
}

List<ServerEndpoint> parseEndpoints(Object? value) {
  if (value is! List || value.isEmpty || value.length > 8) {
    throw const FormatException('Нужно от 1 до 8 адресов');
  }
  final endpoints = value
      .map((e) => ServerEndpoint.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
  if (endpoints.map((e) => e.origin.toString()).toSet().length !=
      endpoints.length) {
    throw const FormatException('Адреса не должны повторяться');
  }
  return List.unmodifiable(endpoints);
}

class EndpointAnnouncement {
  EndpointAnnouncement(this.endpoints, this.revision, this.digest);
  final List<ServerEndpoint> endpoints;
  final int revision;
  final String digest;

  static Future<EndpointAnnouncement> verify(
    Map<String, dynamic> data,
    Uri endpoint,
    String fingerprint,
    List<int> serverKey,
  ) async {
    final endpoints = parseEndpoints(data['endpoints']);
    final revision = data['endpoint_revision'];
    if (revision is! int ||
        revision < 1 ||
        revision > maxEndpointRevision ||
        data['tls_fingerprint'] != fingerprint ||
        !endpoints.any((e) => e.origin == endpoint)) {
      throw const FormatException(
        'Объявление адресов не соответствует соединению',
      );
    }
    final payload = utf8.encode(
      'space/endpoints/v1\u0000${jsonEncode([data['server_id'], data['identity_origin'], revision, fingerprint, endpoints.map((e) => e.row).toList()])}',
    );
    final valid = await Ed25519().verify(
      payload,
      signature: Signature(
        base64Url.decode(
          base64Url.normalize(data['endpoint_signature'] as String),
        ),
        publicKey: SimplePublicKey(serverKey, type: KeyPairType.ed25519),
      ),
    );
    if (!valid) throw const FormatException('Недействительная подпись адресов');
    return EndpointAnnouncement(
      endpoints,
      revision,
      sha256.convert(payload).toString(),
    );
  }
}

bool publicEndpointAddress(InternetAddress address) {
  if (address.isLoopback || address.isLinkLocal || address.isMulticast) {
    return false;
  }
  final b = address.rawAddress;
  if (address.type == InternetAddressType.IPv6) {
    // Только глобальный unicast; IPv4-mapped адреса не обходят IPv4-фильтр.
    return (b[0] & 0xe0) == 0x20;
  }
  return !(b[0] == 0 ||
      b[0] == 10 ||
      b[0] == 127 ||
      b[0] >= 224 ||
      (b[0] == 100 && b[1] >= 64 && b[1] <= 127) ||
      (b[0] == 169 && b[1] == 254) ||
      (b[0] == 172 && b[1] >= 16 && b[1] <= 31) ||
      (b[0] == 192 && b[1] == 168) ||
      (b[0] == 198 && (b[1] == 18 || b[1] == 19)));
}
