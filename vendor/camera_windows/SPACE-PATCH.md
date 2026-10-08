# Локальная адаптация camera_windows 0.3.0

Источник: https://pub.dev/packages/camera_windows/versions/0.3.0 и https://github.com/flutter/packages/tree/main/packages/camera/camera_windows.
Лицензия BSD-3-Clause сохранена в LICENSE.

Изменён только GetFilePathForPicture в windows/camera_plugin.cpp: Pictures заменён системной временной папкой через GetTempPathW. Сканер удаляет точный созданный кадр в finally. Нет отправки кадров серверу и записи видео. При обновлении upstream этот небольшой патч должен быть перенесён и перепроверен.
