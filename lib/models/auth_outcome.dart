/// Why a sign-in or linking attempt did not change the signed-in user.
enum AuthFailureReason {
  cancelled,
  failed,
  configurationRequired,
  lastSignInMethod,
}

/// Result from an authentication service.
///
/// Access tokens and refresh tokens are intentionally absent. The app must not
/// keep provider credentials, and a provider identity alone is not a session.
class AuthOutcome {
  const AuthOutcome._({
    this.failure,
    this.appUserId,
    this.providerSubject,
    this.sessionEstablished = false,
    this.linkConfirmed = false,
    this.unlinkConfirmed = false,
    this.otpChallengeIssued = false,
  });

  const AuthOutcome.configurationRequired()
    : this._(failure: AuthFailureReason.configurationRequired);

  const AuthOutcome.cancelled() : this._(failure: AuthFailureReason.cancelled);

  const AuthOutcome.failed() : this._(failure: AuthFailureReason.failed);

  const AuthOutcome.session(this.appUserId)
    : failure = null,
      providerSubject = null,
      sessionEstablished = true,
      linkConfirmed = false,
      unlinkConfirmed = false,
      otpChallengeIssued = false;

  const AuthOutcome.linked(this.providerSubject)
    : failure = null,
      appUserId = null,
      sessionEstablished = false,
      linkConfirmed = true,
      unlinkConfirmed = false,
      otpChallengeIssued = false;

  const AuthOutcome.unlinked()
    : failure = null,
      appUserId = null,
      providerSubject = null,
      sessionEstablished = false,
      linkConfirmed = false,
      unlinkConfirmed = true,
      otpChallengeIssued = false;

  const AuthOutcome.otpChallenge()
    : failure = null,
      appUserId = null,
      providerSubject = null,
      sessionEstablished = false,
      linkConfirmed = false,
      unlinkConfirmed = false,
      otpChallengeIssued = true;

  final AuthFailureReason? failure;
  final String? appUserId;
  final String? providerSubject;

  /// True only after the application backend has created a session.
  final bool sessionEstablished;

  /// True only after the backend has attached this provider to the app user.
  final bool linkConfirmed;

  /// True only after the backend has removed the provider link.
  final bool unlinkConfirmed;

  /// True only after a verification service has issued a one-time code.
  final bool otpChallengeIssued;

  bool get hasSession =>
      sessionEstablished && appUserId != null && appUserId!.trim().isNotEmpty;

  bool get hasConfirmedLink =>
      linkConfirmed &&
      providerSubject != null &&
      providerSubject!.trim().isNotEmpty;
}
