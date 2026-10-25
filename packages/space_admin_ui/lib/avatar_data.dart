import 'dart:typed_data';

List<(String, int)>? _pngChunks(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  final chunks = <(String, int)>[];
  var offset = 8;
  for (var count = 0; count < 64; count++) {
    if (offset + 12 > bytes.length) return null;
    final size = data.getUint32(offset);
    if (size > bytes.length - offset - 12) return null;
    chunks.add((
      String.fromCharCodes(bytes.sublist(offset + 4, offset + 8)),
      size,
    ));
    offset += size + 12;
    if (offset == bytes.length) return chunks;
  }
  return null;
}

bool validProfileAvatar(List<int> raw) {
  if (raw.length < 45 || raw.length > 8192) return false;
  const signature = [137, 80, 78, 71, 13, 10, 26, 10];
  for (var i = 0; i < signature.length; i++) {
    if (raw[i] != signature[i]) return false;
  }
  final bytes = Uint8List.fromList(raw),
      data = ByteData.sublistView(Uint8List.fromList(raw));
  final width = data.getUint32(16), height = data.getUint32(20);
  if (width < 1 || height < 1 || width > 256 || height > 256) return false;
  final chunks = _pngChunks(bytes);
  return chunks != null && _profileChunks(chunks);
}

bool _profileChunks(List<(String, int)> chunks) =>
    chunks.length >= 3 &&
    chunks.first == ('IHDR', 13) &&
    chunks.last == ('IEND', 0) &&
    chunks.skip(1).every((chunk) => chunk.$1 != 'IHDR') &&
    chunks.take(chunks.length - 1).every((chunk) => chunk.$1 != 'IEND') &&
    chunks.any((chunk) => chunk.$1 == 'IDAT') &&
    chunks.every(
      (chunk) =>
          const {'IHDR', 'PLTE', 'tRNS', 'IDAT', 'IEND'}.contains(chunk.$1),
    );
