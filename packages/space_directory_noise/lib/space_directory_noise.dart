// Copyright Space contributors. SPDX-License-Identifier: MIT
import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

const _asset = 'package:space_directory_noise/space_directory_noise.dart';

@Native<Pointer<Uint8> Function(Pointer<Uint8>, UintPtr)>(
  assetId: _asset,
  symbol: 'space_directory_noise_call',
)
external Pointer<Uint8> _call(Pointer<Uint8> input, int length);
@Native<Void Function(Pointer<Uint8>)>(
  assetId: _asset,
  symbol: 'space_directory_noise_free',
)
external void _free(Pointer<Uint8> output);

abstract interface class DirectoryNoiseEngine {
  Future<Map<String, dynamic>> execute(Map<String, dynamic> input);
}

class NativeDirectoryNoise implements DirectoryNoiseEngine {
  const NativeDirectoryNoise();
  @override
  Future<Map<String, dynamic>> execute(Map<String, dynamic> input) =>
      Isolate.run(() => _execute(input));
}

Map<String, dynamic> _execute(Map<String, dynamic> input) {
  final bytes = utf8.encode(jsonEncode(input));
  if (bytes.length > 8 * 1024 * 1024)
    throw const FormatException('Noise input');
  final buffer = calloc<Uint8>(bytes.length);
  Pointer<Uint8> output = nullptr;
  try {
    buffer.asTypedList(bytes.length).setAll(0, bytes);
    output = _call(buffer, bytes.length);
    if (output == nullptr) throw StateError('Directory noise unavailable');
    final response =
        jsonDecode(output.cast<Utf8>().toDartString()) as Map<String, dynamic>;
    if (response['ok'] != true)
      throw StateError('Directory noise rejected: ${response['error']}');
    return response['data'] as Map<String, dynamic>;
  } finally {
    buffer.asTypedList(bytes.length).fillRange(0, bytes.length, 0);
    bytes.fillRange(0, bytes.length, 0);
    calloc.free(buffer);
    if (output != nullptr) _free(output);
  }
}
