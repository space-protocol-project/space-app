import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/server_workspaces.dart';
import 'components.dart';
import 'recovery_panel.dart';
import 'user_export.dart';

class DevicePanel extends StatefulWidget {
  const DevicePanel({
    super.key,
    required this.workspaces,
    required this.fallback,
    required this.restoreController,
    required this.onRestored,
  });
  final ServerWorkspaces workspaces;
  final ChatController fallback;
  final ChatController Function(String origin) restoreController;
  final Future<void> Function(String origin, ChatController controller)
  onRestored;
  @override
  State<DevicePanel> createState() => _DevicePanelState();
}

class _DevicePanelState extends State<DevicePanel> {
  String? selected;
  ChatController? operationController;
  String? operationOrigin;
  bool operationActive = false;

  ({String? origin, ChatController controller}) _selection(
    Map<String, ChatController> entries,
  ) {
    if (operationActive) {
      return (origin: operationOrigin, controller: operationController!);
    }
    final origin = entries.containsKey(selected)
        ? selected
        : entries.keys.firstOrNull;
    return (origin: origin, controller: entries[origin] ?? widget.fallback);
  }

  void _lockSelection(bool active, ChatController controller, String? origin) {
    if (!mounted) return;
    setState(() {
      operationActive = active;
      operationController = active ? controller : null;
      operationOrigin = active ? origin : null;
    });
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ServerWorkspaces, WorkspaceState>(
        bloc: widget.workspaces,
        builder: (context, _) {
          final entries = widget.workspaces.controllers;
          final selection = _selection(entries);
          final origin = selection.origin;
          final controller = selection.controller;
          return PageBody(
            title: context.strings.myDevice,
            description: context.strings.myDeviceDescription,
            children: [
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.computer_outlined, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      Platform.operatingSystem,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SelectableText(Platform.operatingSystemVersion),
                    const Divider(height: 32),
                    Text(context.strings.myDeviceStorage),
                    const SizedBox(height: 16),
                    Text(context.strings.myDeviceAccessHelp),
                    if (entries.isNotEmpty)
                      ..._identityDetails(context, entries, origin, controller),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RecoveryPanel(
                key: ObjectKey(controller),
                controller: controller,
                identityOrigin: origin,
                spaceOrigins: entries.keys.toList(),
                onPendingChanged: (active) =>
                    _lockSelection(active, controller, origin),
                restoreController: widget.restoreController,
                onRestored: (origin, target) async {
                  await widget.onRestored(origin, target);
                  if (mounted) setState(() => selected = origin);
                },
              ),
              UserExportButton(parent: controller),
            ],
          );
        },
      );
  List<Widget> _identityDetails(
    BuildContext context,
    Map<String, ChatController> entries,
    String? origin,
    ChatController controller,
  ) {
    return [
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        key: ValueKey('device-identity-$origin'),
        initialValue: origin,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: context.strings.deviceIdentityChoice,
        ),
        items: [
          for (final entry in entries.entries)
            DropdownMenuItem(
              value: entry.key,
              child: Text(
                entry.value.spaceTitle.isEmpty
                    ? entry.key
                    : entry.value.spaceTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: operationActive
            ? null
            : (value) => setState(() => selected = value),
      ),
      if (!controller.connected) ...[
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: controller.busy || operationActive
              ? null
              : () => widget.workspaces.reconnect(origin!),
          icon: const Icon(Icons.link),
          label: Text(context.strings.deviceConnectIdentity),
        ),
      ],
      if (controller.principalId.isNotEmpty) ...[
        const SizedBox(height: 16),
        SelectableText(controller.principalId),
        SelectableText(controller.fingerprint),
      ],
      if (controller.error.isNotEmpty) Text(controller.error),
    ];
  }
}
