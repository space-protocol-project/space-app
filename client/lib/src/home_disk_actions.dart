part of 'home_controller.dart';

extension HomeDiskActions on HomeController {
  Future<HomeBackupPreferences> _backupPreferences(Directory root) async {
    final offered = await release();
    final active = await HomeInstallation(root)
        .active(offered, legacy: await legacyHomeReleases(), persist: false);
    return HomeBackupPreferences(
      root,
      active == null ? null : HomeInstallation(root).runtime(active),
      tool: transferTool,
    );
  }

  Future<HomeBackupSettings?> _backupSettings() async {
    if (busy || _disposed || !supported) return null;
    return _diskOperation(
      (root) async => (await _backupPreferences(root)).load(),
    );
  }

  Future<void> _saveBackupPolicy(HomeBackupPolicy policy) async {
    if (busy || _disposed || !supported) {
      throw StateError('Дождитесь завершения другой операции');
    }
    await _diskOperation((root) async {
      await HomeUpdateJournal(root).requireSettled();
      await (await _backupPreferences(root)).save(policy);
    });
  }

  Future<HomeDiskReport?> _scanDisk() async {
    if (busy || _disposed || !supported) return null;
    return _diskOperation(
      (root) => HomeDiskManager(root, storage: storage).scan(),
    );
  }

  Future<bool> _cleanDisk(HomeDiskCleaned event) async {
    if (busy || running || _disposed || !supported) return false;
    await _diskOperation(
      (root) => HomeDiskManager(
        root,
        storage: storage,
      ).clean(event.report, event.selected),
    );
    return true;
  }

  Future<T> _diskOperation<T>(Future<T> Function(Directory) operation) async {
    busy = true;
    _update();
    final ownLock = !running;
    try {
      final root = await _directory();
      if (ownLock) {
        _lock = await File('${root.path}/process.lock')
            .open(mode: FileMode.append);
        await _lock!.lock(FileLock.exclusive);
      }
      return await operation(root);
    } finally {
      if (ownLock) await _unlock();
      busy = false;
      _update();
    }
  }
}
