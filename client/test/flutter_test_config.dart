import 'dart:async';

// Пакет предоставляет эту точку подмены для тестов без нативного плагина.
// ignore: implementation_imports
import 'package:desktop_drop/src/native_transport.dart';
import 'package:cross_file_io/cross_file_io.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  CrossFileIO.registerWith();
  NativeTransport.debugOverride = NativeTransport.testing()
    ..invokeHandler = (call) async => call.method == 'initialize'
        ? {'view': (call.arguments as Map)['view'], 'generation': 1}
        : null;
  await testMain();
}
