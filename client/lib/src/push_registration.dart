part of 'core.dart';

extension PushRegistration on SpaceSession {
  Future<Map<String, Object>> registerAndroidPush(
    Map<String, String> identity,
  ) async {
    await _ensureSession();
    if (server.connectOrigin.scheme != 'https' ||
        server.tlsFingerprint.isEmpty) {
      throw StateError('Уведомления требуют защищённого подключения');
    }
    final client = pinnedRpcClient(
      server.connectOrigin,
      server.tlsFingerprint,
      dialHost: server.dialHost,
    );
    try {
      final request = await client.postUrl(
        server.connectOrigin.resolve('/api/push/register'),
      );
      request.followRedirects = false;
      request.headers.set('Authorization', 'Bearer $_token');
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(identity));
      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != 200) {
        throw StateError('Регистрация уведомлений недоступна');
      }
      final raw = await response.fold<List<int>>([], (buffer, chunk) {
        if (buffer.length + chunk.length > 2048) {
          throw StateError('Ответ слишком велик');
        }
        return buffer..addAll(chunk);
      });
      final token = (jsonDecode(utf8.decode(raw)) as Map)['token'];
      if (token is! String ||
          !RegExp(r'^st_[A-Za-z0-9_-]{43}$').hasMatch(token)) {
        throw StateError('Некорректный ключ уведомлений');
      }
      return {
        ...identity,
        'token': token,
        'origin': server.origin.toString(),
        'principal': principalId,
        'endpoint': server.connectOrigin.toString().replaceFirst(
          RegExp(r'/$'),
          '',
        ),
        'fingerprint': server.tlsFingerprint,
      };
    } finally {
      client.close(force: true);
    }
  }
}
