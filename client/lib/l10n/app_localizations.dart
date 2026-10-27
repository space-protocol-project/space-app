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

  /// No description provided for @voiceShortcutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клавиши рации'**
  String get voiceShortcutTitle;

  /// No description provided for @voiceShortcutScope.
  ///
  /// In ru, this message translates to:
  /// **'Действуют в активном окне. При потере фокуса передача закрывается.'**
  String get voiceShortcutScope;

  /// No description provided for @voiceShortcutPress.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите клавишу или сочетание с Ctrl, Alt, Shift или Meta. Отпустите клавиши перед сохранением. Escape — отмена.'**
  String get voiceShortcutPress;

  /// No description provided for @voiceShortcutSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get voiceShortcutSave;

  /// No description provided for @deviceTransferTitle.
  ///
  /// In ru, this message translates to:
  /// **'Перенос устройства'**
  String get deviceTransferTitle;

  /// No description provided for @deviceTransferHelp.
  ///
  /// In ru, this message translates to:
  /// **'Два шага: сохраните один зашифрованный архив, затем перетащите его сюда на новом устройстве. Пространства, ключи, история, очереди, черновики, настройки и домашний Эфир переносятся вместе.'**
  String get deviceTransferHelp;

  /// No description provided for @deviceTransferExport.
  ///
  /// In ru, this message translates to:
  /// **'Полный перенос'**
  String get deviceTransferExport;

  /// No description provided for @deviceTransferExportHelp.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить устройство целиком в один файл'**
  String get deviceTransferExportHelp;

  /// No description provided for @deviceTransferRestore.
  ///
  /// In ru, this message translates to:
  /// **'Полное восстановление'**
  String get deviceTransferRestore;

  /// No description provided for @deviceTransferRestoreHelp.
  ///
  /// In ru, this message translates to:
  /// **'Перетащите архив сюда или нажмите, чтобы выбрать файл'**
  String get deviceTransferRestoreHelp;

  /// No description provided for @deviceTransferOneFile.
  ///
  /// In ru, this message translates to:
  /// **'Перетащите один файл полного переноса устройства.'**
  String get deviceTransferOneFile;

  /// No description provided for @deviceTransferPasswordHelp.
  ///
  /// In ru, this message translates to:
  /// **'Пароль архива может быть любым, в том числе пустым. Полный перенос остановит все пространства и домашний сервер на исходном устройстве после проверки архива. Сохраните архив и пароль вне диска ОС. Восстановление выполняется в новой установке; после него перезапустите приложение. Не восстанавливайте один архив на нескольких устройствах. Для следующего переноса после продолжения переписки нужен новый архив.'**
  String get deviceTransferPasswordHelp;

  /// No description provided for @deviceTransferFinished.
  ///
  /// In ru, this message translates to:
  /// **'Сохраните архив и пароль. Закройте приложение; после восстановления откройте его заново. Прежнее устройство не используйте для продолжения переписки.'**
  String get deviceTransferFinished;

  /// No description provided for @deviceTransferClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть приложение'**
  String get deviceTransferClose;

  /// No description provided for @failureConflict.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение уже изменено. Закройте редактор и откройте актуальную версию; ваш текст можно скопировать перед закрытием.'**
  String get failureConflict;

  /// No description provided for @messageDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение удалено'**
  String get messageDeleted;

  /// No description provided for @messageEdited.
  ///
  /// In ru, this message translates to:
  /// **'изменено'**
  String get messageEdited;

  /// No description provided for @messageActions.
  ///
  /// In ru, this message translates to:
  /// **'Действия с сообщением'**
  String get messageActions;

  /// No description provided for @editMessage.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get editMessage;

  /// No description provided for @deleteMessage.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get deleteMessage;

  /// No description provided for @deleteMessageConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить сообщение для всех участников? Это действие нельзя отменить.'**
  String get deleteMessageConfirm;

  /// No description provided for @saveMessage.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get saveMessage;

  /// No description provided for @cancelMessageChange.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancelMessageChange;

  /// No description provided for @messageText.
  ///
  /// In ru, this message translates to:
  /// **'Текст сообщения'**
  String get messageText;

  /// No description provided for @messageTextInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите текст длиной до 4096 байт.'**
  String get messageTextInvalid;

  /// No description provided for @interfaceScale.
  ///
  /// In ru, this message translates to:
  /// **'Масштаб интерфейса'**
  String get interfaceScale;

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
  /// **'Комнаты'**
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
  /// **'Чаты'**
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
  /// **'Чаты и доступ задаёт этот сервер.'**
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

  /// No description provided for @closeNavigation.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть навигацию'**
  String get closeNavigation;

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
  /// **'Чаты и ресурсы сервера.'**
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
  /// **'Уведомления можно включить в настройках приложения. Камера и микрофон включаются только по вашему действию.'**
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
  /// **'Лента пространства'**
  String get feedTitle;

  /// No description provided for @feedDescription.
  ///
  /// In ru, this message translates to:
  /// **'Новости и публикации участников этого пространства.'**
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
  /// **'Чат'**
  String get channel;

  /// No description provided for @noReading.
  ///
  /// In ru, this message translates to:
  /// **'Нет чтения'**
  String get noReading;

  /// No description provided for @refreshChat.
  ///
  /// In ru, this message translates to:
  /// **'Обновить чаты и чат'**
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
  /// **'Выберите другой чат или обратитесь к владельцу пространства.'**
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
  /// **'В этом чате нельзя отправлять сообщения'**
  String get cannotSend;

  /// No description provided for @messageHint.
  ///
  /// In ru, this message translates to:
  /// **''**
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
  /// **'Эфир'**
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

  /// No description provided for @rotationDevicesReview.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте устройства, которым будет сохранён доступ. Если устройство неизвестно, отмените операцию и сначала отзовите его разрешение.'**
  String get rotationDevicesReview;

  /// No description provided for @rotationConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Сменить корневой ключ? ID, права, история и подтверждённые действующие устройства сохранятся без продления доступа. Старые сеансы и карточки восстановления перестанут действовать. Новый секрет сначала сохраняется в защищённый журнал. После перехода сохраните новую карточку.'**
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
  /// **'Корневой ключ сменён, ID и подтверждённые устройства сохранены. Сохраните новую карточку; прежние карточки больше не действуют.'**
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
  /// **'Серверы, чаты и непрочитанные сообщения.'**
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
  /// **'Доступные чаты'**
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
  /// **'Подключитесь, чтобы загрузить чаты.'**
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
  /// **'Сводка учитывает доступные вам чаты и непрочитанные сообщения. Данные недоступных серверов появятся после подключения.'**
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
  /// **'Права чата изменились. Обновите чат перед повтором.'**
  String get failureChannelChanged;

  /// No description provided for @failureChannelUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к этому чату изменён. Выберите доступный чат.'**
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
  /// **'Нет подтверждения сервера. Запрос сохранён в очереди.'**
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

  /// No description provided for @hotkeysTitle.
  ///
  /// In ru, this message translates to:
  /// **'Горячие клавиши'**
  String get hotkeysTitle;

  /// No description provided for @resetShortcut.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть Enter по умолчанию'**
  String get resetShortcut;

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
  /// **'Устройство'**
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
  /// **'Нет доступных чатов'**
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
  /// **'Эфир'**
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

  /// No description provided for @failureConnectRequired.
  ///
  /// In ru, this message translates to:
  /// **'Нужен сервер с поддержкой ConnectRPC. Обновите домашний runtime или обратитесь к владельцу пространства.'**
  String get failureConnectRequired;

  /// No description provided for @spaceQrCamera.
  ///
  /// In ru, this message translates to:
  /// **'Сканировать QR'**
  String get spaceQrCamera;

  /// No description provided for @spaceQrImage.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать изображение QR'**
  String get spaceQrImage;

  /// No description provided for @spaceQrInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать QR со ссылкой на пространство.'**
  String get spaceQrInvalid;

  /// No description provided for @homeExport.
  ///
  /// In ru, this message translates to:
  /// **'Экспортировать пространство'**
  String get homeExport;

  /// No description provided for @homeImport.
  ///
  /// In ru, this message translates to:
  /// **'Импортировать пространство'**
  String get homeImport;

  /// No description provided for @homeTransferHelp.
  ///
  /// In ru, this message translates to:
  /// **'Архив содержит сообщения, настройки и ключи сервера. Храните его в тайне и импортируйте только свой архив. На время экспорта сервер остановится; импорт не заменяет существующее пространство. При смене IP сохранятся идентичность пространства и TLS-отпечаток. На новом компьютере отдельно восстановите карточку владельца.'**
  String get homeTransferHelp;

  /// No description provided for @homeImportIP.
  ///
  /// In ru, this message translates to:
  /// **'Новый публичный IPv4 (пусто — сохранить прежний)'**
  String get homeImportIP;

  /// No description provided for @homeExported.
  ///
  /// In ru, this message translates to:
  /// **'Пространство экспортировано'**
  String get homeExported;

  /// No description provided for @homeImported.
  ///
  /// In ru, this message translates to:
  /// **'Пространство импортировано. Теперь можно запустить сервер.'**
  String get homeImported;

  /// No description provided for @homeTransferring.
  ///
  /// In ru, this message translates to:
  /// **'Перенос пространства'**
  String get homeTransferring;

  /// No description provided for @homeTransferFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть архив или завершить перенос.'**
  String get homeTransferFailed;

  /// No description provided for @glassEffects.
  ///
  /// In ru, this message translates to:
  /// **'Эффекты стекла'**
  String get glassEffects;

  /// No description provided for @glassEffectsHelp.
  ///
  /// In ru, this message translates to:
  /// **'Размытие плавающих панелей и заголовка.'**
  String get glassEffectsHelp;

  /// No description provided for @attachFiles.
  ///
  /// In ru, this message translates to:
  /// **'Прикрепить файлы'**
  String get attachFiles;

  /// No description provided for @myFiles.
  ///
  /// In ru, this message translates to:
  /// **'Мои файлы'**
  String get myFiles;

  /// No description provided for @removeFile.
  ///
  /// In ru, this message translates to:
  /// **'Убрать файл'**
  String get removeFile;

  /// No description provided for @cancelUpload.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancelUpload;

  /// No description provided for @downloadFile.
  ///
  /// In ru, this message translates to:
  /// **'Скачать файл'**
  String get downloadFile;

  /// No description provided for @downloadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось скачать файл'**
  String get downloadFailed;

  /// No description provided for @noFilesInChannel.
  ///
  /// In ru, this message translates to:
  /// **'В этом чате пока нет ваших файлов'**
  String get noFilesInChannel;

  /// No description provided for @loadMoreFiles.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить ещё'**
  String get loadMoreFiles;

  /// No description provided for @closeFiles.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get closeFiles;

  /// No description provided for @dropFilesHere.
  ///
  /// In ru, this message translates to:
  /// **'Отпустите файлы, чтобы прикрепить'**
  String get dropFilesHere;

  /// No description provided for @optionalNickname.
  ///
  /// In ru, this message translates to:
  /// **'Имя (необязательно)'**
  String get optionalNickname;

  /// No description provided for @channelFiles.
  ///
  /// In ru, this message translates to:
  /// **'Вложения чата'**
  String get channelFiles;

  /// No description provided for @allFileAuthors.
  ///
  /// In ru, this message translates to:
  /// **'Все участники'**
  String get allFileAuthors;

  /// No description provided for @refreshFiles.
  ///
  /// In ru, this message translates to:
  /// **'Обновить вложения'**
  String get refreshFiles;

  /// No description provided for @filesLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить вложения. Попробуйте обновить список.'**
  String get filesLoadFailed;

  /// No description provided for @filesServerUpdateRequired.
  ///
  /// In ru, this message translates to:
  /// **'Для списка вложений нужна актуальная версия сервера.'**
  String get filesServerUpdateRequired;

  /// No description provided for @serverNickname.
  ///
  /// In ru, this message translates to:
  /// **'Свое имя в этом пространстве'**
  String get serverNickname;

  /// No description provided for @nicknameUniqueHelp.
  ///
  /// In ru, this message translates to:
  /// **'Имя должно быть уникальным на сервере. Регистр не учитывается. Пустое поле убирает имя.'**
  String get nicknameUniqueHelp;

  /// No description provided for @saveNickname.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить имя'**
  String get saveNickname;

  /// No description provided for @nicknameSaved.
  ///
  /// In ru, this message translates to:
  /// **'Имя сохранено'**
  String get nicknameSaved;

  /// No description provided for @nicknameTaken.
  ///
  /// In ru, this message translates to:
  /// **'Это имя уже занято. Выберите другое.'**
  String get nicknameTaken;

  /// No description provided for @nicknameInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Используйте до 40 символов без переносов строк.'**
  String get nicknameInvalid;

  /// No description provided for @nicknameFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось изменить профиль. Проверьте подключение.'**
  String get nicknameFailed;

  /// No description provided for @retryProfile.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retryProfile;

  /// No description provided for @messageUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение недоступно'**
  String get messageUnavailable;

  /// No description provided for @mlsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Закрытый чат · MLS'**
  String get mlsTitle;

  /// No description provided for @mlsExperimental.
  ///
  /// In ru, this message translates to:
  /// **'Экспериментальный режим E2EE'**
  String get mlsExperimental;

  /// No description provided for @mlsCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать закрытый чат'**
  String get mlsCreate;

  /// No description provided for @mlsChannelId.
  ///
  /// In ru, this message translates to:
  /// **'Идентификатор чата'**
  String get mlsChannelId;

  /// No description provided for @mlsChannelTitle.
  ///
  /// In ru, this message translates to:
  /// **'Название чата'**
  String get mlsChannelTitle;

  /// No description provided for @mlsDeviceCode.
  ///
  /// In ru, this message translates to:
  /// **'Код этого устройства'**
  String get mlsDeviceCode;

  /// No description provided for @mlsDevices.
  ///
  /// In ru, this message translates to:
  /// **'Устройства чата'**
  String get mlsDevices;

  /// No description provided for @mlsVerify.
  ///
  /// In ru, this message translates to:
  /// **'Проверить устройство'**
  String get mlsVerify;

  /// No description provided for @mlsTrust.
  ///
  /// In ru, this message translates to:
  /// **'Код совпадает'**
  String get mlsTrust;

  /// No description provided for @mlsVerifyHint.
  ///
  /// In ru, this message translates to:
  /// **'Сверьте этот код на другом устройстве по независимому каналу. Сервер не подтверждает подлинность ключа.'**
  String get mlsVerifyHint;

  /// No description provided for @mlsInvite.
  ///
  /// In ru, this message translates to:
  /// **'Пригласить'**
  String get mlsInvite;

  /// No description provided for @mlsRemove.
  ///
  /// In ru, this message translates to:
  /// **'Исключить устройство'**
  String get mlsRemove;

  /// No description provided for @mlsRetry.
  ///
  /// In ru, this message translates to:
  /// **'Обновить и повторить отправку'**
  String get mlsRetry;

  /// No description provided for @mlsWaiting.
  ///
  /// In ru, this message translates to:
  /// **'Это устройство ещё не приглашено в чат или доступ отозван. Передайте его код владельцу чата.'**
  String get mlsWaiting;

  /// No description provided for @mlsInput.
  ///
  /// In ru, this message translates to:
  /// **''**
  String get mlsInput;

  /// No description provided for @mlsSend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get mlsSend;

  /// No description provided for @mlsAttach.
  ///
  /// In ru, this message translates to:
  /// **'Прикрепить файл'**
  String get mlsAttach;

  /// No description provided for @mlsFiles.
  ///
  /// In ru, this message translates to:
  /// **'Файлы чата'**
  String get mlsFiles;

  /// No description provided for @mlsUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение недоступно'**
  String get mlsUnavailable;

  /// No description provided for @mlsCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get mlsCancel;

  /// No description provided for @mlsTransfer.
  ///
  /// In ru, this message translates to:
  /// **'Передать управление'**
  String get mlsTransfer;

  /// No description provided for @mlsTransferTitle.
  ///
  /// In ru, this message translates to:
  /// **'Передать управление чатом?'**
  String get mlsTransferTitle;

  /// No description provided for @mlsTransferHint.
  ///
  /// In ru, this message translates to:
  /// **'Устройство {device} сможет приглашать и исключать участников. Ваш доступ к переписке и файлам сохранится.'**
  String mlsTransferHint(String device);

  /// No description provided for @homeExternalHost.
  ///
  /// In ru, this message translates to:
  /// **'Внешний адрес (IPv4, IPv6 или домен)'**
  String get homeExternalHost;

  /// No description provided for @homeExternalPort.
  ///
  /// In ru, this message translates to:
  /// **'Внешний порт'**
  String get homeExternalPort;

  /// No description provided for @homeAddAddress.
  ///
  /// In ru, this message translates to:
  /// **'Добавить адрес'**
  String get homeAddAddress;

  /// No description provided for @homeRemoveAddress.
  ///
  /// In ru, this message translates to:
  /// **'Удалить адрес'**
  String get homeRemoveAddress;

  /// No description provided for @homeListenPort.
  ///
  /// In ru, this message translates to:
  /// **'Локальный порт'**
  String get homeListenPort;

  /// No description provided for @homeListenInterfaces.
  ///
  /// In ru, this message translates to:
  /// **'Сеть'**
  String get homeListenInterfaces;

  /// No description provided for @homeNetworkHelp.
  ///
  /// In ru, this message translates to:
  /// **'Внешний порт может отличаться от локального. Изменения применятся при следующем запуске сервера.'**
  String get homeNetworkHelp;

  /// No description provided for @homeSaveAddresses.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить настройки'**
  String get homeSaveAddresses;

  /// No description provided for @homeNetworkInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте адреса и порты (1–65535). Адреса не должны повторяться.'**
  String get homeNetworkInvalid;

  /// No description provided for @homeAddressLabel.
  ///
  /// In ru, this message translates to:
  /// **'Адрес'**
  String get homeAddressLabel;

  /// No description provided for @homePrimaryAddress.
  ///
  /// In ru, this message translates to:
  /// **'Основной адрес'**
  String get homePrimaryAddress;

  /// No description provided for @homeBackupAddress.
  ///
  /// In ru, this message translates to:
  /// **'Запасной адрес'**
  String get homeBackupAddress;

  /// No description provided for @homeConnectionAddresses.
  ///
  /// In ru, this message translates to:
  /// **'Подключение участников'**
  String get homeConnectionAddresses;

  /// No description provided for @homeAddressHelp.
  ///
  /// In ru, this message translates to:
  /// **'Домен, IPv4 или IPv6 — без https:// и скобок. Запасной адрес поможет, если основной недоступен.'**
  String get homeAddressHelp;

  /// No description provided for @homeLocalSettings.
  ///
  /// In ru, this message translates to:
  /// **'На этом компьютере'**
  String get homeLocalSettings;

  /// No description provided for @homeDiagTitle.
  ///
  /// In ru, this message translates to:
  /// **'Диагностика подключения'**
  String get homeDiagTitle;

  /// No description provided for @homeDiagRun.
  ///
  /// In ru, this message translates to:
  /// **'Проверить'**
  String get homeDiagRun;

  /// No description provided for @homeDiagRunning.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем адреса…'**
  String get homeDiagRunning;

  /// No description provided for @homeDiagWANLabel.
  ///
  /// In ru, this message translates to:
  /// **'WAN IP роутера (необязательно)'**
  String get homeDiagWANLabel;

  /// No description provided for @homeDiagWANHelp.
  ///
  /// In ru, this message translates to:
  /// **'Адрес со страницы состояния роутера. Это поле не сохраняется.'**
  String get homeDiagWANHelp;

  /// No description provided for @homeDiagCopyCommand.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать команду для другой сети'**
  String get homeDiagCopyCommand;

  /// No description provided for @homeDiagExternalHelp.
  ///
  /// In ru, this message translates to:
  /// **'Space в другой сети автоматически проверяет сохранённое пространство. Для отдельной проверки можно запустить эту команду на внешнем компьютере. Через прокси или VPN результат может остаться неподтверждённым.'**
  String get homeDiagExternalHelp;

  /// No description provided for @homeDiagUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Установленный runtime не поддерживает диагностику. Обновите сервер.'**
  String get homeDiagUnsupported;

  /// No description provided for @homeDiagFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось выполнить диагностику. Проверьте установленный runtime и повторите.'**
  String get homeDiagFailed;

  /// No description provided for @homeDiagLocalPrefix.
  ///
  /// In ru, this message translates to:
  /// **'Локальная проверка'**
  String get homeDiagLocalPrefix;

  /// No description provided for @homeDiagLocalOk.
  ///
  /// In ru, this message translates to:
  /// **'Сервер отвечает локально; TLS и подпись верны.'**
  String get homeDiagLocalOk;

  /// No description provided for @homeDiagRouteOk.
  ///
  /// In ru, this message translates to:
  /// **'Адрес доступен с этого компьютера; TLS и подпись верны.'**
  String get homeDiagRouteOk;

  /// No description provided for @homeDiagUnreachable.
  ///
  /// In ru, this message translates to:
  /// **'Нет подключения. Проверьте запуск, порт и файрвол. Это не доказательство CGNAT.'**
  String get homeDiagUnreachable;

  /// No description provided for @homeDiagDNS.
  ///
  /// In ru, this message translates to:
  /// **'Домен не разрешается. Проверьте имя и DNS-запись.'**
  String get homeDiagDNS;

  /// No description provided for @homeDiagCertificateOk.
  ///
  /// In ru, this message translates to:
  /// **'Сертификат пространства действителен.'**
  String get homeDiagCertificateOk;

  /// No description provided for @homeDiagCertificateMissing.
  ///
  /// In ru, this message translates to:
  /// **'Нет сертификата. Запустите сервер и повторите проверку.'**
  String get homeDiagCertificateMissing;

  /// No description provided for @homeDiagCertificateExpired.
  ///
  /// In ru, this message translates to:
  /// **'Срок действия сертификата не подходит. Проверьте часы и сертификат.'**
  String get homeDiagCertificateExpired;

  /// No description provided for @homeDiagCertificateMismatch.
  ///
  /// In ru, this message translates to:
  /// **'На адресе другой сертификат. Проверьте маршрутизацию; не заменяйте доверенный отпечаток.'**
  String get homeDiagCertificateMismatch;

  /// No description provided for @homeDiagDiscovery.
  ///
  /// In ru, this message translates to:
  /// **'Адрес отвечает, но идентичность или подпись неверна. Проверьте адрес и туннель.'**
  String get homeDiagDiscovery;

  /// No description provided for @homeDiagWANUnknown.
  ///
  /// In ru, this message translates to:
  /// **'WAN IP неизвестен; наличие CGNAT не определено. Можно указать WAN IP роутера выше.'**
  String get homeDiagWANUnknown;

  /// No description provided for @homeDiagWANInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный WAN IP. Возьмите адрес со страницы состояния роутера.'**
  String get homeDiagWANInvalid;

  /// No description provided for @homeDiagWANShared.
  ///
  /// In ru, this message translates to:
  /// **'WAN IP входит в 100.64.0.0/10 — признак CGNAT. Уточните публичный IP у провайдера или используйте TCP-туннель.'**
  String get homeDiagWANShared;

  /// No description provided for @homeDiagWANPrivate.
  ///
  /// In ru, this message translates to:
  /// **'WAN IP частный: возможны двойной NAT или CGNAT. Проверьте вышестоящий роутер и условия провайдера.'**
  String get homeDiagWANPrivate;

  /// No description provided for @homeDiagWANPublic.
  ///
  /// In ru, this message translates to:
  /// **'WAN IP не относится к частным или CGNAT-диапазонам. Это не подтверждает доступность порта извне.'**
  String get homeDiagWANPublic;

  /// No description provided for @homeDiagExternal.
  ///
  /// In ru, this message translates to:
  /// **'Извне не проверено: свежего внешнего подключения нет. Откройте пространство на устройстве в другой сети и повторите проверку. Это не означает, что сервер недоступен.'**
  String get homeDiagExternal;

  /// No description provided for @homeDiagBudget.
  ///
  /// In ru, this message translates to:
  /// **'Время диагностики истекло; оставшиеся адреса не проверены.'**
  String get homeDiagBudget;

  /// No description provided for @homeDiagUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Неизвестный результат; обновите приложение и runtime.'**
  String get homeDiagUnknown;

  /// No description provided for @homeDiagInterface.
  ///
  /// In ru, this message translates to:
  /// **'Адрес прослушивания не принадлежит этому компьютеру. Выберите локальный интерфейс или все интерфейсы.'**
  String get homeDiagInterface;

  /// No description provided for @homeDiagIPv6Private.
  ///
  /// In ru, this message translates to:
  /// **'WAN IPv6 локальный и не подходит для прямого доступа из интернета. Это не доказывает CGNAT.'**
  String get homeDiagIPv6Private;

  /// No description provided for @homeDiagNotReady.
  ///
  /// In ru, this message translates to:
  /// **'TLS отвечает, но сервер ещё не готов (HTTP 503). Завершите первую настройку или дождитесь запуска.'**
  String get homeDiagNotReady;

  /// No description provided for @homeDiagObserved.
  ///
  /// In ru, this message translates to:
  /// **'HTTPS-вход получил запрос из другой публичной сети. Подтверждение относится к указанному времени и этому адресу.'**
  String get homeDiagObserved;

  /// No description provided for @homeDiagObservedAt.
  ///
  /// In ru, this message translates to:
  /// **'Последнее внешнее подключение: {time}'**
  String homeDiagObservedAt(String time);

  /// No description provided for @initialServerSetupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Первый вход в пространство'**
  String get initialServerSetupTitle;

  /// No description provided for @initialServerSetupHelp.
  ///
  /// In ru, this message translates to:
  /// **'Вы станете владельцем этого пространства и сможете назначать других участников администраторами. Ссылка настройки одноразовая.'**
  String get initialServerSetupHelp;

  /// No description provided for @homeAutoPortMapping.
  ///
  /// In ru, this message translates to:
  /// **'Автоматический проброс порта'**
  String get homeAutoPortMapping;

  /// No description provided for @homeAutoPortMappingHelp.
  ///
  /// In ru, this message translates to:
  /// **'Временное правило TCP через PCP, NAT-PMP или UPnP. Удаляется при остановке; не обходит CGNAT.'**
  String get homeAutoPortMappingHelp;

  /// No description provided for @homeAutoPublicIP.
  ///
  /// In ru, this message translates to:
  /// **'Обновлять публичный IP'**
  String get homeAutoPublicIP;

  /// No description provided for @homeAutoPublicIPHelp.
  ///
  /// In ru, this message translates to:
  /// **'Для первого адреса IPv4. Проверка через роутер или ipify; домены и остальные адреса сохраняются.'**
  String get homeAutoPublicIPHelp;

  /// No description provided for @homeDiagMappingOk.
  ///
  /// In ru, this message translates to:
  /// **'Шлюз подтвердил временный проброс TCP. Доступность извне ещё не проверена.'**
  String get homeDiagMappingOk;

  /// No description provided for @homeDiagMappingFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось создать или продлить проброс. Проверьте настройки роутера; при CGNAT нужен публичный адрес или туннель.'**
  String get homeDiagMappingFailed;

  /// No description provided for @homeDiagAutomaticIPFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить публичный IPv4. Проверьте подключение к интернету.'**
  String get homeDiagAutomaticIPFailed;

  /// No description provided for @emojiPicker.
  ///
  /// In ru, this message translates to:
  /// **'Эмодзи'**
  String get emojiPicker;

  /// No description provided for @emojiSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск эмодзи'**
  String get emojiSearch;

  /// No description provided for @emojiRecent.
  ///
  /// In ru, this message translates to:
  /// **'Недавние'**
  String get emojiRecent;

  /// No description provided for @emojiAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get emojiAll;

  /// No description provided for @addReaction.
  ///
  /// In ru, this message translates to:
  /// **'Добавить реакцию'**
  String get addReaction;

  /// No description provided for @reactionParticipants.
  ///
  /// In ru, this message translates to:
  /// **'Кто отреагировал'**
  String get reactionParticipants;

  /// No description provided for @copyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Скопировать'**
  String get copyMessage;

  /// No description provided for @messageCopied.
  ///
  /// In ru, this message translates to:
  /// **'Скопировано'**
  String get messageCopied;

  /// No description provided for @emojiFaces.
  ///
  /// In ru, this message translates to:
  /// **'Лица и эмоции'**
  String get emojiFaces;

  /// No description provided for @emojiPeople.
  ///
  /// In ru, this message translates to:
  /// **'Люди и жесты'**
  String get emojiPeople;

  /// No description provided for @emojiNature.
  ///
  /// In ru, this message translates to:
  /// **'Животные и природа'**
  String get emojiNature;

  /// No description provided for @emojiFood.
  ///
  /// In ru, this message translates to:
  /// **'Еда и напитки'**
  String get emojiFood;

  /// No description provided for @emojiTravel.
  ///
  /// In ru, this message translates to:
  /// **'Путешествия и места'**
  String get emojiTravel;

  /// No description provided for @emojiActivities.
  ///
  /// In ru, this message translates to:
  /// **'Занятия'**
  String get emojiActivities;

  /// No description provided for @emojiObjects.
  ///
  /// In ru, this message translates to:
  /// **'Предметы'**
  String get emojiObjects;

  /// No description provided for @emojiSymbols.
  ///
  /// In ru, this message translates to:
  /// **'Символы'**
  String get emojiSymbols;

  /// No description provided for @emojiFlags.
  ///
  /// In ru, this message translates to:
  /// **'Флаги'**
  String get emojiFlags;

  /// No description provided for @messageQueued.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение сохранено в очереди на этом устройстве'**
  String get messageQueued;

  /// No description provided for @outboxTitle.
  ///
  /// In ru, this message translates to:
  /// **'Очередь отправки'**
  String get outboxTitle;

  /// No description provided for @outboxWaiting.
  ///
  /// In ru, this message translates to:
  /// **'Ожидает отправки'**
  String get outboxWaiting;

  /// No description provided for @outboxBlocked.
  ///
  /// In ru, this message translates to:
  /// **'Отправка остановлена'**
  String get outboxBlocked;

  /// No description provided for @outboxUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать или сохранить очередь. Текст остаётся в поле ввода.'**
  String get outboxUnavailable;

  /// No description provided for @outboxRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить отправку'**
  String get outboxRetry;

  /// No description provided for @outboxDiscard.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из очереди'**
  String get outboxDiscard;

  /// No description provided for @outboxDiscardDescription.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение могло уже попасть на сервер. Удаление из очереди прекращает повторы, но не удаляет сообщение у участников.'**
  String get outboxDiscardDescription;

  /// No description provided for @outboxFileMessage.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение с вложениями'**
  String get outboxFileMessage;

  /// No description provided for @outboxIdentityChanged.
  ///
  /// In ru, this message translates to:
  /// **'Разрешение устройства изменилось. Прежняя очередь сохранена; автоматическая отправка от нового устройства запрещена.'**
  String get outboxIdentityChanged;

  /// No description provided for @outboxFull.
  ///
  /// In ru, this message translates to:
  /// **'Очередь заполнена: до 100 сообщений и 1 МиБ. Дождитесь отправки или уберите ненужные сообщения.'**
  String get outboxFull;

  /// No description provided for @outboxFileLimit.
  ///
  /// In ru, this message translates to:
  /// **'Для ожидающих вложений доступно 200 МиБ на пространство и устройство. Дождитесь отправки или уберите ненужные сообщения.'**
  String get outboxFileLimit;

  /// No description provided for @outboxRecover.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить прежнюю очередь'**
  String get outboxRecover;

  /// No description provided for @outboxRecoverDescription.
  ///
  /// In ru, this message translates to:
  /// **'Эти сообщения остались на этом компьютере под прежним разрешением устройства. Проверьте их перед переносом. Ключи запросов сохраняются, уже принятые сообщения не дублируются.'**
  String get outboxRecoverDescription;

  /// No description provided for @outboxRecoverTrust.
  ///
  /// In ru, this message translates to:
  /// **'Я доверяю текущему устройству и разрешаю отправить эти сообщения от моего имени.'**
  String get outboxRecoverTrust;

  /// No description provided for @outboxRecoverSend.
  ///
  /// In ru, this message translates to:
  /// **'Перенести и отправить'**
  String get outboxRecoverSend;

  /// No description provided for @outboxRecoverFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось завершить перенос. Очередь сохранена; проверьте подключение и повторите.'**
  String get outboxRecoverFailed;

  /// No description provided for @outboxEdit.
  ///
  /// In ru, this message translates to:
  /// **'Правка сообщения'**
  String get outboxEdit;

  /// No description provided for @outboxDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удаление сообщения'**
  String get outboxDelete;

  /// No description provided for @outboxReactionAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить реакцию'**
  String get outboxReactionAdd;

  /// No description provided for @outboxReactionRemove.
  ///
  /// In ru, this message translates to:
  /// **'Снять реакцию'**
  String get outboxReactionRemove;

  /// No description provided for @outboxMutationBlocked.
  ///
  /// In ru, this message translates to:
  /// **'Изменение остановлено. Проверьте права, версию runtime и новое состояние сообщения. При конфликте уберите действие из очереди и выполните его заново.'**
  String get outboxMutationBlocked;

  /// No description provided for @outboxDiscardMutationDescription.
  ///
  /// In ru, this message translates to:
  /// **'Действие могло уже выполниться на сервере. Удаление из очереди прекращает локальные повторы, но не отменяет выполненное действие. Зависимые действия остановятся.'**
  String get outboxDiscardMutationDescription;

  /// No description provided for @replyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Ответить'**
  String get replyMessage;

  /// No description provided for @cancelReply.
  ///
  /// In ru, this message translates to:
  /// **'Отменить ответ'**
  String get cancelReply;

  /// No description provided for @replyUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Исходное сообщение недоступно'**
  String get replyUnavailable;

  /// No description provided for @notifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notifications;

  /// No description provided for @notificationsOff.
  ///
  /// In ru, this message translates to:
  /// **'Выключены'**
  String get notificationsOff;

  /// No description provided for @notificationsPrivate.
  ///
  /// In ru, this message translates to:
  /// **'Скрывать содержимое'**
  String get notificationsPrivate;

  /// No description provided for @notificationsPreview.
  ///
  /// In ru, this message translates to:
  /// **'Показывать текст сообщения'**
  String get notificationsPreview;

  /// No description provided for @notificationsDescription.
  ///
  /// In ru, this message translates to:
  /// **'На компьютере: Обычные и присоединённые закрытые чаты подключённых пространств, пока приложение запущено. Предпросмотр передаёт текст операционной системе. Доставка после закрытия приложения пока не поддерживается.'**
  String get notificationsDescription;

  /// No description provided for @notificationPermissionError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось разрешить уведомления. Проверьте системные настройки.'**
  String get notificationPermissionError;

  /// No description provided for @newMessageNotification.
  ///
  /// In ru, this message translates to:
  /// **'Новое сообщение'**
  String get newMessageNotification;

  /// No description provided for @messageSearchServer.
  ///
  /// In ru, this message translates to:
  /// **'Поиск в истории выбранного чата'**
  String get messageSearchServer;

  /// No description provided for @messageSearchLocal.
  ///
  /// In ru, this message translates to:
  /// **'Поиск только на этом устройстве · MLS'**
  String get messageSearchLocal;

  /// No description provided for @messageSearchFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось выполнить поиск. Повторить'**
  String get messageSearchFailed;

  /// No description provided for @messageSearchMore.
  ///
  /// In ru, this message translates to:
  /// **'Ещё сообщения'**
  String get messageSearchMore;

  /// No description provided for @messageSearchLimit.
  ///
  /// In ru, this message translates to:
  /// **'Показаны первые 200 совпадений. Уточните запрос.'**
  String get messageSearchLimit;

  /// No description provided for @loadOlderMessages.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить предыдущие сообщения'**
  String get loadOlderMessages;

  /// No description provided for @historyPageFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить историю. Повторите попытку.'**
  String get historyPageFailed;

  /// No description provided for @messageSearchAllChannels.
  ///
  /// In ru, this message translates to:
  /// **'Во всех доступных чатах'**
  String get messageSearchAllChannels;

  /// No description provided for @messageSearchMixed.
  ///
  /// In ru, this message translates to:
  /// **'Закрытые чаты — поиск только на этом устройстве'**
  String get messageSearchMixed;

  /// No description provided for @savedMlsSearchChannels.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые закрытые чаты'**
  String get savedMlsSearchChannels;

  /// No description provided for @savedMlsMessagePreview.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённое сообщение · без подключения к серверу'**
  String get savedMlsMessagePreview;

  /// No description provided for @homeArchiveVerified.
  ///
  /// In ru, this message translates to:
  /// **'Архив проверен'**
  String get homeArchiveVerified;

  /// No description provided for @homeArchiveSummary.
  ///
  /// In ru, this message translates to:
  /// **'Пространство: {serverId}\nВерсия данных: {schema}\nФайлов в архиве: {files}\nОбъём после распаковки: {size} МиБ'**
  String homeArchiveSummary(
    String serverId,
    int schema,
    int files,
    String size,
  );

  /// No description provided for @homeArchiveReviewHelp.
  ///
  /// In ru, this message translates to:
  /// **'Состав и контрольные суммы проверены. Это не подтверждает источник архива: восстанавливайте только свою копию. Сервер ещё не восстанавливался. Ключ владельца и история MLS на устройстве восстанавливаются отдельно.'**
  String get homeArchiveReviewHelp;

  /// No description provided for @homeArchiveRestore.
  ///
  /// In ru, this message translates to:
  /// **'Начать восстановление'**
  String get homeArchiveRestore;

  /// No description provided for @homeArchiveUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Этот runtime ещё не умеет проверять архивы. Нужен совместимый выпуск приложения и runtime с поддержкой проверки; восстановление не начато.'**
  String get homeArchiveUnsupported;

  /// No description provided for @homeArchiveCheckFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось проверить архив. Он может быть повреждён или несовместим с runtime. Восстановление не начато.'**
  String get homeArchiveCheckFailed;

  /// No description provided for @homeDiskTitle.
  ///
  /// In ru, this message translates to:
  /// **'Диск и резервные копии'**
  String get homeDiskTitle;

  /// No description provided for @homeDiskPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Ручная очистка runtime и копий обновления сохраняет текущий и предыдущий runtime, три самые новые проверенные копии и копию текущего восстановления. Другие копии предлагаются только спустя 30 дней. Файлы вне домашнего сервера не удаляются.'**
  String get homeDiskPolicy;

  /// No description provided for @homeDiskScan.
  ///
  /// In ru, this message translates to:
  /// **'Показать размеры / обновить'**
  String get homeDiskScan;

  /// No description provided for @homeDiskClean.
  ///
  /// In ru, this message translates to:
  /// **'Удалить выбранное'**
  String get homeDiskClean;

  /// No description provided for @homeDiskConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Выбранные каталоги будут удалены без возможности отмены. Данные пространства, защищённые копии и внешние ZIP-архивы сохранятся. Продолжить?'**
  String get homeDiskConfirm;

  /// No description provided for @homeDiskFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось завершить проверку или очистку. Состояние могло измениться; обновите список. При ссылках и незавершённом восстановлении очистка запрещена.'**
  String get homeDiskFailed;

  /// No description provided for @homeDiskData.
  ///
  /// In ru, this message translates to:
  /// **'Данные пространства'**
  String get homeDiskData;

  /// No description provided for @homeDiskRuntimes.
  ///
  /// In ru, this message translates to:
  /// **'Версии сервера'**
  String get homeDiskRuntimes;

  /// No description provided for @homeDiskBackups.
  ///
  /// In ru, this message translates to:
  /// **'Резервные копии'**
  String get homeDiskBackups;

  /// No description provided for @homeDiskRecoveries.
  ///
  /// In ru, this message translates to:
  /// **'Данные восстановления'**
  String get homeDiskRecoveries;

  /// No description provided for @homeDiskFree.
  ///
  /// In ru, this message translates to:
  /// **'Свободно на диске сервера'**
  String get homeDiskFree;

  /// No description provided for @homeDiskEstimate.
  ///
  /// In ru, this message translates to:
  /// **'Размеры приблизительные и могут меняться во время работы сервера. Очистка повторно проверяет выбранные файлы.'**
  String get homeDiskEstimate;

  /// No description provided for @homeDiskNothing.
  ///
  /// In ru, this message translates to:
  /// **'Нет старых каталогов, которые можно безопасно удалить.'**
  String get homeDiskNothing;

  /// No description provided for @homeDiskStop.
  ///
  /// In ru, this message translates to:
  /// **'Для очистки сначала остановите сервер.'**
  String get homeDiskStop;

  /// No description provided for @homeBackupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Копии по расписанию'**
  String get homeBackupTitle;

  /// No description provided for @homeBackupHelp.
  ///
  /// In ru, this message translates to:
  /// **'Копии создаёт работающий runtime без отключения чатов. После простоя создаётся одна свежая копия. Изменения применяются в течение минуты; начатая операция может завершиться по прежним настройкам.'**
  String get homeBackupHelp;

  /// No description provided for @homeBackupUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Установите или обновите runtime для копий по расписанию.'**
  String get homeBackupUnsupported;

  /// No description provided for @homeBackupEnabled.
  ///
  /// In ru, this message translates to:
  /// **'Включить расписание'**
  String get homeBackupEnabled;

  /// No description provided for @homeBackupInterval.
  ///
  /// In ru, this message translates to:
  /// **'Интервал, часы'**
  String get homeBackupInterval;

  /// No description provided for @homeBackupPrune.
  ///
  /// In ru, this message translates to:
  /// **'Автоматически удалять старые копии'**
  String get homeBackupPrune;

  /// No description provided for @homeBackupCount.
  ///
  /// In ru, this message translates to:
  /// **'Количество копий (3–100)'**
  String get homeBackupCount;

  /// No description provided for @homeBackupDays.
  ///
  /// In ru, this message translates to:
  /// **'Срок хранения, дни (1–3650)'**
  String get homeBackupDays;

  /// No description provided for @homeBackupQuota.
  ///
  /// In ru, this message translates to:
  /// **'Лимит, МиБ (0 — без лимита)'**
  String get homeBackupQuota;

  /// No description provided for @homeBackupRetention.
  ///
  /// In ru, this message translates to:
  /// **'При включённой автоочистке применяется любой из лимитов. Три самые новые проверенные копии сохраняются даже при превышении объёма. Неизвестные, повреждённые и несовместимые файлы не удаляются.'**
  String get homeBackupRetention;

  /// No description provided for @homeBackupSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить настройки'**
  String get homeBackupSave;

  /// No description provided for @homeBackupConfigure.
  ///
  /// In ru, this message translates to:
  /// **'Настроить копирование'**
  String get homeBackupConfigure;

  /// No description provided for @homeBackupRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить статус'**
  String get homeBackupRefresh;

  /// No description provided for @homeBackupFailed.
  ///
  /// In ru, this message translates to:
  /// **'Копирование или очистка не завершены. Проверьте настройки, место и доступ к диску. Следующая попытка — не раньше чем через пять минут.'**
  String get homeBackupFailed;

  /// No description provided for @homeBackupLast.
  ///
  /// In ru, this message translates to:
  /// **'Последняя успешная копия'**
  String get homeBackupLast;

  /// No description provided for @homeBackupNext.
  ///
  /// In ru, this message translates to:
  /// **'Следующая проверка'**
  String get homeBackupNext;

  /// No description provided for @homeBackupProtected.
  ///
  /// In ru, this message translates to:
  /// **'Часть файлов защищена от удаления или лимит объёма недостижим при сохранении трёх копий.'**
  String get homeBackupProtected;

  /// No description provided for @homeBackupOff.
  ///
  /// In ru, this message translates to:
  /// **'Расписание выключено'**
  String get homeBackupOff;

  /// No description provided for @homeBackupRunning.
  ///
  /// In ru, this message translates to:
  /// **'Создаётся копия…'**
  String get homeBackupRunning;

  /// No description provided for @homeBackupOK.
  ///
  /// In ru, this message translates to:
  /// **'Последняя операция завершена'**
  String get homeBackupOK;

  /// No description provided for @homeBackupSpace.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось подтвердить свободное место для новой копии.'**
  String get homeBackupSpace;

  /// No description provided for @homeBackupWaiting.
  ///
  /// In ru, this message translates to:
  /// **'Ожидание работающего runtime и срока копирования'**
  String get homeBackupWaiting;

  /// No description provided for @voiceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Голосовые комнаты'**
  String get voiceTitle;

  /// No description provided for @voiceDescription.
  ///
  /// In ru, this message translates to:
  /// **'Разговор без камеры. Микрофон включается только по вашему нажатию.'**
  String get voiceDescription;

  /// No description provided for @voiceCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать комнату'**
  String get voiceCreate;

  /// No description provided for @voiceName.
  ///
  /// In ru, this message translates to:
  /// **'Название комнаты'**
  String get voiceName;

  /// No description provided for @voiceJoin.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get voiceJoin;

  /// No description provided for @voiceLeave.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из разговора'**
  String get voiceLeave;

  /// No description provided for @voiceMicrophoneOn.
  ///
  /// In ru, this message translates to:
  /// **'Включить микрофон'**
  String get voiceMicrophoneOn;

  /// No description provided for @voiceMicrophoneOff.
  ///
  /// In ru, this message translates to:
  /// **'Выключить микрофон'**
  String get voiceMicrophoneOff;

  /// No description provided for @voiceSoundOn.
  ///
  /// In ru, this message translates to:
  /// **'Включить звук'**
  String get voiceSoundOn;

  /// No description provided for @voiceSoundOff.
  ///
  /// In ru, this message translates to:
  /// **'Отключить звук'**
  String get voiceSoundOff;

  /// No description provided for @voiceJoining.
  ///
  /// In ru, this message translates to:
  /// **'Подключаемся…'**
  String get voiceJoining;

  /// No description provided for @voiceReconnecting.
  ///
  /// In ru, this message translates to:
  /// **'Восстанавливаем соединение. Микрофон выключен.'**
  String get voiceReconnecting;

  /// No description provided for @voiceConnected.
  ///
  /// In ru, this message translates to:
  /// **'В разговоре'**
  String get voiceConnected;

  /// No description provided for @voiceParticipants.
  ///
  /// In ru, this message translates to:
  /// **'Участники'**
  String get voiceParticipants;

  /// No description provided for @voiceMuted.
  ///
  /// In ru, this message translates to:
  /// **'Микрофон выключен'**
  String get voiceMuted;

  /// No description provided for @voiceSpeaking.
  ///
  /// In ru, this message translates to:
  /// **'Говорит'**
  String get voiceSpeaking;

  /// No description provided for @voiceDeafened.
  ///
  /// In ru, this message translates to:
  /// **'Звук выключен'**
  String get voiceDeafened;

  /// No description provided for @voiceEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Голосовых комнат пока нет. Владелец или администратор может создать первую.'**
  String get voiceEmpty;

  /// No description provided for @voiceConnectFirst.
  ///
  /// In ru, this message translates to:
  /// **'Подключитесь к пространству, чтобы открыть голосовые комнаты.'**
  String get voiceConnectFirst;

  /// No description provided for @voiceLimit.
  ///
  /// In ru, this message translates to:
  /// **'До восьми участников в комнате. Для подключения через интернет владелец настраивает STUN/TURN; приложение получает настройки автоматически.'**
  String get voiceLimit;

  /// No description provided for @voiceDesktopOnly.
  ///
  /// In ru, this message translates to:
  /// **'Голосовой срез пока доступен на компьютере.'**
  String get voiceDesktopOnly;

  /// No description provided for @voicePrivacy.
  ///
  /// In ru, this message translates to:
  /// **'Без записи и камеры. Звук проходит через сервер пространства; это не MLS-шифрование между участниками.'**
  String get voicePrivacy;

  /// No description provided for @voiceFailure.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось продолжить разговор'**
  String get voiceFailure;

  /// No description provided for @voiceCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get voiceCancel;

  /// No description provided for @voiceSave.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get voiceSave;

  /// No description provided for @voiceUpdateRuntime.
  ///
  /// In ru, this message translates to:
  /// **'Для голосовых комнат нужен новый runtime с поддержкой голоса. Обновите сервер в «Эфире».'**
  String get voiceUpdateRuntime;

  /// No description provided for @voiceDeviceUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Выбранное аудиоустройство отключено. Подключите его или выберите другое. Затем включите микрофон или звук вручную.'**
  String get voiceDeviceUnavailable;

  /// No description provided for @voiceDeviceDisconnected.
  ///
  /// In ru, this message translates to:
  /// **'Устройство отключено'**
  String get voiceDeviceDisconnected;

  /// No description provided for @voiceAudioDevices.
  ///
  /// In ru, this message translates to:
  /// **'Аудиоустройства'**
  String get voiceAudioDevices;

  /// No description provided for @voiceSettingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Голос'**
  String get voiceSettingsTitle;

  /// No description provided for @voiceInputVolume.
  ///
  /// In ru, this message translates to:
  /// **'Громкость микрофона'**
  String get voiceInputVolume;

  /// No description provided for @voiceOutputVolume.
  ///
  /// In ru, this message translates to:
  /// **'Громкость звука'**
  String get voiceOutputVolume;

  /// No description provided for @voiceProcessingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обработка звука'**
  String get voiceProcessingTitle;

  /// No description provided for @voiceInputProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль микрофона'**
  String get voiceInputProfile;

  /// No description provided for @voiceProfileSpeech.
  ///
  /// In ru, this message translates to:
  /// **'Для разговора'**
  String get voiceProfileSpeech;

  /// No description provided for @voiceProfileStudio.
  ///
  /// In ru, this message translates to:
  /// **'Студия — без обработки'**
  String get voiceProfileStudio;

  /// No description provided for @voiceProfileCustom.
  ///
  /// In ru, this message translates to:
  /// **'Пользовательский'**
  String get voiceProfileCustom;

  /// No description provided for @voiceNoiseSuppression.
  ///
  /// In ru, this message translates to:
  /// **'Шумоподавление'**
  String get voiceNoiseSuppression;

  /// No description provided for @voiceEchoCancellation.
  ///
  /// In ru, this message translates to:
  /// **'Эхоподавление'**
  String get voiceEchoCancellation;

  /// No description provided for @voiceAutoGain.
  ///
  /// In ru, this message translates to:
  /// **'Автоматическая регулировка усиления'**
  String get voiceAutoGain;

  /// No description provided for @voiceProcessingHint.
  ///
  /// In ru, this message translates to:
  /// **'Изменение обработки выключает микрофон: включите его снова, чтобы применить настройки. Для профиля «Студия» используйте наушники.'**
  String get voiceProcessingHint;

  /// No description provided for @voiceTestMicrophone.
  ///
  /// In ru, this message translates to:
  /// **'Проверка микрофона'**
  String get voiceTestMicrophone;

  /// No description provided for @voiceStopMicrophoneTest.
  ///
  /// In ru, this message translates to:
  /// **'Остановить проверку'**
  String get voiceStopMicrophoneTest;

  /// No description provided for @voiceMicrophoneLevel.
  ///
  /// In ru, this message translates to:
  /// **'Уровень микрофона'**
  String get voiceMicrophoneLevel;

  /// No description provided for @voiceMicrophoneTestHint.
  ///
  /// In ru, this message translates to:
  /// **'Вы услышите себя. Проверка работает локально до 60 секунд и не передаёт голос в комнату. Звук комнаты будет выключен. Закрытие настроек останавливает проверку.'**
  String get voiceMicrophoneTestHint;

  /// No description provided for @voiceDevicesDescription.
  ///
  /// In ru, this message translates to:
  /// **'Выберите, через что говорить и слушать. Настройки можно менять до входа в комнату и во время разговора.'**
  String get voiceDevicesDescription;

  /// No description provided for @voiceDevicesRemembered.
  ///
  /// In ru, this message translates to:
  /// **'Выбор сохраняется на этом компьютере. Вход в комнату и восстановление настроек не включают микрофон.'**
  String get voiceDevicesRemembered;

  /// No description provided for @voiceInputDevice.
  ///
  /// In ru, this message translates to:
  /// **'Микрофон'**
  String get voiceInputDevice;

  /// No description provided for @voiceOutputDevice.
  ///
  /// In ru, this message translates to:
  /// **'Вывод звука'**
  String get voiceOutputDevice;

  /// No description provided for @voiceCurrentDevice.
  ///
  /// In ru, this message translates to:
  /// **'Текущее системное устройство'**
  String get voiceCurrentDevice;

  /// No description provided for @voiceRefreshDevices.
  ///
  /// In ru, this message translates to:
  /// **'Обновить устройства'**
  String get voiceRefreshDevices;

  /// No description provided for @voiceCloseDevices.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get voiceCloseDevices;

  /// No description provided for @voicePushToTalk.
  ///
  /// In ru, this message translates to:
  /// **'Режим рации'**
  String get voicePushToTalk;

  /// No description provided for @voicePushToTalkHint.
  ///
  /// In ru, this message translates to:
  /// **'Включите микрофон в комнате и удерживайте выбранные клавиши для разговора. Работает, пока окно активно. Проверка микрофона воспроизводится непрерывно.'**
  String get voicePushToTalkHint;

  /// No description provided for @voiceAutomaticSensitivity.
  ///
  /// In ru, this message translates to:
  /// **'Автоматическая чувствительность микрофона'**
  String get voiceAutomaticSensitivity;

  /// No description provided for @voiceSensitivity.
  ///
  /// In ru, this message translates to:
  /// **'Порог срабатывания'**
  String get voiceSensitivity;

  /// No description provided for @recoveryIncludeSpaces.
  ///
  /// In ru, this message translates to:
  /// **'И пространства'**
  String get recoveryIncludeSpaces;

  /// No description provided for @recoveryIncludeSpacesHint.
  ///
  /// In ru, this message translates to:
  /// **'Создать второй QR со списком пространств и их ключами доступа. Ключи MLS и история не входят.'**
  String get recoveryIncludeSpacesHint;

  /// No description provided for @recoveryAccessQr.
  ///
  /// In ru, this message translates to:
  /// **'Восстановление выбранного доступа'**
  String get recoveryAccessQr;

  /// No description provided for @recoverySpacesQr.
  ///
  /// In ru, this message translates to:
  /// **'Пространства и доступ'**
  String get recoverySpacesQr;

  /// No description provided for @recoverySpacesUseFile.
  ///
  /// In ru, this message translates to:
  /// **'Набор не помещается в один QR. Сохраните зашифрованный файл.'**
  String get recoverySpacesUseFile;

  /// No description provided for @recoverySaveSpacesQr.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить QR пространств'**
  String get recoverySaveSpacesQr;

  /// No description provided for @recoverySaveSpacesFile.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить пространства в файл'**
  String get recoverySaveSpacesFile;

  /// No description provided for @recoverySpacesResult.
  ///
  /// In ru, this message translates to:
  /// **'Добавлено пространств: {restored}. Всего в наборе: {total}. Имеющиеся ключи сохранены без изменений. Для ошибок повторите импорт.'**
  String recoverySpacesResult(int restored, int total);

  /// No description provided for @migrationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Полный перенос пространства'**
  String get migrationTitle;

  /// No description provided for @migrationExportHelp.
  ///
  /// In ru, this message translates to:
  /// **'Архив содержит сервер, ключи устройства, рабочее состояние MLS и локальную историю закрытых чатов. После сохранения прежний клиент прекратит работу с этим пространством. Сохраните архив вне этого диска и запомните пароль. При сбое проверьте файл .pending: он может содержать готовый перенос. После проверки архива рабочие ключи прежнего устройства будут заменены отметкой переноса в системном хранилище.'**
  String get migrationExportHelp;

  /// No description provided for @migrationImportHelp.
  ///
  /// In ru, this message translates to:
  /// **'Восстановление продолжает работу прежнего устройства. Используйте архив только на одном новом устройстве. Старый сервер должен быть остановлен. Существующие ключи не заменяются.'**
  String get migrationImportHelp;

  /// No description provided for @migrationPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль архива'**
  String get migrationPassword;

  /// No description provided for @migrationPasswordRepeat.
  ///
  /// In ru, this message translates to:
  /// **'Повторите пароль'**
  String get migrationPasswordRepeat;

  /// No description provided for @migrationExported.
  ///
  /// In ru, this message translates to:
  /// **'Перенос сохранён. Прежнее устройство остановлено. Сохраните архив и пароль перед переустановкой ОС.'**
  String get migrationExported;

  /// No description provided for @voiceRefreshRooms.
  ///
  /// In ru, this message translates to:
  /// **'Обновить список комнат'**
  String get voiceRefreshRooms;

  /// No description provided for @voiceRouteDirect.
  ///
  /// In ru, this message translates to:
  /// **'Прямое соединение'**
  String get voiceRouteDirect;

  /// No description provided for @voiceRouteRelay.
  ///
  /// In ru, this message translates to:
  /// **'Через TURN'**
  String get voiceRouteRelay;

  /// No description provided for @voiceRouteUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Маршрут пока неизвестен'**
  String get voiceRouteUnknown;

  /// No description provided for @voiceRoundTrip.
  ///
  /// In ru, this message translates to:
  /// **'Задержка RTT: {milliseconds} мс'**
  String voiceRoundTrip(int milliseconds);

  /// No description provided for @voiceProfileSpeechHelp.
  ///
  /// In ru, this message translates to:
  /// **'Шумоподавление, подавление эха, выравнивание громкости и фильтр гула.'**
  String get voiceProfileSpeechHelp;

  /// No description provided for @voiceProfileStudioHelp.
  ///
  /// In ru, this message translates to:
  /// **'Без обработки микрофона. Для музыки и подготовленного звука; используйте наушники.'**
  String get voiceProfileStudioHelp;

  /// No description provided for @voiceProfileCustomHelp.
  ///
  /// In ru, this message translates to:
  /// **'Все параметры обработки можно настроить отдельно.'**
  String get voiceProfileCustomHelp;

  /// No description provided for @voiceActivity.
  ///
  /// In ru, this message translates to:
  /// **'Активация по голосу'**
  String get voiceActivity;

  /// No description provided for @voiceActivityHelp.
  ///
  /// In ru, this message translates to:
  /// **'После ручного включения микрофона передача открывается при превышении порога. Фон тоже может сработать — настройте чувствительность.'**
  String get voiceActivityHelp;

  /// No description provided for @voiceNoiseSuppressionHelp.
  ///
  /// In ru, this message translates to:
  /// **'DeepFilterNet3 — нейросетевое подавление шума. WebRTC — более лёгкий вариант. Звук обрабатывается на вашем устройстве.'**
  String get voiceNoiseSuppressionHelp;

  /// No description provided for @voiceNoiseWebRtc.
  ///
  /// In ru, this message translates to:
  /// **'WebRTC'**
  String get voiceNoiseWebRtc;

  /// No description provided for @voiceNoiseOff.
  ///
  /// In ru, this message translates to:
  /// **'Отключено'**
  String get voiceNoiseOff;

  /// No description provided for @voiceAdvancedSettings.
  ///
  /// In ru, this message translates to:
  /// **'Расширенные настройки голоса'**
  String get voiceAdvancedSettings;

  /// No description provided for @voiceHighPass.
  ///
  /// In ru, this message translates to:
  /// **'Фильтр низкочастотного гула'**
  String get voiceHighPass;

  /// No description provided for @voiceAdvancedActivation.
  ///
  /// In ru, this message translates to:
  /// **'Устойчивое срабатывание по голосу'**
  String get voiceAdvancedActivation;

  /// No description provided for @voiceAdvancedActivationHelp.
  ///
  /// In ru, this message translates to:
  /// **'Удерживает передачу при колебаниях уровня около порога, чтобы не обрывать тихие окончания слов. Определяет уровень, а не распознаёт речь.'**
  String get voiceAdvancedActivationHelp;

  /// No description provided for @voiceReleaseDelay.
  ///
  /// In ru, this message translates to:
  /// **'Задержка закрытия передачи: {milliseconds} мс'**
  String voiceReleaseDelay(int milliseconds);

  /// No description provided for @voiceRoomEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В комнате пока никого нет'**
  String get voiceRoomEmpty;

  /// No description provided for @voiceMicrophoneEnabled.
  ///
  /// In ru, this message translates to:
  /// **'Микрофон включён'**
  String get voiceMicrophoneEnabled;

  /// No description provided for @voiceActivityUpdateRuntime.
  ///
  /// In ru, this message translates to:
  /// **'Для подсветки говорящих собеседников обновите runtime пространства.'**
  String get voiceActivityUpdateRuntime;

  /// No description provided for @voiceHoldToTalk.
  ///
  /// In ru, this message translates to:
  /// **'Удерживайте, чтобы говорить'**
  String get voiceHoldToTalk;

  /// No description provided for @voiceTouchToTalkHint.
  ///
  /// In ru, this message translates to:
  /// **'Включите микрофон в комнате и удерживайте кнопку разговора. При сворачивании приложения кнопка отпускается.'**
  String get voiceTouchToTalkHint;

  /// No description provided for @voiceAndroidNoiseHelp.
  ///
  /// In ru, this message translates to:
  /// **'DeepFilterNet3 включён по умолчанию. WebRTC — более лёгкий вариант; обработку можно отключить. Звук обрабатывается на телефоне.'**
  String get voiceAndroidNoiseHelp;

  /// No description provided for @forumConnectFirst.
  ///
  /// In ru, this message translates to:
  /// **'Подключитесь к пространству, чтобы открыть форум.'**
  String get forumConnectFirst;

  /// No description provided for @forumUpdateRuntime.
  ///
  /// In ru, this message translates to:
  /// **'Для форума нужен новый runtime с поддержкой core.forum.v1. Обновите сервер через «Эфир».'**
  String get forumUpdateRuntime;

  /// No description provided for @forumPrivacy.
  ///
  /// In ru, this message translates to:
  /// **'Сообщения форума хранятся на сервере без сквозного шифрования. Доступ определяется правами раздела.'**
  String get forumPrivacy;

  /// No description provided for @forumSections.
  ///
  /// In ru, this message translates to:
  /// **'Раздел форума'**
  String get forumSections;

  /// No description provided for @forumManage.
  ///
  /// In ru, this message translates to:
  /// **'Разделы и права'**
  String get forumManage;

  /// No description provided for @forumEmptySections.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных форумных разделов. Администратор может создать раздел и назначить права.'**
  String get forumEmptySections;

  /// No description provided for @forumRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get forumRefresh;

  /// No description provided for @forumNewTopic.
  ///
  /// In ru, this message translates to:
  /// **'Создать тему'**
  String get forumNewTopic;

  /// No description provided for @forumTopicTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заголовок темы'**
  String get forumTopicTitle;

  /// No description provided for @forumText.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение'**
  String get forumText;

  /// No description provided for @forumSend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get forumSend;

  /// No description provided for @forumReply.
  ///
  /// In ru, this message translates to:
  /// **'Ответить'**
  String get forumReply;

  /// No description provided for @forumClosed.
  ///
  /// In ru, this message translates to:
  /// **'Тема закрыта. Новые ответы запрещены.'**
  String get forumClosed;

  /// No description provided for @forumClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть тему'**
  String get forumClose;

  /// No description provided for @forumCloseConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть тему? Новые ответы станут недоступны всем участникам.'**
  String get forumCloseConfirm;

  /// No description provided for @forumCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get forumCancel;

  /// No description provided for @forumBack.
  ///
  /// In ru, this message translates to:
  /// **'К темам'**
  String get forumBack;

  /// No description provided for @forumMore.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить ещё'**
  String get forumMore;

  /// No description provided for @forumEmptyTopics.
  ///
  /// In ru, this message translates to:
  /// **'В этом разделе пока нет тем.'**
  String get forumEmptyTopics;

  /// No description provided for @forumReadOnly.
  ///
  /// In ru, this message translates to:
  /// **'У вас есть право чтения. Для публикации нужно право записи в раздел.'**
  String get forumReadOnly;

  /// No description provided for @forumInvalidText.
  ///
  /// In ru, this message translates to:
  /// **'Введите текст или прикрепите файл. Заголовок — до 320 байт UTF-8.'**
  String get forumInvalidText;

  /// No description provided for @forumConflict.
  ///
  /// In ru, this message translates to:
  /// **'Тема изменилась. Обновите её и повторите действие.'**
  String get forumConflict;

  /// No description provided for @forumDenied.
  ///
  /// In ru, this message translates to:
  /// **'Доступ отозван или раздел недоступен. Обновите форум.'**
  String get forumDenied;

  /// No description provided for @forumFailure.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось выполнить действие. Проверьте подключение и повторите попытку.'**
  String get forumFailure;

  /// No description provided for @forumWriteUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Ответ не отправлен: тема закрыта или раздел архивирован. Обновите форум.'**
  String get forumWriteUnavailable;

  /// No description provided for @forumListTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обсуждения'**
  String get forumListTitle;

  /// No description provided for @forumListDescription.
  ///
  /// In ru, this message translates to:
  /// **'Разговоры нашего сообщества'**
  String get forumListDescription;

  /// No description provided for @forumReplies.
  ///
  /// In ru, this message translates to:
  /// **'Ответы'**
  String get forumReplies;

  /// No description provided for @forumAboutSection.
  ///
  /// In ru, this message translates to:
  /// **'Об этом разделе'**
  String get forumAboutSection;

  /// No description provided for @forumAboutTopic.
  ///
  /// In ru, this message translates to:
  /// **'О теме'**
  String get forumAboutTopic;

  /// No description provided for @forumState.
  ///
  /// In ru, this message translates to:
  /// **'Состояние'**
  String get forumState;

  /// No description provided for @forumOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыта'**
  String get forumOpen;

  /// No description provided for @forumClosedLabel.
  ///
  /// In ru, this message translates to:
  /// **'Закрыта'**
  String get forumClosedLabel;

  /// No description provided for @forumAuthor.
  ///
  /// In ru, this message translates to:
  /// **'Автор'**
  String get forumAuthor;

  /// No description provided for @forumCreated.
  ///
  /// In ru, this message translates to:
  /// **'Создана'**
  String get forumCreated;

  /// No description provided for @forumTopicAuthor.
  ///
  /// In ru, this message translates to:
  /// **'Автор темы'**
  String get forumTopicAuthor;

  /// No description provided for @forumAllTopics.
  ///
  /// In ru, this message translates to:
  /// **'Все темы раздела'**
  String get forumAllTopics;

  /// No description provided for @forumActions.
  ///
  /// In ru, this message translates to:
  /// **'Действия с темой'**
  String get forumActions;

  /// No description provided for @forumClosedHeading.
  ///
  /// In ru, this message translates to:
  /// **'Тема закрыта'**
  String get forumClosedHeading;

  /// No description provided for @forumClosedDescription.
  ///
  /// In ru, this message translates to:
  /// **'Новые ответы недоступны. Обсуждение можно читать.'**
  String get forumClosedDescription;

  /// No description provided for @forumPrivacyShort.
  ///
  /// In ru, this message translates to:
  /// **'Доступ определяется правами раздела. Сквозное шифрование недоступно.'**
  String get forumPrivacyShort;

  /// No description provided for @forumOrder.
  ///
  /// In ru, this message translates to:
  /// **'По порядку'**
  String get forumOrder;

  /// No description provided for @forumPin.
  ///
  /// In ru, this message translates to:
  /// **'Закрепить тему'**
  String get forumPin;

  /// No description provided for @forumUnpin.
  ///
  /// In ru, this message translates to:
  /// **'Открепить тему'**
  String get forumUnpin;

  /// No description provided for @forumPinned.
  ///
  /// In ru, this message translates to:
  /// **'Закреплено'**
  String get forumPinned;

  /// No description provided for @forumUnread.
  ///
  /// In ru, this message translates to:
  /// **'Непрочитано'**
  String get forumUnread;

  /// No description provided for @forumReadShown.
  ///
  /// In ru, this message translates to:
  /// **'Отметить показанное прочитанным'**
  String get forumReadShown;

  /// No description provided for @forumAuthorizeDevice.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить модерацию на устройстве'**
  String get forumAuthorizeDevice;

  /// No description provided for @forumDevicePermissionInfo.
  ///
  /// In ru, this message translates to:
  /// **'Корневая карточка вашей личности подпишет разрешение space.manage для этого устройства. Оно позволяет использовать уже назначенные права модератора, но не выдаёт роль или доступ к другим разделам. Если ключа нет на устройстве, выберите свою корневую карточку.'**
  String get forumDevicePermissionInfo;

  /// No description provided for @forumRootPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль корневой карточки'**
  String get forumRootPassword;

  /// No description provided for @forumFirstUnread.
  ///
  /// In ru, this message translates to:
  /// **'Первый непрочитанный ответ'**
  String get forumFirstUnread;

  /// No description provided for @forumRepliesFromStart.
  ///
  /// In ru, this message translates to:
  /// **'Показать ответы сначала'**
  String get forumRepliesFromStart;

  /// No description provided for @forumReopen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть тему снова'**
  String get forumReopen;

  /// No description provided for @forumHideTopic.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть тему'**
  String get forumHideTopic;

  /// No description provided for @forumRestoreTopic.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить тему'**
  String get forumRestoreTopic;

  /// No description provided for @forumHideReply.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть ответ'**
  String get forumHideReply;

  /// No description provided for @forumRestoreReply.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить ответ'**
  String get forumRestoreReply;

  /// No description provided for @forumHiddenTopic.
  ///
  /// In ru, this message translates to:
  /// **'Тема скрыта модератором'**
  String get forumHiddenTopic;

  /// No description provided for @forumHiddenReply.
  ///
  /// In ru, this message translates to:
  /// **'Ответ скрыт модератором'**
  String get forumHiddenReply;

  /// No description provided for @forumReason.
  ///
  /// In ru, this message translates to:
  /// **'Причина действия'**
  String get forumReason;

  /// No description provided for @forumReasonRequired.
  ///
  /// In ru, this message translates to:
  /// **'Укажите причину, не более 1024 байт'**
  String get forumReasonRequired;

  /// No description provided for @forumModerationNotice.
  ///
  /// In ru, this message translates to:
  /// **'Скрытое содержимое и его файлы недоступны до восстановления. Причина сохраняется в журнале модерации.'**
  String get forumModerationNotice;

  /// No description provided for @forumModerationLog.
  ///
  /// In ru, this message translates to:
  /// **'Журнал модерации'**
  String get forumModerationLog;

  /// No description provided for @forumModerationEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Действий модерации пока нет'**
  String get forumModerationEmpty;

  /// No description provided for @forumApply.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get forumApply;

  /// No description provided for @forumReport.
  ///
  /// In ru, this message translates to:
  /// **'Пожаловаться'**
  String get forumReport;

  /// No description provided for @forumReportNotice.
  ///
  /// In ru, this message translates to:
  /// **'Опишите нарушение. Жалоба доступна модераторам; данные заявителя не показываются. Повторная жалоба на этот объект не создаётся.'**
  String get forumReportNotice;

  /// No description provided for @forumReportsQueue.
  ///
  /// In ru, this message translates to:
  /// **'Очередь жалоб'**
  String get forumReportsQueue;

  /// No description provided for @forumReportsPending.
  ///
  /// In ru, this message translates to:
  /// **'Ожидают'**
  String get forumReportsPending;

  /// No description provided for @forumReportsResolved.
  ///
  /// In ru, this message translates to:
  /// **'Решения'**
  String get forumReportsResolved;

  /// No description provided for @forumReportsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Жалоб пока нет'**
  String get forumReportsEmpty;

  /// No description provided for @forumReportDismiss.
  ///
  /// In ru, this message translates to:
  /// **'Отклонить жалобу'**
  String get forumReportDismiss;

  /// No description provided for @forumReportHide.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть содержимое'**
  String get forumReportHide;

  /// No description provided for @forumReportDecisionNotice.
  ///
  /// In ru, this message translates to:
  /// **'Укажите причину решения. Решение и причина сохранятся в журнале модерации.'**
  String get forumReportDecisionNotice;

  /// No description provided for @forumReportOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть обсуждение'**
  String get forumReportOpen;

  /// No description provided for @forumReportTopic.
  ///
  /// In ru, this message translates to:
  /// **'Жалоба на тему'**
  String get forumReportTopic;

  /// No description provided for @forumReportReply.
  ///
  /// In ru, this message translates to:
  /// **'Жалоба на ответ'**
  String get forumReportReply;

  /// No description provided for @feedPrivacy.
  ///
  /// In ru, this message translates to:
  /// **'Публикации доступны серверу. Сквозное шифрование не используется.'**
  String get feedPrivacy;

  /// No description provided for @feedSections.
  ///
  /// In ru, this message translates to:
  /// **'Разделы ленты'**
  String get feedSections;

  /// No description provided for @feedPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Права публикации и комментариев'**
  String get feedPolicy;

  /// No description provided for @feedEmptySections.
  ///
  /// In ru, this message translates to:
  /// **'Доступных разделов ленты пока нет.'**
  String get feedEmptySections;

  /// No description provided for @feedEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Публикаций пока нет.'**
  String get feedEmpty;

  /// No description provided for @feedOpenUnread.
  ///
  /// In ru, this message translates to:
  /// **'Открыть непрочитанное'**
  String get feedOpenUnread;

  /// No description provided for @feedReadOnly.
  ///
  /// In ru, this message translates to:
  /// **'У вас нет права публиковать в этом разделе.'**
  String get feedReadOnly;

  /// No description provided for @feedBack.
  ///
  /// In ru, this message translates to:
  /// **'К публикациям'**
  String get feedBack;

  /// No description provided for @feedComments.
  ///
  /// In ru, this message translates to:
  /// **'Комментарии'**
  String get feedComments;

  /// No description provided for @feedHiddenPost.
  ///
  /// In ru, this message translates to:
  /// **'Публикация скрыта модератором.'**
  String get feedHiddenPost;

  /// No description provided for @feedHiddenComment.
  ///
  /// In ru, this message translates to:
  /// **'Комментарий скрыт модератором.'**
  String get feedHiddenComment;

  /// No description provided for @feedRestoreComment.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить комментарий'**
  String get feedRestoreComment;

  /// No description provided for @feedRestorePost.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить публикацию'**
  String get feedRestorePost;

  /// No description provided for @feedSendFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отправить. Текст и файлы сохранены. Проверьте права и подключение и повторите попытку.'**
  String get feedSendFailed;

  /// No description provided for @feedPublishPermission.
  ///
  /// In ru, this message translates to:
  /// **'Публиковать записи'**
  String get feedPublishPermission;

  /// No description provided for @feedCommentPermission.
  ///
  /// In ru, this message translates to:
  /// **'Оставлять комментарии'**
  String get feedCommentPermission;

  /// No description provided for @feedPolicyHelp.
  ///
  /// In ru, this message translates to:
  /// **'Публикация и комментирование разрешаются отдельно. Без правила оба действия запрещены. Правило участника заменяет правило роли. Читатель может комментировать по явному разрешению, но не публиковать.'**
  String get feedPolicyHelp;

  /// No description provided for @feedPrincipal.
  ///
  /// In ru, this message translates to:
  /// **'Идентификатор участника — необязательно; иначе применяется роль'**
  String get feedPrincipal;

  /// No description provided for @feedRole.
  ///
  /// In ru, this message translates to:
  /// **'Роль'**
  String get feedRole;

  /// No description provided for @feedAddRule.
  ///
  /// In ru, this message translates to:
  /// **'Добавить правило'**
  String get feedAddRule;

  /// No description provided for @feedRemoveRule.
  ///
  /// In ru, this message translates to:
  /// **'Удалить правило'**
  String get feedRemoveRule;

  /// No description provided for @feedPost.
  ///
  /// In ru, this message translates to:
  /// **'Публикация'**
  String get feedPost;

  /// No description provided for @feedComment.
  ///
  /// In ru, this message translates to:
  /// **'Комментарий'**
  String get feedComment;

  /// No description provided for @feedOpenPost.
  ///
  /// In ru, this message translates to:
  /// **'Открыть публикацию'**
  String get feedOpenPost;

  /// No description provided for @feedUpdateRuntime.
  ///
  /// In ru, this message translates to:
  /// **'Сервер ещё не поддерживает ленту. Обновите сервер через «Эфир».'**
  String get feedUpdateRuntime;

  /// No description provided for @feedConnectFirst.
  ///
  /// In ru, this message translates to:
  /// **'Подключитесь к пространству, чтобы открыть ленту.'**
  String get feedConnectFirst;

  /// No description provided for @feedConflict.
  ///
  /// In ru, this message translates to:
  /// **'Публикация или права изменились. Обновите данные и повторите действие.'**
  String get feedConflict;

  /// No description provided for @feedDenied.
  ///
  /// In ru, this message translates to:
  /// **'Доступ отозван или раздел недоступен. Обновите ленту.'**
  String get feedDenied;

  /// No description provided for @feedWriteUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Действие недоступно: публикация скрыта или раздел архивирован. Обновите ленту.'**
  String get feedWriteUnavailable;

  /// No description provided for @feedInvalidText.
  ///
  /// In ru, this message translates to:
  /// **'Введите текст до 8192 байт UTF-8 или прикрепите файл.'**
  String get feedInvalidText;

  /// No description provided for @feedActions.
  ///
  /// In ru, this message translates to:
  /// **'Действия'**
  String get feedActions;

  /// No description provided for @feedMemberRole.
  ///
  /// In ru, this message translates to:
  /// **'Участники'**
  String get feedMemberRole;

  /// No description provided for @feedReaderRole.
  ///
  /// In ru, this message translates to:
  /// **'Читатели'**
  String get feedReaderRole;

  /// No description provided for @communitySearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск в разделе'**
  String get communitySearchHint;

  /// No description provided for @communitySearchEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Совпадений нет'**
  String get communitySearchEmpty;

  /// No description provided for @communitySearchInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите текст от 1 до 256 байт UTF-8'**
  String get communitySearchInvalid;

  /// No description provided for @communitySearchThread.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get communitySearchThread;

  /// No description provided for @communitySearchReply.
  ///
  /// In ru, this message translates to:
  /// **'Ответ'**
  String get communitySearchReply;

  /// No description provided for @communitySearchPost.
  ///
  /// In ru, this message translates to:
  /// **'Публикация'**
  String get communitySearchPost;

  /// No description provided for @communitySearchComment.
  ///
  /// In ru, this message translates to:
  /// **'Комментарий'**
  String get communitySearchComment;

  /// No description provided for @communitySearchRevoked.
  ///
  /// In ru, this message translates to:
  /// **'Раздел больше недоступен'**
  String get communitySearchRevoked;

  /// No description provided for @dashboardAttention.
  ///
  /// In ru, this message translates to:
  /// **'Требует внимания'**
  String get dashboardAttention;

  /// No description provided for @dashboardAttentionEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Всё спокойно — новых задач нет.'**
  String get dashboardAttentionEmpty;

  /// No description provided for @dashboardChecking.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем обновления…'**
  String get dashboardChecking;

  /// No description provided for @dashboardAttentionLimit.
  ///
  /// In ru, this message translates to:
  /// **'Показаны ближайшие задачи. Остальные доступны внутри пространств.'**
  String get dashboardAttentionLimit;

  /// No description provided for @dashboardConnectionIssue.
  ///
  /// In ru, this message translates to:
  /// **'Проблема подключения'**
  String get dashboardConnectionIssue;

  /// No description provided for @dashboardPendingReports.
  ///
  /// In ru, this message translates to:
  /// **'Жалобы на рассмотрении'**
  String get dashboardPendingReports;

  /// No description provided for @dashboardRepliesToYou.
  ///
  /// In ru, this message translates to:
  /// **'Ответы в вашей теме'**
  String get dashboardRepliesToYou;

  /// No description provided for @dashboardCommunityNews.
  ///
  /// In ru, this message translates to:
  /// **'Новое в сообществах'**
  String get dashboardCommunityNews;

  /// No description provided for @dashboardCommunityDescription.
  ///
  /// In ru, this message translates to:
  /// **'Свежие темы и публикации из доступных вам разделов. Счётчики показывают непрочитанное там, где сервер поддерживает отметки чтения.'**
  String get dashboardCommunityDescription;

  /// No description provided for @dashboardCommunityFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить часть разделов. Повторите попытку.'**
  String get dashboardCommunityFailed;

  /// No description provided for @dashboardCommunityUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Для сводки сообществ обновите сервер.'**
  String get dashboardCommunityUnsupported;

  /// No description provided for @dashboardCommunityEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет доступных тем и публикаций.'**
  String get dashboardCommunityEmpty;

  /// No description provided for @dashboardAttentionUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Часть разделов пока не проверена.'**
  String get dashboardAttentionUnknown;

  /// No description provided for @dashboardAttachmentPost.
  ///
  /// In ru, this message translates to:
  /// **'Публикация с вложениями'**
  String get dashboardAttachmentPost;

  /// No description provided for @dashboardCommunityOffline.
  ///
  /// In ru, this message translates to:
  /// **'Данные недоступных пространств появятся после подключения.'**
  String get dashboardCommunityOffline;

  /// No description provided for @communityMention.
  ///
  /// In ru, this message translates to:
  /// **'Упомянуть участника'**
  String get communityMention;

  /// No description provided for @communityMentionQuery.
  ///
  /// In ru, this message translates to:
  /// **'Имя или ID участника'**
  String get communityMentionQuery;

  /// No description provided for @communityMentionFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось получить участников. Проверьте доступ и повторите поиск.'**
  String get communityMentionFailed;

  /// No description provided for @communityMentionEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Участники не найдены'**
  String get communityMentionEmpty;

  /// No description provided for @dashboardMention.
  ///
  /// In ru, this message translates to:
  /// **'Вас упомянули'**
  String get dashboardMention;

  /// No description provided for @dashboardFeedRepliesToYou.
  ///
  /// In ru, this message translates to:
  /// **'Ответы на вашу публикацию'**
  String get dashboardFeedRepliesToYou;

  /// No description provided for @appearanceTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get appearanceTheme;

  /// No description provided for @appearanceThemeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Автоматическая'**
  String get appearanceThemeSystem;

  /// No description provided for @appearanceThemeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get appearanceThemeLight;

  /// No description provided for @appearanceThemeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get appearanceThemeDark;

  /// No description provided for @notificationSection.
  ///
  /// In ru, this message translates to:
  /// **'Раздел'**
  String get notificationSection;

  /// No description provided for @notificationInboxEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Непросмотренных уведомлений нет'**
  String get notificationInboxEmpty;

  /// No description provided for @notificationInboxFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить уведомления. Проверьте подключение и доступ.'**
  String get notificationInboxFailed;

  /// No description provided for @notificationMarkRead.
  ///
  /// In ru, this message translates to:
  /// **'Отметить просмотренным'**
  String get notificationMarkRead;

  /// No description provided for @notificationRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить уведомления'**
  String get notificationRefresh;

  /// No description provided for @notificationPrevious.
  ///
  /// In ru, this message translates to:
  /// **'Предыдущая страница'**
  String get notificationPrevious;

  /// No description provided for @notificationNext.
  ///
  /// In ru, this message translates to:
  /// **'Следующая страница'**
  String get notificationNext;

  /// No description provided for @notificationUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных разделов'**
  String get notificationUnavailable;

  /// No description provided for @notificationReply.
  ///
  /// In ru, this message translates to:
  /// **'Ответ вам'**
  String get notificationReply;

  /// No description provided for @notificationOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть'**
  String get notificationOpen;

  /// No description provided for @mlsMentionsLegacy.
  ///
  /// In ru, this message translates to:
  /// **'Не все устройства подтвердили поддержку упоминаний. Отправится только имя без отметки обращения.'**
  String get mlsMentionsLegacy;

  /// No description provided for @mlsCancelRetry.
  ///
  /// In ru, this message translates to:
  /// **'Отменить отложенные отправки после смены состава'**
  String get mlsCancelRetry;

  /// No description provided for @profileAvatar.
  ///
  /// In ru, this message translates to:
  /// **'Аватар в пространстве'**
  String get profileAvatar;

  /// No description provided for @chooseAvatar.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать изображение'**
  String get chooseAvatar;

  /// No description provided for @removeAvatar.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аватар'**
  String get removeAvatar;

  /// No description provided for @avatarInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Выберите статичный PNG или JPEG до 5 МиБ и 4 миллионов пикселей.'**
  String get avatarInvalid;

  /// No description provided for @profileConflict.
  ///
  /// In ru, this message translates to:
  /// **'Профиль изменён на другом устройстве. Обновите его и повторите сохранение; ваш ввод сохранён.'**
  String get profileConflict;

  /// No description provided for @profileSaved.
  ///
  /// In ru, this message translates to:
  /// **'Профиль сохранён'**
  String get profileSaved;

  /// No description provided for @saveProfile.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить профиль'**
  String get saveProfile;

  /// No description provided for @profileSpaceHelp.
  ///
  /// In ru, this message translates to:
  /// **'Имя уникально в этом пространстве. Имя и аватар общие для всех его разделов.'**
  String get profileSpaceHelp;

  /// No description provided for @communityReactionsRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить запрос'**
  String get communityReactionsRetry;

  /// No description provided for @communityReactionsFailure.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить реакции.'**
  String get communityReactionsFailure;

  /// No description provided for @communityReactionsConflict.
  ///
  /// In ru, this message translates to:
  /// **'Реакции изменились. Проверьте выбор и повторите действие.'**
  String get communityReactionsConflict;

  /// No description provided for @communityReactionsDenied.
  ///
  /// In ru, this message translates to:
  /// **'Реакции недоступны: доступ или состояние раздела изменились.'**
  String get communityReactionsDenied;

  /// No description provided for @communityFavorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get communityFavorites;

  /// No description provided for @communityFavoriteAdd.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить в избранное'**
  String get communityFavoriteAdd;

  /// No description provided for @communityFavoriteRemove.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из избранного'**
  String get communityFavoriteRemove;

  /// No description provided for @communityFavoriteRetry.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить избранное. Повторить'**
  String get communityFavoriteRetry;

  /// No description provided for @communityFavoritesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В этом разделе пока нет избранного.'**
  String get communityFavoritesEmpty;

  /// No description provided for @spaceSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск в пространстве'**
  String get spaceSearch;

  /// No description provided for @spaceSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск в чатах, форуме и ленте'**
  String get spaceSearchHint;

  /// No description provided for @spaceSearchChat.
  ///
  /// In ru, this message translates to:
  /// **'Сообщение'**
  String get spaceSearchChat;

  /// No description provided for @spaceSearchChatMode.
  ///
  /// In ru, this message translates to:
  /// **'Поиск в выбранном чате и локальном MLS'**
  String get spaceSearchChatMode;

  /// No description provided for @spaceSearchLimit.
  ///
  /// In ru, this message translates to:
  /// **'Показаны первые 500 результатов. Уточните запрос.'**
  String get spaceSearchLimit;

  /// No description provided for @feedCancelReference.
  ///
  /// In ru, this message translates to:
  /// **'Убрать ссылку'**
  String get feedCancelReference;

  /// No description provided for @feedOpenOriginal.
  ///
  /// In ru, this message translates to:
  /// **'Открыть оригинал'**
  String get feedOpenOriginal;

  /// No description provided for @feedOriginalUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Исходная публикация недоступна'**
  String get feedOriginalUnavailable;

  /// No description provided for @feedReply.
  ///
  /// In ru, this message translates to:
  /// **'Ответить'**
  String get feedReply;

  /// No description provided for @feedReplyTo.
  ///
  /// In ru, this message translates to:
  /// **'Ответ на комментарий №{number}'**
  String feedReplyTo(String number);

  /// No description provided for @feedRepost.
  ///
  /// In ru, this message translates to:
  /// **'Репост'**
  String get feedRepost;

  /// No description provided for @feedRepostHint.
  ///
  /// In ru, this message translates to:
  /// **'Отправьте без текста для репоста или добавьте свою цитату.'**
  String get feedRepostHint;

  /// No description provided for @feedShare.
  ///
  /// In ru, this message translates to:
  /// **'Репост или цитата'**
  String get feedShare;

  /// No description provided for @followAdd.
  ///
  /// In ru, this message translates to:
  /// **'Подписаться'**
  String get followAdd;

  /// No description provided for @followingEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Вы пока ни на кого не подписаны.'**
  String get followingEmpty;

  /// No description provided for @followingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подписки'**
  String get followingTitle;

  /// No description provided for @followRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить подписки'**
  String get followRefresh;

  /// No description provided for @followRemove.
  ///
  /// In ru, this message translates to:
  /// **'Отписаться'**
  String get followRemove;

  /// No description provided for @followRevoked.
  ///
  /// In ru, this message translates to:
  /// **'Доступ или пространство изменились. Откройте ленту заново.'**
  String get followRevoked;

  /// No description provided for @followUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Участник недоступен'**
  String get followUnavailable;

  /// No description provided for @personalFeed.
  ///
  /// In ru, this message translates to:
  /// **'Моя лента'**
  String get personalFeed;

  /// No description provided for @personalFeedEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся публикации авторов, на которых вы подписаны, из доступных разделов. Подпишитесь на автора у его публикации или комментария.'**
  String get personalFeedEmpty;

  /// No description provided for @personalFeedLimit.
  ///
  /// In ru, this message translates to:
  /// **'Показаны первые 500 публикаций. Обновите ленту, чтобы увидеть новые.'**
  String get personalFeedLimit;

  /// No description provided for @personalFeedOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть обсуждение'**
  String get personalFeedOpen;

  /// No description provided for @userExportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт моего содержимого'**
  String get userExportTitle;

  /// No description provided for @userExportHelp.
  ///
  /// In ru, this message translates to:
  /// **'Собственное содержимое доступных неархивных разделов в JSON. Вложения — только метаданные, без файлов. MLS, ключи и токены не входят. До 5000 записей и 8 МиБ за один период.'**
  String get userExportHelp;

  /// No description provided for @userExportSection.
  ///
  /// In ru, this message translates to:
  /// **'Раздел'**
  String get userExportSection;

  /// No description provided for @userExportAll.
  ///
  /// In ru, this message translates to:
  /// **'Все доступные разделы'**
  String get userExportAll;

  /// No description provided for @userExportAfter.
  ///
  /// In ru, this message translates to:
  /// **'С даты (UTC, необязательно)'**
  String get userExportAfter;

  /// No description provided for @userExportBefore.
  ///
  /// In ru, this message translates to:
  /// **'По дату включительно (UTC, необязательно)'**
  String get userExportBefore;

  /// No description provided for @userExportPrepare.
  ///
  /// In ru, this message translates to:
  /// **'Подготовить JSON'**
  String get userExportPrepare;

  /// No description provided for @userExportSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить JSON'**
  String get userExportSave;

  /// No description provided for @userExportReady.
  ///
  /// In ru, this message translates to:
  /// **'Записей подготовлено'**
  String get userExportReady;

  /// No description provided for @userExportSaved.
  ///
  /// In ru, this message translates to:
  /// **'Экспорт сохранён'**
  String get userExportSaved;

  /// No description provided for @userExportInvalidPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Укажите корректные даты YYYY-MM-DD и период.'**
  String get userExportInvalidPeriod;

  /// No description provided for @pairingNetworkError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось опросить сервер. Проверка повторится автоматически до истечения кода.'**
  String get pairingNetworkError;

  /// No description provided for @pairingVerificationError.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение не прошло проверку. Начните сопряжение заново.'**
  String get pairingVerificationError;

  /// No description provided for @pairingQrInvalid.
  ///
  /// In ru, this message translates to:
  /// **'QR повреждён, истёк или относится к другому пространству. Считайте новый QR на подключаемом устройстве.'**
  String get pairingQrInvalid;

  /// No description provided for @directoryBackupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Резервная копия каталога'**
  String get directoryBackupTitle;

  /// No description provided for @directoryBackupHelp.
  ///
  /// In ru, this message translates to:
  /// **'Пространства, настройки и подписки без рабочих ключей и истории. Пароль — не менее 12 символов. Для возврата доступа нужна recovery-карточка или сопряжение.'**
  String get directoryBackupHelp;

  /// No description provided for @directoryBackupCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать копию'**
  String get directoryBackupCreate;

  /// No description provided for @directoryBackupRead.
  ///
  /// In ru, this message translates to:
  /// **'Проверить копию'**
  String get directoryBackupRead;

  /// No description provided for @directoryBackupApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить каталог'**
  String get directoryBackupApply;

  /// No description provided for @directoryBackupSettings.
  ///
  /// In ru, this message translates to:
  /// **'Заменить настройки интерфейса настройками из копии'**
  String get directoryBackupSettings;

  /// No description provided for @directoryBackupFollows.
  ///
  /// In ru, this message translates to:
  /// **'Добавить подписки из каталога'**
  String get directoryBackupFollows;

  /// No description provided for @directoryBackupResume.
  ///
  /// In ru, this message translates to:
  /// **'Завершить прерванное восстановление'**
  String get directoryBackupResume;

  /// No description provided for @directoryBackupUnverified.
  ///
  /// In ru, this message translates to:
  /// **'Новизна этой копии неизвестна: для неё нет локального свидетеля версии.'**
  String get directoryBackupUnverified;

  /// No description provided for @directoryBackupResults.
  ///
  /// In ru, this message translates to:
  /// **'Результаты по пространствам (при сохранении перечислены неполные снимки подписок):'**
  String get directoryBackupResults;

  /// No description provided for @directoryBackupSaved.
  ///
  /// In ru, this message translates to:
  /// **'Копия сохранена и проверена. Сохраните пароль отдельно.'**
  String get directoryBackupSaved;

  /// No description provided for @directoryBackupRestored.
  ///
  /// In ru, this message translates to:
  /// **'Локальное восстановление завершено. Подписки применяются отдельной командой после входа той же личности.'**
  String get directoryBackupRestored;

  /// No description provided for @directoryBackupError.
  ///
  /// In ru, this message translates to:
  /// **'Операция не завершена. Проверьте пароль, целостность копии и доступ к хранилищу. Незавершённое применение можно повторить.'**
  String get directoryBackupError;

  /// No description provided for @directoryBackupConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Применить проверенный каталог? Существующие ключи доступа не заменяются. Выбранные настройки будут применены; при сбое можно завершить восстановление повторно.'**
  String get directoryBackupConfirm;

  /// No description provided for @directoryBackupFollowsHelp.
  ///
  /// In ru, this message translates to:
  /// **'Добавить отсутствующие подписки для подключённых пространств с той же личностью? Существующие подписки не удаляются. Сервер проверяет права; возможен частичный результат.'**
  String get directoryBackupFollowsHelp;

  /// No description provided for @directoryBackupPreview.
  ///
  /// In ru, this message translates to:
  /// **'Пространств в копии: {count}'**
  String directoryBackupPreview(int count);
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
