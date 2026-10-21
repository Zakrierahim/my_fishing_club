import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/login_controller.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/centered_scroll_view.dart';
import '../../widgets/night_fishing_background.dart';
import '../main/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const Key nameFieldKey = Key('register-name');
  static const Key emailFieldKey = Key('register-email');
  static const Key passwordFieldKey = Key('register-password');
  static const Key submitButtonKey = Key('register-submit');
  static const Key loginLinkKey = Key('register-login-link');

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;

  void _createAccount() {
    final login = context.read<LoginController>();
    if (!login.beginLogin()) {
      return;
    }
    Navigator.of(context).pushReplacement(
      fadePageRoute(page: const MainScreen(), routeName: '/main'),
    );
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
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: CenteredScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.createAccount,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.createAccountSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                TextField(
                  key: RegisterScreen.nameFieldKey,
                  enabled: !isSubmitting,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: fieldStyle,
                  decoration: InputDecoration(
                    hintText: l10n.name,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: RegisterScreen.emailFieldKey,
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
                  key: RegisterScreen.passwordFieldKey,
                  enabled: !isSubmitting,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _createAccount(),
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
                    key: RegisterScreen.submitButtonKey,
                    onPressed: isSubmitting ? null : _createAccount,
                    child: Text(l10n.createAccount),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      key: RegisterScreen.loginLinkKey,
                      onPressed: isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
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
                      child: Text(l10n.login),
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
