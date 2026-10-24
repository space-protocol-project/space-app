import 'home_network.dart';
import 'home_diagnostics.dart';
import 'server_endpoints.dart';
import 'endpoint_connection.dart';
export 'server_endpoints.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:path_provider/path_provider.dart';

import 'event_controller.dart';
import 'platform_capabilities.dart';
import 'home_transfer.dart';
import 'home_archive_inspection.dart';
export 'home_archive_inspection.dart';
import 'home_backup.dart';
import 'home_installation.dart';
import 'home_runtime.dart';
import 'home_storage.dart';
import 'home_disk.dart';
export 'home_disk.dart';
import 'home_backup_policy.dart';
export 'home_backup_policy.dart';
import 'home_update_executor.dart';
import 'home_update_journal.dart';
import 'local_failure.dart';
import 'managed_process.dart';

part 'home_controller.freezed.dart';

part 'home_events.dart';
part 'home_state.dart';
part 'home_disk_actions.dart';

enum HomePhase {
  idle,
  detectingIP,
  downloading,
  installing,
  updating,
  transferring,
  starting,
  running,
  stopping,
  stopped,
}

class HomeServerState {
  HomeServerState(
    this.localOrigin,
    this.publicOrigin,
    this.setupCode,
    this.tlsFingerprint, {
    this.serverId = '',
    this.endpoints = const [],
  });
  final String localOrigin, publicOrigin, setupCode, tlsFingerprint, serverId;
  final List<ServerEndpoint> endpoints;
  String get link => spaceEndpointLink(
    Uri.parse(publicOrigin),
    tlsFingerprint,
    serverId,
    endpoints,
  );
}

Future<Directory> homeDirectory() async =>
    Directory('${(await getApplicationSupportDirectory()).path}/home-server');

class HomeController extends EventController<HomeEvent<dynamic>, HomeState> {
  HomeController({
    this.directory = homeDirectory,
    this.hostingEnabled = true,
    this.release = bundledHomeRelease,
    this.download = downloadHomeRelease,
    this.storage = const HomeStorage(),
    this.diagnoseTool = runHomeDoctor,
    this.transferTool = runHomeTool,
  }) : super(const HomeState()) {
    on<HomeProgressTicked>((event, _) => handleRequest(event, _update));
    on<HomeStatePublished>(
      (event, emit) => event.runAndComplete(() => emit(event.state)),
    );
    on<HomeLoaded>((event, _) => handleRequest(event, _load));
    on<HomeDiskRequested>((event, _) => handleRequest(event, _scanDisk));
    on<HomeBackupSettingsRequested>(
      (event, _) => handleRequest(event, _backupSettings),
    );
    on<HomeBackupPolicySaved>(
      (event, _) => handleRequest(event, () => _saveBackupPolicy(event.policy)),
    );
    on<HomeDiskCleaned>(
      (event, _) => handleRequest(event, () => _cleanDisk(event)),
    );
    on<HomeNetworkSaved>(
      (event, _) => handleRequest(event, () => _saveNetwork(event)),
    );
    on<HomeIPDetected>((event, _) => handleRequest(event, _detectIP));
    on<HomeDiagnosisRequested>(
      (event, _) => handleRequest(event, () => _diagnose(event.wanIP)),
    );
    on<HomeUpdatePrepared>((event, _) => handleRequest(event, _prepareUpdate));
    on<HomeUpdateRequested>(
      (event, _) =>
          handleRequest(event, () => _performUpdate(recover: event.recover)),
    );
    on<HomeStarted>(
      (event, _) => handleRequest(event, () => _start(event.address)),
    );
    on<HomeStopped>(
      (event, _) => handleRequest(
        event,
        () => _stopRequested(disconnectClient: event.disconnectClient),
      ),
    );
    on<HomeExportRequested>(
      (event, _) => handleRequest(event, () => _transfer(event.path)),
    );
    on<HomeImportRequested>(
      (event, _) => handleRequest(
        event,
        () => _transfer(
          event.path,
          importing: true,
          publicIP: event.publicIP,
          inspection: event.inspection,
        ),
      ),
    );
    on<HomeArchiveInspected>(
      (event, _) => handleRequest(event, () => _inspectArchive(event.path)),
    );
    on<HomeErrorReported>(
      (event, _) => handleRequest(event, () => _reportError(event.message)),
    );
  }
  final bool hostingEnabled;
  Future<HomeBackupSettings?> backupSettings() =>
      sendRequest(HomeBackupSettingsRequested());
  Future<void> saveBackupPolicy(HomeBackupPolicy policy) =>
      sendRequest(HomeBackupPolicySaved(policy));
  Future<HomeDiskReport?> inspectDisk() => sendRequest(HomeDiskRequested());
  Future<bool> cleanDisk(HomeDiskReport report, Set<String> selected) =>
      sendRequest(HomeDiskCleaned(report, selected));
  bool get supported => hostingEnabled && canHostSpace;
  Future<bool> exportData(String path) =>
      sendRequest(HomeExportRequested(path));
  final HomeTool transferTool;
  Future<HomeArchiveInspection?> inspectArchive(String path) =>
      sendRequest(HomeArchiveInspected(path));
  Future<bool> importData(
    String path, {
    String publicIP = '',
    HomeArchiveInspection? inspection,
  }) => sendRequest(HomeImportRequested(path, publicIP, inspection));

