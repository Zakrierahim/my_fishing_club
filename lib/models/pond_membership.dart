/// How a membership may be shown. Demo previews are never verified.
enum MembershipStanding { demoPreview, verified }

/// A membership for one pond. A demo record is never treated as verified.
class PondMembership {
  const PondMembership({
    required this.id,
    required this.pondId,
    required this.pondName,
    required this.standing,
    this.membershipNumber,
    this.issuedAt,
    this.expiresAt,
    bool? isDemo,
  }) : isDemo = isDemo ?? standing == MembershipStanding.demoPreview;

  final String id;
  final String pondId;
  final String pondName;
  final String? membershipNumber;
  final MembershipStanding standing;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final bool isDemo;

  bool get isVerified => !isDemo && standing == MembershipStanding.verified;

  /// Demo identifier safe to draw as a preview code. Verified records have none.
  String? get demoIdentifier {
    final value = membershipNumber?.trim();
    if (!isDemo || value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  PondMembership copyWith({
    String? id,
    String? pondId,
    String? pondName,
    String? membershipNumber,
    MembershipStanding? standing,
    DateTime? issuedAt,
    DateTime? expiresAt,
    bool? isDemo,
  }) {
    return PondMembership(
      id: id ?? this.id,
      pondId: pondId ?? this.pondId,
      pondName: pondName ?? this.pondName,
      membershipNumber: membershipNumber ?? this.membershipNumber,
      standing: standing ?? this.standing,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}
