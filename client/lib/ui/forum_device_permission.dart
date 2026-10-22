import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/core.dart';
import 'admin_panel.dart' show openAuthorityCard;

Future<void> authorizeForumDevice(
  BuildContext context,
  SpaceSession session,
) async {
  final password = TextEditingController();
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ForumDevicePermissionDialog(
        password: password,
        requiresCard: !session.hasRootAuthority,
      ),
    );
    if (confirmed != true) return;
    final authority = session.hasRootAuthority
        ? null
        : await openAuthorityCard(password.text, 'Space');
    await session.authorizeAdministration(authority: authority);
  } finally {
    password.dispose();
  }
}

class ForumDevicePermissionDialog extends StatelessWidget {
  const ForumDevicePermissionDialog({
    super.key,
    required this.password,
    required this.requiresCard,
  });
  final TextEditingController password;
  final bool requiresCard;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.forumAuthorizeDevice),
    content: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.strings.forumDevicePermissionInfo),
            if (requiresCard) ...[
              const SizedBox(height: 16),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.strings.forumRootPassword,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(context.strings.forumCancel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(context.strings.forumAuthorizeDevice),
      ),
    ],
  );
}
