import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../generated/l10n/app_localizations.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      label: l10n.fishingHook,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(size * 0.28),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          Icons.phishing_rounded,
          size: size * 0.46,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class AppBrandHeader extends StatelessWidget {
  const AppBrandHeader({super.key, this.markSize = 88});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandMark(size: markSize),
        const SizedBox(height: 20),
        Text(
          l10n.appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
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
    );
  }
}
