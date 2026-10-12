import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import 'components.dart';

class DevicePanel extends StatelessWidget {
  const DevicePanel({super.key});

  @override
  Widget build(BuildContext context) => PageBody(
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
          ],
        ),
      ),
    ],
  );
}
