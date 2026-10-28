import 'directory_validation.dart';

/// Отпечатки предков в порядке возрастания номера ревизии.
/// Данные допустимо использовать только после проверки шифрования архива.
class DirectoryAncestry {
  DirectoryAncestry._(this.firstRevision, this.digests);

  static const maxDigests = 16384;
  final int firstRevision;
  final List<String> digests;

  factory DirectoryAncestry.parse(Object? value, int revision, String parent) {
    final data = directoryMap(value, 'digests,first_revision');
    final first = directoryInt(data['first_revision'], min: 1);
    directoryRequire(first == 1);
    final values = data['digests'];
    directoryRequire(values is List && values.length <= maxDigests);
    final digests = (values as List)
        .map((value) => directoryBytes(value, 32))
        .toList();
    directoryRequire(first + digests.length == revision);
    directoryRequire(digests.isEmpty ? parent.isEmpty : digests.last == parent);
    return DirectoryAncestry._(first, List.unmodifiable(digests));
  }

  bool contains(int revision, String digest) {
    final index = revision - firstRevision;
    return index >= 0 && index < digests.length && digests[index] == digest;
  }

  Map<String, dynamic> append(String digest) {
    directoryBytes(digest, 32);
    directoryRequire(digests.length < maxDigests);
    return {
      'first_revision': firstRevision,
      'digests': [...digests, digest],
    };
  }
}
