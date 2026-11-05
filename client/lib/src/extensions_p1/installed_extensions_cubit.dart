import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart';

import '../app_shutdown.dart';
import '../secure_vault.dart';
import 'bundled_catalog.dart';
import 'catalog_grant_cubit.dart';
import 'desktop_catalog.dart';
import 'installed_packages.dart';
import 'local_lifecycle_host.dart';
import 'local_lifecycle_record.dart';
import 'local_lifecycle_types.dart';
import 'local_session_cubit.dart';
import 'local_sessions.dart';

enum InstalledExtensionsState { idle, loading, ready, unavailable, stopped }

class InstalledExtensionsCubit extends Cubit<InstalledExtensionsState> {
  InstalledExtensionsCubit(
    this.access,
    this.runtime, {
    this.storage = const PlatformKeyStorage(),
    Future<String> Function()? directory,
    Future<DesktopCatalogPicker> Function()? picker,
    this.shutdown,
  }) : directory = directory ?? _directory,
       picker = picker ?? _picker,
       super(InstalledExtensionsState.idle) {
    runtime.prepare = _loader;
    access.sessions.addListener(_locked);
    _subscription = access.stream.listen((state) {
      if (state == LocalSessionStatus.unlocked) _loadCurrent();
    });
    shutdown?.addStopBarrier(stop);
    shutdown?.addDrainBarrier(drain);
    if (access.state == LocalSessionStatus.unlocked) _loadCurrent();
  }

  final LocalSessionCubit access;
  final SpaceCatalogRuntime runtime;
  final SecureKeyStorage storage;
  final Future<String> Function() directory;
  final Future<DesktopCatalogPicker> Function() picker;
  final AppShutdown? shutdown;
  late final _loader = ensure;
  late final StreamSubscription<LocalSessionStatus> _subscription;
  LocalLifecycleHost? _host, _pendingHost;
  DesktopCatalogPicker? _pickerOwner;
  InstalledPackages? _packages;
  String? _scope;
  int _epoch = 0;
  bool _stopping = false, _installing = false;
  Future<void>? _opening;
  Future<void> _draining = Future.value();

  static Future<String> _directory() async => paths.join(
    (await getApplicationSupportDirectory()).path,
    'extensions-p1',
  );
  static Future<DesktopCatalogPicker> _picker() async =>
      (await BundledCatalog.resolve()).picker();
  void _loadCurrent() {
    if (_stopping || access.state != LocalSessionStatus.unlocked) return;
    unawaited(ensure(access.session).catchError((Object _) {}));
  }

  void _guard(LocalExtensionSession session, int epoch) {
    if (_stopping || isClosed || epoch != _epoch) {
      throw StateError('PermissionDenied');
    }
    access.sessions.require(session, '${session.device}/${session.profile}');
  }

  Future<void> ensure(LocalExtensionSession session) async {
    _guard(session, _epoch);
    if (_host != null && _scope == '${session.device}/${session.profile}') {
      return;
    }
    final pending = _opening;
    if (pending != null) {
      await pending;
      return ensure(session);
    }
    final operation = _open(session);
    _opening = operation;
    try {
      await operation;
    } finally {
      if (identical(_opening, operation)) _opening = null;
    }
  }

  Future<void> _open(LocalExtensionSession session) async {
    final epoch = _epoch;
    emit(InstalledExtensionsState.loading);
    _retire();
    LocalLifecycleHost? opened;
    try {
      final base = await directory();
      _guard(session, epoch);
      final selected = await picker();
      _guard(session, epoch);
      final scope = '${session.device}/${session.profile}';
      final root = paths.join(base, session.device, session.profile);
      final packages = InstalledPackages(
        paths.join(root, 'packages'),
        scope,
        storage,
      );
      opened = LocalLifecycleHost.open(
        paths.join(root, 'registry'),
        device: session.device,
        profile: session.profile,
        sessions: access.sessions,
        authority: InstalledPackageAuthority(packages),
        picker: selected,
      );
      _pendingHost = opened;
      await _verify(opened, packages, session, epoch);
      _guard(session, epoch);
      _host = opened;
      _pickerOwner = selected;
      _packages = packages;
      _scope = scope;
      runtime.attach(session, opened);
      emit(InstalledExtensionsState.ready);
    } catch (_) {
      if (identical(_host, opened)) _retire();
      opened?.close();
      if (!_stopping && epoch == _epoch) {
        emit(InstalledExtensionsState.unavailable);
      }
      rethrow;
    } finally {
      _pendingHost = null;
    }
  }

  Future<void> _verify(
    LocalLifecycleHost host,
    InstalledPackages packages,
    LocalExtensionSession session,
    int epoch,
  ) async {
    for (final entry in host.snapshot(session).entries.values) {
      final verified = await packages.verify(entry['package']! as String);
      _guard(session, epoch);
      if (verified.schema != entry['schema'] ||
          jsonEncode(verified.requested) !=
              jsonEncode(lifecycleOf(entry)['requested'])) {
        throw StateError('UntrustedPackage');
      }
    }
  }

  // Порт доверенного установщика. Не доступен через ABI гостя и не принимает URL.
  Future<void> installAccepted(
    LocalExtensionSession session,
    LocalVerifiedPackage package,
    List<int> bytes, {
    required String installation,
    required String instance,
  }) async {
    if (_installing) throw StateError('Busy');
    _installing = true;
    final epoch = _epoch;
    try {
      await ensure(session);
      _guard(session, epoch);
      await _packages!.admit(package, bytes, () => _guard(session, epoch));
      _guard(session, epoch);
      final host = _host!;
      final before = host.snapshot(session);
      await host.execute(
        session,
        LocalLifecycleCommand(
          action: LocalLifecycleAction.install,
          installation: installation,
          instance: instance,
          revision: 0,
          generation: before.generation,
          package: package.digest,
        ),
      );
      _guard(session, epoch);
      runtime.changed();
    } finally {
      _installing = false;
    }
  }

  void _locked() {
    _epoch++;
    _pendingHost?.close();
    if (_host == null && !_stopping) emit(InstalledExtensionsState.idle);
  }

  void _retire() {
    final host = _host;
    _host = null;
    _scope = null;
    _packages = null;
    if (host != null) {
      runtime.detach(host);
      host.close();
    }
    final picker = _pickerOwner;
    _pickerOwner = null;
    if (picker != null) {
      _draining = Future.wait([_draining, picker.stopped]).then((_) {});
    }
  }

  void stop() {
    if (_stopping) return;
    _stopping = true;
    _epoch++;
    if (runtime.prepare == _loader) runtime.prepare = null;
    _pendingHost?.close();
    _retire();
    emit(InstalledExtensionsState.stopped);
  }

  Future<void> drain() => _draining;

  @override
  Future<void> close() async {
    stop();
    shutdown?.removeStopBarrier(stop);
    shutdown?.removeDrainBarrier(drain);
    access.sessions.removeListener(_locked);
    await _subscription.cancel();
    await drain();
    await super.close();
  }
}
