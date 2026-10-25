# Проверка SDK: GHSA-frr6-h895-5pxp

Проверено 25 октября 2026 по [официальному advisory Dart](https://github.com/dart-lang/sdk/security/advisories/GHSA-frr6-h895-5pxp).
Проблема связана с компрометацией промежуточных сертификатов eMudhra и
проверкой TLS в `dart:io`. Исправленные стабильные версии — Dart 3.13.7
и Flutter 3.47.8. Для приложений, собранных прежним SDK, требуется пересборка
и распространение новых двоичных файлов; обновления SDK на компьютере
разработчика недостаточно для уже установленных старых приложений.

В текущем окружении уже установлены Flutter 3.47.8 stable и входящий в него
Dart 3.13.7. Локальный Flutter HEAD и удалённая ветка stable совпадают:
`737ba8f885dc774b53b442759999a312c9461e4e`. Рабочее дерево SDK чистое.
Официальный указатель Dart stable/latest также возвращает 3.13.7.
Переустановка того же SDK и переход на beta не нужны.

Требования client и собственных пакетов уже задают Dart >=3.13.7;
Flutter клиента — >=3.47.8. Все Flutter-задачи CI приложения и сервера
закреплены на 3.47.8 stable. Проверка локальных изменений и новые сборки
выполняются этими исправленными SDK.

Источники: [Flutter 3.47.8](https://github.com/flutter/flutter/releases/tag/3.47.8),
[Dart stable/latest](https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION).
