import 'content_insets.dart';

import 'package:flutter/material.dart';

import '../l10n/admin_localizations.dart';

Future<bool> confirmRecoveryAction(
  BuildContext context,
  String text, {
  String Function(BuildContext)? textBuilder,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) {
        final strings =
            AdminLocalizations.of(context) ??
            lookupAdminLocalizations(const Locale('ru'));
        return AlertDialog(
          scrollable: true,
          title: Text(strings.recoveryConfirm),
          content: Text(textBuilder?.call(context) ?? text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(strings.recoveryConfirmButton),
            ),
          ],
        );
      },
    ) ??
    false;

Future<String?> askRecoveryPassword(
  BuildContext context, {
  required bool creating,
}) async {
  var first = '', second = '';
  bool invalid = false;
  try {
    return await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) {
          return _recoveryPasswordForm(
            context,
            creating: creating,
            invalid: invalid,
            onFirst: (v) => first = v,
            onSecond: (v) => second = v,
            onConfirm: () {
              if (creating && first != second) {
                update(() => invalid = true);
                return;
              }
              Navigator.pop(context, first);
            },
          );
        },
      ),
    );
  } finally {
    first = '';
    second = '';
  }
}

Widget _recoveryPasswordForm(
  BuildContext context, {
  required bool creating,
  required bool invalid,
  required ValueChanged<String> onFirst,
  required ValueChanged<String> onSecond,
  required VoidCallback onConfirm,
}) {
  final strings =
      AdminLocalizations.of(context) ??
      lookupAdminLocalizations(const Locale('ru'));
  return AlertDialog(
    title: Text(creating ? strings.recoveryProtect : strings.recoveryOpen),
    content: SingleChildScrollView(
      primary: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(strings.recoveryPasswordHelp),
          const SizedBox(height: 16),
          TextField(
            scrollPadding: SpaceContentInsets.scrollPaddingOf(context),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            onChanged: onFirst,
            decoration: InputDecoration(labelText: strings.recoveryPassword),
          ),
          if (creating) ...[
            const SizedBox(height: 12),
            TextField(
              scrollPadding: SpaceContentInsets.scrollPaddingOf(context),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              onChanged: onSecond,
              decoration: InputDecoration(
                labelText: strings.recoveryPasswordRepeat,
              ),
            ),
          ],
          if (invalid) Text(strings.recoveryPasswordInvalid),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(strings.cancel),
      ),
      FilledButton(
        onPressed: onConfirm,
        child: Text(
          creating ? strings.recoveryEncrypt : strings.recoveryOpenButton,
        ),
      ),
    ],
  );
}
