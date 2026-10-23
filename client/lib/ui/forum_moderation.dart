import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/forum.pb.dart';
import 'forum_widgets.dart' show forumDate, forumAuthor;

String forumModerationLabel(BuildContext context, String action) =>
    switch (action) {
      'reopen' => context.strings.forumReopen,
      'hide' => context.strings.forumHideTopic,
      'restore' => context.strings.forumRestoreTopic,
      'hide_reply' => context.strings.forumHideReply,
      'restore_reply' => context.strings.forumRestoreReply,
      _ => context.strings.forumActions,
    };

class ForumModerationDialog extends StatefulWidget {
  const ForumModerationDialog({
    super.key,
    required this.title,
    required this.submit,
  });
  final String title;
  final Future<bool> Function(String reason) submit;
  @override
  State<ForumModerationDialog> createState() => _ForumModerationDialogState();
}

class _ForumModerationDialogState extends State<ForumModerationDialog> {
  final reason = TextEditingController();
  final form = GlobalKey<FormState>();
  bool busy = false, failed = false;
  @override
  void dispose() {
    reason.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (busy || !form.currentState!.validate()) return;
    setState(() {
      busy = true;
      failed = false;
    });
    var success = false;
    try {
      success = await widget.submit(reason.text.trim());
    } catch (_) {
      success = false;
    }
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      busy = false;
      failed = true;
    });
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(context.strings.forumModerationNotice),
                const SizedBox(height: 20),
                TextFormField(
                  key: const ValueKey('forum-moderation-reason'),
                  controller: reason,
                  enabled: !busy,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: context.strings.forumReason,
                  ),
                  validator: (text) =>
                      text == null ||
                          text.trim().isEmpty ||
                          utf8.encode(text).length > 1024
                      ? context.strings.forumReasonRequired
                      : null,
                ),
                if (failed)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      context.strings.forumFailure,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(context.strings.forumCancel),
        ),
        FilledButton(
          onPressed: busy ? null : save,
          child: Text(context.strings.forumApply),
        ),
      ],
    ),
  );
}

class ForumModerationLog extends StatefulWidget {
  const ForumModerationLog({super.key, required this.load});
  final Future<ListForumModerationResponse> Function(Int64 after) load;
  @override
  State<ForumModerationLog> createState() => _ForumModerationLogState();
}

class _ForumModerationLogState extends State<ForumModerationLog> {
  final events = <ForumModerationEvent>[];
  var after = Int64.ZERO;
  bool busy = true, failed = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      busy = true;
      failed = false;
    });
    try {
      final page = await widget.load(after);
      if (!mounted) return;
      setState(() {
        events.addAll(page.events);
        after = page.nextId;
        busy = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          failed = true;
          events.clear();
          after = Int64.ZERO;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.forumModerationLog),
    content: SizedBox(
      width: 560,
      height: 420,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final event in events) _event(context, event),
            if (busy)
              const Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(),
              ),
            if (!busy && events.isEmpty && !failed)
              Text(context.strings.forumModerationEmpty),
            if (failed) Text(context.strings.forumDenied),
            if (!busy && (after != Int64.ZERO || failed))
              TextButton(
                onPressed: load,
                child: Text(context.strings.forumMore),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.close),
      ),
    ],
  );
  Widget _event(BuildContext context, ForumModerationEvent event) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          forumModerationLabel(context, event.action),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          '${forumDate(context, event.createdAtUnix.toInt())} · ${forumDate(context, event.createdAtUnix.toInt(), time: true)} · ${forumAuthor('', event.actorId)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        SelectableText(event.reason),
        if (event.replyId.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              event.replyId,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        const Divider(height: 24),
      ],
    ),
  );
}

class ForumHiddenNotice extends StatelessWidget {
  const ForumHiddenNotice({super.key, this.reply = false, this.action});
  final bool reply;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      children: [
        const Icon(Icons.visibility_off_outlined, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            reply
                ? context.strings.forumHiddenReply
                : context.strings.forumHiddenTopic,
          ),
        ),
        ?action,
      ],
    ),
  );
}
