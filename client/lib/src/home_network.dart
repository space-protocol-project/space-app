import 'dart:convert';
import 'dart:io';

import 'server_endpoints.dart';

class HomeNetwork {
  HomeNetwork(
    List<ServerEndpoint> endpoints, {
    this.listenHost = '::',
    this.listenPort = 8443,
    this.revision = 1,
    String? identityOrigin,
  }) : endpoints = List.unmodifiable(endpoints),
       identityOrigin = identityOrigin ?? endpoints.first.origin.toString() {
    parseEndpoints(endpoints.map((e) => e.toJson()).toList());
    if (InternetAddress.tryParse(listenHost) == null ||
        listenPort < 1 ||
        listenPort > 65535 ||
        revision < 1 ||
        revision > maxEndpointRevision) {
      throw const FormatException(
        'Некорректный порт прослушивания или версия адресов',
      );
    }
  }
  final List<ServerEndpoint> endpoints;
  final String listenHost, identityOrigin;
  final int listenPort, revision;

  factory HomeNetwork.fromJson(Map<String, dynamic> data) {
    final endpoints = data['endpoints'] == null
        ? [
            ServerEndpoint.parse(
              data['ip'] as String,
              data['port'] as int? ?? 8443,
            ),
          ]
        : parseEndpoints(data['endpoints']);
    return HomeNetwork(
      endpoints,
      listenHost: data['listen_host'] as String? ?? '0.0.0.0',
      listenPort: data['listen_port'] as int? ?? data['port'] as int? ?? 8443,
      revision: data['endpoint_revision'] as int? ?? 1,
      identityOrigin: data['identity_origin'] as String?,
    );
  }
  Map<String, Object> toJson() => {
    'ip': endpoints.first.host,
    'port': endpoints.first.port,
    'identity_origin': identityOrigin,
    'endpoints': endpoints.map((e) => e.toJson()).toList(),
    'endpoint_revision': revision,
    'listen_host': listenHost,
    'listen_port': listenPort,
  };

  HomeNetwork changed(List<ServerEndpoint> next, String host, int port) {
    final changed =
        jsonEncode(next.map((e) => e.row).toList()) !=
        jsonEncode(endpoints.map((e) => e.row).toList());
    return HomeNetwork(
      next,
      listenHost: host,
      listenPort: port,
      revision: revision + (changed ? 1 : 0),
      identityOrigin: identityOrigin,
    );
  }

  static Future<HomeNetwork?> read(Directory root) async {
    final file = File('${root.path}/config.json');
    if (!await file.exists()) return null;
    if (await file.length() > 16384) {
      throw const FormatException('Слишком большая конфигурация');
    }
    return HomeNetwork.fromJson(
      jsonDecode(await file.readAsString()) as Map<String, dynamic>,
    );
  }

  Future<void> write(Directory root) async {
    final pending = File('${root.path}/config.json.tmp');
    await pending.writeAsString(jsonEncode(toJson()), flush: true);
    await pending.rename('${root.path}/config.json');
  }
}
