// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AdminLocalizationsRu extends AdminLocalizations {
  AdminLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get closeManagement => 'Закрыть управление';

  @override
  String get managementTitle => 'Управление пространством';

  @override
  String get managementIntro => 'Настройки и участники пространства.';

  @override
  String get managementSections => '';

  @override
  String get deviceIdentity => 'Текущая идентичность устройства';

  @override
  String get currentConnection =>
      'Используется идентичность текущего подключения. Дополнительный аккаунт не нужен.';

  @override
  String get currentSession =>
      'Используется текущая сессия приложения Space. Для восстановления откройте раздел идентичности.';

  @override
  String get connectManagement => 'Подключить управление текущим сервером';

  @override
  String get claimOwner => 'Назначить первого владельца';

  @override
  String get setupHelp =>
      'Получите код в консоли сервера: space-server -setup-code. Он действует 15 минут.';

  @override
  String get setupCode => 'Одноразовый код сервера';

  @override
  String get confirmOwner => 'Подтвердить владение';

  @override
  String get authorizeFirst =>
      'Сначала явно выдайте разрешение этому устройству в блоке ниже';

  @override
  String get authorizeTitle => 'Разрешить этому устройству управление сервером';

  @override
  String get authorizeHelp =>
      'Разрешение space.manage подписывается вашим корневым ключом. Оно действует вместе с ролью владельца или администратора.';

  @override
  String get authorizeDevice => 'Выдать разрешение этому устройству';

  @override
  String get authorizeConfirm => 'Разрешить управление сервером?';

  @override
  String get authorizeDetails =>
      'Вы явно разрешаете этому устройству менять настройки, чаты, голосовые комнаты и доступ участников.';

  @override
  String get rootPassword => 'Пароль корневой карточки JSON/PNG';

  @override
  String get cancel => 'Отмена';

  @override
  String get allow => 'Разрешить';

  @override
  String get spaceName => 'Название пространства';

  @override
  String get chatName => 'Название общего чата';

  @override
  String get chatsEnabled => 'Чаты доступны участникам';

  @override
  String get chatsHelp =>
      'Выключение закрывает чтение и отправку. История сохраняется.';

  @override
  String get registration => 'Регистрация';

  @override
  String get registrationOpen => 'Открыта';

  @override
  String get registrationClosed => 'По приглашению';

  @override
  String get saveSettings => 'Сохранить настройки';

  @override
  String get reloadSettings => 'Загрузить заново';

  @override
  String get settingsLoaded => 'Настройки загружены с сервера.';

  @override
  String get settingsSaved => 'Настройки сохранены на сервере.';

  @override
  String get setupNeeded =>
      'Устройство вошло. Укажите одноразовый код сервера для назначения владельца.';

  @override
  String get roleDenied =>
      'Вход выполнен, но ваша роль не разрешает настройку сервера.';

  @override
  String get deviceRevoked =>
      'Это устройство отозвано. Восстановите доступ или используйте другое устройство.';

  @override
  String get signInFirst => 'Сначала войдите';

  @override
  String get identityChanged => 'Идентичность изменилась. Войдите заново';

  @override
  String get accessBlocked => 'Доступ к пространству заблокирован';

  @override
  String get bothNames => 'Укажите название пространства';

  @override
  String get settingsConflict =>
      'Настройки уже изменены. Загрузите их заново и повторите изменения.';

  @override
  String settingsRevision(String revision) {
    return 'Настройки пространства · версия $revision';
  }

  @override
  String get channelsTitle => 'Чаты и права';

  @override
  String get channelsReload => 'Обновить список чатов';

  @override
  String get channelsEmpty => 'Чатов пока нет.';

  @override
  String get channelCreateSection => 'Создать чат';

  @override
  String get channelNewId => 'Адрес нового чата';

  @override
  String get channelNewTitle => 'Название нового чата';

  @override
  String get channelNewOrder => 'Порядок';

  @override
  String get channelDefaults =>
      'Участники смогут читать и писать, читатели — читать. Публичный предпросмотр выключен.';

  @override
  String get channelCreate => 'Создать чат';

  @override
  String get channelName => 'Название';

  @override
  String get channelOrder => 'Порядок';

  @override
  String get channelArchive => 'Архивировать чат';

  @override
  String get channelPublicPreview =>
      'Показывать название посетителям без входа';

  @override
  String get channelPreviewHelp =>
      'Предпросмотр раскрывает название и адрес, но не сообщения. Архив сохраняет историю и запрещает новую запись.';

  @override
  String get channelSave => 'Сохранить чат';

  @override
  String get channelReload => 'Загрузить заново';

  @override
  String get channelAccessHelp =>
      'Индивидуальное правило заменяет правило роли. Владелец и администраторы сохраняют доступ. Читатель не получает отправку. «Управлять» меняет метаданные, но не права.';

  @override
  String get channelRulesEmpty => 'Правил нет: доступ только у администрации.';

  @override
  String get channelRuleSubject => 'Кому добавить правило';

  @override
  String get channelMembers => 'Участники';

  @override
  String get channelReaders => 'Читатели';

  @override
  String get channelIndividual => 'Отдельный участник';

  @override
  String get channelSelectMember => 'Выберите участника';

  @override
  String get channelMoreMembers => 'Загрузить ещё участников';

  @override
  String get channelPrincipalId => 'Или полный идентификатор участника';

  @override
  String get channelAddRule => 'Добавить правило';

  @override
  String get channelSaveAccess => 'Сохранить права';

  @override
  String get channelDeleteRule => 'Удалить правило';

  @override
  String get channelVisible => 'Видеть';

  @override
  String get channelRead => 'Читать сообщения';

  @override
  String get channelWrite => 'Отправлять сообщения';

  @override
  String get channelManage => 'Управлять';

  @override
  String get channelsLoaded => 'Список загружен.';

  @override
  String get channelLoaded => 'Настройки и права загружены.';

  @override
  String get channelCreated => 'Чат создан.';

  @override
  String get channelSaved => 'Настройки чата сохранены.';

  @override
  String get channelAccessSaved => 'Права сохранены.';

  @override
  String get channelRuleAdded =>
      'Правило добавлено в форму. Сохраните права для применения.';

  @override
  String get channelConflict =>
      'Настройки или права уже изменены. Загрузите их заново; несохранённые поля остаются в форме.';

  @override
  String get channelChanged =>
      'Настройки изменились между загрузкой списка и прав';

  @override
  String get channelOrderInvalid => 'Порядок должен быть от 0 до 100000';

  @override
  String get channelNameInvalid => 'Укажите название до 320 байт';

  @override
  String get channelIdInvalid =>
      'Адрес: латинские буквы, цифры, _ или -, начиная с буквы';

  @override
  String get channelIdTaken => 'Этот адрес уже занят. Выберите другой.';

  @override
  String get channelUnavailable => 'Больше недоступно';

  @override
  String get channelRulesLimit => 'Лимит: 100 правил';

  @override
  String get channelMemberRequired =>
      'Выберите участника или укажите его полный идентификатор';

  @override
  String get channelRuleDuplicate =>
      'Правило для этого участника или роли уже есть';

  @override
  String get channelAccessTooLarge =>
      'Список прав слишком большой для одного запроса. Сократите число индивидуальных правил.';

  @override
  String channelRevision(String id, String revision) {
    return '$id · версия $revision';
  }

  @override
  String channelAccessRevision(String revision) {
    return 'Права · версия $revision';
  }

  @override
  String get channelArchivedSuffix => ' · Архив';

  @override
  String get channelBlockedSuffix => ' · Заблокирован';

  @override
  String get roleOwner => 'Владелец';

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get roleMember => 'Участник';

  @override
  String get roleReader => 'Читатель';

  @override
  String get membersConflict =>
      'Права уже изменились. Несохранённые значения остаются в форме. Обновите участников перед повтором.';

  @override
  String get membersLoaded => 'Участники загружены.';

  @override
  String get memberConfirm => 'Изменить права участника?';

  @override
  String get memberApply => 'Применить права';

  @override
  String get memberSaved =>
      'Права участника сохранены. Сервер применяет их к действиям и подпискам.';

  @override
  String get memberCollapse => 'Свернуть права';

  @override
  String get memberEdit => 'Изменить права';

  @override
  String get memberRole => 'Роль участника';

  @override
  String get memberBlock => 'Заблокировать участника';

  @override
  String get memberSave => 'Сохранить права участника';

  @override
  String get membersRefresh => 'Обновить участников';

  @override
  String get membersHelp =>
      'Роли и блокировку меняет только владелец. Администраторы могут просматривать список.';

  @override
  String get membersSearch => 'Поиск по идентификатору или роли';

  @override
  String get membersEmpty => 'Участники не найдены.';

  @override
  String get memberBlocked => 'заблокирован';

  @override
  String get memberAllowed => 'разрешён';

  @override
  String get memberBlockedSuffix => ' · Доступ заблокирован';

  @override
  String memberProposal(String id, String role, String access) {
    return '$id\nРоль: $role\nДоступ: $access';
  }

  @override
  String membersCount(int count) {
    return 'Загружено: $count. Поиск работает по загруженным участникам.';
  }

  @override
  String get invitesTitle => 'Приглашения';

  @override
  String get invitesRefresh => 'Обновить приглашения';

  @override
  String get invitesHelp =>
      'Владелец и администраторы выдают приглашения участникам и читателям. Роль существующего участника приглашение не меняет.';

  @override
  String get inviteRole => 'Роль приглашённого';

  @override
  String get inviteMember => 'Участник — читает и пишет';

  @override
  String get inviteReader => 'Читатель — только чтение';

  @override
  String get inviteTtl => 'Срок приглашения';

  @override
  String get inviteMinute => '1 минута';

  @override
  String get inviteHour => '1 час';

  @override
  String get inviteDay => '1 день';

  @override
  String get inviteWeek => '7 дней';

  @override
  String get inviteUses => 'Число использований (1–100)';

  @override
  String get inviteCreate => 'Создать приглашение';

  @override
  String get inviteCode => 'Код нового приглашения';

  @override
  String get inviteLink => 'Ссылка для Space';

  @override
  String get inviteLinkHelp =>
      'Код показывается только сейчас и хранится в памяти формы. Вставьте ссылку в «Добавить пространство» приложения Space. Для публичного сервера нужен доступ к его порту из сети друга.';

  @override
  String get inviteCopyCode => 'Копировать код';

  @override
  String get inviteCopyLink => 'Копировать ссылку';

  @override
  String get inviteHide => 'Скрыть код';

  @override
  String get inviteRevoke => 'Отозвать приглашение';

  @override
  String get inviteRevokeConfirm => 'Отозвать приглашение?';

  @override
  String get inviteRevokeHelp =>
      'Новые вступления по нему будут запрещены. Уже вступившие участники сохранят доступ.';

  @override
  String get invitesEmpty => 'Приглашений пока нет.';

  @override
  String get invitesMore => 'Загрузить ещё приглашения';

  @override
  String get inviteRevokedState => 'Отозвано';

  @override
  String get inviteExpiredState => 'Истекло';

  @override
  String get inviteUsedState => 'Использовано';

  @override
  String get inviteActiveState => 'Действует';

  @override
  String get invitesLoaded => 'Приглашения загружены.';

  @override
  String get inviteCreated =>
      'Приглашение создано. Скопируйте код или ссылку сейчас.';

  @override
  String get inviteCopied => 'Скопировано в буфер обмена.';

  @override
  String get inviteCopyFailed =>
      'Копирование недоступно. Выделите код или ссылку и скопируйте вручную.';

  @override
  String get inviteRevoked =>
      'Приглашение отозвано. Доступ уже вступивших участников не изменён.';

  @override
  String get inviteUsesInvalid => 'Укажите число использований от 1 до 100';

  @override
  String inviteExpiry(String expiry, int uses, int limit) {
    return 'До $expiry по времени устройства · использований $uses/$limit';
  }

  @override
  String get devicesTitle => 'Устройства и разрешения';

  @override
  String get devicesHelp =>
      'Только устройства вашей идентичности. Роль на сервере и разрешения устройства проверяются отдельно.';

  @override
  String get devicesRefresh => 'Обновить устройства';

  @override
  String get devicesEmpty => 'Нет доступных устройств.';

  @override
  String get deviceRecovery => 'Ключ восстановления';

  @override
  String get deviceCurrent => 'Это устройство';

  @override
  String get deviceOther => 'Другое устройство';

  @override
  String get deviceRevokeAccess => 'Отозвать доступ';

  @override
  String get deviceRevokeConfirm => 'Отозвать доступ?';

  @override
  String get deviceRevoke => 'Отозвать';

  @override
  String get deviceRecoveryWarning =>
      'Карточка и все подключённые через неё устройства потеряют доступ. Проверьте другой путь восстановления.';

  @override
  String get deviceCurrentWarning =>
      'Это устройство потеряет доступ. Его сессия и подписки завершатся.';

  @override
  String get deviceOtherWarning => 'Сессии и подписки устройства завершатся.';

  @override
  String get deviceCardHelp =>
      'После подтверждения выберите исходную карточку JSON или PNG. Секрет используется только для подписи.';

  @override
  String get deviceCardPassword => 'Пароль карточки';

  @override
  String get devicesLoaded => 'Устройства загружены.';

  @override
  String get deviceRevokedStatus => 'Доступ отозван на сервере.';

  @override
  String get deviceExpiryUnknown => 'Срок неизвестен';

  @override
  String deviceAccessUntil(String expiry) {
    return 'Доступ до $expiry';
  }

  @override
  String deviceExpired(String expiry) {
    return 'Срок истёк: $expiry';
  }

  @override
  String deviceScopes(String scopes) {
    return 'Разрешения: $scopes';
  }

  @override
  String deviceParent(String id) {
    return 'Выдано через: $id';
  }

  @override
  String get recoveryConfirm => 'Подтвердите действие';

  @override
  String get recoveryConfirmButton => 'Подтвердить';

  @override
  String get recoveryProtect => 'Защитите карточку';

  @override
  String get recoveryOpen => 'Открыть карточку';

  @override
  String get recoveryPasswordHelp =>
      'Пароль шифрует файл только на этом устройстве. Сервер его не получает. Используйте несколько случайных слов и храните пароль отдельно.';

  @override
  String get recoveryPassword => 'Пароль (от 12 символов)';

  @override
  String get recoveryPasswordRepeat => 'Повторите пароль';

  @override
  String get recoveryPasswordInvalid => 'Пароли не совпадают.';

  @override
  String get recoveryEncrypt => 'Зашифровать';

  @override
  String get recoveryOpenButton => 'Открыть';

  @override
  String get pairingIdentity => 'У вас уже есть идентичность?';

  @override
  String get pairingIntro =>
      'Подключите этот компьютер через подтверждение на исходном устройстве. Корневой ключ и карточка не копируются. Для сопряжения приглашение не нужно.';

  @override
  String get pairingStart => 'Доверять серверу и начать сопряжение';

  @override
  String get pairingInstructions =>
      'На исходном устройстве откройте «Идентичность» → «Подтвердить устройство» в приложении Space. Код действует пять минут.';

  @override
  String get pairingCopy => 'Скопировать код';

  @override
  String get pairingWaiting => 'Ожидаем подпись исходного устройства…';

  @override
  String get pairingCheckBeforeSign =>
      'Введите этот код проверки на управляющем устройстве до выдачи подписи:';

  @override
  String get pairingVerified =>
      'Root-подпись проверена. Сверьте код на обоих экранах:';

  @override
  String get pairingAccept => 'Код совпадает — подключиться';

  @override
  String get pairingCancel => 'Отменить сопряжение';

  @override
  String get rotationTitle => 'Смена корневого ключа';

  @override
  String get rotationHelp =>
      'Сохраняет вашу идентичность и закрывает доступ прежним ключам. Начать смену можно на устройстве с корневым ключом. После сбоя завершите сохранённую смену. Если запрос истёк до завершения на сервере, подключитесь прежним ключом и обновите запрос.';

  @override
  String get rotationStart => 'Сменить корневой ключ';

  @override
  String get rotationRenew => 'Обновить истёкший запрос';

  @override
  String get rotationFinish => 'Завершить сохранённую смену';

  @override
  String get pairingApproveTitle => 'Подтвердить устройство';

  @override
  String get pairingApproveHelp =>
      'Введите одноразовый код с нового устройства. Подпись требует root или открытую recovery-карточку. Для recovery-карточки новое устройство проверяет цепочку от исходного root.';

  @override
  String get pairingCode => 'Код сопряжения';

  @override
  String get pairingPrepare => 'Проверить и подтвердить';

  @override
  String get pairingComparison =>
      'Код проверки для сравнения с новым устройством';

  @override
  String get pairingEnteredCode => 'Код проверки с нового устройства';

  @override
  String get pairingSign => 'Коды совпадают — подписать';

  @override
  String get recoveryTitle => 'Восстановление доступа';

  @override
  String get recoveryHelp =>
      'QR-карточка восстанавливает идентичность. Задайте пароль и храните его отдельно.';

  @override
  String get recoveryExport => 'Сохранить QR';

  @override
  String get recoveryRestore => 'Восстановить из файла';

  @override
  String get recoveryScan => 'Сканировать камерой';

  @override
  String get recoveryDevices => 'Ваши устройства';

  @override
  String get recoveryDevicesHelp =>
      'Показаны разрешения только вашей идентичности. Старые и отозванные записи сохраняются.';

  @override
  String get cameraTitle => 'Сканировать карточку';

  @override
  String get cameraHelp =>
      'Наведите камеру на QR-карточку Space. Кадры обрабатываются на этом устройстве. Микрофон выключен.';

  @override
  String get cameraRestart => 'Включить снова';

  @override
  String get cameraCapture => 'Считать QR';

  @override
  String cameraLabel(int number, String name) {
    return 'Камера $number — $name';
  }

  @override
  String get serverIconTitle => 'Иконка пространства';

  @override
  String get serverIconUpload => 'Выбрать PNG или SVG';

  @override
  String get serverIconHelp =>
      'PNG уменьшается автоматически. SVG — до 8 КиБ, без скриптов и внешних ссылок.';

  @override
  String get serverIconInvalid =>
      'Не удалось прочитать иконку. Выберите PNG до 2048×2048 или простой SVG до 8 КиБ.';

  @override
  String get serverIconUpgrade =>
      'Для изменения иконки требуется обновление сервера.';

  @override
  String get iconOrbit => 'Орбита';

  @override
  String get iconPlanet => 'Планета';

  @override
  String get iconLeaf => 'Лист';

  @override
  String get iconStar => 'Звезда';

  @override
  String get iconBolt => 'Молния';

  @override
  String get iconRocket => 'Ракета';

  @override
  String get recoveryCreateQr => 'Создать QR';

  @override
  String get recoveryOriginalCardNeeded =>
      'На устройстве нет ключа восстановления. Используйте исходную карточку.';

  @override
  String get channelDelete => 'Удалить чат';

  @override
  String channelDeleteConfirm(String name) {
    return 'Удалить чат «$name» и всю его историю? Это действие нельзя отменить.';
  }

  @override
  String get channelDeleted => 'Чат удалён.';

  @override
  String get storageTitle => 'Хранилище файлов';

  @override
  String get storageTotal => 'Общий лимит сервера, МиБ';

  @override
  String get storageMember => 'Личный лимит каждого участника, МиБ';

  @override
  String get storageHelp =>
      '0 запрещает новые загрузки. Уже загруженные файлы сохраняются. Незавершённые загрузки тоже занимают место.';

  @override
  String get storagePersonal => 'Личный лимит, МиБ';

  @override
  String get storageInherited => 'Пусто — стандартный лимит';

  @override
  String get attachmentsEnabled => 'Разрешить вложения файлов';

  @override
  String get attachmentsEnabledHelp =>
      'Если выключено, участники не могут прикреплять и скачивать файлы. Файловые функции скрываются в приложении этого пространства.';

  @override
  String get voiceRoomsTitle => 'Голосовые комнаты';

  @override
  String get voiceRoomsReload => 'Обновить список комнат';

  @override
  String get voiceRoomsEmpty => 'Комнат пока нет.';

  @override
  String get voiceRoomCreate => 'Создать комнату';

  @override
  String get voiceRoomNewTitle => 'Название новой комнаты';

  @override
  String get voiceRoomDefaults =>
      'Участники смогут слушать и говорить, читатели — слушать.';

  @override
  String get voiceRoomListen => 'Слушать';

  @override
  String get voiceRoomSpeak => 'Говорить';

  @override
  String get voiceRoomAccessHelp =>
      'Индивидуальное правило заменяет правило роли. Владелец и администраторы сохраняют доступ. Читатель может слушать, но не говорить. «Управлять» меняет настройки комнаты, но не права.';

  @override
  String get voiceRoomArchive => 'Архивировать комнату';

  @override
  String get voiceRoomArchiveHelp =>
      'Архивированная комната недоступна для новых подключений.';

  @override
  String get voiceRoomSave => 'Сохранить комнату';

  @override
  String get voiceRoomDelete => 'Удалить комнату';

  @override
  String voiceRoomDeleteConfirm(String name) {
    return 'Удалить комнату «$name»? Это действие нельзя отменить.';
  }

  @override
  String get voiceRoomCreated => 'Комната создана.';

  @override
  String get voiceRoomSaved => 'Настройки комнаты сохранены.';

  @override
  String get voiceRoomDeleted => 'Комната удалена.';
}
