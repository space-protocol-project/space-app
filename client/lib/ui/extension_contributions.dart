import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/extensions_p1/actions.dart';
import '../src/extensions_p1/contributions.dart';
import '../src/extensions_p1/contributions_cubit.dart';
import 'extensions_p1.dart';

// Владелец создаёт/закрывает Cubit и actions; рабочая навигация не подключена.
class ExtensionContributionsView extends StatelessWidget {
  const ExtensionContributionsView({
    super.key,
    required this.cubit,
    required this.actions,
    this.locale = 'ru',
  });
  final ContributionsCubit cubit;
  final ExtensionActions actions;
  final String locale;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ContributionsCubit, ContributionsState>(
        bloc: cubit,
        builder: (context, state) => switch (state.phase) {
          ContributionsPhase.loading || ContributionsPhase.opening =>
            const Center(child: CircularProgressIndicator()),
          ContributionsPhase.failed => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  liveRegion: true,
                  child: const Text('Расширение недоступно'),
                ),
                FilledButton(
                  onPressed: cubit.load,
                  child: const Text('Повторить'),
                ),
              ],
            ),
          ),
          ContributionsPhase.list => _list(state),
          ContributionsPhase.document => Column(
            children: [
              TextButton.icon(
                key: const ValueKey('contributions-back'),
                onPressed: cubit.back,
                icon: const Icon(Icons.arrow_back),
                label: const Text('К списку'),
              ),
              Expanded(
                child: ExtensionPanel(
                  document: state.document!,
                  actions: actions,
                  locale: locale,
                  originLabel: state.selected!.label(locale),
                  errorText: 'Расширение недоступно',
                ),
              ),
            ],
          ),
        },
      );

  Widget _list(ContributionsState state) => ListView(
    children: [
      TextButton(onPressed: cubit.load, child: const Text('Обновить список')),
      if (state.entries.isEmpty)
        const ListTile(title: Text('Нет элементов расширения')),
      for (final entry in state.entries)
        ListTile(
          key: ValueKey('contribution-${entry.id}'),
          title: Text(entry.label(locale)),
          subtitle: Text(
            entry.kind == ContributionKind.overview ? 'Обзор' : 'Раздел',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => cubit.open(entry.id),
        ),
    ],
  );
}
