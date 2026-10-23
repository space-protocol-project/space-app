# Локальная адаптация camera_windows 0.3.0+1

Источник: https://pub.dev/packages/camera_windows/versions/0.3.0+1 и https://github.com/flutter/packages/tree/main/packages/camera/camera_windows.
Лицензия BSD-3-Clause сохранена в LICENSE.

В GetFilePathForPicture в windows/camera_plugin.cpp Pictures заменён системной временной папкой через GetTempPathW. Сканер удаляет точный созданный кадр в finally. Нет отправки кадров серверу и записи видео. При обновлении upstream этот небольшой патч должен быть перенесён и перепроверен.

В windows/test/capture_controller_test.cpp ожидаемые тексты системных ошибок получаются через `_com_error`, а не задаются английскими строками. Коды ошибок и точные сравнения сохранены; тесты работают при русском языке Windows. Все 86 нативных тестов прошли.

23 октября 2026 обновлены исходники upstream 0.3.0 → 0.3.0+1: исправлен выбор потока многопоточных USB-камер. Архив pub.dev проверен по SHA-256 `05c322203f66fa68953378398542865606543f294395fbbb055b4ea8f089e39b`. Перед переносом каждый заменённый файл сопоставлен с upstream 0.3.0; локальный `camera_plugin.cpp` не заменялся.
