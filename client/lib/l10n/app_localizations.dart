import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @overview.
  ///
  /// In ru, this message translates to:
  /// **'Обзор'**
  String get overview;

  /// No description provided for @chat.
  ///
  /// In ru, this message translates to:
  /// **'Общий чат'**
  String get chat;

  /// No description provided for @forum.
  ///
  /// In ru, this message translates to:
  /// **'Обсуждения'**
  String get forum;

  /// No description provided for @feed.
  ///
  /// In ru, this message translates to:
  /// **'Лента'**
  String get feed;

  /// No description provided for @rooms.
  ///
  /// In ru, this message translates to:
  /// **'Встречи'**
  String get rooms;

  /// No description provided for @identity.
  ///
  /// In ru, this message translates to:
  /// **'Мой доступ и устройства'**
  String get identity;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @yourSpace.
  ///
  /// In ru, this message translates to:
  /// **'Ваше пространство'**
  String get yourSpace;

  /// No description provided for @connected.
  ///
  /// In ru, this message translates to:
  /// **'Подключено'**
  String get connected;

  /// No description provided for @spaceDisconnected.
  ///
  /// In ru, this message translates to:
  /// **'Пространство не подключено'**
  String get spaceDisconnected;

  /// No description provided for @connection.
  ///
  /// In ru, this message translates to:
  /// **'Подключение'**
  String get connection;

  /// No description provided for @addSpace.
  ///
  /// In ru, this message translates to:
  /// **'Добавить пространство'**
  String get addSpace;

  /// No description provided for @chats.
  ///
  /// In ru, this message translates to:
  /// **'Чаты'**
  String get chats;

  /// No description provided for @channels.
  ///
  /// In ru, this message translates to:
  /// **'Каналы'**
  String get channels;

  /// No description provided for @recentSpaces.
  ///
  /// In ru, this message translates to:
  /// **'Недавние серверы'**
  String get recentSpaces;

  /// No description provided for @prototype.
  ///
  /// In ru, this message translates to:
  /// **'Локальный прототип · Windows'**
  String get prototype;

  /// No description provided for @logo.
  ///
  /// In ru, this message translates to:
  /// **'Логотип Space'**
  String get logo;

  /// No description provided for @selectedSpace.
  ///
  /// In ru, this message translates to:
  /// **'Выбранное пространство'**
  String get selectedSpace;

  /// No description provided for @myIdentity.
  ///
  /// In ru, this message translates to:
  /// **'Мой доступ и устройства'**
  String get myIdentity;

  /// No description provided for @aboutSpace.
  ///
  /// In ru, this message translates to:
  /// **'О пространстве'**
  String get aboutSpace;

  /// No description provided for @independentServer.
  ///
  /// In ru, this message translates to:
  /// **'Каналы и доступ задаёт этот сервер.'**
  String get independentServer;

  /// No description provided for @deviceSignedIn.
  ///
  /// In ru, this message translates to:
  /// **'Вход по ключу устройства выполнен'**
  String get deviceSignedIn;

  /// No description provided for @noSession.
  ///
  /// In ru, this message translates to:
  /// **'Нет активной сессии'**
  String get noSession;

  /// No description provided for @checkConnection.
  ///
  /// In ru, this message translates to:
  /// **'Проверить подключение'**
  String get checkConnection;

  /// No description provided for @beYourself.
  ///
  /// In ru, this message translates to:
  /// **'Можно быть собой.'**
  String get beYourself;

  /// No description provided for @ownPace.
  ///
  /// In ru, this message translates to:
  /// **'Камера и микрофон выключены.'**
  String get ownPace;

  /// No description provided for @openNavigation.
  ///
  /// In ru, this message translates to:
  /// **'Открыть навигацию'**
  String get openNavigation;

  /// No description provided for @reconnecting.
  ///
  /// In ru, this message translates to:
  /// **'Восстанавливаем соединение'**
  String get reconnecting;

  /// No description provided for @keyLogin.
  ///
  /// In ru, this message translates to:
  /// **'Вход по ключу'**
  String get keyLogin;

  /// No description provided for @disconnected.
  ///
  /// In ru, this message translates to:
  /// **'Не подключено'**
  String get disconnected;

  /// No description provided for @serverConnection.
  ///
  /// In ru, this message translates to:
  /// **'Подключение к серверу'**
  String get serverConnection;

  /// No description provided for @appearanceSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки оформления'**
  String get appearanceSettings;

  /// No description provided for @welcome.
  ///
  /// In ru, this message translates to:
  /// **'Ваше пространство'**
  String get welcome;

  /// No description provided for @welcomeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Каналы и ресурсы сервера.'**
  String get welcomeDescription;

  /// No description provided for @ideas.
  ///
  /// In ru, this message translates to:
  /// **'Место для идей.\nИ людей за ними.'**
  String get ideas;

  /// No description provided for @connectDescription.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте сервер по адресу или приглашению.'**
  String get connectDescription;

  /// No description provided for @returnChat.
  ///
  /// In ru, this message translates to:
  /// **'Вернуться в разговор'**
  String get returnChat;

  /// No description provided for @yourConversation.
  ///
  /// In ru, this message translates to:
  /// **'Ваш разговор'**
  String get yourConversation;

  /// No description provided for @noMessages.
  ///
  /// In ru, this message translates to:
  /// **'Подключитесь, чтобы открыть сообщения.'**
  String get noMessages;

  /// No description provided for @openChat.
  ///
  /// In ru, this message translates to:
  /// **'Открыть чат'**
  String get openChat;

  /// No description provided for @yourAttention.
  ///
  /// In ru, this message translates to:
  /// **'Ваше внимание'**
  String get yourAttention;

  /// No description provided for @attentionDescription.
  ///
  /// In ru, this message translates to:
  /// **'Оболочка не отправляет системные уведомления и не включает камеру или микрофон. Можно оставаться в своём ритме.'**
  String get attentionDescription;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки приложения'**
  String get settingsTitle;

  /// No description provided for @settingsDescription.
  ///
  /// In ru, this message translates to:
  /// **'Сохраняются на этом устройстве.'**
  String get settingsDescription;

  /// No description provided for @appearance.
  ///
  /// In ru, this message translates to:
  /// **'Внешний вид'**
  String get appearance;

  /// No description provided for @darkTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная тема'**
  String get darkTheme;

  /// No description provided for @themeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Gruvbox есть в светлом и тёмном вариантах.'**
  String get themeDescription;

  /// No description provided for @compact.
  ///
  /// In ru, this message translates to:
  /// **'Компактный режим'**
  String get compact;

  /// No description provided for @compactDescription.
  ///
  /// In ru, this message translates to:
  /// **'Более плотные элементы управления.'**
  String get compactDescription;

  /// No description provided for @myColors.
  ///
  /// In ru, this message translates to:
  /// **'Мои цвета'**
  String get myColors;

  /// No description provided for @ocean.
  ///
  /// In ru, this message translates to:
  /// **'Тихий океан'**
  String get ocean;

  /// No description provided for @iris.
  ///
  /// In ru, this message translates to:
  /// **'Мягкий ирис'**
  String get iris;

  /// No description provided for @spaceAppearance.
  ///
  /// In ru, this message translates to:
  /// **'Оформление пространства'**
  String get spaceAppearance;

  /// No description provided for @spaceAppearanceDescription.
  ///
  /// In ru, this message translates to:
  /// **'Сервер сможет предложить цвета для своего пространства. До вашего согласия будет использоваться личная тема. Текущая версия ещё не получает такие предложения.'**
  String get spaceAppearanceDescription;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык приложения'**
  String get language;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Разделы и загруженные сообщения'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get clearSearch;

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'Вернуться'**
  String get back;

  /// No description provided for @nothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено. Попробуйте другое слово.'**
  String get nothingFound;

  /// No description provided for @appSection.
  ///
  /// In ru, this message translates to:
  /// **'Раздел приложения'**
  String get appSection;

  /// No description provided for @loadedMessage.
  ///
  /// In ru, this message translates to:
  /// **'Общий чат · загруженное сообщение'**
  String get loadedMessage;

  /// No description provided for @messageCount.
  ///
  /// In ru, this message translates to:
  /// **'Сообщений в общем чате: {count}'**
  String messageCount(int count);

  /// No description provided for @revokeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать это устройство?'**
  String get revokeTitle;

  /// No description provided for @revokeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к выбранному серверу прекратится. Ключи останутся на компьютере; новое разрешение автоматически не создаётся.'**
  String get revokeDescription;

  /// No description provided for @keep.
  ///
  /// In ru, this message translates to:
  /// **'Оставить'**
  String get keep;

  /// No description provided for @revoke.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать'**
  String get revoke;

  /// No description provided for @archived.
  ///
  /// In ru, this message translates to:
  /// **'Архив'**
  String get archived;

  /// No description provided for @noReadAccess.
  ///
  /// In ru, this message translates to:
  /// **'Без доступа к сообщениям'**
  String get noReadAccess;

  /// No description provided for @manageSpace.
  ///
  /// In ru, this message translates to:
  /// **'Управление пространством'**
  String get manageSpace;

  /// No description provided for @forumTitle.
  ///
  /// In ru, this message translates to:
  /// **'Хорошие разговоры остаются.'**
  String get forumTitle;

  /// No description provided for @forumDescription.
  ///
  /// In ru, this message translates to:
  /// **'Место для обсуждений, которым нужно больше времени.'**
  String get forumDescription;

  /// No description provided for @feedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Немного вдохновения.'**
  String get feedTitle;

  /// No description provided for @feedDescription.
  ///
  /// In ru, this message translates to:
  /// **'Публикации людей, которых вы выбрали.'**
  String get feedDescription;

  /// No description provided for @search.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get search;

  /// No description provided for @recoveringEvents.
  ///
  /// In ru, this message translates to:
  /// **'Восстанавливаем события. Сообщения и черновик сохранены.'**
  String get recoveringEvents;

  /// No description provided for @chatTab.
  ///
  /// In ru, this message translates to:
  /// **'Чат'**
  String get chatTab;

  /// No description provided for @topicsTab.
  ///
  /// In ru, this message translates to:
  /// **'Темы'**
  String get topicsTab;

  /// No description provided for @profileTab.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTab;

  /// No description provided for @unreadCount.
  ///
  /// In ru, this message translates to:
  /// **'Непрочитанных сообщений: {count}'**
  String unreadCount(int count);

  /// No description provided for @findSpace.
  ///
  /// In ru, this message translates to:
  /// **'Найдите своё пространство'**
  String get findSpace;

  /// No description provided for @closeConnection.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть подключение'**
  String get closeConnection;

  /// No description provided for @connectionIntro.
  ///
  /// In ru, this message translates to:
  /// **'Введите адрес сервера или приглашение.'**
  String get connectionIntro;

  /// No description provided for @serverAddress.
  ///
  /// In ru, this message translates to:
  /// **'Адрес сервера или ссылка приглашения'**
  String get serverAddress;

  /// No description provided for @optionalInvite.
  ///
  /// In ru, this message translates to:
  /// **'Код приглашения (необязательно)'**
  String get optionalInvite;

  /// No description provided for @checkServer.
  ///
  /// In ru, this message translates to:
  /// **'Проверить сервер'**
  String get checkServer;

  /// No description provided for @verifyTrust.
  ///
  /// In ru, this message translates to:
  /// **'Проверка доверия'**
  String get verifyTrust;

  /// No description provided for @serverKeyFingerprint.
  ///
  /// In ru, this message translates to:
  /// **'Отпечаток серверного ключа'**
  String get serverKeyFingerprint;

  /// No description provided for @tlsCertificateFingerprint.
  ///
  /// In ru, this message translates to:
  /// **'Отпечаток TLS-сертификата'**
  String get tlsCertificateFingerprint;

  /// No description provided for @firstTrustHelp.
  ///
  /// In ru, this message translates to:
  /// **'При первом визите сравните адрес и отпечаток с известными данными владельца. Первый вход создаёт отдельные ключи для этого сервера.'**
  String get firstTrustHelp;

  /// No description provided for @readerInvitation.
  ///
  /// In ru, this message translates to:
  /// **'Приглашение: читатель — только чтение чата.'**
  String get readerInvitation;

  /// No description provided for @memberInvitation.
  ///
  /// In ru, this message translates to:
  /// **'Приглашение: участник — читать и писать в чате.'**
  String get memberInvitation;

  /// No description provided for @trustAndConnect.
  ///
  /// In ru, this message translates to:
  /// **'Доверять и подключиться'**
  String get trustAndConnect;

  /// No description provided for @disconnectServer.
  ///
  /// In ru, this message translates to:
  /// **'Отключиться от сервера'**
  String get disconnectServer;

  /// No description provided for @supportedConnections.
  ///
  /// In ru, this message translates to:
  /// **'Поддерживаются публичные HTTPS-серверы и локальный HTTP. Карточку восстановления можно открыть в разделе «Идентичность».'**
  String get supportedConnections;

  /// No description provided for @chatDescription.
  ///
  /// In ru, this message translates to:
  /// **'Разговоры и маленькие открытия.'**
  String get chatDescription;

  /// No description provided for @connectionInformation.
  ///
  /// In ru, this message translates to:
  /// **'Информация о подключении'**
  String get connectionInformation;

  /// No description provided for @channel.
  ///
  /// In ru, this message translates to:
  /// **'Канал'**
  String get channel;

  /// No description provided for @noReading.
  ///
  /// In ru, this message translates to:
  /// **'Нет чтения'**
  String get noReading;

  /// No description provided for @refreshChat.
  ///
  /// In ru, this message translates to:
  /// **'Обновить каналы и чат'**
  String get refreshChat;

  /// No description provided for @noMessageAccess.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступа к сообщениям'**
  String get noMessageAccess;

  /// No description provided for @startConversation.
  ///
  /// In ru, this message translates to:
  /// **'Начните разговор'**
  String get startConversation;

  /// No description provided for @conversationStarts.
  ///
  /// In ru, this message translates to:
  /// **'Здесь начинается разговор'**
  String get conversationStarts;

  /// No description provided for @contactOwner.
  ///
  /// In ru, this message translates to:
  /// **'Выберите другой канал или обратитесь к владельцу пространства.'**
  String get contactOwner;

  /// No description provided for @emptyChat.
  ///
  /// In ru, this message translates to:
  /// **'В этом чате пока нет сообщений.'**
  String get emptyChat;

  /// No description provided for @connectChatHelp.
  ///
  /// In ru, this message translates to:
  /// **'Подключите своё пространство. Ваши ключи останутся на этом устройстве.'**
  String get connectChatHelp;

  /// No description provided for @you.
  ///
  /// In ru, this message translates to:
  /// **'Вы'**
  String get you;

  /// No description provided for @newMessages.
  ///
  /// In ru, this message translates to:
  /// **'Новые сообщения'**
  String get newMessages;

  /// No description provided for @cannotSend.
  ///
  /// In ru, this message translates to:
  /// **'В этом канале нельзя отправлять сообщения'**
  String get cannotSend;

  /// No description provided for @messageHint.
  ///
  /// In ru, this message translates to:
  /// **'Что у вас нового?'**
  String get messageHint;

  /// No description provided for @sendMessage.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get sendMessage;

  /// No description provided for @newMessagesCount.
  ///
  /// In ru, this message translates to:
  /// **'Новые сообщения: {count}'**
  String newMessagesCount(int count);

  /// No description provided for @newChannelMessages.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{1 новое} few{{count} новых} many{{count} новых} other{{count} новых}}'**
  String newChannelMessages(int count);

  /// No description provided for @homeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Домашний сервер'**
  String get homeTitle;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @homeFirstSetup.
  ///
  /// In ru, this message translates to:
  /// **'Сервер и данные будут созданы на этом компьютере.'**
  String get homeFirstSetup;

  /// No description provided for @homeReuse.
  ///
  /// In ru, this message translates to:
  /// **'Ваш сервер и данные сохранены.'**
  String get homeReuse;

  /// No description provided for @homeIP.
  ///
  /// In ru, this message translates to:
  /// **'Статический публичный IPv4'**
  String get homeIP;

  /// No description provided for @homeIPHint.
  ///
  /// In ru, this message translates to:
  /// **'Адрес, выданный провайдером'**
  String get homeIPHint;

  /// No description provided for @detectingIP.
  ///
  /// In ru, this message translates to:
  /// **'Определяем IP…'**
  String get detectingIP;

  /// No description provided for @detectIP.
  ///
  /// In ru, this message translates to:
  /// **'Определить IP автоматически'**
  String get detectIP;

  /// No description provided for @homeIPPrivacy.
  ///
  /// In ru, this message translates to:
  /// **'Определение адреса обращается к ipify. При VPN будет показан адрес VPN.'**
  String get homeIPPrivacy;

  /// No description provided for @homeIPFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось определить адрес. Введите свой статический IP.'**
  String get homeIPFailed;

  /// No description provided for @homePortHelp.
  ///
  /// In ru, this message translates to:
  /// **'Для доступа друзей направьте TCP-порт 8443 роутера на порт 8443 этого компьютера и разрешите его в брандмауэре. PostgreSQL и локальные порты наружу открывать не нужно.'**
  String get homePortHelp;

  /// No description provided for @goLive.
  ///
  /// In ru, this message translates to:
  /// **'Выйти в эфир'**
  String get goLive;

  /// No description provided for @stopHome.
  ///
  /// In ru, this message translates to:
  /// **'Отключиться'**
  String get stopHome;

  /// No description provided for @homeLink.
  ///
  /// In ru, this message translates to:
  /// **'Ссылка на ваш сервер (открывается через подключение в Space)'**
  String get homeLink;

  /// No description provided for @copyLink.
  ///
  /// In ru, this message translates to:
  /// **'Копировать ссылку'**
  String get copyLink;

  /// No description provided for @manageServer.
  ///
  /// In ru, this message translates to:
  /// **'Управлять сервером'**
  String get manageServer;

  /// No description provided for @homeInviteHelp.
  ///
  /// In ru, this message translates to:
  /// **'Приглашения: «Управление пространством». При отключении участники потеряют соединение.'**
  String get homeInviteHelp;

  /// No description provided for @myHomeServer.
  ///
  /// In ru, this message translates to:
  /// **'Мой домашний сервер'**
  String get myHomeServer;

  /// No description provided for @homeRunningHelp.
  ///
  /// In ru, this message translates to:
  /// **'Сервер работает. После отключения все данные сохранятся.'**
  String get homeRunningHelp;

  /// No description provided for @homeStartHelp.
  ///
  /// In ru, this message translates to:
  /// **'Запустите своё пространство на этом компьютере.'**
  String get homeStartHelp;

  /// No description provided for @myServer.
  ///
  /// In ru, this message translates to:
  /// **'Выйти в эфир'**
  String get myServer;

  /// No description provided for @homeDetectingIP.
  ///
  /// In ru, this message translates to:
  /// **'Определяем публичный IP через ipify'**
  String get homeDetectingIP;

  /// No description provided for @homeDownloading.
  ///
  /// In ru, this message translates to:
  /// **'Скачиваем сервер и PostgreSQL'**
  String get homeDownloading;

  /// No description provided for @homeInstalling.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем и устанавливаем выпуск'**
  String get homeInstalling;

  /// No description provided for @homeUpdating.
  ///
  /// In ru, this message translates to:
  /// **'Проверка и обновление сервера'**
  String get homeUpdating;

  /// No description provided for @homeUpdate.
  ///
  /// In ru, this message translates to:
  /// **'Обновить сервер'**
  String get homeUpdate;

  /// No description provided for @homeReleaseChanges.
  ///
  /// In ru, this message translates to:
  /// **'Изменения выпуска'**
  String get homeReleaseChanges;

  /// No description provided for @managementTab.
  ///
  /// In ru, this message translates to:
  /// **'Управление'**
  String get managementTab;

  /// No description provided for @homeNoReleaseNotes.
  ///
  /// In ru, this message translates to:
  /// **'Описание изменений для этого выпуска не предоставлено.'**
  String get homeNoReleaseNotes;

  /// No description provided for @homeSpaceDetails.
  ///
  /// In ru, this message translates to:
  /// **'Нужно: {required} МиБ · доступно: {available} МиБ'**
  String homeSpaceDetails(String required, String available);

  /// No description provided for @failureHomeSpaceLow.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно свободного места для операции домашнего сервера. Освободите место и повторите попытку.'**
  String get failureHomeSpaceLow;

  /// No description provided for @failureHomeSpaceUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось проверить свободное место. Проверьте доступность диска и повторите попытку.'**
  String get failureHomeSpaceUnknown;

  /// No description provided for @homeResumeUpdate.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить обновление или восстановление'**
  String get homeResumeUpdate;

  /// No description provided for @homeUpdateConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Сервер будет временно отключён для участников. Перед миграциями создаётся резервная копия. После операции сервер останется выключенным: запустите его кнопкой «Выйти в эфир».'**
  String get homeUpdateConfirm;

  /// No description provided for @homeStarting.
  ///
  /// In ru, this message translates to:
  /// **'Запускаем сохранённый сервер'**
  String get homeStarting;

  /// No description provided for @homeRunning.
  ///
  /// In ru, this message translates to:
  /// **'Сервер работает на этом компьютере'**
  String get homeRunning;

  /// No description provided for @homeStopped.
  ///
  /// In ru, this message translates to:
  /// **'Сервер отключён, данные сохранены'**
  String get homeStopped;

  /// No description provided for @serverNowOnline.
  ///
  /// In ru, this message translates to:
  /// **'Сервер {server} сейчас онлайн.'**
  String serverNowOnline(String server);

  /// No description provided for @serverNowOffline.
  ///
  /// In ru, this message translates to:
  /// **'Соединение с сервером {server} потеряно.'**
  String serverNowOffline(String server);

  /// No description provided for @serverAvailabilityUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Доступность пока неизвестна'**
  String get serverAvailabilityUnknown;

  /// No description provided for @recoveryOperationFailed.
  ///
  /// In ru, this message translates to:
  /// **'Операция не завершена. Проверьте доступ, карточку и соединение.'**
  String get recoveryOperationFailed;

  /// No description provided for @recoveryFileLabel.
  ///
  /// In ru, this message translates to:
  /// **'Карточка Space'**
  String get recoveryFileLabel;

  /// No description provided for @recoveryFormat.
  ///
  /// In ru, this message translates to:
  /// **'Формат карточки'**
  String get recoveryFormat;

  /// No description provided for @recoveryFormatHelp.
  ///
  /// In ru, this message translates to:
  /// **'PNG содержит зашифрованный QR и подходит для печати. JSON — компактный резервный файл. Пароль храните отдельно.'**
  String get recoveryFormatHelp;

  /// No description provided for @recoveryPng.
  ///
  /// In ru, this message translates to:
  /// **'QR в PNG'**
  String get recoveryPng;

  /// No description provided for @recoveryCardSaved.
  ///
  /// In ru, this message translates to:
  /// **'Карточка сохранена. Проверьте её восстановлением на отдельном устройстве; файл и пароль храните раздельно.'**
  String get recoveryCardSaved;

  /// No description provided for @recoveryTooLarge.
  ///
  /// In ru, this message translates to:
  /// **'Карточка слишком большая'**
  String get recoveryTooLarge;

  /// No description provided for @recoveryReplaceWarning.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые здесь ключи для этого адреса будут заменены. Сначала сохраните их карточку, если это другая идентичность.'**
  String get recoveryReplaceWarning;

  /// No description provided for @recoveryConnectionDenied.
  ///
  /// In ru, this message translates to:
  /// **'Ключи сохранены, но сервер не разрешил подключение. Проверьте отзыв карточки, блокировку и доступность чата.'**
  String get recoveryConnectionDenied;

  /// No description provided for @recoveryRestored.
  ///
  /// In ru, this message translates to:
  /// **'Идентичность восстановлена с новым устройством. Проверьте список и отзовите потерянные устройства.'**
  String get recoveryRestored;

  /// No description provided for @rotationRenewConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Обновить истёкший запрос с теми же сохранёнными новыми ключами? Если сервер уже завершил переход, используйте завершение сохранённой смены.'**
  String get rotationRenewConfirm;

  /// No description provided for @rotationConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Сменить корневой ключ? Ваш ID, права и история сохранятся. Прежние устройства и карточки потеряют доступ. Новый секрет сначала сохраняется в защищённый журнал. После перехода обязательно сохраните новую карточку.'**
  String get rotationConfirm;

  /// No description provided for @rotationServerRequired.
  ///
  /// In ru, this message translates to:
  /// **'Сначала проверьте адрес прежнего сервера'**
  String get rotationServerRequired;

  /// No description provided for @rotationNotPending.
  ///
  /// In ru, this message translates to:
  /// **'Для этого сервера нет сохранённой смены ключа.'**
  String get rotationNotPending;

  /// No description provided for @rotationReconnect.
  ///
  /// In ru, this message translates to:
  /// **'Новый ключ сохранён. Проверьте доступность сервера и подключитесь повторно.'**
  String get rotationReconnect;

  /// No description provided for @rotationCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Корневой ключ сменён, прежний ID сохранён. Сохраните новую карточку; старые карточки и устройства больше не работают.'**
  String get rotationCompleted;

  /// No description provided for @recoveryRevokeCard.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать ключ восстановления? Карточка и все устройства, подключённые через неё, перестанут работать. Перед этим сохраните другой путь доступа.'**
  String get recoveryRevokeCard;

  /// No description provided for @recoveryRevokeDevice.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать это устройство? Его сессии и подписки завершатся.'**
  String get recoveryRevokeDevice;

  /// No description provided for @recoveryRevoked.
  ///
  /// In ru, this message translates to:
  /// **'Разрешение отозвано на сервере.'**
  String get recoveryRevoked;

  /// No description provided for @pairingAlreadyUsed.
  ///
  /// In ru, this message translates to:
  /// **'Код уже использован или отменён'**
  String get pairingAlreadyUsed;

  /// No description provided for @pairingManageRequest.
  ///
  /// In ru, this message translates to:
  /// **'Запрошено также управление пространством, если роль это разрешает.'**
  String get pairingManageRequest;

  /// No description provided for @pairingChatRequest.
  ///
  /// In ru, this message translates to:
  /// **'Запрошен доступ к чату с вашими правами.'**
  String get pairingChatRequest;

  /// No description provided for @pairingReady.
  ///
  /// In ru, this message translates to:
  /// **'Код появится также на новом устройстве. Введите показанный там код проверки перед выдачей подписи.'**
  String get pairingReady;

  /// No description provided for @pairingMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Коды проверки не совпадают. Не подтверждайте подключение.'**
  String get pairingMismatch;

  /// No description provided for @pairingSignConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Коды на двух устройствах совпадают? Выдать root-подпись для нового устройства с указанными правами?'**
  String get pairingSignConfirm;

  /// No description provided for @pairingSigned.
  ///
  /// In ru, this message translates to:
  /// **'Подпись выдана. Завершите вход на новом устройстве.'**
  String get pairingSigned;

  /// No description provided for @pairingStartFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось начать сопряжение. Проверьте сервер и доступность PostgreSQL.'**
  String get pairingStartFailed;

  /// No description provided for @pairingCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Сопряжение отменено'**
  String get pairingCancelled;

  /// No description provided for @pairingExpired.
  ///
  /// In ru, this message translates to:
  /// **'Код истёк, отменён или подтверждение не прошло проверку. Начните заново.'**
  String get pairingExpired;

  /// No description provided for @pairingCompareTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сверьте код на двух устройствах'**
  String get pairingCompareTitle;

  /// No description provided for @pairingMatches.
  ///
  /// In ru, this message translates to:
  /// **'Код совпадает'**
  String get pairingMatches;

  /// No description provided for @recoveryRestoreConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить идентичность на {origin}? Будет создан новый ключ этого устройства. {warning}'**
  String recoveryRestoreConfirm(String origin, String warning);

  /// No description provided for @pairingPrepareConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Подготовить подключение «{device}» к вашей идентичности? {request} Подпись ещё не выдаётся. Сначала сравните код на обоих экранах.'**
  String pairingPrepareConfirm(String device, String request);

  /// No description provided for @pairingAcceptConfirm.
  ///
  /// In ru, this message translates to:
  /// **'На подтверждающем устройстве должен отображаться код {code}. Совпадает? Сохранённая здесь идентичность для {origin} будет заменена; сначала сохраните её карточку, если это другой аккаунт.'**
  String pairingAcceptConfirm(String code, String origin);

  /// No description provided for @recoveryCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get recoveryCancel;

  /// No description provided for @dashboard.
  ///
  /// In ru, this message translates to:
  /// **'Сводка'**
  String get dashboard;

  /// No description provided for @dashboardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Все ваши пространства — рядом.'**
  String get dashboardTitle;

  /// No description provided for @dashboardDescription.
  ///
  /// In ru, this message translates to:
  /// **'Серверы, каналы и непрочитанные сообщения.'**
  String get dashboardDescription;

  /// No description provided for @dashboardServers.
  ///
  /// In ru, this message translates to:
  /// **'Серверы'**
  String get dashboardServers;

  /// No description provided for @dashboardOnline.
  ///
  /// In ru, this message translates to:
  /// **'Онлайн'**
  String get dashboardOnline;

  /// No description provided for @dashboardChannels.
  ///
  /// In ru, this message translates to:
  /// **'Доступные каналы'**
  String get dashboardChannels;

  /// No description provided for @dashboardUnread.
  ///
  /// In ru, this message translates to:
  /// **'Непрочитанные'**
  String get dashboardUnread;

  /// No description provided for @dashboardRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить сводку'**
  String get dashboardRefresh;

  /// No description provided for @dashboardEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте первое пространство'**
  String get dashboardEmpty;

  /// No description provided for @dashboardEmptyHelp.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте сервер или создайте свой.'**
  String get dashboardEmptyHelp;

  /// No description provided for @dashboardCatalogUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Подключитесь, чтобы загрузить каналы.'**
  String get dashboardCatalogUnknown;

  /// No description provided for @dashboardAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступен'**
  String get dashboardAvailable;

  /// No description provided for @dashboardUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Недоступен'**
  String get dashboardUnavailable;

  /// No description provided for @dashboardOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть пространство'**
  String get dashboardOpen;

  /// No description provided for @dashboardResourcesHelp.
  ///
  /// In ru, this message translates to:
  /// **'Сводка учитывает доступные вам каналы и непрочитанные сообщения. Данные недоступных серверов появятся после подключения.'**
  String get dashboardResourcesHelp;

  /// No description provided for @dashboardSpaces.
  ///
  /// In ru, this message translates to:
  /// **'Ваши пространства'**
  String get dashboardSpaces;

  /// No description provided for @failureCardCorrupt.
  ///
  /// In ru, this message translates to:
  /// **'Карточка повреждена или имеет неверный формат.'**
  String get failureCardCorrupt;

  /// No description provided for @failurePasswordInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен содержать не менее 12 символов и занимать не более 512 байт.'**
  String get failurePasswordInvalid;

  /// No description provided for @failureCardTooLarge.
  ///
  /// In ru, this message translates to:
  /// **'Карточка превышает допустимый размер.'**
  String get failureCardTooLarge;

  /// No description provided for @failureCardUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Формат или параметры шифрования карточки не поддерживаются.'**
  String get failureCardUnsupported;

  /// No description provided for @failureCardAuthentication.
  ///
  /// In ru, this message translates to:
  /// **'Неверный пароль или повреждённая карточка. Проверьте файл и пароль.'**
  String get failureCardAuthentication;

  /// No description provided for @failureReleaseInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Описание выпуска сервера не прошло проверку. Установка остановлена.'**
  String get failureReleaseInvalid;

  /// No description provided for @failurePlatformUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Для этой платформы ещё нет проверенного выпуска домашнего сервера.'**
  String get failurePlatformUnsupported;

  /// No description provided for @failureDownloadAddress.
  ///
  /// In ru, this message translates to:
  /// **'Адрес загрузки сервера не разрешён. Установка остановлена.'**
  String get failureDownloadAddress;

  /// No description provided for @failureDownloadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось скачать сервер. Проверьте соединение и повторите загрузку.'**
  String get failureDownloadFailed;

  /// No description provided for @failureRedirectLimit.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка содержит слишком много перенаправлений. Установка остановлена.'**
  String get failureRedirectLimit;

  /// No description provided for @failureReleaseSize.
  ///
  /// In ru, this message translates to:
  /// **'Сервер загрузился не полностью или размер выпуска не совпадает. Повторите загрузку.'**
  String get failureReleaseSize;

  /// No description provided for @failureHashMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Контрольная сумма выпуска не совпадает. Этот архив нельзя запускать.'**
  String get failureHashMismatch;

  /// No description provided for @failureArchiveInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Архив сервера содержит недопустимые пути, файлы или размеры. Установка остановлена.'**
  String get failureArchiveInvalid;

  /// No description provided for @failureExecutePermission.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось разрешить запуск сервера. Проверьте доступ к каталогу приложения.'**
  String get failureExecutePermission;

  /// No description provided for @failureHomeStartFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось запустить домашний сервер. Проверьте доступ к данным, свободные порты и параметры подключения.'**
  String get failureHomeStartFailed;

  /// No description provided for @failureHomeStopFailed.
  ///
  /// In ru, this message translates to:
  /// **'Сервер не подтвердил остановку всех процессов. Проверьте его состояние перед повторным запуском.'**
  String get failureHomeStopFailed;

  /// No description provided for @failureHomeUpdatePending.
  ///
  /// In ru, this message translates to:
  /// **'Обновление домашнего сервера не завершено. Сначала завершите обновление или восстановление; обычный запуск заблокирован.'**
  String get failureHomeUpdatePending;

  /// No description provided for @failureHomeJournalInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Журнал обновления повреждён или недоступен. Автоматическое продолжение заблокировано; нужна ручная проверка.'**
  String get failureHomeJournalInvalid;

  /// No description provided for @failureHomeBackupMissing.
  ///
  /// In ru, this message translates to:
  /// **'Резервная копия отсутствует. Автоматическое восстановление заблокировано.'**
  String get failureHomeBackupMissing;

  /// No description provided for @failureHomeBackupInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Резервная копия повреждена, неполна или недоступна. Текущие данные не заменены.'**
  String get failureHomeBackupInvalid;

  /// No description provided for @failureHomeRecoveryInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Контрольная запись или каталоги восстановления не соответствуют исходной базе. Переключение заблокировано.'**
  String get failureHomeRecoveryInvalid;

  /// No description provided for @homeRecoveryHelp.
  ///
  /// In ru, this message translates to:
  /// **'Сохраните каталог home-server целиком, включая журнал, backups, recoveries и failed-data. Не удаляйте журнал и не заменяйте базу вручную. Откройте инструкцию восстановления.'**
  String get homeRecoveryHelp;

  /// No description provided for @homeRecoveryGuide.
  ///
  /// In ru, this message translates to:
  /// **'Инструкция восстановления'**
  String get homeRecoveryGuide;

  /// No description provided for @homeRecoveryGuideFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть инструкцию восстановления.'**
  String get homeRecoveryGuideFailed;

  /// No description provided for @homeRecoveryCopy.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать сведения'**
  String get homeRecoveryCopy;

  /// No description provided for @failureHomeUpdateFailed.
  ///
  /// In ru, this message translates to:
  /// **'Обновление не выполнено. Проверьте состояние операции и повторите попытку; новая версия не будет запущена без проверки.'**
  String get failureHomeUpdateFailed;

  /// No description provided for @failurePermissionDenied.
  ///
  /// In ru, this message translates to:
  /// **'Сервер отказал в доступе. Проверьте роль, блокировку и приглашение.'**
  String get failurePermissionDenied;

  /// No description provided for @failureUnauthenticated.
  ///
  /// In ru, this message translates to:
  /// **'Сессия или разрешение устройства недействительны. Войдите заново; новое разрешение автоматически не создаётся.'**
  String get failureUnauthenticated;

  /// No description provided for @failureServerLimit.
  ///
  /// In ru, this message translates to:
  /// **'Достигнут лимит сервера. Попробуйте позже.'**
  String get failureServerLimit;

  /// No description provided for @failureConnectionFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось связаться с сервером. Проверьте адрес и сеть.'**
  String get failureConnectionFailed;

  /// No description provided for @failureTlsRejected.
  ///
  /// In ru, this message translates to:
  /// **'Защищённое соединение не прошло проверку. Проверьте сертификат и доверенный отпечаток.'**
  String get failureTlsRejected;

  /// No description provided for @failureProtocolInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Сервер вернул несовместимые или некорректные данные. Операция остановлена.'**
  String get failureProtocolInvalid;

  /// No description provided for @failureIdentityInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Проверка ключей, подписей или идентичности не пройдена. Операция остановлена.'**
  String get failureIdentityInvalid;

  /// No description provided for @failureAddressInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Укажите HTTPS-адрес сервера или локальный HTTP-адрес. Проверьте ссылку и код приглашения.'**
  String get failureAddressInvalid;

  /// No description provided for @failureOperationFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось выполнить операцию. Проверьте соединение и доступ к защищённому хранилищу.'**
  String get failureOperationFailed;

  /// No description provided for @failureRetrySameRequest.
  ///
  /// In ru, this message translates to:
  /// **'Повтор с тем же текстом использует прежний ключ запроса.'**
  String get failureRetrySameRequest;

  /// No description provided for @failurePositionsLoad.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить позиции чтения. История будет загружена заново.'**
  String get failurePositionsLoad;

  /// No description provided for @failurePositionsSave.
  ///
  /// In ru, this message translates to:
  /// **'Позиция чтения обновлена, но сохранить её на устройстве не удалось.'**
  String get failurePositionsSave;

  /// No description provided for @failureChannelChanged.
  ///
  /// In ru, this message translates to:
  /// **'Права канала изменились. Обновите чат перед повтором.'**
  String get failureChannelChanged;

  /// No description provided for @failureChannelUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к этому каналу изменён. Выберите доступный чат.'**
  String get failureChannelUnavailable;

  /// No description provided for @failureEventsUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Сервер пока не поддерживает подписку событий. Обновите сервер.'**
  String get failureEventsUnsupported;

  /// No description provided for @failureCursorRejected.
  ///
  /// In ru, this message translates to:
  /// **'Сервер не принял курсор истории. Подключитесь заново для загрузки сообщений.'**
  String get failureCursorRejected;

  /// No description provided for @failureDeviceRevoked.
  ///
  /// In ru, this message translates to:
  /// **'Доступ этого устройства отозван. Ключи сохранены; новое разрешение автоматически не создаётся.'**
  String get failureDeviceRevoked;

  /// No description provided for @failureQrTooLarge.
  ///
  /// In ru, this message translates to:
  /// **'Карточка слишком большая для QR; сохраните JSON.'**
  String get failureQrTooLarge;

  /// No description provided for @failureQrFileTooLarge.
  ///
  /// In ru, this message translates to:
  /// **'Файл превышает допустимый размер: PNG — 8 МиБ, JSON — 16 КиБ.'**
  String get failureQrFileTooLarge;

  /// No description provided for @failureQrImageInvalid.
  ///
  /// In ru, this message translates to:
  /// **'PNG повреждён или имеет недопустимый размер. Нужен исходный файл от 64 до 2048 пикселей по каждой стороне.'**
  String get failureQrImageInvalid;

  /// No description provided for @failureQrUnreadable.
  ///
  /// In ru, this message translates to:
  /// **'QR не прочитан или не является карточкой Space. Выберите исходный PNG с белыми полями.'**
  String get failureQrUnreadable;

  /// No description provided for @failureKeyStorageMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Запись ключей принадлежит другому адресу. Операция остановлена.'**
  String get failureKeyStorageMismatch;

  /// No description provided for @failureKeyStorageSave.
  ///
  /// In ru, this message translates to:
  /// **'Защищённое хранилище не подтвердило сохранение ключей. Ротация не отправляется без сохранённого ключа.'**
  String get failureKeyStorageSave;

  /// No description provided for @failureKeyJournalInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Журнал смены ключа повреждён или превышает 64 КиБ. Проверьте защищённое хранилище.'**
  String get failureKeyJournalInvalid;

  /// No description provided for @failureCameraDenied.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к камере запрещён. Разрешите его в настройках системы.'**
  String get failureCameraDenied;

  /// No description provided for @failureCameraUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Камера недоступна или занята. Можно восстановиться из PNG или JSON.'**
  String get failureCameraUnavailable;

  /// No description provided for @failureCameraFrame.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать кадр. Проверьте камеру или выберите файл.'**
  String get failureCameraFrame;

  /// No description provided for @failureCameraStopped.
  ///
  /// In ru, this message translates to:
  /// **'Камера остановлена. Нажмите «Включить снова».'**
  String get failureCameraStopped;

  /// No description provided for @sendingMessage.
  ///
  /// In ru, this message translates to:
  /// **'Отправляется…'**
  String get sendingMessage;

  /// No description provided for @messageUnconfirmed.
  ///
  /// In ru, this message translates to:
  /// **'Нет подтверждения сервера. Повторите отправку с тем же текстом.'**
  String get messageUnconfirmed;

  /// No description provided for @messageAccepted.
  ///
  /// In ru, this message translates to:
  /// **'Принято сервером'**
  String get messageAccepted;

  /// No description provided for @appSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки приложения'**
  String get appSettings;

  /// No description provided for @serverSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки сервера'**
  String get serverSettings;

  /// No description provided for @homeStopping.
  ///
  /// In ru, this message translates to:
  /// **'Отключаем сервер и базу данных…'**
  String get homeStopping;

  /// No description provided for @homeProgressHint.
  ///
  /// In ru, this message translates to:
  /// **'Готовность по этапам. Точное время ожидания процесса заранее неизвестно.'**
  String get homeProgressHint;

  /// No description provided for @homeProgressElapsed.
  ///
  /// In ru, this message translates to:
  /// **'Прошло: {seconds} с'**
  String homeProgressElapsed(int seconds);

  /// No description provided for @homeDownloadEstimate.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка: примерно {seconds} с осталось'**
  String homeDownloadEstimate(int seconds);

  /// No description provided for @identityDescription.
  ///
  /// In ru, this message translates to:
  /// **'Ключи, разрешения и восстановление доступа в выбранном пространстве.'**
  String get identityDescription;

  /// No description provided for @sendShortcutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клавиша отправки'**
  String get sendShortcutTitle;

  /// No description provided for @sendShortcutHelp.
  ///
  /// In ru, this message translates to:
  /// **'Выберите Enter или Shift+Enter для отправки. Другая комбинация добавляет новую строку.'**
  String get sendShortcutHelp;

  /// No description provided for @createOwnSpace.
  ///
  /// In ru, this message translates to:
  /// **'Создать пространство'**
  String get createOwnSpace;

  /// No description provided for @setupSpaceName.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get setupSpaceName;

  /// No description provided for @setupResources.
  ///
  /// In ru, this message translates to:
  /// **'Разделы'**
  String get setupResources;

  /// No description provided for @setupComingSoon.
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get setupComingSoon;

  /// No description provided for @setupInternetHelp.
  ///
  /// In ru, this message translates to:
  /// **'Для друзей: публичный IPv4 и проброс TCP 8443.'**
  String get setupInternetHelp;

  /// No description provided for @setupReady.
  ///
  /// In ru, this message translates to:
  /// **'Пространство готово'**
  String get setupReady;

  /// No description provided for @setupInviteHelp.
  ///
  /// In ru, this message translates to:
  /// **'Одноразовое приглашение · 24 часа. Новые — в управлении.'**
  String get setupInviteHelp;

  /// No description provided for @setupWorking.
  ///
  /// In ru, this message translates to:
  /// **'Создаём пространство…'**
  String get setupWorking;

  /// No description provided for @setupBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get setupBack;

  /// No description provided for @setupNext.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get setupNext;

  /// No description provided for @setupOwnerRequired.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось подключиться владельцем. Откройте «Выйти в эфир» и проверьте состояние сервера.'**
  String get setupOwnerRequired;

  /// No description provided for @setupUpdateRequired.
  ///
  /// In ru, this message translates to:
  /// **'Для настройки иконки сначала обновите домашний сервер.'**
  String get setupUpdateRequired;

  /// No description provided for @myDevice.
  ///
  /// In ru, this message translates to:
  /// **'Моё устройство'**
  String get myDevice;

  /// No description provided for @myDeviceDescription.
  ///
  /// In ru, this message translates to:
  /// **'Идентичности и ключи этого устройства.'**
  String get myDeviceDescription;

  /// No description provided for @myDeviceStorage.
  ///
  /// In ru, this message translates to:
  /// **'Ключи — в защищённом хранилище устройства.'**
  String get myDeviceStorage;

  /// No description provided for @myDeviceAccessHelp.
  ///
  /// In ru, this message translates to:
  /// **'Выберите идентичность для QR, восстановления и сопряжения.'**
  String get myDeviceAccessHelp;

  /// No description provided for @deviceIdentityChoice.
  ///
  /// In ru, this message translates to:
  /// **'Идентичность на этом устройстве'**
  String get deviceIdentityChoice;

  /// No description provided for @deviceConnectIdentity.
  ///
  /// In ru, this message translates to:
  /// **'Подключить идентичность'**
  String get deviceConnectIdentity;

  /// No description provided for @recoveryReadingFile.
  ///
  /// In ru, this message translates to:
  /// **'Чтение файла…'**
  String get recoveryReadingFile;

  /// No description provided for @recoveryDecryptingCard.
  ///
  /// In ru, this message translates to:
  /// **'Расшифровка и проверка ключей…'**
  String get recoveryDecryptingCard;

  /// No description provided for @recoveryCheckingServer.
  ///
  /// In ru, this message translates to:
  /// **'Проверка сервера…'**
  String get recoveryCheckingServer;

  /// No description provided for @recoveryConnectingDevice.
  ///
  /// In ru, this message translates to:
  /// **'Подключение устройства…'**
  String get recoveryConnectingDevice;

  /// No description provided for @recoveryChooseFile.
  ///
  /// In ru, this message translates to:
  /// **'Выберите карточку PNG или JSON'**
  String get recoveryChooseFile;

  /// No description provided for @recoveryParentFolder.
  ///
  /// In ru, this message translates to:
  /// **'Папка выше'**
  String get recoveryParentFolder;

  /// No description provided for @recoveryFilePath.
  ///
  /// In ru, this message translates to:
  /// **'Полный путь к файлу'**
  String get recoveryFilePath;

  /// No description provided for @recoveryOpenFile.
  ///
  /// In ru, this message translates to:
  /// **'Открыть файл'**
  String get recoveryOpenFile;

  /// No description provided for @recoveryFolderUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать папку. Укажите полный путь к файлу.'**
  String get recoveryFolderUnavailable;

  /// No description provided for @setupExisting.
  ///
  /// In ru, this message translates to:
  /// **'Настройка вашего сохранённого пространства.'**
  String get setupExisting;

  /// No description provided for @recoveryGeneratingQr.
  ///
  /// In ru, this message translates to:
  /// **'Создаём QR…'**
  String get recoveryGeneratingQr;

  /// No description provided for @recoverySaveQr.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить QR'**
  String get recoverySaveQr;

  /// No description provided for @recoveryOverwriteQr.
  ///
  /// In ru, this message translates to:
  /// **'Заменить существующий файл QR-карточки?'**
  String get recoveryOverwriteQr;

  /// No description provided for @serverSearch.
  ///
  /// In ru, this message translates to:
  /// **'Найти пространство'**
  String get serverSearch;

  /// No description provided for @serverFilterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get serverFilterAll;

  /// No description provided for @serverNoEvents.
  ///
  /// In ru, this message translates to:
  /// **'Нет загруженных сообщений'**
  String get serverNoEvents;

  /// No description provided for @serverOffline.
  ///
  /// In ru, this message translates to:
  /// **'Офлайн'**
  String get serverOffline;

  /// No description provided for @removeServer.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из приложения'**
  String get removeServer;

  /// No description provided for @removeServerConfirm.
  ///
  /// In ru, this message translates to:
  /// **'История на этом устройстве будет удалена. Сервер можно добавить снова.'**
  String get removeServerConfirm;

  /// No description provided for @serverAccessRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Доступ отозван. Сервер убран.'**
  String get serverAccessRemoved;

  /// No description provided for @serverRemoveFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось убрать сервер. Повторите.'**
  String get serverRemoveFailed;

  /// No description provided for @serverInAir.
  ///
  /// In ru, this message translates to:
  /// **'Сервер в эфире'**
  String get serverInAir;

  /// No description provided for @serverNoChannels.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных каналов'**
  String get serverNoChannels;

  /// No description provided for @spacesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пространства'**
  String get spacesTitle;

  /// No description provided for @updatesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновления'**
  String get updatesTitle;

  /// No description provided for @updatesCheck.
  ///
  /// In ru, this message translates to:
  /// **'Проверить обновления'**
  String get updatesCheck;

  /// No description provided for @updatesChecking.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем…'**
  String get updatesChecking;

  /// No description provided for @updatesCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Установлена актуальная версия'**
  String get updatesCurrent;

  /// No description provided for @updatesAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступна версия {version}'**
  String updatesAvailable(String version);

  /// No description provided for @updatesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Опубликованных сборок пока нет'**
  String get updatesEmpty;

  /// No description provided for @updatesFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось проверить. Повторите.'**
  String get updatesFailed;

  /// No description provided for @updatesOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть выпуск'**
  String get updatesOpen;

  /// No description provided for @updatesChanges.
  ///
  /// In ru, this message translates to:
  /// **'Изменения'**
  String get updatesChanges;

  /// No description provided for @updatesInstalled.
  ///
  /// In ru, this message translates to:
  /// **'Версия {version}'**
  String updatesInstalled(String version);

  /// No description provided for @updatesUnknownVersion.
  ///
  /// In ru, this message translates to:
  /// **'Версия недоступна'**
  String get updatesUnknownVersion;

  /// No description provided for @updatesOpenFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть страницу выпуска'**
  String get updatesOpenFailed;

  /// No description provided for @updatesPackageUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Для этой системы пакет пока недоступен.'**
  String get updatesPackageUnavailable;

  /// No description provided for @updatesPackage.
  ///
  /// In ru, this message translates to:
  /// **'{platform} · {size} МБ'**
  String updatesPackage(String platform, String size);

  /// No description provided for @updatesDownload.
  ///
  /// In ru, this message translates to:
  /// **'Скачать'**
  String get updatesDownload;

  /// No description provided for @updatesDownloadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось скачать. Повторите загрузку.'**
  String get updatesDownloadFailed;

  /// No description provided for @updatesDownloaded.
  ///
  /// In ru, this message translates to:
  /// **'Пакет скачан и проверен.'**
  String get updatesDownloaded;

  /// No description provided for @updatesInstall.
  ///
  /// In ru, this message translates to:
  /// **'Установить и перезапустить'**
  String get updatesInstall;

  /// No description provided for @updatesPreparing.
  ///
  /// In ru, this message translates to:
  /// **'Завершаем операции и останавливаем домашний сервер…'**
  String get updatesPreparing;

  /// No description provided for @updatesInstallFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось начать установку. Проверьте отправку сообщений и состояние домашнего сервера, затем повторите.'**
  String get updatesInstallFailed;

  /// No description provided for @updatesHomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Домашний сервер'**
  String get updatesHomeTitle;

  /// No description provided for @updatesHomeResume.
  ///
  /// In ru, this message translates to:
  /// **'Перед обновлением домашний сервер работал. Запустить его снова?'**
  String get updatesHomeResume;

  /// No description provided for @updatesLater.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get updatesLater;

  /// No description provided for @updatesHomeStart.
  ///
  /// In ru, this message translates to:
  /// **'Запустить'**
  String get updatesHomeStart;

  /// No description provided for @addFavorite.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в избранное'**
  String get addFavorite;

  /// No description provided for @removeFavorite.
  ///
  /// In ru, this message translates to:
  /// **'Удалить из избранного'**
  String get removeFavorite;

  /// No description provided for @favoriteMessages.
  ///
  /// In ru, this message translates to:
  /// **'Избранные сообщения'**
  String get favoriteMessages;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
