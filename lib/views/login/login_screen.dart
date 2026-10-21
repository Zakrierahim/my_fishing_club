import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/login_controller.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/centered_scroll_view.dart';
import '../../widgets/night_fishing_background.dart';
import '../main/main_screen.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const Key backgroundKey = Key('login-background');
  static const Key loginButtonKey = Key('login-button');
  static const Key emailFieldKey = Key('login-email');
  static const Key passwordFieldKey = Key('login-password');
  static const Key registerLinkKey = Key('register-link');

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  void _onLogin() {
    final login = context.read<LoginController>();
    if (!login.beginLogin()) {
      return;
    }
    Navigator.of(context).pushReplacement(
      fadePageRoute(page: const MainScreen(), routeName: '/main'),
    );
  }

  void _openRegister() {
    Navigator.of(
      context,
    ).push(fadePageRoute(page: const RegisterScreen(), routeName: '/register'));
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<LoginController>().isSubmitting;
    final l10n = AppLocalizations.of(context);
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
                TextField(
                  key: LoginScreen.emailFieldKey,
                  enabled: !isSubmitting,
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
                  enabled: !isSubmitting,
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
                    onPressed: isSubmitting ? null : _onLogin,
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
                      onPressed: isSubmitting ? null : _openRegister,
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
