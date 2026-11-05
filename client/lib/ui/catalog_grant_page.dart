import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/extensions_p1/catalog_grant_cubit.dart';
import '../src/extensions_p1/local_session_cubit.dart';

class CatalogGrantPage extends StatelessWidget {
  const CatalogGrantPage({
    super.key,
    required this.access,
    required this.runtime,
  });
  final LocalSessionCubit access;
  final SpaceCatalogRuntime runtime;
  @override
  Widget build(BuildContext context) => BlocProvider(
    key: ValueKey((access, runtime)),
    create: (_) => CatalogGrantCubit(access, runtime),
    child: const _Page(),
  );
}

class _Page extends StatelessWidget {
  const _Page();
  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final cubit = context.read<CatalogGrantCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(s.catalogFolders)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            BlocBuilder<CatalogGrantCubit, CatalogScreenState>(
              builder: (_, state) => switch (state) {
                CatalogLocked() => FilledButton(
                  key: const ValueKey('catalog-unlock'),
                  onPressed: cubit.unlock,
                  child: Text(s.localProfileUnlock),
                ),
                CatalogTargets(:final instances) => Column(
                  children: [
                    if (instances.isEmpty) Text(s.catalogEmpty),
                    for (final id in instances)
                      ListTile(
                        key: ValueKey('catalog-target-$id'),
                        title: Text(id),
                        trailing: const Icon(Icons.folder_open),
                        onTap: () => cubit.choose(id),
                      ),
                  ],
                ),
                CatalogWorking() => const Center(
                  child: CircularProgressIndicator(),
                ),
                CatalogReauthenticate() => Column(
                  children: [
                    Text(s.catalogUnlockAgain),
                    FilledButton(
                      key: const ValueKey('catalog-unlock'),
                      onPressed: cubit.unlock,
                      child: Text(s.localProfileUnlock),
                    ),
                    TextButton(
                      onPressed: cubit.cancel,
                      child: Text(s.cancelMessageChange),
                    ),
                  ],
                ),
                CatalogReview(:final instance, :final package, :final path) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(instance),
                      SelectableText(package),
                      SelectableText(path),
                      FilledButton(
                        key: const ValueKey('catalog-approve'),
                        onPressed: cubit.approve,
                        child: Text(s.catalogApprove),
                      ),
                      TextButton(
                        onPressed: cubit.cancel,
                        child: Text(s.cancelMessageChange),
                      ),
                    ],
                  ),
                CatalogGranted(:final instance) => Text(
                  '${s.catalogGranted} · $instance',
                ),
                CatalogFailed() => Column(
                  children: [
                    Text(s.catalogFailed),
                    TextButton(
                      onPressed: cubit.cancel,
                      child: Text(s.catalogRetry),
                    ),
                  ],
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
