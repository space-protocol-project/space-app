import 'dart:convert';
import 'dart:io';

import 'server_endpoints.dart';

class HomeNetwork {
  HomeNetwork(
    List<ServerEndpoint> endpoints, {
    this.listenHost = '::',
    this.listenPort = 8443,
    this.revision = 1,
    this.autoPortMapping = false,
    this.autoPublicIP = false,
    this.previousAutomatic,
    String? identityOrigin,
  }) : endpoints = List.unmodifiable(endpoints),
       identityOrigin = identityOrigin ?? endpoints.first.origin.toString() {
    parseEndpoints(endpoints.map((e) => e.toJson()).toList());
    if ((autoPortMapping || autoPublicIP || previousAutomatic != null) &&
        endpoints.length > 7) {
      throw const FormatException(
        'Для автоматического адреса допускается до 7 адресов',
      );
    }
    if (autoPublicIP &&
        InternetAddress.tryParse(endpoints.first.host)?.type !=
            InternetAddressType.IPv4) {
      throw const FormatException(
        'Автообновление IP требует IPv4 в первом адресе',
      );
    }
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
  final bool autoPortMapping, autoPublicIP;
  final ServerEndpoint? previousAutomatic;
  List<ServerEndpoint> get advertisedEndpoints => [
    ...endpoints,
    if (previousAutomatic != null &&
        !endpoints.any((e) => e.origin == previousAutomatic!.origin))
      ServerEndpoint.parse(
        previousAutomatic!.host,
        previousAutomatic!.port,
        priority: 255,
      ),
  ];

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
      autoPortMapping: data['auto_port_mapping'] as bool? ?? false,
      autoPublicIP: data['auto_public_ip'] as bool? ?? false,
      previousAutomatic: data['previous_automatic'] == null
          ? null
          : parseEndpoints([data['previous_automatic']]).single,
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
    'auto_port_mapping': autoPortMapping,
    'auto_public_ip': autoPublicIP,
    if (previousAutomatic != null)
      'previous_automatic': previousAutomatic!.toJson(),
  };

  HomeNetwork changed(
    List<ServerEndpoint> next,
    String host,
    int port, {
    bool? autoPortMapping,
    bool? autoPublicIP,
  }) {
    final changed =
        jsonEncode(next.map((e) => e.row).toList()) !=
        jsonEncode(endpoints.map((e) => e.row).toList());
    return HomeNetwork(
      next,
      listenHost: host,
      listenPort: port,
      revision: revision + (changed ? 1 : 0),
      identityOrigin: identityOrigin,
      autoPortMapping: autoPortMapping ?? this.autoPortMapping,
      autoPublicIP: autoPublicIP ?? this.autoPublicIP,
      previousAutomatic: previousAutomatic,
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
