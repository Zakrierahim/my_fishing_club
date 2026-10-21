import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/trip_record.dart';
import '../../widgets/detail_scaffold.dart';
import 'trip_detail_screen.dart';
import 'trip_form_screen.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  static const Key emptyKey = Key('trips-empty');
  static const Key addKey = Key('trips-add');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final items = records.trips;

    return DetailScaffold(
      title: l10n.myTrips,
      titleKey: const Key('trips-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          Text(
            l10n.notAReservation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (records.loadFailed) ...[
            const SizedBox(height: 12),
            Text(l10n.recordsLoadFailed),
          ],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              key: addKey,
              onPressed: () {
                pushAppPage(context, const TripFormScreen(), '/trip-form');
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.planATrip),
            ),
          ),
          const SizedBox(height: 16),
          if (records.loading)
            Text(l10n.loadingRecords)
          else if (items.isEmpty)
            Text(
              l10n.noTripsYet,
              key: emptyKey,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            for (final item in items) ...[
              _TripTile(record: item),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  const _TripTile({required this.record});

  final TripRecord record;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.yMMMd(locale).format(record.startsOn);

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(record.title),
        subtitle: Text(
          '${_statusLabel(l10n, record.status)} · $when'
          '${record.pondName == null ? '' : ' · ${record.pondName}'}',
        ),
        onTap: () {
          pushAppPage(context, TripDetailScreen(tripId: record.id), '/trip');
        },
      ),
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
