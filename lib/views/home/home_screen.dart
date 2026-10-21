import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_tab.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/floating_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Key headerKey = Key('home-header');

  @override
  Widget build(BuildContext context) {
    final clearance = floatingNavClearance(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final headerHeight = _headerHeight(constraints, topInset);

          return Column(
            children: [
              SizedBox(
                height: headerHeight,
                width: double.infinity,
                child: const _HomeHeader(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: clearance),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Full image when it fits; otherwise a capped cover crop so the bar stays clear.
double _headerHeight(BoxConstraints constraints, double topInset) {
  final natural = constraints.maxWidth / AppAssets.homeHeaderAspectRatio;
  final maxHeight = constraints.maxHeight * 0.46;
  final minReadable = math.min(constraints.maxHeight, topInset + 56);
  final height = math.min(natural, math.max(maxHeight, minReadable));
  return math.min(height, constraints.maxHeight);
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final scrim = AppColors.background;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.homeHeader,
          key: HomeScreen.headerKey,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          semanticLabel: AppLocalizations.of(context).homeHeaderScene,
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
                scrim.withValues(alpha: 0),
                scrim.withValues(alpha: 0),
                scrim,
              ],
              stops: const [0, 0.3, 0.78, 1],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                AppLocalizations.of(context).home,
                key: ValueKey<String>('page-heading-${AppTab.home.headingId}'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
