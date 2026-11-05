part of 'local_lifecycle_host.dart';

// Выбор ОС может пережить ровно одну блокировку. До COMMIT корень принадлежит
// экрану и недоступен через beginRead/listCatalog/readCatalog.
final class CatalogGrantIntent {
  CatalogGrantIntent._(
    this.host,
    this.original,
    this.instance,
    this.package,
    this.installation,
    this.revision,
  );
  final LocalLifecycleHost host;
  final LocalExtensionSession original;
  final String instance, package, installation;
  final int revision;
  LocalCatalogRoot? _root;
  bool _closed = false;
  String? get path => _root?.displayPath;

  void _live() {
    if (_closed || host._closed || host._failed) throw StateError('Cancelled');
    final current = host._registry.snapshot;
    if (current.revision != revision + 1 || current.action != 'lock') {
      throw StateError('Conflict');
    }
  }

  Future<void> pick() async {
    _live();
    final root = await host._picker!.select(instance, package, _live);
    try {
      _live();
      if (root.displayPath == null || _root != null) {
        throw StateError('Unavailable');
      }
      _root = root;
      host._pendingRoots[root] = instance;
    } catch (_) {
      root.close();
      rethrow;
    }
  }

  void check(LocalExtensionSession session) {
    _live();
    if (identical(session, original) || session.actor != original.actor) {
      throw StateError('PermissionDenied');
    }
    host._require(session, '${original.device}/${original.profile}');
  }

  Future<String> approve(
    LocalExtensionSession session,
    void Function() guardContext,
  ) async {
    void guard() {
      check(session);
      guardContext();
    }

    guard();
    final root = _root!;
    final authority = host._authority;
    final delegate = switch (authority) {
      CatalogConsentProvider provider => provider.catalogConsent(
        instance,
        package,
        root.id,
      ),
      _ => authority,
    };
    final before = host.snapshot(session);
    final entry = before.entries[instance]!;
    final enable = _command(LocalLifecycleAction.enable, entry);
    host._guard(enable, entry, before.generation);
    host._requireIdle(enable);
    // Оба перехода готовятся на частном снимке. Отказ во второй проверке
    // оставляет экземпляр отключённым, включая прежнюю ревизию реестра.
    await host._prepare(
      session,
      enable,
      entry,
      before,
      (_) {},
      active: guard,
      delegate: delegate,
    );
    guard();
    final grant = _command(LocalLifecycleAction.grant, entry);
    host._guard(grant, entry, before.generation);
    await host._prepare(
      session,
      grant,
      entry,
      before,
      (_) {},
      prepared: root,
      active: guard,
      delegate: delegate,
    );
    guard();
    host._requireIdle(grant);
    host._commit(before, 'grant', null);
    host._pendingRoots.remove(root);
    host._cancel(instance);
    host._roots[root.id] = (instance: instance, root: root);
    _root = null;
    close();
    return root.id;
  }

  LocalLifecycleCommand _command(
    LocalLifecycleAction action,
    Map<String, Object?> entry,
  ) {
    if (entry['package'] != package) throw StateError('StaleBinding');
    final record = lifecycleOf(entry);
    return LocalLifecycleCommand(
      action: action,
      instance: instance,
      installation: installation,
      revision: record['revision']! as int,
      generation: record['generation']! as String,
    );
  }

  void close() {
    _closed = true;
    host._pendingRoots.remove(_root);
    _root?.close();
    _root = null;
  }
}

extension CatalogGrantScreenAccess on LocalLifecycleHost {
  List<String> catalogInstances(LocalExtensionSession session) => [
    for (final e in snapshot(session).entries.entries)
      if (_eligible(e.value)) e.key,
  ];
  bool _eligible(Map<String, Object?> entry) {
    if (_picker == null || !entry.containsKey('lifecycle')) return false;
    return const ['enabled', 'disabled'].contains(entry['state']) &&
        (lifecycleOf(entry)['requested']! as List).contains(
          'device.catalog.read',
        );
  }

  CatalogGrantIntent startCatalogChoice(
    LocalExtensionSession session,
    String instance,
  ) {
    final before = snapshot(session);
    final entry = before.entries[instance];
    if (entry == null || !_eligible(entry)) {
      throw StateError('PermissionDenied');
    }
    return CatalogGrantIntent._(
      this,
      session,
      instance,
      entry['package']! as String,
      entry['installation']! as String,
      before.revision,
    );
  }
}
