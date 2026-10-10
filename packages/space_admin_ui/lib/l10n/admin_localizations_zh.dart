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
  String get managementIntro => '您的服务器，您的规则。使用本地设置代码指定家庭服务器的所有者。';

  @override
  String get managementSections => '所选服务器的设置、频道、成员、邀请和设备。';

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
  String get authorizeDetails => '您明确允许此设备更改设置、频道及成员访问权限。';

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
  String get bothNames => '请输入两个名称';

  @override
  String get settingsConflict => '设置已更改。请重新加载后再修改。';

  @override
  String settingsRevision(String revision) {
    return '空间设置 · 版本 $revision';
  }
}
