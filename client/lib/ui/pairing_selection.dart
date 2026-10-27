import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/directory_repository.dart';
import '../src/pairing_selection.dart';
import 'pairing_panel.dart';

class PairingSelectionPanel extends StatefulWidget {
  const PairingSelectionPanel({super.key, required this.controllers,
    required this.onConnected, this.repository});
  final Map<String, ChatController> Function() controllers;
  final Future<void> Function(String, ChatController) onConnected;
  final DirectoryRepository? repository;
  @override
  State<PairingSelectionPanel> createState() => _PairingSelectionPanelState();
}

class _PairingSelectionPanelState extends State<PairingSelectionPanel> {
  late final cubit = PairingSelectionCubit(() => widget.controllers(), repository: widget.repository);
  @override
  void dispose() { unawaited(cubit.close()); super.dispose(); }

  @override
  Widget build(BuildContext context) => BlocBuilder<PairingSelectionCubit, PairingSelectionState>(
    bloc: cubit,
    builder: (context, state) => Card(child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(context.strings.pairingSelectionTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(context.strings.pairingSelectionHelp),
        const SizedBox(height: 16),
        _mode(state),
        const SizedBox(height: 12),
        ..._spaces(state),
        const SizedBox(height: 16),
        ..._status(state),
        if (state.prepared) ..._requests(state),
      ]),
    )),
  );

  Widget _mode(PairingSelectionState state) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(state.fullManagement ? context.strings.pairingModeFull : context.strings.pairingModeLimited),
    subtitle: Text(state.fullManagement ? context.strings.pairingModeFullHelp : context.strings.pairingModeLimitedHelp),
    value: state.fullManagement,
    onChanged: state.busy || state.prepared ? null : cubit.mode);

  List<Widget> _status(PairingSelectionState state) => [
    if (state.busy) const LinearProgressIndicator(),
    if (state.error.isNotEmpty) Text(context.strings.pairingSelectionFailed),
    if (!state.prepared) OutlinedButton(
      onPressed: state.busy || state.origins.isEmpty ? null : cubit.prepare,
      child: Text(context.strings.pairingSelectionPrepare)),
  ];

  List<Widget> _spaces(PairingSelectionState state) => [
    for (final entry in widget.controllers().entries)
      CheckboxListTile(contentPadding: EdgeInsets.zero,
        title: Text(entry.value.spaceTitle.isEmpty ? entry.key : entry.value.spaceTitle),
        subtitle: Text(entry.key),
        value: state.origins.contains(entry.key),
        onChanged: state.busy || state.prepared || entry.value.connected ? null
          : (value) => cubit.select(entry.key, value ?? false)),
  ];

  List<Widget> _requests(PairingSelectionState state) => [
    for (final origin in state.origins) ...[
      const SizedBox(height: 24),
      Text(origin, style: Theme.of(context).textTheme.titleMedium),
      if (widget.controllers()[origin] case final controller?)
        PairingStartPanel(key: ValueKey('${state.revision}:$origin'),
          controller: controller, fullManagement: state.fullManagement,
          checkRecord: widget.repository?.checkRecord,
          onConnected: (origin) => widget.onConnected(origin, controller)),
    ],
    const SizedBox(height: 16),
    TextButton(onPressed: cubit.reset, child: Text(context.strings.recoveryCancel)),
  ];
}
