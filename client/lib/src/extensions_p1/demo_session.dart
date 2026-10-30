import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'document.dart';

// Экспериментальный транспорт. Рабочие сессии и навигация его не используют.
class ExtensionDemoConnection {
  ExtensionDemoConnection(this.endpoint, this.token) {
    if (endpoint.scheme != 'http' ||
        endpoint.host != '127.0.0.1' ||
        endpoint.path != '/dispatch' ||
        endpoint.hasQuery ||
        endpoint.hasFragment ||
        endpoint.userInfo.isNotEmpty) {
      throw ArgumentError('Требуется loopback-стенд P1');
    }
  }
  final Uri endpoint;
  final String token;

  Future<ExtensionDocument> fetch(String kind, String name) async {
    final client = http.Client();
    try {
      final bytes = await _exchange(
        client,
        kind,
        name,
      ).timeout(const Duration(seconds: 5));
      return ExtensionDocument.parse(bytes, {'acknowledge'});
    } finally {
      client.close();
    }
  }

  Future<List<int>> _exchange(
    http.Client client,
    String kind,
    String name,
  ) async {
    final request = http.Request('POST', endpoint)
      ..followRedirects = false
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({
        'protocol': 'space.dispatch.p1',
        'instance': 'demo',
        'kind': kind,
        'name': name,
        'payload': <String, Object?>{},
      });
    final response = await client.send(request);
    if (response.statusCode != 200 ||
        response.headers['content-type'] != 'application/json') {
      throw const FormatException('Расширение недоступно');
    }
    final bytes = <int>[];
    await for (final chunk in response.stream) {
      if (bytes.length + chunk.length > 16384) {
        throw const FormatException('Размер ответа расширения');
      }
      bytes.addAll(chunk);
    }
    return bytes;
  }
}

sealed class ExtensionDemoState {
  const ExtensionDemoState();
}

class ExtensionDemoLoading extends ExtensionDemoState {
  const ExtensionDemoLoading();
}

class ExtensionDemoLoaded extends ExtensionDemoState {
  const ExtensionDemoLoaded(this.document);
  final ExtensionDocument document;
}

class ExtensionDemoUnavailable extends ExtensionDemoState {
  const ExtensionDemoUnavailable();
}

class ExtensionDemoSession extends Cubit<ExtensionDemoState> {
  ExtensionDemoSession(this.connection) : super(const ExtensionDemoLoading());
  final ExtensionDemoConnection connection;
  bool _running = false;

  Future<void> load() => _request('query', 'overview');
  Future<void> acknowledge() => _request('command', 'acknowledge');

  Future<void> _request(String kind, String name) async {
    if (isClosed || _running) return;
    _running = true;
    try {
      final document = await connection.fetch(kind, name);
      if (!isClosed) emit(ExtensionDemoLoaded(document));
    } catch (_) {
      if (!isClosed) emit(const ExtensionDemoUnavailable());
    } finally {
      _running = false;
    }
  }
}
