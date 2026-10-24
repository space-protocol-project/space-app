import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/feed_api.dart';
import '../src/feed_management.dart';
import '../src/generated/space/v1/feed.pb.dart';
import 'feed.dart' show feedError;
import 'forum_moderation.dart';
import 'forum_widgets.dart' show forumDate;

Future<void> showFeedManagement(
  BuildContext context,
  FeedApi api,
  String channel, {
  required String action,
  String post = '',
  void Function(String)? open,
}) async {
  final controller = FeedManagement(api, channel);
  try {
    await showDialog<void>(
      context: context,
      builder: (_) => FeedManagementDialog(
        controller: controller,
        action: action,
        post: post,
        open: open,
      ),
    );
  } finally {
    await controller.close();
  }
}

class FeedManagementDialog extends StatefulWidget {
  const FeedManagementDialog({
    super.key,
    required this.controller,
    required this.action,
    this.post = '',
    this.open,
  });
  final FeedManagement controller;
  final String action, post;
  final void Function(String)? open;
  @override
  State<FeedManagementDialog> createState() => _FeedManagementDialogState();
}

class _FeedManagementDialogState extends State<FeedManagementDialog> {
  final principal = TextEditingController();
  String role = 'member';
  FeedManagement get controller => widget.controller;
  @override
  void initState() {
    super.initState();
    unawaited(load());
  }

  @override
  void dispose() {
    principal.dispose();
    super.dispose();
  }

  Future<bool> load({bool more = false}) => switch (widget.action) {
    'policy' => controller.loadPolicy(),
    'reports' => controller.loadReports(more: more),
    _ => controller.loadLog(widget.post, more: more),
  };
  String title(BuildContext context) => switch (widget.action) {
    'policy' => context.strings.feedPolicy,
    'reports' => context.strings.forumReportsQueue,
    _ => context.strings.forumModerationLog,
  };
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FeedManagement, FeedManagementState>(
        bloc: controller,
        builder: (context, state) => _dialog(state),
      );

