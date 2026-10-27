import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/directory_archive.dart';
import 'package:space_client/src/directory_document.dart';

import 'fixtures/directory.dart';

const password = 'Unique backup password 🔑';
void main() {
  test(
    'Отдельный случайный DEK и несколько блоков возвращают полный манифест',
    () async {
      final document = directoryDocument(count: 2000);
      final first = await DirectoryArchive.seal(document, password);
      final second = await DirectoryArchive.seal(document, password);
      expect(first, isNot(second));
      expect(first.length, greaterThan(DirectoryArchive.chunkSize));
      expect(
        utf8.decode(first, allowMalformed: true),
        isNot(contains('space.example')),
      );
      expect(
        (await DirectoryArchive.open(first, password)).data,
        document.data,
      );
    },
  );
  test(
    'Неверный пароль, подмена, перестановка, усечение и хвост не выдают данные',
    () async {
      final file = await DirectoryArchive.seal(
        directoryDocument(count: 2000),
        password,
      );
      await expectLater(
        DirectoryArchive.open(file, 'Another secure password'),
        throwsA(anything),
      );
      final damaged = Uint8List.fromList(file);
      damaged[file.length - 1] ^= 1;
      await expectLater(
        DirectoryArchive.open(damaged, password),
        throwsA(anything),
      );
      final header = ByteData.sublistView(
        file,
        DirectoryArchive.magic.length,
        DirectoryArchive.magic.length + 4,
      ).getUint32(0);
      final offset = DirectoryArchive.magic.length + 4 + header + 48;
      final reordered = Uint8List.fromList(file);
      const block = DirectoryArchive.chunkSize + 16;
      reordered.setRange(
        offset,
        offset + block,
        file.sublist(offset + block, offset + block * 2),
      );
      reordered.setRange(
        offset + block,
        offset + block * 2,
        file.sublist(offset, offset + block),
      );
      await expectLater(
        DirectoryArchive.open(reordered, password),
        throwsA(anything),
      );
      await expectLater(
        DirectoryArchive.open(
          Uint8List.fromList(file.sublist(0, file.length - 1)),
          password,
        ),
        throwsFormatException,
      );
      await expectLater(
        DirectoryArchive.open(Uint8List.fromList([...file, 0]), password),
        throwsFormatException,
      );
    },
  );
  test(
    'Неподдерживаемый KDF отвергается, параметры файла ограничены',
    () async {
      final file = await DirectoryArchive.seal(directoryDocument(), password);
      final headerSize = ByteData.sublistView(
        file,
        DirectoryArchive.magic.length,
        DirectoryArchive.magic.length + 4,
      ).getUint32(0);
      final offset = DirectoryArchive.magic.length + 4;
      final changed = Uint8List.fromList(file);
      final header = utf8
          .decode(file.sublist(offset, offset + headerSize))
          .replaceFirst('600000', '900000');
      changed.setRange(offset, offset + headerSize, utf8.encode(header));
      await expectLater(
        DirectoryArchive.open(changed, password),
        throwsFormatException,
      );
      await expectLater(
        DirectoryArchive.seal(directoryDocument(), ''),
        throwsFormatException,
      );
      await expectLater(
        DirectoryArchive.seal(directoryDocument(), ' ' * 20),
        throwsFormatException,
      );
    },
  );
  test(
    'Модель отвергает лишние поля, секреты, дубликаты и настройки вне списка',
    () {
      final valid = directoryDocument().data;
      expect(
        () => DirectoryDocument.parse({...valid, 'deviceSeed': 'secret'}),
        throwsFormatException,
      );
      expect(
        () => DirectoryDocument.parse({
          ...valid,
          'spaces': [directorySpace(), directorySpace()],
        }),
        throwsFormatException,
      );
      expect(
        () => DirectoryDocument.parse({
          ...valid,
          'settings': {...directorySettings(), 'uiScale': 99},
        }),
        throwsFormatException,
      );
      expect(
        () => DirectoryDocument.parse({
          ...valid,
          'spaces': [
            {...directorySpace(), 'rootSeed': 'secret'},
          ],
        }),
        throwsFormatException,
      );
    },
  );
  test('Поток импорта прекращается при превышении размера', () async {
    await expectLater(
      DirectoryArchive.readStream(
        Stream.fromIterable([
          Uint8List(DirectoryArchive.maxFile),
          [1],
        ]),
      ),
      throwsFormatException,
    );
  });
  test('Версия должна быть целой, адрес пространства — каноническим', () {
    final valid = directoryDocument().data;
    expect(
      () => DirectoryDocument.parse({...valid, 'v': 1.0}),
      throwsFormatException,
    );
    expect(
      () => DirectoryDocument.parse({
        ...valid,
        'spaces': [
          {...directorySpace(), 'origin': 'https://space.example/'},
        ],
      }),
      throwsFormatException,
    );
  });
}
