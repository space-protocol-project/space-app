import 'dart:ffi';
import 'dart:isolate';

const _asset = 'package:space_voice_native/space_voice_native.dart';

@Native<Pointer<Void> Function()>(assetId: _asset, symbol: 'space_voice_create')
external Pointer<Void> _create();

@Native<Void Function(Pointer<Void>)>(
  assetId: _asset,
  symbol: 'space_voice_free',
)
external void _free(Pointer<Void> state);

typedef ProcessFrame = Int32 Function(
  Pointer<Void>,
  Pointer<Float>,
  Int32,
  Int32,
);

@Native<ProcessFrame>(assetId: _asset, symbol: 'space_voice_process')
external int processFrame(
  Pointer<Void> state,
  Pointer<Float> samples,
  int frames,
  int rate,
);

abstract interface class DeepFilterHandle {
  int get address;
  int get callbackAddress;
  void release();
}

class DeepFilterContext implements DeepFilterHandle {
  DeepFilterContext._(this.address);
  @override
  final int address;
  bool _released = false;

  static Future<DeepFilterContext> create() async {
    final address = await Isolate.run(() => _create().address);
    if (address == 0) throw StateError('Не удалось загрузить DeepFilterNet3');
    return DeepFilterContext._(address);
  }

  @override
  int get callbackAddress =>
      Native.addressOf<NativeFunction<ProcessFrame>>(processFrame).address;

  @override
  void release() {
    if (_released) return;
    _released = true;
    _free(Pointer<Void>.fromAddress(address));
  }
}
