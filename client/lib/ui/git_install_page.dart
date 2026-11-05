import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/extensions_p1/git_install_cubit.dart';
import '../src/extensions_p1/installed_extensions_cubit.dart';

class GitInstallPage extends StatelessWidget {
  const GitInstallPage({super.key, required this.owner});
  final InstalledExtensionsCubit owner;
  @override
  Widget build(BuildContext context) => BlocProvider(
    key: ValueKey(owner),
    create: (_) => GitInstallCubit(owner),
    child: const GitInstallView(),
  );
}

class GitInstallView extends StatelessWidget {
  const GitInstallView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Установить расширение из Git')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          BlocBuilder<GitInstallCubit, GitInstallState>(
            builder: (context, state) => switch (state) {
              GitLocked() => FilledButton(
                key: const ValueKey('git-unlock'),
                onPressed: context.read<GitInstallCubit>().unlock,
                child: const Text('Разблокировать профиль'),
              ),
              GitIdle() => const _SourceForm(),
              GitWorking() => const _Progress(),
              GitReview() => _Review(key: ObjectKey(state), review: state),
              GitInstalled(:final instance) => Text(
                'Расширение «$instance» установлено и отключено. Доступ к каталогам выдаётся отдельно.',
              ),
              GitFailed(:final reason) => _Failure(reason),
            },
          ),
        ],
      ),
    ),
  );
}

class _SourceForm extends StatefulWidget {
  const _SourceForm();
  @override
  State<_SourceForm> createState() => _SourceFormState();
}

class _SourceFormState extends State<_SourceForm> {
  final repository = TextEditingController();
  final ref = TextEditingController(text: 'refs/heads/main');
  final path = TextEditingController(text: 'extensions/games');
  final instance = TextEditingController(text: 'games');
  @override
  void dispose() {
    for (final controller in [repository, ref, path, instance]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Готовый подписанный пакет в публичном репозитории GitHub. Установка выполняется на этом устройстве.',
      ),
      _input('git-repository', 'HTTPS URL репозитория', repository),
      _input('git-ref', 'Полный commit или refs/heads/… / refs/tags/…', ref),
      _input('git-path', 'Каталог пакета', path),
      _input('git-instance', 'Идентификатор установки', instance),
      const SizedBox(height: 16),
      FilledButton(
        key: const ValueKey('git-prepare'),
        onPressed: () => context.read<GitInstallCubit>().prepare(
          repository.text,
          ref.text,
          path.text,
          instance.text,
        ),
        child: const Text('Проверить пакет'),
      ),
    ],
  );
  Widget _input(String key, String label, TextEditingController controller) =>
      TextField(
        key: ValueKey(key),
        controller: controller,
        decoration: InputDecoration(labelText: label),
        autocorrect: false,
        maxLength: 256,
      );
}

class _Progress extends StatelessWidget {
  const _Progress();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const CircularProgressIndicator(),
      TextButton(
        onPressed: context.read<GitInstallCubit>().cancel,
        child: const Text('Отмена'),
      ),
    ],
  );
}

class _Review extends StatefulWidget {
  const _Review({super.key, required this.review});
  final GitReview review;
  @override
  State<_Review> createState() => _ReviewState();
}

class _ReviewState extends State<_Review> {
  bool trust = false;
  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final candidate = review.candidate;
    final source = candidate.source.json;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${candidate.manifest.plugin} · ${candidate.manifest.version}'),
        SelectableText(
          'Источник: ${source['repository']}\nКаталог: ${source['path']}\nВерсия источника: ${source['ref']}\nCommit источника: ${source['ref_commit']}\nCommit пакета: ${source['commit']}',
        ),
        SelectableText(
          'SHA-256 пакета: ${candidate.package.digest}\nОтпечаток ключа издателя: ${candidate.publisher}',
        ),
        Text(
          candidate.manifest.permissions.isEmpty
              ? 'Возможности устройства не запрашиваются.'
              : 'Запрашивается чтение выбранных каталогов. Разрешение выдаётся отдельно.',
        ),
        const Text(
          'Подпись подтверждает ключ издателя, а не безопасность поведения расширения.',
        ),
        if (!review.known)
          CheckboxListTile(
            key: const ValueKey('git-trust'),
            value: trust,
            title: const Text(
              'Доверять этому ключу для этого расширения и репозитория',
            ),
            onChanged: (value) => setState(() => trust = value == true),
          ),
        if (review.known)
          const Text('Ключ уже принят в этом локальном профиле.'),
        FilledButton(
          key: const ValueKey('git-confirm'),
          onPressed: review.known || trust
              ? () =>
                    context.read<GitInstallCubit>().confirm(trustUnknown: trust)
              : null,
          child: const Text('Установить на это устройство'),
        ),
        TextButton(
          onPressed: context.read<GitInstallCubit>().cancel,
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure(this.reason);
  final String reason;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(switch (reason) {
        'PublisherChanged' || 'TrustChanged' => 'Ключ издателя изменился. Установка запрещена; прежнее доверие не переносится на новый ключ.',
        'AlreadyInstalled' => 'Этот идентификатор установки уже занят.',
        'Conflict' => 'Реестр изменился. Проверьте пакет заново.',
        _ => 'Пакет не принят. Проверьте URL, версию, наличие подписанного готового пакета и доступность источника.',
      }),
      TextButton(
        onPressed: context.read<GitInstallCubit>().cancel,
        child: const Text('Вернуться'),
      ),
    ],
  );
}
