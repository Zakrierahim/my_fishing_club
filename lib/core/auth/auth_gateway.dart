import '../../models/auth_outcome.dart';
import '../../models/auth_provider_id.dart';
import '../../models/linked_account.dart';

/// Boundary for a real authentication backend.
///
/// The shipped app uses [UnconfiguredAuthGateway]. A replacement may report a
/// session or a linked account only after its own service has verified the
/// provider. It must not embed client secrets, OTPs, or token exchange.
abstract class AuthGateway {
  /// True only when a backend can actually send a WhatsApp one-time code.
  bool get whatsappOtpConfigured;

  Future<AuthOutcome> signIn(AuthProviderId provider);

  Future<AuthOutcome> startWhatsAppVerification(String phoneNumber);

  Future<AuthOutcome> submitVerificationCode(String code);

  Future<AuthOutcome> resendVerificationCode();

  Future<List<LinkedAccount>> loadLinkedAccounts({required String appUserId});

  Future<AuthOutcome> link({
    required AuthProviderId provider,
    required String appUserId,
  });

  Future<AuthOutcome> unlink({
    required AuthProviderId provider,
    required String appUserId,
  });
}

/// Used until provider apps and a session backend are configured.
///
/// Every call refuses the operation. Nothing is stored and no account is marked
/// connected.
class UnconfiguredAuthGateway implements AuthGateway {
  const UnconfiguredAuthGateway();

  @override
  bool get whatsappOtpConfigured => false;

  @override
  Future<AuthOutcome> signIn(AuthProviderId provider) {
    return Future<AuthOutcome>.value(const AuthOutcome.configurationRequired());
  }

  @override
  Future<AuthOutcome> startWhatsAppVerification(String phoneNumber) {
    return Future<AuthOutcome>.value(const AuthOutcome.configurationRequired());
  }

  @override
  Future<AuthOutcome> submitVerificationCode(String code) {
    return Future<AuthOutcome>.value(const AuthOutcome.configurationRequired());
  }

  @override
  Future<AuthOutcome> resendVerificationCode() {
    return Future<AuthOutcome>.value(const AuthOutcome.configurationRequired());
  }

  @override
  Future<List<LinkedAccount>> loadLinkedAccounts({required String appUserId}) {
    return Future<List<LinkedAccount>>.value(const <LinkedAccount>[]);
  }

  @override
  Future<AuthOutcome> link({
    required AuthProviderId provider,
    required String appUserId,
  }) {
    return Future<AuthOutcome>.value(const AuthOutcome.configurationRequired());
  }

  @override
  Future<AuthOutcome> unlink({
    required AuthProviderId provider,
    required String appUserId,
  }) {
    return Future<AuthOutcome>.value(const AuthOutcome.configurationRequired());
  }
}
