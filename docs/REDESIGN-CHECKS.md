# Реестр переноса Quiet Space

Дата: 14 октября 2026. База: приложение v0.2.5, 249 тестов прошли, четыре штатно
пропущены; анализ Flutter без замечаний. Незавершённый пользовательский файл
`docs/assets/guides/space-bubble-design.png` не входит в изменения оформления.
Исходные формы сняты из отдельного снимка Git, до изменений темы, в размере
1440×1000. Живой прототип открыт по http://127.0.0.1:8790/; его данные демонстрационные.

## Действия и условия

«Сохранено» означает, что действие остаётся связано с прежним обработчиком.
Проверка конкретного сценария выполняется на соответствующем этапе; наличие
кнопки не заменяет проверку операции. Административные формы остаются общими.

| ID | Действие / прежняя точка входа | Условие и операция | Новая точка входа / проверка |
|---|---|---|---|
| S01 | Добавить пространство, панель слева | `SpaceShell.addSpace`, новый клиент | Панель пространств и сводка; mobile_client_test |
| S02 | Проверить ссылку | `ChatInspected`, HTTPS/локальный HTTP, TLS | ConnectionPanel; core_test, connection_chat_localization_test |
| S03 | QR камерой | камера, разрешение ОС, readQr | Та же форма; space_qr_platform_test, физическая камера отдельно |
| S04 | QR изображением | PNG/JPEG, проверка ссылки | Та же форма; space_qr_platform_test |
| S05 | Вход по приглашению | preview и явное доверие, ChatConnected | Та же форма; invitation/core и home_server_drill |
| S06 | Повторный вход / переподключение | сохранённые ключи, прежний vault | Панель пространств, состояние заголовка; reconnect/offline тесты |
| S07 | Открыть / переключить пространство | workspaces, отдельная сессия | Панель пространств; server_workspaces/shell тесты |
| S08 | Список серверов и их доступность | presence, unknown не равен online | Сводка и ServerInbox; server_presence/server_presence_ui |
| S09 | Удалить из клиента | подтверждение, preferences.forget | ServerInbox; удаляется профиль клиента, не сервер |
| S10 | Выбрать канал / обновить каталог | ChatChannelSelected, ACL/архив | Боковая панель и мобильный выбор; channels_test |
| S11 | Форум, лента, комнаты | существующие информационные экраны, полноценного API нет | Сохраняются маршруты Section и честное состояние |
| C01 | Прочитать историю / новые сообщения | canRead, подписка и курсор | ChatView; chat_controller/events/offline tests |
| C02 | Отправить сообщение | canWrite, busy, лимит 1024 | Плавающее поле, ChatMessageSent; composer_markdown_test |
| C03 | Enter / Shift+Enter / IME | пользовательская настройка, composing | То же поле; composer_markdown_test и IME ручная проверка |
| C04 | Черновик отдельного канала | draftScope, drafts | То же состояние ChatView; shell/channel tests |
| C05 | Прокрутка и восстановление позиции | offsets, scope, активный экран | История под полем; unread_test |
| C06 | Отметить прочитанным | только полностью видимые строки, foreground, ACL | Вычет перекрытия поля и панелей; unread_test |
| C07 | Перейти к непрочитанному | unreadCount, jumpToNew | Кнопка у плавающего поля; unread_test |
| C08 | Перейти к сообщению | jumpToMessage, позиция и канал | Поиск и маркеры; favorite_messages_test |
| C09 | Markdown, ссылки, выделение / копирование | существующий MessageMarkdown | Те же строки; composer_markdown_test |
| C10 | Подтверждение / ошибка отправки | MessageSendStatus, сообщение не теряется | Статус рядом с полем; message_delivery тесты |
| F01 | Добавить / удалить избранное | ChatFavoriteToggled, реальная запись | Закладка сообщения; favorite_messages_test |
| F02 | Маркер и предпросмотр | избранные текущего канала, авторство | Левый край, hover/focus/long press; favorite_messages_test |
| F03 | Открыть / удалить из карточки | переход и удаление разделены | Карточка маркера; mouse/keyboard tests |
| F04 | Отдельный экран сохранённого | новый экран на реальных закладках; в прежнем интерфейсе отсутствовал | Ctrl+K, фильтр избранного; search_test |
| F05 | Поиск / результат / фильтр | доступная история, исходный канал | Кнопка поиска и Ctrl+K/Meta+K; search_test |
| A01 | Настройки пространства, названия, регистрация | administration, expectedRevision | прежняя административная страница; admin_settings_test |
| A02 | Значок сервера: выбрать / убрать | server icon validation, системный файл | прежняя форма; server_icon_test |
| A03 | Предложение оформления сервером | В текущем Flutter-клиенте не реализовано | Не выдавать демо прототипа за рабочую функцию |
| A04 | Каналы: список / выбор / создание | management, версии и загрузка | ChannelsPanel; admin_channels_panel_test |
| A05 | Канал: имя / порядок / архивирование | saveChannel, expectedRevision | та же форма; admin_channels_panel_test |
| A06 | Канал: удалить / подтвердить | deleteChannel, управление | та же форма; admin_channels_panel_test |
| A07 | Права канала: читать / писать / управлять | saveAccess, principal и конфликт | та же форма; admin_channels_panel_test |
| A08 | Участники: загрузка / поиск / следующая страница | members pagination | MembersPanel; admin_people_invites_test |
| A09 | Участник: роль / блокировка / конфликт | save, ACL, expectedRevision | та же форма; admin_people_invites_test |
| A10 | Приглашения: список / пагинация | invites pagination | InvitesPanel; admin_people_invites_test |
| A11 | Создать приглашение: роль / срок / число использований | create, валидация | та же форма; admin_people_invites_test |
| A12 | Скопировать / отозвать приглашение | clipboard / revoke с подтверждением | та же форма; admin_people_invites_test |
| A13 | Устройства: список / отзыв | проверка прав, текущий grant | DevicesPanel; admin_devices_panel_test |
| I01 | Мои устройства / выбрать идентичность | workspaces, текущий профиль | Панель пространств и мобильная навигация; device_panel_test |
| I02 | QR / JSON карточка, пароль, сохранение | recoveryPayload, локальное шифрование | RecoveryPanel; recovery_test, recovery_qr_test |
| I03 | Восстановить карточку: файл / камера | пароль, trust, новая запись устройства | та же форма; recovery_operation/localization tests |
| I04 | Заменить идентичность: подтверждение | защищённый vault, отдельный профиль | тот же диалог; recovery_dialog_localization_test |
| I05 | Ротация root: начать / завершить / обновить | журнал, подписи, receipt | та же форма; root_rotation_test и home_transfer_drill |
| I06 | Сопряжение: начать / код / опрос / отмена | PairingPanel и существующий API | та же форма; pairing tests |
| I07 | Сопряжение: проверить / подготовить / подписать | root/recovery authority, сравнение кода | RecoveryPanel; pairing tests |
| I08 | Отозвать устройство / карточку / текущий вход | условия grant и подтверждение | прежние формы; recovery/admin_devices tests |
| H01 | Создать своё пространство / настройка | только поддерживаемый desktop | Сводка и панель сервера; space_setup/home_server tests |
| H02 | Обнаружить / указать IP | публичный IPv4, ошибки сети | HomePanel; home_server_test |
| H03 | Установить / запустить / остановить | runtime, lock, владелец, progress | HomePanel; home_server_drill |
| H04 | Ссылка, QR, копирование | текущий endpoint и TLS pin | HomePanel; home_localization_test |
| H05 | Управление созданным сервером | подключённый владелец | прежняя административная страница |
| H06 | Экспорт / импорт / новый IP | новый каталог, остановка, проверка архива | HomePanel; home_transfer_test и home_transfer_drill |
| H07 | Обновить / продолжить / восстановить runtime | journal, SHA-256, backups | HomePanel; home_update_executor/journal tests |
| H08 | Диагностика / скопировать сведения / руководство | безопасные сведения без секретов | HomePanel; local_failure/home_localization tests |
| P01 | Светлая / тёмная тема, Gruvbox/Ocean/Iris | PreferencesChanged, сохранение выбора | Личные настройки; shell/localization tests |
| P02 | RU/EN/中文 | PreferencesChanged, локализация | Личные настройки; localization tests |
| P03 | Режим отправки | PreferencesChanged | Личные настройки; composer_markdown_test |
| P04 | Обновление клиента: проверка / загрузка / установка | digest, installedCopy, prepareInstall | AppUpdatesView; app_updates_test, installer CI |
| P05 | Возобновление домашнего сервера после обновления | сохранённая отметка и предложение | прежний диалог; app_updates_test |
| P06 | Размер и положение окна | DesktopWindowState, отдельные настройки | без изменений; desktop_window_test |
| P07 | Ограничения Android/iOS | platform_capabilities, домашний сервер отключён | mobile_client_test, space_qr_platform_test |
| P08 | Доступность: Back / Escape / фокус / крупный текст | стандартные маршруты и Shortcuts | Shell, поиск, панели; shell и новые redesign tests |

