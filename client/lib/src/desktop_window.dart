import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

const windowStateKey = 'space.window.v1';

List<Rect> _nativeWorkAreas() => [
  for (final display in DisplayManager.instance.getAll())
    display.workArea.toRect(),
];

class SavedWindow {
  const SavedWindow(this.bounds, {this.maximized = false});
  final Rect bounds;
  final bool maximized;

  String encode() => jsonEncode({
    'v': 1,
    'x': bounds.left,
    'y': bounds.top,
    'width': bounds.width,
    'height': bounds.height,
    'maximized': maximized,
  });

  static SavedWindow? decode(String? value) {
    if (value == null) return null;
    try {
      final data = jsonDecode(value) as Map;
      if (data['v'] != 1) return null;
      final numbers = [
        'x',
        'y',
        'width',
        'height',
      ].map((key) => (data[key] as num).toDouble()).toList();
      if (numbers.any((n) => !n.isFinite || n.abs() > 1000000) ||
          numbers[2] < 100 ||
          numbers[3] < 100 ||
          numbers[2] > 32768 ||
          numbers[3] > 32768) {
        return null;
      }
      return SavedWindow(
        Rect.fromLTWH(numbers[0], numbers[1], numbers[2], numbers[3]),
        maximized: data['maximized'] == true,
      );
    } catch (_) {
      return null;
    }
  }
}

Rect visibleWindowBounds(Rect bounds, List<Rect> workAreas) {
  final areas = workAreas.where((area) => !area.isEmpty).toList();
  if (areas.isEmpty) return bounds;
  double intersection(Rect area) {
    final overlap = area.intersect(bounds);
    return overlap.isEmpty ? 0 : overlap.width * overlap.height;
  }

  areas.sort((a, b) {
    final overlap = intersection(b).compareTo(intersection(a));
    return overlap != 0
        ? overlap
        : (a.center - bounds.center).distanceSquared.compareTo(
            (b.center - bounds.center).distanceSquared,
          );
  });
  final area = areas.first;
  final width = math.min(bounds.width, area.width);
  final height = math.min(bounds.height, area.height);
  return Rect.fromLTWH(
    bounds.left.clamp(area.left, area.right - width),
    bounds.top.clamp(area.top, area.bottom - height),
    width,
    height,
  );
}

class DesktopWindowState with WindowListener {
  DesktopWindowState(
    this.preferences, {
    WindowManager? manager,
    List<Rect> Function()? readWorkAreas,
  }) : manager = manager ?? windowManager,
       readWorkAreas = readWorkAreas ?? _nativeWorkAreas,
       saved = SavedWindow.decode(preferences.getString(windowStateKey));
  final SharedPreferences preferences;
  final WindowManager manager;
  final List<Rect> Function() readWorkAreas;
  SavedWindow? saved;
  Timer? _timer;
  Future<void> _pending = Future<void>.value();
  bool _closing = false;
  bool _restoring = true;

  static Future<DesktopWindowState?> initialize() async {
    if (kIsWeb ||
        ![
          TargetPlatform.windows,
          TargetPlatform.macOS,
          TargetPlatform.linux,
        ].contains(defaultTargetPlatform)) {
      return null;
    }
    await windowManager.ensureInitialized();
    final state = DesktopWindowState(await SharedPreferences.getInstance());
    windowManager.addListener(state);
    await windowManager.setPreventClose(true);
    return state;
  }

  Future<void> restore() async {
    try {
      await manager.waitUntilReadyToShow(
        WindowOptions(size: saved?.bounds.size ?? const Size(1024, 1024)),
      );
      if (saved != null) {
        var bounds = saved!.bounds;
        try {
          bounds = visibleWindowBounds(bounds, readWorkAreas());
        } catch (_) {}
        saved = SavedWindow(bounds, maximized: saved!.maximized);
        await manager.setBounds(bounds);
      } else {
        saved = SavedWindow(await manager.getBounds());
      }
      if (saved!.maximized) await manager.maximize();
    } finally {
      _restoring = false;
      await manager.show();
      if (defaultTargetPlatform == TargetPlatform.linux &&
          saved != null &&
          !saved!.maximized) {
        await manager.setPosition(saved!.bounds.topLeft);
      }
    }
  }

  Future<void> _captureAndSave() async {
    if (await manager.isMinimized() || await manager.isFullScreen()) return;
    final maximized = await manager.isMaximized();
    final bounds = maximized ? saved?.bounds : await manager.getBounds();
    if (bounds == null || bounds.isEmpty) return;
    saved = SavedWindow(bounds, maximized: maximized);
    await preferences.setString(windowStateKey, saved!.encode());
  }

  Future<void> save() {
    _pending = _pending
        .catchError((Object _) {})
        .then((_) => _captureAndSave());
    return _pending;
  }

  void _scheduleSave() {
    if (_closing || _restoring) return;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () {
      unawaited(save().catchError((Object _) {}));
    });
  }

  @override
  void onWindowMove() => _scheduleSave();
  @override
  void onWindowResize() => _scheduleSave();
  @override
  void onWindowMaximize() => _scheduleSave();
  @override
  void onWindowUnmaximize() => _scheduleSave();
  @override
  void onWindowRestore() => _scheduleSave();

  @override
  void onWindowClose() {
    if (_closing) return;
    _closing = true;
    _timer?.cancel();
    unawaited(_saveAndClose());
  }

  Future<void> _saveAndClose() async {
    try {
      await save().timeout(const Duration(seconds: 2));
    } catch (_) {
      // Ошибка хранилища не должна мешать закрыть приложение.
    } finally {
      manager.removeListener(this);
      await manager.setPreventClose(false);
      await manager.close();
    }
  }
}
