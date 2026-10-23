import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/core.dart';
import '../src/channel_files_controller.dart';
import '../src/generated/space/v1/space.pb.dart' show Asset;
import 'attachment_widgets.dart';

export '../src/channel_files_controller.dart';

class ChannelFilesPanel extends StatefulWidget {
  const ChannelFilesPanel({
    super.key,
    required this.session,
    required this.channel,
    this.revision = 0,
  });
  final AttachmentSession session;
  final String channel;
  final int revision;
  @override
  State<ChannelFilesPanel> createState() => _ChannelFilesPanelState();
}

class _ChannelFilesPanelState extends State<ChannelFilesPanel> {
  late final files = ChannelFilesController(widget.session, widget.channel)
    ..load();
  @override
  void dispose() {
    files.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChannelFilesPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision) {
      files.selectAuthor(files.state.author);
    }
  }

  String authorLabel(String id, Map<String, String> authors) {
    final nickname = authors[id] ?? '';
    return nickname.isEmpty ? id : nickname;
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChannelFilesController, ChannelFilesState>(
        bloc: files,
        builder: (context, state) => ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.strings.channelFiles,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: context.strings.refreshFiles,
                  onPressed: state.busy
                      ? null
                      : () => files.selectAuthor(state.author),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            _authorPicker(context, state),
            const SizedBox(height: 12),
            for (var i = 0; i < state.files.length; i++)
              ..._fileEntry(context, state, i),
            if (state.files.isEmpty && !state.busy && state.error.isEmpty)
              Text(context.strings.noFilesInChannel),
            if (state.error.isNotEmpty)
              Text(filesLoadErrorText(context, state.error)),
            if (state.busy)
              const Center(child: CircularProgressIndicator())
            else if (state.more && state.error.isEmpty)
              TextButton(
                onPressed: files.load,
                child: Text(context.strings.loadMoreFiles),
              ),
          ],
        ),
      );

  String date(Asset asset) => MaterialLocalizations.of(context)
      .formatMediumDate(
        DateTime.fromMillisecondsSinceEpoch(asset.createdAtUnixMs.toInt())
            .toLocal(),
      );
  Widget _authorPicker(BuildContext context, ChannelFilesState state) =>
      DropdownButton<String>(
        isExpanded: true,
        value: state.author,
        items: [
          DropdownMenuItem(
            value: '',
            child: Text(context.strings.allFileAuthors),
          ),
          for (final id in {
            ...state.authors.keys,
            if (state.author.isNotEmpty) state.author,
          }.toList()..sort())
            DropdownMenuItem(
              value: id,
              child: Text(
                authorLabel(id, state.authors),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: (id) {
          if (id != null) files.selectAuthor(id);
        },
      );

  List<Widget> _fileEntry(
    BuildContext context,
    ChannelFilesState state,
    int i,
  ) => [
    if (i == 0 || date(state.files[i]) != date(state.files[i - 1]))
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(date(state.files[i])),
      ),
    Text(
      authorLabel(state.files[i].authorId, state.authors),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall,
    ),
    AttachmentCard(asset: state.files[i], session: widget.session),
    const Divider(height: 20),
  ];
}
