import 'dart:io';
import 'dart:convert';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera/camera.dart' show CameraPreview;
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/connection_panel.dart';

import '../test/shell_test.dart' show TestController;
import 'fixtures/space_link.dart';

class FrameCamera extends CameraPlatform {
  FrameCamera(this.delegate);
  final CameraPlatform delegate;
  Map<String, Object?>? frame;
  int captures = 0;
  @override
  Future<List<CameraDescription>> availableCameras() =>
      delegate.availableCameras();
  @override
  Future<int> createCameraWithSettings(
    CameraDescription description,
    MediaSettings settings,
  ) => delegate.createCameraWithSettings(description, settings);
  @override
  Future<void> initializeCamera(
    int id, {
    ImageFormatGroup imageFormatGroup = ImageFormatGroup.unknown,
  }) => delegate.initializeCamera(id, imageFormatGroup: imageFormatGroup);
  @override
  Stream<CameraInitializedEvent> onCameraInitialized(int id) =>
      delegate.onCameraInitialized(id);
  @override
  Stream<CameraErrorEvent> onCameraError(int id) => delegate.onCameraError(id);
  @override
  Stream<DeviceOrientationChangedEvent> onDeviceOrientationChanged() =>
      delegate.onDeviceOrientationChanged();
  @override
  Widget buildPreview(int id) => delegate.buildPreview(id);
  @override
  Future<void> dispose(int id) => delegate.dispose(id);
  @override
  Future<XFile> takePicture(int id) async {
    captures++;
    final photo = await delegate.takePicture(id);
    if (frame == null) {
      final bytes = await photo.readAsBytes();
      final info = img.findDecoderForData(bytes)?.startDecode(bytes);
      frame = {
        'bytes': bytes.length,
        'width': info?.width,
        'height': info?.height,
      };
      debugPrint('CAMERA_FRAME ${jsonEncode(frame)}');
    }
    return photo;
  }
}

class ImagePicker extends FileSelectorPlatform {
  ImagePicker(this.delegate);
  final FileSelectorPlatform delegate;
  Map<String, Object?>? image;
  XFile? selectedFile;
  @override
  Future<XFile?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    if (selectedFile != null) return selectedFile;
    final file = await delegate.openFile(
      acceptedTypeGroups: acceptedTypeGroups,
      initialDirectory: initialDirectory,
      confirmButtonText: confirmButtonText,
    );
    if (file != null) {
      final bytes = await file.readAsBytes();
      selectedFile = XFile.fromData(bytes);
      final decoder = img.findDecoderForData(bytes);
      final info = decoder?.startDecode(bytes);
      image = {
        'bytes': bytes.length,
        'width': info?.width,
        'height': info?.height,
        'decoder': decoder.runtimeType.toString(),
      };
      debugPrint('QR_IMAGE ${jsonEncode(image)}');
    }
    return file;
  }
}

class QrController extends TestController {
  String? scanned;
  @override
  Future<void> inspect(
    String address, {
    String invitationToken = '',
    String? homeOrigin,
    String tlsFingerprint = '',
  }) async {
    parseConnectionInput(address);
    scanned = address;
  }
}

void main() {
  const source = String.fromEnvironment(
    'SPACE_QR_MODE',
    defaultValue: 'camera',
  );
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.shouldPropagateDevicePointerEvents = true;
  testWidgets(
    'Камера переносит ссылку, приглашение и TLS в форму подключения',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = AppPreferences();
      final controller = QrController();
      final originalCamera = CameraPlatform.instance;
      final camera = FrameCamera(originalCamera);
      CameraPlatform.instance = camera;
      final originalPicker = FileSelectorPlatform.instance;
      final picker = ImagePicker(originalPicker);
      FileSelectorPlatform.instance = picker;
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox());
        await controller.close();
        preferences.dispose();
        CameraPlatform.instance = originalCamera;
        FileSelectorPlatform.instance = originalPicker;
      });
      await tester.pumpWidget(
        MaterialApp(
          theme: preferences.theme,
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            AdminLocalizations.delegate,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: ConnectionPanel(
                controller: controller,
                onConnected: (_) async {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          ValueKey(source == 'image' ? 'space-qr-image' : 'space-qr-camera'),
        ),
      );
      if (source == 'manual') {
        final ready = DateTime.now().add(const Duration(seconds: 30));
        while (find.byType(CameraPreview).evaluate().isEmpty &&
            DateTime.now().isBefore(ready)) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(camera.captures, 0);
        await tester.tap(find.byKey(const ValueKey('camera-capture')));
      }
      final watch = Stopwatch()..start();
      final deadline = DateTime.now().add(
        Duration(minutes: source == 'image' ? 5 : 2),
      );
      while (controller.scanned == null && DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(
        controller.scanned == deviceQrLink,
        true,
        reason: 'Не удалось получить тестовый QR',
      );
      await tester.pumpAndSettle();
      final input = parseConnectionInput(controller.scanned!);
      expect(input.invitationToken, 'iv_${'a' * 43}');
      expect(input.tlsFingerprint, 'b' * 64);
      expect(find.byType(Dialog), findsNothing);
      expect(
        find
            .byType(TextField)
            .evaluate()
            .any(
              (element) =>
                  (element.widget as TextField).controller?.text ==
                  deviceQrLink,
            ),
        true,
      );
      expect(tester.takeException(), isNull);
      binding.reportData = {
        'platform': 'android-qr-$source',
        'source': source,
        'capture_count': camera.captures,
        'scan_elapsed_ms': watch.elapsedMilliseconds,
        'origin': input.origin.toString(),
        'invitation_preserved': true,
        'tls_fingerprint_preserved': true,
        'network_inspection': false,
        'frame': camera.frame,
        'image': picker.image,
      };
    },
    skip: !Platform.isAndroid,
  );
}
