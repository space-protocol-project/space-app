import 'dart:convert';

// Предварительная проверка сохраняет дубликаты, которые jsonDecode иначе теряет.
Object? extensionJson(List<int> bytes) {
  if (bytes.isEmpty || bytes.length > 16384) {
    throw const FormatException('Размер UI');
  }
  final text = utf8.decode(bytes, allowMalformed: false);
  final reader = _Keys(text);
  reader.value(0);
  reader.space();
  if (reader.offset != text.length) throw const FormatException('Хвост JSON');
  return jsonDecode(text);
}

class _Keys {
  _Keys(this.text);
  final String text;
  int offset = 0;

  void space() {
    while (offset < text.length && ' \t\r\n'.contains(text[offset])) {
      offset++;
    }
  }

  bool take(String symbol) {
    space();
    if (offset >= text.length || text[offset] != symbol) return false;
    offset++;
    return true;
  }

  void need(String symbol) {
    if (!take(symbol)) throw const FormatException('Структура JSON');
  }

  String string() {
    space();
    final start = offset;
    need('"');
    while (offset < text.length) {
      final character = text[offset++];
      if (character == '"') {
        return jsonDecode(text.substring(start, offset)) as String;
      }
      if (character == '\\') offset++;
    }
    throw const FormatException('Строка JSON');
  }

  void value(int depth) {
    if (depth > 8) throw const FormatException('Глубина UI');
    space();
    if (offset >= text.length) throw const FormatException('Пустое значение');
    switch (text[offset]) {
      case '{':
        object(depth);
        return;
      case '[':
        array(depth);
        return;
      case '"':
        string();
        return;
      default:
        scalar();
    }
  }

  void scalar() {
    final start = offset;
    while (offset < text.length && !',]} \t\r\n'.contains(text[offset])) {
      offset++;
    }
    if (start == offset) throw const FormatException('Значение JSON');
    final value = jsonDecode(text.substring(start, offset));
    if (value is num && !value.isFinite) {
      throw const FormatException('Бесконечное число');
    }
  }

  void object(int depth) {
    need('{');
    if (take('}')) return;
    final keys = <String>{};
    do {
      if (!keys.add(string())) throw const FormatException('Повтор ключа');
      need(':');
      value(depth + 1);
    } while (take(','));
    need('}');
  }

  void array(int depth) {
    need('[');
    if (take(']')) return;
    do {
      value(depth + 1);
    } while (take(','));
    need(']');
  }
}
