import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/home_controller.dart';
import '../src/home_network.dart';

class HomeNetworkEditor extends StatefulWidget {
  const HomeNetworkEditor({
    super.key,
    required this.home,
    required this.address,
    required this.enabled,
    this.onDetect,
  });
  final HomeController home;
  final TextEditingController address;
  final bool enabled;
  final Future<void> Function()? onDetect;
  @override
  State<HomeNetworkEditor> createState() => HomeNetworkEditorState();
}

class HomeNetworkEditorState extends State<HomeNetworkEditor> {
  late final port = TextEditingController(
    text: '${widget.home.network?.endpoints.first.port ?? 8443}',
  );
  late final listenPort = TextEditingController(
    text: '${widget.home.network?.listenPort ?? 8443}',
  );
  late String listenHost = widget.home.network?.listenHost ?? '::';
  late final alternatives = [...?widget.home.network?.endpoints.skip(1)]
      .map(
        (e) => (
          TextEditingController(text: e.host),
          TextEditingController(text: '${e.port}'),
        ),
      )
      .toList();
  late bool autoPortMapping = widget.home.network?.autoPortMapping ?? false;
  late bool autoPublicIP = widget.home.network?.autoPublicIP ?? false;
  String error = '';
  late HomeNetwork? loadedNetwork = widget.home.network;
  @override
  void didUpdateWidget(covariant HomeNetworkEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final network = widget.home.network;
    if (network == null || identical(network, loadedNetwork)) return;
    loadedNetwork = network;
    port.text = '${network.endpoints.first.port}';
    listenPort.text = '${network.listenPort}';
    listenHost = network.listenHost;
    autoPortMapping = network.autoPortMapping;
    autoPublicIP = network.autoPublicIP;
    final previous = alternatives.toList();
    alternatives.clear();
    for (final endpoint in network.endpoints.skip(1)) {
      alternatives.add((
        TextEditingController(text: endpoint.host),
        TextEditingController(text: '${endpoint.port}'),
      ));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final row in previous) {
        row.$1.dispose();
        row.$2.dispose();
      }
    });
  }

  @override
  void dispose() {
    port.dispose();
    listenPort.dispose();
    for (final row in alternatives) {
      row.$1.dispose();
      row.$2.dispose();
    }
    super.dispose();
  }

  Future<bool> save() async {
    try {
      final endpoints = [
        ServerEndpoint.parse(widget.address.text, int.parse(port.text)),
      ];
      for (final row in alternatives) {
        endpoints.add(
          ServerEndpoint.parse(
            row.$1.text,
            int.parse(row.$2.text),
            priority: endpoints.length,
          ),
        );
      }
      final saved = await widget.home.configureNetwork(
        endpoints,
        listenHost: listenHost,
        listenPort: int.parse(listenPort.text),
        autoPortMapping: autoPortMapping,
        autoPublicIP: autoPublicIP,
      );
      if (mounted) setState(() => error = saved ? '' : widget.home.error);
      return saved;
    } catch (_) {
      if (mounted) setState(() => error = context.strings.homeNetworkInvalid);
      return false;
    }
  }

  InputDecoration decoration(String label, {String? hint}) {
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: colors.surfaceContainerHighest.withValues(alpha: .45),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border,
      enabledBorder: border,
      disabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
    );
  }

  Widget portField(TextEditingController controller, String label) => TextField(
    controller: controller,
    enabled: widget.enabled,
    keyboardType: TextInputType.number,
    decoration: decoration(label),
  );

  Widget addressFields(
    TextEditingController host,
    TextEditingController number,
  ) {
    final field = TextField(
      controller: host,
      enabled: widget.enabled,
      decoration: decoration(
        context.strings.homeAddressLabel,
        hint: 'space.example.org',
      ),
      autocorrect: false,
      enableSuggestions: false,
    );
    final port = portField(number, context.strings.homeExternalPort);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(children: [field, const SizedBox(height: 12), port]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: field),
            const SizedBox(width: 12),
            SizedBox(width: 128, child: port),
          ],
        );
      },
    );
  }

  void removeAddress(int index) {
    final row = alternatives.removeAt(index);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      row.$1.dispose();
      row.$2.dispose();
    });
  }

  Widget addressCard(int index) {
    final primary = index == 0;
    final host = primary ? widget.address : alternatives[index - 1].$1;
    final number = primary ? port : alternatives[index - 1].$2;
    final colors = Theme.of(context).colorScheme;
    return Container(
      key: ValueKey(host),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Icon(
                  primary ? Icons.public_outlined : Icons.alt_route_outlined,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    primary
                        ? context.strings.homePrimaryAddress
                        : context.strings.homeBackupAddress,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                if (primary && widget.onDetect != null)
                  IconButton(
                    tooltip:
                        '${context.strings.detectIP}\n${context.strings.homeIPPrivacy}',
                    onPressed: widget.enabled ? widget.onDetect : null,
                    icon: const Icon(Icons.my_location_outlined, size: 20),
                  ),
                if (!primary)
                  IconButton(
                    tooltip: context.strings.homeRemoveAddress,
                    onPressed: widget.enabled
                        ? () => removeAddress(index - 1)
                        : null,
                    icon: const Icon(Icons.close, size: 20),
                  ),
              ],
            ),
          ),
          addressFields(host, number),
        ],
      ),
    );
  }

  Widget localSettings() {
    final colors = Theme.of(context).colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: colors.outlineVariant.withValues(alpha: .4)),
    );
    final interfaces = DropdownButtonFormField<String>(
      key: ValueKey(listenHost),
      initialValue: listenHost,
      decoration: decoration(context.strings.homeListenInterfaces),
      items: [
        const DropdownMenuItem(value: '::', child: Text('IPv4 + IPv6')),
        const DropdownMenuItem(value: '0.0.0.0', child: Text('IPv4')),
        if (!['::', '0.0.0.0'].contains(listenHost))
          DropdownMenuItem(value: listenHost, child: Text(listenHost)),
      ],
      onChanged: !widget.enabled
          ? null
          : (value) => setState(() => listenHost = value!),
    );
    return ExpansionTile(
      maintainState: true,
      shape: shape,
      collapsedShape: shape,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      leading: const Icon(Icons.dns_outlined, size: 20),
      title: Text(
        context.strings.homeLocalSettings,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final port = portField(listenPort, context.strings.homeListenPort);
            if (constraints.maxWidth < 420) {
              return Column(
                children: [port, const SizedBox(height: 12), interfaces],
              );
            }
            return Row(
              children: [
                Expanded(child: port),
                const SizedBox(width: 12),
                Expanded(child: interfaces),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          context.strings.homeNetworkHelp,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.strings.homeConnectionAddresses,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 6),
      Text(
        context.strings.homeAddressHelp,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 16),
      for (var i = 0; i <= alternatives.length; i++) addressCard(i),
      TextButton.icon(
        onPressed:
            !widget.enabled ||
                alternatives.length >=
                    ((autoPortMapping ||
                            autoPublicIP ||
                            loadedNetwork?.previousAutomatic != null)
                        ? 6
                        : 7)
            ? null
            : () => setState(() {
                alternatives.add((
                  TextEditingController(),
                  TextEditingController(text: '8443'),
                ));
              }),
        icon: const Icon(Icons.add, size: 20),
        label: Text(context.strings.homeAddAddress),
      ),
      const SizedBox(height: 20),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(context.strings.homeAutoPortMapping),
        subtitle: Text(context.strings.homeAutoPortMappingHelp),
        value: autoPortMapping,
        onChanged: widget.enabled
            ? (value) => setState(() => autoPortMapping = value)
            : null,
      ),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(context.strings.homeAutoPublicIP),
        subtitle: Text(context.strings.homeAutoPublicIPHelp),
        value: autoPublicIP,
        onChanged: widget.enabled
            ? (value) => setState(() => autoPublicIP = value)
            : null,
      ),
      const SizedBox(height: 12),
      localSettings(),
      if (error.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      const SizedBox(height: 16),
      Align(
        alignment: Alignment.centerRight,
        child: OutlinedButton.icon(
          onPressed: widget.enabled ? save : null,
          icon: const Icon(Icons.check, size: 18),
          label: Text(context.strings.homeSaveAddresses),
        ),
      ),
    ],
  );
}
