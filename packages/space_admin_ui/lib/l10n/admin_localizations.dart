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

  /// No description provided for @channelsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Каналы и права'**
  String get channelsTitle;

  /// No description provided for @channelsReload.
  ///
  /// In ru, this message translates to:
  /// **'Обновить список каналов'**
  String get channelsReload;

  /// No description provided for @channelsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Каналов пока нет.'**
  String get channelsEmpty;

  /// No description provided for @channelCreateSection.
  ///
  /// In ru, this message translates to:
  /// **'Создать чат-канал'**
  String get channelCreateSection;

  /// No description provided for @channelNewId.
  ///
  /// In ru, this message translates to:
  /// **'Адрес нового канала'**
  String get channelNewId;

  /// No description provided for @channelNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Название нового канала'**
  String get channelNewTitle;

  /// No description provided for @channelNewOrder.
  ///
  /// In ru, this message translates to:
  /// **'Порядок нового канала'**
  String get channelNewOrder;

  /// No description provided for @channelDefaults.
  ///
  /// In ru, this message translates to:
  /// **'Участники смогут читать и писать, читатели — читать. Публичный предпросмотр выключен.'**
  String get channelDefaults;

  /// No description provided for @channelCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать канал'**
  String get channelCreate;

  /// No description provided for @channelName.
  ///
  /// In ru, this message translates to:
  /// **'Название канала'**
  String get channelName;

  /// No description provided for @channelOrder.
  ///
  /// In ru, this message translates to:
  /// **'Порядок канала'**
  String get channelOrder;

  /// No description provided for @channelArchive.
  ///
  /// In ru, this message translates to:
  /// **'Архивировать канал'**
  String get channelArchive;

  /// No description provided for @channelPublicPreview.
  ///
  /// In ru, this message translates to:
  /// **'Показывать название посетителям без входа'**
  String get channelPublicPreview;

  /// No description provided for @channelPreviewHelp.
  ///
  /// In ru, this message translates to:
  /// **'Предпросмотр раскрывает название и адрес, но не сообщения. Архив сохраняет историю и запрещает новую запись.'**
  String get channelPreviewHelp;

  /// No description provided for @channelSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить канал'**
  String get channelSave;

  /// No description provided for @channelReload.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить канал заново'**
  String get channelReload;

  /// No description provided for @channelAccessHelp.
  ///
  /// In ru, this message translates to:
  /// **'Индивидуальное правило заменяет правило роли. Владелец и администраторы сохраняют доступ. Читатель не получает отправку. «Управлять» меняет метаданные, но не права.'**
  String get channelAccessHelp;

  /// No description provided for @channelRulesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Правил нет: доступ только у администрации.'**
  String get channelRulesEmpty;

  /// No description provided for @channelRuleSubject.
  ///
  /// In ru, this message translates to:
  /// **'Кому добавить правило'**
  String get channelRuleSubject;

  /// No description provided for @channelMembers.
  ///
  /// In ru, this message translates to:
  /// **'Участники'**
  String get channelMembers;

  /// No description provided for @channelReaders.
  ///
  /// In ru, this message translates to:
  /// **'Читатели'**
  String get channelReaders;

  /// No description provided for @channelIndividual.
  ///
  /// In ru, this message translates to:
  /// **'Отдельный участник'**
  String get channelIndividual;

  /// No description provided for @channelSelectMember.
  ///
  /// In ru, this message translates to:
  /// **'Выберите участника'**
  String get channelSelectMember;

  /// No description provided for @channelMoreMembers.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить ещё участников'**
  String get channelMoreMembers;

  /// No description provided for @channelPrincipalId.
  ///
  /// In ru, this message translates to:
  /// **'Или полный идентификатор участника'**
  String get channelPrincipalId;

  /// No description provided for @channelAddRule.
  ///
  /// In ru, this message translates to:
  /// **'Добавить правило'**
  String get channelAddRule;

  /// No description provided for @channelSaveAccess.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить права'**
  String get channelSaveAccess;

  /// No description provided for @channelDeleteRule.
  ///
  /// In ru, this message translates to:
  /// **'Удалить правило'**
  String get channelDeleteRule;

  /// No description provided for @channelVisible.
  ///
  /// In ru, this message translates to:
  /// **'Видеть канал'**
  String get channelVisible;

  /// No description provided for @channelRead.
  ///
  /// In ru, this message translates to:
  /// **'Читать сообщения'**
  String get channelRead;

  /// No description provided for @channelWrite.
  ///
  /// In ru, this message translates to:
  /// **'Отправлять сообщения'**
  String get channelWrite;

  /// No description provided for @channelManage.
  ///
  /// In ru, this message translates to:
  /// **'Управлять каналом'**
  String get channelManage;

  /// No description provided for @channelsLoaded.
  ///
  /// In ru, this message translates to:
  /// **'Каналы загружены.'**
  String get channelsLoaded;

  /// No description provided for @channelLoaded.
  ///
  /// In ru, this message translates to:
  /// **'Канал и права загружены.'**
  String get channelLoaded;

  /// No description provided for @channelCreated.
  ///
  /// In ru, this message translates to:
  /// **'Канал создан.'**
  String get channelCreated;

  /// No description provided for @channelSaved.
  ///
  /// In ru, this message translates to:
  /// **'Настройки канала сохранены.'**
  String get channelSaved;

  /// No description provided for @channelAccessSaved.
  ///
  /// In ru, this message translates to:
  /// **'Права канала сохранены.'**
  String get channelAccessSaved;

  /// No description provided for @channelRuleAdded.
  ///
  /// In ru, this message translates to:
  /// **'Правило добавлено в форму. Сохраните права для применения.'**
  String get channelRuleAdded;

  /// No description provided for @channelConflict.
  ///
  /// In ru, this message translates to:
  /// **'Канал или права уже изменены. Загрузите их заново; несохранённые поля остаются в форме.'**
  String get channelConflict;

  /// No description provided for @channelChanged.
  ///
  /// In ru, this message translates to:
  /// **'Канал изменился между загрузкой списка и прав'**
  String get channelChanged;

  /// No description provided for @channelOrderInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Порядок должен быть от 0 до 100000'**
  String get channelOrderInvalid;

  /// No description provided for @channelNameInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Укажите название до 320 байт'**
  String get channelNameInvalid;

  /// No description provided for @channelIdInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Адрес: латинские буквы, цифры, _ или -, начиная с буквы'**
  String get channelIdInvalid;

  /// No description provided for @channelIdTaken.
  ///
  /// In ru, this message translates to:
  /// **'Канал с таким адресом уже существует. Выберите другой адрес.'**
  String get channelIdTaken;

  /// No description provided for @channelUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Канал больше не доступен'**
  String get channelUnavailable;

  /// No description provided for @channelRulesLimit.
  ///
  /// In ru, this message translates to:
  /// **'Лимит: 100 правил'**
  String get channelRulesLimit;

  /// No description provided for @channelMemberRequired.
  ///
  /// In ru, this message translates to:
  /// **'Выберите участника или укажите его полный идентификатор'**
  String get channelMemberRequired;

  /// No description provided for @channelRuleDuplicate.
  ///
  /// In ru, this message translates to:
  /// **'Правило для этого участника или роли уже есть'**
  String get channelRuleDuplicate;

  /// No description provided for @channelAccessTooLarge.
  ///
  /// In ru, this message translates to:
  /// **'Список прав слишком большой для одного запроса. Сократите число индивидуальных правил.'**
  String get channelAccessTooLarge;

  /// No description provided for @channelRevision.
  ///
  /// In ru, this message translates to:
  /// **'Канал {id} · версия {revision}'**
  String channelRevision(String id, String revision);

  /// No description provided for @channelAccessRevision.
  ///
  /// In ru, this message translates to:
  /// **'Права канала · версия {revision}'**
  String channelAccessRevision(String revision);

  /// No description provided for @channelArchivedSuffix.
  ///
  /// In ru, this message translates to:
  /// **' · Архив'**
  String get channelArchivedSuffix;

  /// No description provided for @channelBlockedSuffix.
  ///
  /// In ru, this message translates to:
  /// **' · Заблокирован'**
  String get channelBlockedSuffix;

  /// No description provided for @roleOwner.
  ///
  /// In ru, this message translates to:
  /// **'Владелец'**
  String get roleOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In ru, this message translates to:
  /// **'Администратор'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In ru, this message translates to:
  /// **'Участник'**
  String get roleMember;

  /// No description provided for @roleReader.
  ///
  /// In ru, this message translates to:
  /// **'Читатель'**
  String get roleReader;

  /// No description provided for @membersConflict.
  ///
  /// In ru, this message translates to:
  /// **'Права уже изменились. Несохранённые значения остаются в форме. Обновите участников перед повтором.'**
  String get membersConflict;

  /// No description provided for @membersLoaded.
  ///
  /// In ru, this message translates to:
  /// **'Участники загружены.'**
  String get membersLoaded;

  /// No description provided for @memberConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Изменить права участника?'**
  String get memberConfirm;

  /// No description provided for @memberApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить права'**
  String get memberApply;

  /// No description provided for @memberSaved.
  ///
  /// In ru, this message translates to:
  /// **'Права участника сохранены. Сервер применяет их к действиям и подпискам.'**
  String get memberSaved;

  /// No description provided for @memberCollapse.
  ///
  /// In ru, this message translates to:
  /// **'Свернуть права'**
  String get memberCollapse;

  /// No description provided for @memberEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить права'**
  String get memberEdit;

  /// No description provided for @memberRole.
  ///
  /// In ru, this message translates to:
  /// **'Роль участника'**
  String get memberRole;

  /// No description provided for @memberBlock.
  ///
  /// In ru, this message translates to:
  /// **'Заблокировать участника'**
  String get memberBlock;

  /// No description provided for @memberSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить права участника'**
  String get memberSave;

  /// No description provided for @membersRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить участников'**
  String get membersRefresh;

  /// No description provided for @membersHelp.
  ///
  /// In ru, this message translates to:
  /// **'Роли и блокировку меняет только владелец. Администраторы могут просматривать список.'**
  String get membersHelp;

  /// No description provided for @membersSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по идентификатору или роли'**
  String get membersSearch;

  /// No description provided for @membersEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Участники не найдены.'**
  String get membersEmpty;

  /// No description provided for @memberBlocked.
  ///
  /// In ru, this message translates to:
  /// **'заблокирован'**
  String get memberBlocked;

  /// No description provided for @memberAllowed.
  ///
  /// In ru, this message translates to:
  /// **'разрешён'**
  String get memberAllowed;

  /// No description provided for @memberBlockedSuffix.
  ///
  /// In ru, this message translates to:
  /// **' · Доступ заблокирован'**
  String get memberBlockedSuffix;

  /// No description provided for @memberProposal.
  ///
  /// In ru, this message translates to:
  /// **'{id}\nРоль: {role}\nДоступ: {access}'**
  String memberProposal(String id, String role, String access);

  /// No description provided for @membersCount.
  ///
  /// In ru, this message translates to:
  /// **'Загружено: {count}. Поиск работает по загруженным участникам.'**
  String membersCount(int count);

  /// No description provided for @invitesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Приглашения'**
  String get invitesTitle;

  /// No description provided for @invitesRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить приглашения'**
  String get invitesRefresh;

  /// No description provided for @invitesHelp.
  ///
  /// In ru, this message translates to:
  /// **'Владелец и администраторы выдают приглашения участникам и читателям. Роль существующего участника приглашение не меняет.'**
  String get invitesHelp;

  /// No description provided for @inviteRole.
  ///
  /// In ru, this message translates to:
  /// **'Роль приглашённого'**
  String get inviteRole;

  /// No description provided for @inviteMember.
  ///
  /// In ru, this message translates to:
  /// **'Участник — читает и пишет'**
  String get inviteMember;

  /// No description provided for @inviteReader.
  ///
  /// In ru, this message translates to:
  /// **'Читатель — только чтение'**
  String get inviteReader;

  /// No description provided for @inviteTtl.
  ///
  /// In ru, this message translates to:
  /// **'Срок приглашения'**
  String get inviteTtl;

  /// No description provided for @inviteMinute.
  ///
  /// In ru, this message translates to:
  /// **'1 минута'**
  String get inviteMinute;

  /// No description provided for @inviteHour.
  ///
  /// In ru, this message translates to:
  /// **'1 час'**
  String get inviteHour;

  /// No description provided for @inviteDay.
  ///
  /// In ru, this message translates to:
  /// **'1 день'**
  String get inviteDay;

  /// No description provided for @inviteWeek.
  ///
  /// In ru, this message translates to:
  /// **'7 дней'**
  String get inviteWeek;

  /// No description provided for @inviteUses.
  ///
  /// In ru, this message translates to:
  /// **'Число использований (1–100)'**
  String get inviteUses;

  /// No description provided for @inviteCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать приглашение'**
  String get inviteCreate;

  /// No description provided for @inviteCode.
  ///
  /// In ru, this message translates to:
  /// **'Код нового приглашения'**
  String get inviteCode;

  /// No description provided for @inviteLink.
  ///
  /// In ru, this message translates to:
  /// **'Ссылка для Space'**
  String get inviteLink;

  /// No description provided for @inviteLinkHelp.
  ///
  /// In ru, this message translates to:
  /// **'Код показывается только сейчас и хранится в памяти формы. Вставьте ссылку в «Добавить пространство» приложения Space. Для публичного сервера нужен доступ к его порту из сети друга.'**
  String get inviteLinkHelp;

  /// No description provided for @inviteCopyCode.
  ///
  /// In ru, this message translates to:
  /// **'Копировать код'**
  String get inviteCopyCode;

  /// No description provided for @inviteCopyLink.
  ///
  /// In ru, this message translates to:
  /// **'Копировать ссылку'**
  String get inviteCopyLink;

  /// No description provided for @inviteHide.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть код'**
  String get inviteHide;

  /// No description provided for @inviteRevoke.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать приглашение'**
  String get inviteRevoke;

  /// No description provided for @inviteRevokeConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать приглашение?'**
  String get inviteRevokeConfirm;

  /// No description provided for @inviteRevokeHelp.
  ///
  /// In ru, this message translates to:
  /// **'Новые вступления по нему будут запрещены. Уже вступившие участники сохранят доступ.'**
  String get inviteRevokeHelp;

  /// No description provided for @invitesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Приглашений пока нет.'**
  String get invitesEmpty;

  /// No description provided for @invitesMore.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить ещё приглашения'**
  String get invitesMore;

  /// No description provided for @inviteRevokedState.
  ///
  /// In ru, this message translates to:
  /// **'Отозвано'**
  String get inviteRevokedState;

  /// No description provided for @inviteExpiredState.
  ///
  /// In ru, this message translates to:
  /// **'Истекло'**
  String get inviteExpiredState;

  /// No description provided for @inviteUsedState.
  ///
  /// In ru, this message translates to:
  /// **'Использовано'**
  String get inviteUsedState;

  /// No description provided for @inviteActiveState.
  ///
  /// In ru, this message translates to:
  /// **'Действует'**
  String get inviteActiveState;

  /// No description provided for @invitesLoaded.
  ///
  /// In ru, this message translates to:
  /// **'Приглашения загружены.'**
  String get invitesLoaded;

  /// No description provided for @inviteCreated.
  ///
  /// In ru, this message translates to:
  /// **'Приглашение создано. Скопируйте код или ссылку сейчас.'**
  String get inviteCreated;

  /// No description provided for @inviteCopied.
  ///
  /// In ru, this message translates to:
  /// **'Скопировано в буфер обмена.'**
  String get inviteCopied;

  /// No description provided for @inviteCopyFailed.
  ///
  /// In ru, this message translates to:
  /// **'Копирование недоступно. Выделите код или ссылку и скопируйте вручную.'**
  String get inviteCopyFailed;

  /// No description provided for @inviteRevoked.
  ///
  /// In ru, this message translates to:
  /// **'Приглашение отозвано. Доступ уже вступивших участников не изменён.'**
  String get inviteRevoked;

  /// No description provided for @inviteUsesInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Укажите число использований от 1 до 100'**
  String get inviteUsesInvalid;

  /// No description provided for @inviteExpiry.
  ///
  /// In ru, this message translates to:
  /// **'До {expiry} по времени устройства · использований {uses}/{limit}'**
  String inviteExpiry(String expiry, int uses, int limit);

  /// No description provided for @devicesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Устройства и разрешения'**
  String get devicesTitle;

  /// No description provided for @devicesHelp.
  ///
  /// In ru, this message translates to:
  /// **'Только устройства вашей идентичности. Роль на сервере и разрешения устройства проверяются отдельно.'**
  String get devicesHelp;

  /// No description provided for @devicesRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить устройства'**
  String get devicesRefresh;

  /// No description provided for @devicesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных устройств.'**
  String get devicesEmpty;

  /// No description provided for @deviceRecovery.
  ///
  /// In ru, this message translates to:
  /// **'Ключ восстановления'**
  String get deviceRecovery;

  /// No description provided for @deviceCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Это устройство'**
  String get deviceCurrent;

  /// No description provided for @deviceOther.
  ///
  /// In ru, this message translates to:
  /// **'Другое устройство'**
  String get deviceOther;

  /// No description provided for @deviceRevokeAccess.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать доступ'**
  String get deviceRevokeAccess;

  /// No description provided for @deviceRevokeConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать доступ?'**
  String get deviceRevokeConfirm;

  /// No description provided for @deviceRevoke.
  ///
  /// In ru, this message translates to:
  /// **'Отозвать'**
  String get deviceRevoke;

  /// No description provided for @deviceRecoveryWarning.
  ///
  /// In ru, this message translates to:
  /// **'Карточка и все подключённые через неё устройства потеряют доступ. Проверьте другой путь восстановления.'**
  String get deviceRecoveryWarning;

  /// No description provided for @deviceCurrentWarning.
  ///
  /// In ru, this message translates to:
  /// **'Это устройство потеряет доступ. Его сессия и подписки завершатся.'**
  String get deviceCurrentWarning;

  /// No description provided for @deviceOtherWarning.
  ///
  /// In ru, this message translates to:
  /// **'Сессии и подписки устройства завершатся.'**
  String get deviceOtherWarning;

  /// No description provided for @deviceCardHelp.
  ///
  /// In ru, this message translates to:
  /// **'После подтверждения выберите исходную карточку JSON или PNG. Секрет используется только для подписи.'**
  String get deviceCardHelp;

  /// No description provided for @deviceCardPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль карточки'**
  String get deviceCardPassword;

  /// No description provided for @devicesLoaded.
  ///
  /// In ru, this message translates to:
  /// **'Устройства загружены.'**
  String get devicesLoaded;

  /// No description provided for @deviceRevokedStatus.
  ///
  /// In ru, this message translates to:
  /// **'Доступ отозван на сервере.'**
  String get deviceRevokedStatus;

  /// No description provided for @deviceExpiryUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Срок неизвестен'**
  String get deviceExpiryUnknown;

  /// No description provided for @deviceAccessUntil.
  ///
  /// In ru, this message translates to:
  /// **'Доступ до {expiry}'**
  String deviceAccessUntil(String expiry);

  /// No description provided for @deviceExpired.
  ///
  /// In ru, this message translates to:
  /// **'Срок истёк: {expiry}'**
  String deviceExpired(String expiry);

  /// No description provided for @deviceScopes.
  ///
  /// In ru, this message translates to:
  /// **'Разрешения: {scopes}'**
  String deviceScopes(String scopes);

  /// No description provided for @deviceParent.
  ///
  /// In ru, this message translates to:
  /// **'Выдано через: {id}'**
  String deviceParent(String id);
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
