import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'src/chat_controller.dart';
import 'src/app_shutdown.dart';
import 'src/preferences.dart';
import 'l10n/app_localizations.dart';
import 'ui/shell.dart';
import 'ui/catalog_grant_page.dart';
import 'src/extensions_p1/catalog_grant_cubit.dart';
import 'src/extensions_p1/bundled_catalog.dart';
import 'src/extensions_p1/installed_extensions_cubit.dart';
import 'ui/interface_scale.dart';
import 'ui/app_shutdown_gate.dart';
import 'ui/local_extension_session_scope.dart';
import 'src/extensions_p1/local_session_cubit.dart';
import 'src/extensions_p1/local_profile_verifier.dart';
import 'src/secure_vault.dart';
import 'ui/local_profile_unlock.dart';

import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart';

class SpaceApp extends StatefulWidget {
  const SpaceApp({
    super.key,
    this.controller,
    this.shutdown,
    this.extensionAccess,
    this.catalogRuntime,
    this.profileVerifier,
  });
  final ChatController? controller;
  final AppShutdown? shutdown;
  final LocalSessionCubit? extensionAccess;
  final SpaceCatalogRuntime? catalogRuntime;
  final LocalProfileVerifier? profileVerifier;
  @override
  State<SpaceApp> createState() => _SpaceAppState();
}

class _SpaceAppState extends State<SpaceApp> with WidgetsBindingObserver {
  final catalogs = SpaceCatalogRuntime();
  InstalledExtensionsCubit? installations;
  final preferences = AppPreferences();
  final navigatorKey = GlobalKey<NavigatorState>();
  late final profileVerifier = LocalProfileVerifier(
    const PlatformKeyStorage(),
    lockPath: () async => paths.join(
      (await getApplicationSupportDirectory()).path,
      'extensions-profile.lock',
    ),
  );
  late final defaultAccess = LocalSessionCubit(
    authenticate: _authenticateProfile,
  );
  LocalSessionCubit get extensionAccess =>
      widget.extensionAccess ?? defaultAccess;
  Future<LocalProfileIdentity?> _authenticateProfile() async {
    final context = navigatorKey.currentContext;
    if (!mounted || context == null) return null;
    return showDialog<LocalProfileIdentity>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LocalProfileUnlockDialog(
        service: widget.profileVerifier ?? profileVerifier,
      ),
    );
  }

  late final Future<void> startupReady;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startupReady = preferences.load();
    _bindInstallations();
  }

  void _bindInstallations() {
    if (widget.catalogRuntime != null || !BundledCatalog.supported) return;
    installations = InstalledExtensionsCubit(
      extensionAccess,
      catalogs,
      shutdown: widget.shutdown,
    );
  }

  @override
  void didUpdateWidget(SpaceApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.extensionAccess == widget.extensionAccess &&
        oldWidget.catalogRuntime == widget.catalogRuntime &&
        oldWidget.shutdown == widget.shutdown) {
      return;
    }
    final previous = installations;
    installations = null;
    if (previous != null) unawaited(previous.close());
    _bindInstallations();
  }

  Widget _installationScope(Widget child) {
    final owner = installations;
    return owner == null
        ? child
        : BlocProvider.value(value: owner, child: child);
  }

  @override
  void didChangePlatformBrightness() {
    unawaited(
      preferences.updateSystemBrightness(
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    preferences.dispose();
    final owner = installations;
    if (owner != null) unawaited(owner.close());
    unawaited(catalogs.close());
    unawaited(defaultAccess.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AppPreferences, PreferencesState>(
        bloc: preferences,
        builder: (context, state) => MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Space',
          routes: {
            '/device/catalogs': (_) => CatalogGrantPage(
              access: extensionAccess,
              runtime: widget.catalogRuntime ?? catalogs,
            ),
          },
          builder: (context, child) => _installationScope(
            InterfaceScale(
              scale: state.uiScale,
              child: RepositoryProvider.value(
                value: widget.catalogRuntime ?? catalogs,
                child: LocalExtensionSessionScope(
                  access: extensionAccess,
                  shutdown: widget.shutdown,
                  child: AppShutdownGate(
                    shutdown: widget.shutdown,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior(),
          theme: state.theme ?? preferences.theme,
          locale: state.locale,
          localizationsDelegates: [
            AdminLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SpaceShell(
            extensionAccess: extensionAccess,
            preferences: preferences,
            startupReady: startupReady,
            controller: widget.controller,
            shutdown: widget.shutdown,
          ),
        ),
      );
}
