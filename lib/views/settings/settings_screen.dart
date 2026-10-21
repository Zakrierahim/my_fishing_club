import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/locale_controller.dart';
import '../../core/constants/app_tab.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/app_page_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Key malayOptionKey = Key('language-ms');
  static const Key englishOptionKey = Key('language-en');

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
          ],
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
