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
  String get identity => 'Identity';

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
  String get myIdentity => 'My identity';

  @override
  String get aboutSpace => 'About this space';

  @override
  String get independentServer =>
      'An independent server. Each space defines your permissions and available sections.';

  @override
  String get deviceSignedIn => 'Signed in with a device key';

  @override
  String get noSession => 'No active session';

  @override
  String get checkConnection => 'Check connection';

  @override
  String get beYourself => 'Be yourself.';

  @override
  String get ownPace =>
      'Reply at your own pace. Camera and microphone are inactive; system notifications are currently disabled.';

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
  String get welcome => 'Good to have you here.';

  @override
  String get welcomeDescription =>
      'Your space, your conversations, at your own pace.';

  @override
  String get ideas => 'A place for ideas.\nAnd the people behind them.';

  @override
  String get connectDescription =>
      'Add an independent server by its address, verify trust and join the conversation. No central account is needed.';

  @override
  String get returnChat => 'Back to the conversation';

  @override
  String get yourConversation => 'Your conversation';

  @override
  String get noMessages =>
      'Connect a space to see messages from the selected server.';

  @override
  String get openChat => 'Open chat';

  @override
  String get yourAttention => 'Your attention';

  @override
  String get attentionDescription =>
      'The app does not send system notifications or activate your camera or microphone. Keep your own pace.';

  @override
  String get settingsTitle => 'Make yourself comfortable.';

  @override
  String get settingsDescription =>
      'Your preferences are saved on this device.';

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
  String get connectionIntro =>
      'Enter an independent server address. We will check it first, then you decide whether to trust it.';

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
      'Space will download the server and PostgreSQL, then create a database and certificate. Your data stays on this computer.';

  @override
  String get homeReuse =>
      'Starting again uses your existing server, database, keys, certificate and members.';

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
      'The link does not grant administrator rights. Invite friends through Manage space → Invitations. Stopping the server disconnects them.';

  @override
  String get myHomeServer => 'My home server';

  @override
  String get homeRunningHelp =>
      'The server is running. Disconnecting preserves all data.';

  @override
  String get homeStartHelp => 'Run your own space on this computer.';

  @override
  String get myServer => 'My server';

  @override
  String get homeDetectingIP => 'Detecting public IP with ipify';

  @override
  String get homeDownloading => 'Downloading the server and PostgreSQL';

  @override
  String get homeInstalling => 'Verifying and installing the release';

  @override
  String get homeStarting => 'Starting your existing server';

  @override
  String get homeRunning => 'The server is running on this computer';

  @override
  String get homeStopped => 'Server stopped; data preserved';
}
