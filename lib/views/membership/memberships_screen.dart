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
import 'membership_detail_screen.dart';

class MembershipsScreen extends StatelessWidget {
  const MembershipsScreen({super.key});

  static const Key emptyKey = Key('memberships-empty');
  static const Key exploreKey = Key('memberships-explore');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final memberships = context.watch<MembershipController>().memberships;

    return DetailScaffold(
      title: l10n.myMemberships,
      titleKey: const Key('memberships-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          if (memberships.isEmpty)
            _EmptyMemberships(l10n: l10n)
          else
            for (final membership in memberships) ...[
              _MembershipTile(membership: membership),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _EmptyMemberships extends StatelessWidget {
  const _EmptyMemberships({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.card_membership_rounded,
          color: AppColors.primary,
          size: 40,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.noMembershipYet,
          key: MembershipsScreen.emptyKey,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.membershipsEmptyBody,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        FilledButton(
          key: MembershipsScreen.exploreKey,
          onPressed: () => showExploreTab(context),
          child: Text(l10n.explorePonds),
        ),
      ],
    );
  }
}

class _MembershipTile extends StatelessWidget {
  const _MembershipTile({required this.membership});

  final PondMembership membership;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final standing = membership.isVerified
        ? l10n.verifiedMembership
        : l10n.demoPreview;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          pushAppPage(
            context,
            MembershipDetailScreen(membership: membership),
            '/membership',
          );
        },
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
              if (membership.demoIdentifier != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${l10n.memberId}: ${membership.demoIdentifier}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (membership.isDemo) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.notVerifiedMembership,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.demoPassOnly,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
              if (membership.demoIdentifier != null) ...[
                const SizedBox(height: 16),
                DemoMembershipCodes(
                  membership: membership,
                  showPondName: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
