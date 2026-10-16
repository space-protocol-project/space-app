# Адаптация flutter_secure_storage_windows 4.2.2

Лицензия upstream сохранена. Реально используемый Dart/DPAPI backend получил безопасное имя partition-файла и atomic replace: зашифрованный временный файл → flush → MoveFileEx(REPLACE_EXISTING | WRITE_THROUGH). Активная запись и журнал используют разные partitions. Legacy общий файл читается и мигрируется при первом обращении.

Crash checkpoint находится после половины encrypted temp write и включается только --dart-define=SPACE_VAULT_CRASH_TEST=true. Обычная сборка использует compile-time false и не содержит рабочий checkpoint. Тест завершает exact созданный процесс; active file должен остаться целым, журнал — читаемым. Это process-crash тест, не гарантия от сбоя диска/питания.

Имена partitions допускают `=`: ключи истории используют SHA-256 в base64url с padding. Символ допустим в имени файла Windows; разделители пути, двоеточия и управляющие символы по-прежнему запрещены. Идентификаторы и существующие записи истории не меняются. Проверка `tool/native_vault_drill.dart` включает избранное и запуск нового процесса.
