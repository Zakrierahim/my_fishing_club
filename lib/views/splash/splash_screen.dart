import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Key backgroundKey = Key('splash-background');

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, _openLogin);
  }

  void _openLogin() {
    if (!mounted || _didNavigate) {
      return;
    }
    _didNavigate = true;
    Navigator.of(context).pushReplacement(
      fadePageRoute(page: const LoginScreen(), routeName: '/login'),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrim = AppColors.background;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.splashBackground,
            key: SplashScreen.backgroundKey,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            semanticLabel: AppLocalizations.of(context).splashScene,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: AppColors.background);
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scrim.withValues(alpha: 0.55),
                  scrim.withValues(alpha: 0),
                  scrim.withValues(alpha: 0),
                  scrim.withValues(alpha: 0.35),
                ],
                stops: const [0, 0.22, 0.7, 1],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context).appName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 36,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
