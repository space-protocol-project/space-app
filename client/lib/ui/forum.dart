import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:space_admin_ui/space_admin_ui.dart'
    show ChannelsPanel, SpaceContentInsets;

import '../l10n/strings.dart';
import '../src/core.dart';
import '../src/forum_api.dart';
import '../src/forum_controller.dart';
import '../src/generated/space/v1/forum.pb.dart' show ForumReply;
import '../src/generated/space/v1/space.pb.dart' show Asset;
import 'components.dart';
import 'forum_composer.dart';
import 'forum_device_permission.dart';
import 'forum_widgets.dart';
import 'forum_read_tracker.dart';
import 'forum_moderation.dart';
import 'forum_reports.dart';
import 'page_transition.dart';

class ForumView extends StatefulWidget {
  const ForumView({
    super.key,
    required this.session,
    this.active = true,
    this.sendWithShift = false,
    this.sectionId,
  });
  final SpaceSession? session;
  final String? sectionId;
  final bool active, sendWithShift;
  @override
  State<ForumView> createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  bool visited = false;
  @override
  Widget build(BuildContext context) {
    visited = visited || widget.active;
    if (!visited) return const SizedBox.shrink();
    final connected = widget.session;
    if (connected == null) {
      return PageBody(
        title: context.strings.forumTitle,
        description: context.strings.forumDescription,
        children: [Text(context.strings.forumConnectFirst)],
      );
    }
    return ForumArea(
      key: ObjectKey(connected),
      api: SessionForumApi(connected),
      sectionId: widget.sectionId,
      sendWithShift: widget.sendWithShift,
      active: widget.active,
      authorize: connected.record.administrative
          ? null
          : () => authorizeForumDevice(context, connected),
      manage: connected.canManageSpace
          ? () => _manage(context, connected)
          : null,
    );
  }

  Future<void> _manage(BuildContext context, SpaceSession connected) =>
      showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: SizedBox(
            width: 760,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: context.strings.forumBack,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  ChannelsPanel(call: connected.adminRequest, forum: true),
                ],
              ),
            ),
          ),
        ),
      );
}

class ForumArea extends StatefulWidget {
  const ForumArea({
    super.key,
    required this.api,
    this.manage,
    this.authorize,
    this.active = true,
    this.sendWithShift = false,
    this.sectionId,
  });
  final ForumApi api;
  final String? sectionId;
  final bool sendWithShift, active;
  final Future<void> Function()? manage, authorize;
  @override
  State<ForumArea> createState() => _ForumAreaState();
}

