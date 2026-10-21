import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/confirm_delete.dart';
import '../../widgets/detail_scaffold.dart';
import 'catch_form_screen.dart';

class CatchDetailScreen extends StatelessWidget {
  const CatchDetailScreen({super.key, required this.catchId});

  final String catchId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final record = context.watch<AnglerRecordsController>().catchById(catchId);
    if (record == null) {
      return DetailScaffold(
        title: l10n.catchDetails,
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
          child: Text(l10n.recordMissing),
        ),
      );
    }

    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.yMMMd(locale).add_jm().format(record.caughtAt);
    final catalog = context.watch<PondCatalogController>();
    final pondMissing =
        record.pondId != null &&
        catalog.ponds.every((pond) => pond.id != record.pondId);

    return DetailScaffold(
      title: l10n.catchDetails,
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          if (record.photoPath != null && File(record.photoPath!).existsSync())
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(record.photoPath!),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Text(record.species, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(when, style: Theme.of(context).textTheme.bodyLarge),
          if (record.weightKg != null) ...[
            const SizedBox(height: 8),
            Text('${l10n.weightKg}: ${record.weightKg}'),
          ],
          if (record.lengthCm != null) ...[
            const SizedBox(height: 8),
            Text('${l10n.lengthCm}: ${record.lengthCm}'),
          ],
          if (record.notes != null) ...[
            const SizedBox(height: 8),
            Text(record.notes!),
          ],
          if (record.pondName != null) ...[
            const SizedBox(height: 8),
            Text(record.pondName!),
          ],
          if (pondMissing) ...[
            const SizedBox(height: 8),
            Text(l10n.pondUnavailable),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              pushAppPage(
                context,
                CatchFormScreen(existingId: record.id),
                '/catch-form',
              );
            },
            child: Text(l10n.editCatch),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final confirmed = await confirmDelete(context);
              if (!confirmed || !context.mounted) {
                return;
              }
              final removed = await context
                  .read<AnglerRecordsController>()
                  .deleteCatch(record.id);
              if (!context.mounted) {
                return;
              }
              if (removed) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.couldNotSave)));
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
