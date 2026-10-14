import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:flutter_zxing/flutter_zxing.dart' as native;
import 'package:zxing2/qrcode.dart' as zx;

import 'core.dart';

String? spaceLinkFromImage(Uint8List bytes) {
  try {
    if (bytes.length < 8 || bytes.length > 8 * 1024 * 1024) return null;
    final decoder = img.findDecoderForData(bytes);
    final info = decoder?.startDecode(bytes);
    if (info == null ||
        info.width < 32 ||
        info.height < 32 ||
        info.width > 4096 ||
        info.height > 4096 ||
        info.width * info.height > 12582912) {
      return null;
    }
    final image = decoder!.decode(bytes);
    if (image == null) return null;
    final text = _readLinkQr(image);
    if (text.length > 2048) return null;
    parseConnectionInput(text);
    return text;
  } catch (_) {
    return null;
  }
}

String _readLinkQr(img.Image image) {
  try {
    return _readBasicQr(image);
  } on zx.ReaderException {
    final code = native.zx.readBarcode(
      image.getBytes(order: img.ChannelOrder.rgb),
      native.DecodeParams(
        imageFormat: native.ImageFormat.rgb,
        format: native.Format.qrCode,
        width: image.width,
        height: image.height,
        tryHarder: true,
        tryDownscale: true,
        tryInverted: true,
      ),
    );
    if (!code.isValid || code.text == null) throw const FormatException('QR');
    return code.text!;
  }
}

String _readBasicQr(img.Image image) {
  final pixels = Int32List(image.width * image.height);
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      pixels[y * image.width + x] =
          0xff000000 |
          pixel.r.toInt() << 16 |
          pixel.g.toInt() << 8 |
          pixel.b.toInt();
    }
  }
  final bitmap = zx.BinaryBitmap(
    zx.HybridBinarizer(
      zx.RGBLuminanceSource(image.width, image.height, pixels),
    ),
  );
  final reader = zx.QRCodeReader();
  try {
    return reader.decode(bitmap).text;
  } catch (_) {
    try {
      return reader
          .decode(
            bitmap,
            hints: zx.DecodeHints()..put(zx.DecodeHintType.tryHarder, null),
          )
          .text;
    } catch (_) {
      return reader
          .decode(
            bitmap,
            hints: zx.DecodeHints()..put(zx.DecodeHintType.pureBarcode, null),
          )
          .text;
    }
  }
}
