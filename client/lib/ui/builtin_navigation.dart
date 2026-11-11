import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/builtin/navigation_cubit.dart';
import '../src/builtin/transport.dart';
import '../src/generated/space/v1/builtin.pb.dart';

class BuiltinNavigation extends StatefulWidget {
  const BuiltinNavigation({
    super.key,
    required this.transport,
    required this.closing,
  });
  final BuiltinTransport transport;
  final Stream<void> closing;
  @override
  State<BuiltinNavigation> createState() => _BuiltinNavigationState();
}

class _BuiltinNavigationState extends State<BuiltinNavigation> {
  late final cubit = BuiltinNavigationCubit(widget.transport)..load();
  StreamSubscription<void>? subscription;
  @override
  void initState() {
    super.initState();
    subscription = widget.closing.listen((_) => cubit.invalidate());
  }

  @override
  void dispose() {
    unawaited(subscription?.cancel());
    unawaited(cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<BuiltinNavigationCubit, BuiltinNavigationState>(
        bloc: cubit,
        listener: (context, state) {
          if (state.opened case final BuiltinSection section) {
            Navigator.pop(context, section);
          }
        },
        builder: (context, state) => AlertDialog(
          title: const Text('Разделы пространства'),
          content: SizedBox(width: 440, height: 360, child: _content(state)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
          ],
        ),
      );
  Widget _content(BuiltinNavigationState state) {
    if (state.busy) return const Center(child: CircularProgressIndicator());
    if (state.failed) {
      return Column(
        children: [
          const Text(
            'Разделы недоступны. Проверьте подключение и права доступа.',
          ),
          TextButton(onPressed: cubit.load, child: const Text('Повторить')),
        ],
      );
    }
    if (state.sections.isEmpty) return const Text('Нет доступных разделов');
    return ListView(
      children: [
        for (final section in state.sections)
          ListTile(
            key: ValueKey(section.instanceId),
            title: Text(section.channel.title),
            onTap: () => cubit.open(section.instanceId),
          ),
      ],
    );
  }
}