  Future<bool> configureNetwork(
    List<ServerEndpoint> endpoints, {
    String listenHost = '::',
    int listenPort = 8443,
    bool autoPortMapping = false,
    bool autoPublicIP = false,
  }) => sendRequest(
    HomeNetworkSaved(
      endpoints,
      listenHost,
      listenPort,
      autoPortMapping,
      autoPublicIP,
    ),
  );
  Future<void> load() => sendRequest(HomeLoaded());
  Future<void> diagnose({String wanIP = ''}) =>
      sendRequest(HomeDiagnosisRequested(wanIP));
  Future<String> detectIP() => sendRequest(HomeIPDetected());
  Future<bool> prepareUpdate() => sendRequest(HomeUpdatePrepared());
  Future<void> performUpdate({bool recover = false}) =>
      sendRequest(HomeUpdateRequested(recover: recover));
  Future<HomeServerState?> start(String address) =>
      sendRequest(HomeStarted(address));
  Future<void> stop({Future<void> Function()? disconnectClient}) =>
      sendRequest(HomeStopped(disconnectClient: disconnectClient));
  Future<void> reportError(String message) =>
      sendRequest(HomeErrorReported(message));

  final Future<Directory> Function() directory;
  final Future<HomeRelease> Function() release;
  final HomeStorage storage;
  final HomeTool diagnoseTool;
  HomeDiagnosis? diagnosis;
  HomeDiagnosisError? diagnosisError;
  bool diagnosing = false;
  int _diagnosisGeneration = 0;
  final Future<void> Function(HomeRelease, File, void Function(double))
  download;
  Directory? _root;
  Process? _process;
  bool get ownsProcess => _process != null;
  RandomAccessFile? _lock;
  Future<void>? _unlocking;
  bool busy = false, running = false, _disposed = false;
  String ip = '', error = '';
  HomeNetwork? network;
  String installedVersion = '', availableVersion = '';
  String availableReleaseNotes = '';
  HomeSpaceReport? spaceReport;
  bool pendingUpdate = false;
  String recoverySummary = '';
  bool get recoveryBlocked => {
    LocalFailureCode.homeJournalInvalid,
    LocalFailureCode.homeBackupMissing,
    LocalFailureCode.homeBackupInvalid,
    LocalFailureCode.homeRecoveryInvalid,
  }.contains(failureCode);
  bool get updateAvailable =>
      installedVersion.isNotEmpty &&
      availableVersion.isNotEmpty &&
      HomeRelease.isNewerVersion(availableVersion, installedVersion);
  LocalFailureCode? failureCode;
  HomePhase phase = HomePhase.idle;
  double progress = 0;
  double stopProgress = 0;
  final _operationClock = Stopwatch();
  final _downloadClock = Stopwatch();
  Timer? _progressTimer;
  Timer? _networkTimer;
  bool _readingNetwork = false;
  Duration get elapsed => _operationClock.elapsed;
  int? get downloadSecondsRemaining {
    if (phase != HomePhase.downloading ||
        progress <= 0 ||
        progress >= 1 ||
        _downloadClock.elapsedMilliseconds < 1000) {
      return null;
    }
    return (_downloadClock.elapsedMilliseconds /
            1000 *
            (1 - progress) /
            progress)
        .ceil();
  }

