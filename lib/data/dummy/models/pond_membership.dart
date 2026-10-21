import '../../../models/pond_membership.dart';

/// A fictional membership for one demo pond. It cannot be verified.
class DemoPondMembership extends PondMembership {
  const DemoPondMembership({
    required super.id,
    required super.pondId,
    required super.pondName,
    super.membershipNumber,
    super.issuedAt,
    super.expiresAt,
  }) : super(standing: MembershipStanding.demoPreview, isDemo: true);
}
