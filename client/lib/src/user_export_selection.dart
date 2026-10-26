part of 'user_export.dart';

ExportUserContentRequest userExportSelection(
  String channel,
  String after,
  String before,
) {
  final start = _exportDate(after),
      end = _exportDate(before)?.add(const Duration(days: 1));
  if (start != null && end != null && !start.isBefore(end)) {
    throw const FormatException('Некорректный период');
  }
  return ExportUserContentRequest(
    channelId: channel,
    createdAfterUnixMs: Int64(start?.millisecondsSinceEpoch ?? 0),
    createdBeforeUnixMs: Int64(end?.millisecondsSinceEpoch ?? 0),
  );
}

DateTime? _exportDate(String input) {
  final text = input.trim();
  if (text.isEmpty) return null;
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) {
    throw const FormatException('Нужна дата YYYY-MM-DD');
  }
  final date = DateTime.tryParse('${text}T00:00:00Z');
  if (date == null ||
      date.year < 1970 ||
      date.toIso8601String().substring(0, 10) != text) {
    throw const FormatException('Некорректная дата');
  }
  return date;
}
