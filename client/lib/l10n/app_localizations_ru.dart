// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get voiceShortcutTitle => 'Клавиши рации';

  @override
  String get voiceShortcutScope =>
      'Действуют в активном окне. При потере фокуса передача закрывается.';

  @override
  String get voiceShortcutPress =>
      'Нажмите клавишу или сочетание с Ctrl, Alt, Shift или Meta. Отпустите клавиши перед сохранением. Escape — отмена.';

  @override
  String get voiceShortcutSave => 'Сохранить';

  @override
  String get deviceTransferTitle => 'Перенос устройства';

  @override
  String get deviceTransferHelp =>
      'Два шага: сохраните один зашифрованный архив, затем перетащите его сюда на новом устройстве. Пространства, ключи, история, очереди, черновики, настройки и домашний Эфир переносятся вместе.';

  @override
  String get deviceTransferExport => 'Полный перенос';

  @override
  String get deviceTransferExportHelp =>
      'Сохранить устройство целиком в один файл';

  @override
  String get deviceTransferRestore => 'Полное восстановление';

  @override
  String get deviceTransferRestoreHelp =>
      'Перетащите архив сюда или нажмите, чтобы выбрать файл';

  @override
  String get deviceTransferOneFile =>
      'Перетащите один файл полного переноса устройства.';

  @override
  String get deviceTransferPasswordHelp =>
      'Пароль архива может быть любым, в том числе пустым. Полный перенос остановит все пространства и домашний сервер на исходном устройстве после проверки архива. Сохраните архив и пароль вне диска ОС. Восстановление выполняется в новой установке; после него перезапустите приложение. Не восстанавливайте один архив на нескольких устройствах. Для следующего переноса после продолжения переписки нужен новый архив.';

  @override
  String get deviceTransferFinished =>
      'Сохраните архив и пароль. Закройте приложение; после восстановления откройте его заново. Прежнее устройство не используйте для продолжения переписки.';

  @override
  String get deviceTransferClose => 'Закрыть приложение';

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
  String get rooms => 'Комнаты';

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
  String get channels => 'Чаты';

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
  String get independentServer => 'Чаты и доступ задаёт этот сервер.';

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
  String get closeNavigation => 'Закрыть навигацию';

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
  String get welcomeDescription => 'Чаты и ресурсы сервера.';

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
      'Уведомления можно включить в настройках приложения. Камера и микрофон включаются только по вашему действию.';

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
  String get feedTitle => 'Лента пространства';

  @override
  String get feedDescription =>
      'Новости и публикации участников этого пространства.';

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
  String get channel => 'Чат';

  @override
  String get noReading => 'Нет чтения';

  @override
  String get refreshChat => 'Обновить чаты и чат';

  @override
  String get noMessageAccess => 'Нет доступа к сообщениям';

  @override
  String get startConversation => 'Начните разговор';

  @override
  String get conversationStarts => 'Здесь начинается разговор';

  @override
  String get contactOwner =>
      'Выберите другой чат или обратитесь к владельцу пространства.';

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
  String get cannotSend => 'В этом чате нельзя отправлять сообщения';

  @override
  String get messageHint => '';

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
  String get rotationDevicesReview =>
      'Проверьте устройства, которым будет сохранён доступ. Если устройство неизвестно, отмените операцию и сначала отзовите его разрешение.';

  @override
  String get rotationConfirm =>
      'Сменить корневой ключ? ID, права, история и подтверждённые действующие устройства сохранятся без продления доступа. Старые сеансы и карточки восстановления перестанут действовать. Новый секрет сначала сохраняется в защищённый журнал. После перехода сохраните новую карточку.';

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
      'Корневой ключ сменён, ID и подтверждённые устройства сохранены. Сохраните новую карточку; прежние карточки больше не действуют.';

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
  String get dashboardDescription => 'Серверы, чаты и непрочитанные сообщения.';

  @override
  String get dashboardServers => 'Серверы';

  @override
  String get dashboardOnline => 'Онлайн';

  @override
  String get dashboardChannels => 'Доступные чаты';

  @override
  String get dashboardUnread => 'Непрочитанные';

  @override
  String get dashboardRefresh => 'Обновить сводку';

  @override
  String get dashboardEmpty => 'Добавьте первое пространство';

  @override
  String get dashboardEmptyHelp => 'Добавьте сервер или создайте свой.';

  @override
  String get dashboardCatalogUnknown => 'Подключитесь, чтобы загрузить чаты.';

  @override
  String get dashboardAvailable => 'Доступен';

  @override
  String get dashboardUnavailable => 'Недоступен';

  @override
  String get dashboardOpen => 'Открыть пространство';

  @override
  String get dashboardResourcesHelp =>
      'Сводка учитывает доступные вам чаты и непрочитанные сообщения. Данные недоступных серверов появятся после подключения.';

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
      'Права чата изменились. Обновите чат перед повтором.';

  @override
  String get failureChannelUnavailable =>
      'Доступ к этому чату изменён. Выберите доступный чат.';

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
      'Нет подтверждения сервера. Запрос сохранён в очереди.';

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
  String get serverNoChannels => 'Нет доступных чатов';

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
  String get noFilesInChannel => 'В этом чате пока нет ваших файлов';

  @override
  String get loadMoreFiles => 'Загрузить ещё';

  @override
  String get closeFiles => 'Закрыть';

  @override
  String get dropFilesHere => 'Отпустите файлы, чтобы прикрепить';

  @override
  String get optionalNickname => 'Имя (необязательно)';

  @override
  String get channelFiles => 'Вложения чата';

  @override
  String get allFileAuthors => 'Все участники';

  @override
  String get refreshFiles => 'Обновить вложения';

  @override
  String get filesLoadFailed =>
      'Не удалось загрузить вложения. Попробуйте обновить список.';

  @override
  String get filesServerUpdateRequired =>
      'Для списка вложений нужна актуальная версия сервера.';

  @override
  String get serverNickname => 'Свое имя в этом пространстве';

  @override
  String get nicknameUniqueHelp =>
      'Имя должно быть уникальным на сервере. Регистр не учитывается. Пустое поле убирает имя.';

  @override
  String get saveNickname => 'Сохранить имя';

  @override
  String get nicknameSaved => 'Имя сохранено';

  @override
  String get nicknameTaken => 'Это имя уже занято. Выберите другое.';

  @override
  String get nicknameInvalid =>
      'Используйте до 40 символов без переносов строк.';

  @override
  String get nicknameFailed =>
      'Не удалось изменить профиль. Проверьте подключение.';

  @override
  String get retryProfile => 'Повторить';

  @override
  String get messageUnavailable => 'Сообщение недоступно';

  @override
  String get mlsTitle => 'Закрытый чат · MLS';

  @override
  String get mlsExperimental => 'Экспериментальный режим E2EE';

  @override
  String get mlsCreate => 'Создать закрытый чат';

  @override
  String get mlsChannelId => 'Идентификатор чата';

  @override
  String get mlsChannelTitle => 'Название чата';

  @override
  String get mlsDeviceCode => 'Код этого устройства';

  @override
  String get mlsDevices => 'Устройства чата';

  @override
  String get mlsVerify => 'Проверить устройство';

  @override
  String get mlsTrust => 'Код совпадает';

  @override
  String get mlsVerifyHint =>
      'Сверьте этот код на другом устройстве по независимому каналу. Сервер не подтверждает подлинность ключа.';

  @override
  String get mlsInvite => 'Пригласить';

  @override
  String get mlsRemove => 'Исключить устройство';

  @override
  String get mlsRetry => 'Обновить и повторить отправку';

  @override
  String get mlsWaiting =>
      'Это устройство ещё не приглашено в чат или доступ отозван. Передайте его код владельцу чата.';

  @override
  String get mlsInput => '';

  @override
  String get mlsSend => 'Отправить';

  @override
  String get mlsAttach => 'Прикрепить файл';

  @override
  String get mlsFiles => 'Файлы чата';

  @override
  String get mlsUnavailable => 'Сообщение недоступно';

  @override
  String get mlsCancel => 'Отмена';

  @override
  String get mlsTransfer => 'Передать управление';

  @override
  String get mlsTransferTitle => 'Передать управление чатом?';

  @override
  String mlsTransferHint(String device) {
    return 'Устройство $device сможет приглашать и исключать участников. Ваш доступ к переписке и файлам сохранится.';
  }

  @override
  String get homeExternalHost => 'Внешний адрес (IPv4, IPv6 или домен)';

  @override
  String get homeExternalPort => 'Внешний порт';

  @override
  String get homeAddAddress => 'Добавить адрес';

  @override
  String get homeRemoveAddress => 'Удалить адрес';

  @override
  String get homeListenPort => 'Локальный порт';

  @override
  String get homeListenInterfaces => 'Сеть';

  @override
  String get homeNetworkHelp =>
      'Внешний порт может отличаться от локального. Изменения применятся при следующем запуске сервера.';

  @override
  String get homeSaveAddresses => 'Сохранить настройки';

  @override
  String get homeNetworkInvalid =>
      'Проверьте адреса и порты (1–65535). Адреса не должны повторяться.';

  @override
  String get homeAddressLabel => 'Адрес';

  @override
  String get homePrimaryAddress => 'Основной адрес';

  @override
  String get homeBackupAddress => 'Запасной адрес';

  @override
  String get homeConnectionAddresses => 'Подключение участников';

  @override
  String get homeAddressHelp =>
      'Домен, IPv4 или IPv6 — без https:// и скобок. Запасной адрес поможет, если основной недоступен.';

  @override
  String get homeLocalSettings => 'На этом компьютере';

  @override
  String get homeDiagTitle => 'Диагностика подключения';

  @override
  String get homeDiagRun => 'Проверить';

  @override
  String get homeDiagRunning => 'Проверяем адреса…';

  @override
  String get homeDiagWANLabel => 'WAN IP роутера (необязательно)';

  @override
  String get homeDiagWANHelp =>
      'Адрес со страницы состояния роутера. Это поле не сохраняется.';

  @override
  String get homeDiagCopyCommand => 'Скопировать команду для другой сети';

  @override
  String get homeDiagExternalHelp =>
      'Space в другой сети автоматически проверяет сохранённое пространство. Для отдельной проверки можно запустить эту команду на внешнем компьютере. Через прокси или VPN результат может остаться неподтверждённым.';

  @override
  String get homeDiagUnsupported =>
      'Установленный runtime не поддерживает диагностику. Обновите сервер.';

  @override
  String get homeDiagFailed =>
      'Не удалось выполнить диагностику. Проверьте установленный runtime и повторите.';

  @override
  String get homeDiagLocalPrefix => 'Локальная проверка';

  @override
  String get homeDiagLocalOk =>
      'Сервер отвечает локально; TLS и подпись верны.';

  @override
  String get homeDiagRouteOk =>
      'Адрес доступен с этого компьютера; TLS и подпись верны.';

  @override
  String get homeDiagUnreachable =>
      'Нет подключения. Проверьте запуск, порт и файрвол. Это не доказательство CGNAT.';

  @override
  String get homeDiagDNS => 'Домен не разрешается. Проверьте имя и DNS-запись.';

  @override
  String get homeDiagCertificateOk => 'Сертификат пространства действителен.';

  @override
  String get homeDiagCertificateMissing =>
      'Нет сертификата. Запустите сервер и повторите проверку.';

  @override
  String get homeDiagCertificateExpired =>
      'Срок действия сертификата не подходит. Проверьте часы и сертификат.';

  @override
  String get homeDiagCertificateMismatch =>
      'На адресе другой сертификат. Проверьте маршрутизацию; не заменяйте доверенный отпечаток.';

  @override
  String get homeDiagDiscovery =>
      'Адрес отвечает, но идентичность или подпись неверна. Проверьте адрес и туннель.';

  @override
  String get homeDiagWANUnknown =>
      'WAN IP неизвестен; наличие CGNAT не определено. Можно указать WAN IP роутера выше.';

  @override
  String get homeDiagWANInvalid =>
      'Некорректный WAN IP. Возьмите адрес со страницы состояния роутера.';

  @override
  String get homeDiagWANShared =>
      'WAN IP входит в 100.64.0.0/10 — признак CGNAT. Уточните публичный IP у провайдера или используйте TCP-туннель.';

  @override
  String get homeDiagWANPrivate =>
      'WAN IP частный: возможны двойной NAT или CGNAT. Проверьте вышестоящий роутер и условия провайдера.';

  @override
  String get homeDiagWANPublic =>
      'WAN IP не относится к частным или CGNAT-диапазонам. Это не подтверждает доступность порта извне.';

  @override
  String get homeDiagExternal =>
      'Извне не проверено: свежего внешнего подключения нет. Откройте пространство на устройстве в другой сети и повторите проверку. Это не означает, что сервер недоступен.';

  @override
  String get homeDiagBudget =>
      'Время диагностики истекло; оставшиеся адреса не проверены.';

  @override
  String get homeDiagUnknown =>
      'Неизвестный результат; обновите приложение и runtime.';

  @override
  String get homeDiagInterface =>
      'Адрес прослушивания не принадлежит этому компьютеру. Выберите локальный интерфейс или все интерфейсы.';

  @override
  String get homeDiagIPv6Private =>
      'WAN IPv6 локальный и не подходит для прямого доступа из интернета. Это не доказывает CGNAT.';

  @override
  String get homeDiagNotReady =>
      'TLS отвечает, но сервер ещё не готов (HTTP 503). Завершите первую настройку или дождитесь запуска.';

  @override
  String get homeDiagObserved =>
      'HTTPS-вход получил запрос из другой публичной сети. Подтверждение относится к указанному времени и этому адресу.';

  @override
  String homeDiagObservedAt(String time) {
    return 'Последнее внешнее подключение: $time';
  }

  @override
  String get initialServerSetupTitle => 'Первый вход в пространство';

  @override
  String get initialServerSetupHelp =>
      'Вы станете владельцем этого пространства и сможете назначать других участников администраторами. Ссылка настройки одноразовая.';

  @override
  String get homeAutoPortMapping => 'Автоматический проброс порта';

  @override
  String get homeAutoPortMappingHelp =>
      'Временное правило TCP через PCP, NAT-PMP или UPnP. Удаляется при остановке; не обходит CGNAT.';

  @override
  String get homeAutoPublicIP => 'Обновлять публичный IP';

  @override
  String get homeAutoPublicIPHelp =>
      'Для первого адреса IPv4. Проверка через роутер или ipify; домены и остальные адреса сохраняются.';

  @override
  String get homeDiagMappingOk =>
      'Шлюз подтвердил временный проброс TCP. Доступность извне ещё не проверена.';

  @override
  String get homeDiagMappingFailed =>
      'Не удалось создать или продлить проброс. Проверьте настройки роутера; при CGNAT нужен публичный адрес или туннель.';

  @override
  String get homeDiagAutomaticIPFailed =>
      'Не удалось обновить публичный IPv4. Проверьте подключение к интернету.';

  @override
  String get emojiPicker => 'Эмодзи';

  @override
  String get emojiSearch => 'Поиск эмодзи';

  @override
  String get emojiRecent => 'Недавние';

  @override
  String get emojiAll => 'Все';

  @override
  String get addReaction => 'Добавить реакцию';

  @override
  String get reactionParticipants => 'Кто отреагировал';

  @override
  String get copyMessage => 'Скопировать';

  @override
  String get messageCopied => 'Скопировано';

  @override
  String get emojiFaces => 'Лица и эмоции';

  @override
  String get emojiPeople => 'Люди и жесты';

  @override
  String get emojiNature => 'Животные и природа';

  @override
  String get emojiFood => 'Еда и напитки';

  @override
  String get emojiTravel => 'Путешествия и места';

  @override
  String get emojiActivities => 'Занятия';

  @override
  String get emojiObjects => 'Предметы';

  @override
  String get emojiSymbols => 'Символы';

  @override
  String get emojiFlags => 'Флаги';

  @override
  String get messageQueued =>
      'Сообщение сохранено в очереди на этом устройстве';

  @override
  String get outboxTitle => 'Очередь отправки';

  @override
  String get outboxWaiting => 'Ожидает отправки';

  @override
  String get outboxBlocked => 'Отправка остановлена';

  @override
  String get outboxUnavailable =>
      'Не удалось прочитать или сохранить очередь. Текст остаётся в поле ввода.';

  @override
  String get outboxRetry => 'Повторить отправку';

  @override
  String get outboxDiscard => 'Убрать из очереди';

  @override
  String get outboxDiscardDescription =>
      'Сообщение могло уже попасть на сервер. Удаление из очереди прекращает повторы, но не удаляет сообщение у участников.';

  @override
  String get outboxFileMessage => 'Сообщение с вложениями';

  @override
  String get outboxIdentityChanged =>
      'Разрешение устройства изменилось. Прежняя очередь сохранена; автоматическая отправка от нового устройства запрещена.';

  @override
  String get outboxFull =>
      'Очередь заполнена: до 100 сообщений и 1 МиБ. Дождитесь отправки или уберите ненужные сообщения.';

  @override
  String get outboxFileLimit =>
      'Для ожидающих вложений доступно 200 МиБ на пространство и устройство. Дождитесь отправки или уберите ненужные сообщения.';

  @override
  String get outboxRecover => 'Восстановить прежнюю очередь';

  @override
  String get outboxRecoverDescription =>
      'Эти сообщения остались на этом компьютере под прежним разрешением устройства. Проверьте их перед переносом. Ключи запросов сохраняются, уже принятые сообщения не дублируются.';

  @override
  String get outboxRecoverTrust =>
      'Я доверяю текущему устройству и разрешаю отправить эти сообщения от моего имени.';

  @override
  String get outboxRecoverSend => 'Перенести и отправить';

  @override
  String get outboxRecoverFailed =>
      'Не удалось завершить перенос. Очередь сохранена; проверьте подключение и повторите.';

  @override
  String get outboxEdit => 'Правка сообщения';

  @override
  String get outboxDelete => 'Удаление сообщения';

  @override
  String get outboxReactionAdd => 'Добавить реакцию';

  @override
  String get outboxReactionRemove => 'Снять реакцию';

  @override
  String get outboxMutationBlocked =>
      'Изменение остановлено. Проверьте права, версию runtime и новое состояние сообщения. При конфликте уберите действие из очереди и выполните его заново.';

  @override
  String get outboxDiscardMutationDescription =>
      'Действие могло уже выполниться на сервере. Удаление из очереди прекращает локальные повторы, но не отменяет выполненное действие. Зависимые действия остановятся.';

  @override
  String get replyMessage => 'Ответить';

  @override
  String get cancelReply => 'Отменить ответ';

  @override
  String get replyUnavailable => 'Исходное сообщение недоступно';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationsOff => 'Выключены';

  @override
  String get notificationsPrivate => 'Скрывать содержимое';

  @override
  String get notificationsPreview => 'Показывать текст сообщения';

  @override
  String get notificationsDescription =>
      'На компьютере: Обычные и присоединённые закрытые чаты подключённых пространств, пока приложение запущено. Предпросмотр передаёт текст операционной системе. Доставка после закрытия приложения пока не поддерживается.';

  @override
  String get notificationPermissionError =>
      'Не удалось разрешить уведомления. Проверьте системные настройки.';

  @override
  String get newMessageNotification => 'Новое сообщение';

  @override
  String get messageSearchServer => 'Поиск в истории выбранного чата';

  @override
  String get messageSearchLocal => 'Поиск только на этом устройстве · MLS';

  @override
  String get messageSearchFailed => 'Не удалось выполнить поиск. Повторить';

  @override
  String get messageSearchMore => 'Ещё сообщения';

  @override
  String get messageSearchLimit =>
      'Показаны первые 200 совпадений. Уточните запрос.';

  @override
  String get loadOlderMessages => 'Загрузить предыдущие сообщения';

  @override
  String get historyPageFailed =>
      'Не удалось загрузить историю. Повторите попытку.';

  @override
  String get messageSearchAllChannels => 'Во всех доступных чатах';

  @override
  String get messageSearchMixed =>
      'Закрытые чаты — поиск только на этом устройстве';

  @override
  String get savedMlsSearchChannels => 'Сохранённые закрытые чаты';

  @override
  String get savedMlsMessagePreview =>
      'Сохранённое сообщение · без подключения к серверу';

  @override
  String get homeArchiveVerified => 'Архив проверен';

  @override
  String homeArchiveSummary(
    String serverId,
    int schema,
    int files,
    String size,
  ) {
    return 'Пространство: $serverId\nВерсия данных: $schema\nФайлов в архиве: $files\nОбъём после распаковки: $size МиБ';
  }

  @override
  String get homeArchiveReviewHelp =>
      'Состав и контрольные суммы проверены. Это не подтверждает источник архива: восстанавливайте только свою копию. Сервер ещё не восстанавливался. Ключ владельца и история MLS на устройстве восстанавливаются отдельно.';

  @override
  String get homeArchiveRestore => 'Начать восстановление';

  @override
  String get homeArchiveUnsupported =>
      'Этот runtime ещё не умеет проверять архивы. Нужен совместимый выпуск приложения и runtime с поддержкой проверки; восстановление не начато.';

  @override
  String get homeArchiveCheckFailed =>
      'Не удалось проверить архив. Он может быть повреждён или несовместим с runtime. Восстановление не начато.';

  @override
  String get homeDiskTitle => 'Диск и резервные копии';

  @override
  String get homeDiskPolicy =>
      'Ручная очистка runtime и копий обновления сохраняет текущий и предыдущий runtime, три самые новые проверенные копии и копию текущего восстановления. Другие копии предлагаются только спустя 30 дней. Файлы вне домашнего сервера не удаляются.';

  @override
  String get homeDiskScan => 'Показать размеры / обновить';

  @override
  String get homeDiskClean => 'Удалить выбранное';

  @override
  String get homeDiskConfirm =>
      'Выбранные каталоги будут удалены без возможности отмены. Данные пространства, защищённые копии и внешние ZIP-архивы сохранятся. Продолжить?';

  @override
  String get homeDiskFailed =>
      'Не удалось завершить проверку или очистку. Состояние могло измениться; обновите список. При ссылках и незавершённом восстановлении очистка запрещена.';

  @override
  String get homeDiskData => 'Данные пространства';

  @override
  String get homeDiskRuntimes => 'Версии сервера';

  @override
  String get homeDiskBackups => 'Резервные копии';

  @override
  String get homeDiskRecoveries => 'Данные восстановления';

  @override
  String get homeDiskFree => 'Свободно на диске сервера';

  @override
  String get homeDiskEstimate =>
      'Размеры приблизительные и могут меняться во время работы сервера. Очистка повторно проверяет выбранные файлы.';

  @override
  String get homeDiskNothing =>
      'Нет старых каталогов, которые можно безопасно удалить.';

  @override
  String get homeDiskStop => 'Для очистки сначала остановите сервер.';

  @override
  String get homeBackupTitle => 'Копии по расписанию';

  @override
  String get homeBackupHelp =>
      'Копии создаёт работающий runtime без отключения чатов. После простоя создаётся одна свежая копия. Изменения применяются в течение минуты; начатая операция может завершиться по прежним настройкам.';

  @override
  String get homeBackupUnsupported =>
      'Установите или обновите runtime для копий по расписанию.';

  @override
  String get homeBackupEnabled => 'Включить расписание';

  @override
  String get homeBackupInterval => 'Интервал, часы';

  @override
  String get homeBackupPrune => 'Автоматически удалять старые копии';

  @override
  String get homeBackupCount => 'Количество копий (3–100)';

  @override
  String get homeBackupDays => 'Срок хранения, дни (1–3650)';

  @override
  String get homeBackupQuota => 'Лимит, МиБ (0 — без лимита)';

  @override
  String get homeBackupRetention =>
      'При включённой автоочистке применяется любой из лимитов. Три самые новые проверенные копии сохраняются даже при превышении объёма. Неизвестные, повреждённые и несовместимые файлы не удаляются.';

  @override
  String get homeBackupSave => 'Сохранить настройки';

  @override
  String get homeBackupConfigure => 'Настроить копирование';

  @override
  String get homeBackupRefresh => 'Обновить статус';

  @override
  String get homeBackupFailed =>
      'Копирование или очистка не завершены. Проверьте настройки, место и доступ к диску. Следующая попытка — не раньше чем через пять минут.';

  @override
  String get homeBackupLast => 'Последняя успешная копия';

  @override
  String get homeBackupNext => 'Следующая проверка';

  @override
  String get homeBackupProtected =>
      'Часть файлов защищена от удаления или лимит объёма недостижим при сохранении трёх копий.';

  @override
  String get homeBackupOff => 'Расписание выключено';

  @override
  String get homeBackupRunning => 'Создаётся копия…';

  @override
  String get homeBackupOK => 'Последняя операция завершена';

  @override
  String get homeBackupSpace =>
      'Не удалось подтвердить свободное место для новой копии.';

  @override
  String get homeBackupWaiting =>
      'Ожидание работающего runtime и срока копирования';

  @override
  String get voiceTitle => 'Голосовые комнаты';

  @override
  String get voiceDescription =>
      'Разговор без камеры. Микрофон включается только по вашему нажатию.';

  @override
  String get voiceCreate => 'Создать комнату';

  @override
  String get voiceName => 'Название комнаты';

  @override
  String get voiceJoin => 'Войти';

  @override
  String get voiceLeave => 'Выйти из разговора';

  @override
  String get voiceMicrophoneOn => 'Включить микрофон';

  @override
  String get voiceMicrophoneOff => 'Выключить микрофон';

  @override
  String get voiceSoundOn => 'Включить звук';

  @override
  String get voiceSoundOff => 'Отключить звук';

  @override
  String get voiceJoining => 'Подключаемся…';

  @override
  String get voiceReconnecting =>
      'Восстанавливаем соединение. Микрофон выключен.';

  @override
  String get voiceConnected => 'В разговоре';

  @override
  String get voiceParticipants => 'Участники';

  @override
  String get voiceMuted => 'Микрофон выключен';

  @override
  String get voiceSpeaking => 'Говорит';

  @override
  String get voiceDeafened => 'Звук выключен';

  @override
  String get voiceEmpty =>
      'Голосовых комнат пока нет. Владелец или администратор может создать первую.';

  @override
  String get voiceConnectFirst =>
      'Подключитесь к пространству, чтобы открыть голосовые комнаты.';

  @override
  String get voiceLimit =>
      'До восьми участников в комнате. Для подключения через интернет владелец настраивает STUN/TURN; приложение получает настройки автоматически.';

  @override
  String get voiceDesktopOnly => 'Голосовой срез пока доступен на компьютере.';

  @override
  String get voicePrivacy =>
      'Без записи и камеры. Звук проходит через сервер пространства; это не MLS-шифрование между участниками.';

  @override
  String get voiceFailure => 'Не удалось продолжить разговор';

  @override
  String get voiceCancel => 'Отмена';

  @override
  String get voiceSave => 'Создать';

  @override
  String get voiceUpdateRuntime =>
      'Для голосовых комнат нужен новый runtime с поддержкой голоса. Обновите сервер в «Эфире».';

  @override
  String get voiceDeviceUnavailable =>
      'Выбранное аудиоустройство отключено. Подключите его или выберите другое. Затем включите микрофон или звук вручную.';

  @override
  String get voiceDeviceDisconnected => 'Устройство отключено';

  @override
  String get voiceAudioDevices => 'Аудиоустройства';

  @override
  String get voiceSettingsTitle => 'Голос';

  @override
  String get voiceInputVolume => 'Громкость микрофона';

  @override
  String get voiceOutputVolume => 'Громкость звука';

  @override
  String get voiceProcessingTitle => 'Обработка звука';

  @override
  String get voiceInputProfile => 'Профиль микрофона';

  @override
  String get voiceProfileSpeech => 'Для разговора';

  @override
  String get voiceProfileStudio => 'Студия — без обработки';

  @override
  String get voiceProfileCustom => 'Пользовательский';

  @override
  String get voiceNoiseSuppression => 'Шумоподавление';

  @override
  String get voiceEchoCancellation => 'Эхоподавление';

  @override
  String get voiceAutoGain => 'Автоматическая регулировка усиления';

  @override
  String get voiceProcessingHint =>
      'Изменение обработки выключает микрофон: включите его снова, чтобы применить настройки. Для профиля «Студия» используйте наушники.';

  @override
  String get voiceTestMicrophone => 'Проверка микрофона';

  @override
  String get voiceStopMicrophoneTest => 'Остановить проверку';

  @override
  String get voiceMicrophoneLevel => 'Уровень микрофона';

  @override
  String get voiceMicrophoneTestHint =>
      'Вы услышите себя. Проверка работает локально до 60 секунд и не передаёт голос в комнату. Звук комнаты будет выключен. Закрытие настроек останавливает проверку.';

  @override
  String get voiceDevicesDescription =>
      'Выберите, через что говорить и слушать. Настройки можно менять до входа в комнату и во время разговора.';

  @override
  String get voiceDevicesRemembered =>
      'Выбор сохраняется на этом компьютере. Вход в комнату и восстановление настроек не включают микрофон.';

  @override
  String get voiceInputDevice => 'Микрофон';

  @override
  String get voiceOutputDevice => 'Вывод звука';

  @override
  String get voiceCurrentDevice => 'Текущее системное устройство';

  @override
  String get voiceRefreshDevices => 'Обновить устройства';

  @override
  String get voiceCloseDevices => 'Закрыть';

  @override
  String get voicePushToTalk => 'Режим рации';

  @override
  String get voicePushToTalkHint =>
      'Включите микрофон в комнате и удерживайте выбранные клавиши для разговора. Работает, пока окно активно. Проверка микрофона воспроизводится непрерывно.';

  @override
  String get voiceAutomaticSensitivity =>
      'Автоматическая чувствительность микрофона';

  @override
  String get voiceSensitivity => 'Порог срабатывания';

  @override
  String get recoveryIncludeSpaces => 'И пространства';

  @override
  String get recoveryIncludeSpacesHint =>
      'Создать второй QR со списком пространств и их ключами доступа. Ключи MLS и история не входят.';

  @override
  String get recoveryAccessQr => 'Восстановление выбранного доступа';

  @override
  String get recoverySpacesQr => 'Пространства и доступ';

  @override
  String get recoverySpacesUseFile =>
      'Набор не помещается в один QR. Сохраните зашифрованный файл.';

  @override
  String get recoverySaveSpacesQr => 'Сохранить QR пространств';

  @override
  String get recoverySaveSpacesFile => 'Сохранить пространства в файл';

  @override
  String recoverySpacesResult(int restored, int total) {
    return 'Добавлено пространств: $restored. Всего в наборе: $total. Имеющиеся ключи сохранены без изменений. Для ошибок повторите импорт.';
  }

  @override
  String get migrationTitle => 'Полный перенос пространства';

  @override
  String get migrationExportHelp =>
      'Архив содержит сервер, ключи устройства, рабочее состояние MLS и локальную историю закрытых чатов. После сохранения прежний клиент прекратит работу с этим пространством. Сохраните архив вне этого диска и запомните пароль. При сбое проверьте файл .pending: он может содержать готовый перенос. После проверки архива рабочие ключи прежнего устройства будут заменены отметкой переноса в системном хранилище.';

  @override
  String get migrationImportHelp =>
      'Восстановление продолжает работу прежнего устройства. Используйте архив только на одном новом устройстве. Старый сервер должен быть остановлен. Существующие ключи не заменяются.';

  @override
  String get migrationPassword => 'Пароль архива';

  @override
  String get migrationPasswordRepeat => 'Повторите пароль';

  @override
  String get migrationExported =>
      'Перенос сохранён. Прежнее устройство остановлено. Сохраните архив и пароль перед переустановкой ОС.';

  @override
  String get voiceRefreshRooms => 'Обновить список комнат';

  @override
  String get voiceRouteDirect => 'Прямое соединение';

  @override
  String get voiceRouteRelay => 'Через TURN';

  @override
  String get voiceRouteUnknown => 'Маршрут пока неизвестен';

  @override
  String voiceRoundTrip(int milliseconds) {
    return 'Задержка RTT: $milliseconds мс';
  }

  @override
  String get voiceProfileSpeechHelp =>
      'Шумоподавление, подавление эха, выравнивание громкости и фильтр гула.';

  @override
  String get voiceProfileStudioHelp =>
      'Без обработки микрофона. Для музыки и подготовленного звука; используйте наушники.';

  @override
  String get voiceProfileCustomHelp =>
      'Все параметры обработки можно настроить отдельно.';

  @override
  String get voiceActivity => 'Активация по голосу';

  @override
  String get voiceActivityHelp =>
      'После ручного включения микрофона передача открывается при превышении порога. Фон тоже может сработать — настройте чувствительность.';

  @override
  String get voiceNoiseSuppressionHelp =>
      'DeepFilterNet3 — нейросетевое подавление шума. WebRTC — более лёгкий вариант. Звук обрабатывается на вашем устройстве.';

  @override
  String get voiceNoiseWebRtc => 'WebRTC';

  @override
  String get voiceNoiseOff => 'Отключено';

  @override
  String get voiceAdvancedSettings => 'Расширенные настройки голоса';

  @override
  String get voiceHighPass => 'Фильтр низкочастотного гула';

  @override
  String get voiceAdvancedActivation => 'Устойчивое срабатывание по голосу';

  @override
  String get voiceAdvancedActivationHelp =>
      'Удерживает передачу при колебаниях уровня около порога, чтобы не обрывать тихие окончания слов. Определяет уровень, а не распознаёт речь.';

  @override
  String voiceReleaseDelay(int milliseconds) {
    return 'Задержка закрытия передачи: $milliseconds мс';
  }

  @override
  String get voiceRoomEmpty => 'В комнате пока никого нет';

  @override
  String get voiceMicrophoneEnabled => 'Микрофон включён';

  @override
  String get voiceActivityUpdateRuntime =>
      'Для подсветки говорящих собеседников обновите runtime пространства.';

  @override
  String get voiceHoldToTalk => 'Удерживайте, чтобы говорить';

  @override
  String get voiceTouchToTalkHint =>
      'Включите микрофон в комнате и удерживайте кнопку разговора. При сворачивании приложения кнопка отпускается.';

  @override
  String get voiceAndroidNoiseHelp =>
      'DeepFilterNet3 включён по умолчанию. WebRTC — более лёгкий вариант; обработку можно отключить. Звук обрабатывается на телефоне.';

  @override
  String get forumConnectFirst =>
      'Подключитесь к пространству, чтобы открыть форум.';

  @override
  String get forumUpdateRuntime =>
      'Для форума нужен новый runtime с поддержкой core.forum.v1. Обновите сервер через «Эфир».';

  @override
  String get forumPrivacy =>
      'Сообщения форума хранятся на сервере без сквозного шифрования. Доступ определяется правами раздела.';

  @override
  String get forumSections => 'Раздел форума';

  @override
  String get forumManage => 'Разделы и права';

  @override
  String get forumEmptySections =>
      'Нет доступных форумных разделов. Администратор может создать раздел и назначить права.';

  @override
  String get forumRefresh => 'Обновить';

  @override
  String get forumNewTopic => 'Создать тему';

  @override
  String get forumTopicTitle => 'Заголовок темы';

  @override
  String get forumText => 'Сообщение';

  @override
  String get forumSend => 'Отправить';

  @override
  String get forumReply => 'Ответить';

  @override
  String get forumClosed => 'Тема закрыта. Новые ответы запрещены.';

  @override
  String get forumClose => 'Закрыть тему';

  @override
  String get forumCloseConfirm =>
      'Закрыть тему? Новые ответы станут недоступны всем участникам.';

  @override
  String get forumCancel => 'Отмена';

  @override
  String get forumBack => 'К темам';

  @override
  String get forumMore => 'Загрузить ещё';

  @override
  String get forumEmptyTopics => 'В этом разделе пока нет тем.';

  @override
  String get forumReadOnly =>
      'У вас есть право чтения. Для публикации нужно право записи в раздел.';

  @override
  String get forumInvalidText =>
      'Введите текст или прикрепите файл. Заголовок — до 320 байт UTF-8.';

  @override
  String get forumConflict =>
      'Тема изменилась. Обновите её и повторите действие.';

  @override
  String get forumDenied =>
      'Доступ отозван или раздел недоступен. Обновите форум.';

  @override
  String get forumFailure =>
      'Не удалось выполнить действие. Проверьте подключение и повторите попытку.';

  @override
  String get forumWriteUnavailable =>
      'Ответ не отправлен: тема закрыта или раздел архивирован. Обновите форум.';

  @override
  String get forumListTitle => 'Обсуждения';

  @override
  String get forumListDescription => 'Разговоры нашего сообщества';

  @override
  String get forumReplies => 'Ответы';

  @override
  String get forumAboutSection => 'Об этом разделе';

  @override
  String get forumAboutTopic => 'О теме';

  @override
  String get forumState => 'Состояние';

  @override
  String get forumOpen => 'Открыта';

  @override
  String get forumClosedLabel => 'Закрыта';

  @override
  String get forumAuthor => 'Автор';

  @override
  String get forumCreated => 'Создана';

  @override
  String get forumTopicAuthor => 'Автор темы';

  @override
  String get forumAllTopics => 'Все темы раздела';

  @override
  String get forumActions => 'Действия с темой';

  @override
  String get forumClosedHeading => 'Тема закрыта';

  @override
  String get forumClosedDescription =>
      'Новые ответы недоступны. Обсуждение можно читать.';

  @override
  String get forumPrivacyShort =>
      'Доступ определяется правами раздела. Сквозное шифрование недоступно.';

  @override
  String get forumOrder => 'По порядку';

  @override
  String get forumPin => 'Закрепить тему';

  @override
  String get forumUnpin => 'Открепить тему';

  @override
  String get forumPinned => 'Закреплено';

  @override
  String get forumUnread => 'Непрочитано';

  @override
  String get forumReadShown => 'Отметить показанное прочитанным';

  @override
  String get forumAuthorizeDevice => 'Разрешить модерацию на устройстве';

  @override
  String get forumDevicePermissionInfo =>
      'Корневая карточка вашей личности подпишет разрешение space.manage для этого устройства. Оно позволяет использовать уже назначенные права модератора, но не выдаёт роль или доступ к другим разделам. Если ключа нет на устройстве, выберите свою корневую карточку.';

  @override
  String get forumRootPassword => 'Пароль корневой карточки';

  @override
  String get forumFirstUnread => 'Первый непрочитанный ответ';

  @override
  String get forumRepliesFromStart => 'Показать ответы сначала';

  @override
  String get forumReopen => 'Открыть тему снова';

  @override
  String get forumHideTopic => 'Скрыть тему';

  @override
  String get forumRestoreTopic => 'Восстановить тему';

  @override
  String get forumHideReply => 'Скрыть ответ';

  @override
  String get forumRestoreReply => 'Восстановить ответ';

  @override
  String get forumHiddenTopic => 'Тема скрыта модератором';

  @override
  String get forumHiddenReply => 'Ответ скрыт модератором';

  @override
  String get forumReason => 'Причина действия';

  @override
  String get forumReasonRequired => 'Укажите причину, не более 1024 байт';

  @override
  String get forumModerationNotice =>
      'Скрытое содержимое и его файлы недоступны до восстановления. Причина сохраняется в журнале модерации.';

  @override
  String get forumModerationLog => 'Журнал модерации';

  @override
  String get forumModerationEmpty => 'Действий модерации пока нет';

  @override
  String get forumApply => 'Подтвердить';

  @override
  String get forumReport => 'Пожаловаться';

  @override
  String get forumReportNotice =>
      'Опишите нарушение. Жалоба доступна модераторам; данные заявителя не показываются. Повторная жалоба на этот объект не создаётся.';

  @override
  String get forumReportsQueue => 'Очередь жалоб';

  @override
  String get forumReportsPending => 'Ожидают';

  @override
  String get forumReportsResolved => 'Решения';

  @override
  String get forumReportsEmpty => 'Жалоб пока нет';

  @override
  String get forumReportDismiss => 'Отклонить жалобу';

  @override
  String get forumReportHide => 'Скрыть содержимое';

  @override
  String get forumReportDecisionNotice =>
      'Укажите причину решения. Решение и причина сохранятся в журнале модерации.';

  @override
  String get forumReportOpen => 'Открыть обсуждение';

  @override
  String get forumReportTopic => 'Жалоба на тему';

  @override
  String get forumReportReply => 'Жалоба на ответ';

  @override
  String get feedPrivacy =>
      'Публикации доступны серверу. Сквозное шифрование не используется.';

  @override
  String get feedSections => 'Разделы ленты';

  @override
  String get feedPolicy => 'Права публикации и комментариев';

  @override
  String get feedEmptySections => 'Доступных разделов ленты пока нет.';

  @override
  String get feedEmpty => 'Публикаций пока нет.';

  @override
  String get feedOpenUnread => 'Открыть непрочитанное';

  @override
  String get feedReadOnly => 'У вас нет права публиковать в этом разделе.';

  @override
  String get feedBack => 'К публикациям';

  @override
  String get feedComments => 'Комментарии';

  @override
  String get feedHiddenPost => 'Публикация скрыта модератором.';

  @override
  String get feedHiddenComment => 'Комментарий скрыт модератором.';

  @override
  String get feedRestoreComment => 'Восстановить комментарий';

  @override
  String get feedRestorePost => 'Восстановить публикацию';

  @override
  String get feedSendFailed =>
      'Не удалось отправить. Текст и файлы сохранены. Проверьте права и подключение и повторите попытку.';

  @override
  String get feedPublishPermission => 'Публиковать записи';

  @override
  String get feedCommentPermission => 'Оставлять комментарии';

  @override
  String get feedPolicyHelp =>
      'Публикация и комментирование разрешаются отдельно. Без правила оба действия запрещены. Правило участника заменяет правило роли. Читатель может комментировать по явному разрешению, но не публиковать.';

  @override
  String get feedPrincipal =>
      'Идентификатор участника — необязательно; иначе применяется роль';

  @override
  String get feedRole => 'Роль';

  @override
  String get feedAddRule => 'Добавить правило';

  @override
  String get feedRemoveRule => 'Удалить правило';

  @override
  String get feedPost => 'Публикация';

  @override
  String get feedComment => 'Комментарий';

  @override
  String get feedOpenPost => 'Открыть публикацию';

  @override
  String get feedUpdateRuntime =>
      'Сервер ещё не поддерживает ленту. Обновите сервер через «Эфир».';

  @override
  String get feedConnectFirst =>
      'Подключитесь к пространству, чтобы открыть ленту.';

  @override
  String get feedConflict =>
      'Публикация или права изменились. Обновите данные и повторите действие.';

  @override
  String get feedDenied =>
      'Доступ отозван или раздел недоступен. Обновите ленту.';

  @override
  String get feedWriteUnavailable =>
      'Действие недоступно: публикация скрыта или раздел архивирован. Обновите ленту.';

  @override
  String get feedInvalidText =>
      'Введите текст до 8192 байт UTF-8 или прикрепите файл.';

  @override
  String get feedActions => 'Действия';

  @override
  String get feedMemberRole => 'Участники';

  @override
  String get feedReaderRole => 'Читатели';

  @override
  String get communitySearchHint => 'Поиск в разделе';

  @override
  String get communitySearchEmpty => 'Совпадений нет';

  @override
  String get communitySearchInvalid => 'Введите текст от 1 до 256 байт UTF-8';

  @override
  String get communitySearchThread => 'Тема';

  @override
  String get communitySearchReply => 'Ответ';

  @override
  String get communitySearchPost => 'Публикация';

  @override
  String get communitySearchComment => 'Комментарий';

  @override
  String get communitySearchRevoked => 'Раздел больше недоступен';

  @override
  String get dashboardAttention => 'Требует внимания';

  @override
  String get dashboardAttentionEmpty => 'Всё спокойно — новых задач нет.';

  @override
  String get dashboardChecking => 'Проверяем обновления…';

  @override
  String get dashboardAttentionLimit =>
      'Показаны ближайшие задачи. Остальные доступны внутри пространств.';

  @override
  String get dashboardConnectionIssue => 'Проблема подключения';

  @override
  String get dashboardPendingReports => 'Жалобы на рассмотрении';

  @override
  String get dashboardRepliesToYou => 'Ответы в вашей теме';

  @override
  String get dashboardCommunityNews => 'Новое в сообществах';

  @override
  String get dashboardCommunityDescription =>
      'Свежие темы и публикации из доступных вам разделов. Счётчики показывают непрочитанное там, где сервер поддерживает отметки чтения.';

  @override
  String get dashboardCommunityFailed =>
      'Не удалось обновить часть разделов. Повторите попытку.';

  @override
  String get dashboardCommunityUnsupported =>
      'Для сводки сообществ обновите сервер.';

  @override
  String get dashboardCommunityEmpty => 'Пока нет доступных тем и публикаций.';

  @override
  String get dashboardAttentionUnknown => 'Часть разделов пока не проверена.';

  @override
  String get dashboardAttachmentPost => 'Публикация с вложениями';

  @override
  String get dashboardCommunityOffline =>
      'Данные недоступных пространств появятся после подключения.';

  @override
  String get communityMention => 'Упомянуть участника';

  @override
  String get communityMentionQuery => 'Имя или ID участника';

  @override
  String get communityMentionFailed =>
      'Не удалось получить участников. Проверьте доступ и повторите поиск.';

  @override
  String get communityMentionEmpty => 'Участники не найдены';

  @override
  String get dashboardMention => 'Вас упомянули';

  @override
  String get dashboardFeedRepliesToYou => 'Ответы на вашу публикацию';

  @override
  String get appearanceTheme => 'Тема';

  @override
  String get appearanceThemeSystem => 'Автоматическая';

  @override
  String get appearanceThemeLight => 'Светлая';

  @override
  String get appearanceThemeDark => 'Тёмная';

  @override
  String get notificationSection => 'Раздел';

  @override
  String get notificationInboxEmpty => 'Непросмотренных уведомлений нет';

  @override
  String get notificationInboxFailed =>
      'Не удалось обновить уведомления. Проверьте подключение и доступ.';

  @override
  String get notificationMarkRead => 'Отметить просмотренным';

  @override
  String get notificationRefresh => 'Обновить уведомления';

  @override
  String get notificationPrevious => 'Предыдущая страница';

  @override
  String get notificationNext => 'Следующая страница';

  @override
  String get notificationUnavailable => 'Нет доступных разделов';

  @override
  String get notificationReply => 'Ответ вам';

  @override
  String get notificationOpen => 'Открыть';

  @override
  String get mlsMentionsLegacy =>
      'Не все устройства подтвердили поддержку упоминаний. Отправится только имя без отметки обращения.';

  @override
  String get mlsCancelRetry =>
      'Отменить отложенные отправки после смены состава';

  @override
  String get profileAvatar => 'Аватар в пространстве';

  @override
  String get chooseAvatar => 'Выбрать изображение';

  @override
  String get removeAvatar => 'Удалить аватар';

  @override
  String get avatarInvalid =>
      'Выберите статичный PNG или JPEG до 5 МиБ и 4 миллионов пикселей.';

  @override
  String get profileConflict =>
      'Профиль изменён на другом устройстве. Обновите его и повторите сохранение; ваш ввод сохранён.';

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String get saveProfile => 'Сохранить профиль';

  @override
  String get profileSpaceHelp =>
      'Имя уникально в этом пространстве. Имя и аватар общие для всех его разделов.';

  @override
  String get communityReactionsRetry => 'Повторить запрос';

  @override
  String get communityReactionsFailure => 'Не удалось обновить реакции.';

  @override
  String get communityReactionsConflict =>
      'Реакции изменились. Проверьте выбор и повторите действие.';

  @override
  String get communityReactionsDenied =>
      'Реакции недоступны: доступ или состояние раздела изменились.';
}
