import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectrpc/connect.dart' as connect;

import 'core.dart' show certificateFingerprint, certificateIsCurrent;

HttpClient pinnedRpcClient(Uri origin, String fingerprint, {String? dialHost}) {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
  client.findProxy = (_) => 'DIRECT';
  client.autoUncompress = false;
  client.connectionFactory = RpcSockets(origin, fingerprint, dialHost).connect;
  return client;
}

class RpcSockets {
  const RpcSockets(this.origin, this.fingerprint, this.dialHost);
  final Uri origin;
  final String fingerprint;
  final String? dialHost;

  bool accepts(Uri uri) =>
      uri.scheme == origin.scheme &&
      uri.host == origin.host &&
      uri.port == origin.port;

  Future<ConnectionTask<Socket>> connect(
    Uri uri,
    String? proxyHost,
    int? proxyPort,
  ) async {
    if (!accepts(uri)) {
      throw const HandshakeException('RPC изменил доверенный адрес');
    }
    if (uri.scheme == 'http') return Socket.startConnect(uri.host, uri.port);
    if (fingerprint.isEmpty) {
      throw const HandshakeException('Нет доверенного TLS-отпечатка');
    }
    final task = await SecureSocket.startConnect(
      dialHost ?? uri.host,
      uri.port,
      onBadCertificate: (certificate) =>
          matchesCertificate(certificate, fingerprint),
    );
    return ConnectionTask.fromSocket(
      checkSocket(task.socket, fingerprint),
      task.cancel,
    );
  }
}

bool matchesCertificate(X509Certificate certificate, String fingerprint) =>
    certificateIsCurrent(certificate) &&
    certificateFingerprint(certificate) == fingerprint;

Future<SecureSocket> checkSocket(
  Future<SecureSocket> pending,
  String fingerprint,
) async {
  final socket = await pending;
  final certificate = socket.peerCertificate;
  if (certificate == null || !matchesCertificate(certificate, fingerprint)) {
    socket.destroy();
    throw const HandshakeException(
      'Сертификат RPC не совпадает с доверенным отпечатком',
    );
  }
  return socket;
}

Future<T> withSignal<T>(Future<T> result, connect.AbortSignal? signal) =>
    signal == null
    ? result
    : Future.any([signal.future.then<T>((error) => throw error), result]);

connect.HttpClient rpcHttpClient(HttpClient client) =>
    (input) => sendRpcRequest(client, input);

Future<HttpClientRequest> openRpcRequest(
  HttpClient client,
  connect.HttpRequest input,
) {
  final pending = client.openUrl(input.method, Uri.parse(input.url));
  input.signal?.future.then((error) {
    pending.then((request) => request.abort(error)).ignore();
  });
  return withSignal(pending, input.signal);
}

Future<connect.HttpResponse> sendRpcRequest(
  HttpClient client,
  connect.HttpRequest input,
) async {
  final request = await openRpcRequest(client, input);
  request.followRedirects = false;
  request.headers.removeAll(HttpHeaders.acceptEncodingHeader);
  copyRequestHeaders(request, input.header);
  if (input.body != null) await request.addStream(input.body!);
  final response = await withSignal(request.close(), input.signal);
  return connect.HttpResponse(
    response.statusCode,
    responseHeaders(response),
    responseBytes(response, input.signal),
    connect.Headers(),
  );
}

void copyRequestHeaders(HttpClientRequest request, connect.Headers headers) {
  for (final header in headers.entries) {
    request.headers.add(header.name, header.value);
  }
}

connect.Headers responseHeaders(HttpClientResponse response) {
  final headers = connect.Headers();
  response.headers.forEach((name, values) {
    for (final value in values) {
      headers.add(name, value);
    }
  });
  return headers;
}

Stream<Uint8List> responseBytes(
  HttpClientResponse response,
  connect.AbortSignal? signal,
) async* {
  final iterator = StreamIterator(response);
  try {
    while (await withSignal(iterator.moveNext(), signal)) {
      yield Uint8List.fromList(iterator.current);
    }
  } finally {
    await iterator.cancel();
  }
}
