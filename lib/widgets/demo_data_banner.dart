import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../data/dummy/providers/dummy_fishing_data_provider.dart';
import '../generated/l10n/app_localizations.dart';

/// Visible label while the fictional pond preview is on.
class DemoDataBanner extends StatelessWidget {
  const DemoDataBanner({super.key});

  static const Key bannerKey = Key('demo-data-banner');

  @override
  Widget build(BuildContext context) {
    final enabled = context.watch<DummyFishingDataProvider>().isEnabled;
    if (!enabled) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            l10n.previewData,
            key: bannerKey,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
