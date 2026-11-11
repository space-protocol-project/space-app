part of 'document.dart';

typedef ExtensionChoice = ({String value, String label});

class ExtensionField {
  const ExtensionField(
    this.kind,
    this.isRequired,
    this.maxLength,
    this.options,
  );
  final String kind;
  final bool isRequired;
  final int maxLength;
  final List<ExtensionChoice> options;

  Object get initial => kind == 'toggle.v1' ? false : '';

  bool valid(Object? value) => switch (kind) {
    'toggle.v1' => value is bool,
    'input.v1' =>
      value is String &&
          value.runes.length <= maxLength &&
          (!isRequired || value.isNotEmpty),
    'choice.v1' =>
      value is String &&
          ((!isRequired && value.isEmpty) ||
              options.any((item) => item.value == value)),
    _ => false,
  };
}

ExtensionField _field(
  Map<String, dynamic> map,
  String component,
  String Function(Object?) translated,
) {
  final common = {'id', 'component', 'label_key'};
  if (component == 'toggle.v1') {
    object(map, common);
    return const ExtensionField('toggle.v1', false, 0, []);
  }
  if (component == 'input.v1') {
    object(map, {...common, 'required', 'max_length'});
    final limit = map['max_length'];
    if (limit is! int || limit < 1 || limit > 512) {
      throw const FormatException('Размер поля');
    }
    return ExtensionField(component, _required(map), limit, const []);
  }
  if (component == 'choice.v1') {
    object(map, {...common, 'required', 'options'});
    return ExtensionField(
      component,
      _required(map),
      64,
      _choices(map['options'], translated),
    );
  }
  throw const FormatException('Компонент поля');
}

bool _required(Map<String, dynamic> map) {
  final value = map['required'];
  if (value is! bool) throw const FormatException('Обязательность поля');
  return value;
}

List<ExtensionChoice> _choices(
  Object? raw,
  String Function(Object?) translated,
) {
  if (raw is! List || raw.isEmpty || raw.length > 16) {
    throw const FormatException('Варианты поля');
  }
  final values = <String>{};
  final result = <ExtensionChoice>[];
  for (final item in raw) {
    final map = object(item, {'value', 'label_key'});
    final value = identifier(map['value']);
    if (!values.add(value)) throw const FormatException('Повтор варианта');
    result.add((value: value, label: translated(map['label_key'])));
  }
  return List.unmodifiable(result);
}
