import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart' show url64;
import 'package:space_client/src/directory_ancestry.dart';

void main() {
  final first = url64(List.filled(32, 1));
  final second = url64(List.filled(32, 2));
  final other = url64(List.filled(32, 3));

  test('Проверяет отметку предка после сокращения истории', () {
    final proof = DirectoryAncestry.parse(
      {
        'first_revision': 1,
        'digests': [first, second],
      },
      3,
      second,
    );
    expect(proof.contains(1, first), isTrue);
    expect(proof.contains(2, second), isTrue);
    expect(proof.contains(1, other), isFalse);
    expect(proof.contains(0, first), isFalse);
    expect(proof.contains(3, second), isFalse);
    expect(proof.append(other)['digests'], [first, second, other]);
  });

  test('Отклоняет неполную, подменённую и неверно оформленную историю', () {
    final cases = [
      {
        'first_revision': 1,
        'digests': [first],
      },
      {
        'first_revision': 1,
        'digests': [first, other],
      },
      {
        'first_revision': 1,
        'digests': [first, 'bad'],
      },
      {
        'first_revision': 2,
        'digests': [first, second],
      },
      {
        'first_revision': 1,
        'digests': [first, second],
        'extra': true,
      },
    ];
    for (final value in cases) {
      expect(
        () => DirectoryAncestry.parse(value, 3, second),
        throwsFormatException,
      );
    }
  });

  test('Не позволяет расширить историю сверх установленного предела', () {
    final proof = DirectoryAncestry.parse(
      {
        'first_revision': 1,
        'digests': List.filled(DirectoryAncestry.maxDigests, first),
      },
      DirectoryAncestry.maxDigests + 1,
      first,
    );
    expect(() => proof.append(second), throwsFormatException);
  });
}
