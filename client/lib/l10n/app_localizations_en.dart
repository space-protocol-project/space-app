// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get overview => 'Overview';

  @override
  String get chat => 'General chat';

  @override
  String get forum => 'Discussions';

  @override
  String get feed => 'Feed';

  @override
  String get rooms => 'Meetings';

  @override
  String get identity => 'My access and devices';

  @override
  String get settings => 'Settings';

  @override
  String get yourSpace => 'Your space';

  @override
  String get connected => 'Connected';

  @override
  String get spaceDisconnected => 'Space is not connected';

  @override
  String get connection => 'Connection';

  @override
  String get addSpace => 'Add a space';

  @override
  String get chats => 'Chats';

  @override
  String get channels => 'Channels';

  @override
  String get recentSpaces => 'Recent spaces';

  @override
  String get prototype => 'Experimental desktop app';

  @override
  String get logo => 'Space logo';

  @override
  String get selectedSpace => 'Selected space';

  @override
  String get myIdentity => 'My access and devices';

  @override
  String get aboutSpace => 'About this space';

  @override
  String get independentServer => 'This server controls channels and access.';

  @override
  String get deviceSignedIn => 'Signed in with a device key';

  @override
  String get noSession => 'No active session';

  @override
  String get checkConnection => 'Check connection';

  @override
  String get beYourself => 'Be yourself.';

  @override
  String get ownPace => 'Camera and microphone are off.';

  @override
  String get openNavigation => 'Open navigation';

  @override
  String get reconnecting => 'Reconnecting';

  @override
  String get keyLogin => 'Key sign-in';

  @override
  String get disconnected => 'Not connected';

  @override
  String get serverConnection => 'Server connection';

  @override
  String get appearanceSettings => 'Appearance settings';

  @override
  String get welcome => 'Your space';

  @override
  String get welcomeDescription => 'Server channels and resources.';

  @override
  String get ideas => 'A place for ideas.\nAnd the people behind them.';

  @override
  String get connectDescription => 'Add a server by address or invitation.';

  @override
  String get returnChat => 'Back to the conversation';

  @override
  String get yourConversation => 'Your conversation';

  @override
  String get noMessages => 'Connect to open messages.';

  @override
  String get openChat => 'Open chat';

  @override
  String get yourAttention => 'Your attention';

  @override
  String get attentionDescription =>
      'The app does not send system notifications or activate your camera or microphone. Keep your own pace.';

  @override
  String get settingsTitle => 'App settings';

  @override
  String get settingsDescription => 'Saved on this device.';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get themeDescription => 'Gruvbox comes in light and dark variants.';

  @override
  String get compact => 'Compact mode';

  @override
  String get compactDescription => 'More compact controls.';

  @override
  String get myColors => 'My colors';

  @override
  String get ocean => 'Quiet ocean';

  @override
  String get iris => 'Soft iris';

  @override
  String get spaceAppearance => 'Space appearance';

  @override
  String get spaceAppearanceDescription =>
      'A server will be able to suggest colors. Your personal theme stays until you accept. This version does not receive these suggestions yet.';

  @override
  String get language => 'App language';

  @override
  String get searchHint => 'Sections and loaded messages';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get back => 'Back';

  @override
  String get nothingFound => 'Nothing found. Try another word.';

  @override
  String get appSection => 'App section';

  @override
  String get loadedMessage => 'General chat · loaded message';

  @override
  String messageCount(int count) {
    return 'Messages in general chat: $count';
  }

  @override
  String get revokeTitle => 'Revoke this device?';

  @override
  String get revokeDescription =>
      'Access to this server will end. Keys stay on this computer; a new permission will not be created automatically.';

  @override
  String get keep => 'Keep';

  @override
  String get revoke => 'Revoke';

  @override
  String get archived => 'Archived';

  @override
  String get noReadAccess => 'No message access';

  @override
  String get manageSpace => 'Manage space';

  @override
  String get forumTitle => 'Good conversations stay.';

  @override
  String get forumDescription => 'A place for discussions that need more time.';

  @override
  String get feedTitle => 'A little inspiration.';

  @override
  String get feedDescription => 'Posts from people you choose.';

  @override
  String get search => 'Search';

  @override
  String get recoveringEvents =>
      'Recovering events. Messages and your draft are preserved.';

  @override
  String get chatTab => 'Chat';

  @override
  String get topicsTab => 'Topics';

  @override
  String get profileTab => 'Profile';

  @override
  String unreadCount(int count) {
    return 'Unread messages: $count';
  }

  @override
  String get findSpace => 'Find your space';

  @override
  String get closeConnection => 'Close connection';

  @override
  String get connectionIntro => 'Enter a server address or invitation.';

  @override
  String get serverAddress => 'Server address or invitation link';

  @override
  String get optionalInvite => 'Invitation code (optional)';

  @override
  String get checkServer => 'Check server';

  @override
  String get verifyTrust => 'Verify trust';

  @override
  String get serverKeyFingerprint => 'Server key fingerprint';

  @override
  String get tlsCertificateFingerprint => 'TLS certificate fingerprint';

  @override
  String get firstTrustHelp =>
      'On your first visit, compare the address and fingerprint with the owner’s known details. Signing in creates separate keys for this server.';

  @override
  String get readerInvitation => 'Reader invitation: read-only chat access.';

  @override
  String get memberInvitation => 'Member invitation: read and write in chat.';

  @override
  String get trustAndConnect => 'Trust and connect';

  @override
  String get disconnectServer => 'Disconnect from server';

  @override
  String get supportedConnections =>
      'Public HTTPS servers and local HTTP are supported. Open recovery cards in Identity.';

  @override
  String get chatDescription => 'Conversations and little discoveries.';

  @override
  String get connectionInformation => 'Connection information';

  @override
  String get channel => 'Channel';

  @override
  String get noReading => 'No read access';

  @override
  String get refreshChat => 'Refresh channels and chat';

  @override
  String get noMessageAccess => 'No access to messages';

  @override
  String get startConversation => 'Start a conversation';

  @override
  String get conversationStarts => 'The conversation starts here';

  @override
  String get contactOwner =>
      'Choose another channel or contact the space owner.';

  @override
  String get emptyChat => 'There are no messages in this chat yet.';

  @override
  String get connectChatHelp =>
      'Connect your space. Your keys stay on this device.';

  @override
  String get you => 'You';

  @override
  String get newMessages => 'New messages';

  @override
  String get cannotSend => 'You cannot send messages in this channel';

  @override
  String get messageHint => 'What’s new?';

  @override
  String get sendMessage => 'Send';

  @override
  String newMessagesCount(int count) {
    return 'New messages: $count';
  }

  @override
  String newChannelMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new',
      one: '1 new',
    );
    return '$_temp0';
  }

  @override
  String get homeTitle => 'Home server';

  @override
  String get close => 'Close';

  @override
  String get homeFirstSetup =>
      'The server and data will be created on this computer.';

  @override
  String get homeReuse => 'Your server and data are saved.';

  @override
  String get homeIP => 'Static public IPv4';

  @override
  String get homeIPHint => 'Address assigned by your internet provider';

  @override
  String get detectingIP => 'Detecting IP…';

  @override
  String get detectIP => 'Detect IP automatically';

  @override
  String get homeIPPrivacy =>
      'IP detection uses ipify. If you use a VPN, it will show the VPN address.';

  @override
  String get homeIPFailed =>
      'Could not detect your address. Enter your static IP.';

  @override
  String get homePortHelp =>
      'To let friends connect, forward TCP port 8443 on your router to port 8443 on this computer and allow it through the firewall. Keep PostgreSQL and local ports private.';

  @override
  String get goLive => 'Go live';

  @override
  String get stopHome => 'Disconnect';

  @override
  String get homeLink =>
      'Your server link (paste it into the connection screen in Space)';

  @override
  String get copyLink => 'Copy link';

  @override
  String get manageServer => 'Manage server';

  @override
  String get homeInviteHelp =>
      'Invitations: Space management. Stopping disconnects participants.';

  @override
  String get myHomeServer => 'My home server';

  @override
  String get homeRunningHelp =>
      'The server is running. Disconnecting preserves all data.';

  @override
  String get homeStartHelp => 'Run your own space on this computer.';

  @override
  String get myServer => 'Go live';

  @override
  String get homeDetectingIP => 'Detecting public IP with ipify';

  @override
  String get homeDownloading => 'Downloading the server and PostgreSQL';

  @override
  String get homeInstalling => 'Verifying and installing the release';

  @override
  String get homeUpdating => 'Checking and updating server';

  @override
  String get homeUpdate => 'Update server';

  @override
  String get homeReleaseChanges => 'Release changes';

  @override
  String get managementTab => 'Manage';

  @override
  String get homeNoReleaseNotes =>
      'No change description was provided for this release.';

  @override
  String homeSpaceDetails(String required, String available) {
    return 'Required: $required MiB · available: $available MiB';
  }

  @override
  String get failureHomeSpaceLow =>
      'There is not enough free space for the home server operation. Free up space and retry.';

  @override
  String get failureHomeSpaceUnknown =>
      'Free space could not be checked. Check that the disk is accessible and retry.';

  @override
  String get homeResumeUpdate => 'Resume update or recovery';

  @override
  String get homeUpdateConfirm =>
      'The server will be temporarily unavailable to participants. A backup is created before migrations. The server stays off after the operation: start it with Go live.';

  @override
  String get homeStarting => 'Starting your existing server';

  @override
  String get homeRunning => 'The server is running on this computer';

  @override
  String get homeStopped => 'Server stopped; data preserved';

  @override
  String serverNowOnline(String server) {
    return 'Server $server is now online.';
  }

  @override
  String serverNowOffline(String server) {
    return 'Connection to server $server was lost.';
  }

  @override
  String get serverAvailabilityUnknown => 'Availability is not yet known';

  @override
  String get recoveryOperationFailed =>
      'The operation did not finish. Check access, the card and the connection.';

  @override
  String get recoveryFileLabel => 'Space card';

  @override
  String get recoveryFormat => 'Card format';

  @override
  String get recoveryFormatHelp =>
      'PNG contains an encrypted QR code suitable for printing. JSON is a compact backup file. Keep the password separately.';

  @override
  String get recoveryPng => 'QR in PNG';

  @override
  String get recoveryCardSaved =>
      'Card saved. Test recovery on another device; store the file and password separately.';

  @override
  String get recoveryTooLarge => 'Card is too large';

  @override
  String get recoveryReplaceWarning =>
      'Saved keys for this address will be replaced. Back them up as a card first if they belong to another identity.';

  @override
  String get recoveryConnectionDenied =>
      'Keys saved, but the server denied the connection. Check whether the card was revoked, access blocked or chat unavailable.';

  @override
  String get recoveryRestored =>
      'Identity restored with a new device. Check the device list and revoke lost devices.';

  @override
  String get rotationRenewConfirm =>
      'Renew the expired request using the same saved new keys? If the server already completed rotation, finish the saved rotation instead.';

  @override
  String get rotationConfirm =>
      'Rotate the root key? Your ID, permissions and history stay unchanged. Old devices and cards lose access. The new secret is first saved in a protected journal. Save a new card after rotation.';

  @override
  String get rotationServerRequired =>
      'First check the original server address';

  @override
  String get rotationNotPending => 'No saved key rotation for this server.';

  @override
  String get rotationReconnect =>
      'New key saved. Check server availability and reconnect.';

  @override
  String get rotationCompleted =>
      'Root key rotated; your ID is preserved. Save a new card. Old cards and devices no longer work.';

  @override
  String get recoveryRevokeCard =>
      'Revoke the recovery key? The card and all devices connected through it will stop working. Make sure you have another access method.';

  @override
  String get recoveryRevokeDevice =>
      'Revoke this device? Its sessions and subscriptions will end.';

  @override
  String get recoveryRevoked => 'Permission revoked on the server.';

  @override
  String get pairingAlreadyUsed => 'Code already used or cancelled';

  @override
  String get pairingManageRequest =>
      'Space management is also requested if the role allows it.';

  @override
  String get pairingChatRequest =>
      'Chat access with your permissions is requested.';

  @override
  String get pairingReady =>
      'The code also appears on the new device. Enter its verification code before signing.';

  @override
  String get pairingMismatch =>
      'Verification codes do not match. Do not approve the connection.';

  @override
  String get pairingSignConfirm =>
      'Do the codes on both devices match? Sign for the new device with the specified permissions using the root authority?';

  @override
  String get pairingSigned =>
      'Signature issued. Finish signing in on the new device.';

  @override
  String get pairingStartFailed =>
      'Could not start pairing. Check the server and PostgreSQL availability.';

  @override
  String get pairingCancelled => 'Pairing cancelled';

  @override
  String get pairingExpired =>
      'The code expired, was cancelled or the approval failed verification. Start again.';

  @override
  String get pairingCompareTitle => 'Compare the code on both devices';

  @override
  String get pairingMatches => 'Code matches';

  @override
  String recoveryRestoreConfirm(String origin, String warning) {
    return 'Restore identity on $origin? A new key will be created for this device. $warning';
  }

  @override
  String pairingPrepareConfirm(String device, String request) {
    return 'Prepare to connect “$device” to your identity? $request No signature is issued yet. Compare the code on both screens first.';
  }

  @override
  String pairingAcceptConfirm(String code, String origin) {
    return 'The approving device must display code $code. Does it match? The identity saved here for $origin will be replaced. Save its card first if it belongs to another account.';
  }

  @override
  String get recoveryCancel => 'Cancel';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get dashboardTitle => 'All your spaces, together.';

  @override
  String get dashboardDescription => 'Servers, channels and unread messages.';

  @override
  String get dashboardServers => 'Servers';

  @override
  String get dashboardOnline => 'Online';

  @override
  String get dashboardChannels => 'Accessible channels';

  @override
  String get dashboardUnread => 'Unread messages';

  @override
  String get dashboardRefresh => 'Refresh overview';

  @override
  String get dashboardEmpty => 'Add your first space';

  @override
  String get dashboardEmptyHelp => 'Add a server or create your own.';

  @override
  String get dashboardCatalogUnknown => 'Connect to load channels.';

  @override
  String get dashboardAvailable => 'Available';

  @override
  String get dashboardUnavailable => 'Unavailable';

  @override
  String get dashboardOpen => 'Open space';

  @override
  String get dashboardResourcesHelp =>
      'The overview includes accessible channels and unread messages. Data from unavailable servers appears after reconnection.';

  @override
  String get dashboardSpaces => 'Your spaces';

  @override
  String get failureCardCorrupt =>
      'The card is damaged or has an invalid format.';

  @override
  String get failurePasswordInvalid =>
      'The password must contain at least 12 characters and no more than 512 bytes.';

  @override
  String get failureCardTooLarge => 'The card exceeds the allowed size.';

  @override
  String get failureCardUnsupported =>
      'The card format or encryption parameters are unsupported.';

  @override
  String get failureCardAuthentication =>
      'Wrong password or damaged card. Check the file and password.';

  @override
  String get failureReleaseInvalid =>
      'The server release descriptor failed validation. Installation stopped.';

  @override
  String get failurePlatformUnsupported =>
      'No verified home server release is available for this platform.';

  @override
  String get failureDownloadAddress =>
      'The server download address is not allowed. Installation stopped.';

  @override
  String get failureDownloadFailed =>
      'Could not download the server. Check the connection and try again.';

  @override
  String get failureRedirectLimit =>
      'The download has too many redirects. Installation stopped.';

  @override
  String get failureReleaseSize =>
      'The server download is incomplete or its size is incorrect. Download it again.';

  @override
  String get failureHashMismatch =>
      'The release checksum does not match. This archive must not be executed.';

  @override
  String get failureArchiveInvalid =>
      'The server archive contains invalid paths, files or sizes. Installation stopped.';

  @override
  String get failureExecutePermission =>
      'Could not grant permission to run the server. Check access to the application directory.';

  @override
  String get failureHomeStartFailed =>
      'Could not start the home server. Check data access, available ports and connection settings.';

  @override
  String get failureHomeStopFailed =>
      'The server did not confirm that all processes stopped. Check its state before restarting.';

  @override
  String get failureHomeUpdatePending =>
      'The home server update is unfinished. Complete the update or recovery first; normal startup is blocked.';

  @override
  String get failureHomeUpdateFailed =>
      'The update was not completed. Check the operation state and retry; the new version will not start without verification.';

  @override
  String get failurePermissionDenied =>
      'The server denied access. Check your role, block status and invitation.';

  @override
  String get failureUnauthenticated =>
      'The session or device authorization is invalid. Sign in again; no new authorization is created automatically.';

  @override
  String get failureServerLimit =>
      'A server limit was reached. Try again later.';

  @override
  String get failureConnectionFailed =>
      'Could not reach the server. Check the address and network.';

  @override
  String get failureTlsRejected =>
      'The secure connection could not be verified. Check the certificate and trusted fingerprint.';

  @override
  String get failureProtocolInvalid =>
      'The server returned incompatible or invalid data. The operation was stopped.';

  @override
  String get failureIdentityInvalid =>
      'Key, signature or identity verification failed. The operation was stopped.';

  @override
  String get failureAddressInvalid =>
      'Enter an HTTPS server address or a local HTTP address. Check the link and invitation code.';

  @override
  String get failureOperationFailed =>
      'The operation failed. Check the connection and access to secure storage.';

  @override
  String get failureRetrySameRequest =>
      'Retrying the same text reuses the original request key.';

  @override
  String get failurePositionsLoad =>
      'Could not load reading positions. History will be loaded again.';

  @override
  String get failurePositionsSave =>
      'The reading position was updated but could not be saved on this device.';

  @override
  String get failureChannelChanged =>
      'Channel permissions changed. Refresh the chat before retrying.';

  @override
  String get failureChannelUnavailable =>
      'Access to this channel changed. Select an accessible chat.';

  @override
  String get failureEventsUnsupported =>
      'This server does not support event subscriptions yet. Update the server.';

  @override
  String get failureCursorRejected =>
      'The server rejected the history cursor. Reconnect to load messages.';

  @override
  String get failureDeviceRevoked =>
      'Access for this device was revoked. Keys were preserved; no new authorization is created automatically.';

  @override
  String get failureQrTooLarge =>
      'The card is too large for QR. Save it as JSON.';

  @override
  String get failureQrFileTooLarge =>
      'The file exceeds the size limit: PNG 8 MiB, JSON 16 KiB.';

  @override
  String get failureQrImageInvalid =>
      'The PNG is damaged or has invalid dimensions. Use the original file, 64–2048 pixels on each side.';

  @override
  String get failureQrUnreadable =>
      'The QR could not be read or is not a Space card. Select the original PNG with white margins.';

  @override
  String get failureKeyStorageMismatch =>
      'The key record belongs to another address. The operation was stopped.';

  @override
  String get failureKeyStorageSave =>
      'Secure storage did not confirm that keys were saved. Rotation is not submitted without a saved key.';

  @override
  String get failureKeyJournalInvalid =>
      'The key rotation journal is damaged or exceeds 64 KiB. Check secure storage.';

  @override
  String get failureCameraDenied =>
      'Camera access was denied. Allow it in system settings.';

  @override
  String get failureCameraUnavailable =>
      'The camera is unavailable or busy. Restore from PNG or JSON instead.';

  @override
  String get failureCameraFrame =>
      'Could not read the frame. Check the camera or select a file.';

  @override
  String get failureCameraStopped =>
      'The camera was stopped. Select Restart camera.';

  @override
  String get sendingMessage => 'Sending…';

  @override
  String get messageUnconfirmed =>
      'No server confirmation. Retry with the same text.';

  @override
  String get messageAccepted => 'Accepted by server';

  @override
  String get appSettings => 'App settings';

  @override
  String get serverSettings => 'Server settings';

  @override
  String get homeStopping => 'Stopping server and database…';

  @override
  String get homeProgressHint =>
      'Progress by completed stages. Process waiting time is not known in advance.';

  @override
  String homeProgressElapsed(int seconds) {
    return 'Elapsed: $seconds s';
  }

  @override
  String homeDownloadEstimate(int seconds) {
    return 'Download: about $seconds s remaining';
  }

  @override
  String get identityDescription =>
      'Keys, permissions and recovery for the selected space.';

  @override
  String get sendShortcutTitle => 'Send shortcut';

  @override
  String get sendShortcutHelp =>
      'Choose Enter or Shift+Enter to send. The other combination inserts a new line.';

  @override
  String get createOwnSpace => 'Create space';

  @override
  String get setupSpaceName => 'Name';

  @override
  String get setupResources => 'Sections';

  @override
  String get setupComingSoon => 'Coming soon';

  @override
  String get setupInternetHelp =>
      'For friends: public IPv4 and TCP 8443 forwarding.';

  @override
  String get setupReady => 'Your space is ready';

  @override
  String get setupInviteHelp =>
      'Single-use invitation · 24 hours. Create more in management.';

  @override
  String get setupWorking => 'Creating space…';

  @override
  String get setupBack => 'Back';

  @override
  String get setupNext => 'Next';

  @override
  String get setupOwnerRequired =>
      'Could not connect as owner. Open Go live and check the server status.';

  @override
  String get setupUpdateRequired =>
      'Update the home server before configuring its icon.';

  @override
  String get myDevice => 'My device';

  @override
  String get myDeviceDescription => 'Identities and keys on this device.';

  @override
  String get myDeviceStorage => 'Keys are in protected device storage.';

  @override
  String get myDeviceAccessHelp =>
      'Select an identity for QR, recovery and pairing.';

  @override
  String get deviceIdentityChoice => 'Identity on this device';

  @override
  String get deviceConnectIdentity => 'Connect identity';

  @override
  String get recoveryReadingFile => 'Reading file…';

  @override
  String get recoveryDecryptingCard => 'Decrypting and validating keys…';

  @override
  String get recoveryCheckingServer => 'Checking server…';

  @override
  String get recoveryConnectingDevice => 'Connecting device…';

  @override
  String get recoveryChooseFile => 'Choose a PNG or JSON card';

  @override
  String get recoveryParentFolder => 'Parent folder';

  @override
  String get recoveryFilePath => 'Full file path';

  @override
  String get recoveryOpenFile => 'Open file';

  @override
  String get recoveryFolderUnavailable =>
      'Could not read this folder. Enter the full file path.';

  @override
  String get setupExisting => 'Configure your saved space.';

  @override
  String get recoveryGeneratingQr => 'Creating QR…';

  @override
  String get recoverySaveQr => 'Save QR';

  @override
  String get recoveryOverwriteQr => 'Replace the existing QR card file?';

  @override
  String get serverSearch => 'Find a space';

  @override
  String get serverFilterAll => 'All';

  @override
  String get serverNoEvents => 'No loaded messages';

  @override
  String get serverOffline => 'Offline';

  @override
  String get removeServer => 'Remove from app';

  @override
  String get removeServerConfirm =>
      'History on this device will be deleted. You can add the server again.';

  @override
  String get serverAccessRemoved => 'Access revoked. Server removed.';

  @override
  String get serverRemoveFailed => 'Could not remove the server. Try again.';

  @override
  String get serverInAir => 'Server is online';

  @override
  String get serverNoChannels => 'No available channels';

  @override
  String get spacesTitle => 'Spaces';

  @override
  String get updatesTitle => 'Updates';

  @override
  String get updatesCheck => 'Check for updates';

  @override
  String get updatesChecking => 'Checking…';

  @override
  String get updatesCurrent => 'You are up to date';

  @override
  String updatesAvailable(String version) {
    return 'Version $version is available';
  }

  @override
  String get updatesEmpty => 'No published builds yet';

  @override
  String get updatesFailed => 'Unable to check. Try again.';

  @override
  String get updatesOpen => 'Open release';

  @override
  String get updatesChanges => 'Changes';

  @override
  String updatesInstalled(String version) {
    return 'Version $version';
  }

  @override
  String get updatesUnknownVersion => 'Version unavailable';

  @override
  String get updatesOpenFailed => 'Unable to open the release page';

  @override
  String get updatesPackageUnavailable =>
      'No package is available for this system yet.';

  @override
  String updatesPackage(String platform, String size) {
    return '$platform · $size MB';
  }

  @override
  String get updatesDownload => 'Download';

  @override
  String get updatesDownloadFailed => 'Download failed. Please retry.';

  @override
  String get updatesDownloaded => 'Package downloaded and verified.';
}
