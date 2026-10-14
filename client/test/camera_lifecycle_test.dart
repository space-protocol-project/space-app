import 'dart:async';

import 'package:camera/camera.dart' show CameraPreview;
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/camera_scanner.dart';

class LifecycleCamera extends CameraPlatform {
  final discovery = Completer<List<CameraDescription>>();
  int requests = 0, initialized = 0, disposed = 0;
  int captures = 0;
  Completer<XFile>? pendingPicture;
  static const cameras = [
    CameraDescription(
      name: 'test',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 0,
    ),
  ];
  @override
  Future<List<CameraDescription>> availableCameras() =>
      ++requests == 1 ? discovery.future : Future.value(cameras);
  @override
  Future<int> createCameraWithSettings(
    CameraDescription cameraDescription,
    MediaSettings? mediaSettings,
  ) async => 1;
  @override
  Future<void> initializeCamera(
    int cameraId, {
    ImageFormatGroup imageFormatGroup = ImageFormatGroup.unknown,
  }) async {
    initialized++;
  }

  @override
  Stream<CameraInitializedEvent> onCameraInitialized(int cameraId) =>
      Stream.value(
        const CameraInitializedEvent(
          1,
          640,
          480,
          ExposureMode.auto,
          true,
          FocusMode.auto,
          true,
        ),
      );
  @override
  Stream<CameraErrorEvent> onCameraError(int cameraId) => Stream.multi((_) {});
  @override
  Stream<DeviceOrientationChangedEvent> onDeviceOrientationChanged() =>
      Stream.value(
        const DeviceOrientationChangedEvent(DeviceOrientation.portraitUp),
      );
  @override
  Widget buildPreview(int cameraId) =>
      const ColoredBox(key: ValueKey('camera-preview'), color: Colors.black);
  @override
  Future<void> dispose(int cameraId) async {
    disposed++;
  }

  @override
  Future<XFile> takePicture(int cameraId) async {
    captures++;
    return pendingPicture?.future ?? XFile.fromData(Uint8List(8));
  }
}

void main() {
  testWidgets(
    'Камера возобновляется при возврате во время начальной загрузки',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final original = CameraPlatform.instance;
      final camera = LifecycleCamera();
      CameraPlatform.instance = camera;
      addTearDown(() => CameraPlatform.instance = original);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            AdminLocalizations.delegate,
          ],
          home: Scaffold(body: RecoveryCameraDialog(spaceLink: true)),
        ),
      );
      await tester.pump();
      expect(camera.requests, 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      camera.discovery.complete(LifecycleCamera.cameras);
      await tester.pumpAndSettle();
      expect(camera.requests, 2);
      expect(camera.initialized, 1);
      expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
      final captureRect = tester.getRect(
        find.byKey(const ValueKey('camera-capture')),
      );
      final restartRect = tester.getRect(
        find.widgetWithText(TextButton, 'Включить снова'),
      );
      final cancelRect = tester.getRect(
        find.widgetWithText(TextButton, 'Отмена'),
      );
      expect(restartRect.top, closeTo(captureRect.top, 1));
      expect(cancelRect.top, closeTo(captureRect.top, 1));
      expect(restartRect.left, greaterThan(captureRect.right));
      expect(cancelRect.left, greaterThan(restartRect.right));
      final previewSize = tester.getSize(
        find.byKey(const ValueKey('camera-preview')),
      );
      expect(previewSize.width / previewSize.height, closeTo(480 / 640, .001));
      final preview = tester.widget<CameraPreview>(find.byType(CameraPreview));
      preview.controller.value = preview.controller.value.copyWith(
        deviceOrientation: DeviceOrientation.landscapeLeft,
      );
      await tester.pump();
      final landscapeSize = tester.getSize(find.byType(CameraPreview));
      expect(
        landscapeSize.width / landscapeSize.height,
        closeTo(640 / 480, .001),
      );
      expect(tester.takeException(), isNull);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pumpAndSettle();
      expect(camera.disposed, 1);
      expect(find.byKey(const ValueKey('camera-preview')), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(camera.initialized, 2);
      expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      expect(camera.disposed, 2);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Ручное считывание ждёт автоматический кадр и сохраняет предпросмотр',
    (tester) async {
      final original = CameraPlatform.instance;
      final camera = LifecycleCamera()
        ..discovery.complete(LifecycleCamera.cameras);
      CameraPlatform.instance = camera;
      addTearDown(() => CameraPlatform.instance = original);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            AdminLocalizations.delegate,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => scanSpaceCamera(context),
                child: const Text('Открыть сканер'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Открыть сканер'));
      await tester.pumpAndSettle();
      camera.pendingPicture = Completer<XFile>();
      await tester.pump(const Duration(milliseconds: 800));
      expect(camera.captures, 1);
      await tester.tap(find.byKey(const ValueKey('camera-capture')));
      await tester.pump(const Duration(milliseconds: 1600));
      expect(camera.captures, 1);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('camera-capture')))
            .onPressed,
        isNull,
      );
      camera.pendingPicture!.complete(XFile.fromData(Uint8List(8)));
      for (var attempt = 0; attempt < 20; attempt++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)),
        );
        await tester.pump();
        if (tester
                .widget<FilledButton>(
                  find.byKey(const ValueKey('camera-capture')),
                )
                .onPressed !=
            null) {
          break;
        }
      }
      expect(camera.captures, 2);
      expect(find.byKey(const ValueKey('camera-preview')), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('camera-capture')))
            .onPressed,
        isNotNull,
      );
      await tester.pump(const Duration(milliseconds: 800));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      expect(camera.captures, 3);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
