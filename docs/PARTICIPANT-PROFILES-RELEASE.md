# Совместимый выпуск профиля участника

Runtime [v0.7.20](https://github.com/space-protocol-project/space-server/releases/tag/v0.7.20) опубликован.
Приложение [v0.7.26+56](https://github.com/space-protocol-project/space-app/releases/tag/v0.7.26) опубликовано. Оба выпуска Latest, без draft и prerelease. Схема PostgreSQL 37,
голосовой профиль 3. Профиль пространства: уникальное Unicode-имя и аватар,
без переопределений по разделам. Настройки телефона доступны в нижней панели;
выбор темы расположен в настройках.

Прежний UpdateProfile и клиентские getNickname/setNickname удалены без адаптера.
Для профиля нужен core.member.profile.v1. Обновляйте приложение и сервер вместе.
Перед обновлением сохраните копию пространства и ключей MLS; откат схемы 37
требует восстановления совместимой копии. Идентичность, история и права
сохраняются миграцией 36→37.

Локальная приёмка реализации: 938 Flutter-тестов прошли, 40 пропущены; анализ
клиента и space_admin_ui чистый, COG максимум 14. Полные Go-тесты и -race
с отдельной PostgreSQL, vet/mod verify/govulncheck прошли. Проверены настоящий
Dart/Connect, два разрешения устройства одной личности, конфликты ревизий,
Unicode-уникальность, сохранение истории, перезапуск и удаление аватара.
Windows release и Android debug собраны; нативный редактор Windows прошёл
hot restart без ошибок выполнения. [Подробности](PARTICIPANT-PROFILES.md).

Android на устройстве и эмуляторе не запускался. Физическая приёмка,
системные уведомления при закрытом процессе и ранее открытые аппаратные
проверки не входят в подтверждённые результаты этого выпуска.

Flutter 3.47.8 / Dart 3.13.7 и Go 1.27.3 сверены со стабильными выпусками.
Совместимая зависимость posix обновлена до 6.5.3. Более новые http2/xml
ограничены родительскими пакетами, material_color_utilities/test_api закреплены
стабильным Flutter SDK; принудительные overrides не добавлены.

[Релизный CI runtime](https://github.com/space-protocol-project/space-server/actions/runs/40240064496)
успешен: три платформы, полный Go/Flutter, -race, TLS, перенос, обновление,
восстановление MLS и нативное хранилище Windows.
[Публичный Linux-установщик](https://github.com/space-protocol-project/space-server/actions/runs/40241953005)
проверен успешно. Три архива, три дескриптора и SHA256SUMS скачаны полностью;
размеры, SHA-256 и CRC совпали, внутри каждого архива подтверждена схема 37.
Бинарник из опубликованного Windows-архива прошёл настоящий Dart/Connect-сценарий
профиля: уникальность, два устройства, ревизии, перезапуск, история и удаление
аватара; отдельная PostgreSQL штатно остановлена.

Исходники runtime: b8b3bd18ee096a1789fbe3c29e59b46ed9c8fe86.
Исходники тега приложения: 93d45898d2191a89e6e72498be8bf3cf701ccb8c.
[Релизный CI приложения](https://github.com/space-protocol-project/space-app/actions/runs/40241984339).
Релизный CI приложения успешен целиком. Все четыре установщика и SHA256SUMS скачаны полностью; размеры и SHA-256 совпали с GitHub и файлом контрольных сумм, CRC APK корректны. Подпись APK совпадает с v0.7.25; package ID org.spaceprotocol.space_client, versionCode 56 > 55, minSdk 24. Три ABI, все 36 ELF-библиотек и встроенный каталог runtime v0.7.20 проверены.


## Проверенные архивы runtime

| Файл | Размер, байт | SHA-256 |
|---|---:|---|
| `Space-home-windows-x64.zip` | 75956668 | `bf1befaf3fcbc623a85260e19350b8aa75aa2921edeb42e817b4ce30298ae5a0` |
| `Space-home-linux-x64.zip` | 31443322 | `5f773e1de8ba812c35984ac3b71d03a9f1034238db21793eebe6f2396c05e4fe` |
| `Space-home-macos-arm64.zip` | 29075866 | `649d28b7d0c7082835366d644f68b0e25a784f63afbef859c194fd58b60392d0` |

OpenAPI: исправлена генерация RPC-путей через `generate_unbound_methods=true`;
проверены новые операции профиля и отсутствие UpdateProfile.
[CI контракта](https://github.com/space-protocol-project/space-protocol/actions/runs/40243242999)
успешен, buf lint прошёл; проверки не ослаблены.

## Проверенные установщики приложения

| Файл | Размер, байт | SHA-256 |
|---|---:|---|
| `Space-Setup-windows-x64.exe` | 34342267 | `7acd7105de8a9790eb2db90deab14cadd3c882da1786c1857cb9a06687e24ca5` |
| `Space-macos-arm64.dmg` | 84084208 | `2470cbe2c0b34dd9ddc6a3b549a3ff155de9cc72eaf6881334d3c5bf3ea773c4` |
| `Space-linux-x64.run` | 43422997 | `6f0d4dacbb73284acf122ce99d0c5ecf3c8865c656481baadb3e0db6497f7f98` |
| `Space-android.apk` | 210108952 | `4292eb960369517f8fbec5a92647cf9c92a7f6b77837daf8637ec3990b4c0da5` |

Сертификат APK (SHA-256): `75d792704929d0135d2120d07fa6b557f94532bf0f2581857d770b908be7bda3`.
