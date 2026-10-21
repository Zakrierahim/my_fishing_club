import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/catch_record.dart';
import '../../widgets/detail_scaffold.dart';
import 'catch_detail_screen.dart';
import 'catch_form_screen.dart';

class CatchListScreen extends StatelessWidget {
  const CatchListScreen({super.key});

  static const Key emptyKey = Key('catches-empty');
  static const Key addKey = Key('catches-add');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final items = records.catches;

    return DetailScaffold(
      title: l10n.catchLog,
      titleKey: const Key('catches-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          if (records.loadFailed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.recordsLoadFailed,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              key: addKey,
              onPressed: () {
                pushAppPage(context, const CatchFormScreen(), '/catch-form');
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addCatch),
            ),
          ),
          const SizedBox(height: 16),
          if (records.loading)
            Text(l10n.loadingRecords)
          else if (items.isEmpty)
            Text(
              l10n.noCatchesYet,
              key: emptyKey,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            for (final item in items) ...[
              _CatchTile(record: item),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _CatchTile extends StatelessWidget {
  const _CatchTile({required this.record});

  final CatchRecord record;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.yMMMd(locale).add_jm().format(record.caughtAt);

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(record.species),
        subtitle: Text(
          record.pondName == null ? when : '$when · ${record.pondName}',
        ),
        onTap: () {
          pushAppPage(context, CatchDetailScreen(catchId: record.id), '/catch');
        },
      ),
    );
  }
}
