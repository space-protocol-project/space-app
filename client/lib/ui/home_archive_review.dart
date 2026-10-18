import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/home_archive_inspection.dart';

Future<bool> confirmHomeArchive(
  BuildContext context,
  HomeArchiveInspection report,
) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => HomeArchiveReview(report: report),
    ) ==
    true;

class HomeArchiveReview extends StatelessWidget {
  const HomeArchiveReview({super.key, required this.report});
  final HomeArchiveInspection report;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.homeArchiveVerified),
    content: SizedBox(
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.verified_outlined, size: 32),
            const SizedBox(height: 16),
            SelectableText(
              context.strings.homeArchiveSummary(
                report.serverId,
                report.schemaVersion,
                report.files,
                (report.unpackedBytes / (1024 * 1024)).toStringAsFixed(1),
              ),
            ),
            const SizedBox(height: 16),
            Text(context.strings.homeArchiveReviewHelp),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(context.strings.close),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(context.strings.homeArchiveRestore),
      ),
    ],
  );
}
