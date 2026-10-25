import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

typedef _SetAttributeNative = Int32 Function(
  IntPtr,
  Uint32,
  Pointer<Void>,
  Uint32,
);
typedef _SetAttribute = int Function(int, int, Pointer<Void>, int);

final _SetAttribute _setAttribute = DynamicLibrary.open(
  'dwmapi.dll',
).lookupFunction<_SetAttributeNative, _SetAttribute>('DwmSetWindowAttribute');

int _colorRef(int argb) =>
    ((argb & 255) << 16) | (argb & 0xFF00) | ((argb >> 16) & 255);

// Позволяет применить цвета и к уже запущенному runner без нового канала.
Future<void> applyWindowThemeFallback(
  bool dark,
  int background,
  int foreground,
) async {
  final int handle;
  try {
    handle = await windowManager.getId();
  } on MissingPluginException {
    return;
  } on PlatformException {
    return;
  }
  if (handle == 0) return;
  final set = _setAttribute;
  final value = calloc<Uint32>();
  try {
    value.value = dark ? 1 : 0;
    set(handle, 20, value.cast(), sizeOf<Uint32>());
    value.value = _colorRef(background);
    set(handle, 34, value.cast(), sizeOf<Uint32>());
    set(handle, 35, value.cast(), sizeOf<Uint32>());
    value.value = _colorRef(foreground);
    set(handle, 36, value.cast(), sizeOf<Uint32>());
  } finally {
    calloc.free(value);
  }
}
