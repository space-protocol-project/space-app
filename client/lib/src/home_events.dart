part of 'home_controller.dart';

sealed class HomeEvent<T> extends RequestEvent<T> {}

final class HomeLoaded extends HomeEvent<void> {}

final class HomeIPDetected extends HomeEvent<String> {}

final class HomeDiagnosisRequested extends HomeEvent<void> {
  HomeDiagnosisRequested(this.wanIP);
  final String wanIP;
}

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

final class HomeExportRequested extends HomeEvent<bool> {
  HomeExportRequested(this.path);
  final String path;
}

final class HomeImportRequested extends HomeEvent<bool> {
  HomeImportRequested(this.path, this.publicIP);
  final String path, publicIP;
}

final class HomeNetworkSaved extends HomeEvent<bool> {
  HomeNetworkSaved(
    List<ServerEndpoint> endpoints,
    this.listenHost,
    this.listenPort,
    this.autoPortMapping,
    this.autoPublicIP,
  ) : endpoints = List.unmodifiable(endpoints);
  final List<ServerEndpoint> endpoints;
  final String listenHost;
  final int listenPort;
  final bool autoPortMapping, autoPublicIP;
}