## Вложения и новые возможности

В Content API передаётся текст; полноценного транспорта вложений, реакций,
голоса и push нет. Редизайн не добавляет фиктивную отправку файла, реакцию или
медиа-сессию. Системный выбор QR, карточек, значков и архивов сохраняется.
Передача вложений требует отдельного серверного контракта и не блокирует оформление.

## Журнал проверки этапов

- База: анализ без замечаний, 249 тестов успешны, 4 штатно пропущены.
- Тема, каркас, стеклянный заголовок, плавающее поле, маркеры избранного и точный поиск перенесены. Настройка эффектов сохраняется через PreferencesChanged.
- Полный набор: 261 успешный тест, 4 штатно пропущены. flutter analyze без замечаний. Golden-снимки переписки — 390×844 и 1280×800 в обеих темах; также проверена компоновка 768×1024 и 1667×1267.
- После последних изменений выполнены hot restart и hot reload Windows-приложения, ошибок исполнения нет. Windows Release собирается успешно; визуальная проверка именно Release и измерение производительности ещё не выполнены.
- Проверка treesitter_cyclomatic_complexity: максимальная когнитивная сложность production-функций приложения 15. Переход к сообщению разделён на поиск строки и размещение цели между перекрывающими поверхностями.
- Промежуточные кадры боковой панели проверены widget-тестом: ограниченная область начинается после полосы пространств, скрытая панель не перехватывает нажатия.
- В обновлённом плане отдельно учтены стеклянный заголовок и обрезка панели; итоговая приёмка всех этапов остаётся открытой.
- Ещё нужны: Windows 100/125/150% на реальном экране, проверка IME/камеры/Android, profile/release оценка прокрутки и полная визуальная приёмка дополнительных административных экранов.
- Физическая камера, IME и Android-устройство требуют отдельной ручной приёмки.
