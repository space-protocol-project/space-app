import 'mls_files.dart';
import 'mls_recovery.dart';
import '../src/rpc_clients.dart' show MlsDevice;

import 'dart:async';
import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../l10n/strings.dart';
import '../src/core.dart';
import '../src/mls/client.dart';
import '../src/mls/controller.dart';
import '../src/mls/files.dart';

class MlsChannelView extends StatefulWidget {
  const MlsChannelView({
    super.key,
    required this.session,
    required this.channelId,
    required this.groupId,
    required this.attachmentsEnabled,
    required this.canWrite,
    required this.active,
  });
  final SpaceSession session;
  final String channelId;
  final List<int> groupId;
  final bool attachmentsEnabled, canWrite, active;
  @override
  State<MlsChannelView> createState() => _MlsChannelViewState();
}

class _MlsChannelViewState extends State<MlsChannelView> {
  late final Future<MlsClient> future = widget.session.mlsClient();
  @override
  Widget build(BuildContext context) => FutureBuilder<MlsClient>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(
          child: Text('Не удалось открыть защищённое хранилище MLS'),
        );
      }
      final client = snapshot.data;
      if (client == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return _MlsConversation(
        client: client,
        channelId: widget.channelId,
        groupId: widget.groupId,
        attachmentsEnabled: widget.attachmentsEnabled,
        canWrite: widget.canWrite,
        active: widget.active,
      );
    },
  );
}

class _MlsConversation extends StatefulWidget {
  const _MlsConversation({
    required this.client,
    required this.channelId,
    required this.groupId,
    required this.attachmentsEnabled,
    required this.canWrite,
    required this.active,
  });
  final MlsClient client;
  final String channelId;
  final List<int> groupId;
  final bool attachmentsEnabled, canWrite, active;
  @override
  State<_MlsConversation> createState() => _MlsConversationState();
}

class _MlsConversationState extends State<_MlsConversation> {
  late final MlsController controller = MlsController(
    widget.client,
    widget.channelId,
    widget.groupId,
  );
  final draft = TextEditingController();
  final scroll = ScrollController();
  List<XFile> files = [];
  bool submitting = false;
  String? submittedText;
  Timer? timer;
  DialogRoute<void>? filesRoute;

