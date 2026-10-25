import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'files.dart';
import 'participant_profiles.dart';

Future<Uint8List> prepareProfileAvatar(SpaceFile file) async {
  if (await file.length() > 5 * 1024 * 1024) {
    throw const FormatException('Выберите PNG или JPEG до 5 МиБ');
  }
  final data = BytesBuilder(copy: false);
  await for (final chunk in file.openRead()) {
    if (data.length + chunk.length > 5 * 1024 * 1024) {
      throw const FormatException('Выберите PNG или JPEG до 5 МиБ');
    }
    data.add(chunk);
  }
  final bytes = data.takeBytes();
  return Isolate.run(() => profileAvatarBytes(bytes));
}

Uint8List profileAvatarBytes(Uint8List bytes) {
  if (bytes.length > 5 * 1024 * 1024) {
    throw const FormatException('Слишком большое изображение');
  }
  final input = _avatarInput(bytes);
  final img.Decoder decoder =
      img.PngDecoder(maxPixels: 4 * 1024 * 1024).isValidFile(input)
      ? img.PngDecoder(maxPixels: 4 * 1024 * 1024)
      : img.JpegDecoder(maxPixels: 4 * 1024 * 1024);
  final info = decoder.startDecode(input);
  if (info == null ||
      info.numFrames != 1 ||
      info.width > 4096 ||
      info.height > 4096) {
    throw const FormatException(
      'Нужно статичное PNG или JPEG до 4 миллионов пикселей',
    );
  }
  final decoded = decoder.decodeFrame(0);
  if (decoded == null) {
    throw const FormatException('Не удалось прочитать изображение');
  }
  final image = img.bakeOrientation(decoded);
  for (final size in [128, 96, 64]) {
    final canvas = _profileCanvas(image, size);
    final png = img.encodePng(
      img.quantize(canvas, numberOfColors: 64),
      level: 9,
    );
    if (validProfileAvatar(png)) return png;
  }
  throw const FormatException('Не удалось подготовить аватар до 8 КиБ');
}

img.Image _profileCanvas(img.Image image, int size) {
  final cropped = img.copyResizeCropSquare(
    image,
    size: size,
    interpolation: img.Interpolation.average,
  );
  final canvas = img.Image(width: size, height: size, numChannels: 4);
  for (final pixel in cropped) {
    canvas.setPixel(pixel.x, pixel.y, pixel);
  }
  return canvas;
}

Uint8List _avatarInput(Uint8List bytes) {
  if (!img.PngDecoder().isValidFile(bytes)) return bytes;
  final data = ByteData.sublistView(bytes);
  final out = BytesBuilder(copy: false)..add(bytes.sublist(0, 8));
  var offset = 8;
  for (var count = 0; count < 1024; count++) {
    final (kind, size, end) = _avatarChunk(bytes, offset);
    _checkAvatarChunk(kind, offset, size, data);
    if (const {'IHDR', 'PLTE', 'tRNS', 'IDAT', 'IEND'}.contains(kind)) {
      out.add(bytes.sublist(offset, end));
    }
    if (kind == 'IEND') {
      if (size != 0 || end != bytes.length) {
        throw const FormatException('Повреждённый конец PNG');
      }
      return out.takeBytes();
    }
    offset = end;
  }
  throw const FormatException('Повреждённое PNG-изображение');
}

void _checkAvatarChunk(String kind, int offset, int size, ByteData data) {
  if (const {'acTL', 'fcTL', 'fdAT'}.contains(kind)) {
    throw const FormatException('Выберите статичное изображение');
  }
  if (offset == 8) {
    if (kind != 'IHDR' || size != 13) {
      throw const FormatException('Нет заголовка PNG');
    }
    final width = data.getUint32(16), height = data.getUint32(20);
    if (width < 1 ||
        height < 1 ||
        width > 4096 ||
        height > 4096 ||
        width * height > 4 * 1024 * 1024) {
      throw const FormatException('Изображение превышает 4 миллиона пикселей');
    }
  } else if (kind == 'IHDR') {
    throw const FormatException('Повторный заголовок PNG');
  }
}

(String, int, int) _avatarChunk(Uint8List bytes, int offset) {
  if (offset + 12 > bytes.length) throw const FormatException('Обрыв PNG');
  final size = ByteData.sublistView(bytes).getUint32(offset);
  if (size > bytes.length - offset - 12) {
    throw const FormatException('Обрыв блока PNG');
  }
  return (
    String.fromCharCodes(bytes.sublist(offset + 4, offset + 8)),
    size,
    offset + size + 12,
  );
}
