import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/desktop_window.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Размер и положение сохраняются, включая отрицательные координаты', () {
    const original = SavedWindow(
      Rect.fromLTWH(-1500, 80, 900, 700),
      maximized: true,
    );
    final restored = SavedWindow.decode(original.encode())!;
    expect(restored.bounds, original.bounds);
    expect(restored.maximized, true);
    expect(SavedWindow.decode('{"v":1,"width":-1}'), isNull);
    expect(SavedWindow.decode('invalid'), isNull);
  });
  test('Отключённый монитор и большой размер не оставляют окно вне экрана', () {
    const area = Rect.fromLTWH(0, 40, 1920, 1000);
    final moved = visibleWindowBounds(
      const Rect.fromLTWH(-2500, 50, 900, 700),
      [area],
    );
    expect(area.contains(moved.topLeft), true);
    expect(moved.size, const Size(900, 700));
    final resized = visibleWindowBounds(
      const Rect.fromLTWH(1800, 900, 2400, 1400),
      [area],
    );
    expect(resized, area);
    const left = Rect.fromLTWH(-1920, 0, 1920, 1080);
    const saved = Rect.fromLTWH(-1500, 100, 900, 700);
    expect(visibleWindowBounds(saved, [area, left]), saved);
  });

  for (final platform in [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.linux,
  ]) {
    test(
      'Сохранение перед закрытием и восстановление состояния: $platform',
      () async {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        SharedPreferences.setMockInitialValues({});
        const channel = MethodChannel('window_manager');
        var bounds = const Rect.fromLTWH(210, 130, 900, 700);
        var maximized = false;
        var minimized = false;
        var preventClose = true;
        final closed = Completer<void>();
        final prefs = await SharedPreferences.getInstance();
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              final args = call.arguments as Map?;
              switch (call.method) {
                case 'isMinimized':
                  return minimized;
                case 'isMaximized':
                  return maximized;
                case 'isFullScreen':
                  return false;
                case 'getBounds':
                  return {
                    'x': bounds.left,
                    'y': bounds.top,
                    'width': bounds.width,
                    'height': bounds.height,
                  };
                case 'setBounds':
                  bounds = Rect.fromLTWH(
                    args?['x'] ?? bounds.left,
                    args?['y'] ?? bounds.top,
                    args?['width'] ?? bounds.width,
                    args?['height'] ?? bounds.height,
                  );
                case 'maximize':
                  maximized = true;
                case 'unmaximize':
                  maximized = false;
                case 'restore':
                  minimized = false;
                case 'setPreventClose':
                  preventClose = args!['isPreventClose'] as bool;
                case 'close':
                  expect(preventClose, false);
                  expect(
                    SavedWindow.decode(prefs.getString(windowStateKey))!
                        .maximized,
                    true,
                  );
                  closed.complete();
              }
              return null;
            });
        addTearDown(
          () => TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null),
        );
        final cleanup = Completer<bool>();
        var exitCalls = 0;
        final state = await DesktopWindowState.initialize(
          prepareExit: () {
            exitCalls++;
            return cleanup.future;
          },
        );
        expect(state, isNotNull);
        await state!.save();
        final normal = bounds;
        maximized = true;
        bounds = const Rect.fromLTWH(0, 0, 1920, 1080);
        await state.save();
        expect(
          SavedWindow.decode(prefs.getString(windowStateKey))!.bounds,
          normal,
        );
        minimized = true;
        state.onWindowClose();
        state.onWindowClose();
        await Future<void>.delayed(Duration.zero);
        expect(exitCalls, 1);
        expect(preventClose, true);
        expect(closed.isCompleted, false);
        cleanup.complete(true);
        await closed.future.timeout(const Duration(seconds: 3));
        var screenReads = 0;
        final next = DesktopWindowState(
          prefs,
          readWorkAreas: () {
            screenReads++;
            return [const Rect.fromLTWH(0, 0, 1920, 1080)];
          },
        );
        await next.restore();
        expect(screenReads, 1);
        expect(bounds, normal);
        expect(maximized, true);
      },
    );
  }

  test(
    'Неподтверждённый выход сохраняет окно; следующий запрос может завершиться',
    () async {
      SharedPreferences.setMockInitialValues({});
      var allowExit = false;
      var closes = 0;
      const channel = MethodChannel('window_manager');
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'isMinimized') return true;
        if (call.method == 'close') closes++;
        return null;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      final state = DesktopWindowState(
        await SharedPreferences.getInstance(),
        prepareExit: () async => allowExit,
      );
      state.onWindowClose();
      await Future<void>.delayed(Duration.zero);
      expect(closes, 0);
      allowExit = true;
      state.onWindowClose();
      await Future<void>.delayed(Duration.zero);
      expect(closes, 1);
    },
  );
}
