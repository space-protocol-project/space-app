import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'recovery_qr.dart';

String? cameraCardInWorker(Uint8List bytes) {
  if (bytes.length > 8 * 1024 * 1024 || bytes.length < 8) return null;
  final jpeg = bytes[0] == 255 && bytes[1] == 216 && bytes[2] == 255;
  final png =
      bytes[0] == 137 && bytes[1] == 80 && bytes[2] == 78 && bytes[3] == 71;
  if (!jpeg && !png) return null;
  final decoder = img.findDecoderForData(bytes);
  final info = decoder?.startDecode(bytes);
  if (info == null ||
      info.width < 64 ||
      info.height < 64 ||
      info.width > 4096 ||
      info.height > 4096 ||
      info.width * info.height > 12582912) {
    return null;
  }
  var frame = decoder!.decode(bytes);
  if (frame == null) return null;
  if (frame.width > 1400 || frame.height > 1400) {
    frame = img.copyResize(
      frame,
      width: frame.width >= frame.height ? 1400 : null,
      height: frame.height > frame.width ? 1400 : null,
    );
  }
  try {
    return cardFromArtifact(img.encodePng(frame));
  } catch (_) {
    return null;
  }
}
