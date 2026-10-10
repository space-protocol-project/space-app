import 'package:flutter/material.dart';

class RecoveryDeviceView {
  const RecoveryDeviceView({
    required this.id,
    required this.expiresAt,
    this.revoked = false,
    this.recovery = false,
  });
  final String id;
  final int expiresAt;
  final bool revoked, recovery;
}

class RecoveryToolsView extends StatelessWidget {
  const RecoveryToolsView({
    super.key,
    required this.connected,
    required this.hasServer,
    required this.hasDeviceManagement,
    required this.hasRootAuthority,
    required this.canRotate,
    required this.pending,
    required this.message,
    required this.pairingCode,
    required this.pairingEntered,
    required this.pairingCheck,
    required this.pairingPrepared,
    required this.devices,
    required this.currentGrantId,
    required this.onRotate,
    required this.onRenewRotation,
    required this.onFinishRotation,
    required this.onPreparePairing,
    required this.onApprovePairing,
    required this.onPairingCodeChanged,
    required this.onExport,
    required this.onRestore,
    required this.onScan,
    required this.onRefreshDevices,
    required this.onRevoke,
  });
  final bool connected,
      hasServer,
      hasDeviceManagement,
      hasRootAuthority,
      canRotate,
      pending,
      pairingPrepared;
  final String message, pairingCheck, currentGrantId;
  final TextEditingController pairingCode, pairingEntered;
  final List<RecoveryDeviceView> devices;
  final VoidCallback onRotate,
      onRenewRotation,
      onFinishRotation,
      onPreparePairing,
      onApprovePairing,
      onExport,
      onRestore,
      onScan,
      onRefreshDevices;
  final ValueChanged<String> onPairingCodeChanged, onRevoke;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      RecoverySurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Смена корневого ключа',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Сохраняет вашу идентичность и закрывает доступ прежним ключам. Начать смену можно на устройстве с корневым ключом. После сбоя завершите сохранённую смену. Если запрос истёк до завершения на сервере, подключитесь прежним ключом и обновите запрос.',
            ),
            const SizedBox(height: 12),
            if (connected && hasRootAuthority && canRotate) ...[
              OutlinedButton(
                onPressed: pending ? null : onRotate,
                child: const Text('Сменить корневой ключ'),
              ),
              TextButton(
                onPressed: pending ? null : onRenewRotation,
                child: const Text('Обновить истёкший запрос'),
              ),
            ],
            OutlinedButton(
              onPressed: pending || !hasServer ? null : onFinishRotation,
              child: const Text('Завершить сохранённую смену'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      RecoverySurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Подтвердить устройство',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Введите одноразовый код с нового устройства. Подпись требует root или открытую recovery-карточку. Для recovery-карточки новое устройство проверяет цепочку от исходного root.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pairingCode,
              onChanged: onPairingCodeChanged,
              decoration: const InputDecoration(
                labelText: 'Код сопряжения',
                hintText: 'pc_…',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: pending || !connected || !hasDeviceManagement
                  ? null
                  : onPreparePairing,
              icon: const Icon(Icons.verified_user_outlined),
              label: const Text('Проверить и подтвердить'),
            ),
            if (pairingCheck.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Код проверки для сравнения с новым устройством'),
              SelectableText(
                pairingCheck,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (pairingPrepared) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: pairingEntered,
                  decoration: const InputDecoration(
                    labelText: 'Код проверки с нового устройства',
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: pending ? null : onApprovePairing,
                  child: const Text('Коды совпадают — подписать'),
                ),
              ],
            ],
          ],
        ),
      ),
      const SizedBox(height: 20),
      RecoverySurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Восстановление доступа',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Зашифрованная карточка сохраняет доступ к этой идентичности на выбранном сервере. Рабочий ключ устройства в неё не копируется. Владение карточкой и паролем позволяет подключать новые устройства. Устройство из карточки восстановления не сохраняет управляющий секрет; для отзыва других устройств её нужно открыть заново. Корневая карточка восстанавливает полный управляющий root. Карточку можно сохранить как QR в PNG или JSON и восстановить из выбранного файла.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: pending || !connected || !hasRootAuthority
                      ? null
                      : onExport,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Сохранить карточку'),
                ),
                OutlinedButton.icon(
                  onPressed: pending ? null : onRestore,
                  icon: const Icon(Icons.restore),
                  label: const Text('Восстановить из файла'),
                ),
                OutlinedButton.icon(
                  onPressed: pending ? null : onScan,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Сканировать камерой'),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      RecoverySurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ваши устройства',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Обновить устройства',
                  onPressed: pending || !connected || !hasDeviceManagement
                      ? null
                      : onRefreshDevices,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const Text(
              'Показаны разрешения только вашей идентичности. Старые и отозванные записи сохраняются.',
            ),
            for (final grant in devices) ...[
              const Divider(),
              Text(
                grant.recovery
                    ? 'Ключ восстановления'
                    : grant.id == currentGrantId
                    ? 'Это устройство'
                    : 'Другое устройство',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SelectableText(
                grant.id,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
              Text(
                grant.revoked
                    ? 'Отозвано'
                    : 'Действует до ${DateTime.fromMillisecondsSinceEpoch(grant.expiresAt * 1000).toLocal()}',
              ),
              if (!grant.revoked &&
                  grant.expiresAt >
                      DateTime.now().millisecondsSinceEpoch ~/ 1000)
                TextButton(
                  onPressed: pending ? null : () => onRevoke(grant.id),
                  child: const Text('Отозвать доступ'),
                ),
            ],
          ],
        ),
      ),
      if (pending) ...[
        const SizedBox(height: 16),
        const LinearProgressIndicator(),
      ],
      if (message.isNotEmpty) ...[const SizedBox(height: 12), Text(message)],
    ],
  );
}

class RecoverySurface extends StatelessWidget {
  const RecoverySurface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Padding(padding: const EdgeInsets.all(24), child: child),
  );
}
