// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get voiceShortcutTitle => '按键通话快捷键';

  @override
  String get voiceShortcutScope => '仅在活动窗口中生效。失去焦点时停止传输。';

  @override
  String get voiceShortcutPress =>
      '按下一个键或与 Ctrl、Alt、Shift、Meta 组合。保存前松开所有键。Escape 取消。';

  @override
  String get voiceShortcutSave => '保存';

  @override
  String get deviceTransferTitle => '迁移设备';

  @override
  String get deviceTransferHelp =>
      '只需两步：保存一个加密归档，然后在新设备上将其拖入此处。空间、密钥、历史、队列、草稿、设置和家庭服务器一起迁移。';

  @override
  String get deviceTransferExport => '完整迁移';

  @override
  String get deviceTransferExportHelp => '将整个设备保存到一个文件';

  @override
  String get deviceTransferRestore => '完整恢复';

  @override
  String get deviceTransferRestoreHelp => '将归档拖入此处或点击选择文件';

  @override
  String get deviceTransferOneFile => '请拖入一个完整设备迁移文件。';

  @override
  String get deviceTransferPasswordHelp =>
      '归档密码可以任意设置，也可以留空。归档验证后会停止原设备的所有空间和家庭服务器。请将归档和密码保存在系统磁盘之外。恢复到全新安装后重新启动应用。请勿将同一归档恢复到多台设备。继续通信后，下次迁移需要创建新归档。';

  @override
  String get deviceTransferFinished => '请保存归档和密码。关闭应用，恢复后重新打开。请勿在原设备上继续通信。';

  @override
  String get deviceTransferClose => '关闭应用';

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
  String get rooms => '语音房间';

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
  String get channels => '聊天';

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
  String get independentServer => '聊天和访问权限由此服务器管理。';

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
  String get closeNavigation => '关闭导航';

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
  String get welcomeDescription => '服务器聊天和资源。';

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
  String get attentionDescription => '可以在应用设置中启用通知。摄像头和麦克风仅在您操作时开启。';

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
  String get feedTitle => '空间动态';

  @override
  String get feedDescription => '此空间的新闻和成员发布。';

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
  String get channel => '聊天';

  @override
  String get noReading => '无阅读权限';

  @override
  String get refreshChat => '刷新聊天和聊天';

  @override
  String get noMessageAccess => '无法访问消息';

  @override
  String get startConversation => '开始交流';

  @override
  String get conversationStarts => '交流从这里开始';

  @override
  String get contactOwner => '请选择其他聊天或联系空间所有者。';

  @override
  String get emptyChat => '此聊天中还没有消息。';

  @override
  String get connectChatHelp => '连接你的空间。密钥会保留在此设备上。';

  @override
  String get you => '你';

  @override
  String get newMessages => '新消息';

  @override
  String get cannotSend => '无法在此聊天发送消息';

  @override
  String get messageHint => '';

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
  String get dashboardDescription => '服务器、聊天和未读消息。';

  @override
  String get dashboardServers => '服务器';

  @override
  String get dashboardOnline => '在线';

  @override
  String get dashboardChannels => '可访问聊天';

  @override
  String get dashboardUnread => '未读消息';

  @override
  String get dashboardRefresh => '刷新总览';

  @override
  String get dashboardEmpty => '添加您的首个空间';

  @override
  String get dashboardEmptyHelp => '添加服务器或创建自己的服务器。';

  @override
  String get dashboardCatalogUnknown => '连接后加载聊天。';

  @override
  String get dashboardAvailable => '可用';

  @override
  String get dashboardUnavailable => '不可用';

  @override
  String get dashboardOpen => '打开空间';

  @override
  String get dashboardResourcesHelp => '总览包含您可访问的聊天和未读消息。无法访问的服务器重新连接后，其数据将显示。';

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
  String get failureChannelChanged => '聊天权限已更改。请刷新聊天后重试。';

  @override
  String get failureChannelUnavailable => '此聊天的访问权限已更改。请选择可访问的聊天。';

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
  String get messageUnconfirmed => '未收到服务器确认，请求已保存在队列中。';

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
  String get serverNoChannels => '暂无可用聊天';

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
  String get noFilesInChannel => '此聊天暂无您上传的文件';

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
  String get mlsTitle => '私密聊天 · MLS';

  @override
  String get mlsExperimental => '实验性端到端加密';

  @override
  String get mlsCreate => '创建私密聊天';

  @override
  String get mlsChannelId => '聊天标识';

  @override
  String get mlsChannelTitle => '聊天名称';

  @override
  String get mlsDeviceCode => '此设备的验证码';

  @override
  String get mlsDevices => '聊天设备';

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
  String get mlsWaiting => '此设备尚未获邀或访问已被撤销。请将验证码提供给聊天所有者。';

  @override
  String get mlsInput => '';

  @override
  String get mlsSend => '发送';

  @override
  String get mlsAttach => '添加文件';

  @override
  String get mlsFiles => '聊天文件';

  @override
  String get mlsUnavailable => '消息不可用';

  @override
  String get mlsCancel => '取消';

  @override
  String get mlsTransfer => '移交管理权';

  @override
  String get mlsTransferTitle => '移交聊天管理权？';

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

  @override
  String get initialServerSetupTitle => '首次登录空间';

  @override
  String get initialServerSetupHelp => '你将成为此空间的所有者，并可将其他成员设为管理员。此设置链接只能使用一次。';

  @override
  String get homeAutoPortMapping => '自动端口映射';

  @override
  String get homeAutoPortMappingHelp =>
      '通过 PCP、NAT-PMP 或 UPnP 创建临时 TCP 映射，停止时删除；无法绕过 CGNAT。';

  @override
  String get homeAutoPublicIP => '更新公网 IP';

  @override
  String get homeAutoPublicIPHelp => '用于首个 IPv4 地址。通过路由器或 ipify 检查；保留域名及其他地址。';

  @override
  String get homeDiagMappingOk => '路由器已确认临时 TCP 映射，尚未验证外网可达性。';

  @override
  String get homeDiagMappingFailed => '无法创建或续期映射。请检查路由器设置；CGNAT 需要公网地址或隧道。';

  @override
  String get homeDiagAutomaticIPFailed => '无法更新公网 IPv4 地址，请检查网络连接。';

  @override
  String get emojiPicker => '表情';

  @override
  String get emojiSearch => '搜索表情';

  @override
  String get emojiRecent => '最近使用';

  @override
  String get emojiAll => '全部';

  @override
  String get addReaction => '添加回应';

  @override
  String get reactionParticipants => '回应者';

  @override
  String get copyMessage => '复制';

  @override
  String get messageCopied => '已复制';

  @override
  String get emojiFaces => '表情与情感';

  @override
  String get emojiPeople => '人物与手势';

  @override
  String get emojiNature => '动物与自然';

  @override
  String get emojiFood => '食物与饮料';

  @override
  String get emojiTravel => '旅行与地点';

  @override
  String get emojiActivities => '活动';

  @override
  String get emojiObjects => '物品';

  @override
  String get emojiSymbols => '符号';

  @override
  String get emojiFlags => '旗帜';

  @override
  String get messageQueued => '消息已保存在此设备的队列中';

  @override
  String get outboxTitle => '发送队列';

  @override
  String get outboxWaiting => '等待发送';

  @override
  String get outboxBlocked => '发送已停止';

  @override
  String get outboxUnavailable => '无法读取或保存队列。文本仍保留在输入框中。';

  @override
  String get outboxRetry => '重新发送';

  @override
  String get outboxDiscard => '从队列移除';

  @override
  String get outboxDiscardDescription => '消息可能已到达服务器。从队列移除只会停止重试，不会删除其他成员的消息。';

  @override
  String get outboxFileMessage => '含附件的消息';

  @override
  String get outboxIdentityChanged => '设备授权已更改。原队列已保留，禁止从新设备自动发送。';

  @override
  String get outboxFull => '队列已满：最多100条消息和1 MiB。请等待发送或移除不需要的消息。';

  @override
  String get outboxFileLimit => '每个空间和设备的待发送附件最多占用 200 MiB。请等待发送完成或移除不需要的消息。';

  @override
  String get outboxRecover => '恢复以前的发送队列';

  @override
  String get outboxRecoverDescription =>
      '这些消息仍保存在此计算机上，属于以前的设备授权。请先检查消息再恢复。请求密钥保持不变，已接收的消息不会重复。';

  @override
  String get outboxRecoverTrust => '我信任当前设备，并允许它以我的身份发送这些消息。';

  @override
  String get outboxRecoverSend => '恢复并发送';

  @override
  String get outboxRecoverFailed => '无法完成恢复。队列已保留，请检查连接后重试。';

  @override
  String get outboxEdit => '编辑消息';

  @override
  String get outboxDelete => '删除消息';

  @override
  String get outboxReactionAdd => '添加回应';

  @override
  String get outboxReactionRemove => '移除回应';

  @override
  String get outboxMutationBlocked =>
      '更改已停止。请检查权限、runtime 版本和消息的最新状态。如有冲突，请移除此排队操作后重新执行。';

  @override
  String get outboxDiscardMutationDescription =>
      '服务器可能已执行此操作。移出队列只会停止本地重试，不会撤销已执行的操作。依赖的操作将停止。';

  @override
  String get replyMessage => '回复';

  @override
  String get cancelReply => '取消回复';

  @override
  String get replyUnavailable => '原消息不可用';

  @override
  String get notifications => '通知';

  @override
  String get notificationsOff => '关闭';

  @override
  String get notificationsPrivate => '隐藏内容';

  @override
  String get notificationsPreview => '显示消息文本';

  @override
  String get notificationsDescription =>
      '桌面端：应用运行时接收已连接空间的普通聊天和已加入的加密聊天通知。预览会将文本传给操作系统。暂不支持退出应用后的通知。';

  @override
  String get notificationPermissionError => '无法启用通知。请检查系统设置。';

  @override
  String get newMessageNotification => '新消息';

  @override
  String get messageSearchServer => '搜索当前聊天历史记录';

  @override
  String get messageSearchLocal => '仅在此设备搜索 · MLS';

  @override
  String get messageSearchFailed => '搜索失败。重试';

  @override
  String get messageSearchMore => '更多消息';

  @override
  String get messageSearchLimit => '显示前 200 条结果。请缩小搜索范围。';

  @override
  String get loadOlderMessages => '加载更早的消息';

  @override
  String get historyPageFailed => '无法加载历史记录。请重试。';

  @override
  String get messageSearchAllChannels => '所有可用聊天';

  @override
  String get messageSearchMixed => '私密聊天仅在此设备上搜索';

  @override
  String get savedMlsSearchChannels => '已保存的私密聊天';

  @override
  String get savedMlsMessagePreview => '已保存的消息 · 离线';

  @override
  String get homeArchiveVerified => '备份已验证';

  @override
  String homeArchiveSummary(
    String serverId,
    int schema,
    int files,
    String size,
  ) {
    return '空间：$serverId\n数据版本：$schema\n备份文件数：$files\n解压后大小：$size MiB';
  }

  @override
  String get homeArchiveReviewHelp =>
      '已验证文件和校验和。这不能证明来源可信，请仅恢复自己的备份。尚未开始恢复。所有者密钥和设备的 MLS 历史需单独恢复。';

  @override
  String get homeArchiveRestore => '开始恢复';

  @override
  String get homeArchiveUnsupported => '此运行时尚不支持备份验证。需要支持验证的兼容应用和运行时版本；尚未开始恢复。';

  @override
  String get homeArchiveCheckFailed => '无法验证备份。文件可能已损坏或与运行时不兼容。尚未开始恢复。';

  @override
  String get homeDiskTitle => '磁盘和备份';

  @override
  String get homeDiskPolicy =>
      '运行时和更新备份的手动清理：清理会保留当前和上一版运行时、最新的三个已验证备份以及当前恢复备份。其他备份仅在30天后列为候选。不会删除家庭服务器之外的文件。';

  @override
  String get homeDiskScan => '查看大小 / 刷新';

  @override
  String get homeDiskClean => '删除所选';

  @override
  String get homeDiskConfirm => '所选文件夹将永久删除。空间数据、受保护的备份和外部ZIP存档会保留。是否继续？';

  @override
  String get homeDiskFailed => '无法完成检查或清理。状态可能已更改，请刷新列表。链接和未完成的恢复会阻止清理。';

  @override
  String get homeDiskData => '空间数据';

  @override
  String get homeDiskRuntimes => '服务器版本';

  @override
  String get homeDiskBackups => '备份';

  @override
  String get homeDiskRecoveries => '恢复数据';

  @override
  String get homeDiskFree => '服务器磁盘可用空间';

  @override
  String get homeDiskEstimate => '大小为估计值，服务器运行时可能变化。清理会再次检查所选文件。';

  @override
  String get homeDiskNothing => '没有可安全删除的旧文件夹。';

  @override
  String get homeDiskStop => '清理前请先停止服务器。';

  @override
  String get homeBackupTitle => '定时备份';

  @override
  String get homeBackupHelp =>
      '运行中的运行时会备份而不中断聊天。停机后创建一个最新备份。更改在一分钟内生效，正在运行的任务可能按原设置完成。';

  @override
  String get homeBackupUnsupported => '请安装或更新运行时以使用定时备份。';

  @override
  String get homeBackupEnabled => '启用定时备份';

  @override
  String get homeBackupInterval => '间隔（小时）';

  @override
  String get homeBackupPrune => '自动删除旧备份';

  @override
  String get homeBackupCount => '备份数量（3–100）';

  @override
  String get homeBackupDays => '保留天数（1–3650）';

  @override
  String get homeBackupQuota => '上限，MiB（0为不限）';

  @override
  String get homeBackupRetention =>
      '启用自动清理后，任一超限条件都会生效。即使超出容量上限，也保留最新三个已验证备份。未知、损坏和不兼容文件不会删除。';

  @override
  String get homeBackupSave => '保存设置';

  @override
  String get homeBackupConfigure => '设置备份';

  @override
  String get homeBackupRefresh => '刷新状态';

  @override
  String get homeBackupFailed => '备份或清理未完成。请检查设置、磁盘空间和访问权限。至少五分钟后重试。';

  @override
  String get homeBackupLast => '上次成功备份';

  @override
  String get homeBackupNext => '下次检查';

  @override
  String get homeBackupProtected => '部分文件受到保护，或容量上限无法容纳三个备份。';

  @override
  String get homeBackupOff => '定时备份已关闭';

  @override
  String get homeBackupRunning => '正在创建备份…';

  @override
  String get homeBackupOK => '上次操作已完成';

  @override
  String get homeBackupSpace => '无法确认有足够空间创建新备份。';

  @override
  String get homeBackupWaiting => '等待运行时运行并到达备份时间';

  @override
  String get voiceTitle => '语音房间';

  @override
  String get voiceDescription => '无摄像头的语音交流。只有您主动操作时才会启用麦克风。';

  @override
  String get voiceCreate => '创建房间';

  @override
  String get voiceName => '房间名称';

  @override
  String get voiceJoin => '加入';

  @override
  String get voiceLeave => '退出语音';

  @override
  String get voiceMicrophoneOn => '开启麦克风';

  @override
  String get voiceMicrophoneOff => '关闭麦克风';

  @override
  String get voiceSoundOn => '开启声音';

  @override
  String get voiceSoundOff => '关闭声音';

  @override
  String get voiceJoining => '连接中…';

  @override
  String get voiceReconnecting => '正在重新连接。麦克风已关闭。';

  @override
  String get voiceConnected => '通话中';

  @override
  String get voiceParticipants => '参与者';

  @override
  String get voiceMuted => '麦克风已关闭';

  @override
  String get voiceSpeaking => '正在说话';

  @override
  String get voiceDeafened => '声音已关闭';

  @override
  String get voiceEmpty => '还没有语音房间。所有者或管理员可以创建第一个房间。';

  @override
  String get voiceConnectFirst => '请先连接空间以打开语音房间。';

  @override
  String get voiceLimit => '每个房间最多八位参与者。通过互联网连接时，由所有者配置 STUN/TURN，应用会自动获取设置。';

  @override
  String get voiceDesktopOnly => '语音房间目前仅支持桌面端。';

  @override
  String get voicePrivacy => '不录音、不使用摄像头。音频经过空间服务器，并非参与者之间的 MLS 加密。';

  @override
  String get voiceFailure => '无法继续通话';

  @override
  String get voiceCancel => '取消';

  @override
  String get voiceSave => '创建';

  @override
  String get voiceUpdateRuntime => '语音房间需要支持语音的新运行时。请在“广播”中更新服务器。';

  @override
  String get voiceDeviceUnavailable => '所选音频设备已断开。请重新连接或选择其他设备，然后手动开启麦克风或声音。';

  @override
  String get voiceDeviceDisconnected => '设备已断开';

  @override
  String get voiceAudioDevices => '音频设备';

  @override
  String get voiceSettingsTitle => '语音';

  @override
  String get voiceInputVolume => '麦克风音量';

  @override
  String get voiceOutputVolume => '输出音量';

  @override
  String get voiceProcessingTitle => '音频处理';

  @override
  String get voiceInputProfile => '麦克风模式';

  @override
  String get voiceProfileSpeech => '对话';

  @override
  String get voiceProfileStudio => '录音室 — 无处理';

  @override
  String get voiceProfileCustom => '自定义';

  @override
  String get voiceNoiseSuppression => '降噪';

  @override
  String get voiceEchoCancellation => '回声消除';

  @override
  String get voiceAutoGain => '自动增益控制';

  @override
  String get voiceProcessingHint => '更改处理设置会关闭麦克风。请重新开启以应用设置。录音室模式建议使用耳机。';

  @override
  String get voiceTestMicrophone => '测试麦克风';

  @override
  String get voiceStopMicrophoneTest => '停止测试';

  @override
  String get voiceMicrophoneLevel => '麦克风电平';

  @override
  String get voiceMicrophoneTestHint =>
      '您将听到自己的声音。测试仅在本地运行，最长60秒，不会向房间发送音频。房间声音将关闭。关闭设置会停止测试。';

  @override
  String get voiceDevicesDescription => '选择麦克风和声音输出设备。加入房间前或通话期间均可更改。';

  @override
  String get voiceDevicesRemembered => '选择会保存在此电脑上。加入房间和恢复设置不会自动开启麦克风。';

  @override
  String get voiceInputDevice => '麦克风';

  @override
  String get voiceOutputDevice => '声音输出';

  @override
  String get voiceCurrentDevice => '当前系统设备';

  @override
  String get voiceRefreshDevices => '刷新设备';

  @override
  String get voiceCloseDevices => '关闭';

  @override
  String get voicePushToTalk => '按键说话';

  @override
  String get voicePushToTalkHint =>
      '先在房间中开启麦克风，再按住选定的快捷键说话。仅在窗口获得焦点时有效。麦克风测试连续播放。';

  @override
  String get voiceAutomaticSensitivity => '自动输入灵敏度';

  @override
  String get voiceSensitivity => '输入阈值';

  @override
  String get recoveryIncludeSpaces => '包含空间';

  @override
  String get recoveryIncludeSpacesHint =>
      '创建第二个二维码，包含已保存的空间及其恢复密钥，不包含 MLS 密钥和历史记录。';

  @override
  String get recoveryAccessQr => '所选身份访问恢复';

  @override
  String get recoverySpacesQr => '空间与访问';

  @override
  String get recoverySpacesUseFile => '内容过大，无法放入一个二维码，请保存加密文件。';

  @override
  String get recoverySaveSpacesQr => '保存空间二维码';

  @override
  String get recoverySaveSpacesFile => '将空间保存到文件';

  @override
  String recoverySpacesResult(int restored, int total) {
    return '已添加空间：$restored。集合总数：$total。现有密钥保持不变。失败的空间可重新导入。';
  }

  @override
  String get migrationTitle => '完整迁移空间';

  @override
  String get migrationExportHelp =>
      '归档包含服务器、设备密钥、当前 MLS 状态和加密聊天本地历史。保存后，此客户端将停止使用该空间。请将归档保存在其他磁盘并记住密码。如果操作中断，请检查 .pending 文件，其中可能包含完整迁移。 验证归档后，系统存储中旧设备的工作密钥将被迁移标记替换。';

  @override
  String get migrationImportHelp =>
      '恢复后将继续使用原设备身份。此归档只能用于一台新设备。旧服务器必须停止。现有密钥不会被替换。';

  @override
  String get migrationPassword => '归档密码';

  @override
  String get migrationPasswordRepeat => '再次输入密码';

  @override
  String get migrationExported => '迁移已保存，旧设备已停止。重装系统前请保管归档和密码。';

  @override
  String get voiceRefreshRooms => '刷新房间列表';

  @override
  String get voiceRouteDirect => '直接连接';

  @override
  String get voiceRouteRelay => '通过 TURN';

  @override
  String get voiceRouteUnknown => '连接路径尚未知';

  @override
  String voiceRoundTrip(int milliseconds) {
    return '往返延迟：$milliseconds 毫秒';
  }

  @override
  String get voiceProfileSpeechHelp => '降噪、回声消除、自动增益控制和高通滤波。';

  @override
  String get voiceProfileStudioHelp => '不处理麦克风音频。适合音乐和已处理的输入；请使用耳机。';

  @override
  String get voiceProfileCustomHelp => '单独调整各项音频处理设置。';

  @override
  String get voiceActivity => '语音激活';

  @override
  String get voiceActivityHelp => '手动开启麦克风后，超过阈值才会发送。噪声也可能触发，请调整灵敏度。';

  @override
  String get voiceNoiseSuppressionHelp =>
      'DeepFilterNet3 使用神经网络降噪。WebRTC 的资源占用更低。音频在本机处理。';

  @override
  String get voiceNoiseWebRtc => 'WebRTC';

  @override
  String get voiceNoiseOff => '关闭';

  @override
  String get voiceAdvancedSettings => '高级语音设置';

  @override
  String get voiceHighPass => '低频噪声滤波';

  @override
  String get voiceAdvancedActivation => '稳定语音激活';

  @override
  String get voiceAdvancedActivationHelp => '在阈值附近保持发送，避免切断轻声词尾。依据音量判断，并非语音识别。';

  @override
  String voiceReleaseDelay(int milliseconds) {
    return '停止发送延迟：$milliseconds 毫秒';
  }

  @override
  String get voiceRoomEmpty => '房间里暂时没有人';

  @override
  String get voiceMicrophoneEnabled => '麦克风已开启';

  @override
  String get voiceActivityUpdateRuntime => '请更新空间运行时以突出显示正在说话的参与者。';

  @override
  String get voiceHoldToTalk => '按住说话';

  @override
  String get voiceTouchToTalkHint => '在房间中开启麦克风，然后按住通话按钮。应用进入后台时会松开按钮。';

  @override
  String get voiceAndroidNoiseHelp =>
      '默认启用 DeepFilterNet3。WebRTC 是负载较低的选项，也可以关闭处理。音频在手机上处理。';

  @override
  String get forumConnectFirst => '连接空间以打开论坛。';

  @override
  String get forumUpdateRuntime => '论坛需要支持 core.forum.v1 的运行时。请在广播中更新服务器。';

  @override
  String get forumPrivacy => '论坛消息存储在服务器上，未端到端加密。访问由版块权限控制。';

  @override
  String get forumSections => '论坛版块';

  @override
  String get forumManage => '版块与权限';

  @override
  String get forumEmptySections => '没有可用的论坛版块。管理员可以创建版块并分配权限。';

  @override
  String get forumRefresh => '刷新';

  @override
  String get forumNewTopic => '创建主题';

  @override
  String get forumTopicTitle => '主题标题';

  @override
  String get forumText => '消息';

  @override
  String get forumSend => '发送';

  @override
  String get forumReply => '回复';

  @override
  String get forumClosed => '主题已关闭，无法添加新回复。';

  @override
  String get forumClose => '关闭主题';

  @override
  String get forumCloseConfirm => '关闭此主题？所有成员将无法添加新回复。';

  @override
  String get forumCancel => '取消';

  @override
  String get forumBack => '返回主题';

  @override
  String get forumMore => '加载更多';

  @override
  String get forumEmptyTopics => '此版块尚无主题。';

  @override
  String get forumReadOnly => '您可以阅读此版块。发布需要写入权限。';

  @override
  String get forumInvalidText => '请输入文本或添加附件。标题最多 320 UTF-8 字节。';

  @override
  String get forumConflict => '主题已更改。请刷新后重试。';

  @override
  String get forumDenied => '访问权限已撤销或版块不可用。请刷新论坛。';

  @override
  String get forumFailure => '操作失败。请检查连接后重试。';

  @override
  String get forumWriteUnavailable => '回复未发送：主题已关闭或版块已归档。请刷新论坛。';

  @override
  String get forumListTitle => '讨论';

  @override
  String get forumListDescription => '社区交流';

  @override
  String get forumReplies => '回复';

  @override
  String get forumAboutSection => '关于此版块';

  @override
  String get forumAboutTopic => '关于此主题';

  @override
  String get forumState => '状态';

  @override
  String get forumOpen => '开放';

  @override
  String get forumClosedLabel => '已关闭';

  @override
  String get forumAuthor => '作者';

  @override
  String get forumCreated => '创建时间';

  @override
  String get forumTopicAuthor => '主题作者';

  @override
  String get forumAllTopics => '此版块的所有主题';

  @override
  String get forumActions => '主题操作';

  @override
  String get forumClosedHeading => '主题已关闭';

  @override
  String get forumClosedDescription => '无法添加新回复，仍可阅读此讨论。';

  @override
  String get forumPrivacyShort => '访问由版块权限控制。不支持端到端加密。';

  @override
  String get forumOrder => '按顺序';

  @override
  String get forumPin => '置顶主题';

  @override
  String get forumUnpin => '取消置顶';

  @override
  String get forumPinned => '已置顶';

  @override
  String get forumUnread => '未读';

  @override
  String get forumReadShown => '将已显示消息标为已读';

  @override
  String get forumAuthorizeDevice => '授权此设备管理论坛';

  @override
  String get forumDevicePermissionInfo =>
      '您的根身份将为此设备签署 space.manage 授权。它仅启用已有的管理权限，不授予角色或其他版块访问权。若此设备没有根密钥，请选择您自己的根卡。';

  @override
  String get forumRootPassword => '根卡密码';

  @override
  String get forumFirstUnread => '第一条未读回复';

  @override
  String get forumRepliesFromStart => '从头查看回复';

  @override
  String get forumReopen => '重新开放主题';

  @override
  String get forumHideTopic => '隐藏主题';

  @override
  String get forumRestoreTopic => '恢复主题';

  @override
  String get forumHideReply => '隐藏回复';

  @override
  String get forumRestoreReply => '恢复回复';

  @override
  String get forumHiddenTopic => '主题已被管理员隐藏';

  @override
  String get forumHiddenReply => '回复已被管理员隐藏';

  @override
  String get forumReason => '操作原因';

  @override
  String get forumReasonRequired => '请填写原因，最多 1024 字节';

  @override
  String get forumModerationNotice => '隐藏内容及其文件在恢复前不可访问。原因将保存到管理日志。';

  @override
  String get forumModerationLog => '管理日志';

  @override
  String get forumModerationEmpty => '暂无管理操作';

  @override
  String get forumApply => '确认';

  @override
  String get forumReport => '举报';

  @override
  String get forumReportNotice => '请说明违规原因。举报内容仅供版主审核，不显示举报人。同一内容不会重复举报。';

  @override
  String get forumReportsQueue => '举报队列';

  @override
  String get forumReportsPending => '待处理';

  @override
  String get forumReportsResolved => '已处理';

  @override
  String get forumReportsEmpty => '暂无举报';

  @override
  String get forumReportDismiss => '驳回举报';

  @override
  String get forumReportHide => '隐藏内容';

  @override
  String get forumReportDecisionNotice => '请说明处理原因。决定及原因将保存到审核日志。';

  @override
  String get forumReportOpen => '打开讨论';

  @override
  String get forumReportTopic => '主题举报';

  @override
  String get forumReportReply => '回复举报';

  @override
  String get feedPrivacy => '服务器可读取发布内容，未使用端到端加密。';

  @override
  String get feedSections => '动态分区';

  @override
  String get feedPolicy => '发布和评论权限';

  @override
  String get feedEmptySections => '暂无可用的动态分区。';

  @override
  String get feedEmpty => '暂无发布。';

  @override
  String get feedOpenUnread => '打开未读评论';

  @override
  String get feedReadOnly => '您无权在此分区发布。';

  @override
  String get feedBack => '返回动态';

  @override
  String get feedComments => '评论';

  @override
  String get feedHiddenPost => '此发布已被版主隐藏。';

  @override
  String get feedHiddenComment => '此评论已被版主隐藏。';

  @override
  String get feedRestoreComment => '恢复评论';

  @override
  String get feedRestorePost => '恢复发布';

  @override
  String get feedSendFailed => '发送失败。文本和文件已保留。请检查权限和连接后重试。';

  @override
  String get feedPublishPermission => '发布动态';

  @override
  String get feedCommentPermission => '发表评论';

  @override
  String get feedPolicyHelp =>
      '发布和评论分别授权。没有规则时两者均禁止。个人规则替代角色规则。读者经明确授权可评论，但不可发布。';

  @override
  String get feedPrincipal => '成员标识符（可选，否则使用角色）';

  @override
  String get feedRole => '角色';

  @override
  String get feedAddRule => '添加规则';

  @override
  String get feedRemoveRule => '删除规则';

  @override
  String get feedPost => '发布';

  @override
  String get feedComment => '评论';

  @override
  String get feedOpenPost => '打开发布';

  @override
  String get feedUpdateRuntime => '此服务器尚不支持动态，请在家庭服务器中更新。';

  @override
  String get feedConnectFirst => '连接空间以查看动态。';

  @override
  String get feedConflict => '发布内容或权限已更改，请刷新后重试。';

  @override
  String get feedDenied => '访问权限已撤销或此分区不可用，请刷新动态。';

  @override
  String get feedWriteUnavailable => '此操作不可用：发布已隐藏或分区已归档，请刷新动态。';

  @override
  String get feedInvalidText => '请输入不超过8192个UTF-8字节的文本或附加文件。';

  @override
  String get feedActions => '操作';

  @override
  String get feedMemberRole => '成员';

  @override
  String get feedReaderRole => '读者';

  @override
  String get communitySearchHint => '搜索此分区';

  @override
  String get communitySearchEmpty => '没有匹配结果';

  @override
  String get communitySearchInvalid => '请输入 1–256 字节的 UTF-8 文本';

  @override
  String get communitySearchThread => '主题';

  @override
  String get communitySearchReply => '回复';

  @override
  String get communitySearchPost => '动态';

  @override
  String get communitySearchComment => '评论';

  @override
  String get communitySearchRevoked => '已无法访问此分区';

  @override
  String get dashboardAttention => '需要关注';

  @override
  String get dashboardAttentionEmpty => '暂无需要处理的事项。';

  @override
  String get dashboardChecking => '正在检查更新…';

  @override
  String get dashboardAttentionLimit => '显示部分事项，其余内容可在空间中查看。';

  @override
  String get dashboardConnectionIssue => '连接问题';

  @override
  String get dashboardPendingReports => '待处理举报';

  @override
  String get dashboardRepliesToYou => '您的主题有新回复';

  @override
  String get dashboardCommunityNews => '社区动态';

  @override
  String get dashboardCommunityDescription =>
      '来自可读版块的最新主题与动态。服务器支持阅读记录时，徽标显示未读数量。';

  @override
  String get dashboardCommunityFailed => '部分分区刷新失败，请重试。';

  @override
  String get dashboardCommunityUnsupported => '请更新服务器以启用社区摘要。';

  @override
  String get dashboardCommunityEmpty => '暂无可用的主题或动态。';

  @override
  String get dashboardAttentionUnknown => '部分分区尚未检查。';

  @override
  String get dashboardAttachmentPost => '含附件的动态';

  @override
  String get dashboardCommunityOffline => '连接后将显示不可用空间的动态。';

  @override
  String get communityMention => '提及成员';

  @override
  String get communityMentionQuery => '成员名称或 ID';

  @override
  String get communityMentionFailed => '无法加载成员。请检查访问权限并重试。';

  @override
  String get communityMentionEmpty => '未找到成员';

  @override
  String get dashboardMention => '有人提及您';

  @override
  String get dashboardFeedRepliesToYou => '您的动态有新回复';

  @override
  String get appearanceTheme => '主题';

  @override
  String get appearanceThemeSystem => '跟随系统';

  @override
  String get appearanceThemeLight => '浅色';

  @override
  String get appearanceThemeDark => '深色';

  @override
  String get notificationSection => '分区';

  @override
  String get notificationInboxEmpty => '没有未读通知';

  @override
  String get notificationInboxFailed => '无法更新通知。请检查连接和访问权限。';

  @override
  String get notificationMarkRead => '标记为已查看';

  @override
  String get notificationRefresh => '刷新通知';

  @override
  String get notificationPrevious => '上一页';

  @override
  String get notificationNext => '下一页';

  @override
  String get notificationUnavailable => '没有可访问的分区';

  @override
  String get notificationReply => '回复你的消息';

  @override
  String get notificationOpen => '打开';

  @override
  String get mlsMentionsLegacy => '部分设备尚未确认支持提及。将仅发送姓名，不包含提及标记。';

  @override
  String get mlsCancelRetry => '取消成员变更后的待发送消息';

  @override
  String get profileAvatar => '空间头像';

  @override
  String get chooseAvatar => '选择图片';

  @override
  String get removeAvatar => '移除头像';

  @override
  String get avatarInvalid => '请选择不超过 5 MiB 和 400 万像素的静态 PNG 或 JPEG 图片。';

  @override
  String get profileConflict => '个人资料已在其他设备上更改。请重新加载后保存；您的草稿已保留。';

  @override
  String get profileSaved => '个人资料已保存';

  @override
  String get saveProfile => '保存个人资料';

  @override
  String get profileSpaceHelp => '名称在此空间内唯一。名称和头像适用于所有版块。';

  @override
  String get communityReactionsRetry => '重试请求';

  @override
  String get communityReactionsFailure => '无法更新回应。';

  @override
  String get communityReactionsConflict => '回应已更改。请检查选择后重试。';

  @override
  String get communityReactionsDenied => '回应不可用：权限或分区状态已更改。';

  @override
  String get communityFavorites => '收藏';

  @override
  String get communityFavoriteAdd => '添加到收藏';

  @override
  String get communityFavoriteRemove => '取消收藏';

  @override
  String get communityFavoriteRetry => '无法更新收藏。重试';

  @override
  String get communityFavoritesEmpty => '此分区暂无收藏。';

  @override
  String get spaceSearch => '搜索此空间';

  @override
  String get spaceSearchHint => '搜索聊天、论坛和动态';

  @override
  String get spaceSearchChat => '消息';

  @override
  String get spaceSearchChatMode => '搜索当前聊天与本地 MLS';

  @override
  String get spaceSearchLimit => '显示前 500 条结果。请缩小搜索范围。';

  @override
  String get feedCancelReference => '移除引用';

  @override
  String get feedOpenOriginal => '查看原文';

  @override
  String get feedOriginalUnavailable => '原帖不可用';

  @override
  String get feedReply => '回复';

  @override
  String feedReplyTo(String number) {
    return '回复评论 #$number';
  }

  @override
  String get feedRepost => '转发';

  @override
  String get feedRepostHint => '直接发送以转发，或添加文字以引用。';

  @override
  String get feedShare => '转发或引用';

  @override
  String get followAdd => '关注';

  @override
  String get followingEmpty => '你还没有关注任何人。';

  @override
  String get followingTitle => '关注';

  @override
  String get followRefresh => '刷新关注';

  @override
  String get followRemove => '取消关注';

  @override
  String get followRevoked => '权限或空间已更改。请重新打开动态。';

  @override
  String get followUnavailable => '成员不可用';

  @override
  String get personalFeed => '我的动态';

  @override
  String get personalFeedEmpty => '这里显示你关注的作者在可访问版块中的帖子。在帖子或评论旁关注作者。';

  @override
  String get personalFeedLimit => '显示前500条帖子。刷新以查看新帖子。';

  @override
  String get personalFeedOpen => '打开讨论';

  @override
  String get userExportTitle => '导出我的内容';

  @override
  String get userExportHelp =>
      '将自己的普通消息、主题、帖子和回复导出为 JSON。附件仅包含元数据，不含文件。无 MLS、密钥或令牌。每个时段最多 5000 条、8 MiB。';

  @override
  String get userExportSection => '版块';

  @override
  String get userExportAll => '所有可访问版块';

  @override
  String get userExportAfter => '起始日期（UTC，可选）';

  @override
  String get userExportBefore => '结束日期（UTC，包含当天，可选）';

  @override
  String get userExportPrepare => '准备 JSON';

  @override
  String get userExportSave => '保存 JSON';

  @override
  String get userExportReady => '已准备条目';

  @override
  String get userExportSaved => '导出已保存';

  @override
  String get userExportInvalidPeriod => '请输入有效的 YYYY-MM-DD 日期和时间范围。';

  @override
  String get pairingNetworkError => '无法连接服务器。代码到期前将自动重试。';

  @override
  String get pairingVerificationError => '验证失败。请重新开始配对。';

  @override
  String get pairingQrInvalid => '二维码无效、已过期或属于其他空间。请扫描待连接设备上的新二维码。';

  @override
  String get directoryBackupTitle => '加密目录备份';

  @override
  String get directoryBackupHelp =>
      '备份空间、设置和关注，不含设备密钥和历史记录。密码至少12个字符。访问权限需通过恢复卡或配对恢复。';

  @override
  String get directoryBackupCreate => '创建备份';

  @override
  String get directoryBackupRead => '预览备份';

  @override
  String get directoryBackupApply => '恢复目录';

  @override
  String get directoryBackupSettings => '用备份中的设置替换界面设置';

  @override
  String get directoryBackupFollows => '添加已保存的关注';

  @override
  String get directoryBackupResume => '完成中断的恢复';

  @override
  String get directoryBackupUnverified => '此备份没有本地版本记录，无法确认是否为最新版本。';

  @override
  String get directoryBackupResults => '空间结果（保存时列出不完整的关注快照）：';

  @override
  String get directoryBackupSaved => '备份已保存并验证。请单独保存密码。';

  @override
  String get directoryBackupRestored => '本地恢复已完成。请使用相同身份登录后单独恢复关注。';

  @override
  String get directoryBackupError => '操作未完成。请检查密码、备份完整性和存储访问权限。可继续中断的恢复。';

  @override
  String get directoryBackupConfirm => '应用已验证的目录？访问密钥将保留。将应用所选设置；中断后可继续恢复。';

  @override
  String get directoryBackupFollowsHelp =>
      '为已连接且身份相同的空间添加缺失的关注？将保留现有关注。服务器会检查权限，结果可能不完整。';

  @override
  String directoryBackupPreview(int count) {
    return '备份中的空间数量：$count';
  }

  @override
  String directoryBackupSpaceComplete(String origin, int count) {
    return '$origin：关注 $count 位参与者；快照完整';
  }

  @override
  String directoryBackupSpaceIncomplete(String origin, int count) {
    return '$origin：已保存 $count 个关注；无法获取当前列表';
  }

  @override
  String get pairingModeFull => '完整模式';

  @override
  String get pairingSelectionFailed => '无法准备所选空间。请检查地址和服务器信任信息。不能覆盖已保存的身份。';

  @override
  String get pairingModeLimited => '受限模式';

  @override
  String get pairingSelectionPrepare => '准备所选空间';

  @override
  String get pairingSelectionHelp =>
      '在新设备上选择最多 12 个尚未保存身份的已知空间。在原设备上逐一确认每个空间的二维码和验证码。可以先恢复目录备份。';

  @override
  String get pairingSelectionTitle => '配对所选空间';

  @override
  String get pairingModeFullHelp =>
      '在所选空间内获得工作访问权限、允许的管理操作及设备管理权限。需根卡授权，不会传输根密钥。';

  @override
  String get pairingModeLimitedHelp => '仅能访问所选空间，不能配对或撤销其他设备，也不能管理根密钥。';

  @override
  String get directoryTransferSend => '发送所选内容';

  @override
  String get directoryTransferError => '传输已取消或验证失败。请检查连接并使用新的二维码请求重新开始。';

  @override
  String get directoryTransferConfirm => '代码相同，继续';

  @override
  String get directoryTransferWaiting => '正在等待另一台设备。请求在 5 分钟后过期。';

  @override
  String get directoryTransferTitle => '将目录传输到另一台设备';

  @override
  String get directoryTransferReceive => '接收目录';

  @override
  String get directoryTransferCompareHelp =>
      '请当面或通过受信任的渠道比较两台设备上的代码。如有任何字符不同，请取消传输。不要通过此服务器比较代码。';

  @override
  String get directoryTransferSelect => '在源设备上选择最多 12 个空间';

  @override
  String get directoryTransferDone => '完成。请分别配对各空间以获得访问权限；登录后可在备份设置中应用关注列表。';

  @override
  String get directoryTransferRequest => '来自新设备的二维码请求';

  @override
  String get directoryTransferComparison => '输入新设备上显示的代码';

  @override
  String get directoryTransferCopy => '复制二维码请求';

  @override
  String get directoryTransferHelp =>
      '先在两台设备上打开同一个受信任的空间。仅传输选定的空间、设置和关注列表，不传输密钥和访问权限；恢复后请分别配对各空间。';

  @override
  String get directoryTransferRelay => '选择用于传输的受信任空间';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get voiceShortcutTitle => '按键通话快捷键';

  @override
  String get voiceShortcutScope => '仅在活动窗口中生效。失去焦点时停止传输。';

  @override
  String get voiceShortcutPress =>
      '按下一个键或与 Ctrl、Alt、Shift、Meta 组合。保存前松开所有键。Escape 取消。';

  @override
  String get voiceShortcutSave => '保存';

  @override
  String get deviceTransferTitle => '迁移设备';

  @override
  String get deviceTransferHelp =>
      '只需两步：保存一个加密归档，然后在新设备上将其拖入此处。空间、密钥、历史、队列、草稿、设置和家庭服务器一起迁移。';

  @override
  String get deviceTransferExport => '完整迁移';

  @override
  String get deviceTransferExportHelp => '将整个设备保存到一个文件';

  @override
  String get deviceTransferRestore => '完整恢复';

  @override
  String get deviceTransferRestoreHelp => '将归档拖入此处或点击选择文件';

  @override
  String get deviceTransferOneFile => '请拖入一个完整设备迁移文件。';

  @override
  String get deviceTransferPasswordHelp =>
      '密码至少12个字符。归档验证后会停止原设备的所有空间和家庭服务器。请将归档和密码保存在系统磁盘之外。恢复到全新安装后重新启动应用。请勿将同一归档恢复到多台设备。继续通信后，下次迁移需要创建新归档。';

  @override
  String get deviceTransferFinished => '请保存归档和密码。关闭应用，恢复后重新打开。请勿在原设备上继续通信。';

  @override
  String get deviceTransferClose => '关闭应用';

  @override
  String get attentionDescription => '可以在应用设置中启用通知。摄像头和麦克风仅在您操作时开启。';

  @override
  String get messageUnconfirmed => '未收到服务器确认，请求已保存在队列中。';

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

  @override
  String get homeAutoPortMapping => '自动端口映射';

  @override
  String get homeAutoPortMappingHelp =>
      '通过 PCP、NAT-PMP 或 UPnP 创建临时 TCP 映射，停止时删除；无法绕过 CGNAT。';

  @override
  String get homeAutoPublicIP => '更新公网 IP';

  @override
  String get homeAutoPublicIPHelp => '用于首个 IPv4 地址。通过路由器或 ipify 检查；保留域名及其他地址。';

  @override
  String get homeDiagMappingOk => '路由器已确认临时 TCP 映射，尚未验证外网可达性。';

  @override
  String get homeDiagMappingFailed => '无法创建或续期映射。请检查路由器设置；CGNAT 需要公网地址或隧道。';

  @override
  String get homeDiagAutomaticIPFailed => '无法更新公网 IPv4 地址，请检查网络连接。';

  @override
  String get emojiPicker => '表情';

  @override
  String get emojiSearch => '搜索表情';

  @override
  String get emojiRecent => '最近使用';

  @override
  String get emojiAll => '全部';

  @override
  String get addReaction => '添加回应';

  @override
  String get reactionParticipants => '回应者';

  @override
  String get copyMessage => '复制';

  @override
  String get messageCopied => '已复制';

  @override
  String get emojiFaces => '表情与情感';

  @override
  String get emojiPeople => '人物与手势';

  @override
  String get emojiNature => '动物与自然';

  @override
  String get emojiFood => '食物与饮料';

  @override
  String get emojiTravel => '旅行与地点';

  @override
  String get emojiActivities => '活动';

  @override
  String get emojiObjects => '物品';

  @override
  String get emojiSymbols => '符号';

  @override
  String get emojiFlags => '旗帜';

  @override
  String get messageQueued => '消息已保存在此设备的队列中';

  @override
  String get outboxTitle => '发送队列';

  @override
  String get outboxWaiting => '等待发送';

  @override
  String get outboxBlocked => '发送已停止';

  @override
  String get outboxUnavailable => '无法读取或保存队列。文本仍保留在输入框中。';

  @override
  String get outboxRetry => '重新发送';

  @override
  String get outboxDiscard => '从队列移除';

  @override
  String get outboxDiscardDescription => '消息可能已到达服务器。从队列移除只会停止重试，不会删除其他成员的消息。';

  @override
  String get outboxFileMessage => '含附件的消息';

  @override
  String get outboxIdentityChanged => '设备授权已更改。原队列已保留，禁止从新设备自动发送。';

  @override
  String get outboxFull => '队列已满：最多100条消息和1 MiB。请等待发送或移除不需要的消息。';

  @override
  String get outboxFileLimit => '每个空间和设备的待发送附件最多占用 200 MiB。请等待发送完成或移除不需要的消息。';

  @override
  String get outboxRecover => '恢复以前的发送队列';

  @override
  String get outboxRecoverDescription =>
      '这些消息仍保存在此计算机上，属于以前的设备授权。请先检查消息再恢复。请求密钥保持不变，已接收的消息不会重复。';

  @override
  String get outboxRecoverTrust => '我信任当前设备，并允许它以我的身份发送这些消息。';

  @override
  String get outboxRecoverSend => '恢复并发送';

  @override
  String get outboxRecoverFailed => '无法完成恢复。队列已保留，请检查连接后重试。';

  @override
  String get outboxEdit => '编辑消息';

  @override
  String get outboxDelete => '删除消息';

  @override
  String get outboxReactionAdd => '添加回应';

  @override
  String get outboxReactionRemove => '移除回应';

  @override
  String get outboxMutationBlocked =>
      '更改已停止。请检查权限、runtime 版本和消息的最新状态。如有冲突，请移除此排队操作后重新执行。';

  @override
  String get outboxDiscardMutationDescription =>
      '服务器可能已执行此操作。移出队列只会停止本地重试，不会撤销已执行的操作。依赖的操作将停止。';

  @override
  String get replyMessage => '回复';

  @override
  String get cancelReply => '取消回复';

  @override
  String get replyUnavailable => '原消息不可用';

  @override
  String get notifications => '通知';

  @override
  String get notificationsOff => '关闭';

  @override
  String get notificationsPrivate => '隐藏内容';

  @override
  String get notificationsPreview => '显示消息文本';

  @override
  String get notificationsDescription =>
      '桌面端：应用运行时接收已连接空间的普通频道和已加入的加密频道通知。预览会将文本传给操作系统。暂不支持退出应用后的通知。';

  @override
  String get notificationPermissionError => '无法启用通知。请检查系统设置。';

  @override
  String get newMessageNotification => '新消息';

  @override
  String get messageSearchServer => '搜索当前频道历史记录';

  @override
  String get messageSearchLocal => '仅在此设备搜索 · MLS';

  @override
  String get messageSearchFailed => '搜索失败。重试';

  @override
  String get messageSearchMore => '更多消息';

  @override
  String get messageSearchLimit => '显示前 200 条结果。请缩小搜索范围。';

  @override
  String get loadOlderMessages => '加载更早的消息';

  @override
  String get historyPageFailed => '无法加载历史记录。请重试。';

  @override
  String get messageSearchAllChannels => '所有可用频道';

  @override
  String get messageSearchMixed => '私密频道仅在此设备上搜索';

  @override
  String get savedMlsSearchChannels => '已保存的私密频道';

  @override
  String get savedMlsMessagePreview => '已保存的消息 · 离线';

  @override
  String get homeArchiveVerified => '备份已验证';

  @override
  String homeArchiveSummary(
    String serverId,
    int schema,
    int files,
    String size,
  ) {
    return '空间：$serverId\n数据版本：$schema\n备份文件数：$files\n解压后大小：$size MiB';
  }

  @override
  String get homeArchiveReviewHelp =>
      '已验证文件和校验和。这不能证明来源可信，请仅恢复自己的备份。尚未开始恢复。所有者密钥和设备的 MLS 历史需单独恢复。';

  @override
  String get homeArchiveRestore => '开始恢复';

  @override
  String get homeArchiveUnsupported => '此运行时尚不支持备份验证。需要支持验证的兼容应用和运行时版本；尚未开始恢复。';

  @override
  String get homeArchiveCheckFailed => '无法验证备份。文件可能已损坏或与运行时不兼容。尚未开始恢复。';

  @override
  String get homeDiskTitle => '磁盘和备份';

  @override
  String get homeDiskPolicy =>
      '运行时和更新备份的手动清理：清理会保留当前和上一版运行时、最新的三个已验证备份以及当前恢复备份。其他备份仅在30天后列为候选。不会删除家庭服务器之外的文件。';

  @override
  String get homeDiskScan => '查看大小 / 刷新';

  @override
  String get homeDiskClean => '删除所选';

  @override
  String get homeDiskConfirm => '所选文件夹将永久删除。空间数据、受保护的备份和外部ZIP存档会保留。是否继续？';

  @override
  String get homeDiskFailed => '无法完成检查或清理。状态可能已更改，请刷新列表。链接和未完成的恢复会阻止清理。';

  @override
  String get homeDiskData => '空间数据';

  @override
  String get homeDiskRuntimes => '服务器版本';

  @override
  String get homeDiskBackups => '备份';

  @override
  String get homeDiskRecoveries => '恢复数据';

  @override
  String get homeDiskFree => '服务器磁盘可用空间';

  @override
  String get homeDiskEstimate => '大小为估计值，服务器运行时可能变化。清理会再次检查所选文件。';

  @override
  String get homeDiskNothing => '没有可安全删除的旧文件夹。';

  @override
  String get homeDiskStop => '清理前请先停止服务器。';

  @override
  String get homeBackupTitle => '定时备份';

  @override
  String get homeBackupHelp =>
      '运行中的运行时会备份而不中断聊天。停机后创建一个最新备份。更改在一分钟内生效，正在运行的任务可能按原设置完成。';

  @override
  String get homeBackupUnsupported => '请安装或更新运行时以使用定时备份。';

  @override
  String get homeBackupEnabled => '启用定时备份';

  @override
  String get homeBackupInterval => '间隔（小时）';

  @override
  String get homeBackupPrune => '自动删除旧备份';

  @override
  String get homeBackupCount => '备份数量（3–100）';

  @override
  String get homeBackupDays => '保留天数（1–3650）';

  @override
  String get homeBackupQuota => '上限，MiB（0为不限）';

  @override
  String get homeBackupRetention =>
      '启用自动清理后，任一超限条件都会生效。即使超出容量上限，也保留最新三个已验证备份。未知、损坏和不兼容文件不会删除。';

  @override
  String get homeBackupSave => '保存设置';

  @override
  String get homeBackupConfigure => '设置备份';

  @override
  String get homeBackupRefresh => '刷新状态';

  @override
  String get homeBackupFailed => '备份或清理未完成。请检查设置、磁盘空间和访问权限。至少五分钟后重试。';

  @override
  String get homeBackupLast => '上次成功备份';

  @override
  String get homeBackupNext => '下次检查';

  @override
  String get homeBackupProtected => '部分文件受到保护，或容量上限无法容纳三个备份。';

  @override
  String get homeBackupOff => '定时备份已关闭';

  @override
  String get homeBackupRunning => '正在创建备份…';

  @override
  String get homeBackupOK => '上次操作已完成';

  @override
  String get homeBackupSpace => '无法确认有足够空间创建新备份。';

  @override
  String get homeBackupWaiting => '等待运行时运行并到达备份时间';

  @override
  String get voiceTitle => '语音房间';

  @override
  String get voiceDescription => '无摄像头的语音交流。只有您主动操作时才会启用麦克风。';

  @override
  String get voiceCreate => '创建房间';

  @override
  String get voiceName => '房间名称';

  @override
  String get voiceJoin => '加入';

  @override
  String get voiceLeave => '退出语音';

  @override
  String get voiceMicrophoneOn => '开启麦克风';

  @override
  String get voiceMicrophoneOff => '关闭麦克风';

  @override
  String get voiceSoundOn => '开启声音';

  @override
  String get voiceSoundOff => '关闭声音';

  @override
  String get voiceJoining => '连接中…';

  @override
  String get voiceReconnecting => '正在重新连接。麦克风已关闭。';

  @override
  String get voiceConnected => '通话中';

  @override
  String get voiceParticipants => '参与者';

  @override
  String get voiceMuted => '麦克风已关闭';

  @override
  String get voiceSpeaking => '正在说话';

  @override
  String get voiceDeafened => '声音已关闭';

  @override
  String get voiceEmpty => '还没有语音房间。所有者或管理员可以创建第一个房间。';

  @override
  String get voiceConnectFirst => '请先连接空间以打开语音房间。';

  @override
  String get voiceLimit => '每个房间最多八位参与者。通过互联网连接时，由所有者配置 STUN/TURN，应用会自动获取设置。';

  @override
  String get voiceDesktopOnly => '语音房间目前仅支持桌面端。';

  @override
  String get voicePrivacy => '不录音、不使用摄像头。音频经过空间服务器，并非参与者之间的 MLS 加密。';

  @override
  String get voiceFailure => '无法继续通话';

  @override
  String get voiceCancel => '取消';

  @override
  String get voiceSave => '创建';

  @override
  String get voiceUpdateRuntime => '语音房间需要支持语音的新运行时。请在“广播”中更新服务器。';

  @override
  String get voiceDeviceUnavailable => '所选音频设备已断开。请重新连接或选择其他设备，然后手动开启麦克风或声音。';

  @override
  String get voiceDeviceDisconnected => '设备已断开';

  @override
  String get voiceAudioDevices => '音频设备';

  @override
  String get voiceSettingsTitle => '语音';

  @override
  String get voiceInputVolume => '麦克风音量';

  @override
  String get voiceOutputVolume => '输出音量';

  @override
  String get voiceProcessingTitle => '音频处理';

  @override
  String get voiceInputProfile => '麦克风模式';

  @override
  String get voiceProfileSpeech => '对话';

  @override
  String get voiceProfileStudio => '录音室 — 无处理';

  @override
  String get voiceProfileCustom => '自定义';

  @override
  String get voiceNoiseSuppression => '降噪';

  @override
  String get voiceEchoCancellation => '回声消除';

  @override
  String get voiceAutoGain => '自动增益控制';

  @override
  String get voiceProcessingHint => '更改处理设置会关闭麦克风。请重新开启以应用设置。录音室模式建议使用耳机。';

  @override
  String get voiceTestMicrophone => '测试麦克风';

  @override
  String get voiceStopMicrophoneTest => '停止测试';

  @override
  String get voiceMicrophoneLevel => '麦克风电平';

  @override
  String get voiceMicrophoneTestHint =>
      '您将听到自己的声音。测试仅在本地运行，最长60秒，不会向房间发送音频。房间声音将关闭。关闭设置会停止测试。';

  @override
  String get voiceDevicesDescription => '选择麦克风和声音输出设备。加入房间前或通话期间均可更改。';

  @override
  String get voiceDevicesRemembered => '选择会保存在此电脑上。加入房间和恢复设置不会自动开启麦克风。';

  @override
  String get voiceInputDevice => '麦克风';

  @override
  String get voiceOutputDevice => '声音输出';

  @override
  String get voiceCurrentDevice => '当前系统设备';

  @override
  String get voiceRefreshDevices => '刷新设备';

  @override
  String get voiceCloseDevices => '关闭';

  @override
  String get voicePushToTalk => '按键说话';

  @override
  String get voicePushToTalkHint =>
      '先在房间中开启麦克风，再按住选定的快捷键说话。仅在窗口获得焦点时有效。麦克风测试连续播放。';

  @override
  String get voiceAutomaticSensitivity => '自动输入灵敏度';

  @override
  String get voiceSensitivity => '输入阈值';

  @override
  String get recoveryIncludeSpaces => '包含空间';

  @override
  String get recoveryIncludeSpacesHint =>
      '创建第二个二维码，包含已保存的空间及其恢复密钥，不包含 MLS 密钥和历史记录。';

  @override
  String get recoveryAccessQr => '所选身份访问恢复';

  @override
  String get recoverySpacesQr => '空间与访问';

  @override
  String get recoverySpacesUseFile => '内容过大，无法放入一个二维码，请保存加密文件。';

  @override
  String get recoverySaveSpacesQr => '保存空间二维码';

  @override
  String get recoverySaveSpacesFile => '将空间保存到文件';

  @override
  String recoverySpacesResult(int restored, int total) {
    return '已添加空间：$restored。集合总数：$total。现有密钥保持不变。失败的空间可重新导入。';
  }

  @override
  String get migrationTitle => '完整迁移空间';

  @override
  String get migrationExportHelp =>
      '归档包含服务器、设备密钥、当前 MLS 状态和加密频道本地历史。保存后，此客户端将停止使用该空间。请将归档保存在其他磁盘并记住密码。如果操作中断，请检查 .pending 文件，其中可能包含完整迁移。 验证归档后，系统存储中旧设备的工作密钥将被迁移标记替换。';

  @override
  String get migrationImportHelp =>
      '恢复后将继续使用原设备身份。此归档只能用于一台新设备。旧服务器必须停止。现有密钥不会被替换。';

  @override
  String get migrationPassword => '归档密码（至少 12 个字符）';

  @override
  String get migrationPasswordRepeat => '再次输入密码';

  @override
  String get migrationExported => '迁移已保存，旧设备已停止。重装系统前请保管归档和密码。';

  @override
  String get feedOpenUnread => '打开未读评论';

  @override
  String get communitySearchHint => '搜索此分区';

  @override
  String get communitySearchEmpty => '没有匹配结果';

  @override
  String get communitySearchInvalid => '请输入 1–256 字节的 UTF-8 文本';

  @override
  String get communitySearchThread => '主题';

  @override
  String get communitySearchReply => '回复';

  @override
  String get communitySearchPost => '动态';

  @override
  String get communitySearchComment => '评论';

  @override
  String get communitySearchRevoked => '已无法访问此分区';

  @override
  String get dashboardAttention => '需要关注';

  @override
  String get dashboardAttentionEmpty => '暂无需要处理的事项。';

  @override
  String get dashboardChecking => '正在检查更新…';

  @override
  String get dashboardAttentionLimit => '显示部分事项，其余内容可在空间中查看。';

  @override
  String get dashboardConnectionIssue => '连接问题';

  @override
  String get dashboardPendingReports => '待处理举报';

  @override
  String get dashboardRepliesToYou => '您的主题有新回复';

  @override
  String get dashboardCommunityNews => '社区动态';

  @override
  String get dashboardCommunityDescription =>
      '来自可读版块的最新主题与动态。服务器支持阅读记录时，徽标显示未读数量。';

  @override
  String get dashboardCommunityFailed => '部分分区刷新失败，请重试。';

  @override
  String get dashboardCommunityUnsupported => '请更新服务器以启用社区摘要。';

  @override
  String get dashboardCommunityEmpty => '暂无可用的主题或动态。';

  @override
  String get dashboardAttentionUnknown => '部分分区尚未检查。';

  @override
  String get dashboardAttachmentPost => '含附件的动态';

  @override
  String get dashboardCommunityOffline => '连接后将显示不可用空间的动态。';

  @override
  String get communityMention => '提及成员';

  @override
  String get communityMentionQuery => '成员名称或 ID';

  @override
  String get communityMentionFailed => '无法加载成员。请检查访问权限并重试。';

  @override
  String get communityMentionEmpty => '未找到成员';

  @override
  String get dashboardMention => '有人提及您';

  @override
  String get dashboardFeedRepliesToYou => '您的动态有新回复';

  @override
  String get appearanceTheme => '主题';

  @override
  String get appearanceThemeSystem => '跟随系统';

  @override
  String get appearanceThemeLight => '浅色';

  @override
  String get appearanceThemeDark => '深色';

  @override
  String get notificationSection => '分区';

  @override
  String get notificationInboxEmpty => '没有未读通知';

  @override
  String get notificationInboxFailed => '无法更新通知。请检查连接和访问权限。';

  @override
  String get notificationMarkRead => '标记为已查看';

  @override
  String get notificationRefresh => '刷新通知';

  @override
  String get notificationPrevious => '上一页';

  @override
  String get notificationNext => '下一页';

  @override
  String get notificationUnavailable => '没有可访问的分区';

  @override
  String get notificationReply => '回复你的消息';

  @override
  String get notificationOpen => '打开';

  @override
  String get mlsMentionsLegacy => '部分设备尚未确认支持提及。将仅发送姓名，不包含提及标记。';

  @override
  String get mlsCancelRetry => '取消成员变更后的待发送消息';

  @override
  String get profileAvatar => '空间头像';

  @override
  String get chooseAvatar => '选择图片';

  @override
  String get removeAvatar => '移除头像';

  @override
  String get avatarInvalid => '请选择不超过 5 MiB 和 400 万像素的静态 PNG 或 JPEG 图片。';

  @override
  String get profileConflict => '个人资料已在其他设备上更改。请重新加载后保存；您的草稿已保留。';

  @override
  String get profileSaved => '个人资料已保存';

  @override
  String get saveProfile => '保存个人资料';

  @override
  String get profileSpaceHelp => '名称在此空间内唯一。名称和头像适用于所有版块。';

  @override
  String get communityReactionsRetry => '重试请求';

  @override
  String get communityReactionsFailure => '无法更新回应。';

  @override
  String get communityReactionsConflict => '回应已更改。请检查选择后重试。';

  @override
  String get communityReactionsDenied => '回应不可用：权限或分区状态已更改。';

  @override
  String get communityFavorites => '收藏';

  @override
  String get communityFavoriteAdd => '添加到收藏';

  @override
  String get communityFavoriteRemove => '取消收藏';

  @override
  String get communityFavoriteRetry => '无法更新收藏。重试';

  @override
  String get communityFavoritesEmpty => '此分区暂无收藏。';

  @override
  String get spaceSearch => '搜索此空间';

  @override
  String get spaceSearchHint => '搜索聊天、论坛和动态';

  @override
  String get spaceSearchChat => '消息';

  @override
  String get spaceSearchChatMode => '搜索当前聊天与本地 MLS';

  @override
  String get spaceSearchLimit => '显示前 500 条结果。请缩小搜索范围。';

  @override
  String get feedCancelReference => '移除引用';

  @override
  String get feedOpenOriginal => '查看原文';

  @override
  String get feedOriginalUnavailable => '原帖不可用';

  @override
  String get feedReply => '回复';

  @override
  String feedReplyTo(String number) {
    return '回复评论 #$number';
  }

  @override
  String get feedRepost => '转发';

  @override
  String get feedRepostHint => '直接发送以转发，或添加文字以引用。';

  @override
  String get feedShare => '转发或引用';

  @override
  String get followAdd => '关注';

  @override
  String get followingEmpty => '你还没有关注任何人。';

  @override
  String get followingTitle => '关注';

  @override
  String get followRefresh => '刷新关注';

  @override
  String get followRemove => '取消关注';

  @override
  String get followRevoked => '权限或空间已更改。请重新打开动态。';

  @override
  String get followUnavailable => '成员不可用';

  @override
  String get personalFeed => '我的动态';

  @override
  String get personalFeedEmpty => '这里显示你关注的作者在可访问版块中的帖子。在帖子或评论旁关注作者。';

  @override
  String get personalFeedLimit => '显示前500条帖子。刷新以查看新帖子。';

  @override
  String get personalFeedOpen => '打开讨论';

  @override
  String get userExportTitle => '导出我的内容';

  @override
  String get userExportHelp =>
      '将自己的普通消息、主题、帖子和回复导出为 JSON。附件仅包含元数据，不含文件。无 MLS、密钥或令牌。每个时段最多 5000 条、8 MiB。';

  @override
  String get userExportSection => '版块';

  @override
  String get userExportAll => '所有可访问版块';

  @override
  String get userExportAfter => '起始日期（UTC，可选）';

  @override
  String get userExportBefore => '结束日期（UTC，包含当天，可选）';

  @override
  String get userExportPrepare => '准备 JSON';

  @override
  String get userExportSave => '保存 JSON';

  @override
  String get userExportReady => '已准备条目';

  @override
  String get userExportSaved => '导出已保存';

  @override
  String get userExportInvalidPeriod => '请输入有效的 YYYY-MM-DD 日期和时间范围。';

  @override
  String get pairingNetworkError => '无法连接服务器。代码到期前将自动重试。';

  @override
  String get pairingVerificationError => '验证失败。请重新开始配对。';

  @override
  String get pairingQrInvalid => '二维码无效、已过期或属于其他空间。请扫描待连接设备上的新二维码。';

  @override
  String get directoryBackupTitle => '加密目录备份';

  @override
  String get directoryBackupHelp =>
      '备份空间、设置和关注，不含设备密钥和历史记录。密码至少12个字符。访问权限需通过恢复卡或配对恢复。';

  @override
  String get directoryBackupCreate => '创建备份';

  @override
  String get directoryBackupRead => '预览备份';

  @override
  String get directoryBackupApply => '恢复目录';

  @override
  String get directoryBackupSettings => '用备份中的设置替换界面设置';

  @override
  String get directoryBackupFollows => '添加已保存的关注';

  @override
  String get directoryBackupResume => '完成中断的恢复';

  @override
  String get directoryBackupUnverified => '此备份没有本地版本记录，无法确认是否为最新版本。';

  @override
  String get directoryBackupResults => '空间结果（保存时列出不完整的关注快照）：';

  @override
  String get directoryBackupSaved => '备份已保存并验证。请单独保存密码。';

  @override
  String get directoryBackupRestored => '本地恢复已完成。请使用相同身份登录后单独恢复关注。';

  @override
  String get directoryBackupError => '操作未完成。请检查密码、备份完整性和存储访问权限。可继续中断的恢复。';

  @override
  String get directoryBackupConfirm => '应用已验证的目录？访问密钥将保留。将应用所选设置；中断后可继续恢复。';

  @override
  String get directoryBackupFollowsHelp =>
      '为已连接且身份相同的空间添加缺失的关注？将保留现有关注。服务器会检查权限，结果可能不完整。';

  @override
  String directoryBackupPreview(int count) {
    return '备份中的空间数量：$count';
  }

  @override
  String directoryBackupSpaceComplete(String origin, int count) {
    return '$origin：关注 $count 位参与者；快照完整';
  }

  @override
  String directoryBackupSpaceIncomplete(String origin, int count) {
    return '$origin：已保存 $count 个关注；无法获取当前列表';
  }

  @override
  String get pairingModeFull => '完整模式';

  @override
  String get pairingSelectionFailed => '无法准备所选空间。请检查地址和服务器信任信息。不能覆盖已保存的身份。';

  @override
  String get pairingModeLimited => '受限模式';

  @override
  String get pairingSelectionPrepare => '准备所选空间';

  @override
  String get pairingSelectionHelp =>
      '在新设备上选择最多 12 个尚未保存身份的已知空间。在原设备上逐一确认每个空间的二维码和验证码。可以先恢复目录备份。';

  @override
  String get pairingSelectionTitle => '配对所选空间';

  @override
  String get pairingModeFullHelp =>
      '在所选空间内获得工作访问权限、允许的管理操作及设备管理权限。需根卡授权，不会传输根密钥。';

  @override
  String get pairingModeLimitedHelp => '仅能访问所选空间，不能配对或撤销其他设备，也不能管理根密钥。';

  @override
  String get directoryTransferSend => '发送所选内容';

  @override
  String get directoryTransferError => '传输已取消或验证失败。请检查连接并使用新的二维码请求重新开始。';

  @override
  String get directoryTransferConfirm => '代码相同，继续';

  @override
  String get directoryTransferWaiting => '正在等待另一台设备。请求在 5 分钟后过期。';

  @override
  String get directoryTransferTitle => '将目录传输到另一台设备';

  @override
  String get directoryTransferReceive => '接收目录';

  @override
  String get directoryTransferCompareHelp =>
      '请当面或通过受信任的渠道比较两台设备上的代码。如有任何字符不同，请取消传输。不要通过此服务器比较代码。';

  @override
  String get directoryTransferSelect => '在源设备上选择最多 12 个空间';

  @override
  String get directoryTransferDone => '完成。请分别配对各空间以获得访问权限；登录后可在备份设置中应用关注列表。';

  @override
  String get directoryTransferRequest => '来自新设备的二维码请求';

  @override
  String get directoryTransferComparison => '输入新设备上显示的代码';

  @override
  String get directoryTransferCopy => '复制二维码请求';

  @override
  String get directoryTransferHelp =>
      '先在两台设备上打开同一个受信任的空间。仅传输选定的空间、设置和关注列表，不传输密钥和访问权限；恢复后请分别配对各空间。';

  @override
  String get directoryTransferRelay => '选择用于传输的受信任空间';
}
