import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/ui/camera_scanner.dart';

class NoCamera extends CameraPlatform {
  @override
  Future<List<CameraDescription>> availableCameras() async => [];
}

void main() {
  testWidgets('Без камеры диалог объясняет ошибку и закрывается', (
    tester,
  ) async {
    final original = CameraPlatform.instance;
    CameraPlatform.instance = NoCamera();
    addTearDown(() => CameraPlatform.instance = original);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => scanRecoveryCamera(context),
              child: const Text('Камера'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Камера'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Камера недоступна'), findsOneWidget);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(find.byType(RecoveryCameraDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
