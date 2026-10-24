import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:space_admin_ui/space_admin_ui.dart' show ChannelsPanel;

import '../l10n/strings.dart';
import '../src/core.dart';
import '../src/feed_api.dart';
import '../src/feed_controller.dart';
import '../src/feed_management.dart';
import '../src/generated/space/v1/feed.pb.dart';
import '../src/generated/space/v1/space.pb.dart' show Asset;
import 'attachment_widgets.dart';
import 'components.dart';
import 'feed_management.dart';
import 'forum_device_permission.dart';
import 'forum_moderation.dart';
import 'forum_widgets.dart' show forumAuthor, forumDate;
import 'message_composer_controls.dart';
import 'message_input_surface.dart';

String feedError(BuildContext context, Object error) {
  if (error is! GrpcError) return context.strings.forumFailure;
  return switch (error.code) {
    StatusCode.aborted => context.strings.feedConflict,
    StatusCode.permissionDenied ||
    StatusCode.notFound ||
    StatusCode.unauthenticated => context.strings.feedDenied,
    StatusCode.unimplemented => context.strings.feedUpdateRuntime,
    StatusCode.failedPrecondition => context.strings.feedWriteUnavailable,
    StatusCode.invalidArgument => context.strings.feedInvalidText,
    _ => context.strings.forumFailure,
  };
}

