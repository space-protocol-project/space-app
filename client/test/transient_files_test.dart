import 'dart:typed_data';
import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/files.dart';

final class EphemeralFile extends FileSystemXFile {
  EphemeralFile(this.chunks, this.reportedLength) : super('provider-file');
  final List<Uint8List> chunks;
  final int? reportedLength;
  final released = Completer<void>();

  @override
  Future<int?> length() async => reportedLength;

  @override
  Stream<Uint8List> openRead([int? start, int? end]) async* {
    if (released.isCompleted) throw StateError('Источник уже освобождён');
    yield* Stream.fromIterable(chunks);
  }
}

void main() {
  test(
    'Неизвестный размер провайдера определяется ограниченным чтением',
    () async {
      final source = EphemeralFile([
        Uint8List.fromList([4, 5]),
      ], null);
      final queue = AttachmentQueue();
      addTearDown(queue.close);
      await queue.add(
        AttachmentFilesAdded([
          SpaceFile.transient(source, name: 'проверка.bin'),
        ]),
      );
      expect(queue.state.files.single.size, 2);
      expect(await queue.state.files.single.file.readAsBytes(), [4, 5]);
    },
  );
  test(
    'После drop файл доступен независимо от срока жизни провайдера',
    () async {
      final source = EphemeralFile([
        Uint8List.fromList([1, 2, 3]),
      ], 3);
      final queue = AttachmentQueue();
      addTearDown(queue.close);
      await queue.add(
        AttachmentFilesAdded([
          SpaceFile.transient(source, name: 'проверка.txt'),
        ]),
      );
      source.released.complete();
      final saved = queue.state.files.single;
      expect(saved.name, 'проверка.txt');
      expect(await saved.file.readAsBytes(), [1, 2, 3]);
      expect(saved.file.transient, isFalse);
    },
  );

  test(
    'Провайдер не обходит предел размера и не оставляет неполный файл',
    () async {
      for (final source in [
        EphemeralFile([Uint8List(2)], 3),
        EphemeralFile([Uint8List(maxAttachmentSize), Uint8List(1)], 3),
      ]) {
        final queue = AttachmentQueue();
        await queue.add(
          AttachmentFilesAdded([
            SpaceFile.transient(source, name: 'проверка.bin'),
          ]),
        );
        expect(queue.state.files, isEmpty);
        expect(queue.state.problem, isA<StateError>());
        await queue.close();
      }
    },
  );
}
