import '../l10n/strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_selector/file_selector.dart';
import 'package:file_saver/file_saver.dart';

import '../src/attachments.dart';
import '../src/core.dart';
import '../src/rpc_clients.dart';

class AttachmentComposer extends StatelessWidget {
  const AttachmentComposer({
    super.key,
    required this.queue,
    required this.enabled,
    required this.openFiles,
    this.openChannelFiles,
    this.session,
    this.canRead = true,
  });
  final AttachmentQueue queue;
  final AttachmentSession? session;
  final bool canRead;
  final bool enabled;
  final VoidCallback openFiles;
  final VoidCallback? openChannelFiles;
  Widget channelFilesButton(BuildContext context) {
    if (openChannelFiles == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: context.strings.channelFiles,
      onPressed: canRead ? openChannelFiles : null,
      icon: const Icon(Icons.folder_shared_outlined),
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AttachmentQueue, AttachmentState>(
        bloc: queue,
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: context.strings.attachFiles,
                  onPressed: enabled && !state.busy
                      ? () async {
                          final files = await openFilesPicker();
                          await queue.add(AttachmentFilesAdded(files));
                        }
                      : null,
                  icon: const Icon(Icons.attach_file),
                ),
                Text('${state.files.length}/5'),
                const Spacer(),
                channelFilesButton(context),
                TextButton.icon(
                  onPressed: state.busy
                      ? queue.cancel
                      : canRead
                      ? openFiles
                      : null,
                  icon: Icon(state.busy ? Icons.close : Icons.folder_outlined),
                  label: Text(
                    state.busy
                        ? context.strings.cancelUpload
                        : context.strings.myFiles,
                  ),
                ),
              ],
            ),
            if (state.files.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 76),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final file in state.files)
                      _fileTile(
                        dense: true,
                        leading: const Icon(Icons.insert_drive_file_outlined),
                        title: Text(
                          file.file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(attachmentSize(file.size)),
                        trailing: IconButton(
                          tooltip: context.strings.removeFile,
                          onPressed: state.busy
                              ? null
                              : () => queue.remove(file, session: session),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                  ],
                ),
              ),
            if (state.busy) LinearProgressIndicator(value: state.progress),
            if (state.error.isNotEmpty)
              Text(
                state.error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      );
}

Future<List<XFile>> openFilesPicker() => openFiles();

class AttachmentCard extends StatefulWidget {
  const AttachmentCard({super.key, required this.asset, required this.session});
  final Asset asset;
  final AttachmentSession? session;
  @override
  State<AttachmentCard> createState() => _AttachmentCardState();
}

class _AttachmentCardState extends State<AttachmentCard> {
  bool busy = false;
  Future<void> save() async {
    final session = widget.session;
    if (session == null || busy) return;
    setState(() => busy = true);
    try {
      final bytes = await downloadAttachment(session, widget.asset);
      await FileSaver.instance.saveAs(
        name: widget.asset.name,
        includeExtension: false,
        bytes: bytes,
        mimeType: MimeType.custom,
        customMimeType: 'application/octet-stream',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.strings.downloadFailed}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 360),
    child: _fileTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.insert_drive_file_outlined),
      title: Text(
        widget.asset.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(attachmentSize(widget.asset.byteSize.toInt())),
      trailing: busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              tooltip: context.strings.downloadFile,
              onPressed: widget.session == null ? null : save,
              icon: const Icon(Icons.download),
            ),
    ),
  );
}

class MyFilesDialog extends StatefulWidget {
  const MyFilesDialog({
    super.key,
    required this.session,
    required this.channel,
  });
  final AttachmentSession session;
  final String channel;
  @override
  State<MyFilesDialog> createState() => _MyFilesDialogState();
}

class _MyFilesDialogState extends State<MyFilesDialog> {
  final files = <Asset>[];
  String cursor = '', error = '';
  bool busy = false, more = true;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    if (busy) return;
    setState(() {
      busy = true;
      error = '';
    });
    try {
      final reply = await widget.session.listMyAssets(
        ListMyAssetsRequest(channelId: widget.channel, after: cursor),
      );
      if (!mounted) return;
      setState(() {
        files.addAll(reply.assets);
        cursor = reply.nextCursor;
        more = cursor.isNotEmpty;
      });
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String date(Asset a) => MaterialLocalizations.of(context).formatMediumDate(
    DateTime.fromMillisecondsSinceEpoch(a.createdAtUnixMs.toInt()).toLocal(),
  );
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.myFiles),
    content: SizedBox(
      width: 480,
      height: 420,
      child: ListView(
        children: [
          for (var i = 0; i < files.length; i++) ...[
            if (i == 0 || date(files[i]) != date(files[i - 1]))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  date(files[i]),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            AttachmentCard(asset: files[i], session: widget.session),
          ],
          if (files.isEmpty && !busy && error.isEmpty)
            Text(context.strings.noFilesInChannel),
          if (error.isNotEmpty) Text(error),
          if (busy)
            const Center(child: CircularProgressIndicator())
          else if (more)
            TextButton(
              onPressed: load,
              child: Text(context.strings.loadMoreFiles),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.closeFiles),
      ),
    ],
  );
}

Widget _fileTile({
  Widget? leading,
  Widget? title,
  Widget? subtitle,
  Widget? trailing,
  bool dense = false,
  EdgeInsetsGeometry? contentPadding,
}) => Material(
  type: MaterialType.transparency,
  child: ListTile(
    leading: leading,
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    dense: dense,
    contentPadding: contentPadding,
  ),
);
