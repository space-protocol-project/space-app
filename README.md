# Space App

Общее Flutter-приложение Space: общение и управление независимыми серверами в одном интерфейсе.

- [Установщики и релизы](https://github.com/space-protocol-project/space-app/releases).
- [Руководство приложения](docs/APPLICATION-GUIDE.md).
- [Домашний сервер — «Выйти в эфир»](docs/HOME-SERVER.md).
- [Управление сервером](docs/ADMIN-GUIDE.md).
- [Сервер и runtime](https://github.com/space-protocol-project/space-server).
- [Протокол, архитектура и промосайт](https://github.com/space-protocol-project/space-protocol).

## Возможности

Чат, автоматическое обновление каналов и прав, непрочитанные сообщения, настройки, каналы/ACL, участники, приглашения, устройства, recovery-карточки и сопряжение. Начальная локализация: русский, упрощённый китайский и английский; часть экранов ещё русскоязычная.

«Выйти в эфир» устанавливает проверенный runtime из `space-server`, создаёт собственную PostgreSQL и сертификат для статического IPv4, назначает владельца локально и открывает управление в этом же приложении. После запуска кнопка становится «Отключиться». Повторный запуск использует тот же сервер и данные. Для друзей нужен проброс TCP 8443 и разрешение брандмауэра.

## Разработка

Flutter 3.47.6 / Dart 3.13.5. Из каталога `client`:

```powershell
flutter pub get
flutter run -d windows
flutter analyze --no-pub
flutter test --no-pub
```

Общие пакеты находятся в `packages/`. Исходники сервера здесь не дублируются. Протокол лежит в `space-protocol`; сгенерированные Dart bindings сохраняются в `client/lib/src/generated`. Из корня этого репозитория генерация: `buf generate ../space-protocol/protocol/proto --template client/buf.gen.yaml`.

## Публикация

Тег `vX.Y.Z` запускает проверки и сборку Windows Setup, macOS DMG и Linux RUN. CI публикует выпуск только после успешных сборок и проверок; описание берётся из одноимённого раздела [Changelog.md](Changelog.md), вместе с установщиками публикуется SHA-256. [Подробности](packaging/README.md).

Windows — первая проверенная платформа. macOS/Linux требуют ручной проверки установки, защищённого хранилища и восстановления; DMG пока без подписи Apple и notarization. Реальное подключение друзей из интернета проверяется отдельно от runner.
