# Space: Flutter-клиент для Windows

Первый нативный клиент локального прототипа. Flutter 3.47.6 / Dart 3.13.5; Windows — первая проверенная платформа. Android и Flutter Web ещё не добавлены.

![Экран подключения](docs/preview.png)

Изображение получено из Flutter-рендера начального экрана, без вымышленных сообщений или подключения.

## Что работает

- Подключение по локальному origin, например `http://127.0.0.1:8080`.
- Discovery по HTTP без redirect, проверка версии/ключа/адреса gRPC, затем manifest через gRPC.
- Подтверждение первого доверия; сохранение `origin + server ID + public key`. Изменение identity блокирует подключение.
- Независимые root/device Ed25519-ключи для сервера, проверка challenge перед подписью.
- Root-authorized registration, device login и root-authorized revoke.
- Текстовый чат, страницы истории, polling durable events каждые две секунды, дедупликация.
- Повтор неудачной отправки с тем же текстом использует прежний idempotency key в рамках процесса.
- Вход с сохранённым grant после перезапуска; токен только в памяти. Перед expiry выполняется новый device login, без refresh token.

## Запуск

Запустите [Go-сервер](../server/README.md) с PostgreSQL. HTTP по умолчанию `127.0.0.1:8080`, gRPC — `127.0.0.1:9090`. Флаги `-http` и `-grpc` изменяют порты. Discovery объявляет фактический gRPC endpoint; клиент не угадывает порт.

Из каталога `client`:

```powershell
flutter pub get
flutter run -d windows
```

Введите адрес → «Проверить сервер» → проверьте origin и отпечаток → «Доверять и подключиться». Отпечаток полезно сравнить с известным серверным ключом. На первом визите действует локальная TOFU-модель; сам отпечаток не доказывает владельца сервера.

Go `-demo` не предоставляет настоящую identity/auth, поэтому этот Flutter-клиент его не принимает. Без локального Docker серверные интеграционные проверки выполняются в CI; приложение можно собрать независимо от базы.

## Архитектура

```text
app.dart → ChatController → SpaceSession → generated Dart gRPC clients
                               ↓
                         IdentityVault
                               ↓
                      SecureIdentityVault
```

`core.dart` содержит протокольную логику без Flutter UI. Discovery — HTTP, application API — нативный gRPC. `generated/` получен из общего `.proto`. `chat_controller.dart` управляет подключением, событиями и повтором отправки. `secure_vault.dart` — адаптер платформенного хранилища.

Windows-ключи сохраняются через `flutter_secure_storage`, одним защищённым record на origin; trust pin хранится вместе с ними. Private keys не пишутся в обычные файлы/логи, небезопасного fallback нет. Это программные Ed25519-ключи; аппаратная изоляция/passkeys не заявляются. Native backend входит в Windows-сборку; автоматическая сквозная проверка Windows vault на реальном устройстве ещё требуется.

Профиль генерирует случайные server roots. Master recovery seed, HKDF derivation и recovery card ещё не реализованы. Потеря vault означает потерю этих ключей. Отозванный grant не заменяется автоматически. Хранилище не следует удалять для обхода отзыва.

## Проверки и генерация

```powershell
flutter analyze
flutter test
flutter build windows --release
```

Проверены широкий/узкий интерфейс, запрет отправки до подключения, ограничения URL, trust conflict и отказ подписывать challenge другого сервера/origin/device/purpose. В CI Dart-клиент подключается к Go-серверу и PostgreSQL: register, login, message, retry, reconnect, events и revoke с отказом `Unauthenticated`.

Генерация из корня репозитория:

```powershell
dart pub global activate protoc_plugin 25.1.0
buf generate protocol/proto --template client/buf.gen.yaml
```

Для Buf в Windows `dart.exe` должен быть в PATH раньше `dart.bat`: обычно `<Flutter SDK>/bin/cache/dart-sdk/bin`. Сгенерированные файлы коммитим. Версии runtime-зависимостей фиксирует `pubspec.lock`.

При ошибке MSVC из-за длинного пути используйте короткий checkout либо junction к `client`, выполните там `flutter clean`, `flutter pub get` и сборку. Результат: `build/windows/x64/runner/Release/`; для переноса нужен весь каталог, не один `.exe`.

## Что дальше

Server streaming, reconnect/backoff, ACL/invites, список пространств, backup/recovery, полноценный vault UX, Android, Flutter Web с HTTP adapter, медиа и уведомления. Сейчас один общий чат, open registration и локальные insecure transports. Подписанный manifest, TLS-профиль и key migration ещё не реализованы; клиент не предназначен для публичного сервера.
