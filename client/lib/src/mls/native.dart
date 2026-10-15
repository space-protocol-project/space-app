import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:space_mls_native/space_mls_native.dart' as bundled;

abstract interface class MlsEngine {
  Future<Map<String, dynamic>> execute(Map<String, dynamic> request);
}

class NativeMlsEngine implements MlsEngine {
  NativeMlsEngine({String? libraryPath})
    : libraryPath = libraryPath ?? defaultPath;
  final String libraryPath;

  static String get defaultPath =>
      Platform.environment['SPACE_MLS_LIBRARY'] ?? '';

  bool get available =>
      libraryPath.isEmpty ? bundled.available : _libraryAvailable(libraryPath);

  @override
  Future<Map<String, dynamic>> execute(Map<String, dynamic> request) {
    final selectedPath = libraryPath;
    return Isolate.run(() => _execute(selectedPath, request));
  }
}

Map<String, dynamic> _execute(
  String libraryPath,
  Map<String, dynamic> request,
) {
  final library = libraryPath.isEmpty ? null : DynamicLibrary.open(libraryPath);
  final call = library == null
      ? (Pointer<Uint8> p, int n) => bundled.call(p, n).cast<Utf8>()
      : library.lookupFunction<
          Pointer<Utf8> Function(Pointer<Uint8>, UintPtr),
          Pointer<Utf8> Function(Pointer<Uint8>, int)
        >('space_mls_call');
  final release = library == null
      ? (Pointer<Utf8> p) => bundled.release(p.cast<Uint8>())
      : library.lookupFunction<
          Void Function(Pointer<Utf8>),
          void Function(Pointer<Utf8>)
        >('space_mls_free');
  final encoded = utf8.encode(jsonEncode(request));
  final buffer = calloc<Uint8>(encoded.length);
  Pointer<Utf8> output = nullptr;
  try {
    buffer.asTypedList(encoded.length).setAll(0, encoded);
    output = call(buffer, encoded.length);
    if (output == nullptr) throw StateError('Модуль MLS не вернул результат');
    final response = jsonDecode(output.toDartString()) as Map<String, dynamic>;
    if (response['ok'] != true) {
      throw StateError(
        '${request['op']}: ${response['error'] as String? ?? 'Ошибка обработки MLS'}',
      );
    }
    return response['data'] as Map<String, dynamic>;
  } finally {
    buffer.asTypedList(encoded.length).fillRange(0, encoded.length, 0);
    encoded.fillRange(0, encoded.length, 0);
    calloc.free(buffer);
    if (output != nullptr) release(output);
  }
}

bool _libraryAvailable(String path) {
  try {
    DynamicLibrary.open(path);
    return true;
  } on ArgumentError {
    return false;
  }
}
