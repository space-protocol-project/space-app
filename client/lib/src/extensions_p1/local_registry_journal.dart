import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'local_registry_codec.dart';

class RegistryJournal {
  RegistryJournal._(this._file, this._path);
  final RandomAccessFile _file;
  final String _path;
  static final _owned = <String>{};

  static RegistryJournal open(String path) {
    final file = File(path);
    file.parent.createSync(recursive: true);
    // Реестр создаётся в закрытом каталоге приложения, не по пути гостя.
    if (!file.existsSync()) file.createSync();
    final canonical = file.resolveSymbolicLinksSync();
    if (!_owned.add(canonical)) throw StateError('registry_already_open');
    RandomAccessFile? handle;
    try {
      handle = file.openSync(mode: FileMode.append);
      handle.lockSync(FileLock.exclusive);
      return RegistryJournal._(handle, canonical);
    } catch (_) {
      handle?.closeSync();
      _owned.remove(canonical);
      rethrow;
    }
  }

  RegistrySnapshot read(String scope) {
    final length = _file.lengthSync();
    if (length > registryJournalLimit) {
      throw const FormatException('journal_limit');
    }
    _file.setPositionSync(0);
    final bytes = _file.readSync(length);
    if (bytes.length != length)
      throw const FormatException('journal_short_read');
    final last = bytes.lastIndexOf(10);
    final complete = bytes.sublist(0, last + 1);
    var current = RegistrySnapshot.initial(scope);
    for (final line in utf8.decode(complete).split('\n')) {
      if (line.isEmpty) continue;
      current = _decodeLine(line, current, scope);
    }
    // Незавершённый последний кадр не является COMMIT.
    if (last + 1 != length) {
      _file.truncateSync(last + 1);
      _file.flushSync();
    }
    _file.setPositionSync(last + 1);
    return current;
  }

  RegistrySnapshot _decodeLine(
    String line,
    RegistrySnapshot current,
    String scope,
  ) {
    if (utf8.encode(line).length + 1 > registryFrameLimit || line.length < 66) {
      throw const FormatException('registry_frame');
    }
    final raw = line.substring(65);
    final digest = sha256.convert(utf8.encode(raw)).toString();
    if (line[64] != ' ' || line.substring(0, 64) != digest) {
      throw const FormatException('registry_checksum');
    }
    final next = RegistrySnapshot.decode(raw, scope);
    final previous = sha256.convert(utf8.encode(current.encode())).toString();
    if (next.revision != current.revision + 1 || next.previous != previous) {
      throw const FormatException('registry_chain');
    }
    return next;
  }

  void append(RegistrySnapshot snapshot, void Function(String)? checkpoint) {
    final raw = snapshot.encode();
    final digest = sha256.convert(utf8.encode(raw)).toString();
    final frame = utf8.encode('$digest $raw\n');
    if (frame.length > registryFrameLimit ||
        _file.lengthSync() + frame.length > registryJournalLimit) {
      throw StateError('registry_full');
    }
    checkpoint?.call('before');
    final middle = frame.length ~/ 2;
    _file.writeFromSync(frame, 0, middle);
    checkpoint?.call('partial');
    _file.writeFromSync(frame, middle);
    _file.flushSync();
    checkpoint?.call('after');
  }

  void close() {
    try {
      _file.closeSync();
    } finally {
      _owned.remove(_path);
    }
  }
}
