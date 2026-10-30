import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/extensions_p1/actions.dart';
import '../src/extensions_p1/demo_session.dart';
import 'extensions_p1.dart';

// Демонстрация не зарегистрирована в навигации рабочего приложения.
class ExtensionDemoView extends StatefulWidget {
  const ExtensionDemoView({super.key, required this.session});
  final ExtensionDemoSession session;

  @override
  State<ExtensionDemoView> createState() => _ExtensionDemoViewState();
}

class _ExtensionDemoViewState extends State<ExtensionDemoView> {
  late final actions = ExtensionActions({
    'acknowledge': widget.session.acknowledge,
  });

  @override
  void initState() {
    super.initState();
    unawaited(widget.session.load());
  }

  @override
  void dispose() {
    unawaited(actions.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ExtensionDemoSession, ExtensionDemoState>(
        bloc: widget.session,
        builder: (context, state) => switch (state) {
          ExtensionDemoLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ExtensionDemoLoaded(:final document) => ExtensionPanel(
            document: document,
            actions: actions,
            locale: 'ru',
            originLabel: 'Демонстрация P1',
            errorText: 'Расширение недоступно',
          ),
          ExtensionDemoUnavailable() => Column(
            children: [
              const Text('Расширение недоступно'),
              FilledButton(
                onPressed: widget.session.load,
                child: const Text('Повторить'),
              ),
            ],
          ),
        },
      );
}
