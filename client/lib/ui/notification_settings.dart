import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/preferences.dart';
import 'components.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({
    super.key,
    required this.preferences,
    this.requestPermission,
  });
  final AppPreferences preferences;
  final Future<bool> Function()? requestPermission;
  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool busy = false;
  String error = '';
  Future<void> change(int? mode) async {
    if (mode == null || busy) return;
    setState(() {
      busy = true;
      error = '';
    });
    try {
      if (mode != 0 && await widget.requestPermission?.call() == false) {
        throw StateError('permission');
      }
      await widget.preferences.changeNotifications(mode);
    } catch (_) {
      if (mounted) {
        setState(() => error = context.strings.notificationPermissionError);
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.notifications,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          key: ValueKey((widget.preferences.notificationMode, busy)),
          initialValue: widget.preferences.notificationMode,
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: 0,
              child: Text(context.strings.notificationsOff),
            ),
            DropdownMenuItem(
              value: 1,
              child: Text(context.strings.notificationsPrivate),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text(context.strings.notificationsPreview),
            ),
          ],
          onChanged: busy ? null : change,
        ),
        const SizedBox(height: 12),
        Text(context.strings.notificationsDescription),
        if (error.isNotEmpty)
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    ),
  );
}
