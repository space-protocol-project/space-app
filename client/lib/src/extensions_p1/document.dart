import 'strict_json.dart';
part 'form_document.dart';

class ExtensionNode {
  const ExtensionNode(
    this.id,
    this.component,
    this.label,
    this.command,
    this.children, {
    this.field,
  });
  final String id, component, label, command;
  final List<ExtensionNode> children;
  final ExtensionField? field;
}

class ExtensionDocument {
  const ExtensionDocument(this.body, this.strings);
  final List<ExtensionNode> body;
  final Map<String, Map<String, String>> strings;

  String text(String locale, String key) =>
      strings[locale]?[key] ?? strings['en']![key]!;

  static ExtensionDocument parse(List<int> bytes, Set<String> commands) {
    final root = object(extensionJson(bytes), {'ui_api', 'body', 'strings'});
    if (root['ui_api'] != 'space.ui.p1') {
      throw const FormatException('Версия UI');
    }
    final strings = _strings(root['strings']);
    final parser = _Nodes(commands, strings);
    return ExtensionDocument(parser.list(root['body'], 0), strings);
  }

  static Map<String, Map<String, String>> _strings(Object? value) {
    final languages = object(value, {'en', 'ru'});
    if (!languages.containsKey('en')) {
      throw const FormatException('Нет fallback en');
    }
    final result = <String, Map<String, String>>{};
    for (final entry in languages.entries) {
      if (entry.value is! Map<String, dynamic>) {
        throw const FormatException('Переводы');
      }
      final map = entry.value as Map<String, dynamic>;
      if (map.length > 64) throw const FormatException('Число переводов');
      result[entry.key] = Map.unmodifiable(
        map.map((key, value) => MapEntry(identifier(key), label(value))),
      );
    }
    return Map.unmodifiable(result);
  }
}

Map<String, dynamic> object(Object? value, Set<String> allowed) {
  if (value is! Map<String, dynamic> ||
      value.keys.any((key) => !allowed.contains(key))) {
    throw const FormatException('Поля UI');
  }
  return value;
}

String identifier(Object? value) {
  if (value is! String ||
      !RegExp(r'^[a-z][a-z0-9_.-]{0,63}$').hasMatch(value)) {
    throw const FormatException('Идентификатор UI');
  }
  return value;
}

String label(Object? value) {
  if (value is! String || value.isEmpty || value.runes.length > 512) {
    throw const FormatException('Текст UI');
  }
  return value;
}

class _Nodes {
  _Nodes(this.commands, this.strings);
  final Set<String> commands;
  final Map<String, Map<String, String>> strings;
  final ids = <String>{};
  int count = 0;

  List<ExtensionNode> list(Object? value, int depth, {bool inForm = false}) {
    if (value is! List || value.isEmpty || value.length > 32) {
      throw const FormatException('Список UI');
    }
    return List.unmodifiable(
      value.map((item) => node(item, depth, inForm: inForm)),
    );
  }

  ExtensionNode node(Object? value, int depth, {bool inForm = false}) {
    if (++count > 64 || depth > 4) throw const FormatException('Бюджет UI');
    final map = object(value, {
      'id',
      'component',
      'label_key',
      'command',
      'children',
      'required',
      'fallback',
      'max_length',
      'options',
    });
    final id = identifier(map['id']);
    if (!ids.add(id)) throw const FormatException('Повтор ID');
    final component = identifier(map['component']);
    if (inForm) return field(map, id, component);
    if ({'input.v1', 'toggle.v1', 'choice.v1'}.contains(component)) {
      throw const FormatException('Поле вне формы');
    }
    if (component == 'form.v1') return form(map, id, depth);
    if (!{'section.v1', 'text.v1', 'button.v1'}.contains(component)) {
      return fallback(map, depth);
    }
    return known(map, id, component, depth);
  }

  ExtensionNode form(Map<String, dynamic> map, String id, int depth) {
    object(map, {'id', 'component', 'label_key', 'command', 'children'});
    final command = identifier(map['command']);
    if (!commands.contains(command)) {
      throw const FormatException('Команда формы');
    }
    final children = list(map['children'], depth + 1, inForm: true);
    if (children.length > 16) throw const FormatException('Число полей формы');
    return ExtensionNode(
      id,
      'form.v1',
      translated(map['label_key']),
      command,
      children,
    );
  }

  ExtensionNode field(Map<String, dynamic> map, String id, String component) {
    final field = _field(map, component, translated);
    return ExtensionNode(
      id,
      component,
      translated(map['label_key']),
      '',
      const [],
      field: field,
    );
  }

  String translated(Object? value) {
    final key = identifier(value);
    if (!strings['en']!.containsKey(key)) {
      throw const FormatException('Нет текста');
    }
    return key;
  }

  ExtensionNode fallback(Map<String, dynamic> map, int depth) {
    object(map, {'id', 'component', 'required', 'fallback'});
    if (map['required'] != false || !map.containsKey('fallback')) {
      throw const FormatException('Компонент не поддерживается');
    }
    return node(map['fallback'], depth + 1);
  }

  ExtensionNode known(
    Map<String, dynamic> map,
    String id,
    String component,
    int depth,
  ) {
    final allowed = switch (component) {
      'section.v1' => {'id', 'component', 'label_key', 'children'},
      'button.v1' => {'id', 'component', 'label_key', 'command'},
      _ => {'id', 'component', 'label_key'},
    };
    object(map, allowed);
    final key = identifier(map['label_key']);
    if (!strings['en']!.containsKey(key)) {
      throw const FormatException('Нет текста');
    }
    final command = component == 'button.v1' ? identifier(map['command']) : '';
    if (command.isNotEmpty && !commands.contains(command)) {
      throw const FormatException('Команда не разрешена');
    }
    final children = component == 'section.v1'
        ? list(map['children'], depth + 1)
        : const <ExtensionNode>[];
    return ExtensionNode(id, component, key, command, children);
  }
}
