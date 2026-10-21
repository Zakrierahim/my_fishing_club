import 'package:flutter/material.dart';

import '../../core/constants/app_tab.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/app_page_scaffold.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Key emptyKey = Key('notifications-empty');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppPageScaffold(
      title: l10n.notification,
      headingId: AppTab.notification.headingId,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noNotificationsYet,
            key: emptyKey,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noNotificationsBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
