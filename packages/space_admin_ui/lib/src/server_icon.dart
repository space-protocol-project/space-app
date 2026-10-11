import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as image;
import 'package:xml/xml.dart';

const serverIconPresets = <String, IconData>{
  'orbit': Icons.hub_outlined,
  'planet': Icons.public,
  'leaf': Icons.eco_outlined,
  'star': Icons.star_outline,
  'bolt': Icons.bolt_outlined,
  'rocket': Icons.rocket_launch_outlined,
};
const _svgTags = {
  'svg',
  'g',
  'path',
  'rect',
  'circle',
  'ellipse',
  'line',
  'polyline',
  'polygon',
};
const _svgAttrs = {
  'xmlns',
  'viewBox',
  'width',
  'height',
  'd',
  'fill',
  'stroke',
  'stroke-width',
  'stroke-linecap',
  'stroke-linejoin',
  'fill-rule',
  'clip-rule',
  'cx',
  'cy',
  'r',
  'rx',
  'ry',
  'x',
  'y',
  'x1',
  'y1',
  'x2',
  'y2',
  'points',
  'transform',
  'opacity',
  'fill-opacity',
  'stroke-opacity',
};
bool safeServerSvg(Uint8List bytes) {
  try {
    if (bytes.length > 8192) return false;
    final doc = XmlDocument.parse(utf8.decode(bytes));
    if (doc.children.whereType<XmlElement>().length != 1 ||
        doc.rootElement.name.local != 'svg' ||
        doc.descendants.length > 512)
      return false;
    if (doc.descendants.whereType<XmlProcessing>().any(
      (node) => node.target != 'xml',
    ))
      return false;
    if (doc.descendants.whereType<XmlDoctype>().isNotEmpty ||
        doc.descendants.whereType<XmlText>().any(
          (n) => n.value.trim().isNotEmpty,
        ))
      return false;
    for (final e in doc.descendants.whereType<XmlElement>()) {
      if (!_svgTags.contains(e.name.local) ||
          e.ancestors.whereType<XmlElement>().length >= 16 ||
          (e.name.namespaceUri != null &&
              e.name.namespaceUri != 'http://www.w3.org/2000/svg'))
        return false;
      for (final a in e.attributes) {
        if (!_svgAttrs.contains(a.name.local) ||
            (a.name.prefix != null && a.name.prefix != 'xmlns') ||
            a.value
                .replaceAll(RegExp(r'\s+'), '')
                .toLowerCase()
                .contains('url('))
          return false;
      }
    }
    return true;
  } catch (_) {
    return false;
  }
}

Map<String, dynamic>? validatedServerIcon(Object? value) {
  try {
    if (value is! Map) return null;
    final preset = value['preset'] ?? '',
        mime = value['mediaType'] ?? '',
        data = value['data'] ?? '';
    if (preset is! String ||
        mime is! String ||
        data is! String ||
        data.length > 11000)
      return null;
    if (data.isEmpty)
      return mime.isEmpty && serverIconPresets.containsKey(preset)
          ? {'preset': preset}
          : null;
    if (preset.isNotEmpty) return null;
    final bytes = base64Decode(data);
    if (bytes.length > 8192) return null;
    if (mime == 'image/svg+xml') {
      if (!safeServerSvg(bytes)) return null;
    } else if (mime == 'image/png') {
      if (bytes.length < 24 ||
          bytes[0] != 137 ||
          bytes[1] != 80 ||
          bytes[2] != 78 ||
          bytes[3] != 71)
        return null;
      final header = ByteData.sublistView(bytes);
      final w = header.getUint32(16), h = header.getUint32(20);
      if (w < 1 || h < 1 || w > 256 || h > 256) return null;
    } else {
      return null;
    }
    return {'mediaType': mime, 'data': data};
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> prepareServerIcon(List<Object> input) {
  final bytes = input[0] as Uint8List, svg = input[1] as bool;
  if (svg) {
    if (!safeServerSvg(bytes)) throw const FormatException('Некорректный SVG');
    return {'mediaType': 'image/svg+xml', 'data': base64Encode(bytes)};
  }
  if (bytes.length < 24) throw const FormatException('Некорректный PNG');
  final header = ByteData.sublistView(bytes);
  final w = header.getUint32(16), h = header.getUint32(20);
  if (w < 1 || h < 1 || w > 2048 || h > 2048)
    throw const FormatException('PNG слишком большой');
  final decoded = image.decodePng(bytes);
  if (decoded == null) throw const FormatException('Некорректный PNG');
  for (final size in [64, 48, 32]) {
    final resized = image.copyResize(
      decoded,
      width: size,
      height: size,
      maintainAspect: true,
      interpolation: image.Interpolation.average,
    );
    final png = image.encodePng(resized, level: 9);
    if (png.length <= 8192)
      return {'mediaType': 'image/png', 'data': base64Encode(png)};
  }
  throw const FormatException('Иконка слишком большая');
}

class ServerIconView extends StatelessWidget {
  const ServerIconView({super.key, this.value, this.size = 28});
  final Object? value;
  final double size;
  @override
  Widget build(BuildContext context) {
    final icon = validatedServerIcon(value);
    Widget fallback() => Icon(
      serverIconPresets[icon?['preset']] ?? serverIconPresets['orbit'],
      size: size,
    );
    if (icon?['data'] == null) return fallback();
    final bytes = base64Decode(icon!['data'] as String);
    return ClipRect(
      child: SizedBox.square(
        dimension: size,
        child: icon['mediaType'] == 'image/png'
            ? Image.memory(
                bytes,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => fallback(),
              )
            : SvgPicture.memory(
                theme: SvgTheme(
                  currentColor: Theme.of(context).colorScheme.onSurface,
                ),
                bytes,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => fallback(),
              ),
      ),
    );
  }
}
