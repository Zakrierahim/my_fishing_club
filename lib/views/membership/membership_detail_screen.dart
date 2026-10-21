import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/pond_membership.dart';
import '../../widgets/demo_membership_codes.dart';
import '../../widgets/detail_scaffold.dart';

class MembershipDetailScreen extends StatelessWidget {
  const MembershipDetailScreen({super.key, required this.membership});

  final PondMembership membership;

  static const Key standingKey = Key('membership-standing');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final standing = membership.isVerified
        ? l10n.verifiedMembership
        : l10n.demoPreview;

    return DetailScaffold(
      title: l10n.membershipDetails,
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          Text(
            membership.pondName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            standing,
            key: standingKey,
            style: TextStyle(
              color: membership.isVerified
                  ? AppColors.primary
                  : AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (membership.isDemo) ...[
            const SizedBox(height: 8),
            Text(
              l10n.notVerifiedMembership,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          if (membership.demoIdentifier != null) ...[
            const SizedBox(height: 20),
            DemoMembershipCodes(membership: membership, showPondName: false),
          ],
        ],
      ),
    );
  }
}
