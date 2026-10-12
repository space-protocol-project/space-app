import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr/qr.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import '../l10n/strings.dart';

typedef CreateHomeSpace = Future<String> Function(
  String title,
  Map<String, dynamic> icon,
  bool chatEnabled,
);

class SpaceSetupWizard extends StatefulWidget {
  const SpaceSetupWizard({
    super.key,
    required this.create,
    required this.manage,
  });
  final CreateHomeSpace create;
  final VoidCallback manage;

  @override
  State<SpaceSetupWizard> createState() => _SpaceSetupWizardState();
}

class _SpaceSetupWizardState extends State<SpaceSetupWizard> {
  final title = TextEditingController();
  Map<String, dynamic> icon = {'preset': 'orbit'};
  int step = 0;
  bool chat = true, busy = false, iconLoading = false;
  String link = '', error = '';

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  Future<void> next() async {
    if (busy || iconLoading) return;
    if (step == 0) {
      if (title.text.trim().isEmpty) return;
      setState(() => step = 1);
      return;
    }
    setState(() {
      busy = true;
      error = '';
    });
    try {
      final result = await widget.create(title.text.trim(), icon, chat);
      if (mounted) {
        setState(() {
          link = result;
          step = 2;
        });
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    return PopScope(
      canPop: !busy,
      child: Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 580,
            maxHeight: MediaQuery.sizeOf(context).height * .9,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        s.createOwnSpace,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: busy ? null : () => Navigator.pop(context),
                      tooltip: s.close,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text('${step + 1} / 3'),
                const SizedBox(height: 20),
                if (step == 0) ...[
                  TextField(
                    controller: title,
                    maxLength: 80,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(labelText: s.setupSpaceName),
                  ),
                  const SizedBox(height: 16),
                  ServerIconPicker(
                    value: icon,
                    disabled: busy,
                    onChanged: (value) => setState(() => icon = value),
                    onPending: (value) => setState(() => iconLoading = value),
                  ),
                ],
                if (step == 1) ...[
                  Text(
                    s.setupResources,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.chat),
                    value: chat,
                    onChanged: busy
                        ? null
                        : (value) => setState(() => chat = value!),
                  ),
                  for (final label in [s.forum, s.feed, s.rooms])
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(label),
                      subtitle: Text(s.setupComingSoon),
                      value: false,
                      onChanged: null,
                    ),
                  Text(s.setupInternetHelp),
                ],
                if (step == 2) ...[
                  Text(
                    s.setupReady,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 240,
                      height: 240,
                      child: CustomPaint(painter: _LinkQrPainter(link)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SelectableText(link),
                  Text(s.setupInviteHelp),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () =>
                            Clipboard.setData(ClipboardData(text: link)),
                        icon: const Icon(Icons.copy),
                        label: Text(s.copyLink),
                      ),
                      FilledButton.icon(
                        onPressed: widget.manage,
                        icon: const Icon(Icons.tune),
                        label: Text(s.manageSpace),
                      ),
                    ],
                  ),
                ],
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                if (busy) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                  Text(s.setupWorking),
                ],
                if (step < 2) ...[
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (step > 0)
                        TextButton(
                          onPressed: busy ? null : () => setState(() => step--),
                          child: Text(s.setupBack),
                        ),
                      FilledButton(
                        onPressed:
                            busy || iconLoading || title.text.trim().isEmpty
                            ? null
                            : next,
                        child: Text(step == 0 ? s.setupNext : s.createOwnSpace),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkQrPainter extends CustomPainter {
  _LinkQrPainter(String link)
    : matrix = QrImage(
        QrCode(
          payload: QrPayload.fromTypedData(
            Uint8List.fromList(utf8.encode(link)),
          ),
          errorCorrectLevel: QrErrorCorrectLevel.medium,
        ),
      );
  final QrImage matrix;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final cell = size.shortestSide / (matrix.moduleCount + 8);
    final paint = Paint()..color = Colors.black;
    for (var y = 0; y < matrix.moduleCount; y++) {
      for (var x = 0; x < matrix.moduleCount; x++) {
        if (matrix.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH((x + 4) * cell, (y + 4) * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_LinkQrPainter oldDelegate) => true;
}
