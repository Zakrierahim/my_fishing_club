import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/profile_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/detail_scaffold.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Key nameKey = Key('profile-name');
  static const Key editKey = Key('profile-edit');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = context.watch<ProfileController>().displayName;
    final display = name ?? l10n.nameNotSet;

    return DetailScaffold(
      title: l10n.profile,
      titleKey: const Key('profile-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.secondary,
            child: name == null
                ? const Icon(
                    Icons.person_rounded,
                    color: AppColors.textPrimary,
                    size: 36,
                  )
                : Text(
                    name.characters.first.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            display,
            key: nameKey,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _UnavailableRow(label: l10n.email),
          const SizedBox(height: 8),
          _UnavailableRow(label: l10n.phoneNumber),
          const SizedBox(height: 20),
          FilledButton(
            key: editKey,
            onPressed: () {
              pushAppPage(context, const EditProfileScreen(), '/profile/edit');
            },
            child: Text(l10n.editProfile),
          ),
        ],
      ),
    );
  }
}

class _UnavailableRow extends StatelessWidget {
  const _UnavailableRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              l10n.unavailable,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
