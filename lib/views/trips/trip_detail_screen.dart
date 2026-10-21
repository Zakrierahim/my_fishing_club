import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/navigation/open_session.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/trip_record.dart';
import '../../widgets/confirm_delete.dart';
import '../../widgets/detail_scaffold.dart';
import 'trip_form_screen.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final record = records.tripById(tripId);
    if (record == null) {
      return DetailScaffold(
        title: l10n.tripDetails,
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
          child: Text(l10n.recordMissing),
        ),
      );
    }

    final locale = Localizations.localeOf(context).toString();
    final start = DateFormat.yMMMd(locale).format(record.startsOn);
    final end = record.endsOn == null
        ? null
        : DateFormat.yMMMd(locale).format(record.endsOn!);
    final catalog = context.watch<PondCatalogController>();
    final pondMissing =
        record.pondId != null &&
        catalog.ponds.every((pond) => pond.id != record.pondId);

    return DetailScaffold(
      title: l10n.tripDetails,
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          Text(record.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            _statusLabel(l10n, record.status),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text('${l10n.startDate}: $start'),
          if (end != null) ...[
            const SizedBox(height: 8),
            Text('${l10n.endDate}: $end'),
          ],
          if (record.pondName != null) ...[
            const SizedBox(height: 8),
            Text(record.pondName!),
          ],
          if (pondMissing) ...[
            const SizedBox(height: 8),
            Text(l10n.pondUnavailable),
          ],
          if (record.notes != null) ...[
            const SizedBox(height: 8),
            Text(record.notes!),
          ],
          const SizedBox(height: 8),
          Text(l10n.notAReservation),
          const SizedBox(height: 20),
          if (record.status == TripStatus.planned) ...[
            FilledButton.icon(
              key: const Key('trip-start-session'),
              onPressed: () => openFishingSession(
                context,
                tripId: record.id,
                pondId: record.pondId,
              ),
              icon: const Icon(Icons.timer_outlined),
              label: Text(
                records.activeSession == null
                    ? l10n.startSession
                    : l10n.resumeSession,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (record.status != TripStatus.completed)
            FilledButton(
              onPressed: () =>
                  _setStatus(context, record, TripStatus.completed),
              child: Text(l10n.markCompleted),
            ),
          if (record.status != TripStatus.cancelled) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () =>
                  _setStatus(context, record, TripStatus.cancelled),
              child: Text(l10n.cancelTrip),
            ),
          ],
          if (record.status != TripStatus.planned) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _setStatus(context, record, TripStatus.planned),
              child: Text(l10n.reopenTrip),
            ),
          ],
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              pushAppPage(
                context,
                TripFormScreen(existingId: record.id),
                '/trip-form',
              );
            },
            child: Text(l10n.editTrip),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              final confirmed = await confirmDelete(context);
              if (!confirmed || !context.mounted) {
                return;
              }
              final removed = await context
                  .read<AnglerRecordsController>()
                  .deleteTrip(record.id);
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

  Future<void> _setStatus(
    BuildContext context,
    TripRecord record,
    TripStatus status,
  ) async {
    final saved = await context.read<AnglerRecordsController>().saveTrip(
      record.copyWith(status: status),
    );
    if (!context.mounted || saved) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).couldNotSave)),
    );
  }
}

String _statusLabel(AppLocalizations l10n, TripStatus status) {
  return switch (status) {
    TripStatus.planned => l10n.tripStatusPlanned,
    TripStatus.completed => l10n.tripStatusCompleted,
    TripStatus.cancelled => l10n.tripStatusCancelled,
  };
}
