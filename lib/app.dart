import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controllers/angler_records_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/linked_accounts_controller.dart';
import 'controllers/locale_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/main_controller.dart';
import 'controllers/membership_controller.dart';
import 'controllers/pond_catalog_controller.dart';
import 'controllers/profile_controller.dart';
import 'core/auth/auth_gateway.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'data/dummy/dummy_fishing_data.dart';
import 'data/dummy/providers/dummy_fishing_data_provider.dart';
import 'generated/l10n/app_localizations.dart';
import 'views/splash/splash_screen.dart';

class FishingApp extends StatelessWidget {
  const FishingApp({
    super.key,
    this.localeController,
    this.authGateway,
    this.pondCatalog,
    this.membershipController,
    this.profileController,
    this.anglerRecords,
    this.useDummyData = false,
  });

  /// When omitted, the app starts in English until a saved language is loaded.
  final LocaleController? localeController;

  /// When omitted, provider sign-in stays unavailable until a backend exists.
  final AuthGateway? authGateway;

  /// When omitted, Explore has no ponds unless [useDummyData] is true.
  final PondCatalogController? pondCatalog;

  /// When omitted, the angler has no memberships unless [useDummyData] is true.
  final MembershipController? membershipController;

  /// Loads the fictional pond preview. Release builds and tests leave this off.
  final bool useDummyData;

  /// When omitted, the profile name is unset.
  final ProfileController? profileController;

  /// When omitted, favorites, catches, and trips load from local storage.
  final AnglerRecordsController? anglerRecords;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleController>(
          create: (_) => localeController ?? LocaleController(),
        ),
        Provider<AuthGateway>(
          create: (_) => authGateway ?? const UnconfiguredAuthGateway(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AuthController(gateway: context.read<AuthGateway>()),
        ),
        ChangeNotifierProvider(
          create: (context) => LinkedAccountsController(
            gateway: context.read<AuthGateway>(),
            auth: context.read<AuthController>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => MainController()),
        ChangeNotifierProvider(
          create: (_) => DummyFishingDataProvider(enabled: useDummyData),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              pondCatalog ??
              PondCatalogController(
                ponds: useDummyData ? DummyFishingData.ponds : const [],
              ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              membershipController ??
              MembershipController(
                memberships: useDummyData
                    ? DummyFishingData.memberships
                    : const [],
              ),
        ),
        ChangeNotifierProvider(
          create: (_) => profileController ?? ProfileController(),
        ),
        if (anglerRecords != null)
          ChangeNotifierProvider<AnglerRecordsController>.value(
            value: anglerRecords!,
          )
        else
          ChangeNotifierProvider(create: (_) => AnglerRecordsController()),
      ],
      child: const _LocalizedApp(),
    );
  }
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleController>().locale;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const SplashScreen(),
      ),
    );
  }
}
