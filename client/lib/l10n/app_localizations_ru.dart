// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get failureConflict =>
      'Сообщение уже изменено. Закройте редактор и откройте актуальную версию; ваш текст можно скопировать перед закрытием.';

  @override
  String get messageDeleted => 'Сообщение удалено';

  @override
  String get messageEdited => 'изменено';

  @override
  String get messageActions => 'Действия с сообщением';

  @override
  String get editMessage => 'Редактировать';

  @override
  String get deleteMessage => 'Удалить';

  @override
  String get deleteMessageConfirm =>
      'Удалить сообщение для всех участников? Это действие нельзя отменить.';

  @override
  String get saveMessage => 'Сохранить';

  @override
  String get cancelMessageChange => 'Отмена';

  @override
  String get messageText => 'Текст сообщения';

  @override
  String get messageTextInvalid => 'Введите текст длиной до 4096 байт.';

  @override
  String get interfaceScale => 'Масштаб интерфейса';

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
  String get identity => 'Мой доступ и устройства';

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
  String get recentSpaces => 'Недавние серверы';

  @override
  String get prototype => 'Локальный прототип · Windows';

  @override
  String get logo => 'Логотип Space';

  @override
  String get selectedSpace => 'Выбранное пространство';

  @override
  String get myIdentity => 'Мой доступ и устройства';

  @override
  String get aboutSpace => 'О пространстве';

  @override
  String get independentServer => 'Каналы и доступ задаёт этот сервер.';

  @override
  String get deviceSignedIn => 'Вход по ключу устройства выполнен';

  @override
  String get noSession => 'Нет активной сессии';

  @override
  String get checkConnection => 'Проверить подключение';

  @override
  String get beYourself => 'Можно быть собой.';

  @override
  String get ownPace => 'Камера и микрофон выключены.';

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
  String get welcome => 'Ваше пространство';

  @override
  String get welcomeDescription => 'Каналы и ресурсы сервера.';

  @override
  String get ideas => 'Место для идей.\nИ людей за ними.';

  @override
  String get connectDescription => 'Добавьте сервер по адресу или приглашению.';

  @override
  String get returnChat => 'Вернуться в разговор';

  @override
  String get yourConversation => 'Ваш разговор';

  @override
  String get noMessages => 'Подключитесь, чтобы открыть сообщения.';

  @override
  String get openChat => 'Открыть чат';

  @override
  String get yourAttention => 'Ваше внимание';

  @override
  String get attentionDescription =>
      'Оболочка не отправляет системные уведомления и не включает камеру или микрофон. Можно оставаться в своём ритме.';

  @override
  String get settingsTitle => 'Настройки приложения';

  @override
  String get settingsDescription => 'Сохраняются на этом устройстве.';

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
  String get connectionIntro => 'Введите адрес сервера или приглашение.';

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
  String get homeTitle => 'Эфир';

  @override
  String get close => 'Закрыть';

  @override
  String get homeFirstSetup =>
      'Сервер и данные будут созданы на этом компьютере.';

  @override
  String get homeReuse => 'Ваш сервер и данные сохранены.';

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
      'Приглашения: «Управление пространством». При отключении участники потеряют соединение.';

  @override
  String get myHomeServer => 'Мой домашний сервер';

  @override
  String get homeRunningHelp =>
      'Сервер работает. После отключения все данные сохранятся.';

  @override
  String get homeStartHelp => 'Запустите своё пространство на этом компьютере.';

  @override
  String get myServer => 'Выйти в эфир';

  @override
  String get homeDetectingIP => 'Определяем публичный IP через ipify';

  @override
  String get homeDownloading => 'Скачиваем сервер и PostgreSQL';

  @override
  String get homeInstalling => 'Проверяем и устанавливаем выпуск';

  @override
  String get homeUpdating => 'Проверка и обновление сервера';

  @override
  String get homeUpdate => 'Обновить сервер';

  @override
  String get homeReleaseChanges => 'Изменения выпуска';

  @override
  String get managementTab => 'Управление';

  @override
  String get homeNoReleaseNotes =>
      'Описание изменений для этого выпуска не предоставлено.';

  @override
  String homeSpaceDetails(String required, String available) {
    return 'Нужно: $required МиБ · доступно: $available МиБ';
  }

  @override
  String get failureHomeSpaceLow =>
      'Недостаточно свободного места для операции домашнего сервера. Освободите место и повторите попытку.';

  @override
  String get failureHomeSpaceUnknown =>
      'Не удалось проверить свободное место. Проверьте доступность диска и повторите попытку.';

  @override
  String get homeResumeUpdate => 'Продолжить обновление или восстановление';

  @override
  String get homeUpdateConfirm =>
      'Сервер будет временно отключён для участников. Перед миграциями создаётся резервная копия. После операции сервер останется выключенным: запустите его кнопкой «Выйти в эфир».';

  @override
  String get homeStarting => 'Запускаем сохранённый сервер';

  @override
  String get homeRunning => 'Сервер работает на этом компьютере';

  @override
  String get homeStopped => 'Сервер отключён, данные сохранены';

  @override
  String serverNowOnline(String server) {
    return 'Сервер $server сейчас онлайн.';
  }

  @override
  String serverNowOffline(String server) {
    return 'Соединение с сервером $server потеряно.';
  }

  @override
  String get serverAvailabilityUnknown => 'Доступность пока неизвестна';

  @override
  String get recoveryOperationFailed =>
      'Операция не завершена. Проверьте доступ, карточку и соединение.';

  @override
  String get recoveryFileLabel => 'Карточка Space';

  @override
  String get recoveryFormat => 'Формат карточки';

  @override
  String get recoveryFormatHelp =>
      'PNG содержит зашифрованный QR и подходит для печати. JSON — компактный резервный файл. Пароль храните отдельно.';

  @override
  String get recoveryPng => 'QR в PNG';

  @override
  String get recoveryCardSaved =>
      'Карточка сохранена. Проверьте её восстановлением на отдельном устройстве; файл и пароль храните раздельно.';

  @override
  String get recoveryTooLarge => 'Карточка слишком большая';

  @override
  String get recoveryReplaceWarning =>
      'Сохранённые здесь ключи для этого адреса будут заменены. Сначала сохраните их карточку, если это другая идентичность.';

  @override
  String get recoveryConnectionDenied =>
      'Ключи сохранены, но сервер не разрешил подключение. Проверьте отзыв карточки, блокировку и доступность чата.';

  @override
  String get recoveryRestored =>
      'Идентичность восстановлена с новым устройством. Проверьте список и отзовите потерянные устройства.';

  @override
  String get rotationRenewConfirm =>
      'Обновить истёкший запрос с теми же сохранёнными новыми ключами? Если сервер уже завершил переход, используйте завершение сохранённой смены.';

  @override
  String get rotationConfirm =>
      'Сменить корневой ключ? Ваш ID, права и история сохранятся. Прежние устройства и карточки потеряют доступ. Новый секрет сначала сохраняется в защищённый журнал. После перехода обязательно сохраните новую карточку.';

  @override
  String get rotationServerRequired =>
      'Сначала проверьте адрес прежнего сервера';

  @override
  String get rotationNotPending =>
      'Для этого сервера нет сохранённой смены ключа.';

  @override
  String get rotationReconnect =>
      'Новый ключ сохранён. Проверьте доступность сервера и подключитесь повторно.';

  @override
  String get rotationCompleted =>
      'Корневой ключ сменён, прежний ID сохранён. Сохраните новую карточку; старые карточки и устройства больше не работают.';

  @override
  String get recoveryRevokeCard =>
      'Отозвать ключ восстановления? Карточка и все устройства, подключённые через неё, перестанут работать. Перед этим сохраните другой путь доступа.';

  @override
  String get recoveryRevokeDevice =>
      'Отозвать это устройство? Его сессии и подписки завершатся.';

  @override
  String get recoveryRevoked => 'Разрешение отозвано на сервере.';

  @override
  String get pairingAlreadyUsed => 'Код уже использован или отменён';

  @override
  String get pairingManageRequest =>
      'Запрошено также управление пространством, если роль это разрешает.';

  @override
  String get pairingChatRequest => 'Запрошен доступ к чату с вашими правами.';

  @override
  String get pairingReady =>
      'Код появится также на новом устройстве. Введите показанный там код проверки перед выдачей подписи.';

  @override
  String get pairingMismatch =>
      'Коды проверки не совпадают. Не подтверждайте подключение.';

  @override
  String get pairingSignConfirm =>
      'Коды на двух устройствах совпадают? Выдать root-подпись для нового устройства с указанными правами?';

  @override
  String get pairingSigned =>
      'Подпись выдана. Завершите вход на новом устройстве.';

  @override
  String get pairingStartFailed =>
      'Не удалось начать сопряжение. Проверьте сервер и доступность PostgreSQL.';

  @override
  String get pairingCancelled => 'Сопряжение отменено';

  @override
  String get pairingExpired =>
      'Код истёк, отменён или подтверждение не прошло проверку. Начните заново.';

  @override
  String get pairingCompareTitle => 'Сверьте код на двух устройствах';

  @override
  String get pairingMatches => 'Код совпадает';

  @override
  String recoveryRestoreConfirm(String origin, String warning) {
    return 'Восстановить идентичность на $origin? Будет создан новый ключ этого устройства. $warning';
  }

  @override
  String pairingPrepareConfirm(String device, String request) {
    return 'Подготовить подключение «$device» к вашей идентичности? $request Подпись ещё не выдаётся. Сначала сравните код на обоих экранах.';
  }

  @override
  String pairingAcceptConfirm(String code, String origin) {
    return 'На подтверждающем устройстве должен отображаться код $code. Совпадает? Сохранённая здесь идентичность для $origin будет заменена; сначала сохраните её карточку, если это другой аккаунт.';
  }

  @override
  String get recoveryCancel => 'Отмена';

  @override
  String get dashboard => 'Сводка';

  @override
  String get dashboardTitle => 'Все ваши пространства — рядом.';

  @override
  String get dashboardDescription =>
      'Серверы, каналы и непрочитанные сообщения.';

  @override
  String get dashboardServers => 'Серверы';

  @override
  String get dashboardOnline => 'Онлайн';

  @override
  String get dashboardChannels => 'Доступные каналы';

  @override
  String get dashboardUnread => 'Непрочитанные';

  @override
  String get dashboardRefresh => 'Обновить сводку';

  @override
  String get dashboardEmpty => 'Добавьте первое пространство';

  @override
  String get dashboardEmptyHelp => 'Добавьте сервер или создайте свой.';

  @override
  String get dashboardCatalogUnknown => 'Подключитесь, чтобы загрузить каналы.';

  @override
  String get dashboardAvailable => 'Доступен';

  @override
  String get dashboardUnavailable => 'Недоступен';

  @override
  String get dashboardOpen => 'Открыть пространство';

  @override
  String get dashboardResourcesHelp =>
      'Сводка учитывает доступные вам каналы и непрочитанные сообщения. Данные недоступных серверов появятся после подключения.';

  @override
  String get dashboardSpaces => 'Ваши пространства';

  @override
  String get failureCardCorrupt =>
      'Карточка повреждена или имеет неверный формат.';

  @override
  String get failurePasswordInvalid =>
      'Пароль должен содержать не менее 12 символов и занимать не более 512 байт.';

  @override
  String get failureCardTooLarge => 'Карточка превышает допустимый размер.';

  @override
  String get failureCardUnsupported =>
      'Формат или параметры шифрования карточки не поддерживаются.';

  @override
  String get failureCardAuthentication =>
      'Неверный пароль или повреждённая карточка. Проверьте файл и пароль.';

  @override
  String get failureReleaseInvalid =>
      'Описание выпуска сервера не прошло проверку. Установка остановлена.';

  @override
  String get failurePlatformUnsupported =>
      'Для этой платформы ещё нет проверенного выпуска домашнего сервера.';

  @override
  String get failureDownloadAddress =>
      'Адрес загрузки сервера не разрешён. Установка остановлена.';

  @override
  String get failureDownloadFailed =>
      'Не удалось скачать сервер. Проверьте соединение и повторите загрузку.';

  @override
  String get failureRedirectLimit =>
      'Загрузка содержит слишком много перенаправлений. Установка остановлена.';

  @override
  String get failureReleaseSize =>
      'Сервер загрузился не полностью или размер выпуска не совпадает. Повторите загрузку.';

  @override
  String get failureHashMismatch =>
      'Контрольная сумма выпуска не совпадает. Этот архив нельзя запускать.';

  @override
  String get failureArchiveInvalid =>
      'Архив сервера содержит недопустимые пути, файлы или размеры. Установка остановлена.';

  @override
  String get failureExecutePermission =>
      'Не удалось разрешить запуск сервера. Проверьте доступ к каталогу приложения.';

  @override
  String get failureHomeStartFailed =>
      'Не удалось запустить домашний сервер. Проверьте доступ к данным, свободные порты и параметры подключения.';

  @override
  String get failureHomeStopFailed =>
      'Сервер не подтвердил остановку всех процессов. Проверьте его состояние перед повторным запуском.';

  @override
  String get failureHomeUpdatePending =>
      'Обновление домашнего сервера не завершено. Сначала завершите обновление или восстановление; обычный запуск заблокирован.';

  @override
  String get failureHomeJournalInvalid =>
      'Журнал обновления повреждён или недоступен. Автоматическое продолжение заблокировано; нужна ручная проверка.';

  @override
  String get failureHomeBackupMissing =>
      'Резервная копия отсутствует. Автоматическое восстановление заблокировано.';

  @override
  String get failureHomeBackupInvalid =>
      'Резервная копия повреждена, неполна или недоступна. Текущие данные не заменены.';

  @override
  String get failureHomeRecoveryInvalid =>
      'Контрольная запись или каталоги восстановления не соответствуют исходной базе. Переключение заблокировано.';

  @override
  String get homeRecoveryHelp =>
      'Сохраните каталог home-server целиком, включая журнал, backups, recoveries и failed-data. Не удаляйте журнал и не заменяйте базу вручную. Откройте инструкцию восстановления.';

  @override
  String get homeRecoveryGuide => 'Инструкция восстановления';

  @override
  String get homeRecoveryGuideFailed =>
      'Не удалось открыть инструкцию восстановления.';

  @override
  String get homeRecoveryCopy => 'Скопировать сведения';

  @override
  String get failureHomeUpdateFailed =>
      'Обновление не выполнено. Проверьте состояние операции и повторите попытку; новая версия не будет запущена без проверки.';

  @override
  String get failurePermissionDenied =>
      'Сервер отказал в доступе. Проверьте роль, блокировку и приглашение.';

  @override
  String get failureUnauthenticated =>
      'Сессия или разрешение устройства недействительны. Войдите заново; новое разрешение автоматически не создаётся.';

  @override
  String get failureServerLimit => 'Достигнут лимит сервера. Попробуйте позже.';

  @override
  String get failureConnectionFailed =>
      'Не удалось связаться с сервером. Проверьте адрес и сеть.';

  @override
  String get failureTlsRejected =>
      'Защищённое соединение не прошло проверку. Проверьте сертификат и доверенный отпечаток.';

  @override
  String get failureProtocolInvalid =>
      'Сервер вернул несовместимые или некорректные данные. Операция остановлена.';

  @override
  String get failureIdentityInvalid =>
      'Проверка ключей, подписей или идентичности не пройдена. Операция остановлена.';

  @override
  String get failureAddressInvalid =>
      'Укажите HTTPS-адрес сервера или локальный HTTP-адрес. Проверьте ссылку и код приглашения.';

  @override
  String get failureOperationFailed =>
      'Не удалось выполнить операцию. Проверьте соединение и доступ к защищённому хранилищу.';

  @override
  String get failureRetrySameRequest =>
      'Повтор с тем же текстом использует прежний ключ запроса.';

  @override
  String get failurePositionsLoad =>
      'Не удалось загрузить позиции чтения. История будет загружена заново.';

  @override
  String get failurePositionsSave =>
      'Позиция чтения обновлена, но сохранить её на устройстве не удалось.';

  @override
  String get failureChannelChanged =>
      'Права канала изменились. Обновите чат перед повтором.';

  @override
  String get failureChannelUnavailable =>
      'Доступ к этому каналу изменён. Выберите доступный чат.';

  @override
  String get failureEventsUnsupported =>
      'Сервер пока не поддерживает подписку событий. Обновите сервер.';

  @override
  String get failureCursorRejected =>
      'Сервер не принял курсор истории. Подключитесь заново для загрузки сообщений.';

  @override
  String get failureDeviceRevoked =>
      'Доступ этого устройства отозван. Ключи сохранены; новое разрешение автоматически не создаётся.';

  @override
  String get failureQrTooLarge =>
      'Карточка слишком большая для QR; сохраните JSON.';

  @override
  String get failureQrFileTooLarge =>
      'Файл превышает допустимый размер: PNG — 8 МиБ, JSON — 16 КиБ.';

  @override
  String get failureQrImageInvalid =>
      'PNG повреждён или имеет недопустимый размер. Нужен исходный файл от 64 до 2048 пикселей по каждой стороне.';

  @override
  String get failureQrUnreadable =>
      'QR не прочитан или не является карточкой Space. Выберите исходный PNG с белыми полями.';

  @override
  String get failureKeyStorageMismatch =>
      'Запись ключей принадлежит другому адресу. Операция остановлена.';

  @override
  String get failureKeyStorageSave =>
      'Защищённое хранилище не подтвердило сохранение ключей. Ротация не отправляется без сохранённого ключа.';

  @override
  String get failureKeyJournalInvalid =>
      'Журнал смены ключа повреждён или превышает 64 КиБ. Проверьте защищённое хранилище.';

  @override
  String get failureCameraDenied =>
      'Доступ к камере запрещён. Разрешите его в настройках системы.';

  @override
  String get failureCameraUnavailable =>
      'Камера недоступна или занята. Можно восстановиться из PNG или JSON.';

  @override
  String get failureCameraFrame =>
      'Не удалось прочитать кадр. Проверьте камеру или выберите файл.';

  @override
  String get failureCameraStopped =>
      'Камера остановлена. Нажмите «Включить снова».';

  @override
  String get sendingMessage => 'Отправляется…';

  @override
  String get messageUnconfirmed =>
      'Нет подтверждения сервера. Повторите отправку с тем же текстом.';

  @override
  String get messageAccepted => 'Принято сервером';

  @override
  String get appSettings => 'Настройки приложения';

  @override
  String get serverSettings => 'Настройки сервера';

  @override
  String get homeStopping => 'Отключаем сервер и базу данных…';

  @override
  String get homeProgressHint =>
      'Готовность по этапам. Точное время ожидания процесса заранее неизвестно.';

  @override
  String homeProgressElapsed(int seconds) {
    return 'Прошло: $seconds с';
  }

  @override
  String homeDownloadEstimate(int seconds) {
    return 'Загрузка: примерно $seconds с осталось';
  }

  @override
  String get identityDescription =>
      'Ключи, разрешения и восстановление доступа в выбранном пространстве.';

  @override
  String get hotkeysTitle => 'Горячие клавиши';

  @override
  String get resetShortcut => 'Вернуть Enter по умолчанию';

  @override
  String get sendShortcutTitle => 'Клавиша отправки';

  @override
  String get sendShortcutHelp =>
      'Выберите Enter или Shift+Enter для отправки. Другая комбинация добавляет новую строку.';

  @override
  String get createOwnSpace => 'Создать пространство';

  @override
  String get setupSpaceName => 'Название';

  @override
  String get setupResources => 'Разделы';

  @override
  String get setupComingSoon => 'Скоро';

  @override
  String get setupInternetHelp =>
      'Для друзей: публичный IPv4 и проброс TCP 8443.';

  @override
  String get setupReady => 'Пространство готово';

  @override
  String get setupInviteHelp =>
      'Одноразовое приглашение · 24 часа. Новые — в управлении.';

  @override
  String get setupWorking => 'Создаём пространство…';

  @override
  String get setupBack => 'Назад';

  @override
  String get setupNext => 'Далее';

  @override
  String get setupOwnerRequired =>
      'Не удалось подключиться владельцем. Откройте «Выйти в эфир» и проверьте состояние сервера.';

  @override
  String get setupUpdateRequired =>
      'Для настройки иконки сначала обновите домашний сервер.';

  @override
  String get myDevice => 'Устройство';

  @override
  String get myDeviceDescription => 'Идентичности и ключи этого устройства.';

  @override
  String get myDeviceStorage => 'Ключи — в защищённом хранилище устройства.';

  @override
  String get myDeviceAccessHelp =>
      'Выберите идентичность для QR, восстановления и сопряжения.';

  @override
  String get deviceIdentityChoice => 'Идентичность на этом устройстве';

  @override
  String get deviceConnectIdentity => 'Подключить идентичность';

  @override
  String get recoveryReadingFile => 'Чтение файла…';

  @override
  String get recoveryDecryptingCard => 'Расшифровка и проверка ключей…';

  @override
  String get recoveryCheckingServer => 'Проверка сервера…';

  @override
  String get recoveryConnectingDevice => 'Подключение устройства…';

  @override
  String get recoveryChooseFile => 'Выберите карточку PNG или JSON';

  @override
  String get recoveryParentFolder => 'Папка выше';

  @override
  String get recoveryFilePath => 'Полный путь к файлу';

  @override
  String get recoveryOpenFile => 'Открыть файл';

  @override
  String get recoveryFolderUnavailable =>
      'Не удалось прочитать папку. Укажите полный путь к файлу.';

  @override
  String get setupExisting => 'Настройка вашего сохранённого пространства.';

  @override
  String get recoveryGeneratingQr => 'Создаём QR…';

  @override
  String get recoverySaveQr => 'Сохранить QR';

  @override
  String get recoveryOverwriteQr => 'Заменить существующий файл QR-карточки?';

  @override
  String get serverSearch => 'Найти пространство';

  @override
  String get serverFilterAll => 'Все';

  @override
  String get serverNoEvents => 'Нет загруженных сообщений';

  @override
  String get serverOffline => 'Офлайн';

  @override
  String get removeServer => 'Убрать из приложения';

  @override
  String get removeServerConfirm =>
      'История на этом устройстве будет удалена. Сервер можно добавить снова.';

  @override
  String get serverAccessRemoved => 'Доступ отозван. Сервер убран.';

  @override
  String get serverRemoveFailed => 'Не удалось убрать сервер. Повторите.';

  @override
  String get serverInAir => 'Сервер в эфире';

  @override
  String get serverNoChannels => 'Нет доступных каналов';

  @override
  String get spacesTitle => 'Пространства';

  @override
  String get updatesTitle => 'Обновления';

  @override
  String get updatesCheck => 'Проверить обновления';

  @override
  String get updatesChecking => 'Проверяем…';

  @override
  String get updatesCurrent => 'Установлена актуальная версия';

  @override
  String updatesAvailable(String version) {
    return 'Доступна версия $version';
  }

  @override
  String get updatesEmpty => 'Опубликованных сборок пока нет';

  @override
  String get updatesFailed => 'Не удалось проверить. Повторите.';

  @override
  String get updatesOpen => 'Открыть выпуск';

  @override
  String get updatesChanges => 'Изменения';

  @override
  String updatesInstalled(String version) {
    return 'Версия $version';
  }

  @override
  String get updatesUnknownVersion => 'Версия недоступна';

  @override
  String get updatesOpenFailed => 'Не удалось открыть страницу выпуска';

  @override
  String get updatesPackageUnavailable =>
      'Для этой системы пакет пока недоступен.';

  @override
  String updatesPackage(String platform, String size) {
    return '$platform · $size МБ';
  }

  @override
  String get updatesDownload => 'Скачать';

  @override
  String get updatesDownloadFailed => 'Не удалось скачать. Повторите загрузку.';

  @override
  String get updatesDownloaded => 'Пакет скачан и проверен.';

  @override
  String get updatesInstall => 'Установить и перезапустить';

  @override
  String get updatesPreparing =>
      'Завершаем операции и останавливаем домашний сервер…';

  @override
  String get updatesInstallFailed =>
      'Не удалось начать установку. Проверьте отправку сообщений и состояние домашнего сервера, затем повторите.';

  @override
  String get updatesHomeTitle => 'Эфир';

  @override
  String get updatesHomeResume =>
      'Перед обновлением домашний сервер работал. Запустить его снова?';

  @override
  String get updatesLater => 'Позже';

  @override
  String get updatesHomeStart => 'Запустить';

  @override
  String get addFavorite => 'Добавить в избранное';

  @override
  String get removeFavorite => 'Удалить из избранного';

  @override
  String get favoriteMessages => 'Избранные сообщения';

  @override
  String get failureConnectRequired =>
      'Нужен сервер с поддержкой ConnectRPC. Обновите домашний runtime или обратитесь к владельцу пространства.';

  @override
  String get spaceQrCamera => 'Сканировать QR';

  @override
  String get spaceQrImage => 'Выбрать изображение QR';

  @override
  String get spaceQrInvalid =>
      'Не удалось прочитать QR со ссылкой на пространство.';

  @override
  String get homeExport => 'Экспортировать пространство';

  @override
  String get homeImport => 'Импортировать пространство';

  @override
  String get homeTransferHelp =>
      'Архив содержит сообщения, настройки и ключи сервера. Храните его в тайне и импортируйте только свой архив. На время экспорта сервер остановится; импорт не заменяет существующее пространство. При смене IP сохранятся идентичность пространства и TLS-отпечаток. На новом компьютере отдельно восстановите карточку владельца.';

  @override
  String get homeImportIP => 'Новый публичный IPv4 (пусто — сохранить прежний)';

  @override
  String get homeExported => 'Пространство экспортировано';

  @override
  String get homeImported =>
      'Пространство импортировано. Теперь можно запустить сервер.';

  @override
  String get homeTransferring => 'Перенос пространства';

  @override
  String get homeTransferFailed =>
      'Не удалось открыть архив или завершить перенос.';

  @override
  String get glassEffects => 'Эффекты стекла';

  @override
  String get glassEffectsHelp => 'Размытие плавающих панелей и заголовка.';

  @override
  String get attachFiles => 'Прикрепить файлы';

  @override
  String get myFiles => 'Мои файлы';

  @override
  String get removeFile => 'Убрать файл';

  @override
  String get cancelUpload => 'Отмена';

  @override
  String get downloadFile => 'Скачать файл';

  @override
  String get downloadFailed => 'Не удалось скачать файл';

  @override
  String get noFilesInChannel => 'В этом канале пока нет ваших файлов';

  @override
  String get loadMoreFiles => 'Загрузить ещё';

  @override
  String get closeFiles => 'Закрыть';

  @override
  String get dropFilesHere => 'Отпустите файлы, чтобы прикрепить';

  @override
  String get optionalNickname => 'Ник (необязательно)';

  @override
  String get channelFiles => 'Вложения чата';

  @override
  String get allFileAuthors => 'Все участники';

  @override
  String get refreshFiles => 'Обновить вложения';
}
