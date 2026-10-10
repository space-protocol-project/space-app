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
  /// **'Идентичность'**
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
  /// **'Недавние пространства'**
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
  /// **'Моя идентичность'**
  String get myIdentity;

  /// No description provided for @aboutSpace.
  ///
  /// In ru, this message translates to:
  /// **'О пространстве'**
  String get aboutSpace;

  /// No description provided for @independentServer.
  ///
  /// In ru, this message translates to:
  /// **'Независимый сервер. Ваши права и доступные разделы определяются отдельно в каждом пространстве.'**
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
  /// **'Не обязательно отвечать сразу. Камера и микрофон не используются; системные уведомления пока выключены.'**
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
  /// **'Хорошо, что вы здесь.'**
  String get welcome;

  /// No description provided for @welcomeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Ваше пространство, ваши разговоры — в удобном темпе.'**
  String get welcomeDescription;

  /// No description provided for @ideas.
  ///
  /// In ru, this message translates to:
  /// **'Место для идей.\nИ людей за ними.'**
  String get ideas;

  /// No description provided for @connectDescription.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте независимый сервер по адресу, проверьте доверие и продолжите разговор. Центральный аккаунт не нужен.'**
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
  /// **'Пространство ещё не подключено. Здесь появятся реальные сообщения выбранного сервера.'**
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
  /// **'Пусть будет удобно вам.'**
  String get settingsTitle;

  /// No description provided for @settingsDescription.
  ///
  /// In ru, this message translates to:
  /// **'Личное оформление сохраняется на этом устройстве.'**
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
  /// **'Адрес независимого сервера. Сначала проверим его, затем вы решите, доверять ли ему.'**
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
