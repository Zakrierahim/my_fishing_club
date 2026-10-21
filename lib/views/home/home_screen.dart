import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/membership_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_tab.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/navigation/open_session.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/demo_data_banner.dart';
import '../../widgets/floating_bottom_nav.dart';
import '../catches/catch_detail_screen.dart';
import '../catches/catch_list_screen.dart';
import '../membership/memberships_screen.dart';
import '../pass/fishing_pass_screen.dart';
import '../sessions/session_detail_screen.dart';
import '../sessions/session_format.dart';
import '../trips/trip_list_screen.dart';

/// Greeting for [hour] in local time. Morning before 12, afternoon before 18.
String homeGreeting(AppLocalizations l10n, int hour) {
  if (hour < 12) {
    return l10n.goodMorning;
  }
  if (hour < 18) {
    return l10n.goodAfternoon;
  }
  return l10n.goodEvening;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Key headerKey = Key('home-header');
  static const Key logCatchKey = Key('home-log-catch');
  static const Key explorePondsKey = Key('home-explore-ponds');
  static const Key membershipsKey = Key('home-memberships');
  static const Key tripsKey = Key('home-trips');
  static const Key passKey = Key('home-pass');
  static const Key membershipEmptyKey = Key('home-membership-empty');
  static const Key emptyCatchesKey = Key('home-empty-catches');

  @override
  Widget build(BuildContext context) {
    final clearance = floatingNavClearance(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final headerHeight = _headerHeight(constraints, topInset);
          final contentWidth = math.min(
            constraints.maxWidth,
            AppConstants.contentMaxWidth,
          );

          return Column(
            children: [
              SizedBox(
                height: headerHeight,
                width: double.infinity,
                child: const _HomeHeader(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: contentWidth,
                    child: _HomeDashboard(bottomClearance: clearance),
                  ),
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

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({required this.bottomClearance});

  final double bottomClearance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final greeting = homeGreeting(l10n, DateTime.now().hour);
    final memberships = context.watch<MembershipController>();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppConstants.pageHorizontalPadding,
        4,
        AppConstants.pageHorizontalPadding,
        bottomClearance,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(greeting, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(l10n.homePrompt, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          const DemoDataBanner(),
          const SizedBox(height: 8),
          _sectionTitle(context, l10n.membershipSection),
          const SizedBox(height: 12),
          _MembershipOverview(memberships: memberships),
          const SizedBox(height: 12),
          _PassCard(
            onTap: () {
              pushAppPage(context, const FishingPassScreen(), '/pass');
            },
          ),
          const SizedBox(height: 28),
          _sectionTitle(context, l10n.fishingSession),
          const SizedBox(height: 12),
          const _SessionHomeCard(),
          const SizedBox(height: 28),
          _sectionTitle(context, l10n.quickActions),
          const SizedBox(height: 12),
          _ActionGrid(l10n: l10n),
          const SizedBox(height: 28),
          _sectionTitle(context, l10n.recentActivity),
          const SizedBox(height: 12),
          const _RecentCatches(),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

BoxDecoration _panelDecoration({
  Color border = AppColors.border,
  double width = 1,
}) {
  return BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: border, width: width),
  );
}

class _MembershipOverview extends StatelessWidget {
  const _MembershipOverview({required this.memberships});

  final MembershipController memberships;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = memberships.memberships;

    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: items.isEmpty
            ? Text(
                l10n.noMembershipYet,
                key: HomeScreen.membershipEmptyKey,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final membership in items) ...[
                    Text(
                      membership.pondName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      membership.isVerified
                          ? l10n.verifiedMembership
                          : l10n.demoPreview,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (membership.demoIdentifier != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.memberId}: ${membership.demoIdentifier}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (membership.isDemo) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.notVerifiedMembership,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.demoPassOnly,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ],
              ),
      ),
    );
  }
}

class _PassCard extends StatelessWidget {
  const _PassCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: HomeScreen.passKey,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 88),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.badge_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.myFishingPass,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.passCardSubtitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionHomeCard extends StatelessWidget {
  const _SessionHomeCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    if (records.loading) {
      return Text(l10n.loadingRecords);
    }
    final active = records.activeSession;
    final locale = active == null
        ? null
        : Localizations.localeOf(context).toString();

    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (active == null)
              Text(
                l10n.noSessionsYet,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else ...[
              Text(
                sessionTitle(l10n, active),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.sessionActive,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.sessionStartedAt}: ${DateFormat.yMMMd(locale).add_jm().format(active.startedAt)}',
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.sessionElapsed}: ${sessionDurationLabel(l10n, active.elapsedUntil(DateTime.now()))}',
              ),
              if (active.pondName != null) ...[
                const SizedBox(height: 4),
                Text(active.pondName!),
              ],
            ],
            const SizedBox(height: 12),
            FilledButton(
              key: Key(active == null ? 'session-start' : 'session-resume'),
              onPressed: () {
                if (active == null) {
                  openFishingSession(context);
                } else {
                  pushAppPage(
                    context,
                    SessionDetailScreen(sessionId: active.id),
                    '/session',
                  );
                }
              },
              child: Text(
                active == null ? l10n.startSession : l10n.resumeSession,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('session-history'),
              onPressed: () => openFishingHistory(context),
              child: Text(l10n.fishingHistory),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentCatches extends StatelessWidget {
  const _RecentCatches();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final items = records.catches.take(3).toList();
    if (items.isEmpty) {
      return DecoratedBox(
        key: HomeScreen.emptyCatchesKey,
        decoration: _panelDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Text(
            l10n.noCatchesYet,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final locale = Localizations.localeOf(context).toString();
    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Column(
        children: [
          for (final item in items)
            ListTile(
              title: Text(item.species),
              subtitle: Text(DateFormat.yMMMd(locale).format(item.caughtAt)),
              onTap: () {
                pushAppPage(
                  context,
                  CatchDetailScreen(catchId: item.id),
                  '/catch',
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ActionCard(
                key: HomeScreen.explorePondsKey,
                icon: Icons.water_rounded,
                title: l10n.explorePonds,
                onTap: () => showExploreTab(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                key: HomeScreen.membershipsKey,
                icon: Icons.card_membership_rounded,
                title: l10n.myMemberships,
                onTap: () {
                  pushAppPage(
                    context,
                    const MembershipsScreen(),
                    '/memberships',
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ActionCard(
                key: HomeScreen.logCatchKey,
                icon: Icons.add_rounded,
                title: l10n.logACatch,
                onTap: () {
                  pushAppPage(context, const CatchListScreen(), '/log-catch');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                key: HomeScreen.tripsKey,
                icon: Icons.route_rounded,
                title: l10n.myTrips,
                onTap: () {
                  pushAppPage(context, const TripListScreen(), '/trips');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
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
          constraints: const BoxConstraints(minHeight: 96),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
