// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get voiceShortcutTitle => 'Push-to-talk shortcut';

  @override
  String get voiceShortcutScope =>
      'Active window only. Transmission closes on focus loss.';

  @override
  String get voiceShortcutPress =>
      'Press a key or combine it with Ctrl, Alt, Shift or Meta. Release the keys before saving. Escape cancels.';

  @override
  String get voiceShortcutSave => 'Save';

  @override
  String get deviceTransferTitle => 'Device transfer';

  @override
  String get deviceTransferHelp =>
      'Two steps: save one encrypted archive, then drop it here on the new device. Spaces, keys, history, queues, drafts, settings and the home server move together.';

  @override
  String get deviceTransferExport => 'Full transfer';

  @override
  String get deviceTransferExportHelp => 'Save the entire device in one file';

  @override
  String get deviceTransferRestore => 'Full restore';

  @override
  String get deviceTransferRestoreHelp =>
      'Drop the archive here or click to select a file';

  @override
  String get deviceTransferOneFile => 'Drop one full device transfer file.';

  @override
  String get deviceTransferPasswordHelp =>
      'The archive password can be anything, including empty. After verification, full transfer stops all spaces and the home server on the source device. Keep the archive and password outside the OS disk. Restore into a fresh installation and restart the app. Do not restore one archive onto several devices. After resuming messages, create a fresh archive for the next move.';

  @override
  String get deviceTransferFinished =>
      'Keep the archive and password. Close the app; open it again after restoring. Do not resume messaging on the source device.';

  @override
  String get deviceTransferClose => 'Close application';

  @override
  String get failureConflict =>
      'The message has changed. Close the editor and open the latest version; you can copy your text before closing.';

  @override
  String get messageDeleted => 'Message deleted';

  @override
  String get messageEdited => 'edited';

  @override
  String get messageActions => 'Message actions';

  @override
  String get editMessage => 'Edit';

  @override
  String get deleteMessage => 'Delete';

  @override
  String get deleteMessageConfirm =>
      'Delete this message for everyone? This cannot be undone.';

  @override
  String get saveMessage => 'Save';

  @override
  String get cancelMessageChange => 'Cancel';

  @override
  String get messageText => 'Message text';

  @override
  String get messageTextInvalid => 'Enter text up to 4096 bytes.';

  @override
  String get interfaceScale => 'Interface scale';

  @override
  String get overview => 'Overview';

  @override
  String get chat => 'General chat';

  @override
  String get forum => 'Discussions';

  @override
  String get feed => 'Feed';

  @override
  String get rooms => 'Rooms';

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
  String get channels => 'Chats';

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
  String get independentServer => 'This server controls chats and access.';

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
  String get closeNavigation => 'Close navigation';

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
  String get welcomeDescription => 'Server chats and resources.';

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
      'You can enable notifications in app settings. The camera and microphone are activated only by your action.';

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
  String get feedTitle => 'Space feed';

  @override
  String get feedDescription => 'News and posts from this space.';

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
  String get channel => 'Chat';

  @override
  String get noReading => 'No read access';

  @override
  String get refreshChat => 'Refresh chats and chat';

  @override
  String get noMessageAccess => 'No access to messages';

  @override
  String get startConversation => 'Start a conversation';

  @override
  String get conversationStarts => 'The conversation starts here';

  @override
  String get contactOwner => 'Choose another chat or contact the space owner.';

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
  String get cannotSend => 'You cannot send messages in this chat';

  @override
  String get messageHint => '';

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
  String get homeTitle => 'On air';

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
  String get rotationDevicesReview =>
      'Review the devices that will keep access. If a device is unfamiliar, cancel and revoke its permission first.';

  @override
  String get rotationConfirm =>
      'Change the root key? Your ID, permissions, history and verified active devices will remain, without extending their access. Old sessions and recovery cards will be revoked. The new secret is saved in a protected journal first. Save a new recovery card after the change.';

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
      'Root key changed. Your ID and verified devices are preserved. Save a new recovery card; old cards no longer work.';

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
  String get dashboardDescription => 'Servers, chats and unread messages.';

  @override
  String get dashboardServers => 'Servers';

  @override
  String get dashboardOnline => 'Online';

  @override
  String get dashboardChannels => 'Accessible chats';

  @override
  String get dashboardUnread => 'Unread messages';

  @override
  String get dashboardRefresh => 'Refresh overview';

  @override
  String get dashboardEmpty => 'Add your first space';

  @override
  String get dashboardEmptyHelp => 'Add a server or create your own.';

  @override
  String get dashboardCatalogUnknown => 'Connect to load chats.';

  @override
  String get dashboardAvailable => 'Available';

  @override
  String get dashboardUnavailable => 'Unavailable';

  @override
  String get dashboardOpen => 'Open space';

  @override
  String get dashboardResourcesHelp =>
      'The overview includes accessible chats and unread messages. Data from unavailable servers appears after reconnection.';

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
  String get failureHomeJournalInvalid =>
      'The update journal is corrupt or inaccessible. Automatic continuation is blocked; manual inspection is required.';

  @override
  String get failureHomeBackupMissing =>
      'The backup is missing. Automatic recovery is blocked.';

  @override
  String get failureHomeBackupInvalid =>
      'The backup is corrupt, incomplete or inaccessible. Current data was not replaced.';

  @override
  String get failureHomeRecoveryInvalid =>
      'The baseline or recovery directories do not match the original database. Switching is blocked.';

  @override
  String get homeRecoveryHelp =>
      'Preserve the entire home-server directory, including the journal, backups, recoveries and failed-data. Do not delete the journal or replace the database manually. Open the recovery guide.';

  @override
  String get homeRecoveryGuide => 'Recovery guide';

  @override
  String get homeRecoveryGuideFailed => 'Could not open the recovery guide.';

  @override
  String get homeRecoveryCopy => 'Copy diagnostics';

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
      'Chat permissions changed. Refresh the chat before retrying.';

  @override
  String get failureChannelUnavailable =>
      'Access to this chat changed. Select an accessible chat.';

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
      'No server confirmation. The request is saved in the queue.';

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
  String get hotkeysTitle => 'Keyboard shortcuts';

  @override
  String get resetShortcut => 'Restore default Enter';

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
  String get myDevice => 'Device';

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
  String get serverNoChannels => 'No available chats';

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

  @override
  String get updatesInstall => 'Install and restart';

  @override
  String get updatesPreparing =>
      'Finishing operations and stopping the home server…';

  @override
  String get updatesInstallFailed =>
      'Installation could not start. Check message delivery and the home server, then retry.';

  @override
  String get updatesHomeTitle => 'On air';

  @override
  String get updatesHomeResume =>
      'The home server was running before the update. Start it again?';

  @override
  String get updatesLater => 'Later';

  @override
  String get updatesHomeStart => 'Start';

  @override
  String get addFavorite => 'Add to favorites';

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String get favoriteMessages => 'Favorite messages';

  @override
  String get failureConnectRequired =>
      'This server must support ConnectRPC. Update the home runtime or contact the space owner.';

  @override
  String get spaceQrCamera => 'Scan QR';

  @override
  String get spaceQrImage => 'Choose QR image';

  @override
  String get spaceQrInvalid =>
      'Could not read a QR code containing a space link.';

  @override
  String get homeExport => 'Export space';

  @override
  String get homeImport => 'Import space';

  @override
  String get homeTransferHelp =>
      'The archive contains messages, settings and server keys. Keep it private and import only your own archive. The server stops during export; import never replaces an existing space. Changing IP keeps the space identity and TLS fingerprint. On a new computer, restore your owner recovery card separately.';

  @override
  String get homeImportIP => 'New public IPv4 (empty keeps the old address)';

  @override
  String get homeExported => 'Space exported';

  @override
  String get homeImported => 'Space imported. You can now start the server.';

  @override
  String get homeTransferring => 'Transferring space';

  @override
  String get homeTransferFailed =>
      'Could not open the archive or complete the transfer.';

  @override
  String get glassEffects => 'Glass effects';

  @override
  String get glassEffectsHelp => 'Blur floating panels and the header.';

  @override
  String get attachFiles => 'Attach files';

  @override
  String get myFiles => 'My files';

  @override
  String get removeFile => 'Remove file';

  @override
  String get cancelUpload => 'Cancel';

  @override
  String get downloadFile => 'Download file';

  @override
  String get downloadFailed => 'Could not download the file';

  @override
  String get noFilesInChannel => 'You have no files in this chat yet';

  @override
  String get loadMoreFiles => 'Load more';

  @override
  String get closeFiles => 'Close';

  @override
  String get dropFilesHere => 'Drop files to attach';

  @override
  String get optionalNickname => 'Name (optional)';

  @override
  String get channelFiles => 'Chat attachments';

  @override
  String get allFileAuthors => 'All participants';

  @override
  String get refreshFiles => 'Refresh attachments';

  @override
  String get filesLoadFailed =>
      'Could not load attachments. Try refreshing the list.';

  @override
  String get filesServerUpdateRequired =>
      'Update the server to use the attachment list.';

  @override
  String get serverNickname => 'Your name in this space';

  @override
  String get nicknameUniqueHelp =>
      'Your name must be unique on this server. Case is ignored. Leave blank to remove it.';

  @override
  String get saveNickname => 'Save name';

  @override
  String get nicknameSaved => 'Name saved';

  @override
  String get nicknameTaken => 'This name is taken. Choose another.';

  @override
  String get nicknameInvalid => 'Use up to 40 characters without line breaks.';

  @override
  String get nicknameFailed =>
      'Could not update your profile. Check your connection.';

  @override
  String get retryProfile => 'Retry';

  @override
  String get messageUnavailable => 'Message unavailable';

  @override
  String get mlsTitle => 'Private chat · MLS';

  @override
  String get mlsExperimental => 'Experimental E2EE';

  @override
  String get mlsCreate => 'Create private chat';

  @override
  String get mlsChannelId => 'Chat ID';

  @override
  String get mlsChannelTitle => 'Chat title';

  @override
  String get mlsDeviceCode => 'This device’s code';

  @override
  String get mlsDevices => 'Chat devices';

  @override
  String get mlsVerify => 'Verify device';

  @override
  String get mlsTrust => 'Codes match';

  @override
  String get mlsVerifyHint =>
      'Compare this code on the other device through an independent channel. The server does not establish trust in this key.';

  @override
  String get mlsInvite => 'Invite';

  @override
  String get mlsRemove => 'Remove device';

  @override
  String get mlsRetry => 'Refresh and retry delivery';

  @override
  String get mlsWaiting =>
      'This device has not been invited or access was revoked. Share its code with the chat owner.';

  @override
  String get mlsInput => '';

  @override
  String get mlsSend => 'Send';

  @override
  String get mlsAttach => 'Attach file';

  @override
  String get mlsFiles => 'Chat files';

  @override
  String get mlsUnavailable => 'Message unavailable';

  @override
  String get mlsCancel => 'Cancel';

  @override
  String get mlsTransfer => 'Transfer management';

  @override
  String get mlsTransferTitle => 'Transfer chat management?';

  @override
  String mlsTransferHint(String device) {
    return 'Device $device will be able to invite and remove members. You will keep access to messages and files.';
  }

  @override
  String get homeExternalHost => 'External address (IPv4, IPv6 or domain)';

  @override
  String get homeExternalPort => 'External port';

  @override
  String get homeAddAddress => 'Add address';

  @override
  String get homeRemoveAddress => 'Remove address';

  @override
  String get homeListenPort => 'Local port';

  @override
  String get homeListenInterfaces => 'Network';

  @override
  String get homeNetworkHelp =>
      'External and local ports may differ. Changes apply the next time the server starts.';

  @override
  String get homeSaveAddresses => 'Save settings';

  @override
  String get homeNetworkInvalid =>
      'Check addresses and ports (1–65535). Addresses must be unique.';

  @override
  String get homeAddressLabel => 'Address';

  @override
  String get homePrimaryAddress => 'Primary address';

  @override
  String get homeBackupAddress => 'Backup address';

  @override
  String get homeConnectionAddresses => 'Participant connections';

  @override
  String get homeAddressHelp =>
      'Domain, IPv4 or IPv6, without https:// or brackets. A backup address helps when the primary is unavailable.';

  @override
  String get homeLocalSettings => 'On this computer';

  @override
  String get homeDiagTitle => 'Connection diagnostics';

  @override
  String get homeDiagRun => 'Check';

  @override
  String get homeDiagRunning => 'Checking addresses…';

  @override
  String get homeDiagWANLabel => 'Router WAN IP (optional)';

  @override
  String get homeDiagWANHelp =>
      'Copy it from the router status page. This field is not saved.';

  @override
  String get homeDiagCopyCommand => 'Copy command for another network';

  @override
  String get homeDiagExternalHelp =>
      'Space on another network automatically checks saved spaces. For a separate check, run this command on an external computer. Proxies or VPNs may leave the result unconfirmed.';

  @override
  String get homeDiagUnsupported =>
      'The installed runtime does not support diagnostics. Update the server.';

  @override
  String get homeDiagFailed =>
      'Diagnostics could not run. Check the installed runtime and try again.';

  @override
  String get homeDiagLocalPrefix => 'Local check';

  @override
  String get homeDiagLocalOk =>
      'The server responds locally; TLS and signature are valid.';

  @override
  String get homeDiagRouteOk =>
      'The address is reachable from this computer; TLS and signature are valid.';

  @override
  String get homeDiagUnreachable =>
      'Cannot connect. Check server startup, port and firewall. This does not prove CGNAT.';

  @override
  String get homeDiagDNS =>
      'The domain cannot be resolved. Check the name and DNS record.';

  @override
  String get homeDiagCertificateOk => 'The space certificate is valid.';

  @override
  String get homeDiagCertificateMissing =>
      'No certificate found. Start the server and check again.';

  @override
  String get homeDiagCertificateExpired =>
      'Certificate validity check failed. Check the clock and certificate.';

  @override
  String get homeDiagCertificateMismatch =>
      'The address presents a different certificate. Check routing; do not replace the trusted fingerprint.';

  @override
  String get homeDiagDiscovery =>
      'The address responds, but the identity or signature is invalid. Check the address and tunnel.';

  @override
  String get homeDiagWANUnknown =>
      'WAN IP is unknown; CGNAT cannot be determined. You can enter the router WAN IP above.';

  @override
  String get homeDiagWANInvalid =>
      'Invalid WAN IP. Use the address from the router status page.';

  @override
  String get homeDiagWANShared =>
      'WAN IP is in 100.64.0.0/10, a sign of CGNAT. Ask your ISP about a public IP or use a TCP tunnel.';

  @override
  String get homeDiagWANPrivate =>
      'WAN IP is private: double NAT or CGNAT is possible. Check the upstream router and ISP service.';

  @override
  String get homeDiagWANPublic =>
      'WAN IP is outside private and CGNAT ranges. This does not confirm that the port is reachable externally.';

  @override
  String get homeDiagExternal =>
      'Not checked externally: no recent external connection. Open this space on a device on another network and check again. This does not mean the server is unreachable.';

  @override
  String get homeDiagBudget =>
      'Diagnostics timed out; remaining addresses were not checked.';

  @override
  String get homeDiagUnknown => 'Unknown result; update the app and runtime.';

  @override
  String get homeDiagInterface =>
      'The listen address does not belong to this computer. Select a local interface or all interfaces.';

  @override
  String get homeDiagIPv6Private =>
      'WAN IPv6 is local and cannot provide direct internet access. This does not prove CGNAT.';

  @override
  String get homeDiagNotReady =>
      'TLS responds, but the server is not ready (HTTP 503). Complete initial setup or wait for startup.';

  @override
  String get homeDiagObserved =>
      'The HTTPS listener received a request from another public network. This observation applies to the stated time and this address.';

  @override
  String homeDiagObservedAt(String time) {
    return 'Last external connection: $time';
  }

  @override
  String get initialServerSetupTitle => 'First sign-in to your space';

  @override
  String get initialServerSetupHelp =>
      'You will become the owner of this space and can appoint other members as administrators. This setup link can only be used once.';

  @override
  String get homeAutoPortMapping => 'Automatic port forwarding';

  @override
  String get homeAutoPortMappingHelp =>
      'Temporary TCP mapping using PCP, NAT-PMP or UPnP. Removed on shutdown; does not bypass CGNAT.';

  @override
  String get homeAutoPublicIP => 'Update public IP';

  @override
  String get homeAutoPublicIPHelp =>
      'For the first IPv4 address. Checked through the router or ipify; domains and other addresses are preserved.';

  @override
  String get homeDiagMappingOk =>
      'The router confirmed a temporary TCP mapping. External reachability remains unverified.';

  @override
  String get homeDiagMappingFailed =>
      'Could not create or renew the mapping. Check router settings; CGNAT requires a public address or tunnel.';

  @override
  String get homeDiagAutomaticIPFailed =>
      'Could not update the public IPv4 address. Check the internet connection.';

  @override
  String get emojiPicker => 'Emoji';

  @override
  String get emojiSearch => 'Search emoji';

  @override
  String get emojiRecent => 'Recent';

  @override
  String get emojiAll => 'All';

  @override
  String get addReaction => 'Add reaction';

  @override
  String get reactionParticipants => 'Reactions';

  @override
  String get copyMessage => 'Copy';

  @override
  String get messageCopied => 'Copied';

  @override
  String get emojiFaces => 'Faces and emotions';

  @override
  String get emojiPeople => 'People and gestures';

  @override
  String get emojiNature => 'Animals and nature';

  @override
  String get emojiFood => 'Food and drink';

  @override
  String get emojiTravel => 'Travel and places';

  @override
  String get emojiActivities => 'Activities';

  @override
  String get emojiObjects => 'Objects';

  @override
  String get emojiSymbols => 'Symbols';

  @override
  String get emojiFlags => 'Flags';

  @override
  String get messageQueued => 'Message saved in the queue on this device';

  @override
  String get outboxTitle => 'Send queue';

  @override
  String get outboxWaiting => 'Waiting to send';

  @override
  String get outboxBlocked => 'Sending stopped';

  @override
  String get outboxUnavailable =>
      'Could not read or save the queue. Your text remains in the input field.';

  @override
  String get outboxRetry => 'Retry sending';

  @override
  String get outboxDiscard => 'Remove from queue';

  @override
  String get outboxDiscardDescription =>
      'The message may already be on the server. Removing it from the queue stops retries but does not delete it for participants.';

  @override
  String get outboxFileMessage => 'Message with attachments';

  @override
  String get outboxIdentityChanged =>
      'The device grant has changed. The previous queue is retained; automatic sending from the new device is blocked.';

  @override
  String get outboxFull =>
      'The queue is full: up to 100 messages and 1 MiB. Wait for delivery or remove unwanted messages.';

  @override
  String get outboxFileLimit =>
      'Pending attachments can use up to 200 MiB per space and device. Wait for delivery or remove unneeded messages.';

  @override
  String get outboxRecover => 'Recover previous queue';

  @override
  String get outboxRecoverDescription =>
      'These messages remain on this computer under a previous device grant. Review them before recovery. Request keys are preserved, so accepted messages are not duplicated.';

  @override
  String get outboxRecoverTrust =>
      'I trust the current device and allow it to send these messages on my behalf.';

  @override
  String get outboxRecoverSend => 'Recover and send';

  @override
  String get outboxRecoverFailed =>
      'Recovery could not be completed. The queue is preserved; check your connection and retry.';

  @override
  String get outboxEdit => 'Edit message';

  @override
  String get outboxDelete => 'Delete message';

  @override
  String get outboxReactionAdd => 'Add reaction';

  @override
  String get outboxReactionRemove => 'Remove reaction';

  @override
  String get outboxMutationBlocked =>
      'Change stopped. Check your permissions, runtime version, and the latest message. For a conflict, discard this queued action and perform it again.';

  @override
  String get outboxDiscardMutationDescription =>
      'The action may already have been applied on the server. Discarding stops local retries but does not undo the action. Dependent actions will stop.';

  @override
  String get replyMessage => 'Reply';

  @override
  String get cancelReply => 'Cancel reply';

  @override
  String get replyUnavailable => 'Original message is unavailable';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsOff => 'Off';

  @override
  String get notificationsPrivate => 'Hide content';

  @override
  String get notificationsPreview => 'Show message text';

  @override
  String get notificationsDescription =>
      'On desktop: Ordinary and joined encrypted chats in connected spaces while the app is running. Previews share text with the operating system. Delivery after quitting is not supported yet.';

  @override
  String get notificationPermissionError =>
      'Could not enable notifications. Check system settings.';

  @override
  String get newMessageNotification => 'New message';

  @override
  String get messageSearchServer => 'Search the selected chat history';

  @override
  String get messageSearchLocal => 'Search on this device only · MLS';

  @override
  String get messageSearchFailed => 'Search failed. Retry';

  @override
  String get messageSearchMore => 'More messages';

  @override
  String get messageSearchLimit =>
      'Showing the first 200 matches. Refine your query.';

  @override
  String get loadOlderMessages => 'Load older messages';

  @override
  String get historyPageFailed => 'Could not load history. Please retry.';

  @override
  String get messageSearchAllChannels => 'All available chats';

  @override
  String get messageSearchMixed =>
      'Private chats are searched only on this device';

  @override
  String get savedMlsSearchChannels => 'Saved private chats';

  @override
  String get savedMlsMessagePreview => 'Saved message · offline';

  @override
  String get homeArchiveVerified => 'Archive verified';

  @override
  String homeArchiveSummary(
    String serverId,
    int schema,
    int files,
    String size,
  ) {
    return 'Space: $serverId\nData version: $schema\nFiles in archive: $files\nUnpacked size: $size MiB';
  }

  @override
  String get homeArchiveReviewHelp =>
      'Contents and checksums were verified. This does not authenticate the source: restore only your own backup. Restoration has not started. Restore the owner key and device MLS history separately.';

  @override
  String get homeArchiveRestore => 'Start restoration';

  @override
  String get homeArchiveUnsupported =>
      'This runtime cannot verify archives yet. A compatible app and runtime release with archive verification is required; restoration has not started.';

  @override
  String get homeArchiveCheckFailed =>
      'The archive could not be verified. It may be damaged or incompatible with the runtime. Restoration has not started.';

  @override
  String get homeDiskTitle => 'Disk and backups';

  @override
  String get homeDiskPolicy =>
      'Manual cleanup of runtimes and update backups keeps the current and previous runtime, the three newest verified backups and the current recovery backup. Other backups are offered only after 30 days. Files outside the home server are never removed.';

  @override
  String get homeDiskScan => 'Show sizes / refresh';

  @override
  String get homeDiskClean => 'Delete selected';

  @override
  String get homeDiskConfirm =>
      'Selected folders will be permanently removed. Space data, protected backups and external ZIP archives will remain. Continue?';

  @override
  String get homeDiskFailed =>
      'Inspection or cleanup could not finish. State may have changed; refresh the list. Links and pending recovery block cleanup.';

  @override
  String get homeDiskData => 'Space data';

  @override
  String get homeDiskRuntimes => 'Server versions';

  @override
  String get homeDiskBackups => 'Backups';

  @override
  String get homeDiskRecoveries => 'Recovery data';

  @override
  String get homeDiskFree => 'Free on server disk';

  @override
  String get homeDiskEstimate =>
      'Sizes are estimates and may change while the server runs. Cleanup checks selected files again.';

  @override
  String get homeDiskNothing => 'No old folders can be safely removed.';

  @override
  String get homeDiskStop => 'Stop the server before cleanup.';

  @override
  String get homeBackupTitle => 'Scheduled backups';

  @override
  String get homeBackupHelp =>
      'The running runtime creates backups without disconnecting chats. One fresh backup follows downtime. Changes apply within a minute; a running job may finish with its previous settings.';

  @override
  String get homeBackupUnsupported =>
      'Install or update the runtime for scheduled backups.';

  @override
  String get homeBackupEnabled => 'Enable schedule';

  @override
  String get homeBackupInterval => 'Interval, hours';

  @override
  String get homeBackupPrune => 'Automatically remove old backups';

  @override
  String get homeBackupCount => 'Backup count (3–100)';

  @override
  String get homeBackupDays => 'Retention, days (1–3650)';

  @override
  String get homeBackupQuota => 'Limit, MiB (0 = unlimited)';

  @override
  String get homeBackupRetention =>
      'When automatic cleanup is enabled, any exceeded limit applies. The three newest verified backups remain even above the size limit. Unknown, corrupt and incompatible files are kept.';

  @override
  String get homeBackupSave => 'Save settings';

  @override
  String get homeBackupConfigure => 'Configure backups';

  @override
  String get homeBackupRefresh => 'Refresh status';

  @override
  String get homeBackupFailed =>
      'Backup or cleanup did not finish. Check settings, disk space and access. Retry is no earlier than five minutes later.';

  @override
  String get homeBackupLast => 'Last successful backup';

  @override
  String get homeBackupNext => 'Next check';

  @override
  String get homeBackupProtected =>
      'Some files are protected or the size limit cannot hold three backups.';

  @override
  String get homeBackupOff => 'Schedule disabled';

  @override
  String get homeBackupRunning => 'Creating a backup…';

  @override
  String get homeBackupOK => 'Last operation finished';

  @override
  String get homeBackupSpace =>
      'Could not confirm enough free space for a new backup.';

  @override
  String get homeBackupWaiting =>
      'Waiting for a running runtime and the scheduled time';

  @override
  String get voiceTitle => 'Voice rooms';

  @override
  String get voiceDescription =>
      'Audio conversations. Your microphone turns on only when you choose.';

  @override
  String get voiceCreate => 'Create room';

  @override
  String get voiceName => 'Room name';

  @override
  String get voiceJoin => 'Join';

  @override
  String get voiceLeave => 'Leave conversation';

  @override
  String get voiceMicrophoneOn => 'Turn microphone on';

  @override
  String get voiceMicrophoneOff => 'Turn microphone off';

  @override
  String get voiceSoundOn => 'Turn sound on';

  @override
  String get voiceSoundOff => 'Turn sound off';

  @override
  String get voiceJoining => 'Connecting…';

  @override
  String get voiceReconnecting => 'Reconnecting. Microphone is off.';

  @override
  String get voiceConnected => 'Connected';

  @override
  String get voiceParticipants => 'Participants';

  @override
  String get voiceMuted => 'Microphone off';

  @override
  String get voiceSpeaking => 'Speaking';

  @override
  String get voiceDeafened => 'Sound off';

  @override
  String get voiceEmpty =>
      'No voice rooms yet. An owner or administrator can create one.';

  @override
  String get voiceConnectFirst => 'Connect to a space to open voice rooms.';

  @override
  String get voiceLimit =>
      'Up to eight participants per room. For internet connections, the owner configures STUN/TURN; the app receives the settings automatically.';

  @override
  String get voiceDesktopOnly =>
      'Voice rooms are currently available on desktop.';

  @override
  String get voicePrivacy =>
      'No recording or camera. Audio passes through your space server; it is not participant-to-participant MLS encryption.';

  @override
  String get voiceFailure => 'Could not continue the conversation';

  @override
  String get voiceCancel => 'Cancel';

  @override
  String get voiceSave => 'Create';

  @override
  String get voiceUpdateRuntime =>
      'Voice rooms require a runtime with voice support. Update your server in Broadcast.';

  @override
  String get voiceDeviceUnavailable =>
      'A selected audio device is disconnected. Reconnect it or choose another device, then enable the microphone or sound manually.';

  @override
  String get voiceDeviceDisconnected => 'Device disconnected';

  @override
  String get voiceAudioDevices => 'Audio devices';

  @override
  String get voiceSettingsTitle => 'Voice';

  @override
  String get voiceInputVolume => 'Microphone volume';

  @override
  String get voiceOutputVolume => 'Output volume';

  @override
  String get voiceProcessingTitle => 'Audio processing';

  @override
  String get voiceInputProfile => 'Microphone profile';

  @override
  String get voiceProfileSpeech => 'Conversation';

  @override
  String get voiceProfileStudio => 'Studio — no processing';

  @override
  String get voiceProfileCustom => 'Custom';

  @override
  String get voiceNoiseSuppression => 'Noise suppression';

  @override
  String get voiceEchoCancellation => 'Echo cancellation';

  @override
  String get voiceAutoGain => 'Automatic gain control';

  @override
  String get voiceProcessingHint =>
      'Changing processing turns off your microphone. Turn it on again to apply the settings. Use headphones with the Studio profile.';

  @override
  String get voiceTestMicrophone => 'Test microphone';

  @override
  String get voiceStopMicrophoneTest => 'Stop test';

  @override
  String get voiceMicrophoneLevel => 'Microphone level';

  @override
  String get voiceMicrophoneTestHint =>
      'You will hear yourself. The test runs locally for up to 60 seconds and does not send audio to the room. Room audio will be turned off. Closing settings stops the test.';

  @override
  String get voiceDevicesDescription =>
      'Choose your microphone and sound output. You can change devices before joining a room or during a conversation.';

  @override
  String get voiceDevicesRemembered =>
      'Your choices are saved on this computer. Joining a room and restoring settings do not turn on your microphone.';

  @override
  String get voiceInputDevice => 'Microphone';

  @override
  String get voiceOutputDevice => 'Sound output';

  @override
  String get voiceCurrentDevice => 'Current system device';

  @override
  String get voiceRefreshDevices => 'Refresh devices';

  @override
  String get voiceCloseDevices => 'Close';

  @override
  String get voicePushToTalk => 'Push to talk';

  @override
  String get voicePushToTalkHint =>
      'Enable the microphone in the room, then hold your chosen shortcut to speak. Works while this window has focus. The microphone test plays continuously.';

  @override
  String get voiceAutomaticSensitivity => 'Automatic input sensitivity';

  @override
  String get voiceSensitivity => 'Input threshold';

  @override
  String get recoveryIncludeSpaces => 'Include spaces';

  @override
  String get recoveryIncludeSpacesHint =>
      'Create a second QR with saved spaces and their recovery keys. MLS keys and history are not included.';

  @override
  String get recoveryAccessQr => 'Selected access recovery';

  @override
  String get recoverySpacesQr => 'Spaces and access';

  @override
  String get recoverySpacesUseFile =>
      'This set is too large for one QR. Save the encrypted file.';

  @override
  String get recoverySaveSpacesQr => 'Save spaces QR';

  @override
  String get recoverySaveSpacesFile => 'Save spaces to file';

  @override
  String recoverySpacesResult(int restored, int total) {
    return 'Spaces added: $restored. Total in collection: $total. Existing keys were kept unchanged. Retry import for failures.';
  }

  @override
  String get migrationTitle => 'Full space migration';

  @override
  String get migrationExportHelp =>
      'The archive contains the server, device keys, working MLS state and local encrypted-chat history. After saving, this client will stop using this space. Keep the archive on another drive and remember the password. If interrupted, check the .pending file: it may contain the completed migration. After verification, the previous device working keys in system storage will be replaced with a migration marker.';

  @override
  String get migrationImportHelp =>
      'Restoring continues the previous device. Use the archive on only one new device. The old server must be stopped. Existing keys are never replaced.';

  @override
  String get migrationPassword => 'Archive password';

  @override
  String get migrationPasswordRepeat => 'Repeat password';

  @override
  String get migrationExported =>
      'Migration saved. The previous device is stopped. Preserve the archive and password before reinstalling the OS.';

  @override
  String get voiceRefreshRooms => 'Refresh rooms';

  @override
  String get voiceRouteDirect => 'Direct connection';

  @override
  String get voiceRouteRelay => 'Via TURN';

  @override
  String get voiceRouteUnknown => 'Route not yet known';

  @override
  String voiceRoundTrip(int milliseconds) {
    return 'RTT: $milliseconds ms';
  }

  @override
  String get voiceProfileSpeechHelp =>
      'Noise suppression, echo cancellation, automatic gain control and a high-pass filter.';

  @override
  String get voiceProfileStudioHelp =>
      'Unprocessed microphone audio. For music and prepared input; use headphones.';

  @override
  String get voiceProfileCustomHelp =>
      'Adjust each processing option separately.';

  @override
  String get voiceActivity => 'Voice activity';

  @override
  String get voiceActivityHelp =>
      'After manually enabling the microphone, transmission opens above the threshold. Noise can also trigger it; adjust sensitivity.';

  @override
  String get voiceNoiseSuppressionHelp =>
      'DeepFilterNet3 uses neural noise suppression. WebRTC is a lighter option. Audio is processed on your device.';

  @override
  String get voiceNoiseWebRtc => 'WebRTC';

  @override
  String get voiceNoiseOff => 'Off';

  @override
  String get voiceAdvancedSettings => 'Advanced voice settings';

  @override
  String get voiceHighPass => 'Low-frequency noise filter';

  @override
  String get voiceAdvancedActivation => 'Stable voice activation';

  @override
  String get voiceAdvancedActivationHelp =>
      'Keeps transmission open near the threshold to preserve quiet word endings. Uses sound level, not speech recognition.';

  @override
  String voiceReleaseDelay(int milliseconds) {
    return 'Transmission release delay: $milliseconds ms';
  }

  @override
  String get voiceRoomEmpty => 'No one is in this room yet';

  @override
  String get voiceMicrophoneEnabled => 'Microphone enabled';

  @override
  String get voiceActivityUpdateRuntime =>
      'Update this space’s runtime to highlight speaking participants.';

  @override
  String get voiceHoldToTalk => 'Hold to talk';

  @override
  String get voiceTouchToTalkHint =>
      'Enable the microphone in the room and hold the talk button. The button is released when the app goes into the background.';

  @override
  String get voiceAndroidNoiseHelp =>
      'DeepFilterNet3 is enabled by default. WebRTC is a lighter option; processing can also be disabled. Audio is processed on your phone.';

  @override
  String get forumConnectFirst => 'Connect to a space to open the forum.';

  @override
  String get forumUpdateRuntime =>
      'The forum requires a runtime supporting core.forum.v1. Update the server in Broadcast.';

  @override
  String get forumPrivacy =>
      'Forum messages are stored on the server without end-to-end encryption. Section permissions control access.';

  @override
  String get forumSections => 'Forum section';

  @override
  String get forumManage => 'Sections and permissions';

  @override
  String get forumEmptySections =>
      'No forum sections are available. An administrator can create a section and assign permissions.';

  @override
  String get forumRefresh => 'Refresh';

  @override
  String get forumNewTopic => 'Create topic';

  @override
  String get forumTopicTitle => 'Topic title';

  @override
  String get forumText => 'Message';

  @override
  String get forumSend => 'Send';

  @override
  String get forumReply => 'Reply';

  @override
  String get forumClosed => 'This topic is closed. New replies are disabled.';

  @override
  String get forumClose => 'Close topic';

  @override
  String get forumCloseConfirm =>
      'Close this topic? New replies will be disabled for everyone.';

  @override
  String get forumCancel => 'Cancel';

  @override
  String get forumBack => 'Back to topics';

  @override
  String get forumMore => 'Load more';

  @override
  String get forumEmptyTopics => 'There are no topics in this section yet.';

  @override
  String get forumReadOnly =>
      'You can read this section. Writing permission is required to post.';

  @override
  String get forumInvalidText =>
      'Enter text or attach a file. Title: up to 320 UTF-8 bytes.';

  @override
  String get forumConflict => 'The topic changed. Refresh it and try again.';

  @override
  String get forumDenied =>
      'Access was revoked or the section is unavailable. Refresh the forum.';

  @override
  String get forumFailure =>
      'The action failed. Check your connection and try again.';

  @override
  String get forumWriteUnavailable =>
      'Reply was not sent: the topic is closed or the section is archived. Refresh the forum.';

  @override
  String get forumListTitle => 'Discussions';

  @override
  String get forumListDescription => 'Conversations in our community';

  @override
  String get forumReplies => 'Replies';

  @override
  String get forumAboutSection => 'About this section';

  @override
  String get forumAboutTopic => 'About this topic';

  @override
  String get forumState => 'Status';

  @override
  String get forumOpen => 'Open';

  @override
  String get forumClosedLabel => 'Closed';

  @override
  String get forumAuthor => 'Author';

  @override
  String get forumCreated => 'Created';

  @override
  String get forumTopicAuthor => 'Topic author';

  @override
  String get forumAllTopics => 'All topics in this section';

  @override
  String get forumActions => 'Topic actions';

  @override
  String get forumClosedHeading => 'Topic closed';

  @override
  String get forumClosedDescription =>
      'New replies are disabled. You can still read the discussion.';

  @override
  String get forumPrivacyShort =>
      'Section permissions control access. End-to-end encryption is unavailable.';

  @override
  String get forumOrder => 'In order';

  @override
  String get forumPin => 'Pin topic';

  @override
  String get forumUnpin => 'Unpin topic';

  @override
  String get forumPinned => 'Pinned';

  @override
  String get forumUnread => 'Unread';

  @override
  String get forumReadShown => 'Mark displayed messages as read';

  @override
  String get forumAuthorizeDevice => 'Authorize moderation on this device';

  @override
  String get forumDevicePermissionInfo =>
      'Your root identity signs a space.manage grant for this device. It enables existing moderation permissions; it does not grant a role or access to other sections. If the key is not on this device, choose your root card.';

  @override
  String get forumRootPassword => 'Root card password';

  @override
  String get forumFirstUnread => 'First unread reply';

  @override
  String get forumRepliesFromStart => 'Show replies from the beginning';

  @override
  String get forumReopen => 'Reopen topic';

  @override
  String get forumHideTopic => 'Hide topic';

  @override
  String get forumRestoreTopic => 'Restore topic';

  @override
  String get forumHideReply => 'Hide reply';

  @override
  String get forumRestoreReply => 'Restore reply';

  @override
  String get forumHiddenTopic => 'Topic hidden by a moderator';

  @override
  String get forumHiddenReply => 'Reply hidden by a moderator';

  @override
  String get forumReason => 'Reason for this action';

  @override
  String get forumReasonRequired => 'Enter a reason, up to 1024 bytes';

  @override
  String get forumModerationNotice =>
      'Hidden content and its files remain unavailable until restored. The reason is saved in the moderation log.';

  @override
  String get forumModerationLog => 'Moderation log';

  @override
  String get forumModerationEmpty => 'No moderation actions yet';

  @override
  String get forumApply => 'Confirm';

  @override
  String get forumReport => 'Report';

  @override
  String get forumReportNotice =>
      'Describe the violation. Moderators can review the report; the reporter is not identified. Duplicate reports are not created.';

  @override
  String get forumReportsQueue => 'Report queue';

  @override
  String get forumReportsPending => 'Pending';

  @override
  String get forumReportsResolved => 'Decisions';

  @override
  String get forumReportsEmpty => 'No reports';

  @override
  String get forumReportDismiss => 'Dismiss report';

  @override
  String get forumReportHide => 'Hide content';

  @override
  String get forumReportDecisionNotice =>
      'Provide a reason. The decision and reason will be recorded in the moderation log.';

  @override
  String get forumReportOpen => 'Open discussion';

  @override
  String get forumReportTopic => 'Topic report';

  @override
  String get forumReportReply => 'Reply report';

  @override
  String get feedPrivacy =>
      'Posts are visible to the server. End-to-end encryption is not used.';

  @override
  String get feedSections => 'Feed sections';

  @override
  String get feedPolicy => 'Publishing and commenting permissions';

  @override
  String get feedEmptySections => 'No feed sections are available yet.';

  @override
  String get feedEmpty => 'No posts yet.';

  @override
  String get feedOpenUnread => 'Open unread comments';

  @override
  String get feedReadOnly => 'You cannot publish in this section.';

  @override
  String get feedBack => 'Back to posts';

  @override
  String get feedComments => 'Comments';

  @override
  String get feedHiddenPost => 'This post was hidden by a moderator.';

  @override
  String get feedHiddenComment => 'This comment was hidden by a moderator.';

  @override
  String get feedRestoreComment => 'Restore comment';

  @override
  String get feedRestorePost => 'Restore post';

  @override
  String get feedSendFailed =>
      'Could not send. Text and files have been kept. Check your permissions and connection, then try again.';

  @override
  String get feedPublishPermission => 'Publish posts';

  @override
  String get feedCommentPermission => 'Write comments';

  @override
  String get feedPolicyHelp =>
      'Publishing and commenting are granted separately. Both are denied without a rule. An individual rule replaces the role rule. Readers may comment when explicitly allowed, but cannot publish.';

  @override
  String get feedPrincipal => 'Member ID — optional; otherwise use the role';

  @override
  String get feedRole => 'Role';

  @override
  String get feedAddRule => 'Add rule';

  @override
  String get feedRemoveRule => 'Remove rule';

  @override
  String get feedPost => 'Post';

  @override
  String get feedComment => 'Comment';

  @override
  String get feedOpenPost => 'Open post';

  @override
  String get feedUpdateRuntime =>
      'This server does not support the feed yet. Update it in Home server.';

  @override
  String get feedConnectFirst => 'Connect to a space to open its feed.';

  @override
  String get feedConflict =>
      'The post or permissions changed. Refresh and try again.';

  @override
  String get feedDenied =>
      'Access was revoked or this section is unavailable. Refresh the feed.';

  @override
  String get feedWriteUnavailable =>
      'This action is unavailable: the post is hidden or the section is archived. Refresh the feed.';

  @override
  String get feedInvalidText =>
      'Enter text up to 8192 UTF-8 bytes or attach a file.';

  @override
  String get feedActions => 'Actions';

  @override
  String get feedMemberRole => 'Members';

  @override
  String get feedReaderRole => 'Readers';

  @override
  String get communitySearchHint => 'Search this section';

  @override
  String get communitySearchEmpty => 'No matches';

  @override
  String get communitySearchInvalid => 'Enter 1–256 UTF-8 bytes of text';

  @override
  String get communitySearchThread => 'Thread';

  @override
  String get communitySearchReply => 'Reply';

  @override
  String get communitySearchPost => 'Post';

  @override
  String get communitySearchComment => 'Comment';

  @override
  String get communitySearchRevoked =>
      'Access to this section is no longer available';

  @override
  String get dashboardAttention => 'Needs attention';

  @override
  String get dashboardAttentionEmpty =>
      'All caught up — nothing needs attention.';

  @override
  String get dashboardChecking => 'Checking for updates…';

  @override
  String get dashboardAttentionLimit =>
      'Showing the first tasks. Open your spaces for the rest.';

  @override
  String get dashboardConnectionIssue => 'Connection issue';

  @override
  String get dashboardPendingReports => 'Pending reports';

  @override
  String get dashboardRepliesToYou => 'Replies to your thread';

  @override
  String get dashboardCommunityNews => 'New in communities';

  @override
  String get dashboardCommunityDescription =>
      'Recent threads and posts from sections you can read. Badges show unread items where the server supports read tracking.';

  @override
  String get dashboardCommunityFailed =>
      'Some sections could not be refreshed. Try again.';

  @override
  String get dashboardCommunityUnsupported =>
      'Update the server to enable community summaries.';

  @override
  String get dashboardCommunityEmpty =>
      'No threads or posts are available yet.';

  @override
  String get dashboardAttentionUnknown =>
      'Some sections have not been checked yet.';

  @override
  String get dashboardAttachmentPost => 'Post with attachments';

  @override
  String get dashboardCommunityOffline =>
      'Updates from unavailable spaces will appear after connecting.';

  @override
  String get communityMention => 'Mention a member';

  @override
  String get communityMentionQuery => 'Member name or ID';

  @override
  String get communityMentionFailed =>
      'Could not load members. Check your access and try again.';

  @override
  String get communityMentionEmpty => 'No members found';

  @override
  String get dashboardMention => 'You were mentioned';

  @override
  String get dashboardFeedRepliesToYou => 'Replies to your post';

  @override
  String get appearanceTheme => 'Theme';

  @override
  String get appearanceThemeSystem => 'Automatic';

  @override
  String get appearanceThemeLight => 'Light';

  @override
  String get appearanceThemeDark => 'Dark';

  @override
  String get notificationSection => 'Section';

  @override
  String get notificationInboxEmpty => 'No unread notifications';

  @override
  String get notificationInboxFailed =>
      'Could not update notifications. Check your connection and access.';

  @override
  String get notificationMarkRead => 'Mark as seen';

  @override
  String get notificationRefresh => 'Refresh notifications';

  @override
  String get notificationPrevious => 'Previous page';

  @override
  String get notificationNext => 'Next page';

  @override
  String get notificationUnavailable => 'No accessible sections';

  @override
  String get notificationReply => 'Reply to you';

  @override
  String get notificationOpen => 'Open';

  @override
  String get mlsMentionsLegacy =>
      'Some devices have not confirmed mention support. Only the name will be sent, without a mention marker.';

  @override
  String get mlsCancelRetry =>
      'Cancel pending messages after membership changes';

  @override
  String get profileAvatar => 'Space avatar';

  @override
  String get chooseAvatar => 'Choose image';

  @override
  String get removeAvatar => 'Remove avatar';

  @override
  String get avatarInvalid =>
      'Choose a still PNG or JPEG up to 5 MiB and 4 million pixels.';

  @override
  String get profileConflict =>
      'The profile changed on another device. Reload it and save again; your draft is preserved.';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSpaceHelp =>
      'Your name is unique in this space. Your name and avatar apply to every section.';

  @override
  String get communityReactionsRetry => 'Retry request';

  @override
  String get communityReactionsFailure => 'Could not update reactions.';

  @override
  String get communityReactionsConflict =>
      'Reactions changed. Check your selection and try again.';

  @override
  String get communityReactionsDenied =>
      'Reactions are unavailable: access or the section state changed.';

  @override
  String get communityFavorites => 'Favorites';

  @override
  String get communityFavoriteAdd => 'Save to favorites';

  @override
  String get communityFavoriteRemove => 'Remove from favorites';

  @override
  String get communityFavoriteRetry => 'Could not update favorites. Retry';

  @override
  String get communityFavoritesEmpty => 'No favorites in this section yet.';

  @override
  String get spaceSearch => 'Search this space';

  @override
  String get spaceSearchHint => 'Search chats, forums and feeds';

  @override
  String get spaceSearchChat => 'Message';

  @override
  String get spaceSearchChatMode => 'Search the selected chat and local MLS';

  @override
  String get spaceSearchLimit =>
      'Showing the first 500 results. Refine your search.';

  @override
  String get feedCancelReference => 'Remove reference';

  @override
  String get feedOpenOriginal => 'Open original';

  @override
  String get feedOriginalUnavailable => 'Original post unavailable';

  @override
  String get feedReply => 'Reply';

  @override
  String feedReplyTo(String number) {
    return 'Reply to comment #$number';
  }

  @override
  String get feedRepost => 'Repost';

  @override
  String get feedRepostHint =>
      'Send without text to repost, or add your own comment to quote.';

  @override
  String get feedShare => 'Repost or quote';

  @override
  String get followAdd => 'Follow';

  @override
  String get followingEmpty => 'You are not following anyone yet.';

  @override
  String get followingTitle => 'Following';

  @override
  String get followRefresh => 'Refresh following';

  @override
  String get followRemove => 'Unfollow';

  @override
  String get followRevoked => 'Access or space changed. Open the feed again.';

  @override
  String get followUnavailable => 'Participant unavailable';

  @override
  String get personalFeed => 'My feed';

  @override
  String get personalFeedEmpty =>
      'Posts from authors you follow will appear here from sections you can read. Follow an author next to their post or comment.';

  @override
  String get personalFeedLimit =>
      'Showing the first 500 posts. Refresh to see newer posts.';

  @override
  String get personalFeedOpen => 'Open discussion';

  @override
  String get userExportTitle => 'Export my content';

  @override
  String get userExportHelp =>
      'Your ordinary messages, topics, posts and replies as JSON. Attachments include metadata only, without files. MLS, keys and tokens are excluded. Up to 5000 entries and 8 MiB per period.';

  @override
  String get userExportSection => 'Section';

  @override
  String get userExportAll => 'All accessible sections';

  @override
  String get userExportAfter => 'From date (UTC, optional)';

  @override
  String get userExportBefore => 'Through date (UTC, optional)';

  @override
  String get userExportPrepare => 'Prepare JSON';

  @override
  String get userExportSave => 'Save JSON';

  @override
  String get userExportReady => 'Entries prepared';

  @override
  String get userExportSaved => 'Export saved';

  @override
  String get userExportInvalidPeriod =>
      'Enter valid YYYY-MM-DD dates and a valid period.';

  @override
  String get pairingNetworkError =>
      'Cannot reach the server. Polling will retry until the code expires.';

  @override
  String get pairingVerificationError =>
      'Verification failed. Start pairing again.';

  @override
  String get pairingQrInvalid =>
      'The QR is invalid, expired, or belongs to another space. Scan a new QR on the device being connected.';

  @override
  String get directoryBackupTitle => 'Encrypted directory backup';

  @override
  String get directoryBackupHelp =>
      'Spaces, settings and follows without device keys or history. Use at least 12 password characters. Recover access with a recovery card or pairing.';

  @override
  String get directoryBackupCreate => 'Create backup';

  @override
  String get directoryBackupRead => 'Preview backup';

  @override
  String get directoryBackupApply => 'Restore directory';

  @override
  String get directoryBackupSettings =>
      'Replace interface settings with the backup settings';

  @override
  String get directoryBackupFollows => 'Add saved follows';

  @override
  String get directoryBackupResume => 'Finish interrupted restore';

  @override
  String get directoryBackupUnverified =>
      'This backup has no local version witness. Its freshness is unknown.';

  @override
  String get directoryBackupResults =>
      'Space results (incomplete follow snapshots are listed when saving):';

  @override
  String get directoryBackupSaved =>
      'Backup saved and verified. Store the password separately.';

  @override
  String get directoryBackupRestored =>
      'Local restore completed. Restore follows separately after signing in with the same identity.';

  @override
  String get directoryBackupError =>
      'Operation incomplete. Check the password, backup integrity and storage access. An interrupted restore can be resumed.';

  @override
  String get directoryBackupConfirm =>
      'Apply the verified directory? Access keys are preserved. Selected settings will be applied; interrupted restoration can be resumed.';

  @override
  String get directoryBackupFollowsHelp =>
      'Add missing follows for connected spaces with the same identity? Existing follows are kept. Servers check access; results may be partial.';

  @override
  String directoryBackupPreview(int count) {
    return 'Spaces in this backup: $count';
  }

  @override
  String directoryBackupSpaceComplete(String origin, int count) {
    return '$origin: $count follows; snapshot complete';
  }

  @override
  String directoryBackupSpaceIncomplete(String origin, int count) {
    return '$origin: $count saved follows; current list unavailable';
  }

  @override
  String get pairingModeFull => 'Full mode';

  @override
  String get pairingSelectionFailed =>
      'Cannot prepare this selection. Check addresses and server trust. Existing saved identities cannot be replaced.';

  @override
  String get pairingModeLimited => 'Limited mode';

  @override
  String get pairingSelectionPrepare => 'Prepare selected spaces';

  @override
  String get pairingSelectionHelp =>
      'On the new device, select up to 12 known spaces without a saved identity. Confirm a separate QR and verification code for each space on the source device. You can restore a directory backup first.';

  @override
  String get pairingSelectionTitle => 'Pair selected spaces';

  @override
  String get pairingModeFullHelp =>
      'Working access, permitted administrative actions and device management in selected spaces. A root card must authorize this mode; the root secret is never transferred.';

  @override
  String get pairingModeLimitedHelp =>
      'Working access to selected spaces only. Cannot pair or revoke other devices or manage root keys.';

  @override
  String get directoryTransferSend => 'Send selected';

  @override
  String get directoryTransferError =>
      'The transfer was cancelled or failed verification. Check the connection and start again with a new QR request.';

  @override
  String get directoryTransferConfirm => 'Codes match — continue';

  @override
  String get directoryTransferWaiting =>
      'Waiting for the other device. The request expires in 5 minutes.';

  @override
  String get directoryTransferTitle => 'Transfer directory to another device';

  @override
  String get directoryTransferReceive => 'Receive directory';

  @override
  String get directoryTransferCompareHelp =>
      'Compare the code on both devices in person or over a trusted channel. Cancel if any character differs. Do not compare codes through this server.';

  @override
  String get directoryTransferSelect =>
      'On the source device, select up to 12 spaces';

  @override
  String get directoryTransferDone =>
      'Done. Pair each space separately for access; following lists can be applied after signing in through backup settings.';

  @override
  String get directoryTransferRequest => 'QR request from the new device';

  @override
  String get directoryTransferComparison =>
      'Enter the code shown on the new device';

  @override
  String get directoryTransferCopy => 'Copy QR request';

  @override
  String get directoryTransferHelp =>
      'Open the same trusted space on both devices first. Selected spaces, preferences and following lists are transferred. Keys and access are excluded: pair each space separately after restoring.';

  @override
  String get directoryTransferRelay => 'Select a trusted space for transfer';

  @override
  String get remoteBackupTitle => 'Backups in a space';

  @override
  String get remoteBackupHelp =>
      'Save encrypted backups in a connected space. Its server can run independently or be started by the app using the runtime. Recovery requires the saved kit and a separate password. Pairing or a recovery card restores access to spaces.';

  @override
  String get remoteBackupKitHelp =>
      'The kit contains secret backup read and write credentials. Save it outside this device, separately from the password. Anyone with the kit can download encrypted copies and disrupt future publications.';

  @override
  String get remoteBackupStorage => 'Space for backups';

  @override
  String get remoteBackupSetup => 'Save kit and configure';

  @override
  String get remoteBackupImportKit => 'Open recovery kit';

  @override
  String get remoteBackupPublish => 'Create or resume backup';

  @override
  String get remoteBackupRead => 'Verify and open backup';

  @override
  String get remoteBackupConfigure => 'Retry space setup';

  @override
  String get remoteBackupSaved =>
      'Backup saved in the space and verified after download.';

  @override
  String get remoteBackupConfigured => 'The space is ready to store backups.';

  @override
  String get remoteBackupVerified => 'Version reported by the space:';

  @override
  String get remoteBackupError =>
      'Operation incomplete. Check the kit, password, connection and permissions. Version, signature or digest mismatches block recovery. Retry an unfinished publication with the same password.';

  @override
  String get remoteBackupSaveKit => 'Save kit again';

  @override
  String get remoteBackupRevoke => 'Revoke kit';

  @override
  String get remoteBackupRevokeHelp =>
      'Revoke backup access in the selected space? The owner\'s active session is required. The kit will stop working; stored containers will remain.';

  @override
  String get remoteBackupRevoked => 'Backup access revoked in the space.';

  @override
  String get remoteBackupFreshness =>
      'Rollback is checked against local history. After that history is lost, backup freshness cannot be confirmed.';
}
