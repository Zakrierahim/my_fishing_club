import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/auth/auth_messages.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/auth_provider_id.dart';
import '../../widgets/centered_scroll_view.dart';
import '../../widgets/night_fishing_background.dart';
import '../main/main_screen.dart';

/// Collects a phone number and code for WhatsApp verification.
///
/// The screen does not create, send, or check a code. Those steps stay in
/// [AuthController], which accepts a session only from the backend.
class WhatsAppVerificationScreen extends StatefulWidget {
  const WhatsAppVerificationScreen({super.key});

  static const Key phoneKey = Key('whatsapp-phone');
  static const Key codeKey = Key('whatsapp-code');
  static const Key sendKey = Key('whatsapp-send');
  static const Key verifyKey = Key('whatsapp-verify');
  static const Key resendKey = Key('whatsapp-resend');
  static const Key errorKey = Key('whatsapp-error');

  @override
  State<WhatsAppVerificationScreen> createState() =>
      _WhatsAppVerificationScreenState();
}

class _WhatsAppVerificationScreenState
    extends State<WhatsAppVerificationScreen> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    await context.read<AuthController>().startWhatsAppVerification(_phone.text);
  }

  Future<void> _resend() async {
    await context.read<AuthController>().resendVerificationCode();
  }

  Future<void> _verify() async {
    final auth = context.read<AuthController>();
    final attempt = await auth.submitVerificationCode(_code.text);
    if (!mounted || attempt.ignored) {
      return;
    }
    final outcome = attempt.outcome;
    if (outcome != null && outcome.hasSession && auth.appUserId != null) {
      Navigator.of(context).pushReplacement(
        fadePageRoute(page: const MainScreen(), routeName: '/main'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();
    final configured = auth.whatsappOtpConfigured;
    final busy = auth.isBusy;
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: busy ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  l10n.whatsappVerificationTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.whatsappVerificationSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                TextField(
                  key: WhatsAppVerificationScreen.phoneKey,
                  controller: _phone,
                  enabled: configured && !busy,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: fieldStyle,
                  decoration: InputDecoration(hintText: l10n.phoneNumber),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: WhatsAppVerificationScreen.sendKey,
                    onPressed: configured && !busy ? _send : null,
                    child: auth.isBusyWith(AuthProviderId.whatsapp)
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textPrimary,
                            ),
                          )
                        : Text(l10n.continueWithWhatsApp),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: WhatsAppVerificationScreen.codeKey,
                  controller: _code,
                  enabled: configured && !busy,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: fieldStyle,
                  decoration: InputDecoration(hintText: l10n.verificationCode),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: WhatsAppVerificationScreen.verifyKey,
                    onPressed: configured && !busy ? _verify : null,
                    child: Text(l10n.verify),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    key: WhatsAppVerificationScreen.resendKey,
                    onPressed: configured && !busy ? _resend : null,
                    child: Text(l10n.resendCode),
                  ),
                ),
                if (!configured || auth.failure != null)
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      !configured
                          ? l10n.configurationRequired
                          : authFailureMessage(l10n, auth.failure!),
                      key: WhatsAppVerificationScreen.errorKey,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.danger),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
