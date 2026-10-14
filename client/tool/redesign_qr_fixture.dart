import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:qr/qr.dart';

import '../integration_test/fixtures/space_link.dart';

Future<void> main(List<String> args) async {
  final output = Directory(args.single);
  await output.create(recursive: true);
  final matrix = QrImage(
    QrCode(
      payload: QrPayload.fromTypedData(
        Uint8List.fromList(utf8.encode(deviceQrLink)),
      ),
      errorCorrectLevel: QrErrorCorrectLevel.medium,
    ),
  );
  final size = matrix.moduleCount + 8;
  final svg = StringBuffer(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $size $size" shape-rendering="crispEdges"><rect width="$size" height="$size" fill="white"/>',
  );
  for (var y = 0; y < matrix.moduleCount; y++) {
    for (var x = 0; x < matrix.moduleCount; x++) {
      if (matrix.isDark(y, x)) {
        svg.write('<rect x="${x + 4}" y="${y + 4}" width="1" height="1"/>');
      }
    }
  }
  svg.write('</svg>');
  await File('${output.path}/qr.svg').writeAsString(svg.toString());
  await File('${output.path}/index.html').writeAsString('''
<!doctype html><html lang="ru"><meta charset="utf-8">
<title>Проверка QR Space</title>
<style>body{margin:0;background:#1d2021;color:#eee5cf;font:18px sans-serif;text-align:center;padding:24px}img{width:min(100%,560px);background:white;border-radius:12px}p{max-width:560px;margin:20px auto;line-height:1.5}</style>
<h1>Проверка камеры</h1><img src="qr.svg" alt="Тестовый QR пространства">
<p>Направьте камеру телефона на код. Это тестовая ссылка: подключение к серверу не выполняется.</p>
</html>
''');
}
