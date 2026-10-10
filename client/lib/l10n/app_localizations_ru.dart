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

  @override
  String get findSpace => 'Найдите своё пространство';

  @override
  String get closeConnection => 'Закрыть подключение';

  @override
  String get connectionIntro =>
      'Адрес независимого сервера. Сначала проверим его, затем вы решите, доверять ли ему.';

  @override
  String get serverAddress => 'Адрес сервера или ссылка приглашения';

  @override
  String get optionalInvite => 'Код приглашения (необязательно)';

  @override
  String get checkServer => 'Проверить сервер';

  @override
  String get verifyTrust => 'Проверка доверия';

  @override
  String get serverKeyFingerprint => 'Отпечаток серверного ключа';

  @override
  String get tlsCertificateFingerprint => 'Отпечаток TLS-сертификата';

  @override
  String get firstTrustHelp =>
      'При первом визите сравните адрес и отпечаток с известными данными владельца. Первый вход создаёт отдельные ключи для этого сервера.';

  @override
  String get readerInvitation => 'Приглашение: читатель — только чтение чата.';

  @override
  String get memberInvitation =>
      'Приглашение: участник — читать и писать в чате.';

  @override
  String get trustAndConnect => 'Доверять и подключиться';

  @override
  String get disconnectServer => 'Отключиться от сервера';

  @override
  String get supportedConnections =>
      'Поддерживаются публичные HTTPS-серверы и локальный HTTP. Карточку восстановления можно открыть в разделе «Идентичность».';

  @override
  String get chatDescription => 'Разговоры и маленькие открытия.';

  @override
  String get connectionInformation => 'Информация о подключении';

  @override
  String get channel => 'Канал';

  @override
  String get noReading => 'Нет чтения';

  @override
  String get refreshChat => 'Обновить каналы и чат';

  @override
  String get noMessageAccess => 'Нет доступа к сообщениям';

  @override
  String get startConversation => 'Начните разговор';

  @override
  String get conversationStarts => 'Здесь начинается разговор';

  @override
  String get contactOwner =>
      'Выберите другой канал или обратитесь к владельцу пространства.';

  @override
  String get emptyChat => 'В этом чате пока нет сообщений.';

  @override
  String get connectChatHelp =>
      'Подключите своё пространство. Ваши ключи останутся на этом устройстве.';

  @override
  String get you => 'Вы';

  @override
  String get newMessages => 'Новые сообщения';

  @override
  String get cannotSend => 'В этом канале нельзя отправлять сообщения';

  @override
  String get messageHint => 'Что у вас нового?';

  @override
  String get sendMessage => 'Отправить';

  @override
  String newMessagesCount(int count) {
    return 'Новые сообщения: $count';
  }

  @override
  String newChannelMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новых',
      many: '$count новых',
      few: '$count новых',
      one: '1 новое',
    );
    return '$_temp0';
  }

  @override
  String get homeTitle => 'Домашний сервер';

  @override
  String get close => 'Закрыть';

  @override
  String get homeFirstSetup =>
      'Space скачает сервер и PostgreSQL, создаст базу и сертификат. Данные останутся на этом компьютере.';

  @override
  String get homeReuse =>
      'Повторный запуск использует ваш прежний сервер, базу, ключи, сертификат и участников.';

  @override
  String get homeIP => 'Статический публичный IPv4';

  @override
  String get homeIPHint => 'Адрес, выданный провайдером';

  @override
  String get detectingIP => 'Определяем IP…';

  @override
  String get detectIP => 'Определить IP автоматически';

  @override
  String get homeIPPrivacy =>
      'Определение адреса обращается к ipify. При VPN будет показан адрес VPN.';

  @override
  String get homeIPFailed =>
      'Не удалось определить адрес. Введите свой статический IP.';

  @override
  String get homePortHelp =>
      'Для доступа друзей направьте TCP-порт 8443 роутера на порт 8443 этого компьютера и разрешите его в брандмауэре. PostgreSQL и локальные порты наружу открывать не нужно.';

  @override
  String get goLive => 'Выйти в эфир';

  @override
  String get stopHome => 'Отключиться';

  @override
  String get homeLink =>
      'Ссылка на ваш сервер (открывается через подключение в Space)';

  @override
  String get copyLink => 'Копировать ссылку';

  @override
  String get manageServer => 'Управлять сервером';

  @override
  String get homeInviteHelp =>
      'Сама ссылка не выдаёт права администратора. Друзей приглашайте через «Управление пространством → Приглашения». Остановка сервера завершит их подключения.';

  @override
  String get myHomeServer => 'Мой домашний сервер';

  @override
  String get homeRunningHelp =>
      'Сервер работает. После отключения все данные сохранятся.';

  @override
  String get homeStartHelp => 'Запустите своё пространство на этом компьютере.';

  @override
  String get myServer => 'Мой сервер';

  @override
  String get homeDetectingIP => 'Определяем публичный IP через ipify';

  @override
  String get homeDownloading => 'Скачиваем сервер и PostgreSQL';

  @override
  String get homeInstalling => 'Проверяем и устанавливаем выпуск';

  @override
  String get homeStarting => 'Запускаем сохранённый сервер';

  @override
  String get homeRunning => 'Сервер работает на этом компьютере';

  @override
  String get homeStopped => 'Сервер отключён, данные сохранены';
}
