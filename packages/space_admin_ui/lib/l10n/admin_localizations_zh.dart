// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AdminLocalizationsZh extends AdminLocalizations {
  AdminLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get closeManagement => '关闭管理';

  @override
  String get managementTitle => '空间管理';

  @override
  String get managementIntro => '空间设置和成员。';

  @override
  String get managementSections => '';

  @override
  String get deviceIdentity => '当前设备身份';

  @override
  String get currentConnection => '使用当前连接的身份，无需额外账户。';

  @override
  String get currentSession => '使用当前 Space 会话。如需恢复访问，请打开身份页面。';

  @override
  String get connectManagement => '管理当前服务器';

  @override
  String get claimOwner => '指定首位所有者';

  @override
  String get setupHelp => '在服务器控制台获取代码：space-server -setup-code。有效期为 15 分钟。';

  @override
  String get setupCode => '服务器一次性代码';

  @override
  String get confirmOwner => '确认所有权';

  @override
  String get authorizeFirst => '请先在下方明确授权此设备';

  @override
  String get authorizeTitle => '允许此设备管理服务器';

  @override
  String get authorizeHelp => 'space.manage 权限由您的根密钥签署，同时需要所有者或管理员角色。';

  @override
  String get authorizeDevice => '授权此设备';

  @override
  String get authorizeConfirm => '允许管理服务器？';

  @override
  String get authorizeDetails => '您明确允许此设备修改设置、聊天、语音房间和成员访问权限。';

  @override
  String get rootPassword => '根身份卡密码（JSON/PNG）';

  @override
  String get cancel => '取消';

  @override
  String get allow => '允许';

  @override
  String get spaceName => '空间名称';

  @override
  String get chatName => '公共聊天名称';

  @override
  String get chatsEnabled => '成员可以使用聊天';

  @override
  String get chatsHelp => '关闭后将禁止读取和发送，历史记录会保留。';

  @override
  String get registration => '注册';

  @override
  String get registrationOpen => '开放';

  @override
  String get registrationClosed => '仅限邀请';

  @override
  String get saveSettings => '保存设置';

  @override
  String get reloadSettings => '重新加载';

  @override
  String get settingsLoaded => '已从服务器加载设置。';

  @override
  String get settingsSaved => '设置已保存到服务器。';

  @override
  String get setupNeeded => '设备已登录。请输入服务器的一次性代码以指定所有者。';

  @override
  String get roleDenied => '已登录，但您的角色无权管理此服务器。';

  @override
  String get deviceRevoked => '此设备已被撤销。请恢复访问或使用其他设备。';

  @override
  String get signInFirst => '请先登录';

  @override
  String get identityChanged => '身份已更改。请重新登录';

  @override
  String get accessBlocked => '此空间的访问已被阻止';

  @override
  String get bothNames => '请输入空间名称';

  @override
  String get settingsConflict => '设置已更改。请重新加载后再修改。';

  @override
  String settingsRevision(String revision) {
    return '空间设置 · 版本 $revision';
  }

  @override
  String get channelsTitle => '聊天与权限';

  @override
  String get channelsReload => '刷新聊天列表';

  @override
  String get channelsEmpty => '暂无聊天。';

  @override
  String get channelCreateSection => '创建聊天';

  @override
  String get channelNewId => '新聊天地址';

  @override
  String get channelNewTitle => '新聊天名称';

  @override
  String get channelNewOrder => '顺序';

  @override
  String get channelDefaults => '成员可读取和发送，阅读者只能读取。公开预览已关闭。';

  @override
  String get channelCreate => '创建聊天';

  @override
  String get channelName => '名称';

  @override
  String get channelOrder => '顺序';

  @override
  String get channelArchive => '归档聊天';

  @override
  String get channelPublicPreview => '向未登录访客显示名称';

  @override
  String get channelPreviewHelp => '预览会显示名称和地址，但不显示消息。归档保留历史记录，并禁止发送新消息。';

  @override
  String get channelSave => '保存聊天';

  @override
  String get channelReload => '重新加载';

  @override
  String get channelAccessHelp =>
      '个人规则优先于角色规则。所有者和管理员保留访问权限。阅读者不能发送消息。管理权限允许修改元数据，但不允许修改权限。';

  @override
  String get channelRulesEmpty => '没有规则：仅所有者和管理员可访问。';

  @override
  String get channelRuleSubject => '添加规则的对象';

  @override
  String get channelMembers => '成员';

  @override
  String get channelReaders => '阅读者';

  @override
  String get channelIndividual => '单个成员';

  @override
  String get channelSelectMember => '选择成员';

  @override
  String get channelMoreMembers => '加载更多成员';

  @override
  String get channelPrincipalId => '或输入完整成员标识符';

  @override
  String get channelAddRule => '添加规则';

  @override
  String get channelSaveAccess => '保存权限';

  @override
  String get channelDeleteRule => '删除规则';

  @override
  String get channelVisible => '可见';

  @override
  String get channelRead => '读取消息';

  @override
  String get channelWrite => '发送消息';

  @override
  String get channelManage => '管理';

  @override
  String get channelsLoaded => '列表已加载。';

  @override
  String get channelLoaded => '设置和权限已加载。';

  @override
  String get channelCreated => '聊天已创建。';

  @override
  String get channelSaved => '聊天设置已保存。';

  @override
  String get channelAccessSaved => '权限已保存。';

  @override
  String get channelRuleAdded => '规则已添加到表单。保存权限后才会生效。';

  @override
  String get channelConflict => '设置或权限已更改。请重新加载；未保存的字段会保留在表单中。';

  @override
  String get channelChanged => '设置在加载列表和权限期间发生了变化';

  @override
  String get channelOrderInvalid => '顺序必须在 0 到 100000 之间';

  @override
  String get channelNameInvalid => '请输入不超过 320 字节的名称';

  @override
  String get channelIdInvalid => '地址：使用拉丁字母、数字、_ 或 -，并以字母开头';

  @override
  String get channelIdTaken => '此地址已被占用，请选择其他地址。';

  @override
  String get channelUnavailable => '已不可用';

  @override
  String get channelRulesLimit => '最多 100 条规则';

  @override
  String get channelMemberRequired => '请选择成员或输入其完整标识符';

  @override
  String get channelRuleDuplicate => '此成员或角色的规则已存在';

  @override
  String get channelAccessTooLarge => '权限列表超出请求限制。请减少个人规则的数量。';

  @override
  String channelRevision(String id, String revision) {
    return '$id · 版本 $revision';
  }

  @override
  String channelAccessRevision(String revision) {
    return '权限 · 版本 $revision';
  }

  @override
  String get channelArchivedSuffix => ' · 已归档';

  @override
  String get channelBlockedSuffix => ' · 已阻止';

  @override
  String get roleOwner => '所有者';

  @override
  String get roleAdmin => '管理员';

  @override
  String get roleMember => '成员';

  @override
  String get roleReader => '阅读者';

  @override
  String get membersConflict => '权限已更改。未保存的值会保留在表单中。请刷新成员后重试。';

  @override
  String get membersLoaded => '成员已加载。';

  @override
  String get memberConfirm => '更改成员权限？';

  @override
  String get memberApply => '应用权限';

  @override
  String get memberSaved => '成员权限已保存。服务器会将其应用于操作和订阅。';

  @override
  String get memberCollapse => '收起权限';

  @override
  String get memberEdit => '编辑权限';

  @override
  String get memberRole => '成员角色';

  @override
  String get memberBlock => '阻止成员';

  @override
  String get memberSave => '保存成员权限';

  @override
  String get membersRefresh => '刷新成员';

  @override
  String get membersHelp => '只有所有者可以更改角色和阻止成员。管理员可以查看列表。';

  @override
  String get membersSearch => '按标识符或角色搜索';

  @override
  String get membersEmpty => '未找到成员。';

  @override
  String get memberBlocked => '已阻止';

  @override
  String get memberAllowed => '允许';

  @override
  String get memberBlockedSuffix => ' · 访问已被阻止';

  @override
  String memberProposal(String id, String role, String access) {
    return '$id\n角色：$role\n访问：$access';
  }

  @override
  String membersCount(int count) {
    return '已加载：$count。搜索仅针对已加载的成员。';
  }

  @override
  String get invitesTitle => '邀请';

  @override
  String get invitesRefresh => '刷新邀请';

  @override
  String get invitesHelp => '所有者和管理员可邀请成员和阅读者。邀请不会更改已有成员的角色。';

  @override
  String get inviteRole => '受邀者角色';

  @override
  String get inviteMember => '成员 — 读取和发送';

  @override
  String get inviteReader => '阅读者 — 只读';

  @override
  String get inviteTtl => '邀请有效期';

  @override
  String get inviteMinute => '1 分钟';

  @override
  String get inviteHour => '1 小时';

  @override
  String get inviteDay => '1 天';

  @override
  String get inviteWeek => '7 天';

  @override
  String get inviteUses => '使用次数（1–100）';

  @override
  String get inviteCreate => '创建邀请';

  @override
  String get inviteCode => '新邀请代码';

  @override
  String get inviteLink => 'Space 邀请链接';

  @override
  String get inviteLinkHelp =>
      '代码仅在此时显示，并保存在表单内存中。请将链接粘贴到 Space 的“添加空间”。公共服务器的端口必须能从朋友的网络访问。';

  @override
  String get inviteCopyCode => '复制代码';

  @override
  String get inviteCopyLink => '复制链接';

  @override
  String get inviteHide => '隐藏代码';

  @override
  String get inviteRevoke => '撤销邀请';

  @override
  String get inviteRevokeConfirm => '撤销邀请？';

  @override
  String get inviteRevokeHelp => '此邀请将不再允许新成员加入。已加入的成员保留访问权限。';

  @override
  String get invitesEmpty => '暂无邀请。';

  @override
  String get invitesMore => '加载更多邀请';

  @override
  String get inviteRevokedState => '已撤销';

  @override
  String get inviteExpiredState => '已过期';

  @override
  String get inviteUsedState => '已用完';

  @override
  String get inviteActiveState => '有效';

  @override
  String get invitesLoaded => '邀请已加载。';

  @override
  String get inviteCreated => '邀请已创建。请立即复制代码或链接。';

  @override
  String get inviteCopied => '已复制到剪贴板。';

  @override
  String get inviteCopyFailed => '无法复制。请选中代码或链接并手动复制。';

  @override
  String get inviteRevoked => '邀请已撤销。已加入成员的访问权限不变。';

  @override
  String get inviteUsesInvalid => '请输入 1 到 100 之间的使用次数';

  @override
  String inviteExpiry(String expiry, int uses, int limit) {
    return '截至 $expiry（设备时间）· 已使用 $uses/$limit 次';
  }

  @override
  String get devicesTitle => '设备与权限';

  @override
  String get devicesHelp => '仅显示属于您身份的设备。服务器角色和设备权限分别验证。';

  @override
  String get devicesRefresh => '刷新设备';

  @override
  String get devicesEmpty => '没有可用设备。';

  @override
  String get deviceRecovery => '恢复密钥';

  @override
  String get deviceCurrent => '此设备';

  @override
  String get deviceOther => '其他设备';

  @override
  String get deviceRevokeAccess => '撤销访问';

  @override
  String get deviceRevokeConfirm => '撤销访问？';

  @override
  String get deviceRevoke => '撤销';

  @override
  String get deviceRecoveryWarning => '身份卡及所有通过它连接的设备将失去访问权限。请确保您有其他恢复方式。';

  @override
  String get deviceCurrentWarning => '此设备将失去访问权限。其会话和订阅将结束。';

  @override
  String get deviceOtherWarning => '该设备的会话和订阅将结束。';

  @override
  String get deviceCardHelp => '确认后请选择原始 JSON 或 PNG 身份卡。密钥仅用于签署请求。';

  @override
  String get deviceCardPassword => '身份卡密码';

  @override
  String get devicesLoaded => '设备已加载。';

  @override
  String get deviceRevokedStatus => '已在服务器上撤销访问。';

  @override
  String get deviceExpiryUnknown => '有效期未知';

  @override
  String deviceAccessUntil(String expiry) {
    return '访问有效至 $expiry';
  }

  @override
  String deviceExpired(String expiry) {
    return '已过期：$expiry';
  }

  @override
  String deviceScopes(String scopes) {
    return '权限：$scopes';
  }

  @override
  String deviceParent(String id) {
    return '签发来源：$id';
  }

  @override
  String get recoveryConfirm => '确认操作';

  @override
  String get recoveryConfirmButton => '确认';

  @override
  String get recoveryProtect => '保护身份卡';

  @override
  String get recoveryOpen => '打开身份卡';

  @override
  String get recoveryPasswordHelp => '密码仅在此设备上加密文件，不会发送到服务器。请使用多个随机单词，并单独保存密码。';

  @override
  String get recoveryPassword => '密码（至少 12 个字符）';

  @override
  String get recoveryPasswordRepeat => '再次输入密码';

  @override
  String get recoveryPasswordInvalid => '两次密码不一致。';

  @override
  String get recoveryEncrypt => '加密';

  @override
  String get recoveryOpenButton => '打开';

  @override
  String get pairingIdentity => '已有身份？';

  @override
  String get pairingIntro => '在原设备上确认后连接此电脑。根密钥和身份卡不会被复制。设备配对不需要邀请。';

  @override
  String get pairingStart => '信任服务器并开始配对';

  @override
  String get pairingInstructions => '在原设备的 Space 中打开“身份”→“确认设备”。代码有效期为五分钟。';

  @override
  String get pairingCopy => '复制代码';

  @override
  String get pairingWaiting => '等待原设备签名…';

  @override
  String get pairingCheckBeforeSign => '签名前，请在授权设备上输入此验证码：';

  @override
  String get pairingVerified => '根签名已验证。请核对两个屏幕上的代码：';

  @override
  String get pairingAccept => '代码一致 — 连接';

  @override
  String get pairingCancel => '取消配对';

  @override
  String get rotationTitle => '更换根密钥';

  @override
  String get rotationHelp =>
      '保留您的身份并撤销旧密钥。请在持有根密钥的设备上开始更换。发生故障后，请完成已保存的更换操作。如果请求在服务器完成操作前过期，请使用旧密钥连接并更新请求。';

  @override
  String get rotationStart => '更换根密钥';

  @override
  String get rotationRenew => '更新已过期的请求';

  @override
  String get rotationFinish => '完成已保存的更换';

  @override
  String get pairingApproveTitle => '确认设备';

  @override
  String get pairingApproveHelp =>
      '请输入新设备的一次性代码。签名需要根密钥或已打开的恢复身份卡。使用恢复身份卡时，新设备会验证从原始根密钥开始的授权链。';

  @override
  String get pairingCode => '配对代码';

  @override
  String get pairingPrepare => '检查并确认';

  @override
  String get pairingComparison => '用于与新设备核对的验证码';

  @override
  String get pairingEnteredCode => '新设备上的验证码';

  @override
  String get pairingSign => '代码一致 — 签名';

  @override
  String get recoveryTitle => '恢复访问';

  @override
  String get recoveryHelp => '二维码恢复卡可恢复您的身份。请设置密码并单独保存。';

  @override
  String get recoveryExport => '保存二维码';

  @override
  String get recoveryRestore => '从文件恢复';

  @override
  String get recoveryScan => '使用摄像头扫描';

  @override
  String get recoveryDevices => '您的设备';

  @override
  String get recoveryDevicesHelp => '仅显示您身份的权限。旧记录和已撤销的记录会保留。';

  @override
  String get cameraTitle => '扫描身份卡';

  @override
  String get cameraHelp => '请将摄像头对准 Space 身份卡上的二维码。图像仅在此设备上处理。麦克风已关闭。';

  @override
  String get cameraRestart => '重新启动摄像头';

  @override
  String get cameraCapture => '扫描二维码';

  @override
  String cameraLabel(int number, String name) {
    return '摄像头 $number — $name';
  }

  @override
  String get serverIconTitle => '空间图标';

  @override
  String get serverIconUpload => '选择 PNG 或 SVG';

  @override
  String get serverIconHelp => 'PNG 自动缩小。SVG 最大8 KiB，不含脚本或外部链接。';

  @override
  String get serverIconInvalid =>
      '无法读取图标。请选择不超过 2048×2048 的 PNG 或不超过 8 KiB 的简单 SVG。';

  @override
  String get serverIconUpgrade => '请更新服务器以更改图标。';

  @override
  String get iconOrbit => '轨道';

  @override
  String get iconPlanet => '星球';

  @override
  String get iconLeaf => '叶子';

  @override
  String get iconStar => '星星';

  @override
  String get iconBolt => '闪电';

  @override
  String get iconRocket => '火箭';

  @override
  String get recoveryCreateQr => '创建二维码';

  @override
  String get recoveryOriginalCardNeeded => '此设备没有恢复密钥。请使用原始恢复卡。';

  @override
  String get channelDelete => '删除聊天';

  @override
  String channelDeleteConfirm(String name) {
    return '删除“$name”及其全部消息？此操作无法撤销。';
  }

  @override
  String get channelDeleted => '聊天已删除。';

  @override
  String get storageTitle => '文件存储';

  @override
  String get storageTotal => '服务器存储上限（MiB）';

  @override
  String get storageMember => '每位成员的默认上限（MiB）';

  @override
  String get storageHelp => '0 表示禁止新上传。已有文件会保留。未完成的上传也占用额度。';

  @override
  String get storagePersonal => '个人上限（MiB）';

  @override
  String get storageInherited => '留空则使用默认上限';

  @override
  String get attachmentsEnabled => '允许文件附件';

  @override
  String get attachmentsEnabledHelp => '关闭后，成员无法附加或下载文件，此空间的文件功能将被隐藏。';

  @override
  String get voiceRoomsTitle => '语音房间';

  @override
  String get voiceRoomsReload => '刷新房间列表';

  @override
  String get voiceRoomsEmpty => '暂无房间。';

  @override
  String get voiceRoomCreate => '创建房间';

  @override
  String get voiceRoomNewTitle => '新房间名称';

  @override
  String get voiceRoomDefaults => '成员可以收听和发言，读者只能收听。';

  @override
  String get voiceRoomListen => '收听';

  @override
  String get voiceRoomSpeak => '发言';

  @override
  String get voiceRoomAccessHelp =>
      '个人规则替代角色规则。所有者和管理员保留访问权限。读者只能收听，不能发言。管理权限允许修改房间设置，但不能修改权限。';

  @override
  String get voiceRoomArchive => '归档房间';

  @override
  String get voiceRoomArchiveHelp => '已归档的房间无法接受新连接。';

  @override
  String get voiceRoomSave => '保存房间';

  @override
  String get voiceRoomDelete => '删除房间';

  @override
  String voiceRoomDeleteConfirm(String name) {
    return '删除房间“$name”？此操作无法撤销。';
  }

  @override
  String get voiceRoomCreated => '房间已创建。';

  @override
  String get voiceRoomSaved => '房间设置已保存。';

  @override
  String get voiceRoomDeleted => '房间已删除。';

  @override
  String get voiceRoomCapacity => '参与人数上限';

  @override
  String get voiceRoomCapacityHelp =>
      '2 至 32 人，默认为 8 人。降低上限不会断开现有参与者。更改上限需要所有参与者使用最新应用。';

  @override
  String get voiceRoomCapacityInvalid => '请输入 2 至 32 之间的整数。';

  @override
  String get forumSectionsTitle => '论坛版块与权限';

  @override
  String get forumSectionDefaults => '成员可以阅读、创建主题和回复；只读成员只能阅读。';

  @override
  String get forumSectionAccessHelp => '管理和读取权限允许关闭主题。设备需要管理访问权限。仅作为作者无法关闭主题。';

  @override
  String get forumSectionPrivacy => '论坛版块不支持公开预览和端到端加密。已归档版块为只读。';
}
