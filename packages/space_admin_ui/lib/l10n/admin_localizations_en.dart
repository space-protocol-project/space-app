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

  @override
  String get channelsTitle => 'Channels and permissions';

  @override
  String get channelsReload => 'Refresh channels';

  @override
  String get channelsEmpty => 'No channels yet.';

  @override
  String get channelCreateSection => 'Create a chat channel';

  @override
  String get channelNewId => 'New channel address';

  @override
  String get channelNewTitle => 'New channel name';

  @override
  String get channelNewOrder => 'New channel order';

  @override
  String get channelDefaults =>
      'Members can read and send; readers can read. Public preview is disabled.';

  @override
  String get channelCreate => 'Create channel';

  @override
  String get channelName => 'Channel name';

  @override
  String get channelOrder => 'Channel order';

  @override
  String get channelArchive => 'Archive channel';

  @override
  String get channelPublicPreview =>
      'Show the name to visitors without signing in';

  @override
  String get channelPreviewHelp =>
      'Preview reveals the name and address, but no messages. Archiving preserves history and blocks new messages.';

  @override
  String get channelSave => 'Save channel';

  @override
  String get channelReload => 'Reload channel';

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
  String get channelVisible => 'See channel';

  @override
  String get channelRead => 'Read messages';

  @override
  String get channelWrite => 'Send messages';

  @override
  String get channelManage => 'Manage channel';

  @override
  String get channelsLoaded => 'Channels loaded.';

  @override
  String get channelLoaded => 'Channel and permissions loaded.';

  @override
  String get channelCreated => 'Channel created.';

  @override
  String get channelSaved => 'Channel settings saved.';

  @override
  String get channelAccessSaved => 'Channel permissions saved.';

  @override
  String get channelRuleAdded =>
      'Rule added to the form. Save permissions to apply it.';

  @override
  String get channelConflict =>
      'The channel or permissions have changed. Reload them; unsaved fields remain in the form.';

  @override
  String get channelChanged => 'Channel changed while loading its permissions';

  @override
  String get channelOrderInvalid => 'Order must be between 0 and 100000';

  @override
  String get channelNameInvalid => 'Enter a name up to 320 bytes';

  @override
  String get channelIdInvalid =>
      'Address: Latin letters, digits, _ or -, starting with a letter';

  @override
  String get channelIdTaken =>
      'This channel address is already in use. Choose another.';

  @override
  String get channelUnavailable => 'Channel is no longer available';

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
    return 'Channel $id · revision $revision';
  }

  @override
  String channelAccessRevision(String revision) {
    return 'Channel permissions · revision $revision';
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
}
