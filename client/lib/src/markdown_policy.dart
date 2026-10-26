/// Ограничения разбора недоверенного Markdown; сложный ввод остаётся текстом.
bool canFormatMarkdown(String text) {
  if (text.length > 32768 || '\n'.allMatches(text).length > 256) return false;
  if (RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]').hasMatch(text)) return false;
  if (RegExp(r'[`*_\[\]<>]').allMatches(text).length > 256) return false;
  if (!text.split('\n').every(_boundedMarkdownPrefix)) return false;
  return _boundedMarkdownBrackets(text);
}

bool _boundedMarkdownPrefix(String line) {
  var quotes=0,spaces=0;
  for(final unit in line.codeUnits) {
    if(unit==62) {quotes++;spaces=0;}
    else if(unit==32||unit==9) {spaces+=unit==9?4:1;}
    else {return true;}
    if(quotes>8||spaces>=64) return false;
  }
  return true;
}

bool _boundedMarkdownBrackets(String text) {
  var depth = 0;
  for (final unit in text.codeUnits) {
    if (unit == 91) depth++;
    if (unit == 93 && depth > 0) depth--;
    if (depth > 16) return false;
  }
  return true;
}

Uri? safeMarkdownLink(String? href) {
  if (href == null || href.length > 2048) return null;
  if (RegExp(r'[\x00-\x20\x7f-\x9f\u202a-\u202e\u2066-\u2069]').hasMatch(href)) {
    return null;
  }
  final uri = Uri.tryParse(href);
  if (uri == null ||
      !['http', 'https'].contains(uri.scheme) ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    return null;
  }
  return uri;
}
