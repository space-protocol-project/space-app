part of 'chat_outbox.dart';

/// Каталог содержит только локальные grant той же личности и сервера.
/// Данные очереди по-прежнему читаются из отдельных защищённых записей.
extension OutboxSources on LocalChatOutbox {
  String _family(OutboxScope scope) =>
      jsonEncode([scope.origin, scope.serverId, scope.principalId]);

  String _familyId(OutboxScope scope) =>
      sha256.convert(utf8.encode(_family(scope))).toString();

  Future<T> _catalogLocked<T>(
    OutboxScope scope,
    Future<T> Function() operation,
  ) async {
    final root = await directory();
    final locks = await Directory('${root.path}/outbox-catalog-locks')
        .create(recursive: true);
    return OutboxLock.run('${locks.path}/${_familyId(scope)}.lock', operation);
  }

  Future<List<String>> _grants(OutboxScope scope) async {
    final saved = await storage.read(
      key: 'space.outbox.sources.v1.${_familyId(scope)}',
    );
    if (saved == null) return [];
    if (utf8.encode(saved).length > 64 * 1024) {
      throw const FormatException('Каталог очередей слишком большой');
    }
    final data = jsonDecode(saved) as Map<String, dynamic>;
    final grants = (data['grants'] as List).cast<String>();
    if (data['v'] != 1 ||
        data['binding'] != _family(scope) ||
        grants.length > 256 ||
        grants.toSet().length != grants.length ||
        grants.any((grant) => grant.isEmpty || grant.length > 128)) {
      throw const FormatException('Недопустимый каталог очередей');
    }
    return grants;
  }

  Future<void> _rememberScope(OutboxScope scope) async {
    if (scope.grantId.isEmpty) return;
    await _catalogLocked(scope, () async {
      final grants = await _grants(scope);
      if (grants.contains(scope.grantId)) return;
      if (grants.length >= 256 || scope.grantId.length > 128) {
        throw const FormatException('Каталог очередей заполнен');
      }
      await storage.write(
        key: 'space.outbox.sources.v1.${_familyId(scope)}',
        value: jsonEncode({
          'v': 1,
          'binding': _family(scope),
          'grants': [...grants, scope.grantId],
        }),
      );
    });
  }

  Future<List<OutboxScope>> previousScopes(OutboxScope current) async {
    final grants = await _catalogLocked(current, () => _grants(current));
    final sources = <OutboxScope>[];
    for (final grant in grants) {
      if (grant == current.grantId) continue;
      final scope = OutboxScope(
        current.origin,
        current.serverId,
        current.principalId,
        grant,
      );
      if ((await read(scope)).isNotEmpty) sources.add(scope);
    }
    return List.unmodifiable(sources);
  }
}
