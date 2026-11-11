import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/extensions_p1/actions.dart';
import '../src/extensions_p1/document.dart';
import '../src/extensions_p1/form_cubit.dart';

class ExtensionForm extends StatefulWidget {
  const ExtensionForm({
    super.key,
    required this.node,
    required this.document,
    required this.actions,
    required this.locale,
    required this.busy,
    required this.errorText,
  });
  final ExtensionNode node;
  final ExtensionDocument document;
  final ExtensionActions actions;
  final String locale, errorText;
  final bool busy;

  @override
  State<ExtensionForm> createState() => _ExtensionFormState();
}

class _ExtensionFormState extends State<ExtensionForm> {
  late ExtensionFormCubit cubit = _create();
  ExtensionFormCubit _create() => ExtensionFormCubit(
    widget.node.children,
    (values) => widget.actions.submit(widget.node.command, values),
  );

  @override
  void didUpdateWidget(covariant ExtensionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node != widget.node || oldWidget.actions != widget.actions) {
      unawaited(cubit.close());
      cubit = _create();
    }
  }

  @override
  void dispose() {
    unawaited(cubit.close());
    super.dispose();
  }

  String text(String key) => widget.document.text(widget.locale, key);
  bool get russian => widget.locale == 'ru';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ExtensionFormCubit, ExtensionFormState>(
        bloc: cubit,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final node in widget.node.children)
              Padding(
                key: ValueKey('form-field-${node.id}'),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _field(node, state),
              ),
            FilledButton(
              key: ValueKey('${widget.node.id}.submit'),
              onPressed: widget.busy ? null : cubit.submit,
              child: Text(text(widget.node.label)),
            ),
            if (_status(state) case final String message)
              Semantics(liveRegion: true, child: Text(message)),
          ],
        ),
      );

  String? _status(ExtensionFormState state) => switch (state.status) {
    ExtensionFormStatus.failed => widget.errorText,
    ExtensionFormStatus.succeeded => russian ? 'Отправлено' : 'Submitted',
    ExtensionFormStatus.invalid =>
      russian ? 'Проверьте поля формы' : 'Check the form fields',
    _ => null,
  };

  Widget _field(ExtensionNode node, ExtensionFormState state) {
    final field = node.field!;
    final error = state.errors.contains(node.id)
        ? (russian ? 'Проверьте значение' : 'Check the value')
        : null;
    return switch (field.kind) {
      'input.v1' => TextFormField(
        key: ValueKey('${identityHashCode(cubit)}.${node.id}'),
        enabled: !widget.busy,
        initialValue: state.values[node.id] as String,
        decoration: InputDecoration(
          labelText: text(node.label),
          errorText: error,
        ),
        maxLength: field.maxLength,
        inputFormatters: [
          TextInputFormatter.withFunction(
            (oldValue, newValue) =>
                newValue.text.runes.length <= field.maxLength
                ? newValue
                : oldValue,
          ),
        ],
        onChanged: (value) => cubit.change(node.id, value),
      ),
      'toggle.v1' => SwitchListTile(
        title: Text(text(node.label)),
        value: state.values[node.id] as bool,
        onChanged: widget.busy ? null : (value) => cubit.change(node.id, value),
      ),
      'choice.v1' => _choice(node, state, error),
      _ => throw StateError('Не проверено поле'),
    };
  }

  Widget _choice(ExtensionNode node, ExtensionFormState state, String? error) {
    final value = state.values[node.id] as String;
    return DropdownButtonFormField<String>(
      key: ValueKey('${identityHashCode(cubit)}.${node.id}'),
      initialValue: value.isEmpty ? null : value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: text(node.label),
        errorText: error,
      ),
      items: [
        for (final option in node.field!.options)
          DropdownMenuItem(
            value: option.value,
            child: Text(text(option.label)),
          ),
      ],
      onChanged: widget.busy
          ? null
          : (value) {
              if (value != null) cubit.change(node.id, value);
            },
    );
  }
}
