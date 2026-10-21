import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/auth_controller.dart';
import 'package:my_fishing_club/models/auth_outcome.dart';
import 'package:my_fishing_club/models/auth_provider_id.dart';

import '../support/fake_auth_gateway.dart';

void main() {
  test('sign-in without a backend does not create a session', () async {
    final auth = AuthController(gateway: FakeAuthGateway());

    final attempt = await auth.signIn(AuthProviderId.google);

    expect(attempt.ignored, isFalse);
    expect(attempt.outcome!.failure, AuthFailureReason.configurationRequired);
    expect(auth.appUserId, isNull);
    expect(auth.failure, AuthFailureReason.configurationRequired);
    expect(auth.isBusy, isFalse);

    auth.dispose();
  });

  test('a second sign-in call is ignored while the first is running', () async {
    final gateway = FakeAuthGateway(
      delay: const Duration(milliseconds: 30),
      signInResult: const AuthOutcome.cancelled(),
    );
    final auth = AuthController(gateway: gateway);

    final first = auth.signIn(AuthProviderId.google);
    final second = auth.signIn(AuthProviderId.facebook);
    final secondAttempt = await second;
    final firstAttempt = await first;

    expect(secondAttempt.ignored, isTrue);
    expect(firstAttempt.outcome!.failure, AuthFailureReason.cancelled);
    expect(gateway.signInCalls, 1);
    expect(auth.appUserId, isNull);
    expect(auth.failure, AuthFailureReason.cancelled);

    auth.dispose();
  });

  test('cancellation and provider errors do not create a session', () async {
    final gateway = FakeAuthGateway(
      signInResult: const AuthOutcome.cancelled(),
    );
    final auth = AuthController(gateway: gateway);

    await auth.signIn(AuthProviderId.facebook);
    expect(auth.failure, AuthFailureReason.cancelled);
    expect(auth.appUserId, isNull);

    gateway.signInResult = const AuthOutcome.failed();
    await auth.signIn(AuthProviderId.tiktok);
    expect(auth.failure, AuthFailureReason.failed);
    expect(auth.appUserId, isNull);

    gateway.throwOnSignIn = true;
    await auth.signIn(AuthProviderId.google);
    expect(auth.failure, AuthFailureReason.failed);
    expect(auth.appUserId, isNull);

    auth.dispose();
  });

  test('a backend session is kept and an empty user id is not', () async {
    final gateway = FakeAuthGateway(
      signInResult: const AuthOutcome.session('user-1'),
    );
    final auth = AuthController(gateway: gateway);

    await auth.signIn(AuthProviderId.google);
    expect(auth.appUserId, 'user-1');
    expect(auth.failure, isNull);

    gateway.signInResult = const AuthOutcome.session('   ');
    await auth.signIn(AuthProviderId.facebook);
    expect(auth.appUserId, 'user-1');
    expect(auth.failure, AuthFailureReason.failed);

    auth.signOut();
    expect(auth.appUserId, isNull);

    auth.dispose();
  });

  test('WhatsApp codes are refused until verification is configured', () async {
    final gateway = FakeAuthGateway();
    final auth = AuthController(gateway: gateway);

    final send = await auth.startWhatsAppVerification('+60123456789');
    final resend = await auth.resendVerificationCode();
    final submit = await auth.submitVerificationCode('123456');

    expect(send.outcome!.failure, AuthFailureReason.configurationRequired);
    expect(resend.outcome!.failure, AuthFailureReason.configurationRequired);
    expect(submit.outcome!.failure, AuthFailureReason.configurationRequired);
    expect(gateway.codeCalls, 0);
    expect(auth.appUserId, isNull);

    final empty = await auth.submitVerificationCode('   ');
    expect(empty.outcome!.failure, AuthFailureReason.failed);

    auth.dispose();
  });
}
