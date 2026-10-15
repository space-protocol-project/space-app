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

connect.HttpClient rpcHttpClient(HttpClient client) {
  final budget = RpcSubscriptionBudget();
  return (input) => sendRpcRequest(client, input, budget: budget);
}

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
  connect.HttpRequest input, {
  RpcSubscriptionBudget? budget,
}) async {
  final streaming =
      input.header
          .get('content-type')
          ?.any((value) => value.startsWith('application/connect+')) ??
      false;
  if (streaming) budget?.start();
  final request = await openRpcRequest(client, input);
  request.followRedirects = false;
  request.headers.removeAll(HttpHeaders.acceptEncodingHeader);
  copyRequestHeaders(request, input.header);
  if (input.body != null) await request.addStream(input.body!);
  final response = await withSignal(request.close(), input.signal);
  return connect.HttpResponse(
    response.statusCode,
    responseHeaders(response),
    responseBytes(response, input.signal, framed: streaming, budget: budget),
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
  connect.AbortSignal? signal, {
  bool framed = false,
  RpcSubscriptionBudget? budget,
}) async* {
  final iterator = StreamIterator(response);
  final limit = RpcBodyLimit(framed: framed);
  try {
    while (await withSignal(iterator.moveNext(), signal)) {
      limit.add(iterator.current);
      if (framed) budget?.add(iterator.current.length);
      yield Uint8List.fromList(iterator.current);
    }
  } finally {
    await iterator.cancel();
  }
}

// Ограничиваем unary целиком, а поток — по кадрам, до накопления тела декодером.
class RpcBodyLimit {
  RpcBodyLimit({
    required this.framed,
    this.streamBytes = 64 * 1024 * 1024,
    this.streamFrames = 4096,
  });
  final bool framed;
  final int streamBytes, streamFrames;
  static const maxBytes = 8 * 1024 * 1024;
  final _header = Uint8List(5);
  int _headerLength = 0;
  int _remaining = 0;
  int _received = 0;
  int _framesReceived = 0;

  void add(List<int> bytes) {
    if (framed) {
      _received += bytes.length;
      if (_received > streamBytes) _exhausted();
      _frames(bytes);
    } else {
      _received += bytes.length;
      _check(_received);
    }
  }

  void _frames(List<int> bytes) {
    var offset = 0;
    while (offset < bytes.length) {
      if (_remaining > 0) {
        final count = _remaining.clamp(0, bytes.length - offset);
        offset += count;
        _remaining -= count;
        continue;
      }
      final count = (5 - _headerLength).clamp(0, bytes.length - offset);
      _header.setRange(_headerLength, _headerLength + count, bytes, offset);
      _headerLength += count;
      offset += count;
      if (_headerLength == 5) {
        if (++_framesReceived > streamFrames) _exhausted();
        _remaining = ByteData.sublistView(_header).getUint32(1);
        _check(_remaining);
        _headerLength = 0;
      }
    }
  }

  void _check(int size) {
    if (size > maxBytes) {
      throw connect.ConnectException(
        connect.Code.resourceExhausted,
        'Ответ RPC слишком большой',
      );
    }
  }
}

Never _exhausted() => throw connect.ConnectException(
  connect.Code.resourceExhausted,
  'Исчерпан бюджет подписки. Повторите позже.',
);

// Общий бюджет соединения переживает автоматические переподключения подписки.
class RpcSubscriptionBudget {
  RpcSubscriptionBudget({
    this.maxBytes = 256 * 1024 * 1024,
    this.maxStarts = 60,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;
  final int maxBytes, maxStarts;
  final DateTime Function() now;
  DateTime? _window;
  int _bytes = 0, _starts = 0;
  void _reset() {
    final current = now();
    if (_window == null ||
        current.difference(_window!) >= const Duration(minutes: 15)) {
      _window = current;
      _bytes = 0;
      _starts = 0;
    }
  }

  void start() {
    _reset();
    if (++_starts > maxStarts) _exhausted();
  }

  void add(int bytes) {
    _reset();
    _bytes += bytes;
    if (_bytes > maxBytes) _exhausted();
  }
}
