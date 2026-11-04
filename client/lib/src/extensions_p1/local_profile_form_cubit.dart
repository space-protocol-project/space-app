import 'package:flutter_bloc/flutter_bloc.dart';

import 'local_profile_verifier.dart';
import 'local_profile_record.dart';
import 'local_session_cubit.dart';

sealed class LocalProfileFormState {
  const LocalProfileFormState();
}

class ProfileLoading extends LocalProfileFormState {
  const ProfileLoading();
}

class ProfileWorking extends LocalProfileFormState {
  const ProfileWorking();
}

class ProfileUnavailable extends LocalProfileFormState {
  const ProfileUnavailable();
}

class ProfileReady extends LocalProfileFormState {
  const ProfileReady(this.creating, [this.failure]);
  final bool creating;
  final LocalProfileFailure? failure;
}

class ProfileVerified extends LocalProfileFormState {
  const ProfileVerified(this.identity);
  final LocalProfileIdentity identity;
}

class LocalProfileFormCubit extends Cubit<LocalProfileFormState> {
  LocalProfileFormCubit(this.service) : super(const ProfileLoading());
  final LocalProfileVerifier service;

  Future<void> load() async {
    try {
      final existing = await service.hasProfile();
      if (!isClosed) emit(ProfileReady(!existing));
    } catch (_) {
      if (!isClosed) emit(const ProfileUnavailable());
    }
  }

  Future<void> submit(String password, String confirmation) async {
    final current = state;
    if (current is! ProfileReady) return;
    if (current.creating && password != confirmation) {
      emit(ProfileReady(true, LocalProfileFailure.mismatch));
      return;
    }
    emit(const ProfileWorking());
    try {
      final identity = await service.verify(
        password,
        create: current.creating,
        active: () => !isClosed,
      );
      if (!isClosed) emit(ProfileVerified(identity));
    } on LocalProfileException catch (error) {
      if (!isClosed) emit(ProfileReady(current.creating, error.failure));
    } catch (_) {
      if (!isClosed) emit(const ProfileUnavailable());
    }
  }
}