  @override
  void initState() {
    super.initState();
    controller.add(MlsRefresh());
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (widget.active && !controller.working) controller.add(MlsRefresh());
    });
  }

  @override
  void didUpdateWidget(covariant _MlsConversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attachmentsEnabled && !widget.attachmentsEnabled) {
      final route = filesRoute;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (route?.isActive == true) route!.navigator?.removeRoute(route);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    unawaited(controller.close());
    draft.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> pickFiles() async {
    final picked = await openFiles();
    if (!mounted) return;
    if (files.length + picked.length > 5) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Не более пяти файлов')));
      return;
    }
    setState(() => files = [...files, ...picked]);
  }

  Future<void> ownCode() async {
    await safely(showOwnCode);
  }

  Future<void> safely(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is StateError
                ? error.message.toString()
                : 'Не удалось выполнить действие MLS',
          ),
        ),
      );
    }
  }

  Future<void> showOwnCode() async {
    final binding = await widget.client.ownBinding();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.mlsDeviceCode),
        content: SelectableText(mlsFingerprint(binding)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.strings.mlsCancel),
          ),
        ],
      ),
    );
  }

  Future<void> verify(MlsDevice device) async {
    final trusted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.mlsVerify),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.strings.mlsVerifyHint),
              const SizedBox(height: 16),
              SelectableText(device.grantId),
              const SizedBox(height: 12),
              SelectableText(mlsFingerprint(mlsBinding(device))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.mlsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.mlsTrust),
          ),
        ],
      ),
    );
    if (trusted == true && mounted) controller.add(MlsTrust(device));
  }

  Future<void> devices() async {
    await safely(showDevices);
  }

  Future<void> showDevices() async {
    final devices = await widget.client.devices(widget.channelId);
    final current = controller.state.data?.channel;
    final manager = (current?['managers'] as List? ?? []).contains(
      widget.client.local.scope['grant_id'],
    );
    final roster = (current?['roster'] as List? ?? []).cast<Map>();
    includeRoster(devices, roster);
    final joined = roster
        .map((binding) => (binding['device'] as Map)['grant_id'])
        .toSet();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.strings.mlsDevices),
        content: SizedBox(
          width: 520,
          height: 400,
          child: ListView(
            children: [
              for (final device in devices)
                ListTile(
                  title: Text(
                    device.principalId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    device.grantId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    unawaited(verify(device));
                  },
                  trailing: manager
                      ? deviceMenu(device, joined, dialogContext)
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deviceMenu(
    MlsDevice device,
    Set<dynamic> joined,
    BuildContext dialogContext,
  ) => PopupMenuButton<String>(
    onSelected: (action) async {
      Navigator.pop(dialogContext);
      if (action == 'transfer' && !await confirmTransfer(device)) {
        return;
      }
      if (!mounted) return;
      controller.add(switch (action) {
        'invite' => MlsInvite(device),
        'transfer' => MlsTransfer(device),
        _ => MlsRemove(device),
      });
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'transfer',
        enabled:
            joined.contains(device.grantId) &&
            device.grantId != widget.client.local.scope['grant_id'],
        child: Text(context.strings.mlsTransfer),
      ),

      PopupMenuItem(
        value: 'invite',
        enabled:
            device.keyPackage.isNotEmpty && !joined.contains(device.grantId),
        child: Text(context.strings.mlsInvite),
      ),
      PopupMenuItem(
        value: 'remove',
        enabled:
            joined.contains(device.grantId) &&
            device.grantId != widget.client.local.scope['grant_id'],
        child: Text(context.strings.mlsRemove),
      ),
    ],
  );

  Future<bool> confirmTransfer(MlsDevice device) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.strings.mlsTransferTitle),
          content: Text(context.strings.mlsTransferHint(device.grantId)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.strings.mlsCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.strings.mlsTransfer),
            ),
          ],
        ),
      ) ??
      false;

  void includeRoster(List<MlsDevice> devices, List<Map> roster) {
    final listed = devices.map((device) => device.grantId).toSet();
    for (final binding in roster) {
      final scope = binding['device'] as Map;
      if (listed.contains(scope['grant_id'])) continue;
      devices.add(
        MlsDevice(
          grantId: scope['grant_id'] as String,
          principalId: scope['principal_id'] as String,
          binding: utf8.encode(jsonEncode(binding)),
        ),
      );
    }
  }

  Future<void> download(
    Map<String, dynamic> message,
    Map<String, dynamic> descriptor,
  ) async {
    try {
      final bytes = await MlsFiles(widget.client).download(
        widget.groupId,
        ((message['message'] as Map)['id'] as List).cast<int>(),
        descriptor,
      );
      final destination = await getSaveLocation(
        suggestedName: descriptor['name'] as String,
      );
      if (destination == null) return;
      await XFile.fromData(
        bytes,
        name: descriptor['name'] as String,
      ).saveTo(destination.path);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось проверить или сохранить файл'),
          ),
        );
      }
    }
  }

  Widget messageCard(Map<String, dynamic> item) {
    final message = item['message'] as Map;
    final descriptors = (message['files'] as List).cast<Map<String, dynamic>>();
    final own = item['grant_id'] == widget.client.local.scope['grant_id'];
    return Align(
      alignment: own ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 680),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: own
              ? Theme.of(context).colorScheme.primaryContainer
                    .withValues(alpha: .3)
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['author_id'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 6),
            if (item['archived'] == true)
              Text('Из архива', style: Theme.of(context).textTheme.labelSmall),
            if ((message['text'] as String).isNotEmpty)
              SelectableText(message['text'] as String),
            if (widget.attachmentsEnabled)
              for (final descriptor in descriptors)
                TextButton.icon(
                  onPressed: () => download(item, descriptor),
                  icon: const Icon(Icons.download),
                  label: Text(descriptor['name'] as String),
                ),
            if (!widget.attachmentsEnabled &&
                (message['text'] as String).isEmpty)
              Text(context.strings.mlsUnavailable),
            Text(
              DateFormat.Hm().format(
                DateTime.fromMillisecondsSinceEpoch(item['time'] as int),
              ),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget composer(MlsState state) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.attachmentsEnabled && files.isNotEmpty)
          Wrap(
            children: files
                .map(
                  (file) => InputChip(
                    label: Text(file.name),
                    onDeleted: state.busy
                        ? null
                        : () => setState(() => files.remove(file)),
                  ),
                )
                .toList(),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height / 3,
          ),
          child: TextField(
            controller: draft,
            minLines: 3,
            maxLines: null,
            enabled:
                !state.busy &&
                !state.recoveryRequired &&
                state.data?.channel['revocation_pending'] != true &&
                !submitting &&
                state.data?.joined == true &&
                widget.canWrite,
            decoration: InputDecoration(
              hintText: context.strings.mlsInput,
              border: InputBorder.none,
            ),
          ),
        ),
        Row(
          children: [
            if (widget.attachmentsEnabled)
              IconButton(
                onPressed: state.busy || state.recoveryRequired
                    ? null
                    : pickFiles,
                tooltip: context.strings.mlsAttach,
                icon: const Icon(Icons.add),
              ),
            const Spacer(),
            IconButton.filled(
              onPressed:
                  state.busy ||
                      state.recoveryRequired ||
                      state.data?.channel['revocation_pending'] == true ||
                      submitting ||
                      state.data?.joined != true ||
                      !widget.canWrite
                  ? null
                  : submit,
              tooltip: context.strings.mlsSend,
              icon: const Icon(Icons.arrow_upward),
            ),
          ],
        ),
      ],
    ),
  );

  Widget messageArea(List<Map<String, dynamic>> messages) => LayoutBuilder(
    builder: (context, constraints) {
      final chat = ListView.builder(
        controller: scroll,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: messages.length,
        itemBuilder: (context, index) => messageCard(messages[index]),
      );
      if (!widget.attachmentsEnabled || constraints.maxWidth < 1080) {
        return chat;
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: chat),
          SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: MlsFilesPanel(
                messages: messages,
                ownId: widget.client.local.scope['principal_id'] as String,
                download: download,
              ),
            ),
          ),
        ],
      );
    },
  );

  Future<void> showFiles() async {
    final messages =
        controller.state.data?.messages ?? <Map<String, dynamic>>[];
    final route = DialogRoute<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 480,
          height: 560,
          child: MlsFilesPanel(
            messages: messages,
            ownId: widget.client.local.scope['principal_id'] as String,
            download: download,
          ),
        ),
      ),
    );
    filesRoute = route;
    await Navigator.of(context).push(route);
    if (identical(filesRoute, route)) filesRoute = null;
  }

  Widget trustRequests(List<MlsDevice> devices) => SizedBox(
    height: (devices.length * 72.0).clamp(0, 160),
    child: ListView(
      children: [
        for (final device in devices)
          ListTile(
            title: Text(context.strings.mlsVerify),
            subtitle: Text(
              device.grantId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: TextButton(
              onPressed: () => verify(device),
              child: Text(context.strings.mlsVerify),
            ),
          ),
      ],
    ),
  );

  Future<void> submit() async {
    if (submitting) return;
    if (draft.text.isEmpty && (!widget.attachmentsEnabled || files.isEmpty)) {
      return;
    }
    final event = MlsSend(
      draft.text,
      widget.attachmentsEnabled ? List.of(files) : [],
    );
    submittedText = draft.text;
    setState(() => submitting = true);
    controller.add(event);
    final accepted = await event.done.future;
    if (!mounted) return;
    setState(() => submitting = false);
    if (accepted) clearSubmitted();
  }

  void clearSubmitted() {
    if (draft.text != submittedText) return;
    draft.clear();
    setState(() => files = []);
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<MlsController, MlsState>(
    bloc: controller,
    listenWhen: (previous, current) => previous.sent != current.sent,
    listener: (context, state) {
      clearSubmitted();
    },
    builder: (context, state) {
      final messages = [
        ...?state.data?.messages,
      ]..sort((a, b) => (a['sequence'] as int).compareTo(b['sequence'] as int));
      return Padding(
        padding: const EdgeInsets.only(top: 72),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.lock_outline),
                const SizedBox(width: 8),
                Expanded(child: Text(context.strings.mlsTitle)),
                PopupMenuButton<String>(
                  tooltip: 'Защита и история',
                  onSelected: (action) => safely(() async {
                    if (action == 'code') {
                      await showMlsGroupCode(
                        context,
                        widget.client,
                        widget.channelId,
                      );
                    } else if (action == 'update') {
                      await widget.client.selfUpdate(widget.channelId);
                    } else if (action == 'cancel-transfer') {
                      await widget.client.cancelTransfer(widget.channelId);
                    } else {
                      await manageMlsArchive(
                        context,
                        widget.client,
                        exporting: action == 'export',
                      );
                    }
                    if (mounted) controller.add(MlsRefresh());
                  }),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'cancel-transfer',
                      child: Text('Отменить ожидающую передачу управления'),
                    ),
                    PopupMenuItem(
                      value: 'code',
                      enabled:
                          state.data?.joined == true && state.error.isEmpty,
                      child: const Text('Код группы'),
                    ),
                    PopupMenuItem(
                      value: 'update',
                      enabled:
                          state.data?.joined == true &&
                          !state.busy &&
                          state.error.isEmpty,
                      child: const Text('Обновить ключи'),
                    ),
                    const PopupMenuItem(
                      value: 'export',
                      child: Text('Сохранить архив истории'),
                    ),
                    const PopupMenuItem(
                      value: 'import',
                      child: Text('Восстановить архив истории'),
                    ),
                  ],
                ),
                if (widget.attachmentsEnabled)
                  IconButton(
                    onPressed: showFiles,
                    tooltip: context.strings.mlsFiles,
                    icon: const Icon(Icons.folder_outlined),
                  ),
                IconButton(
                  onPressed: ownCode,
                  tooltip: context.strings.mlsDeviceCode,
                  icon: const Icon(Icons.fingerprint),
                ),
                IconButton(
                  onPressed: state.busy ? null : devices,
                  tooltip: context.strings.mlsDevices,
                  icon: const Icon(Icons.devices),
                ),
              ],
            ),
            Text(
              context.strings.mlsExperimental,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            if (state.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(state.error),
                    TextButton(
                      onPressed: state.busy
                          ? null
                          : () => controller.add(MlsRefresh()),
                      child: Text(context.strings.mlsRetry),
                    ),
                  ],
                ),
              ),
            if (state.data?.untrusted.isNotEmpty == true)
              trustRequests(state.data!.untrusted),
            if (state.data?.joined == false &&
                state.error.isEmpty &&
                state.data!.untrusted.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(context.strings.mlsWaiting),
              ),
            Expanded(child: messageArea(messages)),
            if (state.data?.joined == true && state.data!.untrusted.isEmpty)
              composer(state),
          ],
        ),
      );
    },
  );
}
