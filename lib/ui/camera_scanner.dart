import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../src/camera_qr.dart';

import 'package:space_admin_ui/space_admin_ui.dart';

Future<String?> scanRecoveryCamera(BuildContext context) => showDialog<String>(
  context: context,
  barrierDismissible: false,
  builder: (_) => const RecoveryCameraDialog(),
);

class RecoveryCameraDialog extends StatefulWidget {
  const RecoveryCameraDialog({super.key});
  @override
  State<RecoveryCameraDialog> createState() => _RecoveryCameraDialogState();
}

class _RecoveryCameraDialogState extends State<RecoveryCameraDialog>
    with WidgetsBindingObserver {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  CameraDescription? selected;
  Timer? timer;
  Future<void>? frameJob;
  int generation = 0;
  String? error;
  bool starting = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(start());
  }

  Future<void> stop() async {
    generation++;
    timer?.cancel();
    timer = null;
    final camera = controller;
    controller = null;
    try {
      await camera?.dispose();
    } catch (_) {}
    try {
      await frameJob?.timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  Future<void> start([CameraDescription? choice]) async {
    if (starting) return;
    starting = true;
    try {
      await stop();
      final token = generation;
      final available = await availableCameras();
      if (!mounted || token != generation) return;
      if (available.isEmpty) {
        throw CameraException('NotFound', 'Нет доступной камеры');
      }
      cameras = available;
      selected = choice == null
          ? available.first
          : available.firstWhere(
              (c) => c.name == choice.name,
              orElse: () => available.first,
            );
      final camera = CameraController(
        selected!,
        ResolutionPreset.high,
        enableAudio: false,
      );
      controller = camera;
      await camera.initialize();
      if (!mounted || token != generation) {
        await camera.dispose();
        return;
      }
      setState(() => error = null);
      timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
        if (frameJob == null && mounted && controller != null) {
          frameJob = readFrame(
            camera,
            token,
          ).whenComplete(() => frameJob = null);
        }
      });
    } on CameraException catch (e) {
      await stop();
      if (mounted) {
        setState(
          () => error = e.code.contains('AccessDenied')
              ? 'Доступ к камере запрещён. Разрешите его в настройках Windows.'
              : 'Камера недоступна или занята другим приложением. Можно восстановиться из файла.',
        );
      }
    } catch (_) {
      await stop();
      if (mounted) {
        setState(
          () => error = 'Не удалось открыть камеру. Используйте PNG или JSON.',
        );
      }
    } finally {
      starting = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> readFrame(CameraController camera, int token) async {
    XFile? photo;
    try {
      photo = await camera.takePicture();
      if (await photo.length() > 8 * 1024 * 1024) return;
      final packet = await compute(
        cameraCardInWorker,
        await photo.readAsBytes(),
      );
      if (packet != null && mounted && token == generation) {
        // Остановка вне frameJob: stop ожидает его завершения.
        timer?.cancel();
        generation++;
        Navigator.of(context).pop(packet);
      }
    } catch (_) {
      if (mounted && token == generation) {
        setState(
          () => error =
              'Не удалось прочитать кадр. Проверьте камеру или выберите файл.',
        );
      }
    } finally {
      if (photo != null) {
        final path = File(photo.path).absolute.path;
        final root =
            '${Directory.systemTemp.absolute.path}${Platform.pathSeparator}';
        if (path
            .replaceAll('/', Platform.pathSeparator)
            .toLowerCase()
            .startsWith(
              root.replaceAll('/', Platform.pathSeparator).toLowerCase(),
            )) {
          try {
            await File(path).delete();
          } catch (_) {}
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      unawaited(stop());
      if (mounted) {
        setState(() => error = 'Камера остановлена. Нажмите «Включить снова».');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RecoveryCameraView(
    cameras: [for (final camera in cameras) camera.name],
    selected: selected?.name,
    starting: starting,
    error: error,
    preview: controller?.value.isInitialized == true
        ? AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: CameraPreview(controller!),
          )
        : null,
    onSelect: (name) {
      if (name != null) {
        unawaited(start(cameras.firstWhere((c) => c.name == name)));
      }
    },
    onRestart: () => unawaited(start(selected)),
    onCancel: () async {
      await stop();
      if (context.mounted) Navigator.of(context).pop();
    },
  );
}
