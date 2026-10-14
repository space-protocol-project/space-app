part of 'app_updates.dart';

sealed class AppUpdateEvent<T> extends RequestEvent<T> {}

final class AppUpdateInitialized extends AppUpdateEvent<void> {}

final class AppUpdateChecked extends AppUpdateEvent<void> {}

final class AppUpdateDownloaded extends AppUpdateEvent<void> {}

final class AppUpdateInstalled extends AppUpdateEvent<void> {
  AppUpdateInstalled(this.prepare);
  final Future<void> Function() prepare;
}

final class AppUpdateStatePublished extends AppUpdateEvent<void> {
  AppUpdateStatePublished(this.state);
  final AppUpdateState state;
}
