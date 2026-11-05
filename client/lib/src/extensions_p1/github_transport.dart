import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

abstract interface class GitObjectTransport {
  Future<Map<String, dynamic>> get(String path);
  void close();
}

bool publicGitAddress(InternetAddress address) {
  if (address.type != InternetAddressType.IPv4) return false;
  final b = address.rawAddress;
  if (b[0] == 0 || b[0] == 10 || b[0] == 127 || b[0] >= 224) return false;
  return !_privateAddress(b) && !_specialAddress(b);
}

bool _privateAddress(Uint8List b) => switch (b[0]) {
  100 => b[1] >= 64 && b[1] <= 127,
  169 => b[1] == 254,
  172 => b[1] >= 16 && b[1] <= 31,
  _ => false,
};

bool _specialAddress(Uint8List b) => switch (b[0]) {
  192 => b[1] == 168 || b[1] == 0 || (b[1] == 88 && b[2] == 99),
  198 => b[1] == 18 || b[1] == 19 || (b[1] == 51 && b[2] == 100),
  203 => b[1] == 0 && b[2] == 113,
  _ => false,
};

class GithubTransport implements GitObjectTransport {
  GithubTransport() {
    _client.findProxy = (_) => 'DIRECT';
    _client.autoUncompress = false;
    _client.connectionTimeout = const Duration(seconds: 10);
    _client.connectionFactory = _connect;
  }
  final _client = HttpClient();
  final _deadline = DateTime.now().add(const Duration(minutes: 2));
  int _requests = 0, _bytes = 0;
  bool _closed = false;

  Future<ConnectionTask<Socket>> _connect(
    Uri uri,
    String? proxy,
    int? port,
  ) async {
    if (_closed ||
        uri.host != 'api.github.com' ||
        uri.scheme != 'https' ||
        uri.port != 443 ||
        proxy != null) {
      throw StateError('GitDestination');
    }
    final addresses = await InternetAddress.lookup(
      uri.host,
      type: InternetAddressType.IPv4,
    );
    if (_closed || addresses.isEmpty || !addresses.every(publicGitAddress)) {
      throw StateError('GitDestination');
    }
    final task = await Socket.startConnect(addresses.first, uri.port);
    return ConnectionTask.fromSocket(
      task.socket.then((socket) => _secure(socket, uri.host)),
      task.cancel,
    );
  }

  Future<Socket> _secure(Socket socket, String host) async {
    try {
      if (_closed) throw StateError('Cancelled');
      return await SecureSocket.secure(
        socket,
        host: host,
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
      socket.destroy();
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> get(String path) async {
    if (_closed ||
        ++_requests > 24 ||
        DateTime.now().isAfter(_deadline) ||
        !path.startsWith('/repos/')) {
      throw StateError('GitLimit');
    }
    try {
      return await _get(path).timeout(const Duration(seconds: 20));
    } catch (_) {
      close();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final request = await _client.getUrl(
      Uri.parse('https://api.github.com$path'),
    );
    request.followRedirects = false;
    request.headers.set('Accept', 'application/vnd.github+json');
    request.headers.set('Accept-Encoding', 'identity');
    request.headers.set('User-Agent', 'Space-P1-client-installer');
    final response = await request.close();
    if (response.statusCode != 200 ||
        response.headers.value('content-encoding') != null) {
      throw StateError('GitUnavailable');
    }
    final body = BytesBuilder(copy: false);
    await for (final chunk in response) {
      _bytes += chunk.length;
      if (_closed ||
          _bytes > 24 * 1024 * 1024 ||
          body.length + chunk.length > 8 * 1024 * 1024) {
        throw StateError('GitLimit');
      }
      body.add(chunk);
    }
    return jsonDecode(utf8.decode(body.takeBytes())) as Map<String, dynamic>;
  }

  @override
  void close() {
    _closed = true;
    _client.close(force: true);
  }
}
