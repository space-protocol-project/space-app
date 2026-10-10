// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get overview => 'Обзор';

  @override
  String get chat => 'Общий чат';

  @override
  String get forum => 'Обсуждения';

  @override
  String get feed => 'Лента';

  @override
  String get rooms => 'Встречи';

  @override
  String get identity => 'Идентичность';

  @override
  String get settings => 'Настройки';

  @override
  String get yourSpace => 'Ваше пространство';

  @override
  String get connected => 'Подключено';

  @override
  String get spaceDisconnected => 'Пространство не подключено';

  @override
  String get connection => 'Подключение';

  @override
  String get addSpace => 'Добавить пространство';

  @override
  String get chats => 'Чаты';

  @override
  String get channels => 'Каналы';

  @override
  String get recentSpaces => 'Недавние пространства';

  @override
  String get prototype => 'Локальный прототип · Windows';

  @override
  String get logo => 'Логотип Space';

  @override
  String get selectedSpace => 'Выбранное пространство';

  @override
  String get myIdentity => 'Моя идентичность';

  @override
  String get aboutSpace => 'О пространстве';

  @override
  String get independentServer =>
      'Независимый сервер. Ваши права и доступные разделы определяются отдельно в каждом пространстве.';

  @override
  String get deviceSignedIn => 'Вход по ключу устройства выполнен';

  @override
  String get noSession => 'Нет активной сессии';

  @override
  String get checkConnection => 'Проверить подключение';

  @override
  String get beYourself => 'Можно быть собой.';

  @override
  String get ownPace =>
      'Не обязательно отвечать сразу. Камера и микрофон не используются; системные уведомления пока выключены.';

  @override
  String get openNavigation => 'Открыть навигацию';

  @override
  String get reconnecting => 'Восстанавливаем соединение';

  @override
  String get keyLogin => 'Вход по ключу';

  @override
  String get disconnected => 'Не подключено';

  @override
  String get serverConnection => 'Подключение к серверу';

  @override
  String get appearanceSettings => 'Настройки оформления';

  @override
  String get welcome => 'Хорошо, что вы здесь.';

  @override
  String get welcomeDescription =>
      'Ваше пространство, ваши разговоры — в удобном темпе.';

  @override
  String get ideas => 'Место для идей.\nИ людей за ними.';

  @override
  String get connectDescription =>
      'Добавьте независимый сервер по адресу, проверьте доверие и продолжите разговор. Центральный аккаунт не нужен.';

  @override
  String get returnChat => 'Вернуться в разговор';

  @override
  String get yourConversation => 'Ваш разговор';

  @override
  String get noMessages =>
      'Пространство ещё не подключено. Здесь появятся реальные сообщения выбранного сервера.';

  @override
  String get openChat => 'Открыть чат';

  @override
  String get yourAttention => 'Ваше внимание';

  @override
  String get attentionDescription =>
      'Оболочка не отправляет системные уведомления и не включает камеру или микрофон. Можно оставаться в своём ритме.';

  @override
  String get settingsTitle => 'Пусть будет удобно вам.';

  @override
  String get settingsDescription =>
      'Личное оформление сохраняется на этом устройстве.';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get darkTheme => 'Тёмная тема';

  @override
  String get themeDescription => 'Gruvbox есть в светлом и тёмном вариантах.';

  @override
  String get compact => 'Компактный режим';

  @override
  String get compactDescription => 'Более плотные элементы управления.';

  @override
  String get myColors => 'Мои цвета';

  @override
  String get ocean => 'Тихий океан';

  @override
  String get iris => 'Мягкий ирис';

  @override
  String get spaceAppearance => 'Оформление пространства';

  @override
  String get spaceAppearanceDescription =>
      'Сервер сможет предложить цвета для своего пространства. До вашего согласия будет использоваться личная тема. Текущая версия ещё не получает такие предложения.';

  @override
  String get language => 'Язык приложения';

  @override
  String get searchHint => 'Разделы и загруженные сообщения';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get back => 'Вернуться';

  @override
  String get nothingFound => 'Ничего не найдено. Попробуйте другое слово.';

  @override
  String get appSection => 'Раздел приложения';

  @override
  String get loadedMessage => 'Общий чат · загруженное сообщение';

  @override
  String messageCount(int count) {
    return 'Сообщений в общем чате: $count';
  }

  @override
  String get revokeTitle => 'Отозвать это устройство?';

  @override
  String get revokeDescription =>
      'Доступ к выбранному серверу прекратится. Ключи останутся на компьютере; новое разрешение автоматически не создаётся.';

  @override
  String get keep => 'Оставить';

  @override
  String get revoke => 'Отозвать';

  @override
  String get archived => 'Архив';

  @override
  String get noReadAccess => 'Без доступа к сообщениям';

  @override
  String get manageSpace => 'Управление пространством';

  @override
  String get forumTitle => 'Хорошие разговоры остаются.';

  @override
  String get forumDescription =>
      'Место для обсуждений, которым нужно больше времени.';

  @override
  String get feedTitle => 'Немного вдохновения.';

  @override
  String get feedDescription => 'Публикации людей, которых вы выбрали.';

  @override
  String get search => 'Поиск';

  @override
  String get recoveringEvents =>
      'Восстанавливаем события. Сообщения и черновик сохранены.';

  @override
  String get chatTab => 'Чат';

  @override
  String get topicsTab => 'Темы';

  @override
  String get profileTab => 'Профиль';

  @override
  String unreadCount(int count) {
    return 'Непрочитанных сообщений: $count';
  }
}
