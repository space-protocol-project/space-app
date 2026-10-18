import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';
import '../src/home_backup_policy.dart';

Future<HomeBackupPolicy?> editHomeBackupPolicy(
  BuildContext context,
  HomeBackupSettings settings,
) => showDialog<HomeBackupPolicy>(
  context: context,
  builder: (_) => HomeBackupEditor(settings: settings),
);

class HomeBackupEditor extends StatefulWidget {
  const HomeBackupEditor({super.key, required this.settings});
  final HomeBackupSettings settings;
  @override
  State<HomeBackupEditor> createState() => _HomeBackupEditorState();
}

class _HomeBackupEditorState extends State<HomeBackupEditor> {
  final form = GlobalKey<FormState>();
  late bool enabled = widget.settings.policy.enabled;
  late bool prune = widget.settings.policy.prune;
  late int interval = widget.settings.policy.intervalHours;
  late final count = TextEditingController(
    text: '${widget.settings.policy.keepCount}',
  );
  late final days = TextEditingController(
    text: '${widget.settings.policy.keepDays}',
  );
  late final quota = TextEditingController(
    text: '${(widget.settings.policy.maxBytes / (1024 * 1024)).ceil()}',
  );

  @override
  void dispose() {
    count.dispose();
    days.dispose();
    quota.dispose();
    super.dispose();
  }

  void save() {
    if (!form.currentState!.validate()) return;
    Navigator.pop(
      context,
      HomeBackupPolicy(
        enabled: enabled,
        prune: prune,
        intervalHours: interval,
        keepCount: int.parse(count.text),
        keepDays: int.parse(days.text),
        maxBytes: int.parse(quota.text) * 1024 * 1024,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.strings.homeBackupTitle),
    content: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.strings.homeBackupHelp),
              if (!widget.settings.supported)
                Text(context.strings.homeBackupUnsupported),
              SwitchListTile(
                key: const ValueKey('backup-enabled'),
                contentPadding: EdgeInsets.zero,
                title: Text(context.strings.homeBackupEnabled),
                value: enabled,
                onChanged: widget.settings.supported || enabled
                    ? (value) => setState(() => enabled = value)
                    : null,
              ),
              DropdownButtonFormField<int>(
                key: const ValueKey('backup-interval'),
                initialValue: interval,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: context.strings.homeBackupInterval,
                ),
                items: ({6, 12, 24, 168, interval}.toList()..sort())
                    .map(
                      (hours) =>
                          DropdownMenuItem(value: hours, child: Text('$hours')),
                    )
                    .toList(),
                onChanged: (value) => setState(() => interval = value!),
              ),
              SwitchListTile(
                key: const ValueKey('backup-prune'),
                contentPadding: EdgeInsets.zero,
                title: Text(context.strings.homeBackupPrune),
                value: prune,
                onChanged: (value) => setState(() => prune = value),
              ),
              _number(
                'backup-count',
                count,
                context.strings.homeBackupCount,
                3,
                100,
              ),
              _number(
                'backup-days',
                days,
                context.strings.homeBackupDays,
                1,
                3650,
              ),
              _number(
                'backup-quota',
                quota,
                context.strings.homeBackupQuota,
                0,
                1048576,
              ),
              const SizedBox(height: 12),
              Text(context.strings.homeBackupRetention),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
      ),
      FilledButton(
        key: const ValueKey('backup-save'),
        onPressed: save,
        child: Text(context.strings.homeBackupSave),
      ),
    ],
  );

  Widget _number(
    String key,
    TextEditingController controller,
    String label,
    int minimum,
    int maximum,
  ) => TextFormField(
    key: ValueKey(key),
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(labelText: label),
    validator: (value) {
      final number = int.tryParse(value ?? '');
      return number == null || number < minimum || number > maximum
          ? '$minimum–$maximum'
          : null;
    },
  );
}
