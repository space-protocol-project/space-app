import '../generated/space/v1/extensions_p1.pb.dart' as pb;

enum ContributionKind { overview, section }

class ContributionEntry {
  ContributionEntry(this.id, this.kind, Map<String, String> title, this.query)
    : title = Map.unmodifiable(title);
  final String id, query;
  final ContributionKind kind;
  final Map<String, String> title;

  String label(String locale) =>
      title[locale] ?? title[locale.split('-').first] ?? title['en']!;
}

class ContributionRegistry {
  ContributionRegistry._(this.entries, this.digest);
  final List<ContributionEntry> entries;
  final List<int> digest;

  factory ContributionRegistry.parse(pb.ListExtensionContributionsResponse r) {
    if (r.registrySha256.length != 32 || r.contributions.length > 32) {
      throw const FormatException('Неверный реестр расширения');
    }
    final seen = <String>{};
    final entries = <ContributionEntry>[];
    for (final item in r.contributions) {
      if (!_operation.hasMatch(item.id) ||
          !_operation.hasMatch(item.query) ||
          !seen.add(item.id)) {
        throw const FormatException('Неверный элемент расширения');
      }
      _validateTitle(item.title);
      final kind = switch (item.kind) {
        pb.ExtensionContributionKind.EXTENSION_CONTRIBUTION_KIND_OVERVIEW =>
          ContributionKind.overview,
        pb.ExtensionContributionKind.EXTENSION_CONTRIBUTION_KIND_SECTION =>
          ContributionKind.section,
        _ => throw const FormatException('Неизвестный вид элемента'),
      };
      entries.add(ContributionEntry(item.id, kind, item.title, item.query));
    }
    entries.sort((a, b) => a.id.compareTo(b.id));
    return ContributionRegistry._(
      List.unmodifiable(entries),
      List.unmodifiable(r.registrySha256),
    );
  }
}

final _operation = RegExp(r'^[a-z][a-z0-9_.-]{0,63}$');
final _locale = RegExp(r'^[a-z]{2,3}(-[A-Za-z0-9]{2,8})*$');
final _control = RegExp(r'[\x00-\x1f\x7f-\x9f]');

void _validateTitle(Map<String, String> titles) {
  if (!titles.containsKey('en') || titles.isEmpty || titles.length > 8) {
    throw const FormatException('Неверные переводы заголовка');
  }
  for (final MapEntry(:key, :value) in titles.entries) {
    if (!_locale.hasMatch(key) ||
        value.trim().isEmpty ||
        value.runes.length > 120 ||
        _control.hasMatch(value)) {
      throw const FormatException('Неверный заголовок');
    }
  }
}
