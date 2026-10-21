import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/linked_accounts_controller.dart';
import '../../core/auth/auth_messages.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/auth_provider_id.dart';
import '../../widgets/provider_mark.dart';

class LinkedAccountsSection extends StatelessWidget {
  const LinkedAccountsSection({super.key});

  static const Key headingKey = Key('linked-accounts-heading');
  static const Key errorKey = Key('linked-accounts-error');
  static const Key confirmKey = Key('unlink-confirm');
  static const Key cancelKey = Key('unlink-cancel');

  static Key actionKey(AuthProviderId provider) =>
      ValueKey<String>('account-action-${provider.name}');

  static Key statusKey(AuthProviderId provider) =>
      ValueKey<String>('account-status-${provider.name}');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accounts = context.watch<LinkedAccountsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.linkedAccounts,
          key: headingKey,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        for (final provider in AuthProviderId.values) ...[
          _AccountRow(provider: provider),
          if (provider != AuthProviderId.whatsapp) const SizedBox(height: 8),
        ],
        if (accounts.failure != null) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(
              authFailureMessage(l10n, accounts.failure!),
              key: errorKey,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.provider});

  final AuthProviderId provider;

  Future<void> _onAction(BuildContext context, bool connected) async {
    final accounts = context.read<LinkedAccountsController>();
    if (!connected) {
      await accounts.link(provider);
      return;
    }
    if (accounts.connectedCount <= 1) {
      await accounts.unlink(provider, confirmed: true);
      return;
    }

    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(l10n.confirmUnlink),
          content: Text(l10n.confirmUnlinkMessage(provider.label)),
          actions: [
            TextButton(
              key: LinkedAccountsSection.cancelKey,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              key: LinkedAccountsSection.confirmKey,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.unlinkAccount),
            ),
          ],
        );
      },
    );
    if (confirmed == true && context.mounted) {
      await context.read<LinkedAccountsController>().unlink(
        provider,
        confirmed: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accounts = context.watch<LinkedAccountsController>();
    final account = accounts.account(provider);
    final connected = account.connected;
    final busy = accounts.isBusyWith(provider);
    final status = connected ? l10n.connected : l10n.notConnected;
    final actionLabel = connected ? l10n.unlinkAccount : l10n.linkAccount;

    return Semantics(
      container: true,
      label: '${provider.label}, $status',
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: connected ? AppColors.primary : AppColors.border,
            width: connected ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ProviderMark(provider: provider),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.label,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          status,
                          key: LinkedAccountsSection.statusKey(provider),
                          style: TextStyle(
                            color: connected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (connected)
                    const Icon(Icons.check_rounded, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                key: LinkedAccountsSection.actionKey(provider),
                onPressed: busy ? null : () => _onAction(context, connected),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  minimumSize: const Size(64, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusButton,
                    ),
                  ),
                ),
                child: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
