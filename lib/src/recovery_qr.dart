import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:qr/qr.dart';
import 'package:zxing2/qrcode.dart' as zx;

const recoveryQrPrefix = 'space-recovery:v1:';
const maxRecoveryImageBytes = 8 * 1024 * 1024;
const _pngSignature = [137, 80, 78, 71, 13, 10, 26, 10];
Uint8List recoveryPng(String packet) {
  final text = recoveryQrPrefix + packet;
  if (utf8.encode(text).length > 2048) {
    throw const FormatException(
      'Карточка слишком большая для QR; сохраните JSON',
    );
  }
  final matrix = QrImage(
    QrCode(
      payload: QrPayload.fromTypedData(Uint8List.fromList(utf8.encode(text))),
      errorCorrectLevel: QrErrorCorrectLevel.medium,
    ),
  );
  const scale = 6, margin = 4;
  final size = (matrix.moduleCount + margin * 2) * scale;
  final image = img.Image(width: size, height: size, numChannels: 3);
  img.fill(image, color: img.ColorRgb8(255, 255, 255));
  for (var r = 0; r < matrix.moduleCount; r++) {
    for (var c = 0; c < matrix.moduleCount; c++) {
      if (!matrix.isDark(r, c)) continue;
      img.fillRect(
        image,
        x1: (c + margin) * scale,
        y1: (r + margin) * scale,
        x2: (c + margin + 1) * scale - 1,
        y2: (r + margin + 1) * scale - 1,
        color: img.ColorRgb8(0, 0, 0),
      );
    }
  }
  return img.encodePng(image);
}

String cardFromArtifact(Uint8List bytes) {
  if (bytes.length > maxRecoveryImageBytes) {
    throw const FormatException('Файл слишком большой');
  }
  final png =
      bytes.length >= 8 &&
      List.generate(8, (i) => bytes[i]).join(',') == _pngSignature.join(',');
  if (!png) {
    if (bytes.length > 16384) {
      throw const FormatException('JSON-карточка слишком большая');
    }
    return utf8.decode(bytes);
  }
  if (bytes.length < 24) throw const FormatException('Повреждённый PNG');
  final header = ByteData.sublistView(bytes);
  final width = header.getUint32(16), height = header.getUint32(20);
  if (width < 64 ||
      height < 64 ||
      width > 2048 ||
      height > 2048 ||
      width * height > 4194304) {
    throw const FormatException(
      'PNG должен быть от 64 до 2048 пикселей по каждой стороне',
    );
  }
  final image = img.decodePng(bytes);
  if (image == null) throw const FormatException('Повреждённый PNG');
  final pixels = Int32List(width * height);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final p = image.getPixel(x, y);
      pixels[y * width + x] =
          (p.r.toInt() << 16) | (p.g.toInt() << 8) | p.b.toInt();
    }
  }
  try {
    final reader = zx.QRCodeReader();
    final bitmap = zx.BinaryBitmap(
      zx.HybridBinarizer(zx.RGBLuminanceSource(width, height, pixels)),
    );
    final text = reader.decode(bitmap).text;
    if (!text.startsWith(recoveryQrPrefix) || utf8.encode(text).length > 2048) {
      throw const FormatException('QR не является карточкой Space');
    }
    return text.substring(recoveryQrPrefix.length);
  } on FormatException {
    rethrow;
  } catch (_) {
    throw const FormatException(
      'QR не прочитан. Выберите исходный PNG с белыми полями.',
    );
  }
}

Uint8List pngInWorker(String packet) => recoveryPng(packet);
String artifactInWorker(Uint8List bytes) => cardFromArtifact(bytes);