class _ForumAreaState extends State<ForumArea> with WidgetsBindingObserver {
  final readTracker = ForumReadTracker();
  Timer? synchronization;
  bool foreground = true, authorizing = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground = state == AppLifecycleState.resumed;
    if (foreground && widget.active) unawaited(controller.synchronize());
  }

  late final controller = ForumController(widget.api);
  @override
  void initState() {
    super.initState();
    unawaited(loadSection());
    foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    synchronization = Timer.periodic(const Duration(seconds: 10), (_) {
      if (widget.active && foreground) unawaited(controller.synchronize());
    });
  }

  Future<void> loadSection() async {
    await controller.refresh();
    if (!mounted) return;
    final section = controller.state.sections
        .where((value) => value.id == widget.sectionId)
        .firstOrNull;
    if (section != null && section.id != controller.state.section?.id) {
      await controller.selectSection(section);
    }
  }

  @override
  void didUpdateWidget(covariant ForumArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) unawaited(controller.synchronize());
  }

  @override
  void dispose() {
    synchronization?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(controller.close());
    super.dispose();
  }

  Future<void> manage() async {
    await widget.manage!();
    if (mounted) await controller.refresh();
  }

  Future<void> create() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.forumNewTopic),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: ForumComposer(
              sendWithShift: widget.sendWithShift,
              newTopic: true,
              session: media?.attachmentSession,
              attachmentsEnabled: media?.attachmentsEnabled ?? false,
              channelId: controller.state.section!.id,
              submit: (title, text, key, attachments) async {
                final success = await controller.create(
                  title,
                  text,
                  key,
                  attachments,
                );
                if (success && context.mounted) Navigator.pop(context);
                return success;
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.strings.forumCancel),
          ),
        ],
      ),
    );
  }

  Future<void> closeTopic() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.forumClose),
        content: Text(context.strings.forumCloseConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.forumCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.forumClose),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) await controller.closeTopic();
  }

  String errorText(Object error) {
    if (error is! GrpcError) return context.strings.forumFailure;
    return switch (error.code) {
      StatusCode.aborted => context.strings.forumConflict,
      StatusCode.permissionDenied ||
      StatusCode.notFound ||
      StatusCode.unauthenticated => context.strings.forumDenied,
      StatusCode.failedPrecondition => context.strings.forumWriteUnavailable,
      StatusCode.unimplemented => context.strings.forumUpdateRuntime,
      StatusCode.invalidArgument => context.strings.forumInvalidText,
      _ => context.strings.forumFailure,
    };
  }

  ForumMedia? get media =>
      widget.api is ForumMedia ? widget.api as ForumMedia : null;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ForumController, ForumState>(
        bloc: controller,
        builder: (context, state) => LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1000;
            final padding = constraints.maxWidth < 600 ? 18.0 : 28.0;
            readTracker.select(state.topic?.id ?? '');
            readTracker.schedule(
              context,
              () => widget.active && foreground && !controller.state.busy,
              (sequence) => unawaited(controller.markVisible(sequence)),
            );
            return NotificationListener<ScrollNotification>(
              onNotification: (_) {
                readTracker.schedule(
                  context,
                  () => widget.active && foreground && !controller.state.busy,
                  (sequence) => unawaited(controller.markVisible(sequence)),
                );
                return false;
              },
              child: SingleChildScrollView(
                key: readTracker.viewport,
                primary: false,
                padding: EdgeInsets.fromLTRB(
                  padding,
                  24 + SpaceContentInsets.topOf(context),
                  padding,
                  28,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _heading(state),
                        if (state.busy)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: LinearProgressIndicator(),
                          ),
                        if (state.error != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              errorText(state.error!),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        _content(state, wide),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _heading(ForumState state) {
    if (state.topic != null) return _topicHeading(state);
    if (state.section == null) {
      return Text(
        context.strings.forumListTitle,
        style: Theme.of(context).textTheme.headlineSmall,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) =>
          _listHeading(state, constraints.maxWidth < 560),
    );
  }

  Widget _listHeading(ForumState state, bool narrow) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionPicker(state),
        const SizedBox(height: 4),
        Text(
          context.strings.forumListDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: title),
              const SizedBox(width: 8),
              _menu(state),
            ],
          ),
          if (state.section!.permissions.write)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: _createButton(state),
              ),
            ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: title),
        const SizedBox(width: 16),
        if (state.section!.permissions.write) _createButton(state),
        _menu(state),
      ],
    );
  }

  Widget _createButton(ForumState state) => FilledButton.icon(
    onPressed: state.busy ? null : create,
    icon: const Icon(Icons.add, size: 18),
    label: Text(context.strings.forumNewTopic),
  );
  Widget _sectionPicker(ForumState state) => DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      key: const ValueKey('forum-section-picker'),
      value: state.section!.id,
      isExpanded: true,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.w700),
      items: state.sections
          .map(
            (section) => DropdownMenuItem(
              value: section.id,
              child: Text(
                section.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: state.busy
          ? null
          : (id) {
              if (id != null) {
                controller.selectSection(
                  state.sections.firstWhere((c) => c.id == id),
                );
              }
            },
    ),
  );
  bool _canClose(ForumState state) =>
      state.topic != null &&
      state.section!.permissions.manage &&
      !state.topic!.hidden &&
      !state.topic!.closed;

  List<PopupMenuEntry<String>> _moderationMenu(ForumState state) {
    final topic = state.topic;
    if (topic == null ||
        !state.section!.permissions.manage ||
        controller.moderation == null) {
      return const [];
    }
    return [
      if (topic.closed && !topic.hidden)
        PopupMenuItem(
          value: 'reopen',
          child: Text(context.strings.forumReopen),
        ),
      PopupMenuItem(
        value: topic.hidden ? 'restore' : 'hide',
        child: Text(
          topic.hidden
              ? context.strings.forumRestoreTopic
              : context.strings.forumHideTopic,
        ),
      ),
      PopupMenuItem(
        value: 'audit',
        child: Text(context.strings.forumModerationLog),
      ),
    ];
  }

  Future<void> _moderate(String action, [ForumReply? reply]) =>
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => ForumModerationDialog(
          title: forumModerationLabel(context, action),
          submit: (reason) => reply == null
              ? controller.moderateTopic(action, reason)
              : controller.moderateReply(reply, reason),
        ),
      );
  Future<void> _audit() {
    final state = controller.state;
    final channel = state.section!.id, thread = state.topic!.id;
    return showDialog<void>(
      context: context,
      builder: (_) => ForumModerationLog(
        load: (after) =>
            controller.moderation!.moderationLog(channel, thread, after),
      ),
    );
  }

  ForumReports? get reports {
    final api = widget.api;
    return api is ForumReports && (api as ForumReports).reportsSupported
        ? api as ForumReports
        : null;
  }

  Future<void> _report([ForumReply? reply]) async {
    final state = controller.state;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ForumModerationDialog(
        title: context.strings.forumReport,
        notice: context.strings.forumReportNotice,
        submit: (reason) async {
          await reports!.reportContent(
            state.section!.id,
            state.topic!.id,
            reply?.id ?? '',
            reason,
          );
          return true;
        },
      ),
    );
  }

  Future<void> _reportsQueue() async {
    final state = controller.state;
    await showDialog<void>(
      context: context,
      builder: (_) => ForumReportsQueue(
        api: reports!,
        forum: widget.api,
        channel: state.section!.id,
        open: (id) async {
          await controller.openTopic(id);
        },
      ),
    );
    if (mounted) await controller.synchronize();
  }

  Widget? _replyActions(ForumState state, ForumReply reply) {
    final moderate =
        state.section!.permissions.manage && controller.moderation != null;
    final report = reports != null && !reply.hidden && !state.topic!.hidden;
    if (!moderate && !report) return null;
    final action = reply.hidden ? 'restore_reply' : 'hide_reply';
    return PopupMenuButton<String>(
      key: ValueKey('forum-reply-actions-${reply.id}'),
      tooltip: context.strings.forumActions,
      enabled: !state.busy,
      onSelected: (selected) => unawaited(
        selected == 'report' ? _report(reply) : _moderate(action, reply),
      ),
      itemBuilder: (_) => [
        if (report)
          PopupMenuItem(
            value: 'report',
            child: Text(context.strings.forumReport),
          ),
        if (moderate)
          PopupMenuItem(
            value: action,
            child: Text(forumModerationLabel(context, action)),
          ),
      ],
      icon: const Icon(Icons.more_horiz, size: 18),
    );
  }

  List<PopupMenuEntry<String>> _reportMenu(ForumState state) => [
    if (reports != null &&
        state.section != null &&
        state.section!.permissions.manage)
      PopupMenuItem(
        value: 'reports',
        child: Text(context.strings.forumReportsQueue),
      ),
    if (reports != null && state.topic != null && !state.topic!.hidden)
      PopupMenuItem(value: 'report', child: Text(context.strings.forumReport)),
  ];

  Widget _menu(ForumState state) => PopupMenuButton<String>(
    key: const ValueKey('forum-actions'),
    tooltip: context.strings.forumActions,
    enabled: !state.busy && !authorizing,
    icon: const Icon(Icons.more_horiz),
    onSelected: (action) => _action(action),
    itemBuilder: (context) => [
      ..._moderationMenu(state),
      ..._reportMenu(state),
      if (_canClose(state))
        PopupMenuItem(value: 'close', child: Text(context.strings.forumClose)),
      if (state.topic != null &&
          state.section!.permissions.manage &&
          controller.navigation != null)
        PopupMenuItem(
          value: 'pin',
          child: Text(
            state.topic!.pinned
                ? context.strings.forumUnpin
                : context.strings.forumPin,
          ),
        ),
      if (widget.authorize != null)
        PopupMenuItem(
          value: 'authorize',
          child: Text(context.strings.forumAuthorizeDevice),
        ),
      PopupMenuItem(
        value: 'refresh',
        child: Text(context.strings.forumRefresh),
      ),
      if (widget.manage != null)
        PopupMenuItem(
          value: 'manage',
          child: Text(context.strings.forumManage),
        ),
      PopupMenuItem(
        value: 'privacy',
        child: Text(context.strings.forumAboutSection),
      ),
    ],
  );
  void _action(String action) {
    switch (action) {
      case 'report':
        unawaited(_report());
      case 'reports':
        unawaited(_reportsQueue());
      case 'hide' || 'restore' || 'reopen':
        unawaited(_moderate(action));
      case 'audit':
        unawaited(_audit());
      case 'pin':
        unawaited(controller.pinTopic());
      case 'authorize':
        unawaited(_authorize());
      case 'close':
        unawaited(closeTopic());
      case 'refresh':
        unawaited(controller.refresh());
      case 'manage':
        unawaited(manage());
      case 'privacy':
        unawaited(
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(context.strings.forumAboutSection),
              content: Text(context.strings.forumPrivacy),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.strings.forumBack),
                ),
              ],
            ),
          ),
        );
    }
  }

  Future<void> _authorize() async {
    if (authorizing) return;
    setState(() => authorizing = true);
    try {
      await widget.authorize!();
      if (mounted) await controller.refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.forumFailure)));
      }
    } finally {
      if (mounted) setState(() => authorizing = false);
    }
  }

  Widget _content(ForumState state, bool wide) {
    if (!state.supported) return Text(context.strings.forumUpdateRuntime);
    if (state.section == null) return _empty(state);
    final content = PageTransition(
      transitionKey: (state.section?.id, state.topic?.id, state.topic?.hidden),
      child: state.topic == null ? _topics(state) : _topic(state),
    );
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          content,
          const SizedBox(height: 28),
          const Divider(height: 32),
          const ForumPrivacy(),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: content),
        const SizedBox(width: 30),
        SizedBox(
          width: 190,
          child: ForumAbout(
            topic: state.topic,
            manage: widget.manage == null ? null : manage,
          ),
        ),
      ],
    );
  }

  Widget _empty(ForumState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(context.strings.forumEmptySections),
      const SizedBox(height: 16),
      OutlinedButton(
        onPressed: state.busy ? null : controller.refresh,
        child: Text(context.strings.forumRefresh),
      ),
      if (widget.manage != null && state.supported)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: FilledButton(
            onPressed: state.busy ? null : manage,
            child: Text(context.strings.forumManage),
          ),
        ),
    ],
  );
  Widget _topics(ForumState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ForumTopicList(
        topics: state.threads,
        busy: state.busy,
        open: controller.openTopic,
      ),
      if (state.threads.isEmpty && !state.busy)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(context.strings.forumEmptyTopics),
        ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Text(
              context.strings.forumAllTopics,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton.icon(
            onPressed: state.busy ? null : controller.refresh,
            icon: const Icon(Icons.refresh, size: 16),
            label: Text(context.strings.forumRefresh),
          ),
        ],
      ),
      if (state.nextThreads != 0)
        OutlinedButton(
          onPressed: state.busy ? null : controller.moreThreads,
          child: Text(context.strings.forumMore),
        ),
    ],
  );
  Widget _topicHeading(ForumState state) {
    final topic = state.topic!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: state.busy ? null : controller.back,
          icon: const Icon(Icons.arrow_back, size: 17),
          label: Text(state.section!.title),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                topic.hidden ? context.strings.forumHiddenTopic : topic.title,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            _menu(state),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              forumDate(context, topic.createdAtUnix.toInt()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Text('·'),
            Text(
              '${context.strings.forumReplies}: ${topic.replyCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (topic.pinned) ...[
              const Icon(Icons.push_pin_outlined, size: 14),
              Text(context.strings.forumPinned),
            ],
            if (topic.readStateSupported && topic.unreadCount > Int64.ZERO)
              Text(
                '${context.strings.forumUnread}: ${topic.unreadCount}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            if (topic.closed) ...[
              const Icon(Icons.lock_outline, size: 14),
              Text(
                context.strings.forumClosedLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _replyMessage(ForumState state, ForumReply reply) {
    if (reply.hidden) {
      return ForumHiddenNotice(
        reply: true,
        action: _replyActions(state, reply),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.topic!.readStateSupported &&
            state.topic!.unreadCount > Int64.ZERO &&
            reply.sequence == state.topic!.readSequence + Int64.ONE)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              context.strings.forumFirstUnread,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ForumMessage(
          author: reply.authorName,
          authorId: reply.authorId,
          text: reply.text,
          timestamp: reply.createdAtUnix.toInt(),
          assets: _visibleAssets(reply.attachments),
          session: media?.attachmentSession,
          trailing: _replyActions(state, reply),
        ),
      ],
    );
  }

  Widget _topic(ForumState state) {
    final topic = state.topic!;
    if (topic.hidden) return const ForumHiddenNotice();
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 740),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            readTracker.track(
              0,
              ForumMessage(
                author: topic.authorName,
                authorId: topic.authorId,
                text: topic.text,
                timestamp: topic.createdAtUnix.toInt(),
                original: true,
                assets: _visibleAssets(topic.attachments),
                session: media?.attachmentSession,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${context.strings.forumReplies}  ${topic.replyCount}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (state.replies.isNotEmpty &&
                    state.replies.first.sequence > Int64.ONE)
                  Flexible(
                    child: TextButton(
                      onPressed: state.busy ? null : controller.fromBeginning,
                      child: Text(context.strings.forumRepliesFromStart),
                    ),
                  )
                else
                  Text(
                    context.strings.forumOrder,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            for (final reply in state.replies)
              readTracker.track(
                reply.sequence.toInt(),
                _replyMessage(state, reply),
              ),
            if (controller.navigation != null && topic.unreadCount > Int64.ZERO)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: OutlinedButton.icon(
                  key: const ValueKey('forum-mark-read'),
                  onPressed: state.busy ? null : controller.markRead,
                  icon: const Icon(Icons.done_all, size: 18),
                  label: Text(context.strings.forumReadShown),
                ),
              ),
            if (state.nextReplies != 0)
              OutlinedButton(
                onPressed: state.busy ? null : controller.moreReplies,
                child: Text(context.strings.forumMore),
              ),
            const SizedBox(height: 24),
            _replyArea(state),
          ],
        ),
      ),
    );
  }

  List<Asset> _visibleAssets(List<Asset> assets) =>
      media?.attachmentsEnabled == false ? const [] : assets;
  Widget _replyArea(ForumState state) {
    if (state.topic!.closed) return const ForumClosedNotice();
    if (!state.section!.permissions.write) {
      return Text(context.strings.forumReadOnly);
    }
    return ForumComposer(
      sendWithShift: widget.sendWithShift,
      key: ValueKey(state.topic!.id),
      disabled: state.busy,
      channelId: state.section!.id,
      session: media?.attachmentSession,
      attachmentsEnabled: media?.attachmentsEnabled ?? false,
      submit: (_, text, key, attachments) =>
          controller.reply(text, key, attachments),
    );
  }
}
