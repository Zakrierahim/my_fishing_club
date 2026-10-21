import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/locale_controller.dart';
import '../../controllers/membership_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../data/dummy/providers/dummy_fishing_data_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_tab.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/app_page_scaffold.dart';
import '../favorites/favorites_screen.dart';
import '../membership/memberships_screen.dart';
import '../profile/profile_screen.dart';
import 'linked_accounts_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Key malayOptionKey = Key('language-ms');
  static const Key englishOptionKey = Key('language-en');
  static const Key profileKey = Key('settings-profile');
  static const Key membershipsKey = Key('settings-memberships');
  static const Key favoritesKey = Key('settings-favorites');
  static const Key demoDataKey = Key('settings-demo-data');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = context.watch<LocaleController>().locale.languageCode;

    return AppPageScaffold(
      title: l10n.settings,
      headingId: AppTab.settings.headingId,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SettingsLink(
              key: profileKey,
              icon: Icons.person_rounded,
              label: l10n.profile,
              onTap: () {
                pushAppPage(context, const ProfileScreen(), '/profile');
              },
            ),
            const SizedBox(height: 8),
            _SettingsLink(
              key: favoritesKey,
              icon: Icons.favorite_border,
              label: l10n.favorites,
              onTap: () {
                pushAppPage(context, const FavoritesScreen(), '/favorites');
              },
            ),
            const SizedBox(height: 8),
            _SettingsLink(
              key: membershipsKey,
              icon: Icons.card_membership_rounded,
              label: l10n.myMemberships,
              onTap: () {
                pushAppPage(context, const MembershipsScreen(), '/memberships');
              },
            ),
            const SizedBox(height: 28),
            Text(
              l10n.preferences,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const _DemoDataSwitch(),
            const SizedBox(height: 20),
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _LanguageOption(
              key: malayOptionKey,
              flag: '🇲🇾',
              label: l10n.bahasaMelayu,
              selected: languageCode == LocaleController.malay.languageCode,
              onSelected: () {
                context.read<LocaleController>().setLocale(
                  LocaleController.malay,
                );
              },
            ),
            const SizedBox(height: 8),
            _LanguageOption(
              key: englishOptionKey,
              flag: '🇬🇧',
              label: l10n.english,
              selected: languageCode == LocaleController.english.languageCode,
              onSelected: () {
                context.read<LocaleController>().setLocale(
                  LocaleController.english,
                );
              },
            ),
            const SizedBox(height: 28),
            const LinkedAccountsSection(),
            const SizedBox(height: 28),
            Text(
              l10n.about,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.appName, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              l10n.versionLabel(AppConstants.appVersion),
              key: const Key('settings-version'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLink extends StatelessWidget {
  const _SettingsLink({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    super.key,
    required this.flag,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppColors.textPrimary
        : AppColors.textSecondary;

    return Semantics(
      selected: selected,
      button: true,
      inMutuallyExclusiveGroup: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? AppColors.secondary : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onSelected,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(flag, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 16,
                        height: 1.3,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (selected)
                    const Icon(Icons.check_rounded, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoDataSwitch extends StatelessWidget {
  const _DemoDataSwitch();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabled = context.watch<DummyFishingDataProvider>().isEnabled;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: SwitchListTile(
        key: SettingsScreen.demoDataKey,
        value: enabled,
        activeThumbColor: AppColors.primary,
        title: Text(l10n.previewData),
        subtitle: Text(l10n.demoDataHint),
        onChanged: (value) {
          context.read<DummyFishingDataProvider>().setPreviewEnabled(
            enabled: value,
            catalog: context.read<PondCatalogController>(),
            memberships: context.read<MembershipController>(),
          );
        },
      ),
    );
  }
}
