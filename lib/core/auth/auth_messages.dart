import '../../generated/l10n/app_localizations.dart';
import '../../models/auth_outcome.dart';

String authFailureMessage(AppLocalizations l10n, AuthFailureReason reason) {
  return switch (reason) {
    AuthFailureReason.cancelled => l10n.authenticationCancelled,
    AuthFailureReason.failed => l10n.authenticationFailed,
    AuthFailureReason.configurationRequired => l10n.configurationRequired,
    AuthFailureReason.lastSignInMethod => l10n.unlinkLastMethod,
  };
}
