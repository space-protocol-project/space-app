import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/extensions_p1/local_profile_form_cubit.dart';
import '../src/extensions_p1/local_profile_record.dart';
import '../src/extensions_p1/local_profile_verifier.dart';
import '../src/extensions_p1/local_session_cubit.dart';

class LocalProfileUnlockDialog extends StatefulWidget {
  const LocalProfileUnlockDialog({super.key, required this.service});
  final LocalProfileVerifier service;
  @override
  State<LocalProfileUnlockDialog> createState() =>
      _LocalProfileUnlockDialogState();
}

class _LocalProfileUnlockDialogState extends State<LocalProfileUnlockDialog>
    with WidgetsBindingObserver {
  late final cubit = LocalProfileFormCubit(widget.service);
  final password = TextEditingController();
  final confirmation = TextEditingController();
  bool closing = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(cubit.load());
  }

  void _finish([LocalProfileIdentity? identity]) {
    if (closing || !mounted) return;
    closing = true;
    password.clear();
    confirmation.clear();
    unawaited(cubit.close());
    Navigator.of(context).pop(identity);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _finish();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    password.dispose();
    confirmation.dispose();
    if (!cubit.isClosed) unawaited(cubit.close());
    super.dispose();
  }

  void _submit() {
    if (closing || cubit.isClosed) return;
    final secret = password.text;
    final repeated = confirmation.text;
    password.clear();
    confirmation.clear();
    unawaited(cubit.submit(secret, repeated));
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<LocalProfileFormCubit, LocalProfileFormState>(
        bloc: cubit,
        listener: (context, state) {
          if (state case ProfileVerified(:final identity)) _finish(identity);
        },
        builder: (context, state) => AlertDialog(
          title: Text(context.strings.localProfileTitle),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(child: _content(state)),
          ),
          actions: [
            TextButton(
              onPressed: () => _finish(),
              child: Text(context.strings.cancelMessageChange),
            ),
            if (state case ProfileReady(:final creating))
              FilledButton(
                onPressed: _submit,
                child: Text(
                  creating
                      ? context.strings.localProfileCreate
                      : context.strings.localProfileUnlock,
                ),
              ),
          ],
        ),
      );

  Widget _content(LocalProfileFormState state) => switch (state) {
    ProfileReady(:final creating, :final failure) => _form(creating, failure),
    ProfileUnavailable() => Text(context.strings.localProfileUnavailable),
    _ => const Center(child: CircularProgressIndicator()),
  };

  Widget _form(bool creating, LocalProfileFailure? failure) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        creating
            ? context.strings.localProfileSetupHelp
            : context.strings.localProfileUnlockHelp,
      ),
      const SizedBox(height: 16),
      _passwordField(
        password,
        context.strings.localProfilePassword,
        'local-profile-password',
      ),
      if (creating) ...[
        const SizedBox(height: 12),
        _passwordField(
          confirmation,
          context.strings.localProfileConfirm,
          'local-profile-confirm',
        ),
      ],
      if (failure != null) ...[
        const SizedBox(height: 12),
        Text(
          _failure(failure),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ],
    ],
  );

  Widget _passwordField(
    TextEditingController controller,
    String label,
    String key,
  ) => TextField(
    key: ValueKey(key),
    controller: controller,
    obscureText: true,
    autocorrect: false,
    enableSuggestions: false,
    maxLength: 256,
    decoration: InputDecoration(labelText: label),
    onSubmitted: (_) => _submit(),
  );

  String _failure(LocalProfileFailure failure) => switch (failure) {
    LocalProfileFailure.password => context.strings.localProfilePasswordRule,
    LocalProfileFailure.mismatch => context.strings.localProfileMismatch,
    LocalProfileFailure.denied => context.strings.localProfileDenied,
    LocalProfileFailure.throttled => context.strings.localProfileThrottled,
    LocalProfileFailure.cancelled => context.strings.localProfileUnlockHelp,
  };
}

class LocalProfileAccessCard extends StatelessWidget {
  const LocalProfileAccessCard({super.key, required this.access});
  final LocalSessionCubit access;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LocalSessionCubit, LocalSessionStatus>(
        bloc: access,
        builder: (context, status) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.localProfileTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  status == LocalSessionStatus.unlocked
                      ? context.strings.localProfileOpen
                      : context.strings.localProfileClosed,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _action(status),
                  child: Text(
                    status == LocalSessionStatus.unlocked
                        ? context.strings.localProfileLock
                        : context.strings.localProfileUnlock,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  VoidCallback? _action(LocalSessionStatus status) => switch (status) {
    LocalSessionStatus.unlocked => access.lock,
    LocalSessionStatus.locked => () => unawaited(access.unlock()),
    _ => null,
  };
}
