import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/main_controller.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/app_tab.dart';
import '../core/theme/app_colors.dart';
import '../generated/l10n/app_localizations.dart';

const double _navOuterVerticalPadding = 6;
const double _navItemVerticalPadding = 8;
const double _navIconSize = 24;
const double _navLabelGap = 4;
const double _navLabelFontSize = 12;
const double _navLabelHeight = 1.2;
const double _contentGapAboveNav = 12;

const Map<AppTab, IconData> _tabIcons = {
  AppTab.home: Icons.home_rounded,
  AppTab.explore: Icons.explore_rounded,
  AppTab.notification: Icons.notifications_rounded,
  AppTab.settings: Icons.settings_rounded,
};

/// Space pages should reserve so the floating bar does not cover content.
double floatingNavClearance(BuildContext context) {
  final safeBottom = MediaQuery.paddingOf(context).bottom;
  final labelHeight =
      MediaQuery.textScalerOf(context).scale(_navLabelFontSize) *
      _navLabelHeight;
  final barHeight =
      (_navOuterVerticalPadding * 2) +
      (_navItemVerticalPadding * 2) +
      _navIconSize +
      _navLabelGap +
      labelHeight;
  return safeBottom +
      AppConstants.navBottomMargin +
      barHeight +
      _contentGapAboveNav;
}

class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    assert(_tabIcons.length == AppTab.values.length);
    final viewPadding = MediaQuery.paddingOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.navHorizontalMargin + viewPadding.left,
        0,
        AppConstants.navHorizontalMargin + viewPadding.right,
        AppConstants.navBottomMargin + viewPadding.bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppConstants.navMaxWidth),
          child: SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.surface,
              elevation: 6,
              shadowColor: const Color(0x80000000),
              surfaceTintColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusNav),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: _navOuterVerticalPadding,
                ),
                child: Row(
                  children: [
                    for (final tab in AppTab.values)
                      Expanded(
                        child: _NavDestination(
                          tab: tab,
                          selected: tab.index == selectedIndex,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination extends StatelessWidget {
  const _NavDestination({required this.tab, required this.selected});

  final AppTab tab;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    final label = tab.label(AppLocalizations.of(context));

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: () => context.read<MainController>().selectTab(tab),
        borderRadius: BorderRadius.circular(18),
        mouseCursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: _navItemVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_tabIcons[tab], size: _navIconSize, color: color),
              const SizedBox(height: _navLabelGap),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    color: color,
                    fontSize: _navLabelFontSize,
                    height: _navLabelHeight,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