class FeedView extends StatefulWidget {
  const FeedView({
    super.key,
    required this.session,
    required this.active,
    this.sendWithShift = false,
  });
  final SpaceSession? session;
  final bool active, sendWithShift;
  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  bool visited = false;
  @override
  Widget build(BuildContext context) {
    visited = visited || widget.active;
    if (!visited) return const SizedBox.shrink();
    final session = widget.session;
    if (session == null) {
      return PageBody(
        title: context.strings.feedTitle,
        description: context.strings.feedDescription,
        children: [Text(context.strings.feedConnectFirst)],
      );
    }
    return FeedArea(
      key: ObjectKey(session),
      api: SessionFeedApi(session),
      active: widget.active,
      sendWithShift: widget.sendWithShift,
      authorize: session.record.administrative
          ? null
          : () => authorizeForumDevice(context, session),
      manage: session.canManageSpace
          ? () => showDialog<void>(
              context: context,
              builder: (context) => Dialog(
                child: SizedBox(
                  width: 760,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            tooltip: context.strings.forumBack,
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        ChannelsPanel(call: session.adminRequest, feed: true),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class FeedArea extends StatefulWidget {
  const FeedArea({
    super.key,
    required this.api,
    this.active = true,
    this.sendWithShift = false,
    this.manage,
    this.authorize,
  });
  final FeedApi api;
  final bool active, sendWithShift;
  final Future<void> Function()? manage, authorize;
  @override
  State<FeedArea> createState() => _FeedAreaState();
}

class _FeedAreaState extends State<FeedArea> with WidgetsBindingObserver {
  late final controller = FeedController(widget.api);
  Timer? timer;
  bool foreground = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    foreground =
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.paused;
    unawaited(controller.refresh());
    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (widget.active && foreground) unawaited(controller.refresh());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground = state == AppLifecycleState.resumed;
  }

  @override
  void didUpdateWidget(covariant FeedArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active) unawaited(controller.refresh());
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(controller.close());
    super.dispose();
  }

  Future<void> managed(Future<void> Function()? operation) async {
    await operation?.call();
    if (mounted) await controller.refresh();
  }

  Future<void> reason(
    String title,
    Future<bool> Function(String) submit, {
    String? notice,
  }) => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        ForumModerationDialog(title: title, submit: submit, notice: notice),
  );
  Future<void> report([FeedComment? comment]) async {
    final state = controller.state;
    final management = FeedManagement(widget.api, state.section!.id);
    try {
      await reason(
        context.strings.forumReport,
        (text) => management.report(state.post!.id, comment?.id ?? '', text),
        notice: context.strings.forumReportNotice,
      );
    } finally {
      await management.close();
    }
  }

  Future<void> moderate([FeedComment? comment]) {
    final hidden = comment?.hidden ?? controller.state.post!.hidden;
    final restore = comment == null
        ? context.strings.feedRestorePost
        : context.strings.feedRestoreComment;
    return reason(
      hidden ? restore : context.strings.forumReportHide,
      (text) => controller.moderate(comment: comment, reason: text),
    );
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<FeedController, FeedState>(
    bloc: controller,
    builder: (context, state) => PopScope(
      canPop: !widget.active || state.post == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && widget.active && !state.busy) controller.back();
      },
      child: _page(state),
    ),
  );

  Widget _page(FeedState state) => PageBody(
    title: context.strings.feedTitle,
    description: context.strings.feedDescription,
    children: [
      Text(context.strings.feedPrivacy),
      const SizedBox(height: 16),
      _toolbar(state),
      const SizedBox(height: 16),
      ..._status(state),
      ..._content(state),
    ],
  );

  Widget _toolbar(FeedState state) => Wrap(
    spacing: 12,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      if (state.sections.isNotEmpty)
        DropdownButton<String>(
          value: state.section?.id,
          items: state.sections
              .map(
                (c) => DropdownMenuItem(
                  value: c.id,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(c.title, overflow: TextOverflow.ellipsis),
                  ),
                ),
              )
              .toList(),
          onChanged: state.busy || state.loading
              ? null
              : (id) => unawaited(
                  controller.select(
                    state.sections.firstWhere((c) => c.id == id),
                  ),
                ),
        ),
      IconButton(
        onPressed: state.loading || state.busy ? null : controller.refresh,
        tooltip: context.strings.forumRefresh,
        icon: const Icon(Icons.refresh),
      ),
      if (widget.manage != null)
        TextButton(
          onPressed: () => managed(widget.manage),
          child: Text(context.strings.feedSections),
        ),
      if (widget.authorize != null)
        TextButton(
          onPressed: () => managed(widget.authorize),
          child: Text(context.strings.forumAuthorizeDevice),
        ),
      if (state.section?.permissions.manage == true) _management(state),
    ],
  );
  Widget _management(FeedState state) => PopupMenuButton<String>(
    tooltip: context.strings.feedActions,
    itemBuilder: (_) => [
      PopupMenuItem(value: 'policy', child: Text(context.strings.feedPolicy)),
      PopupMenuItem(
        value: 'reports',
        child: Text(context.strings.forumReportsQueue),
      ),
    ],
    onSelected: (action) => managed(
      () => showFeedManagement(
        context,
        widget.api,
        state.section!.id,
        action: action,
        open: (id) => unawaited(controller.open(id)),
      ),
    ),
  );
  List<Widget> _status(FeedState state) {
    final widgets = <Widget>[];
    if (state.loading) widgets.add(const LinearProgressIndicator());
    if (state.error != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(feedError(context, state.error!)),
        ),
      );
    }
    if (!state.loading && !state.supported) {
      widgets.add(Text(context.strings.feedUpdateRuntime));
    }
    if (state.supported && state.section == null) {
      widgets.add(Text(context.strings.feedEmptySections));
    }
    return widgets;
  }

  List<Widget> _content(FeedState state) {
    if (state.section == null || !state.supported) return [];
    if (state.post != null) return _discussion(state);
    return _postList(state);
  }

  List<Widget> _postList(FeedState state) => [
    if (state.posts.isEmpty && !state.loading) Text(context.strings.feedEmpty),
    for (final post in state.posts) _post(post, open: true),
    if (state.before > 0)
      TextButton(
        onPressed: state.loading ? null : controller.more,
        child: Text(context.strings.forumMore),
      ),
    const SizedBox(height: 24),
    if (state.permissions?.publish == true)
      _composer()
    else
      Text(context.strings.feedReadOnly),
  ];

  List<Widget> _discussion(FeedState state) => [
    TextButton.icon(
      onPressed: state.busy ? null : controller.back,
      icon: const Icon(Icons.arrow_back),
      label: Text(context.strings.feedBack),
    ),
    const SizedBox(height: 12),
    _post(state.post!, open: false),
    ...state.comments.map(_comment),
    if (state.after > 0)
      TextButton(
        onPressed: state.loading ? null : controller.more,
        child: Text(context.strings.forumMore),
      ),
    const SizedBox(height: 24),
    if (!state.post!.hidden && state.permissions?.comment == true) _composer(),
  ];
  Widget _post(FeedPost post, {required bool open}) => FeedEntryCard(
    key: ValueKey('feed-post-${post.id}'),
    text: post.text,
    author: forumAuthor(post.authorName, post.authorId),
    timestamp: post.createdAtUnix.toInt(),
    hidden: post.hidden,
    hiddenText: context.strings.feedHiddenPost,
    assets: post.attachments,
    session: widget.api.attachmentSession,
    actions: open
        ? TextButton(
            onPressed: () => controller.open(post.id),
            child: Text(
              '${context.strings.feedComments} · ${post.commentCount}',
            ),
          )
        : _postActions(post),
  );
  Widget _postActions(FeedPost post) => Wrap(
    spacing: 12,
    runSpacing: 8,
    children: [
      if (!post.hidden)
        TextButton(
          onPressed: controller.state.busy ? null : report,
          child: Text(context.strings.forumReport),
        ),
      if (controller.state.section?.permissions.manage == true)
        TextButton(
          onPressed: controller.state.busy ? null : moderate,
          child: Text(
            post.hidden
                ? context.strings.feedRestorePost
                : context.strings.forumReportHide,
          ),
        ),
      if (controller.state.section?.permissions.manage == true)
        TextButton(
          onPressed: () => showFeedManagement(
            context,
            widget.api,
            controller.state.section!.id,
            action: 'log',
            post: post.id,
          ),
          child: Text(context.strings.forumModerationLog),
        ),
    ],
  );
  Widget _comment(FeedComment comment) => FeedEntryCard(
    key: ValueKey('feed-comment-${comment.id}'),
    text: comment.text,
    author: forumAuthor(comment.authorName, comment.authorId),
    timestamp: comment.createdAtUnix.toInt(),
    hidden: comment.hidden,
    hiddenText: context.strings.feedHiddenComment,
    assets: comment.attachments,
    session: widget.api.attachmentSession,
    actions: Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (!comment.hidden)
          TextButton(
            onPressed: controller.state.busy ? null : () => report(comment),
            child: Text(context.strings.forumReport),
          ),
        if (controller.state.section?.permissions.manage == true)
          TextButton(
            onPressed: controller.state.busy ? null : () => moderate(comment),
            child: Text(
              comment.hidden
                  ? context.strings.feedRestoreComment
                  : context.strings.forumReportHide,
            ),
          ),
      ],
    ),
  );
  Widget _composer() => FeedComposer(
    key: ObjectKey(controller.draft()),
    draft: controller.draft(),
    sendWithShift: widget.sendWithShift,
  );
}

