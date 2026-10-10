import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SpaceApiError implements Exception {
  SpaceApiError(this.status, this.message);
  final int status;
  final String message;
  @override
  String toString() => message;
}

class SpaceGateway {
  SpaceGateway(this.origin, {http.Client? client})
    : _client = client ?? http.Client();
  final Uri origin;
  String get tlsFingerprint => '';
  final http.Client _client;
  Future<Map<String, dynamic>> call(
    String path, {
    String token = '',
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (!path.startsWith('/api/v1/') || path.startsWith('//'))
      throw ArgumentError('Неподдерживаемый маршрут');
    final request = http.Request(
      method ?? (body == null ? 'GET' : 'POST'),
      origin.resolve(path),
    )..followRedirects = false;
    request.headers['Content-Type'] = 'application/json';
    if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
    if (body != null) request.body = jsonEncode(body);
    final response = await _client
        .send(request)
        .timeout(const Duration(seconds: 10));
    final bytes = <int>[];
    await for (final chunk in response.stream.timeout(
      const Duration(seconds: 10),
    )) {
      bytes.addAll(chunk);
      if (bytes.length > 262144)
        throw const FormatException('Слишком большой ответ сервера');
    }
    if (response.statusCode >= 300 && response.statusCode < 400)
      throw SpaceApiError(response.statusCode, 'Перенаправление API отклонено');
    final data = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    if (response.statusCode != 200)
      throw SpaceApiError(
        response.statusCode,
        data['message'] as String? ?? 'Сервер отклонил запрос',
      );
    return data;
  }

  void close() => _client.close();
}
