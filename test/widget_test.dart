import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/app.dart';
import 'package:my_fishing_club/controllers/locale_controller.dart';
import 'package:my_fishing_club/core/constants/app_assets.dart';
import 'package:my_fishing_club/core/constants/app_constants.dart';
import 'package:my_fishing_club/core/constants/app_tab.dart';
import 'package:my_fishing_club/core/theme/app_colors.dart';
import 'package:my_fishing_club/generated/l10n/app_localizations.dart';
import 'package:my_fishing_club/models/auth_outcome.dart';
import 'package:my_fishing_club/models/auth_provider_id.dart';
import 'package:my_fishing_club/models/linked_account.dart';
import 'package:my_fishing_club/views/home/home_screen.dart';
import 'package:my_fishing_club/views/login/login_screen.dart';
import 'package:my_fishing_club/views/login/whatsapp_verification_screen.dart';
import 'package:my_fishing_club/views/register/register_screen.dart';
import 'package:my_fishing_club/views/settings/linked_accounts_section.dart';
import 'package:my_fishing_club/views/settings/settings_screen.dart';
import 'package:my_fishing_club/views/splash/splash_screen.dart';
import 'package:my_fishing_club/widgets/social_sign_in_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_auth_gateway.dart';
import 'support/tap_clear_of_nav.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations en;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
  });

  Future<void> openLogin(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const FishingApp());
    expect(find.text(en.appName), findsOneWidget);
    expect(find.byKey(SplashScreen.backgroundKey), findsOneWidget);
    expect(find.text(en.welcomeBack), findsNothing);

    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();
  }

  Future<void> openMain(WidgetTester tester) async {
    await openLogin(tester);
    await tester.ensureVisible(find.byKey(LoginScreen.loginButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LoginScreen.loginButtonKey));
    await tester.pumpAndSettle();
  }

  test('splash and home artwork are bundled', () async {
    final splash = await rootBundle.load(AppAssets.splashBackground);
    final header = await rootBundle.load(AppAssets.homeHeader);
    expect(splash.lengthInBytes, greaterThan(1000));
    expect(header.lengthInBytes, greaterThan(1000));
  });

  testWidgets('splash opens the login screen', (tester) async {
    await openLogin(tester);

    expect(find.text(en.appName), findsOneWidget);
    expect(find.text(en.welcomeBack), findsOneWidget);
    expect(find.text(en.welcomeSubtitle), findsOneWidget);
    expect(find.text(en.login), findsOneWidget);
    expect(find.text(en.newUser), findsOneWidget);
    expect(find.widgetWithText(TextButton, en.register), findsOneWidget);
    expect(find.byKey(SplashScreen.backgroundKey), findsNothing);
    expect(find.byKey(LoginScreen.backgroundKey), findsOneWidget);
    expect(find.text(en.continueWithGoogle), findsOneWidget);
    expect(find.text(en.continueWithFacebook), findsOneWidget);
    expect(find.text(en.continueWithTikTok), findsOneWidget);
    expect(find.text(en.continueWithWhatsApp), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    await tester.enterText(
      find.byKey(LoginScreen.emailFieldKey),
      'angler@example.com',
    );
    await tester.enterText(find.byKey(LoginScreen.passwordFieldKey), 'secret');
    expect(find.text('angler@example.com'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(LoginScreen.passwordFieldKey))
          .obscureText,
      isTrue,
    );

    final buttonSize = tester.getSize(find.byKey(LoginScreen.loginButtonKey));
    expect(buttonSize.height, greaterThanOrEqualTo(48));
    expect(buttonSize.width, greaterThan(300));
  });

  testWidgets('register link opens create account and can return', (
    tester,
  ) async {
    await openLogin(tester);
    await tester.ensureVisible(find.byKey(LoginScreen.registerLinkKey));
    await tester.tap(find.byKey(LoginScreen.registerLinkKey));
    await tester.pumpAndSettle();

    expect(find.text(en.createAccount), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(3));

    await tester.ensureVisible(find.byKey(RegisterScreen.loginLinkKey));
    await tester.tap(find.byKey(RegisterScreen.loginLinkKey));
    await tester.pumpAndSettle();

    expect(find.text(en.welcomeBack), findsOneWidget);
    expect(find.widgetWithText(TextButton, en.register), findsOneWidget);
  });

  testWidgets('login opens main and tabs stay on the shell', (tester) async {
    await openMain(tester);

    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsOneWidget,
    );
    expect(find.byKey(HomeScreen.headerKey), findsOneWidget);
    expect(find.text(en.welcomeBack), findsNothing);

    await tester.tap(find.byIcon(Icons.explore_rounded));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('page-heading-Explore')),
      findsOneWidget,
    );
    expect(find.text(en.welcomeBack), findsNothing);
    expect(
      tester.widget<Icon>(find.byIcon(Icons.explore_rounded)).color,
      AppColors.primary,
    );
    expect(
      tester.widget<Icon>(find.byIcon(Icons.home_rounded)).color,
      AppColors.textSecondary,
    );

    await tester.tap(find.byIcon(Icons.notifications_rounded));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('page-heading-Notification')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('page-heading-Settings')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsOneWidget,
    );
  });

  testWidgets('home dashboard lists the next actions and spots opens explore', (
    tester,
  ) async {
    await openMain(tester);

    expect(find.text(homeGreeting(en, DateTime.now().hour)), findsOneWidget);
    expect(find.text(en.homePrompt), findsOneWidget);
    expect(find.text(en.noMembershipYet), findsOneWidget);
    expect(find.text(en.myFishingPass), findsOneWidget);
    expect(find.text(en.logACatch), findsOneWidget);
    expect(find.text(en.explorePonds), findsOneWidget);
    expect(find.text(en.myMemberships), findsOneWidget);
    expect(find.text(en.myTrips), findsOneWidget);
    expect(find.text(en.noCatchesYet), findsOneWidget);
    expect(find.text(en.verifiedMembership), findsNothing);

    final logCatch = find.byKey(HomeScreen.logCatchKey);
    expect(tester.getSize(logCatch).height, greaterThanOrEqualTo(48));

    await tapClearOfNav(tester, find.byKey(HomeScreen.explorePondsKey));

    expect(
      find.byKey(const ValueKey<String>('page-heading-Explore')),
      findsOneWidget,
    );
    expect(find.text(en.noPondsYet), findsOneWidget);
  });

  testWidgets('a second login tap does not stack another main screen', (
    tester,
  ) async {
    await openLogin(tester);

    final button = tester.widget<FilledButton>(
      find.byKey(LoginScreen.loginButtonKey),
    );
    button.onPressed!.call();
    button.onPressed!.call();
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsOneWidget,
    );
    expect(find.text(en.welcomeBack), findsNothing);
    expect(find.byType(Navigator), findsOneWidget);
  });

  testWidgets('back from another tab returns to Home', (tester) async {
    await openMain(tester);
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('page-heading-Settings')),
      findsOneWidget,
    );

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await navigator.maybePop();
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('page-heading-Settings')),
      findsNothing,
    );
    expect(
      tester.widget<Icon>(find.byIcon(Icons.home_rounded)).color,
      AppColors.primary,
    );
  });

  testWidgets('login and main layout fit common device sizes', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);

    const sizes = <Size>[
      Size(320, 568),
      Size(360, 800),
      Size(390, 844),
      Size(844, 390),
      Size(768, 1024),
      Size(1024, 768),
      Size(1280, 800),
    ];

    for (final size in sizes) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      await openMain(tester);
      expect(
        find.byKey(const ValueKey<String>('page-heading-Home')),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);

      for (final tab in AppTab.values) {
        expect(find.text(tab.label(en)), findsWidgets);
      }
    }

    tester.view.physicalSize = const Size(390, 844);
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(top: 59, bottom: 34);
    await openMain(tester);
    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsOneWidget,
    );

    tester.view.physicalSize = const Size(844, 390);
    tester.view.padding = const FakeViewPadding(
      left: 47,
      right: 47,
      bottom: 21,
    );
    tester.view.viewPadding = const FakeViewPadding(
      left: 47,
      right: 47,
      bottom: 21,
    );
    await openMain(tester);
    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsOneWidget,
    );
  });

  testWidgets('Malay selection updates the UI and persists', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final ms = await AppLocalizations.delegate.load(const Locale('ms'));

    await openMain(tester);
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    expect(find.text(en.settings), findsWidgets);
    expect(find.text(en.language), findsOneWidget);

    await tester.ensureVisible(find.byKey(SettingsScreen.malayOptionKey));
    await tester.tap(find.byKey(SettingsScreen.malayOptionKey));
    await tester.pumpAndSettle();

    expect(find.text(ms.settings), findsWidgets);
    expect(find.text(ms.language), findsOneWidget);
    expect(find.text(ms.bahasaMelayu), findsOneWidget);
    expect(find.text(ms.english), findsOneWidget);
    expect(find.text(ms.home), findsOneWidget);
    expect(find.text(ms.linkedAccounts), findsOneWidget);
    expect(find.text(ms.notConnected), findsNWidgets(4));
    expect(find.text(en.settings), findsNothing);
    expect(find.text(en.welcomeBack), findsNothing);

    final restored = await LocaleController.restore();
    expect(restored.locale.languageCode, 'ms');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(FishingApp(localeController: restored));
    expect(find.text(ms.appName), findsOneWidget);
    expect(find.text(en.appName), findsNothing);
  });

  testWidgets('social sign-in stays on login when it is not configured', (
    tester,
  ) async {
    await openLogin(tester);
    final google = find.byKey(SocialSignInButton.keyFor(AuthProviderId.google));
    await tester.ensureVisible(google);
    expect(tester.getSize(google).height, greaterThanOrEqualTo(48));

    await tester.tap(google);
    await tester.pumpAndSettle();

    expect(find.text(en.configurationRequired), findsOneWidget);
    expect(find.text(en.welcomeBack), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsNothing,
    );
  });

  testWidgets('settings link does not mark a provider connected', (
    tester,
  ) async {
    await openMain(tester);
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();

    expect(find.text(en.linkedAccounts), findsOneWidget);
    expect(find.text(en.notConnected), findsNWidgets(4));
    expect(find.text(en.connected), findsNothing);

    final linkGoogle = find.byKey(
      LinkedAccountsSection.actionKey(AuthProviderId.google),
    );
    await tester.ensureVisible(linkGoogle);
    await tester.tap(linkGoogle);
    await tester.pumpAndSettle();

    expect(find.text(en.configurationRequired), findsOneWidget);
    expect(find.text(en.connected), findsNothing);
    expect(
      find.byKey(LinkedAccountsSection.statusKey(AuthProviderId.google)),
      findsOneWidget,
    );
    expect(find.text(en.notConnected), findsNWidgets(4));
  });

  testWidgets('cancelled sign-in does not open the app', (tester) async {
    final gateway = FakeAuthGateway(
      signInResult: const AuthOutcome.cancelled(),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(FishingApp(authGateway: gateway));
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    final facebook = find.byKey(
      SocialSignInButton.keyFor(AuthProviderId.facebook),
    );
    await tester.ensureVisible(facebook);
    final button = tester.widget<OutlinedButton>(facebook);
    button.onPressed!.call();
    button.onPressed!.call();
    await tester.pumpAndSettle();

    expect(gateway.signInCalls, 1);
    expect(find.text(en.authenticationCancelled), findsOneWidget);
    expect(find.text(en.welcomeBack), findsOneWidget);
  });

  testWidgets('a confirmed session shows only service-linked accounts', (
    tester,
  ) async {
    final gateway = FakeAuthGateway(
      signInResult: const AuthOutcome.session('user-1'),
      unlinkResult: const AuthOutcome.unlinked(),
      linkedAccounts: [
        const LinkedAccount(
          provider: AuthProviderId.google,
          confirmedByService: true,
          providerSubject: 'google-subject',
        ),
        const LinkedAccount(
          provider: AuthProviderId.facebook,
          confirmedByService: true,
          providerSubject: 'facebook-subject',
        ),
      ],
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(FishingApp(authGateway: gateway));
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(SocialSignInButton.keyFor(AuthProviderId.google)),
    );
    await tester.tap(
      find.byKey(SocialSignInButton.keyFor(AuthProviderId.google)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    expect(find.text(en.connected), findsNWidgets(2));
    expect(find.text(en.notConnected), findsNWidgets(2));

    final unlinkFacebook = find.byKey(
      LinkedAccountsSection.actionKey(AuthProviderId.facebook),
    );
    await tester.ensureVisible(unlinkFacebook);
    await tester.tap(unlinkFacebook);
    await tester.pumpAndSettle();
    expect(find.text(en.confirmUnlink), findsOneWidget);

    await tester.tap(find.byKey(LinkedAccountsSection.cancelKey));
    await tester.pumpAndSettle();
    expect(find.text(en.connected), findsNWidgets(2));
    expect(gateway.unlinkCalls, 0);

    await tester.tap(unlinkFacebook);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LinkedAccountsSection.confirmKey));
    await tester.pumpAndSettle();
    expect(find.text(en.connected), findsOneWidget);
    expect(gateway.unlinkCalls, 1);

    final unlinkGoogle = find.byKey(
      LinkedAccountsSection.actionKey(AuthProviderId.google),
    );
    await tester.ensureVisible(unlinkGoogle);
    await tester.tap(unlinkGoogle);
    await tester.pumpAndSettle();

    expect(find.text(en.unlinkLastMethod), findsOneWidget);
    expect(find.text(en.confirmUnlink), findsNothing);
    expect(find.text(en.connected), findsOneWidget);
    expect(gateway.unlinkCalls, 1);
  });

  testWidgets('WhatsApp verification does not accept a local code', (
    tester,
  ) async {
    final gateway = FakeAuthGateway(otpConfigured: true);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(FishingApp(authGateway: gateway));
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    final whatsapp = find.byKey(
      SocialSignInButton.keyFor(AuthProviderId.whatsapp),
    );
    await tester.ensureVisible(whatsapp);
    await tester.tap(whatsapp);
    await tester.pumpAndSettle();

    expect(find.text(en.whatsappVerificationTitle), findsOneWidget);
    expect(find.text(en.verificationCode), findsOneWidget);
    expect(find.text(en.resendCode), findsOneWidget);
    expect(gateway.signInCalls, 0);

    await tester.enterText(
      find.byKey(WhatsAppVerificationScreen.codeKey),
      '123456',
    );
    final verify = find.byKey(WhatsAppVerificationScreen.verifyKey);
    await tester.ensureVisible(verify);
    await tester.tap(verify);
    await tester.pumpAndSettle();

    expect(find.text(en.configurationRequired), findsOneWidget);
    expect(find.text(en.whatsappVerificationTitle), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('page-heading-Home')),
      findsNothing,
    );
    expect(gateway.codeCalls, 1);
  });
}
