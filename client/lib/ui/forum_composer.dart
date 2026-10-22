import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/attachments.dart';
import '../src/core.dart' show AttachmentSession, newRequestKey;
import 'attachment_widgets.dart';
import 'message_composer_controls.dart';
import 'message_input_surface.dart';

class ForumComposer extends StatefulWidget {
  const ForumComposer({
    super.key,
    required this.submit,
    this.newTopic = false,
    this.disabled = false,
    this.session,
    this.channelId = '',
    this.attachmentsEnabled = false,
    this.sendWithShift = false,
  });
  final Future<bool> Function(
    String title,
    String text,
    String key,
    List<String> attachments,
  )
  submit;
  final bool newTopic, disabled, attachmentsEnabled, sendWithShift;
  final AttachmentSession? session;
  final String channelId;
  @override
  State<ForumComposer> createState() => _ForumComposerState();
}

class _ForumComposerState extends State<ForumComposer> {
  final title = TextEditingController(), text = TextEditingController();
  final queue = AttachmentQueue();
  String? requestKey, requestPayload;
  bool busy = false, invalid = false, failed = false;
  @override
  void dispose() {
    title.dispose();
    text.dispose();
    queue.cancel();
    unawaited(queue.close());
    super.dispose();
  }

  bool valid(String value, int max) =>
      value.trim().isNotEmpty && utf8.encode(value).length <= max;
  bool get canAttach => widget.attachmentsEnabled && widget.session != null;
  bool get enabled => !busy && !widget.disabled;
  bool validDraft() {
    if (widget.newTopic && !valid(title.text, 320)) return false;
    return valid(text.text, 8192) ||
        (text.text.trim().isEmpty && queue.state.files.isNotEmpty);
  }

  Future<bool> submit() async {
    final payload = jsonEncode([
      title.text,
      text.text,
      queue.state.files.map((f) => f.key).toList(),
    ]);
    if (payload != requestPayload) {
      requestKey = newRequestKey();
      requestPayload = payload;
    }
    var ids = <String>[];
    if (queue.state.files.isNotEmpty) {
      final session = widget.session;
      if (session == null || !canAttach) return false;
      final uploaded = await queue.upload(session, widget.channelId);
      if (uploaded == null || !mounted) return false;
      ids = uploaded;
    }
    return widget.submit(title.text.trim(), text.text.trim(), requestKey!, ids);
  }

  Future<void> send() async {
    if (!enabled || queue.state.busy) return;
    if (!validDraft()) {
      setState(() => invalid = true);
      return;
    }
    setState(() {
      busy = true;
      invalid = false;
      failed = false;
    });
    bool success;
    try {
      success = await submit();
    } catch (_) {
      success = false;
    }
    if (!mounted) return;
    setState(() {
      busy = false;
      failed = !success;
      if (success) {
        title.clear();
        text.clear();
        queue.clear();
        requestKey = null;
        requestPayload = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (widget.newTopic) ...[
        TextField(
          key: const ValueKey('forum-title'),
          controller: title,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: context.strings.forumTopicTitle,
          ),
        ),
        const SizedBox(height: 16),
      ],
      if (canAttach) AttachmentComposer(queue: queue, session: widget.session),
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
                send: () => unawaited(send()),
              ),
              child: MessageDraftField(
                fieldKey: const ValueKey('forum-text'),
                controller: text,
                enabled: enabled,
                hint: context.strings.messageHint,
              ),
            ),
            MessageComposerActions(
              controller: text,
              enabled: enabled,
              send: send,
              queue: queue,
              canAttach: canAttach,
              sendKey: const ValueKey('forum-send'),
            ),
          ],
        ),
      ),
      if (invalid)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(context.strings.forumInvalidText),
        ),
      if (failed)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(context.strings.forumFailure),
        ),
    ],
  );
}
