import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_runtime.dart';

void main() {
  test('Порядок стабильных и предварительных выпусков runtime', () {
    const ordered = [
      'v0.3.3-alpha',
      'v0.3.3-alpha.1',
      'v0.3.3-alpha.2',
      'v0.3.3-alpha.10',
      'v0.3.3-alpha.beta',
      'v0.3.3-beta',
      'v0.3.3-beta.2',
      'v0.3.3-beta.11',
      'v0.3.3-rc.1',
      'v0.3.3',
      'v0.3.4-alpha',
      'v0.3.4',
      'v0.4.0',
      'v1.0.0',
    ];
    for (var left = 0; left < ordered.length; left++) {
      for (var right = 0; right < ordered.length; right++) {
        expect(
          HomeRelease.isNewerVersion(ordered[left], ordered[right]),
          left > right,
          reason: '${ordered[left]} / ${ordered[right]}',
        );
      }
    }
  });
}
