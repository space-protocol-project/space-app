part of 'home_controller.dart';

sealed class HomeEvent<T> extends RequestEvent<T> {}

final class HomeLoaded extends HomeEvent<void> {}

final class HomeIPDetected extends HomeEvent<String> {}

final class HomeUpdatePrepared extends HomeEvent<bool> {}

final class HomeUpdateRequested extends HomeEvent<void> {
  HomeUpdateRequested({this.recover = false});
  final bool recover;
}

final class HomeStarted extends HomeEvent<HomeServerState?> {
  HomeStarted(this.address);
  final String address;
}

final class HomeStopped extends HomeEvent<void> {
  HomeStopped({this.disconnectClient});
  final Future<void> Function()? disconnectClient;
}

final class HomeErrorReported extends HomeEvent<void> {
  HomeErrorReported(this.message);
  final String message;
}

final class HomeStatePublished extends HomeEvent<void> {
  HomeStatePublished(this.state);
  final HomeState state;
}

final class HomeProgressTicked extends HomeEvent<void> {}
