import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'admin_localizations_en.dart';
import 'admin_localizations_ru.dart';
import 'admin_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AdminLocalizations
/// returned by `AdminLocalizations.of(context)`.
///
/// Applications need to include `AdminLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/admin_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AdminLocalizations.localizationsDelegates,
///   supportedLocales: AdminLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AdminLocalizations.supportedLocales
/// property.
abstract class AdminLocalizations {
  AdminLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AdminLocalizations? of(BuildContext context) {
    return Localizations.of<AdminLocalizations>(context, AdminLocalizations);
  }

  static const LocalizationsDelegate<AdminLocalizations> delegate =
      _AdminLocalizationsDelegate();

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
    Locale('en'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @closeManagement.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть управление'**
  String get closeManagement;

  /// No description provided for @managementTitle.
  ///
  /// In ru, this message translates to:
  /// **'Управление пространством'**
  String get managementTitle;

  /// No description provided for @managementIntro.
  ///
  /// In ru, this message translates to:
  /// **'Ваш сервер. Ваши правила. Владелец домашнего сервера назначается локальным кодом настройки.'**
  String get managementIntro;

  /// No description provided for @managementSections.
  ///
  /// In ru, this message translates to:
  /// **'Настройки, каналы, участники, приглашения и устройства выбранного сервера.'**
  String get managementSections;

  /// No description provided for @deviceIdentity.
  ///
  /// In ru, this message translates to:
  /// **'Текущая идентичность устройства'**
  String get deviceIdentity;

  /// No description provided for @currentConnection.
  ///
  /// In ru, this message translates to:
  /// **'Используется идентичность текущего подключения. Дополнительный аккаунт не нужен.'**
  String get currentConnection;

  /// No description provided for @currentSession.
  ///
  /// In ru, this message translates to:
  /// **'Используется текущая сессия приложения Space. Для восстановления откройте раздел идентичности.'**
  String get currentSession;

  /// No description provided for @connectManagement.
  ///
  /// In ru, this message translates to:
  /// **'Подключить управление текущим сервером'**
  String get connectManagement;

  /// No description provided for @claimOwner.
  ///
  /// In ru, this message translates to:
  /// **'Назначить первого владельца'**
  String get claimOwner;

  /// No description provided for @setupHelp.
  ///
  /// In ru, this message translates to:
  /// **'Получите код в консоли сервера: space-server -setup-code. Он действует 15 минут.'**
  String get setupHelp;

  /// No description provided for @setupCode.
  ///
  /// In ru, this message translates to:
  /// **'Одноразовый код сервера'**
  String get setupCode;

  /// No description provided for @confirmOwner.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить владение'**
  String get confirmOwner;

  /// No description provided for @authorizeFirst.
  ///
  /// In ru, this message translates to:
  /// **'Сначала явно выдайте разрешение этому устройству в блоке ниже'**
  String get authorizeFirst;

  /// No description provided for @authorizeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить этому устройству управление сервером'**
  String get authorizeTitle;

  /// No description provided for @authorizeHelp.
  ///
  /// In ru, this message translates to:
  /// **'Разрешение space.manage подписывается вашим корневым ключом. Оно действует вместе с ролью владельца или администратора.'**
  String get authorizeHelp;

  /// No description provided for @authorizeDevice.
  ///
  /// In ru, this message translates to:
  /// **'Выдать разрешение этому устройству'**
  String get authorizeDevice;

  /// No description provided for @authorizeConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить управление сервером?'**
  String get authorizeConfirm;

  /// No description provided for @authorizeDetails.
  ///
  /// In ru, this message translates to:
  /// **'Вы явно разрешаете этому устройству менять настройки, каналы и доступ участников.'**
  String get authorizeDetails;

  /// No description provided for @rootPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль корневой карточки JSON/PNG'**
  String get rootPassword;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @allow.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить'**
  String get allow;

  /// No description provided for @spaceName.
  ///
  /// In ru, this message translates to:
  /// **'Название пространства'**
  String get spaceName;

  /// No description provided for @chatName.
  ///
  /// In ru, this message translates to:
  /// **'Название общего чата'**
  String get chatName;

  /// No description provided for @chatsEnabled.
  ///
  /// In ru, this message translates to:
  /// **'Чаты доступны участникам'**
  String get chatsEnabled;

  /// No description provided for @chatsHelp.
  ///
  /// In ru, this message translates to:
  /// **'Выключение закрывает чтение и отправку. История сохраняется.'**
  String get chatsHelp;

  /// No description provided for @registration.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get registration;

  /// No description provided for @registrationOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыта'**
  String get registrationOpen;

  /// No description provided for @registrationClosed.
  ///
  /// In ru, this message translates to:
  /// **'По приглашению'**
  String get registrationClosed;

  /// No description provided for @saveSettings.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить настройки'**
  String get saveSettings;

  /// No description provided for @reloadSettings.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить заново'**
  String get reloadSettings;

  /// No description provided for @settingsLoaded.
  ///
  /// In ru, this message translates to:
  /// **'Настройки загружены с сервера.'**
  String get settingsLoaded;

  /// No description provided for @settingsSaved.
  ///
  /// In ru, this message translates to:
  /// **'Настройки сохранены на сервере.'**
  String get settingsSaved;

  /// No description provided for @setupNeeded.
  ///
  /// In ru, this message translates to:
  /// **'Устройство вошло. Укажите одноразовый код сервера для назначения владельца.'**
  String get setupNeeded;

  /// No description provided for @roleDenied.
  ///
  /// In ru, this message translates to:
  /// **'Вход выполнен, но ваша роль не разрешает настройку сервера.'**
  String get roleDenied;

  /// No description provided for @deviceRevoked.
  ///
  /// In ru, this message translates to:
  /// **'Это устройство отозвано. Восстановите доступ или используйте другое устройство.'**
  String get deviceRevoked;

  /// No description provided for @signInFirst.
  ///
  /// In ru, this message translates to:
  /// **'Сначала войдите'**
  String get signInFirst;

  /// No description provided for @identityChanged.
  ///
  /// In ru, this message translates to:
  /// **'Идентичность изменилась. Войдите заново'**
  String get identityChanged;

  /// No description provided for @accessBlocked.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к пространству заблокирован'**
  String get accessBlocked;

  /// No description provided for @bothNames.
  ///
  /// In ru, this message translates to:
  /// **'Укажите оба названия'**
  String get bothNames;

  /// No description provided for @settingsConflict.
  ///
  /// In ru, this message translates to:
  /// **'Настройки уже изменены. Загрузите их заново и повторите изменения.'**
  String get settingsConflict;

  /// No description provided for @settingsRevision.
  ///
  /// In ru, this message translates to:
  /// **'Настройки пространства · версия {revision}'**
  String settingsRevision(String revision);
}

class _AdminLocalizationsDelegate
    extends LocalizationsDelegate<AdminLocalizations> {
  const _AdminLocalizationsDelegate();

  @override
  Future<AdminLocalizations> load(Locale locale) {
    return SynchronousFuture<AdminLocalizations>(
      lookupAdminLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AdminLocalizationsDelegate old) => false;
}

AdminLocalizations lookupAdminLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AdminLocalizationsEn();
    case 'ru':
      return AdminLocalizationsRu();
    case 'zh':
      return AdminLocalizationsZh();
  }

  throw FlutterError(
    'AdminLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
