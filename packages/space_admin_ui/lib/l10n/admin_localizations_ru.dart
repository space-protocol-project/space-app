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
  String get managementIntro =>
      'Ваш сервер. Ваши правила. Владелец домашнего сервера назначается локальным кодом настройки.';

  @override
  String get managementSections =>
      'Настройки, каналы, участники, приглашения и устройства выбранного сервера.';

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
      'Вы явно разрешаете этому устройству менять настройки, каналы и доступ участников.';

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
  String get bothNames => 'Укажите оба названия';

  @override
  String get settingsConflict =>
      'Настройки уже изменены. Загрузите их заново и повторите изменения.';

  @override
  String settingsRevision(String revision) {
    return 'Настройки пространства · версия $revision';
  }
}
