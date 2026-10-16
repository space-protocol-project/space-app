// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get failureConflict => '消息已更改。请关闭编辑器并打开最新版本；关闭前可以复制您输入的文本。';

  @override
  String get messageDeleted => '消息已删除';

  @override
  String get messageEdited => '已编辑';

  @override
  String get messageActions => '消息操作';

  @override
  String get editMessage => '编辑';

  @override
  String get deleteMessage => '删除';

  @override
  String get deleteMessageConfirm => '为所有成员删除此消息？此操作无法撤销。';

  @override
  String get saveMessage => '保存';

  @override
  String get cancelMessageChange => '取消';

  @override
  String get messageText => '消息内容';

  @override
  String get messageTextInvalid => '请输入不超过4096字节的文本。';

  @override
  String get interfaceScale => '界面缩放';

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
  String get identity => '我的访问权限与设备';

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
  String get myIdentity => '我的访问权限与设备';

  @override
  String get aboutSpace => '关于此空间';

  @override
  String get independentServer => '频道和访问权限由此服务器管理。';

  @override
  String get deviceSignedIn => '已使用设备密钥登录';

  @override
  String get noSession => '没有活动会话';

  @override
  String get checkConnection => '检查连接';

  @override
  String get beYourself => '做你自己。';

  @override
  String get ownPace => '摄像头和麦克风已关闭。';

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
  String get welcome => '您的空间';

  @override
  String get welcomeDescription => '服务器频道和资源。';

  @override
  String get ideas => '让想法相聚。\n让人们相连。';

  @override
  String get connectDescription => '通过地址或邀请添加服务器。';

  @override
  String get returnChat => '返回聊天';

  @override
  String get yourConversation => '你的交流';

  @override
  String get noMessages => '连接后查看消息。';

  @override
  String get openChat => '打开聊天';

  @override
  String get yourAttention => '你的专注';

  @override
  String get attentionDescription => '应用不会发送系统通知，也不会开启摄像头或麦克风。保持自己的节奏。';

  @override
  String get settingsTitle => '应用设置';

  @override
  String get settingsDescription => '保存在此设备上。';

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
  String get connectionIntro => '输入服务器地址或邀请。';

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
  String get homeTitle => '直播';

  @override
  String get close => '关闭';

  @override
  String get homeFirstSetup => '服务器和数据将在此计算机上创建。';

  @override
  String get homeReuse => '您的服务器和数据已保存。';

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
  String get homeInviteHelp => '邀请：空间管理。关闭服务器将断开参与者连接。';

  @override
  String get myHomeServer => '我的家庭服务器';

  @override
  String get homeRunningHelp => '服务器正在运行。断开后所有数据都会保留。';

  @override
  String get homeStartHelp => '在此电脑上运行自己的空间。';

  @override
  String get myServer => '上线';

  @override
  String get homeDetectingIP => '正在通过 ipify 获取公网 IP';

  @override
  String get homeDownloading => '正在下载服务器和 PostgreSQL';

  @override
  String get homeInstalling => '正在验证并安装版本';

  @override
  String get homeUpdating => '正在检查并更新服务器';

  @override
  String get homeUpdate => '更新服务器';

  @override
  String get homeReleaseChanges => '版本变更';

  @override
  String get managementTab => '管理';

  @override
  String get homeNoReleaseNotes => '此版本未提供变更说明。';

  @override
  String homeSpaceDetails(String required, String available) {
    return '所需：$required MiB · 可用：$available MiB';
  }

  @override
  String get failureHomeSpaceLow => '家庭服务器操作所需的磁盘空间不足。请释放空间后重试。';

  @override
  String get failureHomeSpaceUnknown => '无法检查可用空间。请检查磁盘是否可访问后重试。';

  @override
  String get homeResumeUpdate => '继续更新或恢复';

  @override
  String get homeUpdateConfirm =>
      '参与者将暂时无法访问服务器。迁移前会创建备份。操作后服务器仍保持关闭，请点击上线重新启动。';

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
  String get rotationDevicesReview => '请检查将保留访问权限的设备。如果有不认识的设备，请取消并先撤销其权限。';

  @override
  String get rotationConfirm =>
      '更换根密钥？您的 ID、权限、历史记录和已验证的有效设备将保留，访问期限不会延长。旧会话和恢复卡将失效。新密钥将先保存到受保护的日志中。更换后请保存新的恢复卡。';

  @override
  String get rotationServerRequired => '请先检查原服务器地址';

  @override
  String get rotationNotPending => '此服务器没有已保存的密钥更换操作。';

  @override
  String get rotationReconnect => '新密钥已保存。请检查服务器是否可用并重新连接。';

  @override
  String get rotationCompleted => '根密钥已更换，ID 和已验证的设备已保留。请保存新的恢复卡；旧卡已失效。';

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

  @override
  String get dashboard => '总览';

  @override
  String get dashboardTitle => '您的所有空间，尽在一处。';

  @override
  String get dashboardDescription => '服务器、频道和未读消息。';

  @override
  String get dashboardServers => '服务器';

  @override
  String get dashboardOnline => '在线';

  @override
  String get dashboardChannels => '可访问频道';

  @override
  String get dashboardUnread => '未读消息';

  @override
  String get dashboardRefresh => '刷新总览';

  @override
  String get dashboardEmpty => '添加您的首个空间';

  @override
  String get dashboardEmptyHelp => '添加服务器或创建自己的服务器。';

  @override
  String get dashboardCatalogUnknown => '连接后加载频道。';

  @override
  String get dashboardAvailable => '可用';

  @override
  String get dashboardUnavailable => '不可用';

  @override
  String get dashboardOpen => '打开空间';

  @override
  String get dashboardResourcesHelp => '总览包含您可访问的频道和未读消息。无法访问的服务器重新连接后，其数据将显示。';

  @override
  String get dashboardSpaces => '您的空间';

  @override
  String get failureCardCorrupt => '身份卡已损坏或格式无效。';

  @override
  String get failurePasswordInvalid => '密码必须至少包含 12 个字符，且不超过 512 字节。';

  @override
  String get failureCardTooLarge => '身份卡超出允许的大小。';

  @override
  String get failureCardUnsupported => '不支持此身份卡格式或加密参数。';

  @override
  String get failureCardAuthentication => '密码错误或身份卡损坏。请检查文件和密码。';

  @override
  String get failureReleaseInvalid => '服务器版本描述未通过验证。安装已停止。';

  @override
  String get failurePlatformUnsupported => '此平台尚无经过验证的家庭服务器版本。';

  @override
  String get failureDownloadAddress => '不允许使用此服务器下载地址。安装已停止。';

  @override
  String get failureDownloadFailed => '无法下载服务器。请检查连接并重试。';

  @override
  String get failureRedirectLimit => '下载重定向次数过多。安装已停止。';

  @override
  String get failureReleaseSize => '服务器下载不完整或大小不正确。请重新下载。';

  @override
  String get failureHashMismatch => '版本校验和不一致。禁止运行此压缩包。';

  @override
  String get failureArchiveInvalid => '服务器压缩包包含无效的路径、文件或大小。安装已停止。';

  @override
  String get failureExecutePermission => '无法授予服务器运行权限。请检查应用目录的访问权限。';

  @override
  String get failureHomeStartFailed => '无法启动家庭服务器。请检查数据访问权限、可用端口和连接设置。';

  @override
  String get failureHomeStopFailed => '服务器未确认所有进程已停止。重新启动前请检查其状态。';

  @override
  String get failureHomeUpdatePending => '家庭服务器更新尚未完成。请先完成更新或恢复；正常启动已被阻止。';

  @override
  String get failureHomeJournalInvalid => '更新日志损坏或无法访问。自动继续已被阻止，需要手动检查。';

  @override
  String get failureHomeBackupMissing => '备份不存在。自动恢复已被阻止。';

  @override
  String get failureHomeBackupInvalid => '备份损坏、不完整或无法访问。当前数据未被替换。';

  @override
  String get failureHomeRecoveryInvalid => '原始记录或恢复目录与原始数据库不匹配。已阻止切换。';

  @override
  String get homeRecoveryHelp =>
      '保留整个 home-server 目录，包括日志、backups、recoveries 和 failed-data。请勿删除日志或手动替换数据库。请打开恢复指南。';

  @override
  String get homeRecoveryGuide => '恢复指南';

  @override
  String get homeRecoveryGuideFailed => '无法打开恢复指南。';

  @override
  String get homeRecoveryCopy => '复制诊断信息';

  @override
  String get failureHomeUpdateFailed => '更新未完成。请检查操作状态并重试；未经验证的新版本不会启动。';

  @override
  String get failurePermissionDenied => '服务器拒绝访问。请检查角色、封禁状态和邀请。';

  @override
  String get failureUnauthenticated => '会话或设备授权无效。请重新登录；不会自动创建新授权。';

  @override
  String get failureServerLimit => '已达到服务器限制。请稍后重试。';

  @override
  String get failureConnectionFailed => '无法连接服务器。请检查地址和网络。';

  @override
  String get failureTlsRejected => '无法验证安全连接。请检查证书和可信指纹。';

  @override
  String get failureProtocolInvalid => '服务器返回了不兼容或无效的数据。操作已停止。';

  @override
  String get failureIdentityInvalid => '密钥、签名或身份验证失败。操作已停止。';

  @override
  String get failureAddressInvalid => '请输入 HTTPS 服务器地址或本地 HTTP 地址。请检查链接和邀请码。';

  @override
  String get failureOperationFailed => '操作失败。请检查连接及安全存储访问权限。';

  @override
  String get failureRetrySameRequest => '重试相同文本会重复使用原请求密钥。';

  @override
  String get failurePositionsLoad => '无法加载阅读位置。将重新加载历史记录。';

  @override
  String get failurePositionsSave => '阅读位置已更新，但无法保存到此设备。';

  @override
  String get failureChannelChanged => '频道权限已更改。请刷新聊天后重试。';

  @override
  String get failureChannelUnavailable => '此频道的访问权限已更改。请选择可访问的聊天。';

  @override
  String get failureEventsUnsupported => '此服务器尚不支持事件订阅。请更新服务器。';

  @override
  String get failureCursorRejected => '服务器拒绝了历史游标。请重新连接以加载消息。';

  @override
  String get failureDeviceRevoked => '此设备的访问权限已撤销。密钥已保留；不会自动创建新授权。';

  @override
  String get failureQrTooLarge => '卡片太大，无法生成二维码。请保存为 JSON。';

  @override
  String get failureQrFileTooLarge => '文件超过大小限制：PNG 为 8 MiB，JSON 为 16 KiB。';

  @override
  String get failureQrImageInvalid => 'PNG 已损坏或尺寸无效。请使用原始文件，每边为 64–2048 像素。';

  @override
  String get failureQrUnreadable => '无法读取二维码，或它不是 Space 卡片。请选择带白色边距的原始 PNG。';

  @override
  String get failureKeyStorageMismatch => '密钥记录属于其他地址。操作已停止。';

  @override
  String get failureKeyStorageSave => '安全存储未确认密钥已保存。没有已保存的密钥时不会提交轮换。';

  @override
  String get failureKeyJournalInvalid => '密钥轮换日志已损坏或超过 64 KiB。请检查安全存储。';

  @override
  String get failureCameraDenied => '摄像头访问被拒绝。请在系统设置中允许访问。';

  @override
  String get failureCameraUnavailable => '摄像头不可用或被占用。可使用 PNG 或 JSON 恢复。';

  @override
  String get failureCameraFrame => '无法读取画面。请检查摄像头或选择文件。';

  @override
  String get failureCameraStopped => '摄像头已停止。请选择重新启动摄像头。';

  @override
  String get sendingMessage => '正在发送…';

  @override
  String get messageUnconfirmed => '未收到服务器确认。请重试相同文本。';

  @override
  String get messageAccepted => '服务器已接收';

  @override
  String get appSettings => '应用设置';

  @override
  String get serverSettings => '服务器设置';

  @override
  String get homeStopping => '正在停止服务器和数据库…';

  @override
  String get homeProgressHint => '按已完成阶段显示进度。无法提前确定进程等待时间。';

  @override
  String homeProgressElapsed(int seconds) {
    return '已用时：$seconds 秒';
  }

  @override
  String homeDownloadEstimate(int seconds) {
    return '下载：预计还需 $seconds 秒';
  }

  @override
  String get identityDescription => '所选空间的密钥、权限和访问恢复。';

  @override
  String get hotkeysTitle => '键盘快捷键';

  @override
  String get resetShortcut => '恢复默认 Enter';

  @override
  String get sendShortcutTitle => '发送快捷键';

  @override
  String get sendShortcutHelp => '选择 Enter 或 Shift+Enter 发送。另一组合键用于换行。';

  @override
  String get createOwnSpace => '创建空间';

  @override
  String get setupSpaceName => '名称';

  @override
  String get setupResources => '功能';

  @override
  String get setupComingSoon => '即将推出';

  @override
  String get setupInternetHelp => '邀请朋友：公网 IPv4 和 TCP 8443 端口转发。';

  @override
  String get setupReady => '空间已准备好';

  @override
  String get setupInviteHelp => '一次性邀请 · 24小时。可在管理中创建更多邀请。';

  @override
  String get setupWorking => '正在创建空间…';

  @override
  String get setupBack => '返回';

  @override
  String get setupNext => '下一步';

  @override
  String get setupOwnerRequired => '无法以所有者身份连接。请打开上线并检查服务器状态。';

  @override
  String get setupUpdateRequired => '请先更新家庭服务器，然后设置图标。';

  @override
  String get myDevice => '设备';

  @override
  String get myDeviceDescription => '此设备上的身份和密钥。';

  @override
  String get myDeviceStorage => '密钥保存在设备安全存储中。';

  @override
  String get myDeviceAccessHelp => '选择身份以使用二维码、恢复和配对。';

  @override
  String get deviceIdentityChoice => '此设备上的身份';

  @override
  String get deviceConnectIdentity => '连接身份';

  @override
  String get recoveryReadingFile => '正在读取文件…';

  @override
  String get recoveryDecryptingCard => '正在解密并验证密钥…';

  @override
  String get recoveryCheckingServer => '正在检查服务器…';

  @override
  String get recoveryConnectingDevice => '正在连接设备…';

  @override
  String get recoveryChooseFile => '选择 PNG 或 JSON 恢复卡';

  @override
  String get recoveryParentFolder => '上级文件夹';

  @override
  String get recoveryFilePath => '完整文件路径';

  @override
  String get recoveryOpenFile => '打开文件';

  @override
  String get recoveryFolderUnavailable => '无法读取文件夹。请输入完整文件路径。';

  @override
  String get setupExisting => '配置已保存的空间。';

  @override
  String get recoveryGeneratingQr => '正在创建二维码…';

  @override
  String get recoverySaveQr => '保存二维码';

  @override
  String get recoveryOverwriteQr => '替换现有二维码恢复卡文件？';

  @override
  String get serverSearch => '查找空间';

  @override
  String get serverFilterAll => '全部';

  @override
  String get serverNoEvents => '暂无已加载消息';

  @override
  String get serverOffline => '离线';

  @override
  String get removeServer => '从应用移除';

  @override
  String get removeServerConfirm => '此设备上的历史将被删除。以后可以重新添加服务器。';

  @override
  String get serverAccessRemoved => '访问已撤销，服务器已移除。';

  @override
  String get serverRemoveFailed => '无法移除服务器。请重试。';

  @override
  String get serverInAir => '服务器在线';

  @override
  String get serverNoChannels => '暂无可用频道';

  @override
  String get spacesTitle => '空间';

  @override
  String get updatesTitle => '更新';

  @override
  String get updatesCheck => '检查更新';

  @override
  String get updatesChecking => '正在检查…';

  @override
  String get updatesCurrent => '已是最新版本';

  @override
  String updatesAvailable(String version) {
    return '版本 $version 可用';
  }

  @override
  String get updatesEmpty => '尚无已发布的构建';

  @override
  String get updatesFailed => '无法检查，请重试。';

  @override
  String get updatesOpen => '打开发布页面';

  @override
  String get updatesChanges => '更新内容';

  @override
  String updatesInstalled(String version) {
    return '版本 $version';
  }

  @override
  String get updatesUnknownVersion => '版本不可用';

  @override
  String get updatesOpenFailed => '无法打开发布页面';

  @override
  String get updatesPackageUnavailable => '此系统暂无安装包。';

  @override
  String updatesPackage(String platform, String size) {
    return '$platform · $size MB';
  }

  @override
  String get updatesDownload => '下载';

  @override
  String get updatesDownloadFailed => '下载失败，请重试。';

  @override
  String get updatesDownloaded => '安装包已下载并验证。';

  @override
  String get updatesInstall => '安装并重启';

  @override
  String get updatesPreparing => '正在完成操作并停止家庭服务器…';

  @override
  String get updatesInstallFailed => '无法开始安装。请检查消息发送和家庭服务器状态，然后重试。';

  @override
  String get updatesHomeTitle => '直播';

  @override
  String get updatesHomeResume => '更新前家庭服务器正在运行。是否重新启动？';

  @override
  String get updatesLater => '稍后';

  @override
  String get updatesHomeStart => '启动';

  @override
  String get addFavorite => '添加到收藏';

  @override
  String get removeFavorite => '取消收藏';

  @override
  String get favoriteMessages => '收藏消息';

  @override
  String get failureConnectRequired => '服务器需要支持 ConnectRPC。请更新家庭运行环境或联系空间所有者。';

  @override
  String get spaceQrCamera => '扫描二维码';

  @override
  String get spaceQrImage => '选择二维码图片';

  @override
  String get spaceQrInvalid => '无法读取包含空间链接的二维码。';

  @override
  String get homeExport => '导出空间';

  @override
  String get homeImport => '导入空间';

  @override
  String get homeTransferHelp =>
      '存档包含消息、设置和服务器密钥。请保密并仅导入您自己的存档。导出期间服务器会停止，导入不会覆盖现有空间。更改 IP 会保留空间身份和 TLS 指纹。在新电脑上需单独恢复所有者恢复卡。';

  @override
  String get homeImportIP => '新的公网 IPv4（留空保留原地址）';

  @override
  String get homeExported => '空间已导出';

  @override
  String get homeImported => '空间已导入，现在可以启动服务器。';

  @override
  String get homeTransferring => '正在迁移空间';

  @override
  String get homeTransferFailed => '无法打开存档或完成迁移。';

  @override
  String get glassEffects => '玻璃效果';

  @override
  String get glassEffectsHelp => '模糊浮动面板和标题。';

  @override
  String get attachFiles => '添加文件';

  @override
  String get myFiles => '我的文件';

  @override
  String get removeFile => '移除文件';

  @override
  String get cancelUpload => '取消';

  @override
  String get downloadFile => '下载文件';

  @override
  String get downloadFailed => '无法下载文件';

  @override
  String get noFilesInChannel => '此频道暂无您上传的文件';

  @override
  String get loadMoreFiles => '加载更多';

  @override
  String get closeFiles => '关闭';

  @override
  String get dropFilesHere => '松开文件以添加附件';

  @override
  String get optionalNickname => '名字（可选）';

  @override
  String get channelFiles => '聊天附件';

  @override
  String get allFileAuthors => '所有成员';

  @override
  String get refreshFiles => '刷新附件';

  @override
  String get filesLoadFailed => '无法加载附件，请尝试刷新列表。';

  @override
  String get filesServerUpdateRequired => '请更新服务器以使用附件列表。';

  @override
  String get serverNickname => '您在此空间中的名字';

  @override
  String get nicknameUniqueHelp => '名字在此服务器上必须唯一，不区分大小写。留空可移除名字。';

  @override
  String get saveNickname => '保存名字';

  @override
  String get nicknameSaved => '名字已保存';

  @override
  String get nicknameTaken => '此名字已被使用，请选择其他名字。';

  @override
  String get nicknameInvalid => '请使用最多40个字符，不含换行。';

  @override
  String get nicknameFailed => '无法更新个人资料，请检查连接。';

  @override
  String get retryProfile => '重试';

  @override
  String get messageUnavailable => '消息不可用';

  @override
  String get mlsTitle => '私密频道 · MLS';

  @override
  String get mlsExperimental => '实验性端到端加密';

  @override
  String get mlsCreate => '创建私密频道';

  @override
  String get mlsChannelId => '频道标识';

  @override
  String get mlsChannelTitle => '频道名称';

  @override
  String get mlsDeviceCode => '此设备的验证码';

  @override
  String get mlsDevices => '频道设备';

  @override
  String get mlsVerify => '验证设备';

  @override
  String get mlsTrust => '验证码一致';

  @override
  String get mlsVerifyHint => '请通过独立渠道与另一台设备核对验证码。服务器不能证明密钥可信。';

  @override
  String get mlsInvite => '邀请';

  @override
  String get mlsRemove => '移除设备';

  @override
  String get mlsRetry => '刷新并重试发送';

  @override
  String get mlsWaiting => '此设备尚未获邀或访问已被撤销。请将验证码提供给频道所有者。';

  @override
  String get mlsInput => '有什么新消息？';

  @override
  String get mlsSend => '发送';

  @override
  String get mlsAttach => '添加文件';

  @override
  String get mlsFiles => '频道文件';

  @override
  String get mlsUnavailable => '消息不可用';

  @override
  String get mlsCancel => '取消';

  @override
  String get mlsTransfer => '移交管理权';

  @override
  String get mlsTransferTitle => '移交频道管理权？';

  @override
  String mlsTransferHint(String device) {
    return '设备 $device 将能够邀请和移除成员。你仍可访问消息和文件。';
  }

  @override
  String get homeExternalHost => '外部地址（IPv4、IPv6 或域名）';

  @override
  String get homeExternalPort => '外部端口';

  @override
  String get homeAddAddress => '添加地址';

  @override
  String get homeRemoveAddress => '删除地址';

  @override
  String get homeListenPort => '本地端口';

  @override
  String get homeListenInterfaces => '网络';

  @override
  String get homeNetworkHelp => '外部端口可与本地端口不同。更改将在下次启动服务器时生效。';

  @override
  String get homeSaveAddresses => '保存设置';

  @override
  String get homeNetworkInvalid => '请检查地址和端口（1–65535）。地址不能重复。';

  @override
  String get homeAddressLabel => '地址';

  @override
  String get homePrimaryAddress => '主要地址';

  @override
  String get homeBackupAddress => '备用地址';

  @override
  String get homeConnectionAddresses => '成员连接';

  @override
  String get homeAddressHelp =>
      '请输入域名、IPv4 或 IPv6，不含 https:// 和方括号。主要地址不可用时可使用备用地址。';

  @override
  String get homeLocalSettings => '此计算机';

  @override
  String get homeDiagTitle => '连接诊断';

  @override
  String get homeDiagRun => '检查';

  @override
  String get homeDiagRunning => '正在检查地址…';

  @override
  String get homeDiagWANLabel => '路由器 WAN IP（可选）';

  @override
  String get homeDiagWANHelp => '从路由器状态页面复制；此字段不会保存。';

  @override
  String get homeDiagCopyCommand => '复制用于其他网络的命令';

  @override
  String get homeDiagExternalHelp =>
      '其他网络上的 Space 会自动检查已保存的空间。也可在外部电脑上运行此命令单独检查。使用代理或 VPN 时，结果可能仍无法确认。';

  @override
  String get homeDiagUnsupported => '已安装的 runtime 不支持诊断。请更新服务器。';

  @override
  String get homeDiagFailed => '无法运行诊断。请检查已安装的 runtime 后重试。';

  @override
  String get homeDiagLocalPrefix => '本地检查';

  @override
  String get homeDiagLocalOk => '服务器在本地响应；TLS 和签名有效。';

  @override
  String get homeDiagRouteOk => '此电脑可以访问该地址；TLS 和签名有效。';

  @override
  String get homeDiagUnreachable => '无法连接。请检查服务器是否运行、端口和防火墙。这不能证明存在 CGNAT。';

  @override
  String get homeDiagDNS => '无法解析域名。请检查名称和 DNS 记录。';

  @override
  String get homeDiagCertificateOk => '空间证书有效。';

  @override
  String get homeDiagCertificateMissing => '未找到证书。请启动服务器后重试。';

  @override
  String get homeDiagCertificateExpired => '证书有效期检查失败。请检查系统时间和证书。';

  @override
  String get homeDiagCertificateMismatch => '该地址提供了其他证书。请检查路由，不要替换受信任的指纹。';

  @override
  String get homeDiagDiscovery => '地址有响应，但身份或签名无效。请检查地址和隧道。';

  @override
  String get homeDiagWANUnknown => 'WAN IP 未知，无法判断 CGNAT。可在上方输入路由器 WAN IP。';

  @override
  String get homeDiagWANInvalid => 'WAN IP 无效。请使用路由器状态页面上的地址。';

  @override
  String get homeDiagWANShared =>
      'WAN IP 位于 100.64.0.0/10，这是 CGNAT 的迹象。请向运营商询问公网 IP 或使用 TCP 隧道。';

  @override
  String get homeDiagWANPrivate =>
      'WAN IP 为私有地址，可能存在双重 NAT 或 CGNAT。请检查上级路由器及运营商服务。';

  @override
  String get homeDiagWANPublic => 'WAN IP 不在私有或 CGNAT 地址范围内。这不能确认端口可从外部访问。';

  @override
  String get homeDiagExternal =>
      '尚未从外网确认：没有近期的外部连接。请在其他网络的设备上打开此空间后重试。这不代表服务器不可访问。';

  @override
  String get homeDiagBudget => '诊断已超时；其余地址尚未检查。';

  @override
  String get homeDiagUnknown => '未知结果；请更新应用和 runtime。';

  @override
  String get homeDiagInterface => '监听地址不属于此电脑。请选择本地接口或所有接口。';

  @override
  String get homeDiagIPv6Private =>
      'WAN IPv6 为本地地址，无法提供直接的互联网访问。这不能证明存在 CGNAT。';

  @override
  String get homeDiagNotReady => 'TLS 有响应，但服务器尚未就绪（HTTP 503）。请完成初始设置或等待启动。';

  @override
  String get homeDiagObserved => 'HTTPS 入口收到了来自其他公网的请求。此确认仅对应所示时间和地址。';

  @override
  String homeDiagObservedAt(String time) {
    return '最近的外部连接：$time';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get updatesPackageUnavailable => '此系统暂无安装包。';

  @override
  String updatesPackage(String platform, String size) {
    return '$platform · $size MB';
  }

  @override
  String get addFavorite => '添加到收藏';

  @override
  String get removeFavorite => '取消收藏';

  @override
  String get favoriteMessages => '收藏消息';

  @override
  String get failureConnectRequired => '服务器需要支持 ConnectRPC。请更新家庭运行环境或联系空间所有者。';

  @override
  String get spaceQrCamera => '扫描二维码';

  @override
  String get spaceQrImage => '选择二维码图片';

  @override
  String get spaceQrInvalid => '无法读取包含空间链接的二维码。';

  @override
  String get homeExport => '导出空间';

  @override
  String get homeImport => '导入空间';

  @override
  String get homeTransferHelp =>
      '存档包含消息、设置和服务器密钥。请保密并仅导入您自己的存档。导出期间服务器会停止，导入不会覆盖现有空间。更改 IP 会保留空间身份和 TLS 指纹。在新电脑上需单独恢复所有者恢复卡。';

  @override
  String get homeImportIP => '新的公网 IPv4（留空保留原地址）';

  @override
  String get homeExported => '空间已导出';

  @override
  String get homeImported => '空间已导入，现在可以启动服务器。';

  @override
  String get homeTransferring => '正在迁移空间';

  @override
  String get homeTransferFailed => '无法打开存档或完成迁移。';

  @override
  String get glassEffects => '玻璃效果';

  @override
  String get glassEffectsHelp => '模糊浮动面板和标题。';

  @override
  String get mlsTitle => '私密频道 · MLS';

  @override
  String get mlsExperimental => '实验性端到端加密';

  @override
  String get mlsCreate => '创建私密频道';

  @override
  String get mlsChannelId => '频道标识';

  @override
  String get mlsChannelTitle => '频道名称';

  @override
  String get mlsDeviceCode => '此设备的验证码';

  @override
  String get mlsDevices => '频道设备';

  @override
  String get mlsVerify => '验证设备';

  @override
  String get mlsTrust => '验证码一致';

  @override
  String get mlsVerifyHint => '请通过独立渠道与另一台设备核对验证码。服务器不能证明密钥可信。';

  @override
  String get mlsInvite => '邀请';

  @override
  String get mlsRemove => '移除设备';

  @override
  String get mlsRetry => '刷新并重试发送';

  @override
  String get mlsWaiting => '此设备尚未获邀或访问已被撤销。请将验证码提供给频道所有者。';

  @override
  String get mlsInput => '有什么新消息？';

  @override
  String get mlsSend => '发送';

  @override
  String get mlsAttach => '添加文件';

  @override
  String get mlsFiles => '频道文件';

  @override
  String get mlsUnavailable => '消息不可用';

  @override
  String get mlsCancel => '取消';

  @override
  String get mlsTransfer => '移交管理权';

  @override
  String get mlsTransferTitle => '移交频道管理权？';

  @override
  String mlsTransferHint(String device) {
    return '设备 $device 将能够邀请和移除成员。你仍可访问消息和文件。';
  }

  @override
  String get homeExternalHost => '外部地址（IPv4、IPv6 或域名）';

  @override
  String get homeExternalPort => '外部端口';

  @override
  String get homeAddAddress => '添加地址';

  @override
  String get homeRemoveAddress => '删除地址';

  @override
  String get homeListenPort => '本地端口';

  @override
  String get homeListenInterfaces => '网络';

  @override
  String get homeNetworkHelp => '外部端口可与本地端口不同。更改将在下次启动服务器时生效。';

  @override
  String get homeSaveAddresses => '保存设置';

  @override
  String get homeNetworkInvalid => '请检查地址和端口（1–65535）。地址不能重复。';

  @override
  String get homeAddressLabel => '地址';

  @override
  String get homePrimaryAddress => '主要地址';

  @override
  String get homeBackupAddress => '备用地址';

  @override
  String get homeConnectionAddresses => '成员连接';

  @override
  String get homeAddressHelp =>
      '请输入域名、IPv4 或 IPv6，不含 https:// 和方括号。主要地址不可用时可使用备用地址。';

  @override
  String get homeLocalSettings => '此计算机';

  @override
  String get homeDiagTitle => '连接诊断';

  @override
  String get homeDiagRun => '检查';

  @override
  String get homeDiagRunning => '正在检查地址…';

  @override
  String get homeDiagWANLabel => '路由器 WAN IP（可选）';

  @override
  String get homeDiagWANHelp => '从路由器状态页面复制；此字段不会保存。';

  @override
  String get homeDiagCopyCommand => '复制用于其他网络的命令';

  @override
  String get homeDiagExternalHelp =>
      '其他网络上的 Space 会自动检查已保存的空间。也可在外部电脑上运行此命令单独检查。使用代理或 VPN 时，结果可能仍无法确认。';

  @override
  String get homeDiagUnsupported => '已安装的 runtime 不支持诊断。请更新服务器。';

  @override
  String get homeDiagFailed => '无法运行诊断。请检查已安装的 runtime 后重试。';

  @override
  String get homeDiagLocalPrefix => '本地检查';

  @override
  String get homeDiagLocalOk => '服务器在本地响应；TLS 和签名有效。';

  @override
  String get homeDiagRouteOk => '此电脑可以访问该地址；TLS 和签名有效。';

  @override
  String get homeDiagUnreachable => '无法连接。请检查服务器是否运行、端口和防火墙。这不能证明存在 CGNAT。';

  @override
  String get homeDiagDNS => '无法解析域名。请检查名称和 DNS 记录。';

  @override
  String get homeDiagCertificateOk => '空间证书有效。';

  @override
  String get homeDiagCertificateMissing => '未找到证书。请启动服务器后重试。';

  @override
  String get homeDiagCertificateExpired => '证书有效期检查失败。请检查系统时间和证书。';

  @override
  String get homeDiagCertificateMismatch => '该地址提供了其他证书。请检查路由，不要替换受信任的指纹。';

  @override
  String get homeDiagDiscovery => '地址有响应，但身份或签名无效。请检查地址和隧道。';

  @override
  String get homeDiagWANUnknown => 'WAN IP 未知，无法判断 CGNAT。可在上方输入路由器 WAN IP。';

  @override
  String get homeDiagWANInvalid => 'WAN IP 无效。请使用路由器状态页面上的地址。';

  @override
  String get homeDiagWANShared =>
      'WAN IP 位于 100.64.0.0/10，这是 CGNAT 的迹象。请向运营商询问公网 IP 或使用 TCP 隧道。';

  @override
  String get homeDiagWANPrivate =>
      'WAN IP 为私有地址，可能存在双重 NAT 或 CGNAT。请检查上级路由器及运营商服务。';

  @override
  String get homeDiagWANPublic => 'WAN IP 不在私有或 CGNAT 地址范围内。这不能确认端口可从外部访问。';

  @override
  String get homeDiagExternal =>
      '尚未从外网确认：没有近期的外部连接。请在其他网络的设备上打开此空间后重试。这不代表服务器不可访问。';

  @override
  String get homeDiagBudget => '诊断已超时；其余地址尚未检查。';

  @override
  String get homeDiagUnknown => '未知结果；请更新应用和 runtime。';

  @override
  String get homeDiagInterface => '监听地址不属于此电脑。请选择本地接口或所有接口。';

  @override
  String get homeDiagIPv6Private =>
      'WAN IPv6 为本地地址，无法提供直接的互联网访问。这不能证明存在 CGNAT。';

  @override
  String get homeDiagNotReady => 'TLS 有响应，但服务器尚未就绪（HTTP 503）。请完成初始设置或等待启动。';

  @override
  String get homeDiagObserved => 'HTTPS 入口收到了来自其他公网的请求。此确认仅对应所示时间和地址。';

  @override
  String homeDiagObservedAt(String time) {
    return '最近的外部连接：$time';
  }
}
