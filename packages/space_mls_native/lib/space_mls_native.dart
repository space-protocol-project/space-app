import 'dart:ffi';

const asset = 'package:space_mls_native/space_mls_native.dart';

@Native<Pointer<Uint8> Function(Pointer<Uint8>, UintPtr)>(
  assetId: asset,
  symbol: 'space_mls_call',
)
external Pointer<Uint8> call(Pointer<Uint8> input, int length);

@Native<Void Function(Pointer<Uint8>)>(assetId: asset, symbol: 'space_mls_free')
external void release(Pointer<Uint8> output);

bool get available {
  try {
    Native.addressOf<NativeFunction<Void Function(Pointer<Uint8>)>>(release);
    return true;
  } on ArgumentError {
    return false;
  }
}