  double get operationProgress => switch (phase) {
    HomePhase.idle => 0.01,
    HomePhase.detectingIP => 0.02,
    HomePhase.downloading => 0.05 + 0.55 * progress.clamp(0, 1),
    HomePhase.installing => 0.65,
    HomePhase.updating || HomePhase.transferring => 0.85,
    HomePhase.starting => 0.80,
    HomePhase.stopping => stopProgress,
    HomePhase.running || HomePhase.stopped => 1,
  };
  void _beginProgress() {
    _operationClock.reset();
    _operationClock.start();
    _downloadClock.reset();
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_disposed && !isClosed) add(HomeProgressTicked());
    });
  }

  void _endProgress() {
    _downloadClock.stop();
    _operationClock.stop();
    _progressTimer?.cancel();
  }

  HomeServerState? server;
  void _reportError(String message) {
    error = message;
    failureCode = LocalFailureCode.homeStartFailed;
    _update();
  }

  String _diagnostic = '';

  void _update() {
    if (!_disposed) publishState();
  }

  void _clearDiagnosis() {
    _diagnosisGeneration++;
    diagnosis = null;
    diagnosisError = null;
  }

  Future<void> _diagnose(String wanIP) async {
    if (busy || diagnosing || _disposed || !supported) return;
    diagnosing = true;
    _clearDiagnosis();
    final generation = _diagnosisGeneration;
    _update();
    try {
      final root = await _directory();
      final offered = await release();
      final active = await HomeInstallation(root)
          .active(offered, legacy: await legacyHomeReleases(), persist: false);
      if (active == null) throw const HomeDiagnosisUnsupported();
      final result = await diagnoseTool(
        HomeInstallation(root).runtime(active),
        [
          'doctor',
          '-home-data',
          '${root.path}/data',
          '-json',
          if (wanIP.trim().isNotEmpty) ...['-wan-ip', wanIP.trim()],
        ],
      );
      final report = HomeDiagnosis.fromJson(result);
      if (generation == _diagnosisGeneration && !_disposed) diagnosis = report;
    } catch (problem) {
      if (generation == _diagnosisGeneration && !_disposed) {
        diagnosisError = problem is HomeDiagnosisUnsupported
            ? HomeDiagnosisError.unsupported
            : HomeDiagnosisError.failed;
      }
    } finally {
      diagnosing = false;
      _update();
    }
  }

  void publishState() {
    if (!_disposed && !isClosed) {
      publishStateEvent(HomeStatePublished(HomeState.fromController(this)));
    }
  }

  Future<Directory> _directory() async {
    if (!supported) {
      throw const LocalFailure(
        LocalFailureCode.platformUnsupported,
        'Домашний сервер доступен только на компьютере',
      );
    }
    final root = _root ??= await resolveHomeLocation(await directory());
    await root.create(recursive: true);
    return root;
  }

  Future<void> _load() async {
    if (!supported) return;
    try {
      final root = await _directory();
      await _loadRecovery(root);
      network = await HomeNetwork.read(root);
      ip = network?.endpoints.first.host ?? '';
      final offered = await release();
      availableVersion = offered.version;
      availableReleaseNotes = offered.releaseNotes;
      final selection = HomeInstallation(root).selection;
      if (await selection.exists() && await selection.length() <= 65536) {
        final saved = jsonDecode(await selection.readAsString()) as Map;
        installedVersion = HomeRelease.fromJson(
          Map<String, dynamic>.from(saved['active'] as Map),
        ).version;
      }
      if (installedVersion.isEmpty && ip.isNotEmpty) {
        installedVersion =
            (await HomeInstallation(root).active(
              offered,
              legacy: await legacyHomeReleases(),
              persist: false,
            ))?.version ??
            '';
      }
    } catch (_) {
      /* Первый запуск или недоступное хранилище проверяются при запуске. */
    }
    _update();
  }

  Future<void> _loadRecovery(Directory root) async {
    try {
      final record = await HomeUpdateExecutor(root).inspectRecovery();
      pendingUpdate = record != null && !record.settled;
      recoverySummary =
          'directory: ${root.path}\n'
          'operation: ${record?.id ?? '-'}\nstep: ${record?.step.name ?? '-'}\n'
          'source: ${record?.source.version ?? '-'}\ntarget: ${record?.target.version ?? '-'}';
      if (recoveryBlocked) {
        if (record != null &&
            record.recovery == HomeRecoveryAction.restoreBackup &&
            failureCode == LocalFailureCode.homeBackupInvalid) {
          await verifyHomeBackup(
            Directory('${root.path}/${record.backupPath}'),
            record.target,
          );
        }
        failureCode = null;
        error = '';
      }
    } on LocalFailure catch (problem) {
      pendingUpdate = true;
      failureCode = problem.code;
      error = problem.message;
      recoverySummary = 'directory: ${root.path}';
    }
  }

  Future<bool> _transfer(
    String path, {
    bool importing = false,
    String publicIP = '',
    HomeArchiveInspection? inspection,
  }) async {
    if (busy || running || _disposed || !supported) return false;
    busy = true;
    error = '';
    failureCode = null;
    _beginProgress();
    _update();
    try {
      final root = await _directory();
      _lock = await File('${root.path}/process.lock')
          .open(mode: FileMode.append);
      await _lock!.lock(FileLock.exclusive);
      await HomeUpdateJournal(root).requireSettled();
      final offered = await release();
      final runtime = await _prepare(root, offered);
      final transfer = HomeTransfer(
        root,
        runtime,
        offered,
        tool: transferTool,
        storage: storage,
      );
      phase = HomePhase.transferring;
      _update();
      if (importing) {
        _root = await transfer.importFrom(
          path,
          publicIP: publicIP,
          inspection: inspection,
        );
        installedVersion = offered.version;
        await _load();
      } else {
        await transfer.exportTo(path);
      }
      return true;
    } catch (problem) {
      if (problem is LocalFailure) failureCode = problem.code;
      if (problem is HomeSpaceFailure) {
        spaceReport = problem.report;
        failureCode = problem.code;
      }
      error = problem.toString().replaceFirst('FormatException: ', '');
      return false;
    } finally {
      await _unlock();
      busy = false;
      phase = HomePhase.stopped;
      _endProgress();
      _update();
    }
  }

  Future<HomeArchiveInspection?> _inspectArchive(String path) async {
    if (busy || running || _disposed || !supported) return null;
    busy = true;
    _beginProgress();
    _update();
    try {
      final root = await _directory();
      _lock = await File('${root.path}/process.lock')
          .open(mode: FileMode.append);
      await _lock!.lock(FileLock.exclusive);
      await HomeUpdateJournal(root).requireSettled();
      final offered = await release();
      final runtime = await _prepare(root, offered);
      phase = HomePhase.transferring;
      _update();
      return await HomeTransfer(
        root,
        runtime,
        offered,
        tool: transferTool,
      ).inspect(path);
    } finally {
      await _unlock();
      busy = false;
      phase = HomePhase.stopped;
      _endProgress();
      _update();
    }
  }

  Future<String> _detectIP() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final request = await client
          .getUrl(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 10));
      request.followRedirects = false;
      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != 200) {
        throw const FormatException('Не удалось определить IP');
      }
      final bytes = <int>[];
      await for (final chunk in response.timeout(const Duration(seconds: 10))) {
        bytes.addAll(chunk);
        if (bytes.length > 1024) {
          throw const FormatException('Некорректный ответ определения IP');
        }
      }
      return (jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>)['ip']
          as String;
    } finally {
      client.close(force: true);
    }
  }

  Future<Directory> _install(Directory root) async {
    final offered = await release();
    final installation = HomeInstallation(root);
    final active = await installation.active(
      offered,
      legacy: await legacyHomeReleases(),
    );
    installedVersion = active?.version ?? offered.version;
    availableVersion = offered.version;
    availableReleaseNotes = offered.releaseNotes;
    if (active != null) return installation.runtime(active);
    final target = await _prepare(root, offered);
    await installation.selectInitial(offered);
    return target;
  }

  Future<Directory> _prepare(Directory root, HomeRelease descriptor) async {
    phase = HomePhase.installing;
    _update();
    final ready = await HomeInstallation(root).runtime(descriptor).exists();
    spaceReport = await storage.check(
      root,
      additionalBytes: ready ? 0 : descriptor.bytes + descriptor.unpackedBytes,
    );
    phase = HomePhase.downloading;
    _downloadClock.start();
    _update();
    return HomeInstallation(root).prepare(
      descriptor,
      download: download,
      progress: (value) {
        progress = value;
        _update();
      },
      extracting: () {
        _downloadClock.stop();
        phase = HomePhase.installing;
        _update();
      },
    );
  }

  Future<bool> _prepareUpdate() async {
    if (busy || _disposed) return false;
    busy = true;
    error = '';
    failureCode = null;
    spaceReport = null;
    progress = 0;
    _beginProgress();
    var ownLock = false;
    try {
      final root = await _directory();
      if (!running) {
        _lock = await File('${root.path}/process.lock')
            .open(mode: FileMode.append);
        ownLock = true;
        await _lock!.lock(FileLock.exclusive);
      }
      await HomeUpdateJournal(root).requireSettled();
      final target = await release();
      final source = await HomeInstallation(root)
          .active(target, legacy: await legacyHomeReleases());
      if (source == null || !target.isNewerThan(source)) return false;
      await _prepare(root, target);
      await HomeUpdateExecutor(root).verifyCandidate(target);
      return true;
    } catch (e) {
      if (e is HomeSpaceFailure) spaceReport = e.report;
      failureCode = e is LocalFailure
          ? e.code
          : LocalFailureCode.homeUpdateFailed;
      error = e.toString();
      return false;
    } finally {
      if (ownLock) await _unlock();
      busy = false;
      phase = running ? HomePhase.running : HomePhase.stopped;
      _endProgress();
      _update();
    }
  }

  Future<void> _performUpdate({bool recover = false}) async {
    if (busy || running || _disposed) return;
    busy = true;
    error = '';
    failureCode = null;
    phase = HomePhase.updating;
    _beginProgress();
    _update();
    try {
      final root = await _directory();
      _lock = await File('${root.path}/process.lock')
          .open(mode: FileMode.append);
      await _lock!.lock(FileLock.exclusive);
      final executor = HomeUpdateExecutor(root, storage: storage);
      if (recover) {
        await executor.recover();
      } else {
        final target = await release();
        final source = await HomeInstallation(root)
            .active(target, legacy: await legacyHomeReleases());
        if (source == null || !target.isNewerThan(source)) return;
        await executor.update(source, target);
      }
    } catch (e) {
      if (e is HomeSpaceFailure) spaceReport = e.report;
      failureCode = e is LocalFailure
          ? e.code
          : LocalFailureCode.homeUpdateFailed;
      error = e.toString();
    } finally {
      await _unlock();
      busy = false;
      phase = HomePhase.stopped;
      _endProgress();
      await _load();
      _update();
    }
  }

  Future<void> _prepareConfiguration(Directory root, String address) async {
    network = await HomeNetwork.read(root);
    if (network == null) {
      final host = address.trim().isEmpty ? await _detectIP() : address.trim();
      network = HomeNetwork([ServerEndpoint.parse(host, 8443)]);
      await network!.write(root);
    }
    ip = network!.endpoints.first.host;
  }

  Future<bool> _saveNetwork(HomeNetworkSaved event) async {
    if (busy || running || _disposed || !supported) return false;
    busy = true;
    error = '';
    _update();
    RandomAccessFile? lock;
    try {
      final root = await _directory();
      lock = await File('${root.path}/process.lock')
          .open(mode: FileMode.append);
      await lock.lock(FileLock.exclusive);
      await HomeUpdateJournal(root).requireSettled();
      final previous = await HomeNetwork.read(root);
      final next = previous == null
          ? HomeNetwork(
              event.endpoints,
              listenHost: event.listenHost,
              listenPort: event.listenPort,
              autoPortMapping: event.autoPortMapping,
              autoPublicIP: event.autoPublicIP,
            )
          : previous.changed(
              event.endpoints,
              event.listenHost,
              event.listenPort,
              autoPortMapping: event.autoPortMapping,
              autoPublicIP: event.autoPublicIP,
            );
      await next.write(root);
      _clearDiagnosis();
      network = next;
      ip = next.endpoints.first.host;
      return true;
    } catch (problem) {
      error = problem.toString();
      return false;
    } finally {
      await lock?.close();
      busy = false;
      _update();
    }
  }

  void _observeHomeProcess(Process process) {
    void record(List<int> chunk) {
      _diagnostic = '$_diagnostic${utf8.decode(chunk, allowMalformed: true)}';
      if (_diagnostic.length > 8192) {
        _diagnostic = _diagnostic.substring(_diagnostic.length - 8192);
      }
    }

    process.stdout.listen(record);
    process.stderr.listen(record);
    unawaited(
      process.exitCode.then((code) async {
        // Остановку и снятие блокировки подтверждает _stop после проверки базы.
        if (_process != process || phase == HomePhase.stopping) return;
        _process = null;
        running = false;
        server = null;
        if (!busy && code != 0) {
          failureCode = LocalFailureCode.homeStartFailed;
          error = 'Сервер завершился с ошибкой. $_diagnostic';
        }
        await _unlock();
        _update();
      }),
    );
  }

  void _watchNetwork(Directory root, Process process) {
    _networkTimer?.cancel();
    _networkTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_readingNetwork || _disposed || !running || _process != process) {
        return;
      }
      _readingNetwork = true;
      try {
        final next = await HomeNetwork.read(root);
        final current = server;
        if (next == null ||
            current == null ||
            next.revision <= (network?.revision ?? 0)) {
          return;
        }
        if (_disposed || _process != process || !running) return;
        network = next;
        ip = next.endpoints.first.host;
        server = HomeServerState(
          current.localOrigin,
          next.endpoints.first.origin.toString(),
          current.setupCode,
          current.tlsFingerprint,
          serverId: current.serverId,
          endpoints: next.advertisedEndpoints,
        );
        _clearDiagnosis();
        _update();
      } catch (_) {
        // Во время атомарной замены повторим чтение на следующем такте.
      } finally {
        _readingNetwork = false;
      }
    });
  }

  Future<void> _waitForHomeReady(File ready, Process process) async {
    final deadline = DateTime.now().add(const Duration(seconds: 60));
    while (!await ready.exists()) {
      if (_disposed || _process != process) {
        throw FormatException('Сервер не запущен. $_diagnostic');
      }
      if (DateTime.now().isAfter(deadline)) {
        throw const FormatException('Сервер не успел запуститься');
      }
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<HomeServerState?> _start(String address) async {
    if (busy || running || _disposed) return server;
    _clearDiagnosis();
    busy = true;
    _beginProgress();
    error = '';
    failureCode = null;
    progress = 0;
    phase = HomePhase.idle;
    server = null;
    _diagnostic = '';
    _update();
    try {
      await _requireNotTransferred();
      final root = await _directory();
      _lock = await File('${root.path}/process.lock')
          .open(mode: FileMode.append);
      await _lock!.lock(FileLock.exclusive);
      await HomeUpdateJournal(root).requireSettled();
      await _prepareConfiguration(root, address);
      final runtime = await _install(root);
      await _checkRuntimeCapabilities(runtime);
      if (_disposed) {
        throw const FormatException('Запуск отменён при закрытии приложения');
      }
      phase = HomePhase.starting;
      _update();
      final data = await Directory('${root.path}/data').create(recursive: true);
      final ready = File('${data.path}/state.json');
      if (await ready.exists()) await ready.delete();
      final httpPort = await _freePort();
      final grpcPort = await _freePort();
      final executable =
          '${runtime.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}';
      final process = await Process.start(executable, [
        '-home-data',
        data.path,
        '-home-runtime',
        runtime.path,
        '-public-ip',
        ip,
        '-http',
        '127.0.0.1:$httpPort',
        '-grpc',
        '127.0.0.1:$grpcPort',
        '-https',
        '${network!.listenHost.contains(':') ? '[${network!.listenHost}]' : network!.listenHost}:${network!.listenPort}',
        '-managed',
      ], mode: ProcessStartMode.normal);
      _process = process;
      _observeHomeProcess(process);
      await _waitForHomeReady(ready, process);
      network = await HomeNetwork.read(root) ?? network;
      ip = network!.endpoints.first.host;
      final result =
          jsonDecode(await ready.readAsString()) as Map<String, dynamic>;
      final pem = await File('${data.path}/server.crt').readAsString();
      final der = base64Decode(
        pem.replaceAll(RegExp(r'-----[^-]+-----|\s'), '').trim(),
      );
      server = HomeServerState(
        result['local_origin'] as String,
        result['public_origin'] as String,
        result['setup_code'] as String,
        crypto.sha256.convert(der).toString(),
        serverId: result['server_id'] as String? ?? '',
        endpoints: network!.advertisedEndpoints,
      );
      running = true;
      phase = HomePhase.running;
      _watchNetwork(root, process);
      return server;
    } catch (e) {
      await _handleStartFailure(e);
      return null;
    } finally {
      busy = false;
      _endProgress();
      _update();
    }
  }

  Future<void> _handleStartFailure(Object error) async {
    failureCode = error is LocalFailure
        ? error.code
        : LocalFailureCode.homeStartFailed;
    this.error = error.toString().replaceFirst('FormatException: ', '');
    try {
      await _stop();
    } catch (_) {
      failureCode = LocalFailureCode.homeStopFailed;
      this.error += ' Сервер не подтвердил остановку.';
    }
  }

  Future<void> _checkRuntimeCapabilities(Directory runtime) async {
    final capabilities = await runHomeTool(runtime, ['-runtime-info']);
    if (capabilities['endpointSetVersion'] != 1) {
      throw const FormatException(
        'Обновите runtime: требуется поддержка нескольких адресов пространства',
      );
    }
    if ((network!.autoPortMapping || network!.autoPublicIP) &&
        capabilities['automaticNetworkVersion'] != 1) {
      throw const FormatException(
        'Обновите runtime: требуется поддержка автоматических сетевых настроек',
      );
    }
  }

  Future<void> _requireNotTransferred() async {
    final marker = File(
      '${(await directory()).path}/device-migration-exported.json',
    );
    if (await marker.exists()) {
      throw StateError(
        'Пространство перенесено. Восстановите сохранённый архив на новом компьютере.',
      );
    }
  }

  Future<void> _unlock() {
    if (_unlocking != null) return _unlocking!;
    final lock = _lock;
    _lock = null;
    if (lock == null) return Future.value();
    _unlocking = lock.close().whenComplete(() => _unlocking = null);
    return _unlocking!;
  }

  Future<void> _stop() async {
    _networkTimer?.cancel();
    _clearDiagnosis();
    phase = HomePhase.stopping;
    stopProgress = .2;
    _update();
    final process = _process;
    if (process != null) {
      // EOF запускает штатное завершение Go, затем остановку собственной PostgreSQL.
      await stopManagedProcess(
        process,
        onInputClosed: () {
          stopProgress = .35;
          _update();
        },
      );
      stopProgress = .8;
      _update();
      final pidFile = _root == null
          ? null
          : File('${_root!.path}/data/postgres/postmaster.pid');
      if (pidFile != null && await pidFile.exists()) {
        throw StateError('PostgreSQL не подтвердила остановку: $_diagnostic');
      }
      _process = null;
      stopProgress = .95;
      _update();
    }
    running = false;
    server = null;
    phase = HomePhase.stopped;
    await _unlock();
  }

  Future<void> _stopRequested({
    Future<void> Function()? disconnectClient,
  }) async {
    if (busy) return;
    busy = true;
    phase = HomePhase.stopping;
    stopProgress = 0;
    _beginProgress();
    error = '';
    failureCode = null;
    _update();
    try {
      stopProgress = .05;
      _update();
      if (disconnectClient != null) {
        try {
          await disconnectClient().timeout(const Duration(seconds: 5));
        } catch (_) {
          /* Остановка клиента не должна блокировать завершение сервера. */
        }
      }
      await _stop();
    } catch (_) {
      failureCode = LocalFailureCode.homeStopFailed;
      error = 'Сервер не подтвердил завершение всех процессов. Проверьте состояние перед повторным запуском.';
    } finally {
      busy = false;
      _endProgress();
      _update();
    }
  }

  @override
  Future<void> close() async {
    _disposed = true;
    _networkTimer?.cancel();
    _endProgress();
    unawaited(_process?.stdin.close());
    await super.close();
  }
}

bool isPublicHomeIPv4(String value) {
  final address = InternetAddress.tryParse(value);
  if (address == null || address.type != InternetAddressType.IPv4) return false;
  final bytes = address.rawAddress;
  return bytes[0] > 0 &&
      bytes[0] < 224 &&
      bytes[0] != 10 &&
      bytes[0] != 127 &&
      !(bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) &&
      !(bytes[0] == 192 && bytes[1] == 168) &&
      !(bytes[0] == 169 && bytes[1] == 254) &&
      !(bytes[0] == 100 && bytes[1] >= 64 && bytes[1] <= 127);
}

Future<int> _freePort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();
  return port;
}
