part of 'home_controller.dart';

extension HomeDiskActions on HomeController {
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
