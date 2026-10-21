import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/detail_scaffold.dart';

/// A labelled screen for a flow that does not save anything yet.
class PrototypePlaceholderScreen extends StatelessWidget {
  const PrototypePlaceholderScreen({
    super.key,
    required this.title,
    required this.routeName,
    this.messageKey,
  });

  final String title;
  final String routeName;
  final Key? messageKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DetailScaffold(
      title: title,
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          const Icon(
            Icons.construction_rounded,
            color: AppColors.primary,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.screenNotReady,
            key: messageKey,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
