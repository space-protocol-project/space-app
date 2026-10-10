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
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');
}
