# Совместимый выпуск общего поиска и социальной ленты

Приложение [v0.7.28+58](https://github.com/space-protocol-project/space-app/releases/tag/v0.7.28)
и runtime [v0.7.22](https://github.com/space-protocol-project/space-server/releases/tag/v0.7.22)
опубликованы 26 октября 2026 года. Оба выпуска Latest, не draft и не prerelease.
Схема PostgreSQL 40, голосовой профиль 3. Каталог runtime закреплён в клиенте;
публичные установщики, контрольные суммы и совместимость обновления Android проверены.

## Возможности

- Общий поиск обычных чатов, тем и ответов форума, публикаций и комментариев
  ленты: раздел, тип результата, страницы и переход к точному объекту.
  Сервер повторно проверяет права на каждой странице. MLS остаётся
  в существующем локальном поиске; зашифрованный текст на сервер не отправляется.
- Ответы на конкретные комментарии ленты, переход к адресату на другой
  странице и отмена выбора без потери черновика.
- Репост без текста либо цитата со своим текстом и вложениями внутри раздела.
  Сервер хранит ссылку и заново загружает оригинал при чтении. Скрытый оригинал
  не раскрывает автора, текст или файлы; цепочки вложенных репостов не создаются.
- Форма новой публикации над хронологической лентой, компактные карточки.
  Подписки и персональная лента остаются следующим отдельным срезом.

Требуются `core.space.search.v1` и `core.feed.social.v1`. Обновляйте приложение
и сервер вместе. Миграция 39→40 сохраняет идентичность, историю, профили,
права и отметки чтения. Перед обновлением сохраните резервную копию пространства
и ключей MLS; возврат к схеме 39 требует восстановления совместимой копии.

## Проверки

Все сборки и тесты выполняются в GitHub CI. Локальные сборки остановлены
после сбоя E:; исходники находятся на C: и в GitHub. Android на устройстве
и эмуляторе не запускается. Крупные установщики и архивы скачиваются для
проверки только на GitHub runners.

Сборки закрепляют Flutter 3.47.8 с Dart 3.13.7 и Go 1.27.3. Эти версии
включают актуальные исправления TLS: [Dart/Flutter](https://github.com/dart-lang/sdk/security/advisories/GHSA-frr6-h895-5pxp),
[Go](https://go.dev/doc/devel/release#go1.27.3). PostgreSQL остаётся на поддерживаемой
ветке 17.11; смена основной версии базы требует отдельного переноса данных.

- [Серверные проверки реализации](https://github.com/space-protocol-project/space-server/actions/runs/40362736839): Go, гонки, vet, модули и уязвимости; 1006 Flutter-тестов прошли, 42 пропущены.
- [Целевой клиентский прогон](https://github.com/space-protocol-project/space-app/actions/runs/40364312357): анализ без замечаний и 53 теста, включая переход к адресату на другой странице и запрет неподдерживаемой структурированной ссылки.
- [Проверки платформ](https://github.com/space-protocol-project/space-app/actions/runs/40362798109): Windows/macOS/Linux/Android, настоящий чат с PostgreSQL, нативные поиск и социальная лента Linux с горячим перезапуском.
- [Релизный CI runtime v0.7.22](https://github.com/space-protocol-project/space-server/actions/runs/40371335438) прошёл: три платформы, PostgreSQL, TLS, обновление, перенос, восстановление MLS и полный серверный набор. Анализ клиента без замечаний; 1008 тестов прошли, 42 пропущены.
- [Проверка публичного runtime](https://github.com/space-protocol-project/space-app/actions/runs/40375005424) прошла: полное скачивание трёх архивов и дескрипторов, размеры, SHA-256, CRC и схема 40 во всех runtime-info.json.
- [Установка опубликованного runtime на трёх ОС](https://github.com/space-protocol-project/space-app/actions/runs/40375088511) и [опубликованный Linux-установщик](https://github.com/space-protocol-project/space-server/actions/runs/40375012094) прошли: настоящий публичный комплект, установка, запуск и штатный перезапуск.
- [Релизный CI приложения v0.7.28](https://github.com/space-protocol-project/space-app/actions/runs/40375158499) успешен: Windows, macOS, Linux, подписанный Android APK, нативный и отрицательные сценарии MLS, чат с двумя клиентами и PostgreSQL, Go/Flutter, обновление Windows и системные нажатия macOS/Linux. 1008 тестов Flutter прошли, 42 пропущены. Нативные общий поиск и социальная лента Linux прошли ввод, выбор цели, отправку и горячий перезапуск без ошибок выполнения.
- [Проверка публичной совместимой пары](https://github.com/space-protocol-project/space-app/actions/runs/40381975116) прошла: полное скачивание четырёх установщиков, трёх архивов runtime, дескрипторов и файлов SHA256SUMS. Размеры, SHA-256 и CRC совпали; во всех runtime-info.json схема 40. Встроенный каталог APK точно совпал с опубликованными дескрипторами runtime v0.7.22.

Android: package `org.spaceprotocol.space_client`, minSdk 24, versionName 0.7.28,
versionCode 58 > 57; 36 ELF-библиотек в трёх ABI. Подпись совпала с v0.7.27:
`75d792704929d0135d2120d07fa6b557f94532bf0f2581857d770b908be7bda3`.

Неизменяемые исходники выпусков:

- Приложение: `3f0b73cea19c3232b7a4124cdcebd6f6372613c2`.
- Runtime: `9960a3aa66a25dcb037b316f677bb981c23683f0`.

Подробности реализации: [общий поиск](SPACE-SEARCH.md),
[социальная лента](FEED-SOCIAL.md), [ADR-057](https://github.com/space-protocol-project/space-protocol/blob/main/docs/adr/057-space-search.md),
[ADR-058](https://github.com/space-protocol-project/space-protocol/blob/main/docs/adr/058-feed-social.md).

## Опубликованные файлы

| Файл | Байт | SHA-256 |
| --- | ---: | --- |
| Space-home-windows-x64.zip | 76087893 | 966ff6e6dcb5a57d25935be4d8b55b79d78b7f690385eac239b3b1164b484367 |
| Space-home-linux-x64.zip | 31572318 | 22f9768ee6fd587333dd591cdb975c16cb7d7bca0cd82d3ca29a42d374a35492 |
| Space-home-macos-arm64.zip | 29214576 | 2ef3b91c1ddeaad5e40243cd678dd08684115cf8b940a972d115b9302fe2a9d8 |
| Space-Setup-windows-x64.exe | 34391161 | 9b8d14b8db9f44ef13e132409889b12403fec48554ab82a4ce1088fd5b2d3c27 |
| Space-macos-arm64.dmg | 84994007 | e05c23983cef021782168b5c5ea2c2f829c691cdf0c3685c74080aa59e13c9df |
| Space-linux-x64.run | 43490595 | 642ed6cb724276075c42b5f65343305c7da04ce7dac90b27f5d3a8123ae91faa |
| Space-android.apk | 210617484 | d52cbc0658fd54376babe87d14c88cdddb9d94fd24ac595ae0dc688712673fd5 |
