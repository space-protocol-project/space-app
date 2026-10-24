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
  String get managementIntro => 'Space settings and members.';

  @override
  String get managementSections => '';

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
      'You explicitly allow this device to change settings, chats, voice rooms, and member access.';

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
  String get bothNames => 'Enter the space name';

  @override
  String get settingsConflict =>
      'Settings have changed. Reload them and try again.';

  @override
  String settingsRevision(String revision) {
    return 'Space settings · revision $revision';
  }

  @override
  String get channelsTitle => 'Chats and permissions';

  @override
  String get channelsReload => 'Refresh chats';

  @override
  String get channelsEmpty => 'No chats yet.';

  @override
  String get channelCreateSection => 'Create a chat';

  @override
  String get channelNewId => 'New chat address';

  @override
  String get channelNewTitle => 'New chat name';

  @override
  String get channelNewOrder => 'Order';

  @override
  String get channelDefaults =>
      'Members can read and send; readers can read. Public preview is disabled.';

  @override
  String get channelCreate => 'Create chat';

  @override
  String get channelName => 'Name';

  @override
  String get channelOrder => 'Order';

  @override
  String get channelArchive => 'Archive chat';

  @override
  String get channelPublicPreview =>
      'Show the name to visitors without signing in';

  @override
  String get channelPreviewHelp =>
      'Preview reveals the name and address, but no messages. Archiving preserves history and blocks new messages.';

  @override
  String get channelSave => 'Save chat';

  @override
  String get channelReload => 'Reload';

  @override
  String get channelAccessHelp =>
      'Individual rules override role rules. Owners and admins retain access. Readers cannot send messages. Manage allows metadata changes, but not permission changes.';

  @override
  String get channelRulesEmpty =>
      'No rules: only owners and admins have access.';

  @override
  String get channelRuleSubject => 'Add a rule for';

  @override
  String get channelMembers => 'Members';

  @override
  String get channelReaders => 'Readers';

  @override
  String get channelIndividual => 'Individual member';

  @override
  String get channelSelectMember => 'Select a member';

  @override
  String get channelMoreMembers => 'Load more members';

  @override
  String get channelPrincipalId => 'Or the full member ID';

  @override
  String get channelAddRule => 'Add rule';

  @override
  String get channelSaveAccess => 'Save permissions';

  @override
  String get channelDeleteRule => 'Remove rule';

  @override
  String get channelVisible => 'Visible';

  @override
  String get channelRead => 'Read messages';

  @override
  String get channelWrite => 'Send messages';

  @override
  String get channelManage => 'Manage';

  @override
  String get channelsLoaded => 'List loaded.';

  @override
  String get channelLoaded => 'Settings and permissions loaded.';

  @override
  String get channelCreated => 'Chat created.';

  @override
  String get channelSaved => 'Chat settings saved.';

  @override
  String get channelAccessSaved => 'Permissions saved.';

  @override
  String get channelRuleAdded =>
      'Rule added to the form. Save permissions to apply it.';

  @override
  String get channelConflict =>
      'Settings or permissions have changed. Reload them; unsaved fields remain in the form.';

  @override
  String get channelChanged =>
      'Settings changed between loading the list and permissions';

  @override
  String get channelOrderInvalid => 'Order must be between 0 and 100000';

  @override
  String get channelNameInvalid => 'Enter a name up to 320 bytes';

  @override
  String get channelIdInvalid =>
      'Address: Latin letters, digits, _ or -, starting with a letter';

  @override
  String get channelIdTaken => 'This address is already taken. Choose another.';

  @override
  String get channelUnavailable => 'No longer available';

  @override
  String get channelRulesLimit => 'Limit: 100 rules';

  @override
  String get channelMemberRequired => 'Select a member or enter their full ID';

  @override
  String get channelRuleDuplicate =>
      'A rule for this member or role already exists';

  @override
  String get channelAccessTooLarge =>
      'Permissions exceed the request limit. Reduce the number of individual rules.';

  @override
  String channelRevision(String id, String revision) {
    return '$id · revision $revision';
  }

  @override
  String channelAccessRevision(String revision) {
    return 'Permissions · revision $revision';
  }

  @override
  String get channelArchivedSuffix => ' · Archived';

  @override
  String get channelBlockedSuffix => ' · Blocked';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleMember => 'Member';

  @override
  String get roleReader => 'Reader';

  @override
  String get membersConflict =>
      'Permissions have changed. Unsaved values remain in the form. Refresh members before trying again.';

  @override
  String get membersLoaded => 'Members loaded.';

  @override
  String get memberConfirm => 'Change member permissions?';

  @override
  String get memberApply => 'Apply permissions';

  @override
  String get memberSaved =>
      'Member permissions saved. The server applies them to actions and subscriptions.';

  @override
  String get memberCollapse => 'Collapse permissions';

  @override
  String get memberEdit => 'Edit permissions';

  @override
  String get memberRole => 'Member role';

  @override
  String get memberBlock => 'Block member';

  @override
  String get memberSave => 'Save member permissions';

  @override
  String get membersRefresh => 'Refresh members';

  @override
  String get membersHelp =>
      'Only the owner can change roles and block members. Administrators can view the list.';

  @override
  String get membersSearch => 'Search by ID or role';

  @override
  String get membersEmpty => 'No members found.';

  @override
  String get memberBlocked => 'blocked';

  @override
  String get memberAllowed => 'allowed';

  @override
  String get memberBlockedSuffix => ' · Access blocked';

  @override
  String memberProposal(String id, String role, String access) {
    return '$id\nRole: $role\nAccess: $access';
  }

  @override
  String membersCount(int count) {
    return 'Loaded: $count. Search covers loaded members.';
  }

  @override
  String get invitesTitle => 'Invitations';

  @override
  String get invitesRefresh => 'Refresh invitations';

  @override
  String get invitesHelp =>
      'Owners and admins invite members and readers. An invitation does not change an existing member\'s role.';

  @override
  String get inviteRole => 'Invitee role';

  @override
  String get inviteMember => 'Member — read and send';

  @override
  String get inviteReader => 'Reader — read only';

  @override
  String get inviteTtl => 'Invitation duration';

  @override
  String get inviteMinute => '1 minute';

  @override
  String get inviteHour => '1 hour';

  @override
  String get inviteDay => '1 day';

  @override
  String get inviteWeek => '7 days';

  @override
  String get inviteUses => 'Number of uses (1–100)';

  @override
  String get inviteCreate => 'Create invitation';

  @override
  String get inviteCode => 'New invitation code';

  @override
  String get inviteLink => 'Link for Space';

  @override
  String get inviteLinkHelp =>
      'The code is shown only now and stays in this form\'s memory. Paste the link into Add space in Space. A public server must be reachable from your friend\'s network.';

  @override
  String get inviteCopyCode => 'Copy code';

  @override
  String get inviteCopyLink => 'Copy link';

  @override
  String get inviteHide => 'Hide code';

  @override
  String get inviteRevoke => 'Revoke invitation';

  @override
  String get inviteRevokeConfirm => 'Revoke invitation?';

  @override
  String get inviteRevokeHelp =>
      'New members cannot join with this invitation. Members who already joined keep their access.';

  @override
  String get invitesEmpty => 'No invitations yet.';

  @override
  String get invitesMore => 'Load more invitations';

  @override
  String get inviteRevokedState => 'Revoked';

  @override
  String get inviteExpiredState => 'Expired';

  @override
  String get inviteUsedState => 'Used up';

  @override
  String get inviteActiveState => 'Active';

  @override
  String get invitesLoaded => 'Invitations loaded.';

  @override
  String get inviteCreated => 'Invitation created. Copy the code or link now.';

  @override
  String get inviteCopied => 'Copied to clipboard.';

  @override
  String get inviteCopyFailed =>
      'Copy is unavailable. Select the code or link and copy it manually.';

  @override
  String get inviteRevoked =>
      'Invitation revoked. Existing members keep their access.';

  @override
  String get inviteUsesInvalid => 'Enter a number of uses from 1 to 100';

  @override
  String inviteExpiry(String expiry, int uses, int limit) {
    return 'Until $expiry, device time · uses $uses/$limit';
  }

  @override
  String get devicesTitle => 'Devices and permissions';

  @override
  String get devicesHelp =>
      'Only devices belonging to your identity. Server roles and device permissions are checked separately.';

  @override
  String get devicesRefresh => 'Refresh devices';

  @override
  String get devicesEmpty => 'No available devices.';

  @override
  String get deviceRecovery => 'Recovery key';

  @override
  String get deviceCurrent => 'This device';

  @override
  String get deviceOther => 'Other device';

  @override
  String get deviceRevokeAccess => 'Revoke access';

  @override
  String get deviceRevokeConfirm => 'Revoke access?';

  @override
  String get deviceRevoke => 'Revoke';

  @override
  String get deviceRecoveryWarning =>
      'The card and all devices connected through it will lose access. Make sure you have another recovery method.';

  @override
  String get deviceCurrentWarning =>
      'This device will lose access. Its session and subscriptions will end.';

  @override
  String get deviceOtherWarning =>
      'The device\'s sessions and subscriptions will end.';

  @override
  String get deviceCardHelp =>
      'After confirming, select the original JSON or PNG card. Its secret is used only to sign the request.';

  @override
  String get deviceCardPassword => 'Card password';

  @override
  String get devicesLoaded => 'Devices loaded.';

  @override
  String get deviceRevokedStatus => 'Access revoked on the server.';

  @override
  String get deviceExpiryUnknown => 'Expiry unknown';

  @override
  String deviceAccessUntil(String expiry) {
    return 'Access until $expiry';
  }

  @override
  String deviceExpired(String expiry) {
    return 'Expired: $expiry';
  }

  @override
  String deviceScopes(String scopes) {
    return 'Permissions: $scopes';
  }

  @override
  String deviceParent(String id) {
    return 'Issued through: $id';
  }

  @override
  String get recoveryConfirm => 'Confirm action';

  @override
  String get recoveryConfirmButton => 'Confirm';

  @override
  String get recoveryProtect => 'Protect your card';

  @override
  String get recoveryOpen => 'Open card';

  @override
  String get recoveryPasswordHelp =>
      'The password encrypts the file only on this device. It is not sent to the server. Use several random words and store the password separately.';

  @override
  String get recoveryPassword => 'Password (at least 12 characters)';

  @override
  String get recoveryPasswordRepeat => 'Repeat password';

  @override
  String get recoveryPasswordInvalid => 'The passwords do not match.';

  @override
  String get recoveryEncrypt => 'Encrypt';

  @override
  String get recoveryOpenButton => 'Open';

  @override
  String get pairingIdentity => 'Already have an identity?';

  @override
  String get pairingIntro =>
      'Connect this computer by approving it on your original device. The root key and card are not copied. Pairing does not require an invitation.';

  @override
  String get pairingStart => 'Trust server and start pairing';

  @override
  String get pairingInstructions =>
      'On your original device, open Identity → Approve device in Space. The code expires in five minutes.';

  @override
  String get pairingCopy => 'Copy code';

  @override
  String get pairingWaiting => 'Waiting for the original device\'s signature…';

  @override
  String get pairingCheckBeforeSign =>
      'Enter this verification code on the authorizing device before signing:';

  @override
  String get pairingVerified =>
      'Root signature verified. Compare the code on both screens:';

  @override
  String get pairingAccept => 'Code matches — connect';

  @override
  String get pairingCancel => 'Cancel pairing';

  @override
  String get rotationTitle => 'Root key rotation';

  @override
  String get rotationHelp =>
      'Preserves your identity and revokes old keys. Start on a device holding the root key. After a failure, finish the saved rotation. If the request expires before the server completes it, connect with the old key and renew the request.';

  @override
  String get rotationStart => 'Rotate root key';

  @override
  String get rotationRenew => 'Renew expired request';

  @override
  String get rotationFinish => 'Finish saved rotation';

  @override
  String get pairingApproveTitle => 'Approve device';

  @override
  String get pairingApproveHelp =>
      'Enter the one-time code from the new device. Signing requires the root key or an opened recovery card. For a recovery card, the new device verifies the chain from the original root key.';

  @override
  String get pairingCode => 'Pairing code';

  @override
  String get pairingPrepare => 'Check and approve';

  @override
  String get pairingComparison =>
      'Verification code to compare with the new device';

  @override
  String get pairingEnteredCode => 'Verification code from the new device';

  @override
  String get pairingSign => 'Codes match — sign';

  @override
  String get recoveryTitle => 'Access recovery';

  @override
  String get recoveryHelp =>
      'The QR card restores your identity. Set a password and keep it separately.';

  @override
  String get recoveryExport => 'Save QR';

  @override
  String get recoveryRestore => 'Restore from file';

  @override
  String get recoveryScan => 'Scan with camera';

  @override
  String get recoveryDevices => 'Your devices';

  @override
  String get recoveryDevicesHelp =>
      'Only permissions for your identity are shown. Old and revoked records are retained.';

  @override
  String get cameraTitle => 'Scan card';

  @override
  String get cameraHelp =>
      'Point the camera at a Space QR card. Frames are processed on this device. The microphone is off.';

  @override
  String get cameraRestart => 'Restart camera';

  @override
  String get cameraCapture => 'Scan QR';

  @override
  String cameraLabel(int number, String name) {
    return 'Camera $number — $name';
  }

  @override
  String get serverIconTitle => 'Space icon';

  @override
  String get serverIconUpload => 'Choose PNG or SVG';

  @override
  String get serverIconHelp =>
      'PNG is resized. SVG: up to 8 KiB, without scripts or external links.';

  @override
  String get serverIconInvalid =>
      'Could not read the icon. Choose PNG up to 2048×2048 or a simple SVG up to 8 KiB.';

  @override
  String get serverIconUpgrade => 'Update the server to change its icon.';

  @override
  String get iconOrbit => 'Orbit';

  @override
  String get iconPlanet => 'Planet';

  @override
  String get iconLeaf => 'Leaf';

  @override
  String get iconStar => 'Star';

  @override
  String get iconBolt => 'Bolt';

  @override
  String get iconRocket => 'Rocket';

  @override
  String get recoveryCreateQr => 'Create QR';

  @override
  String get recoveryOriginalCardNeeded =>
      'This device has no recovery key. Use the original card.';

  @override
  String get channelDelete => 'Delete chat';

  @override
  String channelDeleteConfirm(String name) {
    return 'Delete “$name” and all its messages? This cannot be undone.';
  }

  @override
  String get channelDeleted => 'Chat deleted.';

  @override
  String get storageTitle => 'File storage';

  @override
  String get storageTotal => 'Server storage limit, MiB';

  @override
  String get storageMember => 'Default member limit, MiB';

  @override
  String get storageHelp =>
      '0 disables new uploads. Existing files are kept. Pending uploads also count towards the limit.';

  @override
  String get storagePersonal => 'Personal limit, MiB';

  @override
  String get storageInherited => 'Empty uses the default limit';

  @override
  String get attachmentsEnabled => 'Allow file attachments';

  @override
  String get attachmentsEnabledHelp =>
      'When disabled, members cannot attach or download files. File features are hidden for this space.';

  @override
  String get voiceRoomsTitle => 'Voice rooms';

  @override
  String get voiceRoomsReload => 'Refresh rooms';

  @override
  String get voiceRoomsEmpty => 'No rooms yet.';

  @override
  String get voiceRoomCreate => 'Create room';

  @override
  String get voiceRoomNewTitle => 'New room name';

  @override
  String get voiceRoomDefaults =>
      'Members can listen and speak; readers can listen.';

  @override
  String get voiceRoomListen => 'Listen';

  @override
  String get voiceRoomSpeak => 'Speak';

  @override
  String get voiceRoomAccessHelp =>
      'An individual rule replaces the role rule. Owners and administrators retain access. Readers can listen but cannot speak. Manage changes room settings, not permissions.';

  @override
  String get voiceRoomArchive => 'Archive room';

  @override
  String get voiceRoomArchiveHelp =>
      'Archived rooms cannot accept new connections.';

  @override
  String get voiceRoomSave => 'Save room';

  @override
  String get voiceRoomDelete => 'Delete room';

  @override
  String voiceRoomDeleteConfirm(String name) {
    return 'Delete room “$name”? This cannot be undone.';
  }

  @override
  String get voiceRoomCreated => 'Room created.';

  @override
  String get voiceRoomSaved => 'Room settings saved.';

  @override
  String get voiceRoomDeleted => 'Room deleted.';

  @override
  String get voiceRoomCapacity => 'Participant limit';

  @override
  String get voiceRoomCapacityHelp =>
      'From 2 to 32, default 8. Lowering the limit does not disconnect participants. Changing the limit requires up-to-date apps for all participants.';

  @override
  String get voiceRoomCapacityInvalid =>
      'Enter a whole number of participants from 2 to 32.';

  @override
  String get forumSectionsTitle => 'Forum sections and permissions';

  @override
  String get forumSectionDefaults =>
      'Members can read, create topics and reply; readers can only read.';

  @override
  String get forumSectionAccessHelp =>
      'Manage and Read permissions allow closing topics. The device needs administrative access. Authorship alone does not allow closing.';

  @override
  String get forumSectionPrivacy =>
      'Forum sections do not support public previews or end-to-end encryption. Archived sections are read-only.';

  @override
  String get feedSectionsTitle => 'Feed sections';

  @override
  String get feedSectionDefaults =>
      'Members receive regular section access. Publishing and commenting are granted separately in the feed.';

  @override
  String get feedSectionAccessHelp =>
      'These rules control section reading and moderation. Set publishing and commenting permissions in the feed menu.';

  @override
  String get feedSectionPrivacy =>
      'Posts are visible to the server. End-to-end encryption and public preview are unavailable.';
}