  Widget _dialog(FeedManagementState state) => AlertDialog(
    scrollable: true,
    title: Text(title(context)),
    content: SizedBox(width: 640, child: _body(state)),
    actions: _actions(state),
  );
  Widget _body(FeedManagementState state) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (state.busy) const LinearProgressIndicator(),
      if (state.error != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(feedError(context, state.error!)),
        ),
      ...content(state),
    ],
  );
  List<Widget> _actions(FeedManagementState state) => [
    TextButton(
      onPressed: state.busy ? null : () => load(),
      child: Text(context.strings.forumRefresh),
    ),
    if (widget.action == 'policy')
      FilledButton(
        onPressed: state.busy || state.revision == 0 ? null : save,
        child: Text(context.strings.forumApply),
      ),
    TextButton(
      onPressed: state.busy ? null : () => Navigator.pop(context),
      child: Text(context.strings.closeFiles),
    ),
  ];

  List<Widget> content(FeedManagementState state) => switch (widget.action) {
    'policy' => policy(state),
    'reports' => reports(state),
    _ => log(state),
  };
  Future<void> save() async {
    if (await controller.savePolicy() && mounted) Navigator.pop(context);
  }

  List<Widget> policy(FeedManagementState state) => [
    Text(context.strings.feedPolicyHelp),
    const SizedBox(height: 20),
    ...state.rules.asMap().entries.map(
      (entry) => rule(entry.key, entry.value, state.busy),
    ),
    const SizedBox(height: 20),
    DropdownButtonFormField<String>(
      initialValue: role,
      decoration: InputDecoration(labelText: context.strings.feedRole),
      items: [
        DropdownMenuItem(
          value: 'member',
          child: Text(context.strings.feedMemberRole),
        ),
        DropdownMenuItem(
          value: 'reader',
          child: Text(context.strings.feedReaderRole),
        ),
      ],
      onChanged: state.busy
          ? null
          : (value) {
              if (value != null) setState(() => role = value);
            },
    ),
    const SizedBox(height: 16),
    TextField(
      controller: principal,
      enabled: !state.busy,
      decoration: InputDecoration(labelText: context.strings.feedPrincipal),
    ),
    const SizedBox(height: 16),
    TextButton.icon(
      onPressed: state.busy ? null : addRule,
      icon: const Icon(Icons.add),
      label: Text(context.strings.feedAddRule),
    ),
  ];
  void addRule() {
    final id = principal.text.trim();
    final added = FeedAccessRule(
      role: id.isEmpty ? role : '',
      principalId: id,
      permissions: FeedPermissions(),
    );
    final rules =
        controller.state.rules
            .where(
              (r) => r.role != added.role || r.principalId != added.principalId,
            )
            .toList()
          ..add(added);
    controller.rules(rules);
    principal.clear();
  }

  Widget rule(int index, FeedAccessRule rule, bool busy) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                rule.principalId.isEmpty
                    ? roleLabel(rule.role)
                    : rule.principalId,
              ),
            ),
            IconButton(
              onPressed: busy
                  ? null
                  : () => controller.rules(
                      [...controller.state.rules]..removeAt(index),
                    ),
              tooltip: context.strings.feedRemoveRule,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: rule.permissions.publish,
          title: Text(context.strings.feedPublishPermission),
          onChanged: busy ? null : (value) => changeRule(index, publish: value),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: rule.permissions.comment,
          title: Text(context.strings.feedCommentPermission),
          onChanged: busy ? null : (value) => changeRule(index, comment: value),
        ),
        const SizedBox(height: 12),
        const Divider(),
      ],
    ),
  );
  void changeRule(int index, {bool? publish, bool? comment}) {
    final rules = [...controller.state.rules];
    final old = rules[index];
    rules[index] = FeedAccessRule(
      role: old.role,
      principalId: old.principalId,
      permissions: FeedPermissions(
        publish: publish ?? old.permissions.publish,
        comment: comment ?? old.permissions.comment,
      ),
    );
    controller.rules(rules);
  }

  List<Widget> reports(FeedManagementState state) => [
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
      selected: {state.resolved},
      onSelectionChanged: state.busy
          ? null
          : (values) => controller.loadReports(resolved: values.single),
    ),
    const SizedBox(height: 20),
    if (state.reports.isEmpty && !state.busy)
      Text(context.strings.forumReportsEmpty),
    ...state.reports.map((report) => reportItem(report, state)),
    if (state.after > 0)
      TextButton(
        onPressed: state.busy ? null : () => load(more: true),
        child: Text(context.strings.forumMore),
      ),
  ];
  Widget reportItem(FeedReport report, FeedManagementState state) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '#${report.id} · ${report.commentId.isEmpty ? context.strings.feedPost : context.strings.feedComment}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(report.reason),
        const SizedBox(height: 12),
        if (widget.open != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.open!(report.postId);
            },
            child: Text(context.strings.feedOpenPost),
          ),
        if (state.resolved)
          Text(report.decisionReason)
        else
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: state.busy ? null : () => decide(report, 'dismiss'),
                child: Text(context.strings.forumReportDismiss),
              ),
              OutlinedButton(
                onPressed: state.busy ? null : () => decide(report, 'hide'),
                child: Text(context.strings.forumReportHide),
              ),
            ],
          ),
        const SizedBox(height: 12),
        const Divider(),
      ],
    ),
  );
  Future<void> decide(FeedReport report, String decision) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ForumModerationDialog(
        title: decision == 'hide'
            ? context.strings.forumReportHide
            : context.strings.forumReportDismiss,
        notice: context.strings.forumReportDecisionNotice,
        submit: (reason) => controller.resolve(report, decision, reason),
      ),
    );
    if (mounted) await controller.loadReports();
  }

  String roleLabel(String role) => role == 'reader'
      ? context.strings.feedReaderRole
      : context.strings.feedMemberRole;
  String actionLabel(String action) => switch (action) {
    'report_dismiss' => context.strings.forumReportDismiss,
    'report_hide' ||
    'hide' ||
    'hide_comment' => context.strings.forumReportHide,
    'restore_comment' => context.strings.feedRestoreComment,
    'restore' => context.strings.feedRestorePost,
    _ => context.strings.feedActions,
  };

  List<Widget> log(FeedManagementState state) => [
    if (state.log.isEmpty && !state.busy)
      Text(context.strings.forumModerationEmpty),
    ...state.log.map(
      (event) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${actionLabel(event.action)} · ${forumDate(context, event.createdAtUnix.toInt())}',
            ),
            const SizedBox(height: 8),
            Text(event.reason),
            const SizedBox(height: 8),
            Text(event.actorId),
            const Divider(),
          ],
        ),
      ),
    ),
    if (state.after > 0)
      TextButton(
        onPressed: state.busy ? null : () => load(more: true),
        child: Text(context.strings.forumMore),
      ),
  ];
}
