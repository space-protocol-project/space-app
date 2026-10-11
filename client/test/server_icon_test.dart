import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/src/preferences.dart';

void main() {
  test('SVG не содержит активного содержимого и внешних ссылок', () {
    expect(
      safeServerSvg(
        Uint8List.fromList(
          utf8.encode(
            '<svg xmlns="http://www.w3.org/2000/svg"><path d="M0 0L24 24"/></svg>',
          ),
        ),
      ),
      true,
    );
    for (final svg in [
      '<svg><script/></svg>',
      '<svg><image href="https://example.org"/></svg>',
      '<svg onload="go()"/>',
      '<!DOCTYPE svg><svg/>',
      '<svg><path fill="url(https://example.org)"/></svg>',
    ]) {
      expect(safeServerSvg(Uint8List.fromList(utf8.encode(svg))), false);
    }
  });
  test('PNG уменьшается и сохраняет прозрачность', () {
    final source = img.Image(width: 512, height: 256, numChannels: 4);
    img.fill(source, color: img.ColorRgba8(100, 200, 30, 128));
    final icon = prepareServerIcon([img.encodePng(source), false]);
    final bytes = base64Decode(icon['data'] as String);
    expect(bytes.length, lessThanOrEqualTo(8192));
    final result = img.decodePng(bytes)!;
    expect(result.width, lessThanOrEqualTo(64));
    expect(result.height, lessThanOrEqualTo(64));
    expect(result.getPixel(result.width ~/ 2, result.height ~/ 2).a, 128);
  });
  test('Кэш иконок изолирован по серверу и переживает перезапуск', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferences();
    await prefs.load();
    await prefs.remember('https://a.example');
    await prefs.remember('https://b.example');
    await prefs.cacheServerIcon('https://a.example', {'preset': 'star'});
    await prefs.cacheServerIcon('https://b.example', {'preset': 'leaf'});
    await prefs.cacheServerIcon('https://evil.example', {'preset': 'rocket'});
    final restored = AppPreferences();
    await restored.load();
    expect(restored.serverIcons['https://a.example']?['preset'], 'star');
    expect(restored.serverIcons['https://b.example']?['preset'], 'leaf');
    expect(restored.serverIcons.containsKey('https://evil.example'), false);
    prefs.dispose();
    restored.dispose();
  });
}
