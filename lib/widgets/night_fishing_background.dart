import 'package:flutter/material.dart';

import '../core/constants/app_assets.dart';
import '../core/theme/app_colors.dart';
import '../generated/l10n/app_localizations.dart';

/// Full-screen splash photo with a dark tint so foreground text stays readable.
class NightFishingBackground extends StatelessWidget {
  const NightFishingBackground({super.key, this.imageKey, required this.child});

  final Key? imageKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scrim = AppColors.background;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.splashBackground,
          key: imageKey,
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
                scrim.withValues(alpha: 0.5),
                scrim.withValues(alpha: 0.28),
                scrim.withValues(alpha: 0.42),
                scrim.withValues(alpha: 0.72),
              ],
              stops: const [0, 0.32, 0.68, 1],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
