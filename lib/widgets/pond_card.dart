import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/angler_records_controller.dart';
import '../core/theme/app_colors.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/pond.dart';
import 'pond_image.dart';
import 'pond_water_label.dart';

class PondCard extends StatelessWidget {
  const PondCard({super.key, required this.pond, required this.onTap});

  final Pond pond;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final favorite = context.watch<AnglerRecordsController>().isFavorite(
      pond.id,
    );
    final species = pond.species
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .join(', ');

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                PondImage(
                  asset: pond.imageAsset,
                  height: 132,
                  unavailableLabel: pond.imageAsset == null
                      ? l10n.imageUnavailable
                      : null,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    key: ValueKey<String>('favorite-${pond.id}'),
                    tooltip: favorite ? l10n.unfavoritePond : l10n.favoritePond,
                    onPressed: () {
                      context.read<AnglerRecordsController>().setFavorite(
                        pond.id,
                        favorite: !favorite,
                      );
                    },
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.background,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pond.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  if (pond.isDemo) ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.previewData,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (pond.waterType != PondWaterType.unknown) ...[
                    const SizedBox(height: 6),
                    Text(
                      pondWaterLabel(l10n, pond.waterType),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                  if (pond.addressOrArea != null &&
                      pond.addressOrArea!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      pond.addressOrArea!.trim(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                  if (pond.pondType.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      pond.pondType.trim(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                  if (species.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.speciesLabel}: $species',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
