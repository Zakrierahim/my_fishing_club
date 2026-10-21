import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/membership_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/pond_membership.dart';
import '../../widgets/demo_membership_codes.dart';
import '../../widgets/detail_scaffold.dart';

class FishingPassScreen extends StatelessWidget {
  const FishingPassScreen({super.key});

  static const Key emptyKey = Key('pass-empty');
  static const Key qrSlotKey = Key('pass-qr-slot');
  static const Key demoBannerKey = Key('pass-demo-banner');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final memberships = context.watch<MembershipController>().memberships;
    final hasDemo = memberships.any((item) => item.isDemo);
    final showsCodes = memberships.any((item) => item.demoIdentifier != null);

    return DetailScaffold(
      title: l10n.myFishingPass,
      titleKey: const Key('pass-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          if (memberships.isEmpty) ...[
            const Icon(
              Icons.badge_outlined,
              color: AppColors.primary,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.passEmptyTitle,
              key: emptyKey,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.passEmptyBody,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => showExploreTab(context),
              child: Text(l10n.explorePonds),
            ),
          ] else ...[
            if (hasDemo) ...[
              Text(
                l10n.demoPreview,
                key: demoBannerKey,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.demoPassBody,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.notVerifiedMembership,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
            ],
            for (final membership in memberships) ...[
              if (membership.demoIdentifier != null)
                _DemoPassCard(membership: membership)
              else
                _PassMembershipRow(membership: membership),
              const SizedBox(height: 8),
            ],
            if (!showsCodes) ...[const SizedBox(height: 16), const _QrSlot()],
            const SizedBox(height: 12),
            Text(
              l10n.checkInUnavailable,
              key: const Key('pass-check-in'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class _DemoPassCard extends StatelessWidget {
  const _DemoPassCard({required this.membership});

  final PondMembership membership;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DemoMembershipCodes(membership: membership),
      ),
    );
  }
}

class _PassMembershipRow extends StatelessWidget {
  const _PassMembershipRow({required this.membership});

  final PondMembership membership;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final standing = membership.isVerified
        ? l10n.verifiedMembership
        : l10n.demoPreview;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              membership.pondName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              standing,
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

class _QrSlot extends StatelessWidget {
  const _QrSlot();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      key: FishingPassScreen.qrSlotKey,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Text(
          l10n.qrUnavailable,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
