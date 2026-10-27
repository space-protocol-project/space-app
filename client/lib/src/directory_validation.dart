import 'dart:convert';

import 'core.dart' show url64;

const directoryMaxPlain = 4 * 1024 * 1024;
const directoryMaxInteger = 9007199254740991;

void directoryRequire(bool condition) {
  if (!condition) throw const FormatException('Повреждена копия каталога');
}

Map<String, dynamic> directoryMap(Object? value, String fields) {
  directoryRequire(value is Map<String, dynamic>);
  final map = value as Map<String, dynamic>;
  final keys = map.keys.toList()..sort();
  directoryRequire(keys.join(',') == fields);
  return map;
}

String directoryText(Object? value, {int max = 1024}) {
  directoryRequire(value is String);
  final text = value as String;
  directoryRequire(utf8.encode(text).length <= max && !text.contains('\u0000'));
  return text;
}

int directoryInt(Object? value, {int min = 0, int max = directoryMaxInteger}) {
  directoryRequire(value is int);
  final number = value as int;
  directoryRequire(number >= min && number <= max);
  return number;
}

String directoryBytes(Object? value, int length) {
  final text = directoryText(value, max: 128);
  final bytes = base64Url.decode(base64Url.normalize(text));
  directoryRequire(bytes.length == length && url64(bytes) == text);
  return text;
}

String directoryAddress(Object? value) {
  final text = directoryText(value);
  final uri = Uri.parse(text);
  directoryRequire(
    ['http', 'https'].contains(uri.scheme) && uri.host.isNotEmpty,
  );
  directoryRequire(uri.userInfo.isEmpty && !uri.hasQuery && !uri.hasFragment);
  return text;
}
