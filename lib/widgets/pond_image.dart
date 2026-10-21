import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Local pond artwork with a calm fallback when the asset is missing.
class PondImage extends StatelessWidget {
  const PondImage({
    super.key,
    required this.asset,
    this.height = 160,
    this.unavailableLabel,
  });

  final String? asset;
  final double height;
  final String? unavailableLabel;

  @override
  Widget build(BuildContext context) {
    final path = asset?.trim();
    if (path == null || path.isEmpty) {
      return _fallback();
    }

    return Image.asset(
      path,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }

  Widget _fallback() {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ColoredBox(
        color: AppColors.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.water_rounded, color: AppColors.primary, size: 36),
            if (unavailableLabel != null &&
                unavailableLabel!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                unavailableLabel!.trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
