import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'git_package.dart';
import 'git_trust.dart';
import 'github_transport.dart';
import 'installed_extensions_cubit.dart';
import 'local_session_cubit.dart';
import 'local_sessions.dart';
import 'registry_validation.dart';

sealed class GitInstallState {
  const GitInstallState();
}

class GitIdle extends GitInstallState {
  const GitIdle();
}

class GitLocked extends GitInstallState {
  const GitLocked();
}

class GitWorking extends GitInstallState {
  const GitWorking();
}

class GitInstalled extends GitInstallState {
  const GitInstalled(this.instance);
  final String instance;
}

class GitFailed extends GitInstallState {
  const GitFailed(this.reason);
  final String reason;
}

class GitReview extends GitInstallState {
  const GitReview(this.candidate, this.instance, this.revision, this.known);
  final GitCandidate candidate;
  final String instance;
  final int revision;
  final bool known;
}

class GitInstallCubit extends Cubit<GitInstallState> {
  GitInstallCubit(this.owner, {GitObjectTransport Function()? transport})
    : transport = transport ?? GithubTransport.new,
      super(
        owner.access.state == LocalSessionStatus.unlocked
            ? const GitIdle()
            : const GitLocked(),
      ) {
    owner.access.sessions.addListener(_locked);
  }
  final InstalledExtensionsCubit owner;
  final GitObjectTransport Function() transport;
  GitObjectTransport? _request;
  Timer? _expiry;
  LocalExtensionSession? _session;
  int _epoch = 0;

  void _guard(int epoch, LocalExtensionSession session) {
    if (isClosed || epoch != _epoch) throw StateError('Cancelled');
    owner.access.sessions.require(
      session,
      '${session.device}/${session.profile}',
    );
  }

  Future<void> unlock() async {
    if (state is! GitLocked) return;
    final epoch = _epoch;
    final unlocked = await owner.access.unlock();
    if (!isClosed && epoch == _epoch && unlocked) emit(const GitIdle());
  }

  Future<void> prepare(
    String repository,
    String ref,
    String path,
    String instance,
  ) async {
    cancel();
    if (state is GitLocked) return;
    final epoch = _epoch;
    emit(const GitWorking());
    try {
      validateRegistryName(instance);
      final session = _session = owner.access.session;
      void guard() => _guard(epoch, session);
      await owner.ensure(session);
      guard();
      final snapshot = owner.runtime.forSession(session)!.snapshot(session);
      if (snapshot.entries.containsKey(instance)) {
        throw StateError('AlreadyInstalled');
      }
      final request = _request = transport();
      final candidate = await GitPackageLoader(request)
          .load(repository, ref, path, guard);
      final known = await GitTrust(
        owner.storage,
        '${session.device}/${session.profile}',
      ).inspect(candidate, guard);
      guard();
      emit(GitReview(candidate, instance, snapshot.revision, known));
      _expiry = Timer(const Duration(minutes: 2), cancel);
    } catch (error) {
      if (!isClosed && epoch == _epoch) emit(GitFailed(_reason(error)));
    } finally {
      if (epoch == _epoch) {
        _request?.close();
        _request = null;
      }
    }
  }

  Future<void> confirm({bool trustUnknown = false}) async {
    final review = state;
    if (review is! GitReview || (!review.known && !trustUnknown)) return;
    final session = _session!;
    final epoch = _epoch;
    void guard() => _guard(epoch, session);
    emit(const GitWorking());
    try {
      final trust = GitTrust(
        owner.storage,
        '${session.device}/${session.profile}',
      );
      await owner.installAccepted(
        session,
        review.candidate.package,
        review.candidate.bytes,
        installation: review.instance,
        instance: review.instance,
        expectedRevision: review.revision,
        active: guard,
        beforeAdmit: () => trust.accept(review.candidate, review.known, guard),
      );
      guard();
      _expiry?.cancel();
      emit(GitInstalled(review.instance));
    } catch (error) {
      if (!isClosed && epoch == _epoch) emit(GitFailed(_reason(error)));
    }
  }

  String _reason(Object error) {
    if (error is StateError &&
        const [
          'PublisherChanged',
          'TrustChanged',
          'AlreadyInstalled',
          'Conflict',
        ].contains(error.message)) {
      return error.message;
    }
    return 'PackageRejected';
  }

  void _discard() {
    _epoch++;
    _expiry?.cancel();
    _request?.close();
    _request = null;
    _session = null;
  }

  void _locked() {
    _discard();
    if (!isClosed) emit(const GitLocked());
  }

  void cancel() {
    _discard();
    if (!isClosed) {
      emit(
        owner.access.state == LocalSessionStatus.unlocked
            ? const GitIdle()
            : const GitLocked(),
      );
    }
  }

  @override
  Future<void> close() {
    owner.access.sessions.removeListener(_locked);
    _discard();
    return super.close();
  }
}
