import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

class LinkQrPainter extends CustomPainter {
  LinkQrPainter(String link)
    : matrix = QrImage(
        QrCode(
          payload: QrPayload.fromTypedData(
            Uint8List.fromList(utf8.encode(link)),
          ),
          errorCorrectLevel: QrErrorCorrectLevel.medium,
        ),
      );
  final QrImage matrix;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final cell = size.shortestSide / (matrix.moduleCount + 8);
    final paint = Paint()..color = Colors.black;
    for (var y = 0; y < matrix.moduleCount; y++) {
      for (var x = 0; x < matrix.moduleCount; x++) {
        if (matrix.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH((x + 4) * cell, (y + 4) * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(LinkQrPainter oldDelegate) => true;
}

class SpaceLinkQr extends StatelessWidget {
  const SpaceLinkQr(this.link, {super.key});
  final String link;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 220,
    child: CustomPaint(painter: LinkQrPainter(link)),
  );
}
