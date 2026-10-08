# Проверочный патч flutter_secure_storage_windows 4.2.2

Источник: https://pub.dev/packages/flutter_secure_storage_windows/versions/4.2.2. Лицензия upstream сохранена.

Checkpoint после IV/tag и до ciphertext компилируется только при SPACE_VAULT_CRASH_BUILD=1. Проверочный процесс передаёт exact key собственного случайного test namespace. В этой точке файл уже реально частично записан и flush выполнен; test runner завершает только созданный процесс с проверенным путём EXE.

Production сборка выполняется без SPACE_VAULT_CRASH_BUILD. В ней нет crash hook и чтения тестовых env-переменных; штатная запись не изменена. После crash-drill следует явно пересобрать lib/main.dart с удалённым флагом.
