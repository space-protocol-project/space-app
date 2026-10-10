// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AdminLocalizationsEn extends AdminLocalizations {
  AdminLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get closeManagement => 'Close management';

  @override
  String get managementTitle => 'Space management';

  @override
  String get managementIntro =>
      'Your server. Your rules. A home server owner is assigned using its local setup code.';

  @override
  String get managementSections =>
      'Settings, channels, members, invitations and devices for the selected server.';

  @override
  String get deviceIdentity => 'Current device identity';

  @override
  String get currentConnection =>
      'Uses the current connection identity. No additional account is needed.';

  @override
  String get currentSession =>
      'Uses the current Space session. Open Identity to recover access.';

  @override
  String get connectManagement => 'Manage the current server';

  @override
  String get claimOwner => 'Assign the first owner';

  @override
  String get setupHelp =>
      'Get the code from the server console: space-server -setup-code. It expires in 15 minutes.';

  @override
  String get setupCode => 'One-time server code';

  @override
  String get confirmOwner => 'Confirm ownership';

  @override
  String get authorizeFirst =>
      'First authorize this device in the section below';

  @override
  String get authorizeTitle => 'Allow this device to manage the server';

  @override
  String get authorizeHelp =>
      'The space.manage permission is signed with your root key. It also requires the owner or admin role.';

  @override
  String get authorizeDevice => 'Authorize this device';

  @override
  String get authorizeConfirm => 'Allow server management?';

  @override
  String get authorizeDetails =>
      'You explicitly allow this device to change settings, channels and member access.';

  @override
  String get rootPassword => 'Root card password (JSON/PNG)';

  @override
  String get cancel => 'Cancel';

  @override
  String get allow => 'Allow';

  @override
  String get spaceName => 'Space name';

  @override
  String get chatName => 'General chat name';

  @override
  String get chatsEnabled => 'Chats available to members';

  @override
  String get chatsHelp =>
      'Disabling blocks reading and sending. History is preserved.';

  @override
  String get registration => 'Registration';

  @override
  String get registrationOpen => 'Open';

  @override
  String get registrationClosed => 'By invitation';

  @override
  String get saveSettings => 'Save settings';

  @override
  String get reloadSettings => 'Reload';

  @override
  String get settingsLoaded => 'Settings loaded from the server.';

  @override
  String get settingsSaved => 'Settings saved on the server.';

  @override
  String get setupNeeded =>
      'Device signed in. Enter the server setup code to claim ownership.';

  @override
  String get roleDenied =>
      'Signed in, but your role cannot manage this server.';

  @override
  String get deviceRevoked =>
      'This device was revoked. Recover access or use another device.';

  @override
  String get signInFirst => 'Sign in first';

  @override
  String get identityChanged => 'Identity changed. Sign in again';

  @override
  String get accessBlocked => 'Access to this space is blocked';

  @override
  String get bothNames => 'Enter both names';

  @override
  String get settingsConflict =>
      'Settings have changed. Reload them and try again.';

  @override
  String settingsRevision(String revision) {
    return 'Space settings · revision $revision';
  }
}