class FeedEntryCard extends StatelessWidget {
  const FeedEntryCard({
    super.key,
    required this.text,
    required this.author,
    required this.timestamp,
    required this.hidden,
    required this.hiddenText,
    required this.assets,
    required this.session,
    required this.actions,
  });
  final String text, author, hiddenText;
  final int timestamp;
  final bool hidden;
  final List<Asset> assets;
  final AttachmentSession? session;
  final Widget actions;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hidden)
            Text(
              '$author · ${forumDate(context, timestamp)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          const SizedBox(height: 12),
          SelectableText(hidden ? hiddenText : text),
          for (final asset in assets)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: AttachmentCard(asset: asset, session: session),
            ),
          const SizedBox(height: 16),
          actions,
        ],
      ),
    ),
  );
}

class FeedComposer extends StatefulWidget {
  const FeedComposer({
    super.key,
    required this.draft,
    this.sendWithShift = false,
  });
  final FeedDraftCubit draft;
  final bool sendWithShift;
  @override
  State<FeedComposer> createState() => _FeedComposerState();
}

class _FeedComposerState extends State<FeedComposer> {
  late final text = TextEditingController(text: widget.draft.state.text)
    ..addListener(changed);
  void changed() => widget.draft.change(text.text);
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<FeedDraftCubit, FeedDraftState>(
        bloc: widget.draft,
        listener: (_, state) {
          if (text.text != state.text) text.text = state.text;
        },
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AttachmentComposer(
              queue: widget.draft.queue,
              session: widget.draft.api.attachmentSession,
            ),
            MessageInputSurface(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Focus(
                    canRequestFocus: false,
                    onKeyEvent: (_, event) => messageDraftKeyEvent(
                      event,
                      text,
                      sendWithShift: widget.sendWithShift,
                      maxLength: 8192,
                      send: () => unawaited(widget.draft.send()),
                    ),
                    child: MessageDraftField(
                      fieldKey: const ValueKey('feed-text'),
                      controller: text,
                      enabled: !state.busy,
                      maxLength: 8192,
                      hint: context.strings.messageHint,
                    ),
                  ),
                  MessageComposerActions(
                    controller: text,
                    enabled: !state.busy,
                    send: widget.draft.send,
                    queue: widget.draft.queue,
                    canAttach: widget.draft.api.attachmentsEnabled,
                    sendKey: const ValueKey('feed-send'),
                  ),
                ],
              ),
            ),
            if (state.failed)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(context.strings.feedSendFailed),
              ),
          ],
        ),
      );
}
