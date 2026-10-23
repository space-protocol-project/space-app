import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/forum_api.dart';
import '../src/generated/space/v1/forum.pb.dart';
import 'forum_moderation.dart';
import 'forum_widgets.dart' show forumDate, forumAuthor;

class ForumReportsQueue extends StatefulWidget {
  const ForumReportsQueue({
    super.key,
    required this.api,
    required this.forum,
    required this.channel,
    required this.open,
  });
  final ForumReports api;
  final ForumApi forum;
  final String channel;
  final Future<void> Function(String thread) open;
  @override
  State<ForumReportsQueue> createState() => _ForumReportsQueueState();
}

class _ForumReportsQueueState extends State<ForumReportsQueue> {
  final items = <ForumReport>[];
  var after = Int64.ZERO;
  bool busy = true, failed = false, resolved = false;

  @override
  void initState() {
    super.initState();
    load(reset: true);
  }

  Future<void> load({bool reset = false}) async {
    setState(() {
      busy = true;
      failed = false;
      if (reset) {
        items.clear();
        after = Int64.ZERO;
      }
    });
    try {
      final page = await widget.api.reports(widget.channel, after, resolved);
      if (!mounted) return;
      setState(() {
        items.addAll(page.reports);
        after = page.nextId;
        busy = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        items.clear();
        after = Int64.ZERO;
        busy = false;
        failed = true;
      });
    }
  }

  Future<Int64> revision(ForumReport report) async {
    var cursor = Int64.ZERO;
    do {
      final page = await widget.forum.thread(
        widget.channel,
        report.threadId,
        cursor,
      );
      if (report.replyId.isEmpty) return page.thread.revision;
      for (final reply in page.replies) {
        if (reply.id == report.replyId) return reply.revision;
      }
      cursor = page.nextSequence;
    } while (cursor != Int64.ZERO);
    throw StateError('Ответ недоступен');
  }

  Future<void> decide(ForumReport report, String decision) async {
    var version = Int64.ZERO;
    try {
      if (decision == 'hide') version = await revision(report);
    } catch (_) {
      if (mounted) await load(reset: true);
      return;
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ForumModerationDialog(
        title: decision == 'hide'
            ? context.strings.forumReportHide
            : context.strings.forumReportDismiss,
        notice: context.strings.forumReportDecisionNotice,
        submit: (reason) async {
          await widget.api.resolveReport(
            widget.channel,
            report.id,
            decision,
            reason,
            version,
          );
          return true;
        },
      ),
    );
    if (mounted) await load(reset: true);
  }

  Future<void> open(ForumReport report) async {
    Navigator.pop(context);
    await widget.open(report.threadId);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.forumReportsQueue),
    content: SizedBox(
      width: 640,
      height: 480,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(context.strings.forumReportsPending),
              ),
              ButtonSegment(
                value: true,
                label: Text(context.strings.forumReportsResolved),
              ),
            ],
            selected: {resolved},
            onSelectionChanged: busy
                ? null
                : (value) {
                    resolved = value.single;
                    load(reset: true);
                  },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final report in items) entry(report),
                  if (busy) const LinearProgressIndicator(),
                  if (failed) Text(context.strings.forumDenied),
                  if (!busy && !failed && items.isEmpty)
                    Text(context.strings.forumReportsEmpty),
                  if (!busy && (failed || after != Int64.ZERO))
                    TextButton(
                      onPressed: () => load(),
                      child: Text(context.strings.forumMore),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => load(reset: true),
        child: Text(context.strings.forumRefresh),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.close),
      ),
    ],
  );

  Widget entry(ForumReport report) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '#${report.id} · ${report.replyId.isEmpty ? context.strings.forumReportTopic : context.strings.forumReportReply}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        Text(
          report.threadTitle.isEmpty
              ? context.strings.forumHiddenTopic
              : report.threadTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          forumDate(context, report.createdAtUnix.toInt()),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        SelectableText(report.reason),
        if (report.decision.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(forumModerationLabel(context, 'report_${report.decision}')),
          const SizedBox(height: 6),
          SelectableText(report.decisionReason),
          const SizedBox(height: 6),
          Text(
            '${forumAuthor('', report.moderatorId)} · ${forumDate(context, report.resolvedAtUnix.toInt())} · ${forumDate(context, report.resolvedAtUnix.toInt(), time: true)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: busy ? null : () => open(report),
              child: Text(context.strings.forumReportOpen),
            ),
            if (!resolved) ...[
              TextButton(
                onPressed: busy ? null : () => decide(report, 'dismiss'),
                child: Text(context.strings.forumReportDismiss),
              ),
              OutlinedButton(
                onPressed: busy ? null : () => decide(report, 'hide'),
                child: Text(context.strings.forumReportHide),
              ),
            ],
          ],
        ),
        const Divider(height: 24),
      ],
    ),
  );
}
