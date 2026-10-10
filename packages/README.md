# Общие модули основного приложения

- space_admin_ui: настройки, каналы/ACL, участники, приглашения, устройства и общие экраны восстановления.
- space_api: контракт адаптера и ошибки транспорта; основное приложение использует NativeAdminGateway и gRPC.

Отдельная административная программа не выпускается. Browser-only пакеты удалены вместе с экспериментальной web-оболочкой. [Решение и этапы](https://github.com/space-protocol-project/space-protocol/blob/main/docs/adr/025-unified-administration.md).
