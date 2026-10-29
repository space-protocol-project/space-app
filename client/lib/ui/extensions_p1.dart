import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/extensions_p1/actions.dart';
import '../src/extensions_p1/document.dart';

// Прототип не зарегистрирован в навигации рабочего приложения.
class ExtensionPanel extends StatelessWidget {
  const ExtensionPanel({
    super.key,
    required this.document,
    required this.actions,
    required this.locale,
    required this.originLabel,
    required this.errorText,
  });
  final ExtensionDocument document;
  final ExtensionActions actions;
  final String locale, originLabel, errorText;

  @override
  Widget build(BuildContext context) => Card(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ExtensionActions, ExtensionActionState>(
        bloc: actions,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                originLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (state is ExtensionFailed)
              Semantics(liveRegion: true, child: Text(errorText)),
            for (final node in document.body)
              _node(context, node, state is ExtensionRunning),
          ],
        ),
      ),
    ),
  );

  Widget _node(BuildContext context, ExtensionNode node, bool busy) {
    final text = document.text(locale, node.label);
    final child = switch (node.component) {
      'text.v1' => Text(text),
      'button.v1' => FilledButton(
        onPressed: busy ? null : () => actions.invoke(node.command),
        child: Text(text),
      ),
      'section.v1' => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(text, style: Theme.of(context).textTheme.titleSmall),
          ),
          for (final nested in node.children) _node(context, nested, busy),
        ],
      ),
      _ => throw StateError('Не проверен компонент UI'),
    };
    return Padding(
      key: ValueKey(node.id),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: child,
    );
  }
}
