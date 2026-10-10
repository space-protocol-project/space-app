import 'dart:io';

import 'package:image/image.dart' as image;

// Только изменение размеров и кодирование утверждённой PNG, без изменения рисунка.
void main() {
  final source = image.decodePng(
    File('../docs/assets/branding/space-app-icon-v3.png').readAsBytesSync(),
  );
  if (source == null || source.width != source.height) {
    throw StateError('Нужна квадратная PNG-иконка');
  }
  final png = image.copyResize(
    source,
    width: 512,
    height: 512,
    interpolation: image.Interpolation.cubic,
  );
  File('assets/branding/space-app-icon.png')
      .writeAsBytesSync(image.encodePng(png));
  for (final size in [16, 32, 64, 128, 256, 512, 1024]) {
    final directory = Directory(
      'macos/Runner/Assets.xcassets/AppIcon.appiconset',
    );
    if (directory.existsSync()) {
      File('${directory.path}/app_icon_$size.png').writeAsBytesSync(
        image.encodePng(
          image.copyResize(
            source,
            width: size,
            height: size,
            interpolation: image.Interpolation.cubic,
          ),
        ),
      );
    }
  }
  File('windows/runner/resources/app_icon.ico').writeAsBytesSync(
    image.IcoEncoder().encodeImages([
      for (final size in [16, 24, 32, 48, 64, 128, 256])
        image.copyResize(
          source,
          width: size,
          height: size,
          interpolation: image.Interpolation.cubic,
        ),
    ]),
  );
}
