import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/auth_controller.dart';
import 'package:my_fishing_club/controllers/linked_accounts_controller.dart';
import 'package:my_fishing_club/models/auth_outcome.dart';
import 'package:my_fishing_club/models/auth_provider_id.dart';
import 'package:my_fishing_club/models/linked_account.dart';

import '../support/fake_auth_gateway.dart';

LinkedAccount confirmed(AuthProviderId provider) {
  return LinkedAccount(
    provider: provider,
    confirmedByService: true,
    providerSubject: '${provider.name}-subject',
  );
}

void main() {
  test('linking does nothing without an application session', () async {
    final gateway = FakeAuthGateway(
      linkResult: const AuthOutcome.linked('google-subject'),
    );
    final auth = AuthController(gateway: gateway);
    final accounts = LinkedAccountsController(gateway: gateway, auth: auth);

    await accounts.link(AuthProviderId.google);

    expect(accounts.account(AuthProviderId.google).connected, isFalse);
    expect(accounts.failure, AuthFailureReason.configurationRequired);
    expect(gateway.linkCalls, 0);

    accounts.dispose();
    auth.dispose();
  });

  test('an unconfirmed link result stays disconnected', () async {
    final gateway = FakeAuthGateway(
      signInResult: const AuthOutcome.session('user-1'),
      linkResult: const AuthOutcome.linked('   '),
      linkedAccounts: const <LinkedAccount>[
        LinkedAccount(
          provider: AuthProviderId.google,
          confirmedByService: true,
          providerSubject: '',
        ),
        LinkedAccount(
          provider: AuthProviderId.facebook,
          confirmedByService: false,
          providerSubject: 'facebook-subject',
        ),
      ],
    );
    final auth = AuthController(gateway: gateway);
    final accounts = LinkedAccountsController(gateway: gateway, auth: auth);

    await auth.signIn(AuthProviderId.google);
    await accounts.load();

    expect(accounts.connectedCount, 0);

    await accounts.link(AuthProviderId.tiktok);
    expect(accounts.account(AuthProviderId.tiktok).connected, isFalse);
    expect(accounts.failure, AuthFailureReason.configurationRequired);

    accounts.dispose();
    auth.dispose();
  });

  test('a confirmed link is stored and a declined unlink is ignored', () async {
    final gateway = FakeAuthGateway(
      signInResult: const AuthOutcome.session('user-1'),
      linkResult: const AuthOutcome.linked('tiktok-subject'),
      unlinkResult: const AuthOutcome.unlinked(),
      linkedAccounts: [confirmed(AuthProviderId.google)],
    );
    final auth = AuthController(gateway: gateway);
    final accounts = LinkedAccountsController(gateway: gateway, auth: auth);

    await auth.signIn(AuthProviderId.google);
    await accounts.load();
    expect(accounts.account(AuthProviderId.google).connected, isTrue);
    expect(accounts.account(AuthProviderId.facebook).connected, isFalse);

    await accounts.link(AuthProviderId.tiktok);
    expect(accounts.account(AuthProviderId.tiktok).connected, isTrue);

    await accounts.unlink(AuthProviderId.tiktok, confirmed: false);
    expect(accounts.account(AuthProviderId.tiktok).connected, isTrue);
    expect(gateway.unlinkCalls, 0);

    accounts.dispose();
    auth.dispose();
  });

  test('the last linked provider cannot be removed', () async {
    final gateway = FakeAuthGateway(
      signInResult: const AuthOutcome.session('user-1'),
      unlinkResult: const AuthOutcome.unlinked(),
      linkedAccounts: [
        confirmed(AuthProviderId.google),
        confirmed(AuthProviderId.facebook),
      ],
    );
    final auth = AuthController(gateway: gateway);
    final accounts = LinkedAccountsController(gateway: gateway, auth: auth);

    await auth.signIn(AuthProviderId.google);
    await accounts.load();

    await accounts.unlink(AuthProviderId.facebook, confirmed: true);
    expect(accounts.account(AuthProviderId.facebook).connected, isFalse);
    expect(accounts.account(AuthProviderId.google).connected, isTrue);
    expect(gateway.unlinkCalls, 1);

    await accounts.unlink(AuthProviderId.google, confirmed: true);
    expect(accounts.account(AuthProviderId.google).connected, isTrue);
    expect(accounts.failure, AuthFailureReason.lastSignInMethod);
    expect(gateway.unlinkCalls, 1);

    auth.signOut();
    expect(accounts.connectedCount, 0);

    accounts.dispose();
    auth.dispose();
  });

  test('a second link call is ignored while one is running', () async {
    final gateway = FakeAuthGateway(
      delay: const Duration(milliseconds: 30),
      signInResult: const AuthOutcome.session('user-1'),
      linkResult: const AuthOutcome.linked('google-subject'),
    );
    final auth = AuthController(gateway: gateway);
    final accounts = LinkedAccountsController(gateway: gateway, auth: auth);

    await auth.signIn(AuthProviderId.google);
    final first = accounts.link(AuthProviderId.google);
    final second = accounts.link(AuthProviderId.facebook);
    await Future.wait([first, second]);

    expect(gateway.linkCalls, 1);
    expect(accounts.account(AuthProviderId.google).connected, isTrue);
    expect(accounts.account(AuthProviderId.facebook).connected, isFalse);

    accounts.dispose();
    auth.dispose();
  });
}
