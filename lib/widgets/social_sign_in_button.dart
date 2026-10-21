import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../models/auth_provider_id.dart';
import 'provider_mark.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final AuthProviderId provider;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  static Key keyFor(AuthProviderId provider) =>
      ValueKey<String>('social-${provider.name}');

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          key: keyFor(provider),
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            backgroundColor: AppColors.surface,
            disabledForegroundColor: AppColors.textSecondary,
            disabledBackgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.border),
            minimumSize: const Size(64, 52),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusButton),
            ),
            alignment: Alignment.centerLeft,
          ),
          child: Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                ProviderMark(provider: provider),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
