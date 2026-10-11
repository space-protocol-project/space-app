// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get overview => '概览';

  @override
  String get chat => '公共聊天';

  @override
  String get forum => '讨论';

  @override
  String get feed => '动态';

  @override
  String get rooms => '会议';

  @override
  String get identity => '身份';

  @override
  String get settings => '设置';

  @override
  String get yourSpace => '你的空间';

  @override
  String get connected => '已连接';

  @override
  String get spaceDisconnected => '空间未连接';

  @override
  String get connection => '连接';

  @override
  String get addSpace => '添加空间';

  @override
  String get chats => '聊天';

  @override
  String get channels => '频道';

  @override
  String get recentSpaces => '最近的空间';

  @override
  String get prototype => '实验性桌面应用';

  @override
  String get logo => 'Space 标志';

  @override
  String get selectedSpace => '当前空间';

  @override
  String get myIdentity => '我的身份';

  @override
  String get aboutSpace => '关于此空间';

  @override
  String get independentServer => '独立服务器。每个空间分别决定你的权限和可用功能。';

  @override
  String get deviceSignedIn => '已使用设备密钥登录';

  @override
  String get noSession => '没有活动会话';

  @override
  String get checkConnection => '检查连接';

  @override
  String get beYourself => '做你自己。';

  @override
  String get ownPace => '无需立即回复。摄像头和麦克风未启用；系统通知目前已关闭。';

  @override
  String get openNavigation => '打开导航';

  @override
  String get reconnecting => '正在重新连接';

  @override
  String get keyLogin => '密钥登录';

  @override
  String get disconnected => '未连接';

  @override
  String get serverConnection => '服务器连接';

  @override
  String get appearanceSettings => '外观设置';

  @override
  String get welcome => '欢迎你来到这里。';

  @override
  String get welcomeDescription => '你的空间，你的交流，按自己的节奏。';

  @override
  String get ideas => '让想法相聚。\n让人们相连。';

  @override
  String get connectDescription => '通过地址添加独立服务器，验证信任后开始交流。无需中心账号。';

  @override
  String get returnChat => '返回聊天';

  @override
  String get yourConversation => '你的交流';

  @override
  String get noMessages => '连接空间后，这里将显示所选服务器的消息。';

  @override
  String get openChat => '打开聊天';

  @override
  String get yourAttention => '你的专注';

  @override
  String get attentionDescription => '应用不会发送系统通知，也不会开启摄像头或麦克风。保持自己的节奏。';

  @override
  String get settingsTitle => '让使用更舒适。';

  @override
  String get settingsDescription => '个人设置保存在此设备上。';

  @override
  String get appearance => '外观';

  @override
  String get darkTheme => '深色主题';

  @override
  String get themeDescription => 'Gruvbox 提供浅色和深色主题。';

  @override
  String get compact => '紧凑模式';

  @override
  String get compactDescription => '更紧凑的控件。';

  @override
  String get myColors => '我的配色';

  @override
  String get ocean => '静谧海洋';

  @override
  String get iris => '柔和鸢尾';

  @override
  String get spaceAppearance => '空间外观';

  @override
  String get spaceAppearanceDescription =>
      '服务器将能够推荐空间配色。在你同意之前，应用会保留个人主题。当前版本尚不接收此类建议。';

  @override
  String get language => '应用语言';

  @override
  String get searchHint => '功能与已加载的消息';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get back => '返回';

  @override
  String get nothingFound => '未找到结果。请尝试其他关键词。';

  @override
  String get appSection => '应用功能';

  @override
  String get loadedMessage => '公共聊天 · 已加载的消息';

  @override
  String messageCount(int count) {
    return '公共聊天消息数：$count';
  }

  @override
  String get revokeTitle => '撤销此设备？';

  @override
  String get revokeDescription => '对所选服务器的访问将终止。密钥会保留在此电脑上；不会自动创建新的授权。';

  @override
  String get keep => '保留';

  @override
  String get revoke => '撤销';

  @override
  String get archived => '已归档';

  @override
  String get noReadAccess => '无消息访问权限';

  @override
  String get manageSpace => '管理空间';

  @override
  String get forumTitle => '让有价值的交流留下来。';

  @override
  String get forumDescription => '为需要更多时间的讨论提供空间。';

  @override
  String get feedTitle => '一点灵感。';

  @override
  String get feedDescription => '你关注的人发布的内容。';

  @override
  String get search => '搜索';

  @override
  String get recoveringEvents => '正在恢复事件。消息和草稿已保留。';

  @override
  String get chatTab => '聊天';

  @override
  String get topicsTab => '话题';

  @override
  String get profileTab => '个人资料';

  @override
  String unreadCount(int count) {
    return '未读消息：$count';
  }

  @override
  String get findSpace => '找到你的空间';

  @override
  String get closeConnection => '关闭连接';

  @override
  String get connectionIntro => '输入独立服务器的地址。我们会先检查，然后由你决定是否信任。';

  @override
  String get serverAddress => '服务器地址或邀请链接';

  @override
  String get optionalInvite => '邀请码（可选）';

  @override
  String get checkServer => '检查服务器';

  @override
  String get verifyTrust => '验证信任';

  @override
  String get serverKeyFingerprint => '服务器密钥指纹';

  @override
  String get tlsCertificateFingerprint => 'TLS 证书指纹';

  @override
  String get firstTrustHelp => '首次连接时，请与服务器所有者提供的信息核对地址和指纹。登录会为此服务器创建独立的密钥。';

  @override
  String get readerInvitation => '读者邀请：只能阅读聊天消息。';

  @override
  String get memberInvitation => '成员邀请：可以阅读和发送聊天消息。';

  @override
  String get trustAndConnect => '信任并连接';

  @override
  String get disconnectServer => '断开服务器连接';

  @override
  String get supportedConnections => '支持公共 HTTPS 服务器和本地 HTTP。可在“身份”中打开恢复卡。';

  @override
  String get chatDescription => '交流与点滴发现。';

  @override
  String get connectionInformation => '连接信息';

  @override
  String get channel => '频道';

  @override
  String get noReading => '无阅读权限';

  @override
  String get refreshChat => '刷新频道和聊天';

  @override
  String get noMessageAccess => '无法访问消息';

  @override
  String get startConversation => '开始交流';

  @override
  String get conversationStarts => '交流从这里开始';

  @override
  String get contactOwner => '请选择其他频道或联系空间所有者。';

  @override
  String get emptyChat => '此聊天中还没有消息。';

  @override
  String get connectChatHelp => '连接你的空间。密钥会保留在此设备上。';

  @override
  String get you => '你';

  @override
  String get newMessages => '新消息';

  @override
  String get cannotSend => '无法在此频道发送消息';

  @override
  String get messageHint => '有什么新鲜事？';

  @override
  String get sendMessage => '发送';

  @override
  String newMessagesCount(int count) {
    return '新消息：$count';
  }

  @override
  String newChannelMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条新消息',
    );
    return '$_temp0';
  }

  @override
  String get homeTitle => '家庭服务器';

  @override
  String get close => '关闭';

  @override
  String get homeFirstSetup => 'Space 将下载服务器和 PostgreSQL，并创建数据库和证书。数据会保留在此电脑上。';

  @override
  String get homeReuse => '再次启动会使用原有的服务器、数据库、密钥、证书和成员。';

  @override
  String get homeIP => '静态公网 IPv4';

  @override
  String get homeIPHint => '互联网服务提供商分配的地址';

  @override
  String get detectingIP => '正在获取 IP…';

  @override
  String get detectIP => '自动获取 IP';

  @override
  String get homeIPPrivacy => '获取地址会访问 ipify。使用 VPN 时将显示 VPN 的地址。';

  @override
  String get homeIPFailed => '无法获取地址。请输入你的静态 IP。';

  @override
  String get homePortHelp =>
      '为让朋友连接，请将路由器的 TCP 8443 端口转发到此电脑的 8443 端口，并在防火墙中放行。无需对外开放 PostgreSQL 或本地端口。';

  @override
  String get goLive => '上线';

  @override
  String get stopHome => '断开';

  @override
  String get homeLink => '你的服务器链接（粘贴到 Space 的连接界面中）';

  @override
  String get copyLink => '复制链接';

  @override
  String get manageServer => '管理服务器';

  @override
  String get homeInviteHelp => '链接本身不授予管理员权限。请通过“管理空间 → 邀请”邀请朋友。停止服务器会断开他们的连接。';

  @override
  String get myHomeServer => '我的家庭服务器';

  @override
  String get homeRunningHelp => '服务器正在运行。断开后所有数据都会保留。';

  @override
  String get homeStartHelp => '在此电脑上运行自己的空间。';

  @override
  String get myServer => '我的服务器';

  @override
  String get homeDetectingIP => '正在通过 ipify 获取公网 IP';

  @override
  String get homeDownloading => '正在下载服务器和 PostgreSQL';

  @override
  String get homeInstalling => '正在验证并安装版本';

  @override
  String get homeStarting => '正在启动已有的服务器';

  @override
  String get homeRunning => '服务器正在此电脑上运行';

  @override
  String get homeStopped => '服务器已停止，数据已保留';

  @override
  String serverNowOnline(String server) {
    return '服务器 $server 现已在线。';
  }

  @override
  String serverNowOffline(String server) {
    return '与服务器 $server 的连接已断开。';
  }

  @override
  String get serverAvailabilityUnknown => '尚不确定是否可用';

  @override
  String get recoveryOperationFailed => '操作未完成。请检查访问权限、身份卡和连接。';

  @override
  String get recoveryFileLabel => 'Space 身份卡';

  @override
  String get recoveryFormat => '身份卡格式';

  @override
  String get recoveryFormatHelp => 'PNG 包含加密二维码，适合打印。JSON 是紧凑的备份文件。请单独保存密码。';

  @override
  String get recoveryPng => 'PNG 二维码';

  @override
  String get recoveryCardSaved => '身份卡已保存。请在另一台设备上测试恢复，并分开保存文件和密码。';

  @override
  String get recoveryTooLarge => '身份卡文件过大';

  @override
  String get recoveryReplaceWarning => '此地址在本设备上保存的密钥将被替换。如果它们属于其他身份，请先保存其身份卡。';

  @override
  String get recoveryConnectionDenied =>
      '密钥已保存，但服务器拒绝连接。请检查身份卡是否被撤销、访问是否被阻止以及聊天是否可用。';

  @override
  String get recoveryRestored => '身份已通过新设备恢复。请检查设备列表并撤销丢失的设备。';

  @override
  String get rotationRenewConfirm =>
      '使用相同的已保存新密钥更新过期请求？如果服务器已完成更换，请完成已保存的更换操作。';

  @override
  String get rotationConfirm =>
      '更换根密钥？您的标识符、权限和历史记录会保留。旧设备和身份卡将失去访问权限。新密钥会先保存到受保护的日志。更换后务必保存新身份卡。';

  @override
  String get rotationServerRequired => '请先检查原服务器地址';

  @override
  String get rotationNotPending => '此服务器没有已保存的密钥更换操作。';

  @override
  String get rotationReconnect => '新密钥已保存。请检查服务器是否可用并重新连接。';

  @override
  String get rotationCompleted => '根密钥已更换，原标识符已保留。请保存新身份卡；旧身份卡和设备已无法使用。';

  @override
  String get recoveryRevokeCard => '撤销恢复密钥？身份卡及所有通过它连接的设备将无法使用。请先确保有其他访问方式。';

  @override
  String get recoveryRevokeDevice => '撤销此设备？其会话和订阅将结束。';

  @override
  String get recoveryRevoked => '已在服务器上撤销权限。';

  @override
  String get pairingAlreadyUsed => '代码已被使用或取消';

  @override
  String get pairingManageRequest => '如果角色允许，还请求了空间管理权限。';

  @override
  String get pairingChatRequest => '请求使用您的权限访问聊天。';

  @override
  String get pairingReady => '代码也会显示在新设备上。签名前请输入新设备显示的验证码。';

  @override
  String get pairingMismatch => '验证码不一致。请勿确认连接。';

  @override
  String get pairingSignConfirm => '两个设备上的代码是否一致？使用根权限为新设备签署所列权限？';

  @override
  String get pairingSigned => '签名已签发。请在新设备上完成登录。';

  @override
  String get pairingStartFailed => '无法开始配对。请检查服务器和 PostgreSQL 是否可用。';

  @override
  String get pairingCancelled => '配对已取消';

  @override
  String get pairingExpired => '代码已过期、已取消或确认未通过验证。请重新开始。';

  @override
  String get pairingCompareTitle => '核对两个设备上的代码';

  @override
  String get pairingMatches => '代码一致';

  @override
  String recoveryRestoreConfirm(String origin, String warning) {
    return '在 $origin 上恢复身份？将为此设备创建新密钥。$warning';
  }

  @override
  String pairingPrepareConfirm(String device, String request) {
    return '准备将“$device”连接到您的身份？$request 尚未签发签名。请先核对两个屏幕上的代码。';
  }

  @override
  String pairingAcceptConfirm(String code, String origin) {
    return '确认设备应显示代码 $code。是否一致？本设备为 $origin 保存的身份将被替换；如果属于其他账户，请先保存其身份卡。';
  }

  @override
  String get recoveryCancel => '取消';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');
}
