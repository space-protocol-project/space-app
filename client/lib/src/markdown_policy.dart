/// Ограничения разбора недоверенного Markdown; сложный ввод остаётся текстом.
bool canFormatMarkdown(String text) {
  if (text.length>32768 || '\n'.allMatches(text).length>256) return false;
  if (RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]').hasMatch(text)) return false;
  if (RegExp(r'[`*_\[\]<>]').allMatches(text).length>256) return false;
  if (RegExp(r'^(?:[ \t]*>[ \t]*){9}|^ {64}|^\t{16}',multiLine:true).hasMatch(text)) return false;
  return _boundedMarkdownBrackets(text);
}

bool _boundedMarkdownBrackets(String text) {
  var depth=0;
  for (final unit in text.codeUnits) {
    if (unit==91) depth++;
    if (unit==93 && depth>0) depth--;
    if (depth>16) return false;
  }
  return true;
}

Uri? safeMarkdownLink(String? href) {
  if (href==null||href.length>2048) return null;
  if (RegExp(r'[\x00-\x20\x7f-\x9f\u202a-\u202e\u2066-\u2069]').hasMatch(href)) return null;
  final uri=Uri.tryParse(href);
  if (uri==null||!['http','https'].contains(uri.scheme)||uri.host.isEmpty||uri.userInfo.isNotEmpty) return null;
  return uri;
}
