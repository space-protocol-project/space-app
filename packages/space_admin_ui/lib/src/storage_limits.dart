import '../l10n/admin_localizations.dart';

import 'package:flutter/material.dart';

int storageLimitBytes(String text) {
  final value = int.tryParse(text.trim());
  if (value == null || value < 0 || value > 1048576) {
    throw StateError('Укажите целый объём от 0 до 1048576 МиБ');
  }
  return value * 1048576;
}

class StorageLimits extends StatelessWidget {
  const StorageLimits({
    super.key,
    required this.total,
    required this.member,
    required this.enabled,
  });
  final TextEditingController total, member;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        (AdminLocalizations.of(context) ??
                lookupAdminLocalizations(const Locale('ru')))
            .storageTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: total,
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText:
              (AdminLocalizations.of(context) ??
                      lookupAdminLocalizations(const Locale('ru')))
                  .storageTotal,
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: member,
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText:
              (AdminLocalizations.of(context) ??
                      lookupAdminLocalizations(const Locale('ru')))
                  .storageMember,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        (AdminLocalizations.of(context) ??
                lookupAdminLocalizations(const Locale('ru')))
            .storageHelp,
      ),
      const SizedBox(height: 16),
    ],
  );
}
