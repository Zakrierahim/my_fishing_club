import 'package:flutter/material.dart';

import '../../core/constants/app_tab.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/app_page_scaffold.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      title: l10n.explore,
      headingId: AppTab.explore.headingId,
    );
  }
}
