import 'package:my_fishing_club/core/auth/auth_gateway.dart';
import 'package:my_fishing_club/models/auth_outcome.dart';
import 'package:my_fishing_club/models/auth_provider_id.dart';
import 'package:my_fishing_club/models/linked_account.dart';

class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway({
    this.signInResult = const AuthOutcome.configurationRequired(),
    this.linkResult = const AuthOutcome.configurationRequired(),
    this.unlinkResult = const AuthOutcome.configurationRequired(),
    this.phoneStartResult = const AuthOutcome.configurationRequired(),
    this.codeResult = const AuthOutcome.configurationRequired(),
    this.resendResult = const AuthOutcome.configurationRequired(),
    this.linkedAccounts = const <LinkedAccount>[],
    this.delay = Duration.zero,
    this.otpConfigured = false,
    this.throwOnSignIn = false,
  });

  AuthOutcome signInResult;
  AuthOutcome linkResult;
  AuthOutcome unlinkResult;
  AuthOutcome phoneStartResult;
  AuthOutcome codeResult;
  AuthOutcome resendResult;
  List<LinkedAccount> linkedAccounts;
  Duration delay;
  bool otpConfigured;
  bool throwOnSignIn;

  int signInCalls = 0;
  int linkCalls = 0;
  int unlinkCalls = 0;
  int codeCalls = 0;

  Future<T> _pause<T>(T value) => Future<T>.delayed(delay, () => value);

  @override
  bool get whatsappOtpConfigured => otpConfigured;

  @override
  Future<AuthOutcome> signIn(AuthProviderId provider) {
    signInCalls++;
    if (throwOnSignIn) {
      return Future<AuthOutcome>.error(StateError('provider unavailable'));
    }
    return _pause(signInResult);
  }

  @override
  Future<AuthOutcome> startWhatsAppVerification(String phoneNumber) {
    return _pause(phoneStartResult);
  }

  @override
  Future<AuthOutcome> submitVerificationCode(String code) {
    codeCalls++;
    return _pause(codeResult);
  }

  @override
  Future<AuthOutcome> resendVerificationCode() {
    return _pause(resendResult);
  }

  @override
  Future<List<LinkedAccount>> loadLinkedAccounts({required String appUserId}) {
    return _pause(linkedAccounts);
  }

  @override
  Future<AuthOutcome> link({
    required AuthProviderId provider,
    required String appUserId,
  }) {
    linkCalls++;
    return _pause(linkResult);
  }

  @override
  Future<AuthOutcome> unlink({
    required AuthProviderId provider,
    required String appUserId,
  }) {
    unlinkCalls++;
    return _pause(unlinkResult);
  }
}
