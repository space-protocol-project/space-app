import 'dart:async';
import 'message_markdown.dart';

import '../l10n/strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/community_mentions.dart';
import '../src/community_mentions_api.dart';
import '../src/generated/space/v1/community_mentions.pb.dart';

class CommunityMentionText extends StatelessWidget {
  const CommunityMentionText(
    this.text, {
    super.key,
    this.mentions = const [],
    this.style,
  });
  final String text;
  final List<CommunityMention> mentions;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return MessageMarkdown(text:text,style:style,highlightedNames:[
      for(final mention in validMentions(text,mentions)) text.substring(mention.start,mention.start+mention.length),
    ]);
  }
}

class MentionButton extends StatefulWidget {
  const MentionButton({
    super.key,
    required this.api,
    required this.channel,
    this.parent = '',
    required this.draft,
    required this.text,
    this.enabled = true,
  });
  final CommunityMentionApi? api;
  final String channel, parent;
  final MentionDraftCubit draft;
  final TextEditingController text;
  final bool enabled;
  @override
  State<MentionButton> createState() => _MentionButtonState();
}

class _MentionButtonState extends State<MentionButton> {
  bool opened = false;
  String previous = '';
  @override
  void initState() {
    super.initState();
    previous = widget.text.text;
    widget.text.addListener(changed);
  }

  @override
  void didUpdateWidget(covariant MentionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      oldWidget.text.removeListener(changed);
      previous = widget.text.text;
      widget.text.addListener(changed);
    }
  }

  void changed() {
    final text = widget.text.text;
    final at = widget.text.selection.baseOffset;
    final typedAt =
        text.length == previous.length + 1 && at > 0 && text[at - 1] == '@';
    previous = text;
    if (typedAt) unawaited(open(replaceAt: true));
  }

  Future<void> open({bool replaceAt = false}) async {
    final api = widget.api;
    if (api == null || !widget.enabled || opened) return;
    final snapshot = widget.text.text;
    final selection = widget.text.selection;
    final channel = widget.channel;
    final parent = widget.parent;
    opened = true;
    final picker = MentionPickerCubit(api, channel, parent);
    unawaited(picker.search(''));
    final candidate = await showDialog<MentionCandidate>(
      context: context,
      builder: (_) => _MentionDialog(picker: picker),
    );
    await picker.close();
    opened = false;
    _applyCandidate(
      candidate,
      api,
      channel,
      parent,
      snapshot,
      selection,
      replaceAt,
    );
  }

  void _applyCandidate(
    MentionCandidate? candidate,
    CommunityMentionApi api,
    String channel,
    String parent,
    String snapshot,
    TextSelection selection,
    bool replaceAt,
  ) {
    if (!mounted || candidate == null || !widget.enabled) return;
    if (widget.api != api ||
        widget.channel != channel ||
        widget.parent != parent ||
        widget.text.text != snapshot) {
      return;
    }
    widget.draft.change(snapshot);
    final start = selection.isValid ? selection.start : snapshot.length;
    final end = selection.isValid ? selection.end : snapshot.length;
    if (!widget.draft.insert(candidate, replaceAt ? start - 1 : start, end)) {
      return;
    }
    final offset =
        (replaceAt ? start - 1 : start) + candidate.displayName.length + 2;
    widget.text.value = TextEditingValue(
      text: widget.draft.state.text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  @override
  void dispose() {
    widget.text.removeListener(changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.api == null
      ? const SizedBox.shrink()
      : Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            key: const ValueKey('community-mention'),
            tooltip: context.strings.communityMention,
            onPressed: widget.enabled ? open : null,
            icon: const Icon(Icons.alternate_email),
          ),
        );
}

class _MentionDialog extends StatelessWidget {
  const _MentionDialog({required this.picker});
  final MentionPickerCubit picker;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.communityMention),
    content: SizedBox(
      width: 420,
      height: 360,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            maxLength: 128,
            onChanged: picker.search,
            decoration: InputDecoration(
              labelText: context.strings.communityMentionQuery,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<MentionPickerCubit, MentionPickerState>(
              bloc: picker,
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.failed) {
                  return Text(context.strings.communityMentionFailed);
                }
                if (state.candidates.isEmpty) {
                  return Text(context.strings.communityMentionEmpty);
                }
                return ListView(
                  children: [
                    for (final candidate in state.candidates)
                      ListTile(
                        title: Text(candidate.displayName),
                        subtitle: Text(candidate.principalId),
                        onTap: () => Navigator.pop(context, candidate),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.forumCancel),
      ),
    ],
  );
}
