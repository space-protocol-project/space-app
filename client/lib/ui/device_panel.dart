import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/server_workspaces.dart';
import 'components.dart';
import 'recovery_panel.dart';

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

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.workspaces,
    builder: (context, _) {
      final entries = widget.workspaces.controllers;
      final origin = entries.containsKey(selected)
          ? selected
          : entries.keys.firstOrNull;
      final controller = entries[origin] ?? widget.fallback;
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
                const SizedBox(height: 8),
                SelectableText(Platform.operatingSystemVersion),
                const Divider(height: 32),
                Text(context.strings.myDeviceStorage),
                const SizedBox(height: 16),
                Text(context.strings.myDeviceAccessHelp),
                if (entries.isNotEmpty) ...[
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
                    onChanged: (value) => setState(() => selected = value),
                  ),
                  if (!controller.connected) ...[
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: controller.busy
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
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          RecoveryPanel(
            key: ObjectKey(controller),
            controller: controller,
            restoreController: widget.restoreController,
            onRestored: (origin, target) async {
              await widget.onRestored(origin, target);
              if (mounted) setState(() => selected = origin);
            },
          ),
        ],
      );
    },
  );
}
