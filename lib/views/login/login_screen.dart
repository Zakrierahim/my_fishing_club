import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/login_controller.dart';
import '../../core/auth/auth_messages.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/auth_provider_id.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/centered_scroll_view.dart';
import '../../widgets/night_fishing_background.dart';
import '../../widgets/social_sign_in_button.dart';
import '../main/main_screen.dart';
import '../register/register_screen.dart';
import 'whatsapp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const Key backgroundKey = Key('login-background');
  static const Key loginButtonKey = Key('login-button');
  static const Key emailFieldKey = Key('login-email');
  static const Key passwordFieldKey = Key('login-password');
  static const Key registerLinkKey = Key('register-link');
  static const Key authErrorKey = Key('auth-error');

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  void _openMain() {
    Navigator.of(context).pushReplacement(
      fadePageRoute(page: const MainScreen(), routeName: '/main'),
    );
  }

  void _onLogin() {
    final login = context.read<LoginController>();
    if (!login.beginLogin()) {
      return;
    }
    _openMain();
  }

  void _openRegister() {
    Navigator.of(
      context,
    ).push(fadePageRoute(page: const RegisterScreen(), routeName: '/register'));
  }

  Future<void> _onSocial(AuthProviderId provider) async {
    final auth = context.read<AuthController>();
    if (provider == AuthProviderId.whatsapp && auth.whatsappOtpConfigured) {
      auth.clearFailure();
      await Navigator.of(context).push(
        fadePageRoute(
          page: const WhatsAppVerificationScreen(),
          routeName: '/whatsapp',
        ),
      );
      return;
    }

    final attempt = await auth.signIn(provider);
    if (!mounted || attempt.ignored) {
      return;
    }
    final outcome = attempt.outcome;
    if (outcome != null && outcome.hasSession && auth.appUserId != null) {
      _openMain();
    }
  }

  String _socialLabel(AppLocalizations l10n, AuthProviderId provider) {
    return switch (provider) {
      AuthProviderId.google => l10n.continueWithGoogle,
      AuthProviderId.facebook => l10n.continueWithFacebook,
      AuthProviderId.tiktok => l10n.continueWithTikTok,
      AuthProviderId.whatsapp => l10n.continueWithWhatsApp,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<LoginController>().isSubmitting;
    final auth = context.watch<AuthController>();
    final l10n = AppLocalizations.of(context);
    final inputsLocked = isSubmitting || auth.isBusy;
    final fieldStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: NightFishingBackground(
        imageKey: LoginScreen.backgroundKey,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: CenteredScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppBrandHeader(markSize: 72),
                const SizedBox(height: 20),
                Text(
                  l10n.welcomeBack,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                for (final provider in AuthProviderId.values) ...[
                  SocialSignInButton(
                    provider: provider,
                    label: _socialLabel(l10n, provider),
                    isLoading: auth.isBusyWith(provider),
                    onPressed: inputsLocked ? null : () => _onSocial(provider),
                  ),
                  const SizedBox(height: 10),
                ],
                if (auth.failure != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        authFailureMessage(l10n, auth.failure!),
                        key: LoginScreen.authErrorKey,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                TextField(
                  key: LoginScreen.emailFieldKey,
                  enabled: !inputsLocked,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  style: fieldStyle,
                  decoration: InputDecoration(
                    hintText: l10n.email,
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: LoginScreen.passwordFieldKey,
                  enabled: !inputsLocked,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onLogin(),
                  style: fieldStyle,
                  decoration: InputDecoration(
                    hintText: l10n.password,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? l10n.showPassword
                          : l10n.hidePassword,
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: LoginScreen.loginButtonKey,
                    onPressed: inputsLocked ? null : _onLogin,
                    child: Text(l10n.login),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.newUser,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      key: LoginScreen.registerLinkKey,
                      onPressed: inputsLocked ? null : _openRegister,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                      child: Text(l10n.register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
